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
	h_back = /obj/item/mecha_equipment/sleeper/passenger_compartment/tank

/mob/living/heavy_vehicle/premade/pratank/Initialize()
	. = ..()
	install_system(new /obj/item/mecha_equipment/mounted_system/tankcannon(src), HARDPOINT_CANNON)
	install_system(new /obj/item/mecha_equipment/mounted_system/taser/smg/heavyy(src), HARDPOINT_MG)

/mob/living/heavy_vehicle/premade/dpratank
	name = "Yve’kha MK.III light tank"
	desc = "An adhomian tank used by the Adhomai Liberation Army."
	icon_state = "durand"

	e_head = /obj/item/mech_component/sensors/tank/dpra
	e_body = /obj/item/mech_component/chassis/tank/dpra
	e_legs = /obj/item/mech_component/propulsion/tracks/tank
	e_arms = /obj/item/mech_component/manipulators/tank
	e_color = COLOR_DARK_GUNMETAL

	h_back = /obj/item/mecha_equipment/sleeper/passenger_compartment/tank
	h_head = null

/mob/living/heavy_vehicle/premade/dpratank/Initialize()
	. = ..()
	install_system(new /obj/item/mecha_equipment/mounted_system/tankcannon(src), HARDPOINT_CANNON)
	install_system(new /obj/item/mecha_equipment/mounted_system/taser/smg/heavyy(src), HARDPOINT_MG)

/mob/living/heavy_vehicle/premade/nkaatank
	name = "Zhsram MK.II light tank"
	desc = "An adhomian tank used by the Imperial Adhomian Army."
	icon_state = "durand"

	e_head = /obj/item/mech_component/sensors/tank/nka
	e_body = /obj/item/mech_component/chassis/tank/nka
	e_legs = /obj/item/mech_component/propulsion/tracks/tank
	e_arms = /obj/item/mech_component/manipulators/tank
	e_color = COLOR_HULL

	h_back = /obj/item/mecha_equipment/sleeper/passenger_compartment/tank
	h_head = null

/mob/living/heavy_vehicle/premade/nkaatank/Initialize()
	. = ..()
	install_system(new /obj/item/mecha_equipment/mounted_system/tankcannon(src), HARDPOINT_CANNON)
	install_system(new /obj/item/mecha_equipment/mounted_system/taser/smg/heavyy(src), HARDPOINT_MG)

