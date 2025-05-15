/**
 * 页面替换器
 *
 * 应用场景：当需要将某些 path 指定为新链接时使用。也可以用于修复链接，
 * 但与 path 修改器不同的是，修改器通常用于解决通用性问题，
 * 而替换器仅在页面跳转时生效，更多用于解决特定问题。
 *
 * 例如，在模块化开发中，首页壳模板组件可能包含 `SplashActivity` 广告组件作为 `MainActivity`。
 * 在广告结束后，它会自动跳转到业务首页。然而，每个业务的首页 `Path` 可能不同，
 * 但我们不希望业务线修改首页壳模板组件。因此，可以在组件中先写占位符：
 * `https://kymjs.com/splash/to/home`，然后让接入方通过 `PathReplaceInterceptor` 进行替换。
 *
 * **注意**：必须在 `TheRouter.build().navigation()` 方法调用前添加处理器，
 * 否则所有在此之前的跳转不会被替换。
 */
export abstract class PathReplaceInterceptor {
  watch(path: string): boolean {
    return true;
  }

  abstract replace(path: string): string;

  /**
   * 数字越大，优先级越高
   */
  get priority(): number {
    return 5;
  }
}
