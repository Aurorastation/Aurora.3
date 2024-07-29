/*
Alright boys, Firing pins. hopefully with minimal shitcode.
"pin_auth(mob/living/user)" is the check to see if it fires, put the snowflake code here. return one to fire, zero to flop. ezpz

Firing pins as a rule can't be removed without replacing them, blame a really shitty mechanism for it by NT or something idk, this is to stop people from just taking pins from like a capgun or something.
*/

/**
 * # Firing pins
 */
/obj/item/device/firing_pin
	name = "electronic firing pin"
	desc = "A small authentication device, to be inserted into a firearm receiver to allow operation. NT safety regulations require all new designs to incorporate one."
	icon = 'icons/obj/firingpins.dmi'
	icon_state = "firing_pin"
	item_state = "pen"
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 2)
	obj_flags = OBJ_FLAG_CONDUCTABLE
	w_class = WEIGHT_CLASS_TINY
	attack_verb = list("poked")
	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound = 'sound/items/pickup/component.ogg'

	/// The gun this pin is attached to
	var/obj/item/gun/gun

	/// Boolean, if it's emagged
	var/emagged = FALSE

	/// The message to display when the pin fails to authenticate
	var/fail_message = SPAN_WARNING("INVALID USER.")

	/// Boolean, if it explode when user check is failed
	var/selfdestruct = FALSE

	/// Boolean, if it can forcefully replace other pins
	var/force_replace = FALSE

	/// Boolean, if it can be replaced by any pin
	var/pin_replaceable = FALSE

	/// Boolean, if it's destroyed when it's pried out with a screwdriver, see gun.dm
	var/durable = FALSE

/obj/item/device/firing_pin/Initialize(mapload)
	. = ..()

	if(istype(loc, /obj/item/gun))
		gun = loc

/obj/item/device/firing_pin/Destroy()
	if(gun)
		gun.pin = null
		gun = null

	. = ..()

///Part of what allows people to see what firing mode their wireless control pin is in. Returns nothing here if there's no wireless-control firing pin.
/obj/item/device/firing_pin/proc/examine_info()
	return

/obj/item/device/firing_pin/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
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
		to_chat(get_holding_mob(src), SPAN_NOTICE("You override the authentication mechanism."))

/**
 * Inserts the pin into a gun
 *
 * * user - The `mob/living` inserting the pin
 * * G - The `obj/item/gun` the pin is being inserted into
 */
/obj/item/device/firing_pin/proc/gun_insert(mob/living/user, obj/item/gun/G)
	SHOULD_NOT_SLEEP(TRUE)

	gun = G
	user.drop_from_inventory(src,gun)
	gun.pin = src

/**
 * Removes the pin from a gun
 *
 * * user - The `mob/living` removing the pin
 */
/obj/item/device/firing_pin/proc/gun_remove(mob/living/user)
	SHOULD_NOT_SLEEP(TRUE)

	gun.pin = null
	gun = null
	qdel(src)

/**
 * Authenticates if the gun can fire
 *
 * * user - The `mob/living` trying to fire the gun
 *
 * Returns TRUE if the gun can fire, FALSE otherwise
 */
/obj/item/device/firing_pin/proc/pin_auth(mob/living/user)
	SHOULD_NOT_SLEEP(TRUE)

	return TRUE

/**
 * Called when the gun fails to fire because the pin refused to authenticate the shot
 *
 * * user - The `mob/living` that tried to fire the gun
 */
/obj/item/device/firing_pin/proc/auth_fail(mob/living/user)
	SHOULD_NOT_SLEEP(TRUE)

	to_chat(user, fail_message)

	if(selfdestruct)//sound stolen from the lawgiver. todo, remove this from the lawgiver. there can only be one.
		user.show_message(SPAN_DANGER("SELF-DESTRUCTING...<br>"), 1)
		visible_message(SPAN_DANGER("\The [gun] explodes!"))
		playsound(user, 'sound/weapons/lawgiver_idfail.ogg', 40, 1)

		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/external/E = H.organs_by_name[H.hand ? BP_L_HAND : BP_R_HAND]
			E.droplimb(FALSE, DROPLIMB_BLUNT)

		explosion(get_turf(gun), -1, 0, 2, 3)

		if(gun)
			qdel(gun)



/*##############
	SUBTYPES
##############*/


/**
 * # Test range firing pin
 *
 * This safety firing pin allows weapons to be fired within proximity to a firing range.
 */
/obj/item/device/firing_pin/test_range
	name = "test-range firing pin"
	desc = "This safety firing pin allows weapons to be fired within proximity to a firing range."
	fail_message = SPAN_WARNING("TEST RANGE CHECK FAILED.")
	pin_replaceable = 1
	durable = TRUE
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 2)

/obj/item/device/firing_pin/test_range/pin_auth(mob/living/user)
	var/area/A = get_area(src)
	if (A && (A.area_flags & AREA_FLAG_FIRING_RANGE))
		return 1
	else
		return 0


/**
 * # Psionics firing pin
 *
 * This is a psionics-locked firing pin which only authorizes users who are capable of psionics.
 */
/obj/item/device/firing_pin/psionic
	name = "psionics firing pin"
	desc = "This is a psionics-locked firing pin which only authorizes users who are capable of psionics."
	fail_message = SPAN_WARNING("PSIONICS CHECK FAILED.")

/obj/item/device/firing_pin/psionic/pin_auth(mob/living/user)
	if(user.has_psionics())
		return 1
	else
		return 0


