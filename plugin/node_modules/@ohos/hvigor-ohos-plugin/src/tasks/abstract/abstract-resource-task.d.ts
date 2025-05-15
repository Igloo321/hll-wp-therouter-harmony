import { TaskDetails } from '@ohos/hvigor';
import { RestoolCommandBuilder } from '../../builder/restool-command-builder.js';
import { RestoolConfigBuilder } from '../../builder/restool-file-config-builder.js';
import { TargetTaskService } from '../service/target-task-service.js';
import { OhosHapTask } from '../task/ohos-hap-task.js';
export declare abstract class AbstractResource extends OhosHapTask {
    restoolConfigBuilder: RestoolConfigBuilder;
    restoolCommandBuilder?: RestoolCommandBuilder;
    protected outputDir: string;
    protected constructor(taskService: TargetTaskService, taskDetails: TaskDetails);
    /**
     * get common restool config builder
     *
     * @returns {RestoolBuilderInterface} resTool命令构造器
     */
    protected getRestoolConfigBuilder(): RestoolConfigBuilder;
    /**
     * get common restool command builder
     *
     * @returns {RestoolBuilderInterface} resTool编译、链接命令构造器
     * @protected
     */
    protected initConfigTargetResource(): RestoolConfigBuilder;
    protected getRestoolCommandBuilder(): RestoolCommandBuilder;
    protected initCommandTargetResource(): RestoolCommandBuilder;
    /**
     * 获取Har资源的Map，包括local har和三方库的资源，需要根据用户对应target配置的resources来取
     * @param harResourceMap 用于存储Har资源的映射 <dependency path, resource dir / [resource dir]>
     */
    private getHarPathToResourcesDirMap;
}
