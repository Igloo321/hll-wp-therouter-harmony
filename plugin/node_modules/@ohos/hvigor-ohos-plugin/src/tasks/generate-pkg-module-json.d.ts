import { TargetTaskService } from './service/target-task-service.js';
import { OhosHapTask } from './task/ohos-hap-task.js';
export declare class GeneratePkgModuleJson extends OhosHapTask {
    protected readonly jsonPath: string;
    protected readonly packageHapJsonPath: string;
    constructor(taskService: TargetTaskService);
    protected doTaskAction(): Promise<void>;
    initTaskDepends(): void;
}
