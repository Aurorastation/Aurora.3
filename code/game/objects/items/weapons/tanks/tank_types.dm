/* Types of tanks!
 * Contains:
 *		Oxygen
 *		Anesthetic
 *		Air
 *		Phoron
 *		Hydrogen
 *		Emergency Oxygen
 */

/*
 * Oxygen
 */
/obj/item/tank/oxygen
	name = "oxygen tank"
	desc = "A tank of oxygen."
	icon_state = "oxygen"
	item_state = "oxygen"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD

/obj/item/tank/oxygen/adjust_initial_gas()
	air_contents.adjust_gas(GAS_OXYGEN, (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/oxygen/examine(mob/user)
	if(..(user, 0) && air_contents.gas[GAS_OXYGEN] < 10)
		to_chat(user, text("<span class='warning'>The meter on \the [src] indicates you are almost out of oxygen!</span>"))

/obj/item/tank/oxygen/yellow
	desc = "A tank of oxygen, this one is yellow."
	icon_state = "oxygen_f"
	item_state = "oxygen_f"

/obj/item/tank/oxygen/red
	desc = "A tank of oxygen, this one is red."
	icon_state = "oxygen_fr"
	item_state = "oxygen_fr"

/obj/item/tank/oxygen/brown
	desc = "A tank of oxygen, this one is brown."
	icon_state = "oxygen_br"
	item_state = "oxygen_br"

/obj/item/tank/oxygen/marooning_equipment
	name = "marooning oxygen tank"
	desc = "A tank of oxygen, this one is yellow. Issued to marooned personnel."
	icon_state = "oxygen_f"
	item_state = "oxygen_f"

/obj/item/tank/oxygen/marooning_equipment/adjust_initial_gas()
	air_contents.adjust_gas(GAS_OXYGEN, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/*
 * Anesthetic
 */
/obj/item/tank/anesthetic
	name = "anesthetic tank"
	desc = "A tank with an N2O/O2 gas mix."
	icon_state = "anesthetic"
	item_state = "an_tank"

/obj/item/tank/anesthetic/adjust_initial_gas()
	air_contents.gas[GAS_OXYGEN] = (3*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C) * O2STANDARD
	air_contents.gas[GAS_N2O] = (3*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C) * N2STANDARD
	air_contents.update_values()

/*
 * Air
 */
/obj/item/tank/air
	name = "air tank"
	desc = "Mixed anyone?"
	icon_state = "oxygen"
	item_state = "oxygen"

/obj/item/tank/air/adjust_initial_gas()
	air_contents.adjust_multi(GAS_OXYGEN, (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * O2STANDARD, GAS_NITROGEN, (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * N2STANDARD)

/obj/item/tank/air/examine(mob/user)
	if(..(user, 0) && air_contents.gas[GAS_OXYGEN] < 1 && loc==user)
		to_chat(user, "<span class='danger'>The meter on the [src.name] indicates you are almost out of air!</span>")

/*
 * Phoron
 */
/obj/item/tank/phoron
	name = "phoron tank"
	desc = "Contains dangerous phoron. Do not inhale. Warning: extremely flammable."
	icon_state = "phoron"
	item_state = "phoron"
	gauge_icon = null
	flags = CONDUCT
	slot_flags = null	//they have no straps!

/obj/item/tank/phoron/adjust_initial_gas()
	air_contents.adjust_gas(GAS_PHORON, (3*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/phoron/shuttle/adjust_initial_gas()
	air_contents.adjust_gas(GAS_PHORON, 4*(3*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/phoron/attackby(obj/item/W as obj, mob/user as mob)
	..()

	if (istype(W, /obj/item/flamethrower))
		var/obj/item/flamethrower/F = W
		if ((!F.secured)||(F.gas_tank))	return
		src.master = F
		F.gas_tank = src
		user.remove_from_mob(src)
		src.forceMove(F)
	return
/*
*Hydrogen
*/

/obj/item/tank/hydrogen
	name = "hydrogen tank"
	desc = "Contains gaseous hydrogen. Do not inhale. Warning: extremely flammable."
	icon_state = "hydrogen"
	item_state = "hydrogen"
	flags = CONDUCT

/obj/item/tank/hydrogen/adjust_initial_gas()
	air_contents.adjust_gas(GAS_HYDROGEN, (3*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/hydrogen/shuttle/adjust_initial_gas()
	air_contents.adjust_gas(GAS_HYDROGEN, 4*(3*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C))

/*
 * Emergency Oxygen
 */
/obj/item/tank/emergency_oxygen
	name = "emergency oxygen tank"
	desc = "Used for emergencies. Contains very little oxygen, so try to conserve it until you actually need it."
	desc_cult = "This can be reforged to become a large brown oxygen tank."
	icon_state = "emergency"
	item_state = "emergency"
	gauge_icon = "indicator_emergency"
	gauge_cap = 4
	flags = CONDUCT
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL
	force = 4.0
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	volume = 2 //Tiny. Real life equivalents only have 21 breaths of oxygen in them. They're EMERGENCY tanks anyway -errorage (dangercon 2011)

/obj/item/tank/emergency_oxygen/adjust_initial_gas()
	air_contents.adjust_gas(GAS_OXYGEN, (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/emergency_oxygen/examine(mob/user)
	if(..(user, 0) && air_contents.gas[GAS_OXYGEN] < 0.2 && loc==user)
		to_chat(user, text("<span class='danger'>The meter on the [src.name] indicates you are almost out of air!</span>"))

/obj/item/tank/emergency_oxygen/engi
	name = "extended-capacity emergency oxygen tank"
	icon_state = "emergency_engi"
	item_state = "emergency_engi"
	volume = 6

/obj/item/tank/emergency_oxygen/double
	name = "double emergency oxygen tank"
	icon_state = "emergency_double"
	item_state = "emergency_engi"
	gauge_icon = "indicator_emergency_double"
	volume = 10