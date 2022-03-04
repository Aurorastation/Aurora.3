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
	name = "Blast Door"
	desc = "That looks like it doesn't open easily."
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = null

	// Icon states for different shutter types. Simply change this instead of rewriting the update_icon proc.
	var/icon_state_open = null
	var/icon_state_opening = null
	var/icon_state_closed = null
	var/icon_state_closing = null
	var/open_sound = 'sound/machines/blastdooropen.ogg'
	var/close_sound = 'sound/machines/blastdoorclose.ogg'
	var/damage = BLAST_DOOR_CRUSH_DAMAGE
	closed_layer = 3.4 // Above airlocks when closed
	var/id = 1.0
	dir = 1
	explosion_resistance = 25

	//Most blast doors are infrequently toggled and sometimes used with regular doors anyways,
	//turning this off prevents awkward zone geometry in places like medbay lobby, for example.
	block_air_zones = 0

	var/_wifi_id
	var/datum/wifi/receiver/button/door/wifi_receiver

	var/securitylock = TRUE
	var/is_critical = FALSE

/obj/machinery/door/blast/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)
	if(density)
		layer = closed_layer
	else
		layer = open_layer

/obj/machinery/door/airlock/Destroy()
	qdel(wifi_receiver)
	wifi_receiver = null
	return ..()

// Proc: Bumped()
// Parameters: 1 (AM - Atom that tried to walk through this object)
// Description: If we are open returns zero, otherwise returns result of parent function.
/obj/machinery/door/blast/CollidedWith(atom/AM)
	if(!density)
		return ..()
	else
		return 0
// Proc: update_icon()
// Parameters: None
// Description: Updates icon of this object. Uses icon state variables.
/obj/machinery/door/blast/update_icon()
	if(density)
		icon_state = icon_state_closed
	else
		icon_state = icon_state_open
	return

// Proc: force_open()
// Parameters: None
// Description: Opens the door. No checks are done inside this proc.
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

// Proc: force_close()
// Parameters: None
// Description: Closes the door. No checks are done inside this proc.
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

// Proc: force_toggle()
// Parameters: None
// Description: Opens or closes the door, depending on current state. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_toggle()
	if(src.density)
		src.force_open()
	else
		src.force_close()

// Proc: attackby()
// Parameters: 2 (C - Item this object was clicked with, user - Mob which clicked this object)
// Description: If we are clicked with crowbar or wielded fire axe, try to manually open the door.
// This only works on broken doors or doors without power. Also allows repair with Plasteel.
/obj/machinery/door/blast/attackby(obj/item/C as obj, mob/user as mob)
	if(!istype(C, /obj/item/forensics))
		src.add_fingerprint(user)
	if((istype(C, /obj/item/material/twohanded/fireaxe) && C:wielded == 1) || (istype(C, /obj/item/melee/hammer)) || istype(C, /obj/item/crowbar/robotic/jawsoflife))
		if (((stat & NOPOWER) || 	(stat & BROKEN)) && !( src.operating ))
			force_toggle()
		else
			to_chat(usr, "<span class='notice'>[src]'s motors resist your effort.</span>")
		return
	if(istype(C, /obj/item/stack/material) && C.get_material_name() == "plasteel")
		var/amt = Ceiling((maxhealth - health)/150)
		if(!amt)
			to_chat(usr, "<span class='notice'>\The [src] is already fully repaired.</span>")
			return
		var/obj/item/stack/P = C
		if(P.amount < amt)
			to_chat(usr, "<span class='warning'>You don't have enough sheets to repair this! You need at least [amt] sheets.</span>")
			return
		to_chat(usr, "<span class='notice'>You begin repairing [src]...</span>")
		if(do_after(usr, 30))
			if(P.use(amt))
				to_chat(usr, "<span class='notice'>You have repaired \The [src]</span>")
				src.repair()
			else
				to_chat(usr, "<span class='warning'>You don't have enough sheets to repair this! You need at least [amt] sheets.</span>")



// Proc: open()
// Parameters: None
// Description: Opens the door. Does necessary checks. Automatically closes if autoclose is true
/obj/machinery/door/blast/open()
	if (src.operating || (stat & BROKEN || stat & NOPOWER))
		return
	force_open()
	if(autoclose)
		spawn(150)
			close()
	return 1

// Proc: close()
// Parameters: None
// Description: Closes the door. Does necessary checks.
/obj/machinery/door/blast/close()
	if (src.operating || (stat & BROKEN || stat & NOPOWER))
		return
	force_close()
	for(var/turf/turf in locs)
		for(var/atom/movable/AM in turf)
			if(AM.airlock_crush(damage))
				take_damage(damage*0.2)


// Proc: repair()
// Parameters: None
// Description: Fully repairs the blast door.
/obj/machinery/door/blast/proc/repair()
	health = maxhealth
	if(stat & BROKEN)
		stat &= ~BROKEN


/obj/machinery/door/blast/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return 1
	return ..()


/obj/machinery/door/blast/power_change()
	..()
	if(src.operating || (stat & BROKEN) || is_critical)
		return
	if(stat & NOPOWER)
		securitylock = !density // blast doors will only re-open when power is restored if they were open originally
		INVOKE_ASYNC(src, /obj/machinery/door/blast/.proc/force_close)
	else if(securitylock)
		INVOKE_ASYNC(src, /obj/machinery/door/blast/.proc/force_open)
		securitylock = FALSE

/obj/machinery/door/blast/attack_hand(mob/user as mob)
	return

// SUBTYPE: Regular
// Your classical blast door, found almost everywhere.
/obj/machinery/door/blast/regular
	icon_state_open = "pdoor0"
	icon_state_opening = "pdoorc0"
	icon_state_closed = "pdoor1"
	icon_state_closing = "pdoorc1"
	icon_state = "pdoor1"
	maxhealth = 600
	block_air_zones = 1

/obj/machinery/door/blast/regular/open
	icon_state = "pdoor0"
	density = 0
	opacity = 0

// SUBTYPE: Shutters
// Nicer looking, and also weaker, shutters. Found in kitchen and similar areas.
/obj/machinery/door/blast/shutters
	icon_state_open = "shutter0"
	icon_state_opening = "shutterc0"
	icon_state_closed = "shutter1"
	icon_state_closing = "shutterc1"
	icon_state = "shutter1"
	damage = SHUTTER_CRUSH_DAMAGE

/obj/machinery/door/blast/shutters/open
	icon_state = "shutter0"
	density = 0
	opacity = 0

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
	icon_state = "pdoor0"
	density = 0
	opacity = 0

/obj/machinery/door/blast/odin/attackby(obj/item/C as obj, mob/user as mob)
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
