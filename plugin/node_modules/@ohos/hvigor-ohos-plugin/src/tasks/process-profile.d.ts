import { FileSet } from '@ohos/hvigor';
import { TaskInputValue } from '@ohos/hvigor';
import { TargetTaskService } from './service/target-task-service.js';
import { OhosHapTask } from './task/ohos-hap-task.js';
/**
 * 处理module.json
 * 1. 写入ark字段
 * 2. 写入compileMode字段
 * 3. 替换target相关逻辑
 *  3.1 读取target的deviceType, 替换到module.json中
 *
 * @since 2022/1/10
 */
export declare class ProcessProfile extends OhosHapTask {
    private readonly _arkEnable;
    private readonly _deviceTypes;
    private readonly _intermediatesMergeProfile;
    private readonly _processedModuleJson;
    private _moduleTargetData;
    private _pathInfo;
    private _dependencies;
    private harExtensionAbilities;
    constructor(taskService: TargetTaskService);
    initTaskDepends(): void;
    private shouldCollectDependenciesAbilities;
    beforeAlwaysAction(): Promise<void>;
    private validateExtensionAbilities;
    protected doTaskAction(): void;
    declareInputs(): Map<string, TaskInputValue>;
    declareInputFiles(): FileSet;
    declareOutputFiles(): FileSet;
    private mergeHspLibs;
    private collectHarAbilities;
    private addHarAbilitiesToModuleJson;
    /**
     * 构建hap、hsp时支持将直接、间接依赖har的module.json的abilities以及extensionAbilities合并到最终的hap、hsp产物module.json中，合并abilities时如果有name相同的则进行报错
     * @private
     */
    private processDependencyHarAbility;
    private findDuplicatedAbilityNames;
    /**
     * 检查依赖har中abilities数组的ability对象是否存在重复name
     * @private
     * @param moduleAndDepAbilities
     */
    private checkDuplicateAbility;
}
