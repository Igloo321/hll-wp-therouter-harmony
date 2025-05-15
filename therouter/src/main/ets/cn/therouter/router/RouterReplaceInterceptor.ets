import { RouteItem } from "./RouteItem";

/**
 * 路由替换器
 *
 * 应用场景：常用于未登录时无法访问的页面。例如，访问用户钱包页面时，
 * 在路由表中可以声明该页面需要登录。如果在跳转过程中发现目标页需要登录，
 * 则先替换路由到登录页，并将原目标页信息作为参数传递。
 * 登录完成后，用户可以继续执行之前的路由操作。
 *
 * **拦截点更靠后**：路由替换器的拦截时机发生在框架已经从路由表中
 * 根据 `path` 找到目标路由之后，此时对找到的路由进行操作。
 *
 * 传统做法通常是在落地页（目标页面）自行判断用户权限，
 * 但在路由层完成这一逻辑更为合理。
 *
 * **注意**：必须在 `TheRouter.build().navigation()` 方法调用前添加处理器，
 * 否则所有在此之前的跳转不会被替换。
 */
export abstract class RouterReplaceInterceptor {

  watch(routeItem: RouteItem | null): boolean {
    return true;
  }

  abstract replace(routeItem: RouteItem | null): RouteItem | null;

  /**
   * 数字越大，优先级越高
   */
  get priority(): number {
    return 5;
  }
}
