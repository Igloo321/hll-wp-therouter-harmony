import { Module } from '@ohos/hvigor';
import { ModuleTargetData } from '../tasks/data/hap-task-target-data.js';
import { TargetTaskService } from '../tasks/service/target-task-service.js';
import { OhosLogger } from './log/ohos-logger.js';
import { ProjectBuildProfile } from '../options/build/project-build-profile.js';
import { ProjectModel } from '../model/project/project-model.js';
export declare const resolveHookDependency: (name: string, target: string) => string;
export declare const dynamicResolveResourceTasks: (service: TargetTaskService, module: Module) => void;
export declare const warnCreateBuildProfileTask: (targetData: ModuleTargetData, targetService: TargetTaskService, log: OhosLogger) => void;
/**
 * 判断当前apiVersion是否高于limitApiVersion
 *
 * @param targetData
 * @param limitApiVersion
 */
export declare const limitMinApiVersion: (targetData: ModuleTargetData, limitApiVersion: number) => boolean;
/**
 * 重新加载依赖
 *
 * @param targetService
 *
 */
export declare const declareReloadDepends: (targetService: TargetTaskService) => string[];
/**
 * 获取当前buildModeName
 */
export declare const getBuildModeName: () => string;
/**
 * 判断是否需要编译卡片
 * @param formJsonPathArr
 */
export declare const shouldCompileArkTsWidget: (formJsonPathArr: string[]) => boolean;
/**
 * 检测是否开了混淆，没开的话给出warning提示
 * @param targetService
 * @param _log
 */
export declare const doObfuscationCheck: (targetService: TargetTaskService, _log: OhosLogger) => void;
/**
 * 获取bundleType
 * @param product
 * @param projectModel
 */
export declare const getBundleType: (product: ProjectBuildProfile.ProductBuildOpt, projectModel: ProjectModel) => string;
/**
 * 判断是否为元服务工程
 * @param product
 * @param projectModel
 */
export declare const isAtomicServiceProject: (product: ProjectBuildProfile.ProductBuildOpt, projectModel: ProjectModel) => boolean;
