import { AnimatorHandle } from "./AnimatorHandle";
import { AnimatorUtil } from "./AnimatorUtil";

export class HandleTuple {
  enterAnimatorHandle: AnimatorHandle | undefined;
  exitAnimatorHandle: AnimatorHandle | undefined;
}

export class CustomTransition {
  proxy: NavigationTransitionProxy | undefined = undefined;
  operation: NavigationOperation = NavigationOperation.PUSH;
  stackId: string = '';
  hideNavBar: boolean = true;

  constructor(stackId: string, hideNavBar: boolean) {
    this.stackId = stackId;
    this.hideNavBar = hideNavBar;
  }

  getCustomAnimation(from: NavContentInfo, to: NavContentInfo, operation: NavigationOperation):
  NavigationAnimatedTransition | undefined {
    if (this.hideNavBar) {
      if (from.index === -1 || to.index === -1) {
        return undefined;
      }
    }

    let handleTuple: HandleTuple | undefined;
    if (operation === NavigationOperation.PUSH) {
      if (AnimatorUtil.isPageAnimatorExists(operation, this.stackId, to.navDestinationId)) {
        handleTuple = this.getPushOrReplacePageAnimatorHandle(from, to);
      }
    } else if (operation === NavigationOperation.REPLACE) {
      if (AnimatorUtil.isPageAnimatorExists(operation, this.stackId, to.navDestinationId)) {
        handleTuple = this.getPushOrReplacePageAnimatorHandle(from, to);
      }
    } else {
      if (AnimatorUtil.isPageAnimatorExists(operation, this.stackId, from.navDestinationId)) {
        handleTuple = this.getPopPageAnimatorHandle(from, to);
      }
    }

    if (handleTuple?.enterAnimatorHandle || handleTuple?.exitAnimatorHandle) {
      AnimatorUtil.isAnimatorPlayNum += 1;
      let interactiveAnimatorHandle = AnimatorUtil.getInteractiveAnimatorHandle(this.stackId, from.navDestinationId);
      return this.makeCustomAnimation(operation, handleTuple, interactiveAnimatorHandle);
    } else {
      return undefined;
    }
  }

  private getPushOrReplacePageAnimatorHandle(from: NavContentInfo, to: NavContentInfo): HandleTuple {
    const handleTuple = new HandleTuple()
    if (to.mode === NavDestinationMode.STANDARD && from.mode === NavDestinationMode.STANDARD) {
      handleTuple.exitAnimatorHandle =
        AnimatorUtil.getPageAnimatorHandle(NavigationOperation.POP, this.stackId, from.navDestinationId);
    }
    handleTuple.enterAnimatorHandle =
      AnimatorUtil.getPageAnimatorHandle(NavigationOperation.PUSH, this.stackId, to.navDestinationId);
    return handleTuple;
  }

  private getPopPageAnimatorHandle(from: NavContentInfo, to: NavContentInfo): HandleTuple {
    const handleTuple = new HandleTuple()
    if (to.mode === NavDestinationMode.STANDARD && from.mode === NavDestinationMode.STANDARD) {
      handleTuple.enterAnimatorHandle =
        AnimatorUtil.getPageAnimatorHandle(NavigationOperation.PUSH, this.stackId, to.navDestinationId);
    }
    handleTuple.exitAnimatorHandle =
      AnimatorUtil.getPageAnimatorHandle(NavigationOperation.POP, this.stackId, from.navDestinationId);
    return handleTuple;
  }

