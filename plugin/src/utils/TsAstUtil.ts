import {
  Expression,
  Project,
  ScriptTarget,
  SourceFile,
  SyntaxKind
} from 'ts-morph';
import {FileUtil} from '@ohos/hvigor';
import {Logger, PluginError} from '../common/Logger';

export let project: Project | null = null;

export class TsAstUtil {
  static getSourceFile(filePath: string): SourceFile {
    if (!FileUtil.exist(filePath)) {
      // Record error but don't throw exception immediately
      Logger.warn(`File not found: ${filePath}`);

      // Try to handle common import path issues
      // 1. Check for abnormal path formats, such as extra dots or slashes
      const normalizedPath = filePath.replace(/\.+\/+/g, './');
      if (normalizedPath !== filePath && FileUtil.exist(normalizedPath)) {
        Logger.info(`Using normalized path instead: ${normalizedPath}`);
        filePath = normalizedPath;
      } else {
        // If file still not found, throw exception
        throw new Error(`File not found: ${filePath}`);
      }
    }

    if (!project) {
      project = new Project({
        compilerOptions: {target: ScriptTarget.ES2021}
      });
    }
    return project.addSourceFileAtPath(filePath);
  }

  /**
   * @description clear project
   **/
  static clearProject() {
    project = null;
  }

  /**
   * @description parse constant value
   * @param sourceFile 资源文件
   * @param variableName 变量名/类名
   * @param propertyName 属性名
   * @return string 常量值
   */
  static parseConstantValue(sourceFile: SourceFile, variableName: string, propertyName?: string): string {
    let result: string | Expression;
    // Determine whether it is a constant or an object based on the presence of propertyName
    if (propertyName) {
      // object
      let classInstance = sourceFile.getClasses().find((classes) => {
        return classes.getName() === variableName;
      });
      if (!classInstance) {
        throw new Error(`Unknown class '${variableName}'`);
      }
      let property = classInstance.getProperties().find((properties) => {
        return properties.getName() === propertyName;
      });
      if (!property) {
        throw new Error(`Unknown property '${propertyName}'`);
      }
      result = property.getInitializer()!;
    } else {
      // constant
      let constant = sourceFile.getVariableDeclarations().find(declaration => {
        return declaration.getName() === variableName;
      });
      if (!constant) {
        throw new Error(`Unknown constant '${variableName}'`);
      }
      result = constant.getInitializer()!;
    }
    if (result.getKind() !== SyntaxKind.StringLiteral) {
      Logger.error(PluginError.ERR_INVALID_STRING_VALUE, variableName);
      throw new Error('Invalid constants value, only string literal is supported, variableName:' + variableName);
    }
    return result.asKind(SyntaxKind.StringLiteral)?.getLiteralValue()!;
  }

  static parseCrossModuleVariable(scanDir: string) {
    let sourceFiles = project!.addSourceFilesAtPaths(`${scanDir}/**/*.ets`);
    const exportMap = new Map<string, string[]>(); // key: file path, value: exported variables
    for (let sourceFile of sourceFiles) {
      const exportedNames = this.getExportedVariables(sourceFile);
      if (exportedNames.length > 0) {
        exportMap.set(sourceFile.getFilePath(), exportedNames);
      }
    }
    return exportMap;
  }

  // Get all exported variables from the file
  private static getExportedVariables(sourceFile: SourceFile): string[] {
    const exportSymbols: string[] = [];
    let exportKeywordNodes = sourceFile.getDescendantsOfKind(SyntaxKind.ExportKeyword);
    exportKeywordNodes.forEach((node) => {
      let parentNodeKind = node.getParent()?.getKind();
      switch (parentNodeKind) {
        case SyntaxKind.VariableStatement:
          let variableStatement = node.getParent()?.asKind(SyntaxKind.VariableStatement)!;
          let variableNames = variableStatement.getDeclarationList().getDeclarations().map((declaration) => {
            return declaration.getName();
          });
          exportSymbols.push(...variableNames);
          break;
        case SyntaxKind.ClassDeclaration:
          let classDeclaration = node.getParent();
          let className = classDeclaration?.asKind(SyntaxKind.ClassDeclaration)?.getName();
          exportSymbols.push(className!);
          break;
      }
    });
    return exportSymbols;
  }
}
