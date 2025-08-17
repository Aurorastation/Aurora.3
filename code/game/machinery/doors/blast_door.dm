// BLAST DOORS
//
// Refactored 27.12.2014 by Atlantis
//
// Blast doors are suposed to be reinforced versions of regular doors. Instead of being manually
// controlled they use buttons or other means of remote control. This is why they cannot be emagged
// as they lack any ID scanning system, they just handle remote control signals. Subtypes have
// different icons, which are defined by set of variables. Subtypes are on bottom of this file.
#define BLAST_DOOR_CRUSH_DAMAGE 40
#define SHUTTER_CRUSH_DAMAGE 10

/obj/machinery/door/blast
	name = "blast door"
	desc = "That looks like it doesn't open easily."
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = null
	dir = 1
	closed_layer = ABOVE_DOOR_LAYER
	explosion_resistance = 25
	pass_flags_self = PASSDOORS

	/// Most blast doors are infrequently toggled and sometimes used with regular doors anyways.
	/// Turning this off prevents awkward zone geometry in places like medbay lobby, for example.
	block_air_zones = 0

	/// Icon states for different shutter types. Simply change this instead of rewriting the update_icon proc.
	var/icon_state_open = null
	var/icon_state_opening = null
	var/icon_state_closed = null
	var/icon_state_closing = null
	var/open_sound = 'sound/machines/blastdooropen.ogg'
	var/close_sound = 'sound/machines/blastdoorclose.ogg'
	var/damage = BLAST_DOOR_CRUSH_DAMAGE
	var/id = 1.0

	var/_wifi_id
	var/datum/wifi/receiver/button/door/wifi_receiver

	var/securitylock = TRUE
	/// If the blast door should close when power goes out.
	var/fail_secure = FALSE

/obj/machinery/door/blast/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)
	if(density)
		layer = closed_layer
	else
		layer = open_layer

/obj/machinery/door/blast/Destroy()
	QDEL_NULL(wifi_receiver)
	return ..()

/**
 * If are open, return zero. Otherwise return result of parent function.
 *
 * * atom/bumped_atom - Atom that tried to walk through this object
 */
/obj/machinery/door/blast/CollidedWith(atom/bumped_atom)
	if(!density)
		return ..()
	else
		return 0

/**
 * Updates icon of this object. Uses icon state variables.
 */
/obj/machinery/door/blast/update_icon()
	if(density)
		icon_state = icon_state_closed
	else
		icon_state = icon_state_open
	return

/**
 * Opens the door. No checks are done inside this proc.
 */
/obj/machinery/door/blast/proc/force_open()
	src.operating = 1
	playsound(src.loc, open_sound, 100, 1)
	flick(icon_state_opening, src)
	src.density = 0
	update_nearby_tiles()
	src.update_icon()
	src.set_opacity(0)
	sleep(15)
	src.layer = open_layer
	src.operating = 0

/**
 * Closes the door. No checks are done inside this proc.
 */
/obj/machinery/door/blast/proc/force_close()
	if(density)
		return 0
	src.operating = 1
	playsound(src.loc, close_sound, 100, 1)
	src.layer = closed_layer
	flick(icon_state_closing, src)
	src.density = 1
	update_nearby_tiles()
	src.update_icon()
	src.set_opacity(1)
	sleep(15)
	src.operating = 0

/**
 * Opens or closes the door, depending on current state. No checks are done inside this proc.
 */
/obj/machinery/door/blast/proc/force_toggle()
	if(src.density)
		src.force_open()
	else
		src.force_close()

/**
 * If we are clicked with crowbar, wielded fire axe, etc., try to manually open the door.
 * This only works on broken doors or doors without power.
 * Also allows repair with Plasteel.
 *
 * * obj/item/attacking_item - Item this object was clicked with
 * * mob/user - Mob which clicked this object
 */
/obj/machinery/door/blast/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, /obj/item/forensics))
		src.add_fingerprint(user)
	if(istype(attacking_item, /obj/item/material/twohanded/fireaxe))
		var/obj/item/material/twohanded/fireaxe/F = attacking_item
		if(!F.wielded)
			return TRUE

		if(((stat & NOPOWER) || (stat & BROKEN)) && !src.operating)
			force_toggle()
		else
			to_chat(usr, SPAN_NOTICE("[src]'s motors resist your effort."))

		return TRUE

	if(attacking_item.ishammer() || istype(attacking_item, /obj/item/crowbar/hydraulic_rescue_tool))
		if(((stat & NOPOWER) || (stat & BROKEN)) && !src.operating)
			force_toggle()
		else
			to_chat(usr, SPAN_NOTICE("[src]'s motors resist your effort."))

		return TRUE

	if(istype(attacking_item, /obj/item/stack/material) && attacking_item.get_material_name() == "plasteel")
		var/amt = Ceiling((maxhealth - health)/150)
		if(!amt)
			to_chat(usr, SPAN_NOTICE("\The [src] is already fully repaired."))
			return TRUE
		var/obj/item/stack/P = attacking_item
		if(P.amount < amt)
			to_chat(usr, SPAN_WARNING("You don't have enough sheets to repair this! You need at least [amt] sheets."))
			return TRUE
		to_chat(usr, SPAN_NOTICE("You begin repairing [src]..."))
		if(do_after(usr, 3 SECONDS, src, DO_REPAIR_CONSTRUCT))
			if(P.use(amt))
				to_chat(usr, SPAN_NOTICE("You have repaired \The [src]"))
				src.repair()
			else
				to_chat(usr, SPAN_WARNING("You don't have enough sheets to repair this! You need at least [amt] sheets."))
		return TRUE

