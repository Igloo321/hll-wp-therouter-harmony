export interface ReflectClass {
  serviceName: string;
  functionName: string;
  singleton?: boolean;
  instance: ESObject;
}