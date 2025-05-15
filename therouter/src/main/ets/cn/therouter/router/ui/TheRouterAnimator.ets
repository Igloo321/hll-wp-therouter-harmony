import { AnimatorImplement } from "./AnimatorImplement";
import { EffectOptions, IAnimator, OpacityOption } from "./IAnimator";

export class TheRouterAnimator {
  effectOption: EffectOptions;

  constructor(effectOption: EffectOptions) {
    this.effectOption = effectOption;
  }

  toAnimator(): IAnimator {
    let animator: AnimatorImplement = new AnimatorImplement();
    if (this.effectOption.scale) {
      animator.scale = this.effectOption.scale;
    }
    if (this.effectOption.opacity) {
      animator.opacity = this.effectOption.opacity as OpacityOption;
    }
    animator.direction = this.effectOption.direction;
    if (this.effectOption.duration != undefined) {
      animator.duration = this.effectOption.duration;
    }
    if (this.effectOption.curve) {
      animator.curve = this.effectOption.curve;
    }
    return animator;
  }
}