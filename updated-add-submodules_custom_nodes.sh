#!/usr/bin/env bash
set -euo pipefail

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
  "https://github.com/nunchaku-ai/ComfyUI-nunchaku.git"
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
)

mkdir -p custom_nodes

# Remove custom_nodes from .gitignore if present
if grep -q "custom_nodes" .gitignore 2>/dev/null; then
  echo "==> Removing custom_nodes from .gitignore..."
  sed -i '/custom_nodes/d' .gitignore
fi

ADDED=0
SKIPPED=0
FAILED=0

for url in "${REPOS[@]}"; do
  name="$(basename -s .git "$url")"
  path="custom_nodes/${name}"

  # Skip if already a registered submodule
  if git config --file .gitmodules --get "submodule.${path}.url" &>/dev/null; then
    echo "⏭  Skipping (already registered): ${name}"
    ((SKIPPED++))
    continue
  fi

  # Skip if folder already exists with a .git inside
  if [ -d "${path}/.git" ]; then
    echo "⏭  Skipping (folder exists): ${name}"
    ((SKIPPED++))
    continue
  fi

  echo "➕ Adding: ${name}"
  if git submodule add -f "$url" "$path"; then
    ((ADDED++))
  else
    echo "❌ Failed: ${url}"
    ((FAILED++))
  fi
done

echo ""
echo "==> Summary: ${ADDED} added, ${SKIPPED} skipped, ${FAILED} failed"

if [ "$ADDED" -gt 0 ]; then
  git add .gitignore .gitmodules custom_nodes/
  git commit -m "Add ${ADDED} new custom node submodules"
  git push origin master
else
  echo "==> Nothing new to commit."
fi