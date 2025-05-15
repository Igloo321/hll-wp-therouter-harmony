import { PkgSelection } from '../options/build/build-opt.js';
import { Dependency } from '../project/dependency/core/dependency-interface.js';
import { TargetTaskService } from '../tasks/service/target-task-service.js';
/**
 * 为依赖生成cmake脚本生成依赖模型
 */
export declare class PackageResolver {
    name: string;
    version: string;
    path: string;
    headerPath: string[];
    libsPath: string;
    archs: ArchResolver[];
    cmakeDir: string;
    canonicalName: string;
    abiList: string[];
    service?: TargetTaskService;
    matchRule?: PkgSelection;
    linkLibrariesMap: Map<string, string>;
    constructor(dependency: Dependency, abiList: string[], cmakeDir: string, service?: TargetTaskService);
    static getInstance(dep: Dependency, abiList: string[], cmakeDir: string, service?: TargetTaskService): PackageResolver;
    build(): Promise<void>;
    addLibrariesInfo(ohPackageJson5Path: string, isLocal: boolean): void;
    private getHeaderPath;
}
export declare class ArchResolver {
    arch: string;
    path: string;
    pkg: PackageResolver;
    libraries: LibraryResolver[];
    cmakeFile: string;
    cmakeText: string;
    constructor(arch: string, pkg: PackageResolver);
    static getInstance(arch: string, pkg: PackageResolver): ArchResolver;
    build(): Promise<this>;
    /**
     * 本地模块读取cmake codemodel
     * 远程模块读取安装目录
     */
    calLibraries(): Promise<LibraryResolver[]>;
}
export declare class LibraryResolver {
    nameOnDisk: string;
    name: string;
    path: string;
    arch: ArchResolver;
    text: string;
    constructor(name: string, soPath: string, arch: ArchResolver);
    static getInstance(name: string, soPath: string, arch: ArchResolver): LibraryResolver;
    private genPkgText;
    private tryGetLibraryName;
}
