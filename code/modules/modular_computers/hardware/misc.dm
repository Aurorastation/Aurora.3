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
        parent_computer.light_range = range
        parent_computer.light_power = power
        tweak_light(parent_computer)

/obj/item/computer_hardware/flashlight/disable()
    . = ..()
    if(parent_computer)
        parent_computer.light_range = initial(parent_computer.light_range)
        parent_computer.light_power = initial(parent_computer.light_power)
        tweak_light(parent_computer)

/obj/item/computer_hardware/flashlight/proc/tweak_brightness(var/new_power)
    . = power = Clamp(0, new_power, 1)
    parent_computer.light_power = power
    tweak_light(parent_computer)

/obj/item/computer_hardware/flashlight/proc/tweak_light(var/obj/item/modular_computer/C)
    if(!istype(C))
        return
    C.set_light(C.light_range, C.light_power, l_color = flashlight_color)
