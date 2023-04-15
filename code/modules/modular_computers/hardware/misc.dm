/obj/item/computer_hardware/flashlight
    name = "flashlight"
    desc = "A small pen-sized flashlight used to illuminate a small area."
    icon = 'icons/obj/lighting.dmi'
    icon_state = "headlights"
    power_usage = 50
    enabled = FALSE
    critical = FALSE
    var/range = 2
    var/power = 1
    var/flashlight_color = LIGHT_COLOR_HALOGEN

/obj/item/computer_hardware/flashlight/enable()
    . = ..()
    if(parent_computer)
        parent_computer.set_light(range, power, flashlight_color)

/obj/item/computer_hardware/flashlight/disable()
    . = ..()
    if(parent_computer)
        parent_computer.set_light(initial(parent_computer.light_range), initial(parent_computer.light_power), flashlight_color)

/obj/item/computer_hardware/flashlight/proc/tweak_brightness(var/new_power)
    . = power = Clamp(0, new_power, 1)
    if(parent_computer && enabled)
        parent_computer.set_light(range, power, flashlight_color)
