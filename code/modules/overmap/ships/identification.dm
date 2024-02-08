/obj/machinery/iff_beacon
	name = "IFF transponder" //This object handles ship identification on sensors.
	desc = "A complex set of various bluespace and subspace arrays that transmit a ship's identification tags."
	icon = 'icons/obj/machinery/iff_transponder.dmi'
	icon_state = "iff"
	anchored = TRUE
	idle_power_usage = 500
	var/datum/wires/iff/wires
	var/disabled = FALSE
	var/obfuscating = FALSE
	var/can_change_class = TRUE
	var/can_change_name = TRUE

/obj/machinery/iff_beacon/Initialize()
	..()
	wires = new(src)
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/iff_beacon/LateInitialize()
	if(SSatlas.current_map.use_overmap && !linked)
		var/my_sector = GLOB.map_sectors["[z]"]
		if (istype(my_sector, /obj/effect/overmap/visitable))
			attempt_hook_up(my_sector)

/obj/machinery/iff_beacon/attackby(obj/item/attacking_item, mob/user)
	if(default_deconstruction_screwdriver(user, attacking_item))
		return TRUE

	if(panel_open)
		if(attacking_item.ismultitool() || attacking_item.iswirecutter())
			if(panel_open)
				wires.interact(user)
			else
				to_chat(user, SPAN_WARNING("\The [src]'s wires aren't exposed."))
			return TRUE
	..()

/obj/machinery/iff_beacon/proc/toggle()
	if(disabled)
		return // No turning on if broken.
	if(!use_power) //need some juice to kickstart
		use_power_oneoff(idle_power_usage*5)
	update_use_power(!use_power)
	if(use_power) //We are online now. Back to displaying real name.
		linked.update_obfuscated(FALSE)
		obfuscating = FALSE
	else
		linked.update_obfuscated(TRUE)
		obfuscating = TRUE

/obj/machinery/iff_beacon/proc/disable()
	update_use_power(POWER_USE_OFF)
	obfuscating = TRUE
	disabled = TRUE
	linked.update_obfuscated(TRUE)

/obj/machinery/iff_beacon/proc/enable()
	disabled = FALSE
	toggle()

/obj/machinery/iff_beacon/update_icon()
	icon_state = initial(icon_state)
	cut_overlays()
	if(panel_open)
		icon_state += "_o"
	if(!operable() || !use_power)
		icon_state += "_off"

/obj/machinery/iff_beacon/horizon
	can_change_class = FALSE
	can_change_name = FALSE

/obj/machinery/iff_beacon/horizon/shuttle
	icon = 'icons/obj/spaceship/scc/helm_pieces.dmi'
	icon_state = "iff"

/obj/machinery/iff_beacon/name_change
	can_change_name = TRUE
	can_change_class = FALSE
