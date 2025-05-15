import { bundleManager, common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';
import { TheRouterConstants } from '../constants/TheRouterConstants';
import { TheRouterStack } from '../router/TheRouterStack';
import { BundleInfo } from '../router/entity/BundleInfo';

export namespace RouterUtil {
  export const BAVBAR_PAGE_NAME: string = 'TheRouter_NavBar';


  export function getBundleName(): string {
    let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT;
    let info = bundleManager.getBundleInfoForSelfSync(bundleFlags)
    return info.name
  }

  /**
   * When routing pop operations, the names of the constructed target and source pages and the location information of the routing stack
   */
  export interface PageInfo {
    name: string;
    index: number;
  }

  export function getSrcPage(pathStack: TheRouterStack): PageInfo {
    const allPath: string[] = pathStack.getAllPathName();
    const srcPageIndex = allPath.length - 1;
    const srcPage = allPath[srcPageIndex] ?? BAVBAR_PAGE_NAME;
    return {
      index: srcPageIndex,
      name: srcPage
    };
  }

  /**
   * Get target page information
   * @param pathStack
   * @param pageUrl
   * @param skipedLayerNumber
   * @returns
   */
  export function getTargetPage(pathStack: TheRouterStack, pageUrl?: string,
    skipedLayerNumber: number = 0): PageInfo | undefined {
    let allPathName = pathStack.getAllPathName();
    let targetIndex: number = -1;
    let targetName: string = '';
    if (pageUrl) {
      targetIndex = allPathName.indexOf(pageUrl);
      targetName = pageUrl;
      if (targetIndex === -1) { // Invalid pageURL parameter
        return;
      }
    } else {
      targetIndex = allPathName.length - 1 - (skipedLayerNumber + 1);
      targetName = allPathName[targetIndex];
      if (targetIndex === -1) {
        targetName = BAVBAR_PAGE_NAME;
      } else if (targetIndex < -1) { // Failed to retrieve the target page
        return;
      }
    }
    return {
      name: targetName,
      index: targetIndex
    };
  }

  export function getBundleInfoFromJson(json?: string): BundleInfo | undefined {
    try {
      if (json && json.trim().length != 0) {
        let info: BundleInfo = JSON.parse(json);
        return info;
      }
    } catch (error) {
    }
    return undefined;
  }

  export function getBundleInfoFromRawFile(context: common.Context): BundleInfo | undefined {
    try {
      let json = context.resourceManager.getRawFileContentSync(TheRouterConstants.ROUTER_MAP_FILE_NAME);
      let decoder = util.TextDecoder.create();
      let routerMapJsonStr = decoder.decodeToString(json);
      return getBundleInfoFromJson(routerMapJsonStr);
    } catch (error) {
      return undefined;
    }
  }
}