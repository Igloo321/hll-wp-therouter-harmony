import { FileSet, TaskInputValue } from '@ohos/hvigor';
import { OhosLogger } from '../../utils/log/ohos-logger.js';
import { TargetTaskService } from '../service/target-task-service.js';
import { AbstractProcessHarArtifacts } from '../abstract/abstract-process-har-artifacts.js';
/**
 * 收集打包需要用的构建产物
 */
export declare class ProcessHarArtifacts extends AbstractProcessHarArtifacts {
    protected logger: OhosLogger;
    private readonly arkTsCompiledOutputDir;
    private readonly abilities;
    private readonly extensionAbilities;
    private readonly appOptObj;
    private readonly targetModuleOptObj;
    private readonly targetJsonPath;
    private readonly compiledAbcOutputDir;
    private readonly declaredFilesOutputDir;
    private readonly ohPkgMetadataResDir;
    private nonEntryImportees;
    private compiledPackageNames;
    private npmImportees;
    constructor(taskService: TargetTaskService);
    get isBundledDependencies(): boolean;
    get isNativeStripped(): boolean;
    declareInputs(): Map<string, TaskInputValue>;
    declareInputFiles(): FileSet;
    beforeAlwaysAction(): Promise<void>;
    initTaskDepends(): void;
    addSpecialDepends(): void;
    copyCompiledSourceFileToTempDir(): void;
    /**
     * 处理字节码har的bundledDependencies源码依赖资源
     */
    processBundleDepRes(): void;
    /**
     * 拷贝字节码har的bundledDependencies源码依赖的资源目录
     * @param resourcesDir
     * @param dependency
     * @private
     */
    private copyBundledDepRes;
    copyOtherGenerateFiles(): void;
    /**
     * 处理har包时需要将中间产物资源目录下的routerMap拷贝至cache目录下
     * @private
     */
    processHarRouterMap(): void;
    /**
     * 对于字节码HAR，由于代码已经编进abc，且，该abc在集成的时候是直接合并到hap/hsp中，不再有源码参与编译的流程
     * 所以，在集成的时候，就造成了字节码HAR本身的workers、动态import对应文件的ohmurl丢失，导致运行时报错
     * 这里要将这些丢失的ohmurl写入declarationEntry，在集成的时候写入loader.json
     * @param pkgJson
     * @private
     */
    private processDeclarationEntry;
    private collectImportees;
    private collectNonEntryImportees;
    /**
     * 如果开启了bundledDependencies，收集三方库和已compiled的源码HAR
     * @private
     */
    private collectCompiledAndNpmImportees;
    /**
     * 判断有无c++产物，目前的逻辑，除了以.a结尾的，都当做c++产物处理
     * @private
     */
    private hasSoFile;
    private copyPkgTypesFilePath;
    private forEachDependencies;
    /**
     * 设置pkgJson中的dependencyPkgVersion
     * @param pkgJson
     * @private
     */
    private setDependencyPkgVersion;
    processPackageJson(): void;
    /**
     * 删除dependencies或dynamicDependencies中的源码har依赖,保留直接或间接的字节码har和hsp
     * @param dependencyEnum
     * @param pkgJson
     * @private
     */
    private deleteOhPkgDep;
    /**
     * 收集本地或远程源码har依赖动态import(sources/packages)的ohmurl写入declarationEntry
     * @param pkgContextInfos
     * @param declarationEntry
     * @private
     */
    private collectRuntimeOnlyOhmurl;
    /**
     * 获取worker/runtimeOnly-sources/routerMapObj-pageSourceFile的ohmurl并写入declarationEntry
     * @param dep2ConfigMap
     * @param pkgContextInfos
     * @param declarationEntry
     * @private
     */
    private collectConfigOhmurl;
    protected doTaskAction(): Promise<void>;
    /**
     * 处理混淆har场景下的页面动态路由pageSourceFile
     * 拼接模块真实name,修改原始文件后缀,路径分隔符标准化处理
     * @param moduleModel
     * @param routerMapObj
     * @param obfNameCacheJsonObj
     * @private
     */
    private getObfuscatedPageSourceFile;
    /**
     * 收集字节码har的abilities数组中ability对象的srcEntry并转换为ohmurl写入declarationEntry
     *
     * @param pkgContextInfos
     * @param declarationEntry
     * @private
     */
    private collectByteCodeHarAbilityOhmurl;
    /**
     * 处理混淆har模块ability
     * 1..har产物的module.json/abilities/srcEntry的后缀转换成.js
     * 2.若开启路径混淆,.har产物的module.json/abilities/srcEntry根据混淆的namecache转换成混淆后的js路径
     * 3.useTsHar时上述1/2场景中.js后缀修改为.ts
     * @private
     */
    processObfuscatedHarAbility(): void;
    /**
     * 根据混淆配置映射获取混淆后的ability-srcEntry路径
     * @param originalSrcEntry
     * @param obfNameCacheJsonObj
     * @private
     */
    private getObfuscatedHarAbilitySrcEntry;
    /**
     * 获取模块混淆配置映射对象
     * @private
     */
    private getObfNameCacheObj;
}
