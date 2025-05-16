Harmony 动态路由框架：TheRouter
---

[![Hex.pm](https://img.shields.io/hexpm/l/plug.svg)](https://www.apache.org/licenses/LICENSE-2.0)
[![Language](https://img.shields.io/badge/Language-ArkTS-green)](https://kotlinlang.org/)
[![Wiki](https://img.shields.io/badge/Wiki-open-green)](https://therouter.cn/harmony)

Harmony | [Android](https://github.com/HuolalaTech/hll-wp-therouter-android) | [iOS](https://github.com/HuolalaTech/hll-wp-therouter-ios) | [中文官网](https://therouter.cn) 

### 一、功能介绍

TheRouter Harmony 核心功能具备如下能力：

Navigator：  

* 支持 `Path` 与页面多对一关系或一对一关系，可用于解决多端path统一问题
* 页面 `Path` 支持正则表达式声明
* 支持 `json` 格式路由表导出
* 路由表支持为页面添加注释说明
* 支持动态下发 `json` 路由表，降级任意页面为H5
* 支持页面跳转拦截处理
* 支持使用路由跳转到第三方 SDK 中的页面

ServiceProvider：  

* 支持跨模块依赖注入
* 支持自定义注入项的创建规则，依赖注入可自定义参数
* 支持注入对象缓存，多次注入，只会 new 一次对象

ActionManager：  

* 支持全局回调配置
* 支持多对一链式响应
* 支持优先级响应
* 方法支持返回值与入参
* 支持记录调用路径，解决调试期观察者模式无法追踪 `Observable` 的问题


### 二、使用介绍

**更多详细使用文档请查看项目官网 [therouter.cn](https://therouter.cn/harmony)**

### 2.1 开始之前
如果你的是新项目，请先记住一点：**plugin、router 两个依赖的版本号必须保持一致**，请继续往下看接入步骤。   

TheRouter 的版本分为两种，稳定版和 rc版，一般不追求新功能我们就用稳定版就行，可以在官网看到最新的版本号和各种版本的说明：[https://therouter.cn/docs/2022/09/06/01](https://therouter.cn/docs/2022/09/06/01)

#### 2.2 引入依赖 

在工程根目录命令行引入依赖库和插件库（必须全部依赖，不能只使用其中一个）。  

```shell
// 引入代码库依赖
ohpm i @therouter/library   

// 引入插件依赖
npm i @therouter/plugin
```

#### 2.3 接入编译插件  

1. 打开项目根目录的 `hvigor/hvigor-config.json5`，检查 `dependencies` 中是否已经加入了依赖，一般为 `"@therouter/plugin": "x.x.x"`。  
2.  打开工程 **所有** 模块（hsp、hap、har）的 `hvigorfile.ts` 文件。  
3.  在 `plugins` 中加入如下对应的依赖  

```typescript
// 如果是 hsp，则类似如下依赖
import { hspPlugin } from "@therouter/plugin";
export default {
  plugins: [hspPlugin()]
}

// 如果是 har，则类似如下依赖
import { harPlugin } from "@therouter/plugin";
export default {
  plugins: [harPlugin()]
}

// 如果是 hap，则类似如下依赖
import { hapPlugin } from "@therouter/plugin";
export default {
  plugins: [hapPlugin()]
}
```

#### 2.4 初始化

在项目入口的 `UIAbility` 的 `onCreate()` 中加入如下代码：

```typescript
onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    TheRouter.init(this.context);
}
```

#### 2.5 定义页面容器  

TheRouter 按照华为推荐方案，基于系统 Navigation 实现，所以必须在页面中定义一个容器项 `TheRouterPage`，建议创建一个完全新的类作为入口并在 `/resources/base/profile/main_pages.json` 中配置这个类，复制如下代码：  

```typescript
import { TheRouterPage } from '@therouter/library';

@Entry
@Component
struct Index {
  build() {
    RelativeContainer() {
      TheRouterPage({
        stackId: 'XXXX',  //【必传】可以自定义当前stack的名字，每个stack必须唯一
        root: 'path'  // 【必传】当前应用的首页 path，推荐按照一定格式定义页面path
		// 还有很多可选参数，详情请见文档
      });
    }
    .height('100%')
    .width('100%')
  }
}
```

#### 2.6 声明与跳转

给需要跳转的页面加上路由表声明

```typescript
@Route({path : "http://therouter.com/home"})
export struct HomePage {
	xxx
}
```

在需要跳转页面的位置调用如下代码：

```typescript
TheRouter
	.build("http://therouter.com/home")  
	.withString('k', 'v') // 向落地页传参数（如果没参数，可不调用）
	.with({ hello: 'world' }) // 另一种方式传参
	.navigation()
```  

接收有两种形式：

- 通过注解自动接收，默认支持 String 和8种基本数据类型，也支持自定义对象的解析
- 通过代码从路由中获取

使用注解接收对象时，必须调用 TheRouter.inject(this) 。

```typescript
// 第一种：使用注解自动填充
  // 允许解析成8种基本数据类型或对应封装类
  @Autowired()
  key1 : string = ''

  // 允许自定义传参key，如果不传默认是变量名作为key
  @Autowired('hello')
  key1 : string = ''

  // 使用注解接收对象时，必须调用，建议放在 aboutToApper() 中调用。
  TheRouter.inject(this)
  
  
  
// 第二种：通过代码从路由中获取
  // 可以在任何方法中调用，getCurrentParam() 返回值是个ESObject
  const v = TheRouter.getCurrentParam()['k'];   
  
```

### 三、从其他路由迁移至 TheRouter

#### 3.1 辅助工具

DevEco-Studio 插件的全新版本，已完美支持一键迁移工具，无需再次单独下载额外工具使用。    
下载安装最新插件后，在顶部 Tool 菜单内即可看到  TheRouter 相关功能，选择对应路由的一键迁移选项即可使用。   

迁移工具使用说明请见官网文档：[https://therouter.cn/docs/2022/09/29/01](https://therouter.cn/docs/2022/09/29/01)  

<img src="https://cdn.kymjs.com:8843/therouter_assets/img/image/TheRouterIdeaPlugin11.png" width="40%" />

#### 3.2 导航快捷跳转

在安装好 DevEco-Studio 插件的全新版本后打开项目，就可以看到，在项目中所有调用了 `TheRouter.build(path)` 的地方，  
还有 `@Route({ path : "xxxxx"})` 注解的位置，  
在左侧侧边栏上都会有一个绿色箭头的图标。

如果把鼠标放在图标上一段时间，就可以看到提示：  
点击以后跳转到使用这个 `path` 的地方，   
或者跳转到 `path` 定义的位置，点击以后就能自动跳转了。    
如果在代码中有多个地方都可以跳转到当前落地页，点击箭头后会有一个选择框，  
可以选择跳转到使用当前`path`的位置。   

**目前最新版本已经支持展示类名和行数，所有代码更清晰**

<img src="https://cdn.kymjs.com:8843/therouter_assets/img/image/TheRouterIdeaPlugin1.jpg" class="blog-img">

#### 3.3 与其他路由对比

| 功能                           |  TheRouter  |  HMRouter  |  Navigation  |
|------------------------------|---|---|---|
| 具备三端高一致性Harmony/Android/iOS  |✔️|✖️|✖️|
| 注解生成路由表                      |✔️|✔️|✖️|
| 路由path支持正则表达式                |✔️|✔️|✖️|
| 指定拦截器                        |✔️（四大拦截器可根据业务定制）|✔️|✖️|
| 导出路由表                        |✔️（路由文档支持添加注释描述）|✔️|✖️|
| 支持跨模块调用                      |✔️|✔️|✖️|
| 动态修改路由信息                     |✔️|✖️(未提供功能接口)|✔️(限制高，需提前定义，通过if/else修改实现)|
| 远端路由表下发                      |✔️|✖️|✖️|
| 多 Path 对应同一页面（低成本实现双端path统一） |✔️|✖️|✖️|
| 支持使用路由打开第三方SDK页面             |✔️|✖️|✖️|

### 四、源码运行与调试

#### 4.1 工程模块描述  

```
TheRouter
  ├─entry
  │   └──代码使用示例Demo
  ├─business_a
  │   └──用于模块化业务模块的演示模块
  ├─business_b
  │   └──用于模块化业务模块的演示模块
  ├─base
  │   └──用于模块化基础模块的演示模块
  │
  ├─plugin
  │   └──编译期 hvigor 插件源码
  │
  └─therouter
      └──路由库核心代码
```

### 五、Change Log  

详见 releases 记录：[CHANGELOG](https://github.com/HuolalaTech/hll-wp-therouter-harmony/releases)

### 六、Author

<img src="https://github.com/HuolalaTech/hll-wp-therouter-android/wiki/uploads/image/hll.png" width="40%" alt="HUOLALA mobile technology team" />

加入 【TheRouter】 官方微信群：  
*如过期，请加微信：kymjs123，拉你进群*   

<img src="https://cdn.kymjs.com:8843/therouter_assets/img/therouter_wx_group.png" width="40%" alt="TheRouter官方微信群：https://kymjs.com/therouter/wx" />

### 七、开源协议

TheRouter is licensed under the Apache License 2.0: [LICENSE](https://github.com/HuolalaTech/hll-wp-therouter-android/blob/master/LICENSE).  