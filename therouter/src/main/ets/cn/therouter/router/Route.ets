export function Route(params: RouterParams) {
  return Object;
}

export interface RouterParams {
  path: string;
  description?: string;
  launchMode?: string;
  params?: string[];
}

export function Autowired(name?: string) {
  return (target: ESObject, propertyKey: string) => {
    if (!target.__annotatedProperties) {
      target.__annotatedProperties = [];
    }
    if (name == undefined || name == null || name.length == 0) {
      name = propertyKey
    }
    target.__annotatedProperties.push({
      fieldName: propertyKey,
      annotationParam: name
    });
  };
}

export function Action(p: ActionParams) {
  return (target: ESObject, propertyKey: string, descriptor: PropertyDescriptor) => {
  };
}

export interface ActionParams {
  action: string,
  priority?: number
}

export function ServiceProvider(p: ServiceProviderParams) {
  return Object;
}

export interface ServiceProviderParams {
  serviceName: string;
  singleton?: boolean
}

export interface IServiceProvider {}