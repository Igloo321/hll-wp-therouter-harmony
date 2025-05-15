import { Route, TheRouter, } from '@therouter/library';
import { BaseConstant } from 'base';

@Route({ path: BaseConstant.ANIM_PAGE2 })
@Component
export struct AnimPage2 {
  aboutToAppear(): void {
    TheRouter.inject(this)
  }

  build() {
    Column() {
      Text('TheRouter 封装的转场动画演示').margin({ top: 50 })
      Button("再打开当前页(默认动画)")
        .height(40)
        .margin({ top: 50 })
        .onClick(() => {
          TheRouter.build(BaseConstant.ANIM_PAGE2).navigation()
        })
      Button("关闭页面")
        .height(40)
        .margin({ top: 50 })
        .onClick(() => {
          TheRouter.build().pop()
        })
    }
    .height('100%')
    .width('100%')
  }
}
