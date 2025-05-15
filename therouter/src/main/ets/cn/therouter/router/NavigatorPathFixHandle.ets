/**
 * 应用场景：用于修复客户端上路由 path 错误问题。
 * 例如：相对路径转绝对路径，或由于服务端下发的链接无法固定https或http，但客户端代码写死了 https 的 path，就可以用这种方式统一。
 * 注：必须在 TheRouter.build() 方法调用前添加处理器，否则处理器前的所有path不会被修改。
 */
export abstract class NavigatorPathFixHandle {
  watch(path?: string): boolean {
    return true;
  }

  abstract fix(path?: string): string | undefined;

  /**
   * 数字越大，优先级越高
   */
  get priority(): number {
    return 5;
  }
}
