import { TheRouter } from "../../TheRouter";
import { AnimatorUtil } from "./AnimatorUtil";
import { OpacityOption, ScaleOption, TranslateOption } from "./IAnimator";

export class TemplateService {
  static aboutToAppear(pageId: string, stackId: string, pageUrl: string, translateOption: TranslateOption,
    scaleOption: ScaleOption, opacityOption: OpacityOption, extendOption?: ESObject) {
    AnimatorUtil.registerAnimatorHandle(stackId, pageId, translateOption, scaleOption, opacityOption)
  }

  static aboutToDisappear(pageId: string, stackId: string, pageUrl: string, ndId: string) {
    TheRouter.getPathStack(stackId)?.removePage(pageId);
    AnimatorUtil.unRegisterAnimatorHandle(stackId, ndId);
  }

  static onDisAppear(pageId: string, stackId: string, pageUrl: string, ndId: string) {

  }

  static onAppear(pageId: string, stackId: string, pageUrl: string, ndId: string) {
  }

  static onShown(pageId: string, stackId: string, pageUrl: string, ndId: string) {
    const page: ESObject | undefined = TheRouter.getPathStack(stackId)?.getPage(pageId);
    if (page) {
      const onFunction: ESObject = page['onPageShow'];
      if (onFunction) {
        page.onPageShow()
      }
    }
  }

  static onHidden(pageId: string, stackId: string, pageUrl: string, ndId: string) {
    const page: ESObject | undefined = TheRouter.getPathStack(stackId)?.getPage(pageId);
    if (page) {
      const onFunction: ESObject = page['onPageHide'];
      if (onFunction) {
        page.onPageHide()
      }
    }
  }

  static onWillAppear(pageId: string, stackId: string, pageUrl: string) {
  }

  static onWillDisappear(pageId: string, stackId: string, pageUrl: string, ndId: string) {
  }

  static onWillShow(pageId: string, stackId: string, pageUrl: string, ndId: string) {
    const page: ESObject | undefined = TheRouter.getPathStack(stackId)?.getPage(pageId);
    if (page) {
      const onFunction: ESObject = page['onWillShow'];
      if (onFunction) {
        page.onWillShow()
      }
    }
  }

  static onWillHide(pageId: string, stackId: string, pageUrl: string, ndId: string) {
    const page: ESObject | undefined = TheRouter.getPathStack(stackId)?.getPage(pageId);
    if (page) {
      const onFunction: ESObject = page['onWillHide'];
      if (onFunction) {
        page.onWillHide()
      }
    }
  }

  static onReady(pageId: string, stackId: string, pageUrl: string, ndId: string, navContext: NavDestinationContext) {
    AnimatorUtil.updateHandleKey(pageId, stackId, ndId);
  }

  static onBackPressed(pageId: string, stackId: string, pageUrl: string, ndId: string): boolean {
    const page: ESObject | undefined = TheRouter.getPathStack(stackId)?.getPage(pageId);
    if (page) {
      const onBackPressFunction: ESObject = page['onBackPress'];
      if (onBackPressFunction) {
        return page.onBackPress()
      }
    }
    return false;
  }

  static interactiveStart(pageId: string, stackId: string, ndId: string, event: GestureEvent) {
    AnimatorUtil.interactiveStart(stackId, ndId, event);
  }

  static interactiveFinish(pageId: string, stackId: string, ndId: string, event: GestureEvent) {
    AnimatorUtil.interactiveFinish(stackId, ndId, event);
  }

  static interactiveProgress(pageId: string, stackId: string, ndId: string, event: GestureEvent) {
    AnimatorUtil.interactiveProgress(stackId, ndId, event);
  }

  static interactiveCancel(pageId: string, stackId: string, ndId: string) {
    AnimatorUtil.interactiveCancel(stackId, ndId);
  }
}