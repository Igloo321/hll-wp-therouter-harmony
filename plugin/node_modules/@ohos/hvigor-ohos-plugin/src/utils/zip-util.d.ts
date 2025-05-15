export declare class ZipUtil {
    private readonly BEGIN_TIME;
    constructor();
    /**
     * 读取zip包根目录的文件信息
     *
     * @param zipPath zip包路径
     * @param fileList  需要读取的文件列表
     */
    static readFileInZIP(zipPath: string, fileList: string[]): Promise<Map<string, string>>;
}
