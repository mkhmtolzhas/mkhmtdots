local ok, colors = pcall(dofile, os.getenv("HOME") .. "/.config/hypr/matugen-colors.lua")
if not ok or type(colors) ~= "table" then
    colors = { color0 = "rgb(120d0b)", color1 = "rgb(ffd0bf)", color8 = "rgb(9f8d87)" }
end

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 20,
        border_size = 2,
        col = {
            active_border   = colors.color1,
            inactive_border = colors.color8,
        },
        resize_on_border = true,
        allow_tearing    = false,
        layout = "dwindle",
    },
    decoration = {
        rounding       = 10,
        rounding_power = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = colors.color0,
        },
        blur = {
            enabled           = true,
            size              = 3,
            passes            = 1,
            vibrancy          = 0.1696,
            new_optimizations = true,
        },
    },
})
