/obj/item/mech_component/manipulators
	name = "arms"
	pixel_y = -12
	icon_state = "loader_arms"
	has_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)

	var/melee_damage = 10
	var/action_delay = 15
	var/obj/item/robot_parts/robot_component/actuator/motivator

/obj/item/mech_component/manipulators/ready_to_install()
	return motivator

/obj/item/mech_component/manipulators/prebuild()
	motivator = new(src)

/obj/item/mech_component/manipulators/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing,/obj/item/robot_parts/robot_component/actuator))
		if(motivator)
			user << "<span class='warning'>\The [src] already has an actuator installed.</span>"
			return
		motivator = thing
		install_component(thing, user)
	else
		return ..()