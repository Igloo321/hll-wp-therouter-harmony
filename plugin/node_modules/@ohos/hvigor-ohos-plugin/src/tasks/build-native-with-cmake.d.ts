import { FileId } from '../utils/cmake-invalidation-state.js';
import { AbstractBuildNative } from './abstract-build-native.js';
import { TargetTaskService } from './service/target-task-service.js';
/**
 * ohos native代码编译任务
 *
 * @since 2021/1/21
 */
export declare class BuildNativeWithCmake extends AbstractBuildNative {
    private _log;
    private readonly _moduleDir;
    private static readonly sanAbilitySet;
    constructor(taskService: TargetTaskService);
    initTaskDepends(): void;
    taskShouldDo(): boolean;
    protected doTaskAction(): Promise<void>;
    getInputFiles(dir: string, abi: string): Promise<FileId[]>;
    getOptionalOutputFiles(dir: string): FileId[];
    getRequiredOutputFiles(dir: string): FileId[];
    getHardOutputFiles(dir: string): FileId[];
    getToolchainFile(nativeCompiler: string | undefined, hmsAvailable: boolean): string;
    buildCommand(abiFilter: string): string[];
    /**
     * 从hvigor参数设置和build-profile.json5配置文件中收集cmake参数，并返回
     * @param abiType 当前运行环境的abi类型
     */
    addNativeArgs(abiType: string): string[];
    /**
     * 检查当前sdk版本是否支持传入的sanitizer参数
     * @param cmakeArgs 一系列cmake参数字符串所构成的数组
     */
    checkSanArgsSupported(cmakeArgs: string[]): void;
    /**
     * 检查是否设置了多个相互排斥的san参数
     * @param cmakeArgs 一系列cmake参数字符串所构成的数组
     */
    checkExclusiveSan(cmakeArgs: string[]): void;
}
