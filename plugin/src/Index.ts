import {hvigor, HvigorNode, HvigorPlugin} from '@ohos/hvigor';
import {OhosHapContext, OhosHarContext, OhosHspContext, OhosPluginId} from '@ohos/hvigor-ohos-plugin';
import {Logger, PluginError} from './common/Logger';
import PluginConstant from './constants/PluginConstant';
import {TsAstUtil} from './utils/TsAstUtil';
import TheRouterFileUtil from './utils/FileUtil';
import {ModuleHandle} from './ModuleHandle';
import PluginStore from './store/PluginStore'

class Index {
  moduleHandleSet: Set<ModuleHandle> = new Set();

  constructor() {
    hvigor.nodesEvaluated(() => {
      this.moduleHandleSet.forEach((handle) => {
        handle.start();
      });
    });
    hvigor.buildFinished(() => {
      Logger.info(`buildFinished, Start cleaning project！`);
      this.moduleHandleSet.forEach((handle) => {
        if (handle.config.saveGeneratedFile) {
          Logger.info(handle.config.moduleName + ' saveGeneratedFile is true, skip deleting.');
          return;
        }
        this.deleteRouterMapFile(handle);
        this.deleteRawFile(handle);
        this.deleteGeneratorFile(handle);
        if (handle.config.autoObfuscation) {
          this.deleteObfuscationFile(handle);
        }
      });
      instance = null;
      TsAstUtil.clearProject();
    });
  }

  registerPlugin(node: HvigorNode, pluginId: string) {
    const moduleContext = node.getContext(pluginId) as OhosHapContext | OhosHarContext | OhosHspContext;
    if (!moduleContext) {
      Logger.error(PluginError.ERR_ERROR_CONFIG, node.getNodePath());
      throw new Error('moduleContext is null');
    }
    let handle = new ModuleHandle(node, moduleContext);
    let packageJson: any = TheRouterFileUtil.readJson5(TheRouterFileUtil.pathResolve(node.getNodePath(), 'oh-package.json5'));
    if (pluginId === OhosPluginId.OHOS_HAP_PLUGIN) {
      handle.config.moduleName = packageJson.name;
    }
    if (pluginId === OhosPluginId.OHOS_HSP_PLUGIN) {
      PluginStore.getInstance().hspModuleNames.push(packageJson.name)
    }
    this.moduleHandleSet.add(handle);
  }

  private deleteGeneratorFile(handle: ModuleHandle) {
    let builderDirPath = handle.config.getBuilderDir();
    if (TheRouterFileUtil.exist(builderDirPath)) {
      TheRouterFileUtil.rmSync(builderDirPath, {
        recursive: true
      });
      Logger.info(handle.config.modulePath + ' delete builder dir');
    }
  }

  private deleteRouterMapFile(handle: ModuleHandle) {
    let routerMapDirPath = handle.config.getRouterMapDir();
    if (TheRouterFileUtil.exist(routerMapDirPath)) {
      TheRouterFileUtil.unlinkSync(routerMapDirPath);
      Logger.info(routerMapDirPath + ' delete ' + PluginConstant.ROUTER_MAP_NAME);
    }
  }

  private deleteRawFile(handle: ModuleHandle) {
    let rawFilePath = handle.config.getRawFilePath();
    if (TheRouterFileUtil.exist(rawFilePath)) {
      TheRouterFileUtil.unlinkSync(rawFilePath);
      Logger.info(handle.config.modulePath + ' delete rawfile ' + PluginConstant.ROUTER_MAP_NAME);
    }
  }

  private deleteObfuscationFile(handle: ModuleHandle) {
    let obfuscationFilePath = handle.config.getObfuscationFilePath();
    if (TheRouterFileUtil.exist(obfuscationFilePath)) {
      TheRouterFileUtil.unlinkSync(obfuscationFilePath);
      Logger.info(handle.config.modulePath + ' delete ' + PluginConstant.OBFUSCATION_FILE_NAME);
    }
    let consumerRulesPath = handle.config.getConsumerRulesFilePath();
    if (TheRouterFileUtil.exist(consumerRulesPath)) {
      TheRouterFileUtil.unlinkSync(consumerRulesPath);
      Logger.info(handle.config.modulePath + ' delete ' + PluginConstant.CONSUMER_FILE_NAME);
    }
  }
}

let instance: Index | null = null;

// hap plugin
export function hapPlugin(): HvigorPlugin {
  return {
    pluginId: PluginConstant.HAP_PLUGIN_ID,
    apply(node: HvigorNode) {
      if (!instance) {
        instance = new Index();
      }
      instance.registerPlugin(node, OhosPluginId.OHOS_HAP_PLUGIN);
    }
  };
}

// hsp plugin
export function hspPlugin(): HvigorPlugin {
  return {
    pluginId: PluginConstant.HSP_PLUGIN_ID,
    apply(node: HvigorNode) {
      if (!instance) {
        instance = new Index();
      }
      instance.registerPlugin(node, OhosPluginId.OHOS_HSP_PLUGIN);
    }
  };
}

// har plugin
export function harPlugin(): HvigorPlugin {
  return {
    pluginId: PluginConstant.HAR_PLUGIN_ID,
    apply(node: HvigorNode) {
      if (!instance) {
        instance = new Index();
      }
      instance.registerPlugin(node, OhosPluginId.OHOS_HAR_PLUGIN);
    }
  };
}
