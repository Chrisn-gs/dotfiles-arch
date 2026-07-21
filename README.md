# dotfiles-arch

ThinkPad T14 (Arch Linux + Hyprland) 的配置文件备份，使用 [GNU Stow](https://www.gnu.org/software/stow/) 管理符号链接。

## 包含的配置

| Package | 内容 |
|---------|------|
| hypr | Hyprland 窗口管理器配置 |
| waybar | 状态栏配置 |
| wofi | 应用启动器配置 |
| nvim | AstroNvim 编辑器配置 |
| tmux | 终端复用器配置 + scripts |
| zsh | Zsh + Oh My Zsh + Powerlevel10k |
| git | Git 全局配置 |
| keyd | 按键重映射（空格键 TouchCursor） |
| btop | 系统监控工具配置 |
| lazygit | Git TUI 配置 |
| whosthere | 局域网设备扫描工具配置 |
| pam | PAM 认证配置（指纹登录 + sudo） |
| battery-threshold | 电池充电阈值（75%-80%） |
| micmute-toggle | F4 麦克风静音切换脚本（LED 同步失效） |
| rime | fcitx5 Rime 输入法配置（默认简体中文） |

## 桌面环境

- **窗口管理器**：Hyprland（Lua 配置格式）
- **桌面 Shell**：DankMaterialShell (DMS) — 提供顶部状态栏（DankBar）、应用启动器、控制中心等
- **应用启动器**：wofi + spark-linux（自定义快捷启动工具）

## 使用方法

```bash
# 克隆到 home 目录
git clone https://github.com/Chrisn-gs/dotfiles-arch.git ~/dotfiles-arch

# 安装 stow
sudo -S -p '' pacman -S stow

# 部署所有配置
cd ~/dotfiles-arch
stow */

# 或者只部署部分
stow zsh tmux git

# 取消某个配置
stow -D tmux
```

## 注意事项

- keyd 配置需要手动复制到 `/etc/keyd/`（需要 sudo）
- pam 配置需要手动复制到 `/etc/pam.d/`（需要 sudo）
- battery-threshold 需要手动复制到 `/etc/systemd/system/` 并 `systemctl enable battery-threshold`
- micmute-toggle 需要手动复制到 `~/.local/bin/` 和 `/etc/systemd/system/`，然后 `systemctl enable micmute-led`
  - LED 同步实际不生效（无论静音与否 LED 均不亮），静音功能本身正常
- rime 需要先 `stow rime`，然后在 fcitx5 中触发重新部署（或重启 fcitx5）
- Hyprland 配置使用 Lua 格式（非默认 conf）
- 使用 Catppuccin Mocha 配色方案
- 修改后 `git add -A && git commit && git push` 同步

## 系统信息

- 设备：ThinkPad T14 Gen1 AMD
- 系统：Arch Linux
- 窗口管理器：Hyprland
- 终端：kitty + tmux
- 编辑器：Neovim (AstroNvim)
- Shell：Zsh + Oh My Zsh

