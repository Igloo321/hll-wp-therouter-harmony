import { OpacityOption, ScaleOption, TranslateOption } from "./IAnimator";

export class AnimatorHandle {
  translateOption?: TranslateOption;
  scaleOption?: ScaleOption;
  opacityOption?: OpacityOption;
  extendOption?: ESObject;
  startCallback?: AnimatorCallback;
  finishCallback?: AnimatorCallback;
  onFinishCallback?: AnimatorCallback;
  passiveStartCallback?: AnimatorCallback;
  passiveFinishCallback?: AnimatorCallback;
  passiveOnFinishCallback?: AnimatorCallback;
  customAnimationCallback?: AnimatorCallback;
  passiveCustomAnimationCallback?: AnimatorCallback;
  timeout?: number;
  duration: number = 250;
  curve: Curve | string | ICurve = Curve.EaseIn;
  interactive: boolean = false;
  operation?: NavigationOperation;
  proxy?: NavigationTransitionProxy;
  startOffset?: number;
  actionStartCallback?: (event: GestureEvent) => void;
  updateProgressCallback?: InteractiveCallback;
  actionEndCallback?: InteractiveCallback;
  actionCancelCallback?: InteractiveCancelCallback;

  constructor(translateOption?: TranslateOption, scaleOption?: ScaleOption, opacityOption?: OpacityOption,
    extendOption?: ESObject) {
    if (translateOption) {
      this.translateOption = translateOption;
    }
    if (scaleOption) {
      this.scaleOption = scaleOption;
    }
    if (opacityOption) {
      this.opacityOption = opacityOption;
    }
    this.extendOption = extendOption;
  }

  /**
   * custom transition start callback
   * define translate/scale/opacity setting of beginning state
   * @param callback
   * @returns
   */
  start(callback: AnimatorCallback): AnimatorHandle {
    this.startCallback = callback;
    return this;
  }

  /**
   * custom transition finish callback
   * define translate/scale/opacity setting of ending state
   * @param callback
   * @returns
   */
  finish(callback: AnimatorCallback): AnimatorHandle {
    this.finishCallback = callback;
    return this;
  }

  /**
   * custom transition onFinish callback
   * define translate/scale/opacity setting after ending state
   * @param callback
   * @returns
   */
  onFinish(callback: AnimatorCallback): AnimatorHandle {
    this.onFinishCallback = callback;
    return this;
  }

  /**
   * custom animate
   * @param callback
   * @returns
   */
  customAnimation(callback: AnimatorCallback): AnimatorHandle {
    this.customAnimationCallback = callback;
    return this;
  }

  doStart(): void | undefined {
    return this.startCallback?.(this.translateOption, this.scaleOption, this.opacityOption, this.extendOption);
  }

  doFinish(): void | undefined {
    return this.finishCallback?.(this.translateOption, this.scaleOption, this.opacityOption, this.extendOption);
  }

  doOnFinish(): void | undefined {
    return this.onFinishCallback?.(this.translateOption, this.scaleOption, this.opacityOption, this.extendOption);
  }

  doCustomAnimation(proxy: NavigationTransitionProxy): void | undefined {
    return this.customAnimationCallback?.(this.translateOption, this.scaleOption, this.opacityOption,
      this.extendOption, proxy);
  }

  /**
   * custom transition of passive triggered start callback
   * @param callback
   * @returns
   */
  passiveStart(callback: AnimatorCallback): AnimatorHandle {
    this.passiveStartCallback = callback;
    return this;
  }

  /**
   * custom transition of passive triggered finish callback
   * @param callback
   * @returns
   */
  passiveFinish(callback: AnimatorCallback): AnimatorHandle {
    this.passiveFinishCallback = callback;
    return this;
  }

  /**
   * custom transition of passive triggered onFinish callback
   * @param callback
   * @returns
   */
  passiveOnFinish(callback: AnimatorCallback): AnimatorHandle {
    this.passiveOnFinishCallback = callback;
    return this;
  }

  /**
   * custom passive animate
   * @param callback
   * @returns
   */
  passiveCustomAnimation(callback: AnimatorCallback): AnimatorHandle {
    this.passiveCustomAnimationCallback = callback;
    return this;
  }

  doPassiveStart(): void | undefined {
    return this.passiveStartCallback?.(this.translateOption, this.scaleOption, this.opacityOption,
      this.extendOption);
  }

  doPassiveFinish(): void | undefined {
    return this.passiveFinishCallback?.(this.translateOption, this.scaleOption, this.opacityOption,
      this.extendOption);
  }

  doPassiveOnFinish(): void | undefined {
    return this.passiveOnFinishCallback?.(this.translateOption, this.scaleOption, this.opacityOption,
      this.extendOption);
  }

  doPassiveCustomAnimation(proxy: NavigationTransitionProxy): void | undefined {
    return this.passiveCustomAnimationCallback?.(this.translateOption, this.scaleOption, this.opacityOption,
      this.extendOption, proxy);
  }

  /**
   * interactive transition of gesture triggered start callback
   * @param callback
   */
  actionStart(callback: (event: GestureEvent) => void) {
    this.actionStartCallback = callback;
  }

  doActionStart(event: GestureEvent) {
    if (event.fingerList[0]) {
      this.startOffset = event.fingerList[0].localX;
    }
    this.actionStartCallback?.(event);
    this.interactive = true;
  }

  /**
   * interactive transition of gesture triggered update progress callback
   * @param callback
   */
  updateProgress(callback: InteractiveCallback) {
    this.updateProgressCallback = callback;
  }

  doUpdateProgress(event: GestureEvent) {
    this.updateProgressCallback?.(event, this.proxy, this.operation, this.startOffset);
  }

  /**
   * interactive transition of gesture triggered end callback
   * @param callback
   */
  actionEnd(callback: InteractiveCallback) {
    this.actionEndCallback = callback;
  }

  doActionEnd(event: GestureEvent) {
    this.interactive = false;
    this.actionEndCallback?.(event, this.proxy, this.operation, this.startOffset);
  }

  /**
   * interactive transition of gesture triggered cancel callback
   * @param callback
   */
  actionCancel(callback: InteractiveCancelCallback) {
    this.actionCancelCallback = callback;
  }

  doActionCancel() {
    this.actionCancelCallback?.();
    this.proxy?.cancelTransition?.();
    this.proxy = undefined;
    this.interactive = false;
  }

  recoverState() {
    this.proxy = undefined;
    this.operation = undefined;
    this.startOffset = undefined;
    this.interactive = false;
  }
}

export type AnimatorCallback = (translateOption?: TranslateOption, scaleOption?: ScaleOption,
  opacityOption?: OpacityOption, extendOption?: ESObject, proxy?: NavigationTransitionProxy) => void | undefined;

type InteractiveCallback = (event: GestureEvent, proxy?: NavigationTransitionProxy,
  operation?: NavigationOperation, startOffset?: number) => void;

type InteractiveCancelCallback = () => void;
