import { TheRouterConstants } from '../../constants/TheRouterConstants';
import { ImportUtil } from '../../utils/ImportUtil';
import { RouteItem } from '../RouteItem';
import { TheRouter } from '../../TheRouter';

export class BundleInfo {
  routerMap: BundleItem[] = [];
  hspModuleNames: Set<string> = new Set();
}

export function bundleInfoAddRouterMap(base: BundleInfo, info?: BundleInfo) {
  if (info) {
    base.routerMap.push(...info.routerMap)
  }
}

export class BundleItem {
  /**
   * name
   */
  name: string = '';
  /**
   * pageSourceFile
   */
  pageSourceFile: string = '';
  /**
   * buildFunction
   */
  buildFunction: string = '';
  /**
   * customData
   */
  customData: ESObject;
  /**
   * moduleName,eg:entry
   */
  moduleName: string = '';
  /**
   * ohmurl,eg:@normalized:N&&&entry/src/main/ets/animation/CustomPageAnimator&
   */
  ohmurl: string = '';

  public getClassName(): string {
    return this.customData[TheRouterConstants.THEROUTER_ANNOTATION_NAME];
  }

  public importComponent<T>(): T | undefined {
    let modulePath: string | undefined = ImportUtil.getModuleInfoFromOhmUrl(this.ohmurl);
    if (!modulePath) {
      return undefined;
    }
    let moduleInfo = TheRouter.bundleName + TheRouterConstants.MODULE_INFO_SEPARATOR + this.moduleName;
    return ImportUtil.nativeImport<T>(modulePath, moduleInfo,
      this.customData[TheRouterConstants.THEROUTER_ANNOTATION_NAME]);
  }
}

export function bundleToRouteItem(item: BundleItem): RouteItem {
  let routeItem: RouteItem = {
    path: item.name,
    stackId: '',
    param: {},
    launchMode: '',
    animator: undefined,
    buildFunction: item.buildFunction,
    classPath: item.pageSourceFile,
    moduleName: item.moduleName,
    ohmurl: item?.ohmurl
  };
  if (item.customData) {
    routeItem.launchMode = item.customData[TheRouterConstants.THEROUTER_PAGE_LAUNCHMODE];
    routeItem.routePageClassName = item.customData[TheRouterConstants.THEROUTER_ANNOTATION_NAME];
    routeItem.routePageClassPath = item.customData[TheRouterConstants.THEROUTER_PAGE_CLASSPATH];
    const defaultParams: string[] = item.customData[TheRouterConstants.THEROUTER_PAGE_PARAMS];
    if (defaultParams && defaultParams.length % 2 == 0) {
      for (let i = 0; i < defaultParams.length; i += 2) {
        routeItem.param[defaultParams[i]] = defaultParams[i+1]
      }
    }
  }
  return routeItem;
}