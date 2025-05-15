import { Route, TheRouter } from '@therouter/library';
import { BaseConstant } from '../constants/BaseConstant';

@Route({ path: BaseConstant.PAGE_BASE1 })
@Component
export struct BusinessBaseMainPage {
  @State
  title: string = 'Base'
  lastTime: number = 0

  aboutToAppear(): void {
    TheRouter.inject(this)
  }

  build() {
    Column() {
      Text(this.title)
      Button("A模块一对多Path")
        .height(40)
        .margin({ bottom: 10 })
        .onClick(() => {
          this.title = "修改后的title"
          TheRouter.build(BaseConstant.PAGE_A2).withString("hello", "一对多Path").navigation();
        })
      Button("跳B模块页面")
        .height(40)
        .margin({ bottom: 10, top: 40 })
        .onClick(() => {
          this.title = "修改后的title"
          TheRouter.build(BaseConstant.PAGE_B1).navigation();
        })
    }
    .height('100%')
    .width('100%')
  }

  /**
   * 如果自定义 onBackPress()，必须调用 TheRouter.inject(this)
   */
  onBackPress(): boolean | void {
    let time = Date.now();
    if (time - this.lastTime > 1000) {
      this.getUIContext()
        .getPromptAction()
        .showToast({ message: `1s内按两次才关闭页面，当前标题${this.title}`, duration: 1000 });
      this.lastTime = time;
      return true;
    } else {
      return false;
    }
  }
}