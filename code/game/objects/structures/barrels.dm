
// Barrels //

/obj/structure/barrel
	name = "barrel"
	desc = "A sealed canister of mystery, closed to time."
	icon = 'mojave/icons/structure/barrels.dmi'
	max_integrity = 400
	anchored = TRUE
	density = TRUE
	var/icon_type = null
	var/amount = 3 //used for icon randomisation amount
	var/unique = FALSE //used to set if the icon is randomised or not

/obj/structure/barrel/Initialize()
	. = ..()
	if(!unique)
		icon_state = "[icon_type]_[rand(1, amount)]"

/obj/structure/barrel/single

/obj/structure/barrel/single/grey
	icon_state = "grey_1"
	icon_type = "grey"

/obj/structure/barrel/single/grey/one
	icon_state = "grey_1"
	unique = TRUE

/obj/structure/barrel/single/grey/two
	icon_state = "grey_2"
	unique = TRUE

/obj/structure/barrel/single/grey/three
	icon_state = "grey_3"
	unique = TRUE

/obj/structure/barrel/single/red
	icon_state = "red_1"
	icon_type = "red"

/obj/structure/barrel/single/red/one
	icon_state = "red_1"
	unique = TRUE

/obj/structure/barrel/single/red/two
	icon_state = "red_2"
	unique = TRUE

/obj/structure/barrel/single/red/three
	icon_state = "red_3"
	unique = TRUE

/obj/structure/barrel/single/yellow
	icon_state = "yellow_1"
	icon_type = "yellow"

/obj/structure/barrel/single/yellow/one
	icon_state = "yellow_1"
	unique = TRUE

/obj/structure/barrel/single/yellow/two
	icon_state = "yellow_2"
	unique = TRUE

/obj/structure/barrel/single/yellow/three
	icon_state = "yellow_3"
	unique = TRUE

/obj/structure/barrel/single/label
	icon_state = "label_1"
	icon_type = "label"

/obj/structure/barrel/single/label/one
	icon_state = "label_1"
	unique = TRUE

/obj/structure/barrel/single/label/two
	icon_state = "label_2"
	unique = TRUE

/obj/structure/barrel/single/label/three
	icon_state = "label_3"
	unique = TRUE

/obj/structure/barrel/single/hazard
	icon_state = "hazard_1"
	icon_type = "hazard"

/obj/structure/barrel/single/hazard/one
	icon_state = "hazard_1"
	unique = TRUE

/obj/structure/barrel/single/hazard/two
	icon_state = "hazard_2"
	unique = TRUE

/obj/structure/barrel/single/hazard/three
	icon_state = "hazard_3"
	unique = TRUE

/obj/structure/barrel/single/redalt
	icon_state = "red_alt_1"
	icon_type = "red_alt"

/obj/structure/barrel/single/redalt/one
	icon_state = "red_alt_1"
	unique = TRUE

/obj/structure/barrel/single/redalt/two
	icon_state = "red_alt_2"
	unique = TRUE

/obj/structure/barrel/single/redalt/three
	icon_state = "red_alt_3"
	unique = TRUE

/obj/structure/barrel/single/toxic
	icon_state = "toxic_1"
	icon_type = "toxic"
	amount = 4
	light_range = 1.5
	light_color = "#4ba54f"

/obj/structure/barrel/single/toxic/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/structure/barrel/single/toxic/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/structure/barrel/single/toxic/process()
	for(var/mob/living/L in range(4,src))
		L.apply_damage(25, DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)

/obj/structure/barrel/single/toxic/one
	icon_state = "toxic_1"
	unique = TRUE

/obj/structure/barrel/single/toxic/two
	icon_state = "toxic_2"
	unique = TRUE

/obj/structure/barrel/single/toxic/three
	icon_state = "toxic_3"
	unique = TRUE

/obj/structure/barrel/single/toxic/four
	icon_state = "toxic_4"
	unique = TRUE

/obj/structure/barrel/single/waste
	icon_state = "waste_1"
	icon_type = "waste"

/obj/structure/barrel/single/waste/one
	icon_state = "waste_1"
	unique = TRUE

/obj/structure/barrel/single/waste/two
	icon_state = "waste_2"
	unique = TRUE

/obj/structure/barrel/single/waste/three
	icon_state = "waste_3"
	unique = TRUE

/obj/structure/barrel/single/flammable
	icon_state = "flammable_1"
	icon_type = "flammable"

/obj/structure/barrel/single/flammable/one
	icon_state = "flammable_1"
	unique = TRUE

/obj/structure/barrel/single/flammable/two
	icon_state = "flammable_2"
	unique = TRUE

