import { AnimatorHandle } from "./AnimatorHandle";

export interface IAnimator {
  effect(enterHandle: AnimatorHandle, exitHandle: AnimatorHandle): void;

  interactive?(handle: AnimatorHandle): void;
}

export interface EffectOptions {
  direction?: Direction;
  opacity?: OpacityOption;
  scale?: ScaleOption;
  duration?: number;
  curve?: Curve | string | ICurve;
}

export class TranslateOption {
  x?: number | string;
  y?: number | string;
  z?: number | string;
}

export class ScaleOption {
  x?: number;
  y?: number;
  centerX?: number | string;
  centerY?: number | string;
}

/**
 * 透明度
 */
export class OpacityOption {
  opacity?: number;
}

export enum Direction {
  RIGHT_TO_LEFT,
  LEFT_TO_RIGHT,
  BOTTOM_TO_TOP,
  TOP_TO_BOTTOM
}
