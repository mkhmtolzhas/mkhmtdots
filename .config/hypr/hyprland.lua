package.path = os.getenv("HOME") .. "/.config/hypr/?.lua;" .. package.path

require("configs.monitors")
require("configs.autostart")
require("configs.env")
require("configs.hyprcolors")
require("configs.animations")
require("configs.general")
require("configs.input")
require("configs.keybinds")
require("configs.windowrule")
require("configs.debug")
