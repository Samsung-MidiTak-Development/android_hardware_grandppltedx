package mtkLibgrallocExtraCommon

import (
	"os"
	"path/filepath"
	"strings"

	"android/soong/android"
	"android/soong/cc"
)

func mtkDebugFWDefaults(ctx android.LoadHookContext) {
	type props struct {
		Srcs []string
	}
	p := &props{}
	vars := ctx.Config().VendorConfig("mtkPlugin")
	platformDir := strings.ToLower(vars.String("MTK_PLATFORM"))
//	platformDir := strings.ToLower(mediatek.GetFeature("MTK_PLATFORM"))
	localPath := ctx.ModuleDir()
	if _, err := os.Stat(filepath.Join(localPath, "platform", platformDir, "platform.c")); err == nil {
		p.Srcs = append(p.Srcs, filepath.Join("platform", platformDir, "platform.c"))
	} else {
		p.Srcs = append(p.Srcs, filepath.Join("platform", "default", "platform.c"))
	}
	ctx.AppendProperties(p)
}

func init() {
	android.RegisterModuleType("mtk_libgralloc_extra_common_defaults", mtkLibgrallocExtraCommonDefaultsFactory)
}

func mtkLibgrallocExtraCommonDefaultsFactory() android.Module {
	module := cc.DefaultsFactory()
	android.AddLoadHook(module, mtkDebugFWDefaults)
	return module
}