/**
 * Opens the door. Does necessary checks. Automatically closes if autoclose is true.
 */
/obj/machinery/door/blast/open()
	if (src.operating || (stat & BROKEN || stat & NOPOWER))
		return
	force_open()
	if(autoclose)
		addtimer(CALLBACK(src, PROC_REF(close)), 15 SECONDS)
	return 1

/**
 * Closes the door. Does necessary checks.
 */
/obj/machinery/door/blast/close()
	if (src.operating || (stat & BROKEN || stat & NOPOWER))
		return
	force_close()
	for(var/turf/turf in locs)
		for(var/atom/movable/AM in turf)
			if(AM.airlock_crush(damage))
				take_damage(damage*0.2)


/**
 * Fully repairs the blast door.
 */
/obj/machinery/door/blast/proc/repair()
	health = maxhealth
	if(stat & BROKEN)
		stat &= ~BROKEN

/obj/machinery/door/blast/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return 1
	return ..()

/**
 * Controls how blast doors and shutters should act when power is lost or restored.
 */
/obj/machinery/door/blast/power_change()
	..()
	if(src.operating || (stat & BROKEN))
		return
	// Blast doors will only re-open when power is restored if they were open originally.
	if((stat & NOPOWER) && fail_secure)
		securitylock = !density
		INVOKE_ASYNC(src, PROC_REF(force_close))
	else if(securitylock && fail_secure)
		INVOKE_ASYNC(src, PROC_REF(force_open))
		securitylock = FALSE

/obj/machinery/door/blast/attack_hand(mob/user as mob)
	return

// SUBTYPE: Regular
// Your classical blast door, found almost everywhere.
/obj/machinery/door/blast/regular
	//Because SDMM doesn't recognise the name otherwise, for some reason
	name = "blast door"
	icon_state_open = "pdoor0"
	icon_state_opening = "pdoorc0"
	icon_state_closed = "pdoor1"
	icon_state_closing = "pdoorc1"
	icon_state = "pdoor1"
	maxhealth = 600
	block_air_zones = 1

/obj/machinery/door/blast/regular/open
	//Because SDMM doesn't recognise the name otherwise, for some reason
	name = "blast door"
	icon_state = "pdoor0"
	density = FALSE
	opacity = FALSE

// SUBTYPE: Shutters
// Nicer looking, and also weaker, shutters. Found in kitchen and similar areas.
/obj/machinery/door/blast/shutters
	name = "shutter"
	icon_state_open = "shutter0"
	icon_state_opening = "shutterc0"
	icon_state_closed = "shutter1"
	icon_state_closing = "shutterc1"
	icon_state = "shutter1"
	damage = SHUTTER_CRUSH_DAMAGE
	closed_layer = CLOSED_DOOR_LAYER

/obj/machinery/door/blast/shutters/open
	icon_state = "shutter0"
	density = FALSE
	opacity = FALSE

// SUBTYPE: Odin
// Found on the odin, or where people really shouldnt get into
/obj/machinery/door/blast/odin
	icon_state_open = "pdoor0"
	icon_state_opening = "pdoorc0"
	icon_state_closed = "pdoor1"
	icon_state_closing = "pdoorc1"
	icon_state = "pdoor1"
	maxhealth = 1000
	block_air_zones = 1

/obj/machinery/door/blast/odin/open
	//Because SDMM doesn't recognise the name otherwise, for some reason
	name = "blast door"
	icon_state = "pdoor0"
	density = 0
	opacity = 0

/obj/machinery/door/blast/odin/attackby(obj/item/attacking_item, mob/user)
	return

/obj/machinery/door/blast/odin/ex_act(var/severity)
	return

/obj/machinery/door/blast/odin/take_damage(var/damage)
	return

/obj/machinery/door/blast/odin/shuttle
	icon_state = "pdoor0"
	density = 0
	opacity = 0

/obj/machinery/door/blast/odin/shuttle/ert
	_wifi_id = "ert_shuttle_lockdown"

/obj/machinery/door/blast/odin/shuttle/tcfl
	_wifi_id = "tcfl_shuttle_release"
	icon_state = "pdoor1"
	density = 1
	opacity = 1

/obj/machinery/door/blast/odin/shuttle/tcfl/shutter
	_wifi_id = "tcfl_shuttle_lockdown"
	density = 0
	opacity = 0
	icon_state_open = "shutter0"
	icon_state_opening = "shutterc0"
	icon_state_closed = "shutter1"
	icon_state_closing = "shutterc1"
	icon_state = "shutter0"
	damage = SHUTTER_CRUSH_DAMAGE

#undef BLAST_DOOR_CRUSH_DAMAGE
#undef SHUTTER_CRUSH_DAMAGE
