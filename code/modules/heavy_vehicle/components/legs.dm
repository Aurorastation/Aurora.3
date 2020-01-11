/obj/item/mech_component/propulsion
	name = "legs"
	center_of_mass = list("x"=24, "y"=4)
	icon_state = "loader_legs"
	power_use = 75
	var/move_delay = 5
	var/turn_delay = 5
	var/obj/item/robot_parts/robot_component/actuator/motivator
	var/mech_turn_sound = 'sound/mecha/mechturn.ogg'
	var/mech_step_sound = 'sound/mecha/mechstep.ogg'
	var/trample_damage = 5
	var/hover = FALSE // Can this leg allow you to easily travel z-levels?

/obj/item/mech_component/propulsion/Destroy()
	QDEL_NULL(motivator)
	. = ..()

/obj/item/mech_component/propulsion/show_missing_parts(var/mob/user)
	if(!motivator)
		to_chat(user, "<span class='warning'>It is missing a motivator.</span>")

/obj/item/mech_component/propulsion/ready_to_install()
	return motivator

/obj/item/mech_component/propulsion/update_components()
	motivator = locate() in src

/obj/item/mech_component/propulsion/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing,/obj/item/robot_parts/robot_component/actuator))
		if(motivator)
			to_chat(user, "<span class='warning'>\The [src] already has an actuator installed.</span>")
			return
		motivator = thing
		install_component(thing, user)
	else
		return ..()

/obj/item/mech_component/propulsion/prebuild()
	motivator = new(src)

/obj/item/mech_component/propulsion/proc/can_move_on(var/turf/location, var/turf/target_loc)
	if(!istype(location))
		return 1 // Inside something, assume you can get out.
	if(!istype(target_loc))
		return 0 // What are you even doing.
	return 1