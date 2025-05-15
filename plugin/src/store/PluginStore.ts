export default class PluginStore implements IPluginStore {
  private static instance: IPluginStore | null = null;
  public variableCache: Map<string, Map<string, string[]>> = new Map();
  public projectFilePath: string = '';
  public hspModuleNames: string[] = []

  public static clear() {
    this.instance = null;
  }

  public static getInstance() {
    if (!this.instance) {
      this.instance = new PluginStore();
    }
    return this.instance;
  }

}

interface IPluginStore {
  /**
   * @description Export variable cache
   * @example Map<module name, Map<file path, Exported variable name[]>>
   */
  variableCache: Map<string, Map<string, string[]>>;
  projectFilePath: string;
  hspModuleNames: string[];
}