/**
 * # Implant firing pin
 *
 * This is a implant-locked firing pin which only authorizes users who are implanted with a certain device.
 */
/obj/item/device/firing_pin/implant
	name = "implant-keyed firing pin"
	desc = "This is a implant-locked firing pin which only authorizes users who are implanted with a certain device."
	fail_message = SPAN_WARNING("IMPLANT CHECK FAILED.")
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


/**
 * # DNA firing pin
 *
 * This is a DNA-locked firing pin which only authorizes one user. Attempt to fire once to DNA-link.
 */
/obj/item/device/firing_pin/dna
	name = "DNA-keyed firing pin"
	desc = "This is a DNA-locked firing pin which only authorizes one user. Attempt to fire once to DNA-link."
	icon_state = "firing_pin_dna"
	fail_message = SPAN_WARNING("DNA CHECK FAILED.")

	/// The unique enzymes of the user who can fire using this firing pin
	var/unique_enzymes = null

/obj/item/device/firing_pin/dna/afterattack(atom/target, mob/user, proximity_flag)
	..()
	if(proximity_flag && iscarbon(target))
		var/mob/living/carbon/M = target
		if(M.dna && M.dna.unique_enzymes)
			unique_enzymes = M.dna.unique_enzymes
			to_chat(user, SPAN_NOTICE("DNA-LOCK SET."))

/obj/item/device/firing_pin/dna/pin_auth(mob/living/carbon/user)
	if(istype(user) && user.dna && user.dna.unique_enzymes)
		if(user.dna.unique_enzymes == unique_enzymes)
			return TRUE

	return FALSE

/obj/item/device/firing_pin/dna/auth_fail(mob/living/user)
	if(!unique_enzymes)
		if(istype(user) && user.dna && user.dna.unique_enzymes)
			unique_enzymes = user.dna.unique_enzymes
			to_chat(user, SPAN_NOTICE("DNA-LOCK SET."))
	else
		..()

/obj/item/device/firing_pin/dna/dredd
	desc = "This is a DNA-locked firing pin which only authorizes one user. Attempt to fire once to DNA-link. It has a small explosive charge on it."
	selfdestruct = 1


/**
 * # Laser tag firing pin
 *
 * This is a laser tag-locked firing pin which only authorizes users who are wearing a laser tag.
 */
/obj/item/device/firing_pin/tag
	name = "laser tag firing pin"
	desc = "A recreational firing pin, used in laser tag units to ensure users have their vests on."
	fail_message = SPAN_WARNING("SUIT CHECK FAILED.")
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


/**
 * # Access firing pin
 *
 * This access locked firing pin allows weapons to be fired only when the user has the required access.
 */
/obj/item/device/firing_pin/access
	name = "access-keyed firing pin"
	desc = "This access locked firing pin allows weapons to be fired only when the user has the required access."
	fail_message = SPAN_WARNING("ACCESS CHECK FAILED.")
	req_access = list(ACCESS_WEAPONS)

/obj/item/device/firing_pin/access/pin_auth(mob/living/user)
	return !allowed(user)


/**
 * # Away site firing pin
 *
 * This access locked firing pin allows weapons to be fired only when the user is not on-ship.
 */
/obj/item/device/firing_pin/away_site
	name = "away site firing pin"
	desc = "This access locked firing pin allows weapons to be fired only when the user is not on-ship."
	fail_message = SPAN_WARNING("USER ON SHIP LEVEL.")

/obj/item/device/firing_pin/away_site/pin_auth(mob/living/user)
	var/turf/T = get_turf(src)
	return !is_station_level(T.z)



/// A list of all initialized wireless firing pins. Used in the firearm tracking program in guntracker.dm
GLOBAL_LIST_EMPTY_TYPED(wireless_firing_pins, /obj/item/device/firing_pin/wireless)

/**
 * # Wireless firing pin
 *
 * This firing pin is wirelessly controlled. On automatic mode it allow allows weapons to be fired on stun unless the alert level is elevated.
 * Otherwise, it can be controlled from a firearm control console.
 */
/obj/item/device/firing_pin/wireless
	name = "wireless-control firing pin"
	desc = "This firing pin is wirelessly controlled. On automatic mode it allow allows weapons to be fired on stun unless the alert level is elevated. Otherwise, it can be controlled from a firearm control console."
	fail_message = SPAN_WARNING("The wireless-control firing pin clicks!")
	var/registered_user = null
	var/lock_status = WIRELESS_PIN_AUTOMATIC

/obj/item/device/firing_pin/wireless/Initialize() //Adds wireless pins to the list of initialized wireless firing pins.
	. = ..()

	GLOB.wireless_firing_pins += src

/obj/item/device/firing_pin/wireless/Destroy() //Removes the wireless pins from the list of initialized wireless firing pins.
	GLOB.wireless_firing_pins -= src

	. = ..()

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
			else if (GLOB.security_level >= SEC_LEVEL_YELLOW)
				return TRUE
			else
				fail_message = SPAN_WARNING("Unable to fire: insufficient security level.")
				return FALSE
		else
			if (GLOB.security_level >= SEC_LEVEL_YELLOW)
				return TRUE
			else
				fail_message = SPAN_WARNING("Unable to fire: insufficient security level.")
				return FALSE

/// Changes the current lock_status of the weapon, and sends a message and sfx to whoever is holding it.
/obj/item/device/firing_pin/wireless/proc/set_mode(new_mode)
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
