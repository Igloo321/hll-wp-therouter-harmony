import {ServiceResult, RouterInfo} from '../common/AnalyzerResultLike'
import PluginConstant from '../constants/PluginConstant'

export default class ObfuscationUtil {
  static buildObfuscatedStrings(routerMap: RouterInfo[]) {
    let srcPathArr = [...new Set(routerMap.map((routerInfo) => {
      return PluginConstant.CURRENT_DELIMITER + routerInfo.pageSourceFile!
    }))]
    let classNameArr = [...new Set(routerMap.filter((routerInfo) => {
      return routerInfo.name.includes('__')
    }).map((routerInfo) => {
      return routerInfo.customData.name!
    }))]
    let functionName = [...new Set(routerMap.filter((routerInfo) => {
      return routerInfo.name.includes(PluginConstant.ACTION_PREFIX)
    }).map((routerInfo) => {
      return (routerInfo.customData as ServiceResult).functionName!
    }))]
    let watchFunctionName = [...new Set(routerMap.filter((routerInfo) => {
      return routerInfo.buildFunction
    }).map((routerInfo) => {
      return routerInfo.buildFunction + PluginConstant.WARP_BUILDER
    }))]
    return PluginConstant.KEEP_FILE_NAME + PluginConstant.LINE_BREAK +
      srcPathArr.concat(PluginConstant.KEEP_PROPERTY_NAME, functionName)
        .concat(PluginConstant.KEEP_GLOBAL_NAME, classNameArr, watchFunctionName)
        .join(PluginConstant.LINE_BREAK)
  }
};
