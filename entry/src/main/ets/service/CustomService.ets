import { IServiceProvider, Action, ServiceProvider } from '@therouter/library';
import { BaseConstant } from 'base';

export interface TempObj {
  paramA: string,
  paramB: number
}

export interface IService {
  testConsole(): void;

  testFunWithReturn(): string;

  testFunWithParams(str: string, num: number, bool: boolean, obj: TempObj): string | number;

  testAsyncFunction(): Promise<string>;
}

// 所有的ServiceProvider必须实现 IServiceProvider 接口
// 多次添加重复serviceName，框架会保证安全，在编译时报错
@ServiceProvider({ serviceName: BaseConstant.CLASS_SERVICE, singleton: true })
export class CustomService implements IService, IServiceProvider {
  static count = 0;

  constructor() {
    CustomService.count++;
  }

  testConsole(): void {
  }

  // action既可以放在ServiceProvider里面，也可以单独放在任意类中，但不能是top-level函数，这一点与Android不同
  // 多次添加重复action，每个action的方法都会执行，但最终只会返回优先级最高的方法的返回值
  @Action({ action: BaseConstant.TEST_FUN_WITH_RETURN })
  testFunWithReturn(): string {
    return '当前类被创建' + CustomService.count + '次';
  }

  testFunWithParams(str: string, num: number, bool: boolean, obj: TempObj) {
    return obj.paramA || obj.paramB;
  }

  async testAsyncFunction(): Promise<string> {
    return new Promise((resolve) => {
      resolve('Calling asynchronous service testAsyncFun');
    });
  }
}

// 所有的ServiceProvider必须实现 IServiceProvider 接口
// 多次添加重复serviceName，框架会保证安全，在编译时报错
@ServiceProvider({ serviceName: BaseConstant.CLASS_SERVICE2, singleton: false })
export class TestService implements IService, IServiceProvider {
  static count = 0;

  constructor() {
    TestService.count++;
  }

  testConsole(): void {
  }

  testFunWithReturn(): string {
    return '当前类被创建' + TestService.count + '次';
  }

  testFunWithParams(str: string, num: number, bool: boolean, obj: TempObj) {
    return obj.paramA || obj.paramB;
  }

  async testAsyncFunction(): Promise<string> {
    return new Promise((resolve) => {
      resolve('测试Promise');
    });
  }

  // action既可以放在ServiceProvider里面，也可以单独放在任意类中，但不能是top-level函数，这一点与Android不同
  // 多次添加重复action，每个action的方法都会执行，但最终只会返回优先级最高的方法的返回值
  @Action({ action: BaseConstant.TEST_FUN_WITH_PARAMS, priority: 10 })
  public test(par: string): string {
    return "优先级更高的Action：" + par;
  }
}

export class TestAction {
  // action既可以放在ServiceProvider里面，也可以单独放在任意类中，但不能是top-level函数，这一点与Android不同
  // 多次添加重复action，每个action的方法都会执行，但最终只会返回优先级最高的方法的返回值
  @Action({ action: BaseConstant.TEST_FUN_WITH_PARAMS })
  public test(par: string): string {
    return "返回入参：" + par;
  }
}
