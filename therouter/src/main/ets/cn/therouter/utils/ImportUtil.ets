import TheRouterNapi from 'libtherouter.so';

/**
 * Dynamic import util
 */
export class ImportUtil {
  private static readonly OHM_URL_FIRST_SEPARATOR = '&&&';
  private static readonly OHM_URL_SECOND_SEPARATOR = '&';

  /**
   * Retrieve the content of ohmUrl
   * eg:@normalized:N&&&entry/src/main/ets/component/live/LiveHome&
   *    =>entry/src/main/ets/component/live/LiveHome
   * @param ohmUrl
   */
  public static getModuleInfoFromOhmUrl(ohmUrl: string): string | undefined {
    let splitRes = ohmUrl.split(ImportUtil.OHM_URL_FIRST_SEPARATOR);
    if (splitRes.length < 2) {
      return undefined;
    }
    let res = splitRes[1].split(ImportUtil.OHM_URL_SECOND_SEPARATOR);
    return res[0];
  }

  /**
   * dynamic import from native,use napi_load_module_with_info
   * @param module module
   * @param path path
   * @param moduleInfo bundleName/moduleName,eg:cn.therouter/entry
   * @param className clazzName
   * @returns
   */
  public static nativeImport<T>(modulePath: string, moduleInfo: string, className: string): T | undefined {
    try {
      let res: ESObject = TheRouterNapi.loadModule(modulePath, moduleInfo);
      return new res[className]();
    } catch (error) {
      return undefined;
    }
  }

  /**
   * dynamic import from native,use napi_load_module_with_info
   * @param module module
   * @param path path
   * @param moduleInfo bundleName/moduleName,eg:cn.therouter/entry
   * @param functionName functionName
   * @returns
   */
  public static nativeImportFunction<T>(modulePath: string, moduleInfo: string, functionName: string): T | undefined {
    try {
      let res: ESObject = TheRouterNapi.loadModule(modulePath, moduleInfo);
      return res[functionName];
    } catch (error) {
      return undefined;
    }
  }
}