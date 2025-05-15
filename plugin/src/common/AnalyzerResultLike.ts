import BuildConfig from "../BuildConfig";
import {PluginConfig} from "../PluginConfig";

export type AnalyzerResultLike = RouterResult | ServiceResult;

export interface BaseAnalyzeResult {
  name?: string;
  module?: string;
  annotation?: string;
  pageSourceFile?: string;
  isDefaultExport?: boolean;
  routePageClassPath?: string;
}

export interface RouterResult extends BaseAnalyzeResult {
  path?: string;
  singleton?: boolean;
  launchMode?: string;
  description?: string;
  params?: string[];
}

export interface ServiceResult extends BaseAnalyzeResult {
  serviceName?: string;
  functionName?: string;
  singleton?: boolean;
  action?: string;
  priority?: number;
}

export class TemplateModel {
  pageUrl: string;
  importPath: string;
  componentName: string;
  generatorViewName: string;
  isDefaultExport?: boolean;
  aptVersion = BuildConfig.VERSION;
  groupId = '@therouter/';

  constructor(pageUrl: string, importPath: string, componentName: string, generatorViewName: string,
              isDefaultExport?: boolean, config?: PluginConfig) {
    this.isDefaultExport = isDefaultExport;
    this.pageUrl = pageUrl;
    this.importPath = importPath;
    this.componentName = componentName;
    this.generatorViewName = generatorViewName;
    if (config?.groupId) {
      if (config?.groupId == 'null') {
        this.groupId = '';
      } else {
        this.groupId = config.groupId;
      }
    }
  }
}

export class RouterInfo {
  name: string;
  pageSourceFile: string;
  buildFunction: string;
  customData: AnalyzerResultLike;

  constructor(name: string, pageSourceFile: string, buildFunction: string, data: AnalyzerResultLike = {}) {
    this.name = name;
    this.pageSourceFile = pageSourceFile;
    this.buildFunction = buildFunction;
    this.customData = data;
  }
}
