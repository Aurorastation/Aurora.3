/obj/item/modulator_board
	name = "modulator board"
	desc = "A circuitboard capable of altering the function of a shield generator."
	w_class = ITEMSIZE_SMALL
	w_class = ITEMSIZE_SMALL
	flags = CONDUCT
	force = 5
	throwforce = 5
	throw_speed = 3
	throw_range = 15
	var/datum/shield_mode/mod

/obj/item/modulator_board/hyperkinetic/Initialize()
	name += " - hyperkinetic projectiles"
	origin_tech = list(TECH_ENGINEERING = 2)
	mod = new /datum/shield_mode/hyperkinetic(src)
	. = ..()

/obj/item/modulator_board/photonic/Initialize()
	name += " - photonic dispersion"
	origin_tech = list(TECH_ENGINEERING = 2)
	mod = new /datum/shield_mode/photonic(src)
	. = ..()

/obj/item/modulator_board/humanoids/Initialize()
	name += " - humanoid lifeforms"
	origin_tech = list(TECH_ENGINEERING = 2)
	mod = new /datum/shield_mode/humanoids(src)
	. = ..()

/obj/item/modulator_board/silicon/Initialize()
	name += " - silicon lifeforms"
	origin_tech = list(TECH_ENGINEERING = 2)
	mod = new /datum/shield_mode/silicon(src)
	. = ..()

/obj/item/modulator_board/mobs/Initialize()
	name += " - unknown lifeforms"
	origin_tech = list(TECH_ENGINEERING = 2)
	mod = new /datum/shield_mode/mobs(src)
	. = ..()

/obj/item/modulator_board/atmosphere/Initialize()
	name += " - atmospheric containment"
	origin_tech = list(TECH_ENGINEERING = 5)
	mod = new /datum/shield_mode/atmosphere(src)
	. = ..()

/obj/item/modulator_board/hull/Initialize()
	name += " - hull shielding"
	origin_tech = list(TECH_ENGINEERING = 2)
	mod = new /datum/shield_mode/hull(src)
	. = ..()

/obj/item/modulator_board/adaptive/Initialize()
	name += " - adaptive field harmonics"
	origin_tech = list(TECH_ENGINEERING = 8)
	mod = new /datum/shield_mode/adaptive(src)
	. = ..()

/obj/item/modulator_board/overcharge/Initialize()
	name += " - field overcharge"
	origin_tech = list(TECH_ENGINEERING = 5)
	mod = new /datum/shield_mode/overcharge(src)
	. = ..()
