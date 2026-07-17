/obj/item/computer_hardware/flashlight
	name = "flashlight"
	desc = "A small pen-sized flashlight used to illuminate a small area."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "headlights"
	power_usage = 50
	enabled = FALSE
	critical = FALSE

	light_range = 1.2
	light_power = 0.5
	light_color = LIGHT_COLOR_HALOGEN
	light_system = MOVABLE_LIGHT

	light_on = FALSE

/obj/item/computer_hardware/flashlight/enable()
	. = ..()
	if(parent_computer)
		parent_computer.set_light_range_power_color(light_range, light_power, light_color)
		parent_computer.set_light_on(enabled)

/obj/item/computer_hardware/flashlight/disable()
	. = ..()
	if(parent_computer)
		parent_computer.set_light_on(enabled)

/obj/item/computer_hardware/flashlight/proc/tweak_brightness(var/new_power)
	set_light_power(clamp(0, new_power, 1))
	if(parent_computer && enabled)
		parent_computer.set_light_power(light_power)
