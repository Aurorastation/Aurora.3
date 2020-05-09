/mob/living/bot
	name = "Bot"
	health = 20
	maxHealth = 20
	icon = 'icons/obj/aibots.dmi'
	layer = MOB_LAYER
	universal_speak = TRUE
	density = FALSE
	var/obj/item/card/id/botcard
	var/list/botcard_access = list()
	var/on = TRUE
	var/open = FALSE
	var/locked = TRUE
	var/emagged = FALSE
	var/light_strength = 3

	var/obj/access_scanner
	var/list/req_access = list()
	var/list/req_one_access = list()
	var/master_access = access_robotics

	var/last_emote = 0 // timer for emotes

	var/can_take_pai = TRUE
	var/obj/item/device/paicard/pAI

/mob/living/bot/Initialize()
	. = ..()
	update_icons()

	botcard = new /obj/item/card/id(src)
	botcard.access = botcard_access.Copy()

	access_scanner = new /obj(src)
	access_scanner.req_access = req_access.Copy()
	access_scanner.req_one_access = req_one_access.Copy()

/mob/living/bot/Destroy()
	QDEL_NULL(botcard)
	QDEL_NULL(access_scanner)
	return ..()

/mob/living/bot/Life()
	..()
	if(health <= 0)
		death()
		return
	weakened = 0
	stunned = 0
	paralysis = 0

/mob/living/bot/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
	else
		health = maxHealth - getFireLoss() - getBruteLoss()

/mob/living/bot/death()
	explode()

/mob/living/bot/proc/has_master_access(var/obj/item/I)
	var/list/L = I.GetAccess()
	if(master_access in L)
		return TRUE
	else
		return FALSE

/mob/living/bot/proc/has_ui_access(mob/user)
	if(access_scanner.allowed(user))
		return TRUE
	if(!locked)
		return TRUE
	if(isAI(user))
		return TRUE
	return FALSE

/mob/living/bot/attackby(var/obj/item/O, var/mob/user)
	if(O.GetID())
		if((has_master_access(O) || access_scanner.allowed(user)) && !open && !emagged)
			locked = !locked
			to_chat(user, SPAN_NOTICE("You [locked ? "lock" : "unlock"] the controls."))
		else
			if(emagged)
				to_chat(user, SPAN_WARNING("As you swipe your ID, it reads: \"Interface error!\""))
			if(open)
				to_chat(user, SPAN_WARNING("You have to close the access panel before locking it."))
			else
				to_chat(user, SPAN_WARNING("As you swipe your ID, it reads: \"Access denied.\""))
		return
	else if(O.isscrewdriver())
		if(!locked)
			open = !open
			to_chat(user, SPAN_NOTICE("You [open ? "open" : "close"] the maintenance panel."))
		else
			to_chat(user, SPAN_WARNING("You need to unlock the controls first."))
		return
	else if(O.iswelder())
		if(health < maxHealth)
			if(open)
				health = min(maxHealth, health + 10)
				user.visible_message(SPAN_NOTICE("\The [user] repairs [src]."), SPAN_NOTICE("You repair [src]."))
			else
				to_chat(user, SPAN_WARNING("You are unable to repair [src] with the maintenance panel closed."))
		else
			to_chat(user, SPAN_WARNING("[src] does not need a repair."))
		return
	else
		..()

/mob/living/bot/attack_ai(var/mob/user)
	return attack_hand(user)

/mob/living/bot/say(var/message)
	var/verb = "beeps"

	message = sanitize(message)

	..(message, null, verb)

/mob/living/bot/Collide(atom/A)
	if(on && botcard && istype(A, /obj/machinery/door))
		var/obj/machinery/door/D = A
		if(!istype(D, /obj/machinery/door/firedoor) && !istype(D, /obj/machinery/door/blast) && D.check_access(botcard))
			D.open()
	else
		. = ..()

/mob/living/bot/emag_act()
	return FALSE

/mob/living/bot/emp_act(severity)
	switch(severity)
		if(1)
			death()
		else
			turn_off()
	..()

/mob/living/bot/proc/turn_on()
	if(stat)
		return FALSE
	on = TRUE
	set_light(light_strength)
	update_icons()
	return TRUE

/mob/living/bot/proc/turn_off()
	on = FALSE
	set_light(0)
	update_icons()

/mob/living/bot/proc/explode()
	qdel(src)

/mob/living/bot/get_bullet_impact_effect_type(var/def_zone)
	return BULLET_IMPACT_METAL