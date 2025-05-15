import {FileUtil} from '@ohos/hvigor';
import fs from 'fs';

export default class TheRouterFileUtil extends FileUtil {
  static rmSync(path: fs.PathLike, options?: fs.RmOptions) {
    return fs.rmSync(path, options);
  }

  static unlinkSync(path: fs.PathLike) {
    return fs.unlinkSync(path);
  }

  static readdirSync(path: fs.PathLike,
                     options?: {
                       encoding: BufferEncoding | null,
                       withFileTypes?: false | undefined,
                       recursive?: boolean | undefined
                     }) {
    return fs.readdirSync(path, options);
  }
};
