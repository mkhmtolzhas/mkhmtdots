//@ pragma UseQApplication

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import "config"
import "modules/bar"
import "modules/osd"
import "modules/dashboard"
import "modules/wallpaper"

ShellRoot {
    id: shell

    // Match Hyprland's workspace slide direction to the bar orientation:
    // vertical bar → workspaces slide up/down, horizontal bar → left/right.
    Process { id: wsAnimProc }
    function applyWsAnim() {
        const style = Appearance.bar.vertical ? "slidevert" : "slide";
        wsAnimProc.running = false;
        // Apply now AND persist the style so the wallpaper script can re-apply
        // it after `hyprctl reload` (reload resets animations.conf otherwise).
        wsAnimProc.command = ["sh", "-c",
            "hyprctl eval \"hl.animation({ leaf = 'workspaces', enabled = true, speed = 5, bezier = 'wind', style = '" + style + "' })\"; " +
            "echo '" + style + "' > \"$HOME/.cache/quickshell-ws-anim\""];
        wsAnimProc.running = true;
    }
    Connections {
        target: Appearance.bar
        function onVerticalChanged() { shell.applyWsAnim(); }
    }
    Component.onCompleted: applyWsAnim()

    Variants {
        model: Quickshell.screens

        // Variants injects `modelData` (a ShellScreen) into each delegate.
        Bar {}
    }

    // Single overlay OSD for volume / brightness.
    Osd {}

    // Bar position picker popup (toggled from the bar icon).
    PositionPickerOverlay {}

    // Dashboard (toggled via Super+D or clicking the clock).
    Dashboard {}

    // Visual wallpaper picker (toggled via Super+W).
    WallpaperPicker {}

    // ── Bar position hotkeys (bound in Hyprland as quickshell:bar*) ──
    GlobalShortcut {
        name: "barCycle"
        description: "Cycle bar position"
        onPressed: {
            const order = ["top", "right", "bottom", "left"];
            const i = order.indexOf(Appearance.bar.position);
            Appearance.bar.position = order[(i + 1) % order.length];
        }
    }
    GlobalShortcut { name: "barTop";    description: "Bar to top";    onPressed: Appearance.bar.position = "top" }
    GlobalShortcut { name: "barBottom"; description: "Bar to bottom"; onPressed: Appearance.bar.position = "bottom" }
    GlobalShortcut { name: "barLeft";   description: "Bar to left";   onPressed: Appearance.bar.position = "left" }
    GlobalShortcut { name: "barRight";  description: "Bar to right";  onPressed: Appearance.bar.position = "right" }
}
