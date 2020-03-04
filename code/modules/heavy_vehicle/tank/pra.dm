/mob/living/heavy_vehicle/premade/pratank
	name = "Ha'rron MK.V light tank"
	desc = "An adhomian tank used by the Grand People's Army."
	icon_state = "durand"

	e_head = /obj/item/mech_component/sensors/tank
	e_body = /obj/item/mech_component/chassis/tank
	e_legs = /obj/item/mech_component/propulsion/tracks/tank
	e_arms = /obj/item/mech_component/manipulators/tank
	e_color = "#557037"

	h_head = null

/mob/living/heavy_vehicle/premade/pratank/Initialize()
	. = ..()
	install_system(new /obj/item/mecha_equipment/mounted_system/tankcannon(src), HARDPOINT_CANNON)
	install_system(new /obj/item/mecha_equipment/mounted_system/taser/smg/heavyy(src), HARDPOINT_MG)
