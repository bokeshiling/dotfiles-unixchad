<!-- Machine-specific note: ThinkPad X230 -->
# X230 本机专属改动

> **Machine-specific.** 本文件列出的改动只适用于 **ThinkPad X230
> (model 2324FP9, i5-3320M, HD Graphics 4000, 1366x768)**。
> 本仓库 fork 自 [gnuunixchad/dotfiles](https://github.com/gnuunixchad/dotfiles)，
> 除下表条目外与 upstream 保持一致；升级 upstream 时这些文件需要手动合并。

| 文件 | 改动 | 原因 |
|:---|:---|:---|
| `.zshrc` | 追加 `export COLORTERM=truecolor` | `st` 下 catimg/chafa 等需要 24-bit 真彩渲染 |
| `.xinitrc` | `xrandr -s 1920x1080` → `autorandr --change`，回退 `LVDS-1 1366x768` | upstream 的 1920x1080 在 X230 上静默失败（内屏上限 1366x768） |
| `.config/autorandr/x230-nomad/` | 新增 profile（`LVDS-1 1366x768@60.02` + 真实 EDID 指纹） | X230 内屏；upstream 的 `t14-*`/`fx507-*` 是别的机器，对本机不匹配 |
| `.local/bin/fanmode` | 针对 X230 的 `thinkpad_acpi` 风扇档位控制重写 | upstream 版本面向 ThinkPad/ASUS 通用，本机需要 X230 的具体策略 |

## 与 upstream 的合并方式

```sh
cd ~/dotfiles-unixchad
git fetch origin
git merge origin/master        # 或 git rebase
# 若上面三个文件冲突：保留本机版本，改动逻辑见本文件表格
```

## 有意保持与 upstream 一致、未做本机化的部分

- **键盘映射**：使用 `caps:swapescape`，**不加** `altwin:swap_alt_win`
  （upstream 默认会互换 Alt/Super；本机保持物理 Win 键作为 dwm 的 Mod4）。
- **`~/.config/layout.xkb`**：保留 upstream 版本但**不加载**，原因同上
  （该文件的核心就是 Alt/Super 互换）。

## 不在本仓库内、换机器会踩的坑

- **`~/.gitconfig` 不由 stow 管理**（upstream 未收录该文件）。本机已手工创建：

  ```ini
  [user]
      name = bokeshiling
      email = shiling142857@gmail.com
  [commit]
      gpgsign = false
  ```

  本机没有 `bokeshiling` 的 GPG 私钥，故关闭了签名。若要在本机恢复签名：
  导入私钥后把 `gpgsign` 改回 `true`。

- **dwm 需单独编译安装**：本仓库不含二进制。源码在
  [bokeshiling/dwm-unixchad](https://github.com/bokeshiling/dwm-unixchad)，
  构建 `~/Projects/dwm-unixchad` 后 `sudo make install`（装到 `/usr/local/bin/dwm`）。

- **niri/waybar/full-nvim/kitty/alacritty** 属于另一套桌面配置，已归档在
  `~/dotfiles-desktop`，不在本 fork 内。

## 机器本地、不在 stow 之外管理的项

以下内容**不由 fork 的 stow 管理**，换机器或重装需要重新创建（本机已恢复）：

- **`~/.zshenv`**：内容为 `. "$HOME/.cargo/env"`。upstream 的 `.gitignore`
  白名单未放行 `.zshenv`，故保持为本地文件。**这是 `miyu`（`~/.cargo/bin/miyu`）
  能进 PATH 的唯一原因。缺了它 cargo/rustup 工具全部不可用。**
- **`~/.bash_profile`**、**`~/.bash_logout`**：本地文件，同样未纳入 fork。
- **`~/.gitconfig`**：本地文件，见上一节。
- **`~/.local/bin/` 下的外部软链**：已收录进 fork，但目标属于系统/npm，换机需目标存在：

  | 链接 | 目标 |
  |:---|:---|
  | `battery-care` `clean` `sysup` 等 16 个 | `/usr/lib/shorin-contrib/*`（包 `shorin-contrib-git`）|
  | `dsh` | `~/.local/share/npm/bin/dsh` |
  | `dwm` | `/usr/local/bin/dwm` |
