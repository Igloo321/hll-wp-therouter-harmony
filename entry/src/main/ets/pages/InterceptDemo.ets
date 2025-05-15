import { NavigatorPathFixHandle, TheRouter, } from "@therouter/library";

export class InterceptDemo {
  public addIntercept() {

    /**
     * 定义拦截器处理
     * TheRouter支持四种拦截器，可在整个路由跳转各个环节定制跳转动作，详细请查看官网文档
     * https://therouter.cn/docs/2025/03/24/01
     */
    class FixHandle extends NavigatorPathFixHandle {
      fix(path?: string | undefined): string | undefined {
        if (path) {
          if (path.startsWith("http://")) {
            // 把 http://xxx.com/abc 替换成 https://xxx.com/abc 并返回
            return path.replace("http://", "https://");
          }
        }
        return path;
      }
    };
    const handle = new FixHandle();
    // 加入拦截器
    TheRouter.addNavigatorPathFixHandle(handle)
    //移除拦截器
    // TheRouter.addNavigatorPathFixHandle(handle)
  }
}