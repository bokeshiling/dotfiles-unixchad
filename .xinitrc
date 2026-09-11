#!/usr/bin/sh
# @author nate zhou
# @since 2023,2026

wm=${1:-dwm}

export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
mkdir -p "$XDG_CACHE_HOME"

autostart() {
    # X230 本机改动：内屏上限 1366x768，upstream 的 1920x1080 在本机静默失败。
    # 优先让 autorandr 按当前接的屏切 profile，没装/没匹配再退回固定内屏模式。
    if command -v autorandr >/dev/null 2>&1; then
        XDG_SESSION_TYPE=xorg autorandr --change 2>/dev/null \
            || xrandr --output LVDS-1 --mode 1366x768 --primary 2>/dev/null || true
    else
        xrandr -s 1366x768 2>/dev/null || true
    fi

    xwallpaper --zoom ${HOME}/.local/share/wallpaper &

    picom &

    ${HOME}/.local/bin/lucia -d &

    ${HOME}/.local/bin/mbs-cron &

    xss-lock -- slock  &

    redshift -P -O 5000 &

    clipmenud &

    pgrep 'dunst' || dunst -conf ${HOME}/.config/dunst/dunstrc-offset &

    pgrep 'xob' || ${HOME}/.local/bin/xobd &

    fcitx5 -d --verbose '*=0' &

}

config_x() {
    echo "Xft.dpi: 96" | xrdb -m

    xset r rate 200 30 &

    setxkbmap -option caps:swapescape &

    unclutter --timeout 3 &

    xbanish &

    touchpads=$(xinput list | grep -i "touchpad" | grep -oP 'id=\K[0-9]+')
    for touchpad in $touchpads ; do
        xinput set-prop "$touchpad" "libinput Tapping Enabled" 1
        xinput set-prop "$touchpad" "libinput Natural Scrolling Enabled" 1
    done

    xset s on
    xset s 960

    export GTK_IM_MODULE=fcitx
    export XMODIFIERS=@im=fcitx
    export QT_IM_MODULE=fcitx
    export XDG_SESSION_TYPE=xorg

}

config_x; autostart;

# 让 systemd 用户服务（如 xdg-desktop-portal-gtk）能拿到 X 环境变量，
# 否则 QQ 等 Electron 应用的文件选择器/Portal 无法启动。
systemctl --user import-environment DISPLAY XAUTHORITY XDG_SESSION_TYPE 2>/dev/null || true

case "$wm" in
    dwm)
        damblocks-mpdd &
        damblocks --xsetroot &
        exec ssh-agent dwm
        ;;
    bspwm)
        exec ssh-agent bspwm
        ;;
    i3)
        exec ssh-agent i3
        ;;
esac
