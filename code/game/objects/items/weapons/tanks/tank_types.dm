/* Types of tanks!
 * Contains:
 * * Oxygen
 * * Anesthetic
 * * Air
 * * Phoron
 * * Hydrogen
 * * Emergency Oxygen
 */

/*
 * Oxygen
 */
/obj/item/tank/oxygen
	name = "oxygen tank"
	desc = "A tank of oxygen."
	icon_state = "oxygen"
	item_state = "oxygen"
	volume = LARGE_TANK_VOLUME
	distribute_pressure = ONE_ATMOSPHERE * O2STANDARD
	starting_pressure = list(
		GAS_OXYGEN = 6 * ONE_ATMOSPHERE
	)

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
	starting_pressure = list(
		GAS_OXYGEN = 10 * ONE_ATMOSPHERE
	)

/*
 * Anesthetic
 */
/obj/item/tank/anesthetic
	name = "anesthetic tank"
	desc = "A tank with an N2O/O2 gas mix."
	icon_state = "anesthetic"
	item_state = "an_tank"
	volume = LARGE_TANK_VOLUME
	starting_pressure = list(
		GAS_OXYGEN = 6 * ONE_ATMOSPHERE * O2STANDARD,
		GAS_N2O = 6 * ONE_ATMOSPHERE * N2STANDARD
	)

/*
 * Air
 */
/obj/item/tank/air
	name = "air tank"
	desc = "Mixed anyone?"
	icon_state = "oxygen"
	item_state = "oxygen"
	volume = LARGE_TANK_VOLUME
	starting_pressure = list(
		GAS_OXYGEN = 6 * ONE_ATMOSPHERE * O2STANDARD,
		GAS_NITROGEN = 6 * ONE_ATMOSPHERE * N2STANDARD
	)

/*
 * Phoron
 */
/obj/item/tank/phoron
	name = "phoron tank"
	desc = "Contains dangerous phoron. Do not inhale. Warning: extremely flammable."
	icon_state = "phoron"
	item_state = "phoron"
	gauge_icon = null
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = null	//they have no straps!
	starting_pressure = list(
		GAS_PHORON = 3 * ONE_ATMOSPHERE
	)

/obj/item/tank/phoron/shuttle
	starting_pressure = list(
		GAS_PHORON = 4 * ONE_ATMOSPHERE
	)

/*
*Hydrogen
*/

/obj/item/tank/hydrogen
	name = "hydrogen tank"
	desc = "Contains gaseous hydrogen. Do not inhale. Warning: extremely flammable."
	icon_state = "hydrogen"
	item_state = "hydrogen"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	starting_pressure = list(
		GAS_HYDROGEN = 3 * ONE_ATMOSPHERE
	)

/obj/item/tank/hydrogen/shuttle
	starting_pressure = list(
		GAS_HYDROGEN = 4 * ONE_ATMOSPHERE
	)

/*
 * Emergency Oxygen
 */
/obj/item/tank/emergency_oxygen
	name = "emergency oxygen tank"
	desc = "Used for emergencies. Contains very little oxygen, so try to conserve it until you actually need it."
	icon_state = "emergency"
	item_state = "emergency"
	gauge_icon = "indicator_emergency"
	gauge_cap = 4
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	force = 4
	volume = EMERGENCY_TANK_VOLUME
	distribute_pressure = ONE_ATMOSPHERE * O2STANDARD
	starting_pressure = list(
		GAS_OXYGEN = 10 * ONE_ATMOSPHERE
	)

/obj/item/tank/emergency_oxygen/antagonist_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "As a Cultist, this item can be reforged to become a large brown oxygen tank."

/obj/item/tank/emergency_oxygen/engi
	name = "extended-capacity emergency oxygen tank"
	icon_state = "emergency_engi"
	item_state = "emergency_engi"
	volume = EMERGENCY_EXTENDED_TANK_VOLUME

/obj/item/tank/emergency_oxygen/double
	name = "double emergency oxygen tank"
	icon_state = "emergency_double"
	item_state = "emergency_engi"
	gauge_icon = "indicator_emergency_double"
	volume = EMERGENCY_DOUBLE_TANK_VOLUME
