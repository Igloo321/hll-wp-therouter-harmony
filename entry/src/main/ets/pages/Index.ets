import { TheRouterPage } from '@therouter/library';
import { BaseConstant } from 'base';

@Entry
@Component
struct Index {
  build() {
    RelativeContainer() {
      TheRouterPage({
        // 必传，用于标记当前返回栈的id，可以是任意字符串，但必须唯一
        stackId: 'MAIN_NAVIGATION_ID',
        // 必传，当前返回栈的根页面path，不传则显示白屏
        root: BaseConstant.MAIN_PAGE
      });
    }
    .height('100%')
    .width('100%')
  }
}