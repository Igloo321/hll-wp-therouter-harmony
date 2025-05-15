import path from 'path';

export default class PluginConstant {
    static readonly DEFAULT_SCAN_DIR = 'src/main/ets';
    static readonly DEFAULT_ROUTER_MAP_DIR = 'src/main/resources/base/profile';
    static readonly DEFAULT_BUILD_DIR = 'src/main/ets/generated';
    static readonly DEFAULT_BUILD_TPL = 'viewBuilder.ejs';
    static readonly ROUTER_ANNOTATION = 'Route';
    static readonly ACTION_ANNOTATION = 'Action';
    static readonly SERVICE_PROVIDE_ANNOTATION = 'ServiceProvider';

    static readonly ACTION_PREFIX = '__action__';
    static readonly SERVICE_PROVIDE_PREFIX = '__service_provider__';

    static readonly OBFUSCATION_FILE_NAME = 'therouter-obfuscation-rules.txt';
    static readonly CONSUMER_FILE_NAME = 'therouter-consumer-rules.txt';

    static readonly VIEW_NAME_PREFIX = 'TheRouter';
    static readonly ETS_SUFFIX = '.ets';
    static readonly JSON_SUFFIX = '.json';

    static readonly ROUTER_MAP_KEY = 'routeMap';

    static readonly FILE_SEPARATOR = path.sep;
    static readonly DELIMITER = '/';

    static readonly ROUTER_MAP_NAME = PluginConstant.ROUTER_MAP_KEY + PluginConstant.JSON_SUFFIX;
    static readonly MODULE_ROUTER_MAP_NAME = '$profile:' + PluginConstant.ROUTER_MAP_KEY;
    static readonly TEMP_ROUTER_MAP_PATH = '../../intermediates/router_map';
    static readonly RAWFILE_DIR = 'src/main/resources/rawfile/' + PluginConstant.ROUTER_MAP_NAME;

    static readonly HAP_PLUGIN_ID = 'HAP_THEROUTER_PLUGIN';
    static readonly HSP_PLUGIN_ID = 'HSP_THEROUTER_PLUGIN';
    static readonly HAR_PLUGIN_ID = 'HAR_THEROUTER_PLUGIN';
    static readonly HAR_MODULE_NAME = 'har';

    static readonly CONFIG_FILE_NAME = 'therouter_build_config.json';
    static readonly PARENT_DELIMITER = '../';
    static readonly CURRENT_DELIMITER = './';

    static readonly LINE_BREAK = '\n';
    static readonly KEEP_FILE_NAME = '-keep-file-name';
    static readonly KEEP_PROPERTY_NAME = '-keep-property-name';
    static readonly KEEP_GLOBAL_NAME = '-keep-global-name';

    static readonly OH_MODULE_PATH = 'oh_modules';

    static readonly WARP_BUILDER = 'WrapBuilder';
}
