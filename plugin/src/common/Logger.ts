import {HvigorLogger} from '@ohos/hvigor';

export class Logger {
  static error(format: string, ...args: string[]) {
    const publicFormat = `[TheRouterPlugin] ERROR: ${format.replace('%s', args[0])}`;
    HvigorLogger.getLogger().error(publicFormat);
  }

  static info(msg: string, ...args: unknown[]) {
    HvigorLogger.getLogger().info('[TheRouterPlugin] ' + msg, ...args);
  }

  static warn(msg: string, ...args: unknown[]) {
    HvigorLogger.getLogger().warn('[TheRouterPlugin] ' + msg, ...args);
  }
}

export enum PluginError {
  ERR_DUPLICATE_NAME = 'ERR_DUPLICATE_NAME',
  ERR_WRONG_DECORATION = 'ERR_DUPLICATE_',
  ERR_ERROR_CONFIG = 'ERR_INIT_COMPONENT',
  ERR_NOT_EMPTY_STRING = 'ERR_INIT_NOT_READY',
  ERR_INVALID_STRING_VALUE = 'ERR_INVALID_STRING_VALUE'
}

