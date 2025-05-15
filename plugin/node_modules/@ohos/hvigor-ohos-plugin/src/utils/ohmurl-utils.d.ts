/**
 * ohmurl相关方法
 *
 * @since 2024/04/19
 */
import { PkgContextInfoOpt } from '@ohos/hvigor-arkts-compose';
import { TargetTaskService } from '../tasks/service/target-task-service.js';
import { Dependency } from '../project/dependency/core/dependency-interface.js';
/**
 * @normalized:<isSO>&<module name>&<bundle name>&<标准import路径>&<version>
 *
 * @param pkgInfo 信息表中收集的信息
 */
export declare function generateOhmUrl(pkgInfo: PkgContextInfoOpt): string;
/**
 * @normalized:<isSO>&<module name>&<bundle name>&<标准import路径>&<version>
 *
 * @param pkgInfo 信息表中收集的信息
 * @param sourceFile  文件路径sourceFile
 */
export declare function generateOhmUrlForSourceFile(pkgInfo: PkgContextInfoOpt, sourceFile: string): string;
/**
 * 去除主入口文件的后缀
 *
 * @param packageMainName
 */
export declare function removeSuffix(packageMainName: string): string;
/**
 * 生成hap/hsp收集到依赖har中的ability-srcEntry的ohmurl
 *
 * @param targetService
 * @param moduleName
 * @param dependency
 * @param originSrcEntry
 */
export declare function generateOhmurlForSrcEntry(targetService: TargetTaskService, moduleName: string, dependency: Dependency, originSrcEntry: string): string;
