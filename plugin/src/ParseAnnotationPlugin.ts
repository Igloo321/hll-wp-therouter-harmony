import micromatch from 'micromatch';
import ejs from 'ejs';
import {
  AnalyzerResultLike,
  RouterResult,
  ServiceResult,
  RouterInfo,
  TemplateModel
} from './common/AnalyzerResultLike';
import {Logger} from './common/Logger';
import PluginConstant from './constants/PluginConstant';
import TheRouterFileUtil from './utils/FileUtil';
import {StringUtil} from './utils/StringUtil';
import {CustomPageTemplateImpl, PluginConfig} from './PluginConfig';
import {Parser} from './Parser';

export class ParseAnnotationPlugin {
  config: PluginConfig;
  routerMap: RouterInfo[] = [];
  scanFiles: string[] = [];
  private parser: Parser;

  constructor(config: PluginConfig) {
    this.config = config;
    this.parser = new Parser(config);
  }

  public analyzeAnnotation() {
    this.config.scanDir.forEach((dir) => {
      const scanPath = this.config.getScanPath(dir);
      this.deepScan(scanPath, '');
    });
    Logger.info(`Scanned ${this.scanFiles.length} files`, this.scanFiles);
    this.scanFiles.forEach((filePath) => {
      if (filePath.endsWith(PluginConstant.ETS_SUFFIX)) {
        this.parser.analyzeFile(filePath);
      }
    });
    this.parser.getAnalyzeResultSet().forEach((analyzerResult) => {
      this.pushRouterInfo(analyzerResult);
    });
  }

  public generateRouterMap() {
    let routerMap = {
      routerMap: this.routerMap.map((item) => {
        if (item.customData && item.customData.annotation) {
          delete item.customData.annotation;
          delete item.customData.pageSourceFile;
          delete item.customData.isDefaultExport;
        }
        return item;
      })
    };

    const routerMapJsonStr = JSON.stringify(routerMap, null, 2);
    const routerMapFilePath = this.config.getRouterMapDir();
    TheRouterFileUtil.ensureFileSync(routerMapFilePath);
    TheRouterFileUtil.writeFileSync(routerMapFilePath, routerMapJsonStr);
    Logger.info(`${this.config.moduleName} module ${PluginConstant.ROUTER_MAP_NAME} has been generated in ${routerMapFilePath}`);
    this.parser.clearAnalyzeResultSet();
  }

  private matchedPath(filePath: string, customPageTemplate: CustomPageTemplateImpl[], defaultTplFilePath: string): string {
    for (const template of customPageTemplate) {
      if (micromatch.isMatch(filePath, template.srcPath)) {
        return TheRouterFileUtil.pathResolve(this.config.configDir, template.templatePath);
      }
    }
    return defaultTplFilePath;
  }

  private pushRouterInfo(analyzeResult: AnalyzerResultLike) {
    let pageSourceFile = this.config
      .getRelativeSourcePath(analyzeResult.pageSourceFile!)
      .replaceAll(PluginConstant.FILE_SEPARATOR, PluginConstant.DELIMITER);
    switch (analyzeResult.annotation) {
      case PluginConstant.ROUTER_ANNOTATION:
        let generatorFilePath = this.generateBuilder(
          analyzeResult,
          pageSourceFile,
          this.matchedPath(pageSourceFile, this.config.customPageTemplate, this.config.getDefaultTplFilePath())
        );
        let pageUrl = (analyzeResult as RouterResult).path || '';
        Logger.info(`${pageUrl} => ${generatorFilePath}`);
        this.routerMap.forEach((item) => {
          if (item.name == pageUrl) {
            throw new Error(`Multiple Page to single Url ${pageUrl} => ${generatorFilePath} and ${item.pageSourceFile}.`);
          }
        });
        this.routerMap.push(new RouterInfo(pageUrl, generatorFilePath, analyzeResult.name + 'Builder', analyzeResult));
        break;
      case PluginConstant.ACTION_ANNOTATION:
        let action = this.routerMap.length + PluginConstant.ACTION_PREFIX + (analyzeResult as ServiceResult).action;
        Logger.info(`${action} => ${pageSourceFile}`);
        this.routerMap.push(new RouterInfo(action, pageSourceFile, '', analyzeResult));
        break;
      case PluginConstant.SERVICE_PROVIDE_ANNOTATION:
        let className = PluginConstant.SERVICE_PROVIDE_PREFIX + (analyzeResult as ServiceResult).serviceName;
        Logger.info(`${className} => ${pageSourceFile}`);
        this.routerMap.forEach((item) => {
          if (item.name == className) {
            throw new Error(`Multiple ServiceProvider to single name ${className} => ${pageSourceFile} and ${item.pageSourceFile}.`);
          }
        });
        this.routerMap.push(new RouterInfo(className, pageSourceFile, '', analyzeResult));
        break;
    }
  }

  private generateBuilder(analyzeResult: RouterResult, pageSourceFile: string, tempFilePath: string) {
    let importPath = this.config
      .getRelativeBuilderPath(pageSourceFile)
      .replaceAll(PluginConstant.FILE_SEPARATOR, PluginConstant.DELIMITER)
      .replaceAll(PluginConstant.ETS_SUFFIX, '');
    let generatorViewName =
      PluginConstant.VIEW_NAME_PREFIX +
      analyzeResult.name +
      StringUtil.stringToHashCode(analyzeResult.path!);
    const templateModel: TemplateModel = new TemplateModel(
      analyzeResult.path || '',
      importPath,
      analyzeResult.name!,
      generatorViewName,
      analyzeResult.isDefaultExport,
      this.config
    );
    // create template string
    if (!TheRouterFileUtil.exist(tempFilePath)) {
      throw new Error('Invalid template path: ' + tempFilePath);
    }
    const tpl = TheRouterFileUtil.readFileSync(tempFilePath).toString();
    const templateStr = ejs.render(tpl, templateModel);
    // generate file path
    const generatorFilePath = this.config.getGeneratedFilePath(templateModel.generatorViewName);
    TheRouterFileUtil.ensureFileSync(generatorFilePath);
    TheRouterFileUtil.writeFileSync(generatorFilePath, templateStr);
    // Return the generated file path and component name
    return this.config
      .getBuilderFilePath(templateModel.generatorViewName)
      .replaceAll(PluginConstant.FILE_SEPARATOR, PluginConstant.DELIMITER);
  }

  private deepScan(scanPath: string, filePath: string) {
    let resolvePath = TheRouterFileUtil.pathResolve(scanPath, filePath);
    if (!TheRouterFileUtil.exist(resolvePath)) {
      return;
    }
    if (TheRouterFileUtil.isDictionary(resolvePath)) {
      const files: string[] = TheRouterFileUtil.readdirSync(resolvePath);
      files.forEach((file) => {
        this.deepScan(resolvePath, file);
      });
    } else {
      this.scanFiles.push(resolvePath);
    }
  }
}
