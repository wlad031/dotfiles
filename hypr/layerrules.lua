-- lua migration of layerrules.conf

hl.layer_rule({
    name = "blur-swaync-control-center",
    match = {
        namespace = "swaync-control-center",
    },
    blur = true,
})

hl.layer_rule({
    name = "blur-swaync-notification-window",
    match = {
        namespace = "swaync-notification-window",
    },
    blur = true,
})

hl.layer_rule({
    name = "ignore-alpha-default-control-center",
    match = {
        namespace = "swaync-control-center",
    },
    ignore_alpha = 0,
})

hl.layer_rule({
    name = "ignore-alpha-default-notification-window",
    match = {
        namespace = "swaync-notification-window",
    },
    ignore_alpha = 0,
})

hl.layer_rule({
    name = "ignore-alpha-half-control-center",
    match = {
        namespace = "swaync-control-center",
    },
    ignore_alpha = 0.5,
})

hl.layer_rule({
    name = "ignore-alpha-half-notification-window",
    match = {
        namespace = "swaync-notification-window",
    },
    ignore_alpha = 0.5,
})
