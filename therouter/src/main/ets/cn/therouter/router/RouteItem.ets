import { TheRouterConstants } from '../constants/TheRouterConstants';
import { TheRouter } from '../TheRouter';
import { ImportUtil } from '../utils/ImportUtil';
import { deepClone } from '../utils/TheRouterUtil';
import { Navigator, toLaunchMode } from './Navigator';

export interface RouteItem {
  stackId?: string;
  path?: string;
  param?: ESObject;
  launchMode?: string;
  animator?: boolean;
  buildFunction?: string;
  routePageClassPath?: string;
  routePageClassName?: string;
  classPath?: string;
  moduleName?: string;
  ohmurl?: string;
}

export function overrideRouteItem(base?: RouteItem, newRoute?: RouteItem): RouteItem | null {
  if (!base && !newRoute) {
    return null
  }
  if (!base && newRoute) {
    return newRoute;
  }
  if (base && !newRoute) {
    return base;
  }

  const routeItem: RouteItem = deepClone(base)
  // 鸿蒙是静态路由，这里不能覆盖path
  // if (newRoute?.path) {
  //   routeItem.path = newRoute?.path;
  // }
  if (newRoute?.param) {
    if (!routeItem.param) {
      routeItem.param = newRoute.param;
    } else {
      for (const k of Object.keys(newRoute.param)) {
        routeItem.param[k] = newRoute.param[k];
      }
    }
  }
  if (newRoute?.launchMode) {
    routeItem.launchMode = newRoute?.launchMode;
  }
  if (newRoute?.animator != undefined) {
    routeItem.animator = newRoute?.animator;
  }
  if (newRoute?.buildFunction) {
    routeItem.buildFunction = newRoute?.buildFunction;
  }
  if (newRoute?.routePageClassName) {
    routeItem.routePageClassName = newRoute?.routePageClassName;
  }
  if (newRoute?.routePageClassPath) {
    routeItem.routePageClassPath = newRoute?.routePageClassPath;
  }
  if (newRoute?.classPath) {
    routeItem.classPath = newRoute?.classPath;
  }
  if (newRoute?.moduleName) {
    routeItem.moduleName = newRoute?.moduleName;
  }
  if (newRoute?.ohmurl) {
    routeItem.ohmurl = newRoute?.ohmurl;
  }
  return routeItem;
}

export function toNavigator(routeItem: RouteItem): Navigator {
  const navigator = new Navigator(routeItem.path)
    .withStackId(routeItem.stackId)
    .with(routeItem.param)
    .withLaunchMode(toLaunchMode(routeItem.launchMode))
    .withAnimation(routeItem.animator);

  return navigator;
}

export function importWrappedBuilder<T>(item: RouteItem): T | undefined {
  if (item.ohmurl) {
    let modulePath: string | undefined = ImportUtil.getModuleInfoFromOhmUrl(item.ohmurl);
    if (!modulePath) {
      return undefined;
    }

    let moduleInfo = TheRouter.bundleName + TheRouterConstants.MODULE_INFO_SEPARATOR + item.moduleName;
    return ImportUtil.nativeImportFunction<T>(modulePath, moduleInfo, item.buildFunction + 'WrapBuilder');
  }
  return undefined;
}
