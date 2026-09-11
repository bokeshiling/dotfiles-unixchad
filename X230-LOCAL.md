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
