-- https://wiki.hypr.land/configuring/core/binds/

local function bind(keys, dispatcher, description, flags)
    flags = flags or {}
    flags.description = description
    hl.bind(keys, dispatcher, flags)
end

local function exec(cmd)
    return hl.dsp.exec_cmd(cmd)
end

-- Transient notification; messages sharing a key replace each other.
-- Arguments are interpolated into a shell command, so keep them free of single quotes.
local function notify(summary, body, timeout, key)
    local cmd = "notify-send -a Hyprland -u low -t " .. timeout .. " -h boolean:transient:true"
    if key then
        cmd = cmd .. " -h string:x-canonical-private-synchronous:" .. key
    end
    hl.dispatch(hl.dsp.exec_cmd(cmd .. " '" .. summary .. "' '" .. body .. "'"))
end

-- Apps and system
bind("SUPER + SPACE",         exec("uwsm app -- vicinae toggle"),          "Application launcher")
bind("SUPER + N",             exec("swaync-client --toggle-panel"),        "Notification history")
bind("SUPER + L",             exec("loginctl lock-session"),               "Lock the screen")

bind("SUPER + RETURN",        exec("uwsm app -- kitty"),                   "Terminal")
bind("SUPER + B",             exec("uwsm app -- firefox"),                 "Browser")
bind("SUPER + SHIFT + B",     exec("uwsm app -- firefox --private-window"), "Private browser")

bind("SUPER + SHIFT + C",     exec("hyprpicker -a"),                       "Pick color")

bind("Print",                 exec("snip screenshot"),                     "Screenshot")
bind("SHIFT + Print",         exec("snip record"),                         "Record selection")
bind("SUPER + Escape",        exec("snip stop"),                           "Stop recording")

-- Windows
bind("SUPER + W",             hl.dsp.window.close(),                       "Close active window")
bind("SUPER + SHIFT + W",     hl.dsp.window.kill(),                        "Force kill active window")
bind("SUPER + J",             hl.dsp.layout("togglesplit"),                "Toggle window split")
bind("SUPER + K",             hl.dsp.layout("swapsplit"),                  "Swap window split")
bind("SUPER + T",             hl.dsp.window.float({ action = "toggle" }),  "Toggle window floating/tiling")
bind("SUPER + F",             hl.dsp.window.fullscreen({ mode = "maximized" }),  "Maximize")
bind("SUPER + SHIFT + F",     hl.dsp.window.fullscreen({ mode = "fullscreen" }), "Full screen")

-- Move focus with SUPER + arrow keys
for key, dir in pairs({ left = "left", right = "right", up = "up", down = "down" }) do
    bind("SUPER + " .. key,           hl.dsp.focus({ direction = dir }),       "Move window focus " .. dir)
    -- Swap active window with the one next to it
    bind("SUPER + SHIFT + " .. key,   hl.dsp.window.swap({ direction = dir }), "Swap window " .. dir)
end

-- Resize active window
bind("SUPER + ALT + right", hl.dsp.window.resize({ x = 50,  y = 0,   relative = true }), "Increase window width",  { repeating = true })
bind("SUPER + ALT + down",  hl.dsp.window.resize({ x = 0,   y = 50,  relative = true }), "Increase window height", { repeating = true })
bind("SUPER + ALT + left",  hl.dsp.window.resize({ x = -50, y = 0,   relative = true }), "Decrease window width",  { repeating = true })
bind("SUPER + ALT + up",    hl.dsp.window.resize({ x = 0,   y = -50, relative = true }), "Decrease window height", { repeating = true })

-- Mouse window controls
hl.bind("SUPER + mouse:272",       hl.dsp.window.drag(),   { mouse = true }) -- Left mouse
hl.bind("SUPER + mouse:273",       hl.dsp.window.resize(), { mouse = true }) -- Right mouse
hl.bind("SUPER + ALT + mouse:272", hl.dsp.window.drag(),   { mouse = true }) -- Drag into or out of groups


