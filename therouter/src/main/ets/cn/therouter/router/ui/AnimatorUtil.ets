import { TheRouter } from '../../TheRouter';
import { AnimatorHandle } from './AnimatorHandle';
import { IAnimator, OpacityOption, ScaleOption, TranslateOption } from './IAnimator';

export class AnimatorUtil {
  // key: stackid-ndid
  private static interactiveHandleMap: Map<string, AnimatorHandle> = new Map();
  private static enterAnimatorHandleMap: Map<string, AnimatorHandle> = new Map();
  private static exitAnimatorHandleMap: Map<string, AnimatorHandle> = new Map();
  public static isAnimatorPlayNum: number = 0;
  public static defaultAnimator?: IAnimator;

  static interactiveStart(stackId: string, ndid: string, event: GestureEvent) {
    if (AnimatorUtil.isAnimatorPlayNum > 0) {
      return;
    }
    const name = stackId + '-' + ndid;
    AnimatorUtil.interactiveHandleMap.get(name)?.doActionStart(event);
  }

  static interactiveFinish(stackId: string, ndid: string, event: GestureEvent) {
    const name = stackId + '-' + ndid;
    AnimatorUtil.interactiveHandleMap.get(name)?.doActionEnd(event);
  }

  static interactiveProgress(stackId: string, ndid: string, event: GestureEvent) {
    const name = stackId + '-' + ndid;
    AnimatorUtil.interactiveHandleMap.get(name)?.doUpdateProgress(event);
  }

  static interactiveCancel(stackId: string, ndid: string) {
    const name = stackId + '-' + ndid;
    AnimatorUtil.interactiveHandleMap.get(name)?.doActionCancel();
  }

  static getInteractiveAnimatorHandle(stackId: string, ndid?: string): AnimatorHandle | undefined {
    if (ndid) {
      const name = stackId + '-' + ndid;
      return AnimatorUtil.interactiveHandleMap.get(name);
    } else {
      return undefined;
    }
  }

  static getPageAnimatorHandle(operation: NavigationOperation, stackId: string, ndid?: string):
  AnimatorHandle | undefined {
    if (ndid) {
      const name = stackId + '-' + ndid;
      if (operation === NavigationOperation.PUSH || operation === NavigationOperation.REPLACE) {
        return AnimatorUtil.enterAnimatorHandleMap.get(name);
      } else {
        return AnimatorUtil.exitAnimatorHandleMap.get(name);
      }
    } else {
      return undefined;
    }
  }

  static isPageAnimatorExists(operation: NavigationOperation, stackId: string, ndid?: string) {
    if (ndid) {
      const name = stackId + '-' + ndid;
      if (operation === NavigationOperation.PUSH || operation === NavigationOperation.REPLACE) {
        const enterAnimatorHandle = AnimatorUtil.enterAnimatorHandleMap.get(name)
        return !!enterAnimatorHandle?.finishCallback || !!enterAnimatorHandle?.customAnimationCallback;
      } else {
        const exitAnimatorHandle = AnimatorUtil.exitAnimatorHandleMap.get(name)
        return !!exitAnimatorHandle?.finishCallback || !!exitAnimatorHandle?.customAnimationCallback;
      }
    } else {
      return true;
    }
  }

  static registerAnimatorHandle(stackId: string, pageId: string, translateOption?: TranslateOption,
    scaleOption?: ScaleOption, opacityOption?: OpacityOption, extendOption?: ESObject): void {
    const interactiveHandle = new AnimatorHandle(translateOption, scaleOption, opacityOption, extendOption);
    const enterAnimatorHandle = new AnimatorHandle(translateOption, scaleOption, opacityOption, extendOption);
    const exitAnimatorHandle = new AnimatorHandle(translateOption, scaleOption, opacityOption, extendOption);
    let animator = TheRouter.getPathStack(stackId)?.getCurrentAnimator()
    if (!animator) {
      animator = AnimatorUtil.defaultAnimator;
    }
    if (animator) {
      if (animator.interactive) {
        animator.interactive(interactiveHandle);
        AnimatorUtil.interactiveHandleMap.set(pageId, interactiveHandle);
      }
      animator.effect(enterAnimatorHandle, exitAnimatorHandle);
    }
    AnimatorUtil.enterAnimatorHandleMap.set(pageId, enterAnimatorHandle);
    AnimatorUtil.exitAnimatorHandleMap.set(pageId, exitAnimatorHandle);
  }

  static updateHandleKey(pageId: string, stackId: string, ndid: string) {
    const name = stackId + '-' + ndid;
    let enterAnimatorHandle = AnimatorUtil.enterAnimatorHandleMap.get(pageId);
    if (enterAnimatorHandle) {
      AnimatorUtil.enterAnimatorHandleMap.set(name, enterAnimatorHandle);
      AnimatorUtil.enterAnimatorHandleMap.delete(pageId);
    }
    let exitAnimatorHandle = AnimatorUtil.exitAnimatorHandleMap.get(pageId);
    if (exitAnimatorHandle) {
      AnimatorUtil.exitAnimatorHandleMap.set(name, exitAnimatorHandle);
      AnimatorUtil.exitAnimatorHandleMap.delete(pageId);
    }
    let interactiveHandle = AnimatorUtil.interactiveHandleMap.get(pageId);
    if (interactiveHandle) {
      AnimatorUtil.interactiveHandleMap.set(name, interactiveHandle);
      AnimatorUtil.interactiveHandleMap.delete(pageId);
    }
  }

  static unRegisterAnimatorHandle(stackId: string, ndid: string) {
    const name = stackId + '-' + ndid;
    AnimatorUtil.interactiveHandleMap.delete(name);
    AnimatorUtil.enterAnimatorHandleMap.delete(name);
    AnimatorUtil.exitAnimatorHandleMap.delete(name);
  }
}
