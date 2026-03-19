/obj/machinery/atmospherics/binary/pump/high_power
	icon = 'icons/atmos/volume_pump.dmi'
	icon_state = "map_off"
	level = 1

	name = "high power gas pump"
	desc = "A pump. Has double the power rating of the standard gas pump."

	idle_power_usage = 450

	power_rating = 45000	//45000 W ~ 60 HP

	build_icon_state = "volumepump"

/obj/machinery/atmospherics/binary/pump/high_power/on
	use_power = POWER_USE_IDLE
	icon_state = "map_on"

/obj/machinery/atmospherics/binary/pump/high_power/update_icon()
	icon_state = "off"
	build_device_underlays(FALSE)
	ClearOverlays()
	var/list/powered_overlays = list()
	var/mutable_appearance/color_overlay = mutable_appearance(icon, "color")
	color_overlay.color = pipe_color ? pipe_color : COLOR_RED
	powered_overlays += color_overlay
	if(!powered())
		AddOverlays(powered_overlays)
		return

	if(use_power)
		powered_overlays += mutable_appearance(icon, "on")
		powered_overlays += emissive_appearance(icon, "emissive-on")
	AddOverlays(powered_overlays)
