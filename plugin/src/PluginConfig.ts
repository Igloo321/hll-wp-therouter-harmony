import path from 'path';
import TheRouterFileUtil from './utils/FileUtil';
import PluginConstant from './constants/PluginConstant';

export class PluginConfig {
  moduleName: string;
  modulePath: string;
  configDir: string;
  scanDir: string[];
  routerMapDir: string;
  builderDir: string;
  annotation: string[];
  defaultPageTemplate: string;
  customPageTemplate: CustomPageTemplateImpl[];
  saveGeneratedFile: boolean;
  autoObfuscation: boolean;
  groupId?: string;

  constructor(moduleName: string, modulePath: string, configDir: string, param: PluginConfigParam) {
    this.moduleName = moduleName;
    this.modulePath = modulePath;
    this.configDir = configDir;
    this.scanDir = param.scanDir ? [...new Set(param.scanDir)] : [PluginConstant.DEFAULT_SCAN_DIR];
    this.routerMapDir = param.routerMapDir ? param.routerMapDir : PluginConstant.DEFAULT_ROUTER_MAP_DIR;
    this.builderDir = param.builderDir ? param.builderDir : PluginConstant.DEFAULT_BUILD_DIR;
    this.annotation = [
      PluginConstant.ROUTER_ANNOTATION,
      PluginConstant.ACTION_ANNOTATION,
      PluginConstant.SERVICE_PROVIDE_ANNOTATION
    ];
    this.defaultPageTemplate =
      param.defaultPageTemplate ? param.defaultPageTemplate : PluginConstant.DEFAULT_BUILD_TPL;
    this.customPageTemplate = param.customPageTemplate ? param.customPageTemplate : [];
    this.saveGeneratedFile = !!param.saveGeneratedFile;
    this.autoObfuscation = !!param.autoObfuscation;
    this.groupId = param.groupId;
  }

  getScanPath(dir: string) {
    return TheRouterFileUtil.pathResolve(this.modulePath, dir);
  }

  getRelativeSourcePath(filePath: string) {
    return path.relative(this.modulePath, filePath);
  }

  getRelativeBuilderPath(filePath: string) {
    return path.relative(this.builderDir, filePath);
  }

  getGeneratedFilePath(generatorViewName: string) {
    return TheRouterFileUtil.pathResolve(
      this.modulePath,
      this.builderDir,
      generatorViewName + PluginConstant.ETS_SUFFIX
    );
  }

  getBuilderDir() {
    return TheRouterFileUtil.pathResolve(this.modulePath, this.builderDir);
  }

  getBuilderFilePath(generatorViewName: string) {
    return path.join(this.builderDir, generatorViewName + PluginConstant.ETS_SUFFIX);
  }

  getRouterMapDir() {
    return TheRouterFileUtil.pathResolve(this.modulePath, this.routerMapDir, PluginConstant.ROUTER_MAP_NAME);
  }

  getModuleRouterMapFilePath(routerMapFileName: string) {
    return TheRouterFileUtil.pathResolve(
      this.modulePath,
      this.routerMapDir,
      routerMapFileName + PluginConstant.JSON_SUFFIX
    );
  }

  getRawFilePath() {
    return TheRouterFileUtil.pathResolve(this.modulePath, PluginConstant.RAWFILE_DIR);
  }

  getDefaultTplFilePath() {
    let templateFilePath = TheRouterFileUtil.pathResolve(this.configDir, this.defaultPageTemplate);
    if (TheRouterFileUtil.exist(templateFilePath)) {
      return templateFilePath;
    }
    return TheRouterFileUtil.pathResolve(__dirname, PluginConstant.PARENT_DELIMITER + this.defaultPageTemplate);
  }

  getObfuscationFilePath() {
    return TheRouterFileUtil.pathResolve(this.modulePath, PluginConstant.OBFUSCATION_FILE_NAME);
  }

  getConsumerRulesFilePath() {
    return TheRouterFileUtil.pathResolve(this.modulePath, PluginConstant.CONSUMER_FILE_NAME);
  }
}

export interface PluginConfigParam {
  scanDir?: string[];
  routerMapDir?: string;
  builderDir?: string;
  autoObfuscation?: boolean;
  saveGeneratedFile?: boolean;
  defaultPageTemplate?: string;
  customPageTemplate?: CustomPageTemplateImpl[];
  groupId?: string;
}

export interface CustomPageTemplateImpl {
  srcPath: string[];
  templatePath: string;
}
