export declare function getJson5Obj(json5path: string, encodingStr?: string): any;
/**
 * 合并两个String json的数据
 * @param data1
 * @param data2
 */
export declare function mergeStringJson(data1: any, data2: any): {
    string: StringRes[];
};
export interface StringRes {
    name: string;
    value: string;
}
