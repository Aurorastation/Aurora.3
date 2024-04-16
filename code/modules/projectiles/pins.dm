/*
Alright boys, Firing pins. hopefully with minimal shitcode.
"pin_auth(mob/living/user)" is the check to see if it fires, put the snowflake code here. return one to fire, zero to flop. ezpz

Firing pins as a rule can't be removed without replacing them, blame a really shitty mechanism for it by NT or something idk, this is to stop people from just taking pins from like a capgun or something.
*/

/obj/item/device/firing_pin
	name = "electronic firing pin"
	desc = "A small authentication device, to be inserted into a firearm receiver to allow operation. NT safety regulations require all new designs to incorporate one."
	icon = 'icons/obj/firingpins.dmi'
	icon_state = "firing_pin"
	item_state = "pen"
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 2)
	obj_flags = OBJ_FLAG_CONDUCTABLE
	w_class = ITEMSIZE_TINY
	attack_verb = list("poked")
	var/emagged = FALSE
	var/fail_message = "<span class='warning'>INVALID USER.</span>"
	var/selfdestruct = 0 // Explode when user check is failed.
	var/force_replace = 0 // Can forcefully replace other pins.
	var/pin_replaceable = 0 // Can be replaced by any pin.
	var/durable = FALSE //is destroyed when it's pried out with a screwdriver, see gun.dm
	var/obj/item/gun/gun
	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound = 'sound/items/pickup/component.ogg'

/obj/item/device/firing_pin/Initialize(mapload)
	.=..()
	if(istype(loc, /obj/item/gun))
		gun = loc

/obj/item/device/firing_pin/proc/examine_info() // Part of what allows people to see what firing mode  their wireless control pin is in. Returns nothing here if there's no wireless-control firing pin.
		return


/obj/item/device/firing_pin/afterattack(atom/target, mob/user, proximity_flag)
	if(proximity_flag)
		if(istype(target, /obj/item/gun))
			var/obj/item/gun/G = target
			if(!G.needspin)
				to_chat(user, SPAN_WARNING("\The [G] doesn't take pins."))
				return

			if(G.pin && (force_replace || G.pin.pin_replaceable))
				G.pin.forceMove(get_turf(G))
				G.pin.gun_remove(user)
				to_chat(user, SPAN_NOTICE("You remove \the [G]'s old pin."))

			if(!G.pin)
				gun_insert(user, G)
				to_chat(user, SPAN_NOTICE("You insert [src] into \the [G]."))
			else
				to_chat(user, SPAN_NOTICE("This firearm already has a firing pin installed."))

/obj/item/device/firing_pin/emag_act()
	if(!emagged)
		emagged = TRUE
		to_chat(get_holding_mob(src), "<span class='notice'>You override the authentication mechanism.</span>")

/obj/item/device/firing_pin/proc/gun_insert(mob/living/user, obj/item/gun/G)
	gun = G
	user.drop_from_inventory(src,gun)
	gun.pin = src
	return

/obj/item/device/firing_pin/proc/gun_remove(mob/living/user)
	gun.pin = null
	gun = null
	qdel(src)
	return

/obj/item/device/firing_pin/proc/pin_auth(mob/living/user)
	return 1

/obj/item/device/firing_pin/proc/auth_fail(mob/living/carbon/human/user)
	to_chat(user, fail_message)
	if(selfdestruct)//sound stolen from the lawgiver. todo, remove this from the lawgiver. there can only be one.
		user.show_message("<span class='danger'>SELF-DESTRUCTING...</span><br>", 1)
		visible_message("<span class='danger'>\The [gun] explodes!</span>")
		playsound(user, 'sound/weapons/lawgiver_idfail.ogg', 40, 1)
		var/obj/item/organ/external/E = user.organs_by_name[user.hand ? BP_L_HAND : BP_R_HAND]
		E.droplimb(0,DROPLIMB_BLUNT)
		explosion(get_turf(gun), -1, 0, 2, 3)
		if(gun)
			qdel(gun)

/*
Pins Below.
*/

