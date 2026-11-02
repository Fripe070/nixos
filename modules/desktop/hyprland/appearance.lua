hl.config({
    decoration = {
        active_opacity = 1.0,
        inactive_opacity = 0.92,
        dim_special = 0.5,
    },
})

hl.animation({ leaf = "fade",       enabled = false })
hl.animation({ leaf = "windows",    enabled = true, speed = 1, bezier = "default", style = "slide" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "default", style = "slidefade" })
