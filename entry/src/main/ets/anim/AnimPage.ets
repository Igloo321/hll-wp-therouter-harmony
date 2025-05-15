import {
  Route,
  TheRouter,
  IAnimator,
  TranslateOption,
  ScaleOption,
  OpacityOption,
  AnimatorHandle
} from '@therouter/library';
import { BaseConstant } from 'base';
import { curves } from '@kit.ArkUI';

/**
 * 页面跳转华为推荐了两种方案，TheRouter都做了支持
 * 1. 导航转场，华为推荐使用Navigation组件实现，可搭配NavDestination组件实现导航功能，TheRouter封装了调用过程，使用起来更方便
 * 2. 模态转场(主要用于对特定单一页面切换时设置动画)是 ArkUI 提供的能力，TheRouter 只提供了调用透传，详细使用请查看官方文档
 * https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-modal-transition-V5
 */
@Route({ path: BaseConstant.ANIM_PAGE1 })
@Component
export struct AnimPage {
  aboutToAppear(): void {
    TheRouter.inject(this)
  }

  build() {
    Column() {

      /////////////////////////////////////////////////////////////////////////////////////////////////////
      // 模态转场是 ArkUI 提供的能力，TheRouter 只提供了调用透彻，详细使用请查看官方文档                           //
      // https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-modal-transition-V5      //
      /////////////////////////////////////////////////////////////////////////////////////////////////////

      Text('转场动画演示').margin({ top: 50 })
      Text('模态转场(主要用于对特定单一页面切换时设置动画)是 ArkUI 提供的能力，TheRouter 只提供了调用透传，详细使用请查看华为官方文档：')
        .margin({ top: 50 })
      Text('https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-modal-transition-V5')
        .fontColor('#009F9F')
      Text('当前页面：只对页面打开时添加模态转场动画').margin({ top: 50 })
      Button("ArkUI自带的模态转场演示（页面打开关闭都有动画）")
        .height(40)
        .margin({ top: 50 })
        .onClick(() => {
          TheRouter.build(BaseConstant.ANIM_PAGE3).navigation();
        })
      Button("TheRouter自定义跳转动画（请查看代码）")
        .height(40)
        .margin({ top: 50 })
        .onClick(() => {
          TheRouter.build(BaseConstant.ANIM_PAGE2).withAnimation(new CustomAnimator()).navigation()
        })
      Button("TheRouter自定义过程动画（随手指滑动）")
        .height(40)
        .margin({ top: 50 })
        .onClick(() => {
          TheRouter.build(BaseConstant.ANIM_PAGE2)
            .withAnimation(new InteractiveAnimator(BaseConstant.ANIM_PAGE2))
            .navigation()
        })
      Button("关闭系统页面切换动画")
        .height(40)
        .margin({ top: 50 })
        .onClick(() => {
          TheRouter.build(BaseConstant.LIST_PAGE1)
            .withAnimation(false)
            .withString("hello", "来自首页的参数")
            .navigation();
        })
    }
    // 通过模态转场动画实现出现消失转场动画效果，transition需要加在builder下的第一个组件
    .transition(TransitionEffect.translate({ y: 1000 }).animation({ curve: curves.springMotion(0.6, 0.8) }))
    .height('100%')
    .width('100%')
  }
}

export class CustomAnimator implements IAnimator {
  effect(enterHandle: AnimatorHandle, exitHandle: AnimatorHandle): void {
    enterHandle.start((translateOption?: TranslateOption, scaleOption?: ScaleOption,
      opacityOption?: OpacityOption, extendOption?: ESObject, proxy?: NavigationTransitionProxy) => {
      if (translateOption) {
        translateOption.y = '100%';
      }
      if (opacityOption) {
        if (opacityOption) {
          opacityOption.opacity = 0.4;
        }
      }
    });
    enterHandle.finish((translateOption?: TranslateOption, scaleOption?: ScaleOption,
      opacityOption?: OpacityOption, extendOption?: ESObject, proxy?: NavigationTransitionProxy) => {
      if (translateOption) {
        translateOption.y = '0';
      }
      if (opacityOption) {
        if (opacityOption) {
          opacityOption.opacity = 1;
        }
      }
    });
    enterHandle.onFinish((translateOption?: TranslateOption, scaleOption?: ScaleOption,
      opacityOption?: OpacityOption, extendOption?: ESObject, proxy?: NavigationTransitionProxy) => {
      if (translateOption) {
        translateOption.y = '0';
      }
      if (opacityOption) {
        if (opacityOption) {
          opacityOption.opacity = 1;
        }
      }
    });

    exitHandle.start((translateOption?: TranslateOption, scaleOption?: ScaleOption,
      opacityOption?: OpacityOption, extendOption?: ESObject, proxy?: NavigationTransitionProxy) => {
      if (translateOption) {
        translateOption.y = '0';
      }
      if (opacityOption) {
        if (opacityOption) {
          opacityOption.opacity = 1;
        }
      }
    });
    exitHandle.finish((translateOption?: TranslateOption, scaleOption?: ScaleOption,
      opacityOption?: OpacityOption, extendOption?: ESObject, proxy?: NavigationTransitionProxy) => {
      if (translateOption) {
        translateOption.y = '-100%';
      }
      if (opacityOption) {
        if (opacityOption) {
          opacityOption.opacity = 0.4;
        }
      }
    });
    exitHandle.onFinish((translateOption?: TranslateOption, scaleOption?: ScaleOption,
      opacityOption?: OpacityOption, extendOption?: ESObject, proxy?: NavigationTransitionProxy) => {
      if (translateOption) {
        translateOption.y = '-100%';
      }
      if (opacityOption) {
        if (opacityOption) {
          opacityOption.opacity = 0.4;
        }
      }
    });
  }
}


