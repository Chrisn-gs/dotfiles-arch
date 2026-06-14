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

## 电源管理配置

### 笔记本合盖不挂起

为了在SSH远程访问时保持连接，配置了笔记本合盖不挂起：

**配置文件**：`/etc/systemd/logind.conf`

```bash
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
```

**效果**：
- 笔记本合盖 → 系统继续运行 → SSH连接保持
- 屏幕会关闭，但系统不会休眠

**修改后重启服务**：
```bash
sudo -S -p '' systemctl restart systemd-logind
```

**恢复默认**：
```bash
sudo -S -p '' sed -i 's/HandleLidSwitch=ignore/#HandleLidSwitch=suspend/' /etc/systemd/logind.conf
sudo -S -p '' systemctl restart systemd-logind
```
