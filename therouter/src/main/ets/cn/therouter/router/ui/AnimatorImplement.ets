import { AnimatorHandle } from './AnimatorHandle'
import { OpacityOption, ScaleOption, IAnimator, TranslateOption, Direction } from './IAnimator';

export class AnimatorImplement implements IAnimator {
  direction: Direction | undefined;
  opacity?: OpacityOption;
  scale?: ScaleOption;
  duration?: number;
  curve?: Curve | string | ICurve;

  effect(enterHandle: AnimatorHandle, exitHandle: AnimatorHandle): void {
    enterHandle.start((translateOption?: TranslateOption, scaleOption?: ScaleOption, opacityOption?: OpacityOption,
      extendOption?: ESObject, proxy?: NavigationTransitionProxy) => {
      if (opacityOption) {
        opacityOption.opacity = this.opacity?.opacity ? this.opacity.opacity : 1;
      }
      if (this.scale && scaleOption) {
        if (this.scale?.x === 0) {
          scaleOption.x = 0;
        } else {
          scaleOption.x = this.scale?.x ? this.scale.x : scaleOption.x;
        }
        if (this.scale?.y === 0) {
          scaleOption.y = 0;
        } else {
          scaleOption.y = this.scale?.y ? this.scale.y : scaleOption.y;
        }
        if (this.scale?.centerX === 0) {
          scaleOption.centerX = 0;
        } else {
          scaleOption.centerX = this.scale?.centerX ? this.scale.centerX : scaleOption.centerX;
        }
        if (this.scale?.centerY === 0) {
          scaleOption.centerY = 0;
        } else {
          scaleOption.centerY = this.scale?.centerY ? this.scale.centerY : scaleOption.centerY;
        }
      }
      if (translateOption) {
        if (this.direction === Direction.RIGHT_TO_LEFT) {
          translateOption.x = '100%';
        } else if (this.direction === Direction.LEFT_TO_RIGHT) {
          translateOption.x = '-100%';
        } else if (this.direction === undefined) {
          translateOption.x = 0;
          translateOption.y = 0;
        } else if (this.direction === Direction.BOTTOM_TO_TOP) {
          translateOption.y = '100%';
        } else if (this.direction === Direction.TOP_TO_BOTTOM) {
          translateOption.y = '-100%';
        }
      }
    });
    enterHandle.finish((translateOption?: TranslateOption, scaleOption?: ScaleOption, opacityOption?: OpacityOption,
      extendOption?: ESObject, proxy?: NavigationTransitionProxy) => {
      if (translateOption) {
        if (this.direction === Direction.RIGHT_TO_LEFT) {
          translateOption.x = 0;
        } else if (this.direction === Direction.LEFT_TO_RIGHT) {
          translateOption.x = 0;
        } else if (this.direction === undefined) {
          translateOption.x = 0;
          translateOption.y = 0;
        } else if (this.direction === Direction.BOTTOM_TO_TOP) {
          translateOption.y = 0;
        } else if (this.direction === Direction.TOP_TO_BOTTOM) {
          translateOption.y = 0;
        }
      }
      if (scaleOption) {
        scaleOption.x = 1;
        scaleOption.y = 1;
      }
      if (opacityOption) {
        opacityOption.opacity = 1;
      }
    });
    enterHandle.passiveStart((translateOption?: TranslateOption, scaleOption?: ScaleOption,
      opacityOption?: OpacityOption, extendOption?: ESObject, proxy?: NavigationTransitionProxy) => {
      if (opacityOption) {
        opacityOption.opacity = this.opacity?.opacity ? this.opacity.opacity : 1;
      }
      if (this.scale && scaleOption) {
        if (this.scale?.x === 0) {
          scaleOption.x = 0;
        } else {
          scaleOption.x = this.scale?.x ? this.scale.x : scaleOption.x;
        }
        if (this.scale?.y === 0) {
          scaleOption.y = 0;
        } else {
          scaleOption.y = this.scale?.y ? this.scale.y : scaleOption.y;
        }
        if (this.scale?.centerX === 0) {
          scaleOption.centerX = 0;
        } else {
          scaleOption.centerX = this.scale?.centerX ? this.scale.centerX : scaleOption.centerX;
        }
        if (this.scale?.centerY === 0) {
          scaleOption.centerY = 0;
        } else {
          scaleOption.centerY = this.scale?.centerY ? this.scale.centerY : scaleOption.centerY;
        }
      }
      if (translateOption) {
        if (this.direction === Direction.RIGHT_TO_LEFT) {
          translateOption.x = -100;
        } else if (this.direction === Direction.LEFT_TO_RIGHT) {
          translateOption.x = 100;
        } else if (this.direction === undefined) {
          translateOption.x = 0;
          translateOption.y = 0;
        } else if (this.direction === Direction.BOTTOM_TO_TOP) {
          translateOption.y = -100;
        } else if (this.direction === Direction.TOP_TO_BOTTOM) {
          translateOption.y = 100;
        }
      }
    });
    enterHandle.passiveFinish((translateOption?: TranslateOption, scaleOption?: ScaleOption,
      opacityOption?: OpacityOption, extendOption?: ESObject, proxy?: NavigationTransitionProxy) => {
      if (translateOption) {
        if (this.direction === Direction.RIGHT_TO_LEFT) {
          translateOption.x = 0;
        } else if (this.direction === Direction.LEFT_TO_RIGHT) {
          translateOption.x = 0;
        } else if (this.direction === undefined) {
          translateOption.x = 0;
          translateOption.y = 0;
        } else if (this.direction === Direction.BOTTOM_TO_TOP) {
          translateOption.y = 0;
        } else if (this.direction === Direction.TOP_TO_BOTTOM) {
          translateOption.y = 0;
        }
      }
      if (scaleOption) {
        scaleOption.x = 1;
        scaleOption.y = 1;
      }
      if (opacityOption) {
        opacityOption.opacity = 1;
      }
    });
    exitHandle.start((translateOption?: TranslateOption, scaleOption?: ScaleOption,
      opacityOption?: OpacityOption, extendOption?: ESObject, proxy?: NavigationTransitionProxy) => {
      if (translateOption) {
        if (this.direction === Direction.RIGHT_TO_LEFT) {
          translateOption.x = 0;
        } else if (this.direction === Direction.LEFT_TO_RIGHT) {
          translateOption.x = 0;
        } else if (this.direction === undefined) {
          translateOption.x = 0;
          translateOption.y = 0;
        } else if (this.direction === Direction.BOTTOM_TO_TOP) {
          translateOption.y = 0;
        } else if (this.direction === Direction.TOP_TO_BOTTOM) {
          translateOption.y = 0;
        }
      }
      if (scaleOption) {
        scaleOption.x = 1;
        scaleOption.y = 1;
      }
      if (opacityOption) {
        opacityOption.opacity = 1;
      }
    });
    exitHandle.finish((translateOption?: TranslateOption, scaleOption?: ScaleOption,
      opacityOption?: OpacityOption, extendOption?: ESObject, proxy?: NavigationTransitionProxy) => {
      if (opacityOption) {
        opacityOption.opacity = this.opacity?.opacity ? this.opacity.opacity : 1;
      }
      if (this.scale && scaleOption) {
        if (this.scale?.x === 0) {
          scaleOption.x = 0;
        } else {
          scaleOption.x = this.scale?.x ? this.scale.x : scaleOption.x;
        }
        if (this.scale?.y === 0) {
          scaleOption.y = 0;
        } else {
          scaleOption.y = this.scale?.y ? this.scale.y : scaleOption.y;
        }
        if (this.scale?.centerX === 0) {
          scaleOption.centerX = 0;
        } else {
          scaleOption.centerX = this.scale?.centerX ? this.scale.centerX : scaleOption.centerX;
        }
        if (this.scale?.centerY === 0) {
          scaleOption.centerY = 0;
        } else {
          scaleOption.centerY = this.scale?.centerY ? this.scale.centerY : scaleOption.centerY;
        }
      }
      if (translateOption) {
        if (this.direction === Direction.RIGHT_TO_LEFT) {
          translateOption.x = '100%';
        } else if (this.direction === Direction.LEFT_TO_RIGHT) {
          translateOption.x = '-100%';
        } else if (this.direction === undefined) {
          translateOption.x = 0;
          translateOption.y = 0;
        } else if (this.direction === Direction.BOTTOM_TO_TOP) {
          translateOption.y = '100%';
        } else if (this.direction === Direction.TOP_TO_BOTTOM) {
          translateOption.y = '-100%';
        }
      }
    });
    exitHandle.passiveStart((translateOption?: TranslateOption, scaleOption?: ScaleOption,
      opacityOption?: OpacityOption, extendOption?: ESObject, proxy?: NavigationTransitionProxy) => {
      if (translateOption) {
        if (this.direction === Direction.RIGHT_TO_LEFT) {
          translateOption.x = 0;
        } else if (this.direction === Direction.LEFT_TO_RIGHT) {
          translateOption.x = 0;
        } else if (this.direction === undefined) {
          translateOption.x = 0;
          translateOption.y = 0;
        } else if (this.direction === Direction.BOTTOM_TO_TOP) {
          translateOption.y = 0;
        } else if (this.direction === Direction.TOP_TO_BOTTOM) {
          translateOption.y = 0;
        }
      }
      if (scaleOption) {
        scaleOption.x = 1;
        scaleOption.y = 1;
      }
      if (opacityOption) {
        opacityOption.opacity = 1;
      }
    });
    exitHandle.passiveFinish((translateOption?: TranslateOption, scaleOption?: ScaleOption,
      opacityOption?: OpacityOption, extendOption?: ESObject, proxy?: NavigationTransitionProxy) => {
      if (opacityOption) {
        opacityOption.opacity = this.opacity?.opacity ? this.opacity.opacity : 1;
      }
      if (this.scale && scaleOption) {
        if (this.scale?.x === 0) {
          scaleOption.x = 0;
        } else {
          scaleOption.x = this.scale?.x ? this.scale.x : scaleOption.x;
        }
        if (this.scale?.y === 0) {
          scaleOption.y = 0;
        } else {
          scaleOption.y = this.scale?.y ? this.scale.y : scaleOption.y;
        }
        if (this.scale?.centerX === 0) {
          scaleOption.centerX = 0;
        } else {
          scaleOption.centerX = this.scale?.centerX ? this.scale.centerX : scaleOption.centerX;
        }
        if (this.scale?.centerY === 0) {
          scaleOption.centerY = 0;
        } else {
          scaleOption.centerY = this.scale?.centerY ? this.scale.centerY : scaleOption.centerY;
        }
      }
      if (translateOption) {
        if (this.direction === Direction.RIGHT_TO_LEFT) {
          translateOption.x = -100;
        } else if (this.direction === Direction.LEFT_TO_RIGHT) {
          translateOption.x = 100;
        } else if (this.direction === undefined) {
          translateOption.x = 0;
          translateOption.y = 0;
        } else if (this.direction === Direction.BOTTOM_TO_TOP) {
          translateOption.y = -100;
        } else if (this.direction === Direction.TOP_TO_BOTTOM) {
          translateOption.y = 100;
        }
      }
    });
    exitHandle.passiveOnFinish((translateOption?: TranslateOption, scaleOption?: ScaleOption,
      opacityOption?: OpacityOption, extendOption?: ESObject, proxy?: NavigationTransitionProxy) => {
      if (translateOption) {
        translateOption.x = 0;
        translateOption.y = 0;
      }
      if (scaleOption) {
        scaleOption.x = 1;
        scaleOption.y = 1;
        scaleOption.centerX = '50%';
        scaleOption.centerY = '50%';
      }
      if (opacityOption) {
        opacityOption.opacity = 1;
      }
    });
    if (this.duration !== undefined) {
      enterHandle.duration = this.duration;
      exitHandle.duration = this.duration;
    }
    if (this.curve) {
      enterHandle.curve = this.curve;
      exitHandle.curve = this.curve;
    }
  }
}

