import { NavigationCallback } from "./NavigationCallback";
import { overrideRouteItem, RouteItem } from "./RouteItem";
import { RouterUtil } from "../utils/RouterUtil";
import { TheRouterStack } from "./TheRouterStack";
import { Navigator } from "./Navigator";
import { NavigatorPathFixHandle } from "./NavigatorPathFixHandle";
import { PathReplaceInterceptor } from "./PathReplaceInterceptor";
import { RouterReplaceInterceptor } from "./RouterReplaceInterceptor";
import { debug, require } from "../utils/TheRouterUtil";
import { RouterInject } from "./inject/RouterInject";
import { List } from "@kit.ArkTS";

/**
 * 路由跳转核心类，负责管理Stack和Navigator的交互
 */
export class NavigatorManager {
  private static readonly KEY_PATH = "therouter_path"
  private static instance: NavigatorManager = new NavigatorManager();
  private currentStackId: string = '';
  // stackId = stack
  private stackMap: Map<string, TheRouterStack> = new Map();
  public fixHandles: List<NavigatorPathFixHandle> = new List();
  public pathReplaceInterceptors: List<PathReplaceInterceptor> = new List();
  public routerReplaceInterceptors: List<RouterReplaceInterceptor> = new List();
  public routerInterceptor = (route: RouteItem, callback: (route: RouteItem) => void) => {
    callback(route);
  };
  public defaultCallback: NavigationCallback = {
    onResult: (routeItem: RouteItem, popInfo: PopInfo) => {
      debug('NavigationCallback::defaultCallback',
        `onResult()--${JSON.stringify(routeItem)}---${JSON.stringify(popInfo)}`);
    },
    onArrival: (navigator) => {
      debug('NavigationCallback::defaultCallback', `onArrival()-----${JSON.stringify(navigator)}`);
    },
    onLost: (navigator) => {
      debug('NavigationCallback::defaultCallback', `onLost()-----${JSON.stringify(navigator)}`);
    },
  };

  private constructor() {
  }

  public static getInstance(): NavigatorManager {
    return NavigatorManager.instance;
  }

  public createStack(stackId: string, hideNavBar: boolean, context: UIContext): TheRouterStack {
    let stack = this.stackMap.get(stackId);
    if (stack == null) {
      stack = new TheRouterStack(context, stackId, hideNavBar, (stackId: string) => {
        this.currentStackId = stackId;
      });
      this.stackMap.set(stackId, stack);
    }
    this.currentStackId = stackId;
    return stack;
  }

  public getPathStack(stackId?: string): TheRouterStack | null {
    let pathStack = this.stackMap.get(stackId || '');
    if (pathStack == null || pathStack == undefined) {
      pathStack = this.stackMap.get(this.getCurrentStackId());
      require(pathStack != null, "NavigatorManager::getPathStack", `stackMap is empty`);
      if (pathStack == null || pathStack == undefined) {
        return null;
      }
    }
    return pathStack;
  }

  public navigation(type: NavigationOperation, navigator: Navigator, ncb?: NavigationCallback): void {
    debug("NavigatorManager::navigation", `begin navigate ${navigator.getSimpleUrl()}`);
    const callback = ncb || this.defaultCallback;
    let matchUrl = navigator.getSimpleUrl();
    for (const interceptor of this.pathReplaceInterceptors) {
      if (interceptor.watch(matchUrl)) {
        const temp = matchUrl;
        matchUrl = interceptor.replace(matchUrl);
        debug("NavigatorManager::navigation", `${temp} replace to ${matchUrl}`);
      }
    }
    const match = RouterInject.getInstance().matchRouteMap(matchUrl);
    if (match) {
      let routeItem: RouteItem | null = null;
      // 用当前导航覆盖路由表默认数据
      routeItem = overrideRouteItem(match, navigator.toRouteItem());
      if (routeItem) {
        routeItem.param[NavigatorManager.KEY_PATH] = navigator.getSimpleUrl();
      }
      debug("NavigatorManager::navigation", `match route ${JSON.stringify(routeItem)}`);
      for (const interceptor of this.routerReplaceInterceptors) {
        if (interceptor) {
          if (interceptor.watch(routeItem)) {
            routeItem = interceptor.replace(routeItem);
            if (!routeItem) {
              debug("NavigatorManager::navigation", `route replace to ${routeItem}`);
            }
          }
        }
      }
      if (routeItem) {
        debug("NavigatorManager::navigation", "NavigationCallback on found");
        this.routerInterceptor(routeItem, (match) => {
          const stack = this.getPathStack(match.stackId);
          if (stack) {
            stack.navigation(type, match, callback.onResult);
            callback?.onArrival?.(navigator);
          }
        });
      } else {
        callback?.onLost?.(navigator);
      }
    } else {
      callback?.onLost?.(navigator);
    }
  }

  public pop(routeItem?: RouteItem, skipedLayerNumber?: number): void {
    const pathStack = this.getPathStack(routeItem?.stackId);
    if (!pathStack) {
      return;
    }
    const targetPageInfo = RouterUtil.getTargetPage(pathStack, routeItem?.path, skipedLayerNumber);
    routeItem = routeItem || {
      stackId: pathStack.stackId,
      path: targetPageInfo?.name
    };
    routeItem.path = routeItem?.path ?? targetPageInfo?.name;
    pathStack.popPage(routeItem, targetPageInfo);
  }

  public deletePathStack(pathStack: TheRouterStack): void {
    for (let iter of this.stackMap) {
      if (iter[1] === pathStack) {
        this.stackMap.delete(iter[0]);
        break;
      }
    }
    if (this.currentStackId === pathStack.stackId) {
      this.currentStackId = '';
      this.currentStackId = this.getCurrentStackId();
    }
  }

  public getCurrentParam(stackId?: string): ESObject {
    let params: ESObject = {};
    let pathStack = this.getPathStack(stackId);
    if (!pathStack) {
      return params;
    }
    const allPath = pathStack.getAllPathName();
    params = pathStack.getParamByIndex(allPath.length - 1) as ESObject;
    return params;
  }

  private getCurrentStackId(): string {
    let currentStackId = this.currentStackId;
    if (!this.currentStackId) {
      this.stackMap.forEach((v, key) => {
        currentStackId = key;
      });
    }
    return currentStackId;
  }
}