// Test pin, works only near firing ranges.
/obj/item/device/firing_pin/test_range
	name = "test-range firing pin"
	desc = "This safety firing pin allows weapons to be fired within proximity to a firing range."
	fail_message = "<span class='warning'>TEST RANGE CHECK FAILED.</span>"
	pin_replaceable = 1
	durable = TRUE
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 2)

/obj/item/device/firing_pin/test_range/pin_auth(mob/living/user)
	var/area/A = get_area(src)
	if (A && (A.area_flags & AREA_FLAG_FIRING_RANGE))
		return 1
	else
		return 0

// Psionics pin, checks for psionics (psi aug not included)
/obj/item/device/firing_pin/psionic
	name = "psionics firing pin"
	desc = "This is a psionics-locked firing pin which only authorizes users who are capable of psionics."
	fail_message = "<span class='warning'>PSIONICS CHECK FAILED.</span>"

/obj/item/device/firing_pin/psionic/pin_auth(mob/living/user)
	if(user.has_psionics())
		return 1
	else
		return 0

// Implant pin, checks for implant
/obj/item/device/firing_pin/implant
	name = "implant-keyed firing pin"
	desc = "This is a implant-locked firing pin which only authorizes users who are implanted with a certain device."
	fail_message = "<span class='warning'>IMPLANT CHECK FAILED.</span>"
	var/req_implant

/obj/item/device/firing_pin/implant/pin_auth(mob/living/user)
	if (locate(req_implant) in user)
		return 1
	else
		return 0

/obj/item/device/firing_pin/implant/loyalty
	name = "mind shield firing pin"
	desc = "This implant-locked firing pin authorizes the weapon for only mind shielded users."
	icon_state = "firing_pin_loyalty"
	req_implant = /obj/item/implant/mindshield

// Honk pin, clown joke item.
// Can replace other pins. Replace a pin in cap's laser for extra fun! This is generally adminbus only unless someone thinks of a use for it.
/obj/item/device/firing_pin/clown
	name = "hilarious firing pin"
	desc = "Advanced clowntech that can convert any firearm into a far more useful object."
	color = "#FFFF00"
	fail_message = "<span class='warning'>HONK!</span>"
	force_replace = 1

/obj/item/device/firing_pin/clown/pin_auth(mob/living/user)
	playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
	return 0

// DNA-keyed pin.
// When you want to keep your toys for youself.
/obj/item/device/firing_pin/dna
	name = "DNA-keyed firing pin"
	desc = "This is a DNA-locked firing pin which only authorizes one user. Attempt to fire once to DNA-link."
	icon_state = "firing_pin_dna"
	fail_message = "<span class='warning'>DNA CHECK FAILED.</span>"
	var/unique_enzymes = null

/obj/item/device/firing_pin/dna/afterattack(atom/target, mob/user, proximity_flag)
	..()
	if(proximity_flag && iscarbon(target))
		var/mob/living/carbon/M = target
		if(M.dna && M.dna.unique_enzymes)
			unique_enzymes = M.dna.unique_enzymes
			to_chat(user, "<span class='notice'>DNA-LOCK SET.</span>")

/obj/item/device/firing_pin/dna/pin_auth(mob/living/carbon/user)
	if(istype(user) && user.dna && user.dna.unique_enzymes)
		if(user.dna.unique_enzymes == unique_enzymes)
			return 1

	return 0

/obj/item/device/firing_pin/dna/auth_fail(mob/living/carbon/user)
	if(!unique_enzymes)
		if(istype(user) && user.dna && user.dna.unique_enzymes)
			unique_enzymes = user.dna.unique_enzymes
			to_chat(user, "<span class='notice'>DNA-LOCK SET.</span>")
	else
		..()

/obj/item/device/firing_pin/dna/dredd
	desc = "This is a DNA-locked firing pin which only authorizes one user. Attempt to fire once to DNA-link. It has a small explosive charge on it."
	selfdestruct = 1


