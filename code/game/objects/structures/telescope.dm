/*

	Telescope

*/

/obj/item/telescope
	name = "collapsable telescope"
	desc = "A collapsable, high power telescope, allowing obervation of the night sky in the field. This one has multiple filters allowing for readings to be taken outside of the visible range."
	icon = 'icons/obj/structure/telescope.dmi'
	icon_state = "telescope"
	item_state = "telescope"
	slot_flags = SLOT_BACK
	contained_sprite = TRUE
	w_class = ITEMSIZE_HUGE

/obj/item/telescope/afterattack(obj/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	var/turf/T = target
	if(istype(T))
		deploy_tscope(T, user)

/obj/item/telescope/attack_self(mob/user)
	. = ..()
	var/turf/T = get_turf(user)
	if(istype(T))
		deploy_tscope(T, user)

/obj/item/telescope/proc/deploy_tscope(var/turf/target, var/mob/user)
	new /obj/structure/telescope(target)
	to_chat(user, "You set up \the [src] on \the [target].")
	qdel(src)

/obj/structure/telescope
	name = "telescope"
	icon = 'icons/obj/structure/telescope.dmi'
	icon_state = "telescope_set"
	item_state = "telescope_set"
	anchored = TRUE
	density = TRUE

/obj/structure/telescope/attack_hand(mob/living/user)
	. = ..()
	if(use_check(user) || !Adjacent(user))
		return
	var/obj/abstract/weather_system/WS = SSweather.weather_by_z["[z]"]
	var/singleton/state/weather/weather = null
	if(WS)
		weather = WS.weather_system.current_state
	var/turf/T = get_turf(src)
	if(!(T.is_outside() && (!weather || !weather.blocks_sky) && T.get_uv_lumcount() <= 0.5))
		to_chat(user, SPAN_NOTICE("You don't have a view of the stars."))
		return
	user.visible_message(SPAN_NOTICE("\The [user] peers into \the [src], analysing the stars."))
	if(do_after(user, 8 SECONDS))
		var/turf/unsimulated/map/M = get_turf(GLOB.map_sectors["[z]"])
		if(!LAZYLEN(M.visible_constellations))
			to_chat(user, SPAN_NOTICE("There are no constellations visible from this location."))
			return
		to_chat(user, SPAN_NOTICE("You spot the following constellations in the skies above:"))
		for(var/datum/constellation/C in M.visible_constellations)
			to_chat(user, SPAN_NOTICE("[SPAN_BOLD(C.name)] - [C.description]"))

/obj/structure/telescope/MouseDrop(over_object, src_location, over_location)
	..()
	new /obj/item/telescope(get_turf(src))
	to_chat(usr, "You collapse \the [src].")
	qdel(src)
