import { TheRouter } from '../TheRouter';

export function require(pass: boolean, tag: string, msg: string): void {
  if (!pass) {
    if (TheRouter.isDebug) {
      throw new Error(`TheRouter::${tag}::${msg}`);
    } else {
      TheRouter.logCat(`TheRouter::{tag}`, msg);
    }
  }
}

/**
 * 打印日志，允许通过 TheRouter.logCat 自定义日志输出
 */
export function debug(tag: string, msg: string, block: () => void = () => {
}) {
  if (TheRouter.isDebug) {
    console.debug(`TheRouter::${tag}`, msg);
    block();
  } else {
    TheRouter.logCat?.(`TheRouter::${tag}`, msg);
  }
}

export function deepClone(obj: ESObject): ESObject {
  if (obj === null || typeof obj !== 'object') {
    return obj;
  }
  if (obj instanceof Date) {
    return new Date(obj.getTime()) as ESObject;
  }
  if (obj instanceof Array) {
    const copy = [obj.length];
    for (let i = 0; i < obj.length; i++) {
      copy[i] = deepClone(obj[i])
    }
    return copy;
  }
  if (obj instanceof Object) {
    const copy: ESObject = {};
    Object.keys(obj).forEach(key => {
      if (obj.hasOwnProperty(key)) {
        copy[key] = deepClone(obj[key]);
      }
    });
    return copy;
  }
  return obj;
}