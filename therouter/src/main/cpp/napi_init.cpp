#include "napi/native_api.h"
#include "hilog/log.h"
#include <cstdlib>
#include <exception>
#include <memory>
#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0xFF00
#define LOG_TAG "TheRouterLoader"

#define CHECK_STATUS(status) ((status) == napi_status::napi_ok)
static napi_value LoadModule(napi_env env, napi_callback_info info) {
    try {
        size_t argc = 2;
        napi_value argv[2] = {nullptr};
        napi_status status;
        status = napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

        if (!CHECK_STATUS(status)) {
            return nullptr;
        }
        size_t module_path_size = 0;
        napi_get_value_string_utf8(env, argv[0], nullptr, NAPI_AUTO_LENGTH, &module_path_size);
        char *module_path = new char[module_path_size + 1];
        status = napi_get_value_string_utf8(env, argv[0], module_path, module_path_size + 1, &module_path_size);
        if (!CHECK_STATUS(status)) {
            OH_LOG_ERROR(LOG_APP, "[TheRouterLoader DEBUG] load module with info fail get module_path fail");
            return nullptr;
        }
        std::unique_ptr<char[]> module_path_ptr(module_path);

        size_t module_info_size = 0;
        napi_get_value_string_utf8(env, argv[1], nullptr, 0, &module_info_size);
        char *module_info = new char[module_info_size + 1];
        napi_get_value_string_utf8(env, argv[1], module_info, module_info_size + 1, &module_info_size);
        if (!CHECK_STATUS(status)) {
            OH_LOG_ERROR(LOG_APP, "[TheRouterLoader DEBUG] load module with info fail get module_info fail");
            return nullptr;
        }
        std::unique_ptr<char[]> module_info_ptr(module_info);

        napi_value res;
        status = napi_load_module_with_info(env, module_path_ptr.get(), module_info_ptr.get(), &res);
        if (CHECK_STATUS(status)) {
            OH_LOG_DEBUG(
                LOG_APP,
                "[TheRouterLoader DEBUG] load module success, module path is %{public}s, module info is %{public}s",
                module_path, module_info);
            return res;
        } else {
            OH_LOG_ERROR(
                LOG_APP,
                "[TheRouterLoader ERROR] load module fail, module path is %{public}s, module info is %{public}s,"
                " error type is %{public}d",
                module_path, module_info, status);
            return nullptr;
        }
    } catch (const std::exception &e) {
        OH_LOG_ERROR(LOG_APP, "[TheRouterLoader ERROR] load module with info fail ,error message is %{public}s ",
                     e.what());
        return nullptr;
    }
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {
        {"loadModule", nullptr, LoadModule, nullptr, nullptr, nullptr, napi_default, nullptr}};
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "therouter",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterLibraryModule(void) { napi_module_register(&demoModule); }
