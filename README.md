# Harmony Dynamic Routing Framework: TheRouter

[![Hex.pm](https://img.shields.io/hexpm/l/plug.svg)](https://www.apache.org/licenses/LICENSE-2.0)
[![Language](https://img.shields.io/badge/Language-ArkTS-green)](https://kotlinlang.org/)
[![Wiki](https://img.shields.io/badge/Wiki-open-green)](https://therouter.cn/harmony)

Harmony | [Android](https://github.com/HuolalaTech/hll-wp-therouter-android) | [iOS](https://github.com/HuolalaTech/hll-wp-therouter-ios) | [Official Site](https://therouter.cn)

---

### 1. Feature Overview

TheRouter for Harmony offers the following core capabilities:

#### **Navigator**
- Supports **one-to-many** or **one-to-one** mapping between `Path` and pages, resolving multi-platform path unification issues.
- Page `Path` supports regex declarations.
- Exports routing tables in **JSON** format.
- Allows adding comments/descriptions to routing entries.
- Supports dynamic JSON routing table updates (e.g., downgrading any page to H5).
- Provides page redirection interception.
- Enables routing to pages within third-party SDKs.

#### **ServiceProvider**
- Cross-module dependency injection.
- Customizable injection rules with parameter support.
- Cached injection objects (singleton-like behavior).

#### **ActionManager**
- Global callback configuration.
- Chain-triggered multi-response handling.
- Priority-based response control.
- Supports method return values and parameters.
- Call path tracing for debugging observer patterns (solves `Observable` tracking issues).

---

### 2. Usage Guide

**For detailed documentation, visit [therouter.cn](https://therouter.cn/harmony).**

#### 2.1 Prerequisites
For new projects: **Ensure the versions of `plugin` and `router` dependencies match exactly**.

TheRouter offers **stable** and **RC** releases. Stable versions are recommended for production. Check the latest versions at:  
[https://therouter.cn/docs/2022/09/06/01](https://therouter.cn/docs/2022/09/06/01)

#### 2.2 Add Dependencies
Run in the project root:

```shell  
# Core library  
ohpm i @therouter/library  

# Plugin  
npm i @therouter/plugin  
```  

#### 2.3 Configure the Plugin
1. Open `hvigor/hvigor-config.json5` and verify `dependencies` includes `"@therouter/plugin": "x.x.x"`.
2. Update **all** module (`hsp`/`hap`/`har`) `hvigorfile.ts` files:

```typescript  
// For hap:  
import { hapPlugin } from "@therouter/plugin";  
export default { plugins: [hapPlugin()] }  

// For har:  
import { harPlugin } from "@therouter/plugin";  
export default { plugins: [harPlugin()] }  

// For hsp:  
import { hspPlugin } from "@therouter/plugin";  
export default { plugins: [hspPlugin()] }  
```  

#### 2.4 Initialization
In `UIAbility.onCreate()`:

```typescript  
onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {  
    TheRouter.init(this.context);  
}  
```  

#### 2.5 Define Page Container
TheRouter follows Huawei’s recommended `Navigation` implementation. Add a `TheRouterPage` container:

```typescript  
import { TheRouterPage } from '@therouter/library';  

@Entry  
@Component  
struct Index {  
  build() {  
    RelativeContainer() {  
      TheRouterPage({  
        stackId: 'XXXX',  // [Required] Unique stack identifier  
        root: 'path'      // [Required] Homepage path (format recommended)  
        // Optional params (see docs)  
      });  
    }  
    .height('100%')  
    .width('100%')  
  }  
}  
```  

#### 2.6 Page Declaration & Navigation
Annotate target pages:

```typescript  
@Route({ path: "http://therouter.com/home" })  
export struct HomePage { ... }  
```  

Navigate with parameters:

```typescript  
TheRouter  
  .build("http://therouter.com/home")  
  .withString('k', 'v')  // Pass params (optional)  
  .with({ hello: 'world' })  // Alternative param syntax  
  .navigation();  
```  

Retrieve params on the target page:  
There are two forms of parameter reception:  

1. **Automatic reception via annotations**: By default, it supports `String`, the eight primitive data types, and custom object parsing.
2. **Manual retrieval from the route via code**.

When using annotations to receive objects, **`TheRouter.inject(this)` must be called**.

```typescript  
// Method 1: Auto-populate using annotations  
  // Supports parsing into the eight primitive data types or their wrapper classes  
  @Autowired()  
  key1: string = '';  

  // Allows custom parameter keys; if not specified, the variable name is used as the key  
  @Autowired('hello')  
  key2: string = '';  

  // When using annotations to receive objects, this must be called.  
  // Recommended to place it in `aboutToAppear()`.  
  TheRouter.inject(this);  

// Method 2: Retrieve parameters from the route via code  
  // Can be called in any method; `getCurrentParam()` returns an `ESObject`  
  const v = TheRouter.getCurrentParam()['k'];  
```

---

### 3. Migrating from Other Routers

#### 3.1 Migration Tool
The latest **DevEco-Studio plugin** includes a one-click migration tool (no standalone download needed).  
Access via: **Top Menu → Tools → TheRouter**.

Guide: [https://therouter.cn/docs/2022/09/29/01](https://therouter.cn/docs/2022/09/29/01)

<img src="https://cdn.kymjs.com:8843/therouter_assets/img/image/TheRouterIdeaPlugin11.png" width="40%" />  

#### 3.2 Navigation Shortcuts
With the plugin installed:
- Click the **green arrow** next to `TheRouter.build(path)` or `@Route` annotations to jump to definitions/usages.
- For multi-path targets, a selection dialog will appear.

**Latest version shows class names and line numbers for clarity.**

<img src="https://cdn.kymjs.com:8843/therouter_assets/img/image/TheRouterIdeaPlugin1.jpg" class="blog-img">  

#### 3.3 Feature Comparison

| Feature | TheRouter | HMRouter | Navigation |  
|---------|-----------|----------|------------|  
| Cross-platform consistency (Android/iOS/Harmony) | ✔️ | ✖️ | ✖️ |  
| Annotation-based routing | ✔️ | ✔️ | ✖️ |  
| Regex path support | ✔️ | ✔️ | ✖️ |  
| Interceptors | ✔️ (4 types) | ✔️ | ✖️ |  
| Exportable routing tables (with comments) | ✔️ | ✔️ | ✖️ |  
| Cross-module calls | ✔️ | ✔️ | ✖️ |  
| Dynamic route modification | ✔️ | ✖️ | ✔️ (limited) |  
| Remote routing table updates | ✔️ | ✖️ | ✖️ |  
| Multi-path → single page | ✔️ | ✖️ | ✖️ |  
| Open third-party SDK pages | ✔️ | ✖️ | ✖️ |  

---

### 4. Build & Debug

#### 4.1 Project Structure

```  
TheRouter  
  ├─entry          // Demo  
  ├─business_a     // Modular demo module  
  ├─business_b  
  ├─base           // Base module demo  
  ├─plugin         // Hvigor plugin source  
  └─therouter      // Core library  
```  

---

### 5. Changelog

See [Releases](https://github.com/HuolalaTech/hll-wp-therouter-harmony/releases).

---

### 6. Author

<img src="https://github.com/HuolalaTech/hll-wp-therouter-android/wiki/uploads/image/hll.png" width="40%" alt="HUOLALA Tech" />  

Join the **TheRouter WeChat Group**:  
*If the QR code expires, add WeChat: `kymjs123`*

<img src="https://cdn.kymjs.com:8843/therouter_assets/img/therouter_wx_group.png" width="40%" alt="TheRouter WeChat Group" />  

---

### 7. License

TheRouter is licensed under **Apache 2.0**: [LICENSE](https://github.com/HuolalaTech/hll-wp-therouter-android/blob/master/LICENSE).

--- 

Let me know if you'd like any refinements!