export class InteractiveAnimator implements IAnimator {
  private path: string

  constructor(path: string) {
    this.path = path;
  }

  effect(enterHandle: AnimatorHandle, exitHandle: AnimatorHandle): void {
    enterHandle.start((translateOption?: TranslateOption, scaleOption?: ScaleOption,
      opacityOption?: OpacityOption, extendOption?: ESObject, proxy?: NavigationTransitionProxy) => {
      if (translateOption) {
        translateOption.y = '100%';
        translateOption.x = '100%';
      }
      if (opacityOption) {
        opacityOption.opacity = 0.4;
      }
    });
    enterHandle.finish((translateOption?: TranslateOption, scaleOption?: ScaleOption,
      opacityOption?: OpacityOption, extendOption?: ESObject, proxy?: NavigationTransitionProxy) => {
      if (translateOption) {
        translateOption.x = '0';
        translateOption.y = '0';
      }
      if (opacityOption) {
        opacityOption.opacity = 1;
      }
    });
    enterHandle.onFinish((translateOption?: TranslateOption, scaleOption?: ScaleOption,
      opacityOption?: OpacityOption, extendOption?: ESObject, proxy?: NavigationTransitionProxy) => {
      if (translateOption) {
        translateOption.x = '0';
        translateOption.y = '0';
      }
      if (opacityOption) {
        opacityOption.opacity = 1;
      }
    });

    exitHandle.start((translateOption?: TranslateOption, scaleOption?: ScaleOption,
      opacityOption?: OpacityOption, extendOption?: ESObject, proxy?: NavigationTransitionProxy) => {
      if (translateOption) {
        translateOption.x = '0';
        translateOption.y = '0';
      }
      if (opacityOption) {
        opacityOption.opacity = 1;
      }
    });
    exitHandle.finish((translateOption?: TranslateOption, scaleOption?: ScaleOption,
      opacityOption?: OpacityOption, extendOption?: ESObject, proxy?: NavigationTransitionProxy) => {
      if (translateOption) {
        translateOption.x = '100%';
        translateOption.y = '100%';
      }
      if (opacityOption) {
        opacityOption.opacity = 0.4;
      }
    });
    exitHandle.onFinish((translateOption?: TranslateOption, scaleOption?: ScaleOption,
      opacityOption?: OpacityOption, extendOption?: ESObject, proxy?: NavigationTransitionProxy) => {
      if (translateOption) {
        translateOption.x = '0';
        translateOption.y = '0';
      }
      if (opacityOption) {
        opacityOption.opacity = 0.4;
      }
    });
  }

  interactive(handle: AnimatorHandle): void {
    handle.actionStart((event: GestureEvent) => {
      if (event.offsetX > 0) {
        TheRouter.build().pop();
      } else {
        TheRouter.build(this.path).navigation();
      }
      handle.startOffset = event.fingerList[0].localX;
    });
    handle.updateProgress((event, proxy, operation, startOffset) => {
      if (!proxy?.updateTransition || !startOffset) {
        return;
      }
      let offset = 0;
      if (event.fingerList[0]) {
        offset = event.fingerList[0].localX - startOffset;
      }
      if (offset < 0) {
        proxy?.updateTransition(0);
        return;
      }
      let rectWidth = event.target.area.width as number;
      let rate = offset / rectWidth;
      proxy?.updateTransition(rate);
    });
    handle.actionEnd((event, proxy, operation, startOffset) => {
      if (!startOffset) {
        return;
      }
      let rectWidth = event.target.area.width as number;
      let rate = 0;
      if (event.fingerList[0]) {
        rate = Math.abs(event.fingerList[0].localX - startOffset) / rectWidth;
      }
      if (rate > 0.4) {
        proxy?.finishTransition();
      } else {
        proxy?.cancelTransition?.();
      }
    });
  }
}