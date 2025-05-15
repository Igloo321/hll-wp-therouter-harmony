import { TheRouter } from "../../TheRouter";

export function inject(obj: ESObject, stackId?: string) {
  TheRouter.getPathStack(stackId)?.registerPage(obj)
  Object.keys(obj).forEach(key => {
    const params = getAutowiredKey(obj, key)
    if (params) {
      obj[key] = TheRouter.getCurrentParam(stackId)[params]
    }
  });
}

function getAutowiredKey(target: ESObject, key: string): string | undefined {
  const array: Array<ESObject> = target.__annotatedProperties
  if (array) {
    for (let i = 0; i < array.length; i++) {
      if (array[i].fieldName === key) {
        return array[i].annotationParam
      }
    }
  }
  return undefined
}
