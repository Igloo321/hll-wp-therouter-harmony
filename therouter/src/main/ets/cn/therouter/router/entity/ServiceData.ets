import { TheRouterConstants } from "../../constants/TheRouterConstants";
import { BundleItem } from "./BundleInfo";

export class ServiceData extends BundleItem {
  /**
   * 服务名称 serviceName
   */
  serviceName: string = '';
  /**
   * 函数名称 functionName
   */
  functionName: string = '';
  /**
   * 是否单例
   */
  singleton?: boolean;
  /**
   * 数字越大，优先级越高
   */
  priority?: number;

  constructor(item: BundleItem) {
    super();
    this.name = item.name;
    this.pageSourceFile = item.pageSourceFile;
    this.buildFunction = item.buildFunction;
    this.customData = item.customData;
    this.moduleName = item.moduleName;
    this.ohmurl = item.ohmurl;
    this.serviceName = item.customData[TheRouterConstants.THEROUTER_SERVICE_NAME] ||
    item.customData[TheRouterConstants.THEROUTER_ACTION] || '';
    this.functionName = item.customData[TheRouterConstants.THEROUTER_SERVICE_FUNCTION] || '';
    this.singleton = item.customData[TheRouterConstants.THEROUTER_SERVICE_SINGLETON] || '';
    this.priority = item.customData[TheRouterConstants.THEROUTER_ACTION_PRIORITY] || 5
  }
}