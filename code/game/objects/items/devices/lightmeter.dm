// Light meter, intended for debugging.

/obj/item/device/light_meter
	name = "light meter"
	desc = "A simple device that measures ambient light levels."
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"

	// Copied from debugger.dm
	flags = CONDUCT
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3
	matter = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 20)
	var/low = 0
	var/high = 1

/obj/item/device/light_meter/attack_self(mob/user as mob)
	var/turf/T = get_turf(user.loc)
	if (!T)
		to_chat(user, span("alert", "Unable to read light levels."))
		return

	var/visible_reading = T.get_lumcount(low, high)
	var/uv_reading = T.get_uv_lumcount(low, high)

	var/reading = "Light analysis for <b>\the [T]</b>.<br>"
	reading += "Visible light: <b>[visible_reading]</b> lx<br>"
	reading += "Ultraviolet light: <b>[uv_reading]</b> lx ([uv_reading * 5.5 - 1.5] adlx)"

	to_chat(usr, span("notice", reading))

/obj/item/device/light_meter/verb/set_low_bound()
	set category = "Object"
	set name = "Set Detector Low-Bound"
	set src in usr

	var/num = input(usr, "Please enter the low-bound for the detector") as num|null
	if (null)
		return

	low = num

/obj/item/device/light_meter/verb/set_high_bound()
	set category = "Object"
	set name = "Set Detector High-Bound"
	set src in usr

	var/num = input(usr, "Please enter the high-bound for the detector") as num|null
	if (null)
		return

	high = num
