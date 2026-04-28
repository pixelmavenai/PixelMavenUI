#!/usr/bin/env bash
set -euo pipefail



# Deinit all submodules at once
git submodule deinit -f --all

# Remove all submodule entries from git
git rm -f $(git submodule | awk '{print $2}')

# Clean up git internal module cache
rm -rf .git/modules/custom_nodes

# Remove the .gitmodules file
rm -f .gitmodules

# Commit the removal
git add .
git commit -m "Remove all submodules — clean slate"
git push origin master




REPOS=(
  "https://github.com/ltdrdata/ComfyUI-Manager.git"
  "https://github.com/Fannovel16/comfyui_controlnet_aux.git"
  "https://github.com/cubiq/ComfyUI_IPAdapter_plus.git"
  "https://github.com/ssitu/ComfyUI_UltimateSDUpscale.git"
  "https://github.com/rgthree/rgthree-comfy.git"
  "https://github.com/kijai/ComfyUI-KJNodes.git"
  "https://github.com/calcuis/gguf.git"
  "https://github.com/PowerHouseMan/ComfyUI-AdvancedLivePortrait.git"
  "https://github.com/cubiq/ComfyUI_essentials.git"
  "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git"
  "https://github.com/kijai/ComfyUI-Florence2.git"
  "https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git"
  "https://github.com/kijai/ComfyUI-SUPIR.git"
  "https://github.com/nunchaku-ai/ComfyUI-nunchaku.git"   # official — keep this
  # "https://github.com/nunchaku-tech/ComfyUI-nunchaku.git" # removed — duplicate
  "https://github.com/yolain/ComfyUI-Easy-Use.git"
  "https://github.com/BadCafeCode/masquerade-nodes-comfyui.git"
  "https://github.com/giriss/comfy-image-saver.git"
  "https://github.com/ussoewwin/ComfyUI-QwenImageLoraLoader.git"
  "https://github.com/ubisoft/ComfyUI-Chord.git"
  "https://github.com/spinagon/ComfyUI-seamless-tiling.git"
  "https://github.com/gseth/ControlAltAI-Nodes.git"
  "https://github.com/M1kep/ComfyLiterals.git"
  "https://github.com/WASasquatch/was-node-suite-comfyui.git"
  "https://github.com/jtydhr88/ComfyUI-qwenmultiangle.git"
  "https://github.com/chflame163/ComfyUI_LayerStyle.git"
  "https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes.git"
  "https://github.com/aining2022/ComfyUI_Swwan.git"
  # "https://github.com/nunchaku-tech/ComfyUI-nunchaku.git" # removed — use nunchaku-ai instead
  "https://github.com/1038lab/ComfyUI-QwenVL.git"
  "https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch.git"
  "https://github.com/chrisgoringe/cg-use-everywhere.git"
  "https://github.com/scraed/LanPaint.git"
  "https://github.com/luguoli/ComfyUI-Qwen-Image-Integrated-KSampler.git"
  "https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler.git"
  "https://github.com/PozzettiAndrea/ComfyUI-SAM3.git"
  "https://github.com/pixelmavenai/comfyui-custom-branding.git"
  "https://github.com/ClownsharkBatwing/RES4LYF.git"
  "https://github.com/aria1th/ComfyUI-LogicUtils.git"
  "https://github.com/pixaroma/ComfyUI-Pixaroma.git"
  # removed wrong URL above, added correct one below with custom folder name to avoid clash with 1038lab/ComfyUI-QwenVL
)

mkdir -p custom_nodes

# Remove ALL custom_nodes entries from .gitignore
if grep -q "custom_nodes" .gitignore 2>/dev/null; then
  echo "Removing custom_nodes from .gitignore..."
  sed -i '/custom_nodes/d' .gitignore
fi

for url in "${REPOS[@]}"; do
  name="$(basename -s .git "$url")"
  if git submodule status "custom_nodes/${name}" &>/dev/null; then
    echo "Skipping (already added): ${name}"
  else
    echo "Adding submodule: ${name}"
    git submodule add -f "$url" "custom_nodes/${name}" || echo "Failed: ${url}"
  fi
done
git add .gitignore .gitmodules custom_nodes/
git commit -m "Add custom nodes as submodules"
git push origin master