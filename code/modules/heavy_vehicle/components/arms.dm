/obj/item/mech_component/manipulators
	name = "arms"
	pixel_y = -12
	icon_state = "loader_arms"
	has_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	power_use = 50
	var/damagetype = BRUTE

	var/punch_sound = 'sound/mecha/mech_punch.ogg'

	var/melee_damage = 20
	var/action_delay = 15
	var/obj/item/robot_parts/robot_component/actuator/motivator

/obj/item/mech_component/manipulators/Destroy()
	QDEL_NULL(motivator)
	. = ..()

/obj/item/mech_component/manipulators/show_missing_parts(var/mob/user)
	if(!motivator)
		to_chat(user, SPAN_WARNING("It is missing an <a href='?src=\ref[src];info=actuator'>actuator</a>."))

/obj/item/mech_component/manipulators/Topic(href, href_list)
	. = ..()
	if(.)
		return
	switch(href_list["info"])
		if("actuator")
			to_chat(usr, SPAN_NOTICE("An actuator can be created at a mechatronic fabricator."))

/obj/item/mech_component/manipulators/return_diagnostics(mob/user)
	..()
	if(motivator)
		to_chat(user, SPAN_NOTICE("  - Actuator Integrity: <b>[round(((motivator.max_dam - motivator.total_dam) / motivator.max_dam) * 100, 0.1)]%</b>"))
	else
		to_chat(user, SPAN_WARNING("  - Actuator Missing or Non-functional."))

/obj/item/mech_component/manipulators/ready_to_install()
	return motivator

/obj/item/mech_component/manipulators/prebuild()
	motivator = new(src)

/obj/item/mech_component/manipulators/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing,/obj/item/robot_parts/robot_component/actuator))
		if(motivator)
			to_chat(user, SPAN_WARNING("\The [src] already has an actuator installed."))
			return
		if(install_component(thing, user)) motivator = thing
	else
		return ..()

/obj/item/mech_component/manipulators/update_components()
	motivator = locate() in src