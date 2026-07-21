# Hermes Agent CLI 卡住问题排查

使用 Hermes Agent 时，CLI 命令执行卡住的常见原因和解决方法。

---

## 1. sudo 命令卡住（最常见）

### 症状
Hermes 执行 `sudo pacman`、`sudo tee`、`sudo sh -c "..."` 等命令时，终端一直卡住不动，没有输出。

### 原因
Hermes 通过 PTY 执行命令，sudo 的密码/指纹提示显示在 Hermes 的 PTY 中，用户看不到提示也无法输入。指纹传感器虽然会亮，但用户不知道什么时候该按。

### 解决方法：配置 NOPASSWD

#### 第一步：创建 sudoers.d 免密文件

```bash
sudo tee /etc/sudoers.d/nopasswd > /dev/null << 'EOF'
chrisn ALL=(ALL) NOPASSWD: /usr/bin/pacman, /usr/bin/systemctl, /usr/bin/modprobe, /usr/bin/tee, /usr/bin/cat, /usr/bin/cp, /usr/bin/sh, /usr/bin/visudo, /usr/bin/fprintd-enroll, /usr/bin/fprintd-verify, /home/chrisn/.local/bin/micmute-toggle
EOF

# 验证语法
sudo visudo -cf /etc/sudoers.d/nopasswd
```

#### 第二步：检查主 sudoers 文件顺序（关键！）

```bash
sudo grep -n "wheel\|includedir" /etc/sudoers
```

**必须确保 `%wheel ALL=(ALL:ALL) ALL` 在 `@includedir /etc/sudoers.d` 之前。**

正确的顺序：
```
%wheel ALL=(ALL:ALL) ALL          ← 在 includedir 前面
@includedir /etc/sudoers.d        ← 我们的 NOPASSWD 文件在这里加载
```

错误的顺序（会导致免密不生效）：
```
@includedir /etc/sudoers.d        ← NOPASSWD 文件加载
%wheel ALL=(ALL:ALL) ALL          ← 这行覆盖了所有免密规则！
```

**sudoers 规则是最后匹配优先**，所以 `%wheel ALL=(ALL:ALL) ALL` 如果在 `@includedir` 后面，会把所有 NOPASSWD 规则覆盖掉。

#### 第三步：修复顺序（如果不对）

```bash
# 查看当前内容
sudo cat /etc/sudoers | grep -n "wheel\|includedir"

# 如果 %wheel 行在 @includedir 后面，找到行号删除
# 例如重复的 wheel 行在第 140 行：
sudo sh -c 'sed -i "140d" /etc/sudoers'

# 验证
sudo visudo -cf /etc/sudoers
```

#### 第四步：验证生效

```bash
# -n 表示非交互模式，如果免密生效就不会要密码
sudo -n cat /etc/hostname
sudo -n sh -c 'echo "NOPASSWD works!"'
```

---

## 2. 免密命令列表说明

| 命令 | 用途 |
|------|------|
| pacman | 包管理（安装/更新/卸载） |
| systemctl | 服务管理（启用/禁用/重启服务） |
| modprobe | 内核模块加载 |
| tee | 写入系统文件（Hermes 常用 `sudo tee` 写配置） |
| cat | 读取系统文件 |
| cp | 复制系统文件 |
| sh | 执行 shell 复合命令（`sudo sh -c '...'`） |
| visudo | 编辑 sudoers 文件 |
| fprintd-enroll | 指纹录入 |
| fprintd-verify | 指纹验证 |
| micmute-toggle | 麦克风静音切换脚本 |

不包含删除命令（rm）是安全考虑。

---

## 3. sudoers.d 目录下的其他文件

| 文件 | 内容 |
|------|------|
| `10-shorin-nopasswd` | wheel 组的 pacman/systemctl/sudoedit 免密 |
| `micmute-led` | micmute-toggle 脚本免密 |
| `nopasswd` | 我们的完整免密列表 |

文件按字母顺序加载，`nopasswd` 最后加载，规则优先级最高。

---

## 更新日志

- **2026-07-22**: 创建文档，记录 sudo NOPASSWD 配置和 `%wheel` 行顺序问题
