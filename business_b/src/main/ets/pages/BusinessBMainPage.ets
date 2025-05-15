import { Route, TheRouter } from '@therouter/library';
import { BaseConstant } from 'base';

@Route({ path: BaseConstant.PAGE_B1 })
@Component
export struct BusinessBMainPage {
  build() {
    Column() {
      Text('B')
      Button("跳到模块A")
        .height(40)
        .margin({ bottom: 10, top: 40 })
        .onClick(() => {
          TheRouter.build(BaseConstant.PAGE_A1).withString("hello", "来自首页的参数").navigation();
        })
      Button("跳到模块A：一对多Path")
        .height(40)
        .margin({ bottom: 10 })
        .onClick(() => {
          TheRouter.build(BaseConstant.PAGE_A2).withString("hello", "一对多Path").navigation();
        })
    }
    .height('100%')
    .width('100%')
  }
}