hl.config({
    general = {
        layout = "dwindle",
        resize_on_border = true,
        gaps_out = 3,
        gaps_in = 3,
    },

    dwindle = {
        preserve_split = true, -- I want to handle it myself
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },

    group = {
        drag_into_group = 2,
        merge_groups_on_drag = true,
    },

    input = {
        -- Scrolling for people who aren't freaks
        touchpad = { natural_scroll = true },
    },

    xwayland = {
        -- Solves some issues of applications being low resolution
        force_zero_scaling = true,
    },
})

hl.workspace_rule({ workspace = "special:special", gaps_out = 35 })

-- 3-finger swipe to switch workspace
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Ignore maximize requests from clients, so new windows tile instead of opening maximized
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