/obj/structure/barrel/single/flammable/three
	icon_state = "flammable_3"
	unique = TRUE

/obj/structure/barrel/single/warning
	icon_state = "warning_1"
	icon_type = "warning"

/obj/structure/barrel/single/warning/one
	icon_state = "warning_1"
	unique = TRUE

/obj/structure/barrel/single/warning/two
	icon_state = "warning_2"
	unique = TRUE

/obj/structure/barrel/single/warning/three
	icon_state = "warning_3"
	unique = TRUE

/obj/structure/barrel/double
	name = "barrels"
	desc = "Sealed canisters of mystery, closed to time."
	amount = 2

/obj/structure/barrel/double/grey
	icon_state = "double_grey_1"
	icon_type = "double_grey"

/obj/structure/barrel/double/grey/one
	icon_state = "double_grey_1"
	unique = TRUE

/obj/structure/barrel/double/grey/two
	icon_state = "double_grey_2"
	unique = TRUE

/obj/structure/barrel/double/red
	icon_state = "double_red_1"
	icon_type = "double_red"

/obj/structure/barrel/double/red/one
	icon_state = "double_red_1"
	unique = TRUE

/obj/structure/barrel/double/red/two
	icon_state = "double_red_2"
	unique = TRUE

/obj/structure/barrel/double/yellow
	icon_state = "double_yellow_1"
	icon_type = "double_yellow"

/obj/structure/barrel/double/yellow/one
	icon_state = "double_yellow_1"
	unique = TRUE

/obj/structure/barrel/double/yellow/two
	icon_state = "double_yellow_2"
	unique = TRUE

/obj/structure/barrel/double/waste
	icon_state = "double_waste_1"
	icon_type = "double_waste"
	amount = 1

/obj/structure/barrel/triple
	name = "barrels"
	desc = "Sealed canisters of mystery, closed to time."

/obj/structure/barrel/triple/grey
	icon_state = "triple_grey_1"
	icon_type = "triple_grey"

/obj/structure/barrel/triple/grey/one
	icon_state = "triple_grey_1"
	unique = TRUE

/obj/structure/barrel/triple/grey/two
	icon_state = "triple_grey_2"
	unique = TRUE

/obj/structure/barrel/triple/grey/three
	icon_state = "triple_grey_3"
	unique = TRUE

/obj/structure/barrel/triple/red
	icon_state = "triple_red_1"
	icon_type = "triple_red"
	amount = 2

/obj/structure/barrel/triple/red/one
	icon_state = "triple_red_1"
	unique = TRUE

/obj/structure/barrel/triple/red/two
	icon_state = "triple_red_2"
	unique = TRUE

/obj/structure/barrel/triple/yellow
	icon_state = "triple_yellow_1"
	icon_type = "triple_yellow"

/obj/structure/barrel/triple/yellow/one
	icon_state = "triple_yellow_1"
	unique = TRUE

/obj/structure/barrel/triple/yellow/two
	icon_state = "triple_yellow_2"
	unique = TRUE

/obj/structure/barrel/triple/yellow/three
	icon_state = "triple_yellow_3"
	unique = TRUE

/obj/structure/barrel/triple/waste
	icon_state = "triple_waste_1"
	icon_type = "triple_waste"
	amount = 2

/obj/structure/barrel/triple/waste/one
	icon_state = "triple_waste_1"
	unique = TRUE

/obj/structure/barrel/triple/waste/two
	icon_state = "triple_waste_2"
	unique = TRUE

/obj/structure/barrel/quadruple
	name = "barrels"
	desc = "Sealed canisters of mystery, closed to time."
	amount = 1

/obj/structure/barrel/quadruple/grey
	icon_state = "quad_grey_1"
	icon_type = "quad_grey"

/obj/structure/barrel/quadruple/grey/one
	icon_state = "quad_grey_1"
	unique = TRUE

/obj/structure/barrel/quadruple/red
	icon_state = "quad_red_1"
	icon_type = "quad_red"
	amount = 2

/obj/structure/barrel/quadruple/red/one
	icon_state = "quad_red_1"
	unique = TRUE

/obj/structure/barrel/quadruple/red/two
	icon_state = "quad_red_2"
	unique = TRUE

/obj/structure/barrel/quadruple/yellow
	icon_state = "quad_yellow_1"
	icon_type = "quad_yellow"

/obj/structure/barrel/quadruple/yellow/one
	icon_state = "quad_yellow_1"
	unique = TRUE

/obj/structure/barrel/quadruple/waste
	icon_state = "quad_waste_1"
	icon_type = "quad_waste"

/obj/structure/barrel/quadruple/waste/one
	icon_state = "quad_waste_1"
	unique = TRUE
