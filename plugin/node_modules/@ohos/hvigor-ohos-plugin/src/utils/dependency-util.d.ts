import { DependencyEnum } from '../project/dependency/core/dependency-interface.js';
import { ModuleTaskService } from '../tasks/service/module-task-service.js';
import { PackageJson } from 'type-fest';
export type OhosPackageJson = PackageJson & {
    ohos?: {
        org: string;
        artifactType: string;
    };
    artifactType?: string;
};
export declare function getJson5Obj(filePath: string): any;
/**
 * 最小化hsp中的依赖，只保留hsp中的hsp相关依赖并删除devDependencies中的依赖
 *
 * @param packageJsonObj  oh-package.json5文件对象
 * @param service  ModuleTaskService
 * @param packageManagerPath  oh-package.json5的路径
 */
export declare function minimizeHspDependencies(packageJsonObj: any, service: ModuleTaskService, packageManagerPath: string): void;
/**
 * 打包hsp时dependencies依赖会排除hsp以外的其他依赖
 *
 * @param dependencyEnum 依赖类型
 * @param service  ModuleTaskService
 * @param packageManagerPath  oh-package.json5的路径
 * @private
 */
export declare function getDependenciesWithoutHar(dependencyEnum: DependencyEnum, service: ModuleTaskService, packageManagerPath: string): any;