-- Workspaces
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    bind("SUPER + " .. key,                 hl.dsp.focus({ workspace = i }),                         "Switch to workspace " .. i)
    bind("SUPER + SHIFT + " .. key,         hl.dsp.window.move({ workspace = i }),                   "Move window to workspace " .. i)
    bind("SUPER + CTRL + SHIFT + " .. key,  hl.dsp.window.move({ workspace = i, follow = false }),   "Move window silently to workspace " .. i)
end

-- Volume and brightness: repeat while held, work while locked
local held = { repeating = true, locked = true }
bind("XF86AudioRaiseVolume",  exec("swayosd-client --output-volume raise"), "Increase volume",     held)
bind("XF86AudioLowerVolume",  exec("swayosd-client --output-volume lower"), "Decrease volume",     held)
bind("XF86MonBrightnessUp",   exec("swayosd-client --brightness raise"),    "Increase brightness", held)
bind("XF86MonBrightnessDown", exec("swayosd-client --brightness lower"),    "Decrease brightness", held)

-- Media keys: work while locked
local locked = { locked = true }
bind("XF86AudioMute",    exec("swayosd-client --output-volume mute-toggle"), "Toggle mute",             locked)
bind("XF86AudioMicMute", exec("swayosd-client --input-volume mute-toggle"),  "Toggle microphone mute",  locked)
bind("XF86AudioPlay",    exec("swayosd-client --playerctl play-pause"),      "Play/Pause media",        locked)
bind("XF86AudioPause",   exec("swayosd-client --playerctl play-pause"),      "Play/Pause media",        locked)
bind("XF86AudioNext",    exec("swayosd-client --playerctl next"),            "Next track",              locked)
bind("XF86AudioPrev",    exec("swayosd-client --playerctl prev"),            "Previous track",          locked)
bind("XF86AudioStop",    exec("swayosd-client --playerctl stop"),            "Stop media",              locked)

-- Cycle layout for current workspace
-- https://wiki.hypr.land/configuring/code-snippets/#cycle-layout-for-current-workspace
local layouts = { "scrolling", "dwindle", "master", "monocle" }
bind("SUPER + SHIFT + L", function()
    local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
    if not workspace then
        return
    end

    local next_layout = layouts[1]
    for i, layout in ipairs(layouts) do
        if layout == workspace.tiled_layout then
            next_layout = layouts[(i % #layouts) + 1]
            break
        end
    end

    if workspace.special then
        -- workspace_rule replaces the whole rule, so re-state the gaps from config.lua
        hl.workspace_rule({ workspace = tostring(workspace.name), layout = next_layout, gaps_out = 35 })
    else
        hl.workspace_rule({ workspace = "name:" .. tostring(workspace.name), layout = next_layout })
    end

    notify("Layout Switched", "Workspace " .. workspace.name .. " layout set to " .. next_layout, 2000, "hypr-layout")
end, "Cycle workspace layout")

-- Scratchpad (the "special" special workspace)
local function in_scratchpad(workspace)
    return workspace ~= nil and workspace.special and (workspace.name == "special:special" or workspace.name == "special")
end

local function toggle_scratchpad()
    hl.dispatch(hl.dsp.workspace.toggle_special("special"))
end

bind("SUPER + S", function()
    -- Close whichever special workspace is open, otherwise open the scratchpad if it has windows
    local scratchpad = hl.get_workspace("special:special")
    if hl.get_active_special_workspace() or (scratchpad and scratchpad.windows > 0) then
        toggle_scratchpad()
    else
        notify("Scratchpad", "Scratchpad is empty", 1000)
    end
end, "Toggle special workspace")

bind("SUPER + CTRL + S", function()
    local window = hl.get_active_window()
    if not window then
        return
    end

    if in_scratchpad(window.workspace) then
        local remaining = window.workspace.windows - 1
        hl.dispatch(hl.dsp.window.move({ workspace = "e+0", follow = false }))
        if remaining == 0 then
            toggle_scratchpad()
        end
    else
        hl.dispatch(hl.dsp.window.move({ workspace = "special:special", follow = false }))
        notify("Scratchpad", "Window stashed in scratchpad", 1000)
    end
end, "Move window in/out of special workspace")
