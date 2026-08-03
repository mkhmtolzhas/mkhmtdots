local home = os.getenv("HOME")

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})

hl.on("hyprland.start", function()
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("sleep 1 && QT_QPA_PLATFORM=wayland qs")
    hl.exec_cmd("awww-daemon & sleep 1; " .. home .. "/.config/hypr/scripts/wallpapers/set-random.sh")
end)
