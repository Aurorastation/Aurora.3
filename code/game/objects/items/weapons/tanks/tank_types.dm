/* Types of tanks!
 * Contains:
 *		Oxygen
 *		Anesthetic
 *		Air
 *		Phoron
 *		Emergency Oxygen
 */

/*
 * Oxygen
 */
/obj/item/tank/oxygen
	name = "oxygen tank"
	desc = "A tank of oxygen."
	icon_state = GAS_OXYGEN
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD


/obj/item/tank/oxygen/Initialize()
	. = ..()
	air_contents.adjust_gas(GAS_OXYGEN, (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))


/obj/item/tank/oxygen/examine(mob/user)
	if(..(user, 0) && air_contents.gas[GAS_OXYGEN] < 10)
		to_chat(user, text("<span class='warning'>The meter on \the [src] indicates you are almost out of oxygen!</span>"))
		//playsound(usr, 'sound/effects/alert.ogg', 50, 1)


/obj/item/tank/oxygen/yellow
	desc = "A tank of oxygen, this one is yellow."
	icon_state = "oxygen_f"

/obj/item/tank/oxygen/red
	desc = "A tank of oxygen, this one is red."
	icon_state = "oxygen_fr"

/obj/item/tank/oxygen/brown
	desc = "A tank of oxygen, this one is brown."
	icon_state = "oxygen_br"

/*
 * Anesthetic
 */
/obj/item/tank/anesthetic
	name = "anesthetic tank"
	desc = "A tank with an N2O/O2 gas mix."
	icon_state = "anesthetic"
	item_state = "an_tank"

/obj/item/tank/anesthetic/Initialize()
	. = ..()

	air_contents.gas[GAS_OXYGEN] = (3*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C) * O2STANDARD
	air_contents.gas[GAS_N2O] = (3*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C) * N2STANDARD
	air_contents.update_values()

/*
 * Air
 */
/obj/item/tank/air
	name = "air tank"
	desc = "Mixed anyone?"
	icon_state = GAS_OXYGEN

	examine(mob/user)
		if(..(user, 0) && air_contents.gas[GAS_OXYGEN] < 1 && loc==user)
			to_chat(user, "<span class='danger'>The meter on the [src.name] indicates you are almost out of air!</span>")
			user << sound('sound/effects/alert.ogg')

/obj/item/tank/air/Initialize()
	. = ..()
	air_contents.adjust_multi(GAS_OXYGEN, (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * O2STANDARD, GAS_NITROGEN, (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * N2STANDARD)


/*
 * Phoron
 */
/obj/item/tank/phoron
	name = "phoron tank"
	desc = "Contains dangerous phoron. Do not inhale. Warning: extremely flammable."
	icon_state = "phoron"
	gauge_icon = null
	flags = CONDUCT
	slot_flags = null	//they have no straps!

/obj/item/tank/phoron/Initialize()
	. = ..()
	air_contents.adjust_gas("phoron", (3*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/phoron/attackby(obj/item/W as obj, mob/user as mob)
	..()

	if (istype(W, /obj/item/flamethrower))
		var/obj/item/flamethrower/F = W
		if ((!F.status)||(F.ptank))	return
		src.master = F
		F.ptank = src
		user.remove_from_mob(src)
		src.forceMove(F)
	return

/*
 * Emergency Oxygen
 */
/obj/item/tank/emergency_oxygen
	name = "emergency oxygen tank"
	desc = "Used for emergencies. Contains very little oxygen, so try to conserve it until you actually need it."
	description_cult = "This can be reforged to become a large brown oxygen tank."
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


/obj/item/tank/emergency_oxygen/Initialize()
	. = ..()
	air_contents.adjust_gas(GAS_OXYGEN, (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))


/obj/item/tank/emergency_oxygen/examine(mob/user)
	if(..(user, 0) && air_contents.gas[GAS_OXYGEN] < 0.2 && loc==user)
		to_chat(user, text("<span class='danger'>The meter on the [src.name] indicates you are almost out of air!</span>"))
		user << sound('sound/effects/alert.ogg')

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

/obj/item/tank/emergency_nitrogen
	name = "emergency nitrogen tank"
	desc = "An emergency air tank hastily painted red and issued to Vox crewmembers."
	icon_state = "emergency_nitro"
	gauge_icon = "indicator_emergency"
	gauge_cap = 4
	flags = CONDUCT
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL
	force = 4.0
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	volume = 2


/obj/item/tank/emergency_nitrogen/Initialize()
	. = ..()
	air_contents.adjust_gas(GAS_NITROGEN, (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/emergency_nitrogen/examine(mob/user)
	if(..(user, 0) && air_contents.gas[GAS_NITROGEN] < 0.2 && loc==user)
		to_chat(user, text("<span class='danger'>The meter on \the [src] indicates you are almost out of air!</span>"))
		user << sound('sound/effects/alert.ogg')

/*
 * Nitrogen
 */
/obj/item/tank/nitrogen
	name = "nitrogen tank"
	desc = "A tank of nitrogen."
	icon_state = "oxygen_fr"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD

/obj/item/tank/nitrogen/Initialize()
	. = ..()

	air_contents.adjust_gas(GAS_NITROGEN, (3*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/nitrogen/examine(mob/user)
	if(..(user, 0) && air_contents.gas[GAS_NITROGEN] < 10)
		to_chat(user, text("<span class='danger'>The meter on \the [src] indicates you are almost out of nitrogen!</span>"))
		//playsound(user, 'sound/effects/alert.ogg', 50, 1)
