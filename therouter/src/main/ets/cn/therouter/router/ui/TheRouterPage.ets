import { AttributeUpdater } from '@kit.ArkUI';
import { TheRouterStack } from '../TheRouterStack';
import { NavigatorManager } from '../NavigatorManager';
import { TheRouter } from '../../TheRouter';
import { RouterInject } from '../inject/RouterInject';
import { CustomTransition } from './CustomTransition';
import { IAnimator } from './IAnimator';

@Component
export struct TheRouterPage {
  @Require stackId: string = '';
  @State navigationEnable: boolean = true;
  root?: string;
  modifier?: AttributeUpdater<NavigationAttribute>;
  title?: NavTitle;
  menus?: Array<NavigationMenuItem> | WrappedBuilder<[]>;
  toolbar?: Array<ToolbarItem> | WrappedBuilder<[]>;
  toolbarOptions?: NavigationToolbarOptions;
  onTitleModeChange?: (titleMode: NavigationTitleMode) => void;
  onNavBarStateChange?: (isVisible: boolean) => void;
  onNavigationModeChange?: (mode: NavigationMode) => void;
  defaultAnimator?: IAnimator;
  private routerInject: RouterInject = RouterInject.getInstance();
  @BuilderParam closer: () => void = this.closerBuilder;
  private stack?: TheRouterStack;
  private hideNavbar?: boolean;
  private pageBuilder?: WrappedBuilder<ESObject[]>;
  private customTransition?: CustomTransition;

  @Builder
  closerBuilder() {
  }

  getPageBuilder(path: string): boolean {
    this.pageBuilder = this.routerInject.getBuilderByPath(path);
    return !!this.pageBuilder?.builder;
  }

  @Builder
  pageMap(path: string, arg: ESObject) {
    if (this.getPageBuilder(path)) {
      if (this.pageBuilder?.builder.length === 2) {
        this.pageBuilder?.builder(path, arg);
      } else if (this.pageBuilder?.builder.length === 1) {
        this.pageBuilder?.builder(path);
      } else {
        this.pageBuilder?.builder();
      }
    }
  }

  aboutToAppear(): void {
    if (this.closer === this.closerBuilder) {
      this.hideNavbar = true;
    } else {
      this.hideNavbar = false;
    }
    this.stack = NavigatorManager.getInstance().createStack(this.stackId, this.hideNavbar, this.getUIContext());
    this.stack.setDefaultAnimator(this.defaultAnimator);
    this.customTransition = new CustomTransition(this.stackId, this.hideNavbar);
  }

  onDidBuild(): void {
  }

  aboutToDisappear(): void {
    NavigatorManager.getInstance().deletePathStack(this.stack!);
  }

  build() {
    Navigation(this.stack) {
      this.closer();
    }
    .id(this.stackId)
    .hideNavBar(this.hideNavbar)
    .enabled(this.navigationEnable)
    .attributeModifier(this.modifier)
    .title(this.title?.titleValue instanceof WrappedBuilder ?
    this.title.titleValue.builder :
      this.title?.titleValue,
      this.title?.titleOptions)
    .menus(this.menus instanceof WrappedBuilder ? this.menus.builder : this.menus)
    .toolbarConfiguration(this.toolbar instanceof WrappedBuilder ? this.toolbar.builder : this.toolbar)
    .navDestination(this.pageMap)
    .onTitleModeChange(this.onTitleModeChange)
    .onNavBarStateChange(this.onNavBarStateChange)
    .onNavigationModeChange(this.onNavigationModeChange)
    .customNavContentTransition((from: NavContentInfo, to: NavContentInfo, operation: NavigationOperation) => {
      const transition = this.customTransition?.getCustomAnimation(from, to, operation);
      if (transition?.isInteractive) {
        this.navigationEnable = false;
        const transitionEndCallback = transition.onTransitionEnd;
        transition.onTransitionEnd = (success: boolean) => {
          transitionEndCallback?.(success);
          this.navigationEnable = true;
        };
      }
      return transition;
    })
    .onAppear(() => {
      if (this.root) {
        TheRouter.build(this.root).withStackId(this.stackId).navigation();
      }
    })
  }
}

interface NavTitle {
  titleValue: ResourceStr | WrappedBuilder<[]> | NavigationCommonTitle | NavigationCustomTitle;
  titleOptions?: NavigationTitleOptions;
}