// Laser tag pins
/obj/item/device/firing_pin/tag
	name = "laser tag firing pin"
	desc = "A recreational firing pin, used in laser tag units to ensure users have their vests on."
	fail_message = "<span class='warning'>SUIT CHECK FAILED.</span>"
	var/tag_color = ""

/obj/item/device/firing_pin/tag/pin_auth(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/clothing/suit/armor/riot/laser_tag/LT = H.wear_suit
		if(istype(LT) && tag_color == LT.laser_tag_color)
			return TRUE
	to_chat(user, SPAN_WARNING("You need to be wearing [tag_color] laser tag armor!"))
	return FALSE

/obj/item/device/firing_pin/tag/red
	name = "red laser tag firing pin"
	icon_state = "firing_pin_red"
	tag_color = "red"

/obj/item/device/firing_pin/tag/blue
	name = "blue laser tag firing pin"
	icon_state = "firing_pin_blue"
	tag_color = "blue"

/obj/item/device/firing_pin/Destroy()
	if(gun)
		gun.pin = null
	return ..()

//this firing pin checks for access
/obj/item/device/firing_pin/access
	name = "access-keyed firing pin"
	desc = "This access locked firing pin allows weapons to be fired only when the user has the required access."
	fail_message = "<span class='warning'>ACCESS CHECK FAILED.</span>"
	req_access = list(ACCESS_WEAPONS)

/obj/item/device/firing_pin/access/pin_auth(mob/living/user)
	return !allowed(user)

/obj/item/device/firing_pin/away_site
	name = "away site firing pin"
	desc = "This access locked firing pin allows weapons to be fired only when the user is not on-ship."
	fail_message = "<span class='warning'>USER ON SHIP LEVEL.</span>"

/obj/item/device/firing_pin/away_site/pin_auth(mob/living/user)
	var/turf/T = get_turf(src)
	return !isStationLevel(T.z)

var/list/wireless_firing_pins = list() //A list of all initialized wireless firing pins. Used in the firearm tracking program in guntracker.dm

/obj/item/device/firing_pin/wireless
	name = "wireless-control firing pin"
	desc = "This firing pin is wirelessly controlled. On automatic mode it allow allows weapons to be fired on stun unless the alert level is elevated. Otherwise, it can be controlled from a firearm control console."
	fail_message = "<span class='warning'>The wireless-control firing pin clicks!</span>"
	var/registered_user = null
	var/lock_status = WIRELESS_PIN_AUTOMATIC

/obj/item/device/firing_pin/wireless/examine_info(mob/user)
	var/wireless_description
	switch(lock_status)
		if(WIRELESS_PIN_AUTOMATIC)
			wireless_description = "is in automatic mode"
		if(WIRELESS_PIN_DISABLED)
			wireless_description = "has locked the trigger"
		if(WIRELESS_PIN_STUN)
			wireless_description = "is in stun-only mode"
		if(WIRELESS_PIN_LETHAL)
			wireless_description = "is in unrestricted mode"
	to_chat(user, SPAN_NOTICE("The wireless-control firing pin <b>[wireless_description]</b>."))

/obj/item/device/firing_pin/wireless/Initialize() //Adds wireless pins to the list of initialized wireless firing pins.
	wireless_firing_pins += src
	return ..()

/obj/item/device/firing_pin/wireless/Destroy() //Removes the wireless pins from the list of initialized wireless firing pins.
	wireless_firing_pins -= src
	return ..()

/*
	The return of this pin_auth is dependent on the wireless pin's lock_status. The required_firemode_auth list has to match up index-wise with the firemodes.
	All ballistic firearms are considered as being lethal, regardless of ammunition loaded. Behaviours should be as follows:
	Automatic: The weapon will only fire on stun while the security level is Green or Blue. On Yellow, Red & Delta alert the weapon is unrestricted
	Disabled: The weapon will not fire under any circumstance.
	Stun-Only: The weapon will only fire on stun regardless of the current security level.
	Lethal: The weapon will fire on all modes regardless of the current security level.
*/
/obj/item/device/firing_pin/wireless/pin_auth(mob/living/user)
	if(!registered_user)
		fail_message = SPAN_WARNING("Unable to fire: no registered user detected.")
		return FALSE

	if(emagged)
		return TRUE

	if(lock_status == WIRELESS_PIN_DISABLED)
		fail_message = SPAN_WARNING("Unable to fire: firearm remotely disabled.")
		return FALSE

	else if(lock_status == WIRELESS_PIN_LETHAL)
		return TRUE

	else if(lock_status == WIRELESS_PIN_STUN)
		if(istype(gun, /obj/item/gun/energy))
			var/obj/item/gun/energy/EG = gun
			if(EG.required_firemode_auth[EG.sel_mode] == WIRELESS_PIN_LETHAL)
				fail_message = SPAN_WARNING("Unable to fire: firearm not in stun mode.")
				return FALSE
			return TRUE
		else
			fail_message = SPAN_WARNING("Unable to fire: no stun mode detected.")
			return FALSE

	else //Automatic Mode
		if(istype(gun, /obj/item/gun/energy))
			var/obj/item/gun/energy/EG = gun
			if(EG.required_firemode_auth[EG.sel_mode] == WIRELESS_PIN_STUN)
				return TRUE
			else if (GLOB.security_level == SEC_LEVEL_YELLOW || GLOB.security_level == SEC_LEVEL_RED)
				return TRUE
			else
				fail_message = SPAN_WARNING("Unable to fire: insufficient security level.")
				return FALSE
		else
			if (GLOB.security_level == SEC_LEVEL_YELLOW || GLOB.security_level == SEC_LEVEL_RED)
				return TRUE
			else
				fail_message = SPAN_WARNING("Unable to fire: insufficient security level.")
				return FALSE


/obj/item/device/firing_pin/wireless/proc/set_mode(var/new_mode) // Changes the current lock_status of the weapon, and sends a message and sfx to whoever is holding it.
	var/mob/user = get_holding_mob(src)

	if(new_mode == lock_status)
		return

	else if(new_mode == WIRELESS_PIN_AUTOMATIC)
		playsound(user, 'sound/weapons/laser_safetyon.ogg', 40)
		to_chat(user, SPAN_NOTICE("<b>\The [gun.name]'s wireless-control firing pin is now set to automatic.</b>"))
		lock_status = WIRELESS_PIN_AUTOMATIC

	else if(new_mode == WIRELESS_PIN_DISABLED)
		playsound(user, 'sound/weapons/laser_safetyoff.ogg', 40)
		to_chat(user, SPAN_WARNING("<b>\The wireless-control firing pin locks \the [gun.name]'s trigger!</b>"))
		lock_status = WIRELESS_PIN_DISABLED

	else if(new_mode == WIRELESS_PIN_STUN)
		playsound(user, 'sound/weapons/laser_safetyon.ogg', 40)
		to_chat(user, SPAN_NOTICE("<b>\The [gun.name]'s wireless-control firing pin is now set to stun only.</b>"))
		lock_status = WIRELESS_PIN_STUN

	else if(new_mode == WIRELESS_PIN_LETHAL)
		playsound(user, 'sound/weapons/laser_safetyon.ogg', 40)
		to_chat(user, SPAN_NOTICE("<b>\The [gun.name]'s wireless-control firing pin is now unrestricted.</b>"))
		lock_status = WIRELESS_PIN_LETHAL

	return

/obj/item/device/firing_pin/wireless/attackby(obj/item/attacking_item, mob/user) //Lets people register their IDs to the pin. Using it once registers you, using it again clears you.
	if(istype(attacking_item, /obj/item/card/id))
		var/obj/item/card/id/idcard = attacking_item
		if(idcard.registered_name == registered_user)
			to_chat(user, SPAN_NOTICE("You press your ID against the RFID reader and it deregisters your identity."))
			registered_user = null
			return TRUE
		to_chat(user, SPAN_NOTICE("You press your ID against the RFID reader and it chimes as it registers your identity."))
		playsound(user, 'sound/machines/chime.ogg', 20)
		registered_user = idcard.registered_name
		return TRUE
	return FALSE
