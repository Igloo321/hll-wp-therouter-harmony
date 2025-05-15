import { FileSet } from '@ohos/hvigor';
import { OhosLogger } from '../utils/log/ohos-logger.js';
import { ArkCompile } from './ark-compile.js';
export declare class PreviewerArkCompile extends ArkCompile {
    logger: OhosLogger;
    declareInputFiles(): FileSet;
    protected doTaskAction(): Promise<void>;
    /**
     * 处理module.json: 将ohmurl字段添加到收集到的har的abilities、extensionAbilities
     * @private
     */
    private addOhmurlToHarAbility;
    /**
     * 预览调试场景收集hap/hsp依赖的har的ability配置 修改其srcEntry为相对于hap/hsp的module.json的相对路径且需要添加ohmurl字段
     * @param {string} abilityTypeName
     * @private
     */
    private getDependencyHarAbility;
    initTaskDepends(): void;
}