  private makeCustomAnimation(operation: NavigationOperation, handleTuple: HandleTuple | undefined,
    interactiveAnimatorHandle: AnimatorHandle | undefined): NavigationAnimatedTransition {
    let customAnimation: NavigationAnimatedTransition = {
      onTransitionEnd: (isSuccess: boolean) => {
        if (AnimatorUtil.isAnimatorPlayNum > 0) {
          AnimatorUtil.isAnimatorPlayNum -= 1;
        }
        interactiveAnimatorHandle?.recoverState();
      },
      timeout: interactiveAnimatorHandle?.interactive ? undefined :
        (operation === NavigationOperation.PUSH || operation === NavigationOperation.REPLACE ?
          handleTuple?.enterAnimatorHandle?.timeout : handleTuple?.exitAnimatorHandle?.timeout),
      transition: (transitionProxy: NavigationTransitionProxy) => {
        if (interactiveAnimatorHandle?.interactive) {
          interactiveAnimatorHandle.proxy = transitionProxy;
        }
        if (operation === NavigationOperation.PUSH || operation === NavigationOperation.REPLACE) {
          const hasCustomAnimate = !!handleTuple?.enterAnimatorHandle?.customAnimationCallback;
          if (handleTuple?.enterAnimatorHandle?.customAnimationCallback) {
            handleTuple?.enterAnimatorHandle.doCustomAnimation(transitionProxy);
          } else {
            handleTuple?.enterAnimatorHandle?.doStart();
            animateTo({
              duration: handleTuple?.enterAnimatorHandle?.duration,
              curve: handleTuple?.enterAnimatorHandle?.curve,
              onFinish: () => {
                handleTuple?.enterAnimatorHandle?.doOnFinish();
                if (!hasCustomAnimate && !interactiveAnimatorHandle?.interactive) {
                  transitionProxy.finishTransition();
                }
              }
            }, () => {
              handleTuple?.enterAnimatorHandle?.doFinish();
            });
          }
          if (handleTuple?.exitAnimatorHandle?.passiveCustomAnimationCallback) {
            handleTuple?.exitAnimatorHandle?.doPassiveCustomAnimation(transitionProxy);
          } else {
            handleTuple?.exitAnimatorHandle?.doPassiveStart();
            animateTo({
              duration: handleTuple?.enterAnimatorHandle?.duration,
              curve: handleTuple?.exitAnimatorHandle?.curve,
              onFinish: () => {
                handleTuple?.exitAnimatorHandle?.doPassiveOnFinish();
                if (!hasCustomAnimate && !interactiveAnimatorHandle?.interactive) {
                  transitionProxy.finishTransition();
                }
              }
            }, () => {
              handleTuple?.exitAnimatorHandle?.doPassiveFinish();
            });
          }

        } else {
          const hasCustomAnimate = !!handleTuple?.exitAnimatorHandle?.customAnimationCallback;
          if (handleTuple?.enterAnimatorHandle?.passiveCustomAnimationCallback) {
            handleTuple?.enterAnimatorHandle?.doPassiveCustomAnimation(transitionProxy);
          } else {
            handleTuple?.enterAnimatorHandle?.doPassiveStart();
            animateTo({
              duration: handleTuple?.exitAnimatorHandle?.duration,
              curve: handleTuple?.enterAnimatorHandle?.curve,
              onFinish: () => {
                handleTuple?.enterAnimatorHandle?.doPassiveOnFinish();
                if (!hasCustomAnimate && !interactiveAnimatorHandle?.interactive) {
                  transitionProxy.finishTransition();
                }
              }
            }, () => {
              handleTuple?.enterAnimatorHandle?.doPassiveFinish();
            });
          }

          if (handleTuple?.exitAnimatorHandle?.customAnimationCallback) {
            handleTuple?.exitAnimatorHandle?.doCustomAnimation(transitionProxy);
          } else {
            handleTuple?.exitAnimatorHandle?.doStart();
            animateTo({
              duration: handleTuple?.exitAnimatorHandle?.duration,
              curve: handleTuple?.exitAnimatorHandle?.curve,
              onFinish: () => {
                handleTuple?.exitAnimatorHandle?.doOnFinish();
                if (!hasCustomAnimate && !interactiveAnimatorHandle?.interactive) {
                  transitionProxy.finishTransition();
                }
              }
            }, () => {
              handleTuple?.exitAnimatorHandle?.doFinish();
            });
          }
        }
      },
      isInteractive: interactiveAnimatorHandle?.interactive
    };
    return customAnimation;
  }
}
