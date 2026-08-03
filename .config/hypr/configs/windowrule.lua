local inFocus, notInFocus = 0.9, 0.7
local opFocus = inFocus .. " " .. notInFocus

hl.window_rule({ name = "suppress-maximize", match = { class = ".*" }, suppress_event = "maximize" })

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

hl.window_rule({ name = "opacity-default", match = { class = ".*" },      opacity = opFocus })
hl.window_rule({ name = "opacity-kitty",   match = { class = "^kitty$" }, opacity = "1 1" })
hl.window_rule({ name = "opacity-zen",     match = { class = ".*Zen.*" }, opacity = "0.999 0.999" })

hl.window_rule({
    name  = "opacity-browsers",
    match = { class = "^(firefox|brave|chromium|librewolf|qutebrowser|zen-browser)$" },
    opacity = opFocus,
})

hl.window_rule({ name = "opacity-spotify",  match = { title = ".*Spotify.*" },       opacity = opFocus })
hl.window_rule({ name = "opacity-discord",  match = { title = ".*Discord.*" },       opacity = opFocus })
hl.window_rule({ name = "opacity-telegram", match = { title = ".*Telegram.*" },      opacity = opFocus })
hl.window_rule({ name = "opacity-code",     match = { title = ".*Code.*" },          opacity = opFocus })
hl.window_rule({ name = "opacity-files",    match = { title = ".*(Thunar|nemo).*" }, opacity = opFocus })

hl.window_rule({ name = "lunar-fullscreen", match = { class = "^Lunar Client.*$" }, fullscreen = true })
