import { hapTasks } from '@ohos/hvigor-ohos-plugin';
import { hapPlugin } from "@therouter/plugin";

export default {
  system: hapTasks,
  plugins: [hapPlugin()]
}
