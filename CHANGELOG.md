# Changelog

## 2026-07-20

### DMS 升级：dms-shell → dms-shell-git

**问题**：DMS stable (v1.4.6) 的 DankBar workspace switcher 点击无效，只能用 ALT+数字切换工作区。

**根因**：Hyprland Lua 配置将旧的 `hyprctl dispatch workspace N` 语法解析为 Lua 代码，导致语法错误。DMS stable 内部仍使用旧语法。

**上游 issue**：[AvengeMedia/DankMaterialShell#2424](https://github.com/AvengeMedia/DankMaterialShell/issues/2424)

**修复**：升级到 AUR 的 `dms-shell-git`（v1.5.0+），已支持 Hyprland Lua dispatch 语法。

```bash
# 升级步骤
sudo pacman -Rdd dms-shell dms-shell-hyprland
yay -S dms-shell-git
systemctl --user restart dms.service
```

**回滚**：备份在 `~/.config/DankMaterialShell.bak/` 和 `~/.local/state/DankMaterialShell.bak/`。

### spark-linux：URL 打开方式修复

**问题**：Alt+B 选择 URL 类型项目（如 Bilibili）时，弹出 DMS 的 "Open With" 对话框，需要再按一次 Enter 才能打开 Firefox。

**根因**：`spark.sh` 中 URL 类型使用 `xdg-open`，在 Hyprland 下走 xdg-desktop-portal 弹出选择对话框。

**修复**：改为 `setsid firefox "$cmd"` 直接打开，跳过 xdg-open。文件夹类型保持 `xdg-open` 不变。

**提交**：`003c18e` → [spark-linux](https://github.com/Chrisn-gs/spark-linux)
