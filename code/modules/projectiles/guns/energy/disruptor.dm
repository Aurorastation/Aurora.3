/obj/item/gun/energy/disruptorpistol
	name = "disruptor pistol"
	desc = "A Nexus Corporate Security designed blaster pistol with variable settings. This is the NEXUS DP8 Standard variant."
	desc_extended = "Developed and produced by Nexus Corporate Security, the NEXUS DP-8 is a state of the art blaster pistol capable of firing varying blaster bolts to different effect."
	desc_info = "The disruptor pistol is voice-controlled! Try saying 'Disruptor' then a firing mode, or 'Disruptor Crowd Control. Alt+Click to set a Loudspeaker Message, then Unique-Action to play it!"
	icon = 'icons/obj/guns/disruptorpistol/disruptorpistols.dmi'
	icon_state = "disruptorpistol"
	item_state = "disruptorpistol"
	fire_sound = 'sound/weapons/gunshot/bolter.ogg'
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	w_class = WEIGHT_CLASS_NORMAL
	force = 11
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/projectile/energy/disruptorstun
	secondary_projectile_type = /obj/projectile/energy/blaster/disruptor
	max_shots = 10
	charge_cost = 150
	accuracy = 1
	has_item_ratio = FALSE
	modifystate = "disruptorpistolstun"
	sel_mode = 1
	pin = /obj/item/device/firing_pin/wireless // A wireless pin is required for the weapon to function due to repeated logic comparisons against a wireless pin's registered owner.
	required_firemode_auth = list(WIRELESS_PIN_STUN, WIRELESS_PIN_STUN, WIRELESS_PIN_LETHAL, WIRELESS_PIN_LETHAL, WIRELESS_PIN_LETHAL)

	firemodes = list(
		list(
			mode_name = "stun",
			projectile_type = /obj/projectile/energy/disruptorstun,
			modifystate = "disruptorpistolstun",
			fire_sound = 'sound/weapons/gunshot/bolter.ogg'),
		list(
			mode_name = "flash",
			projectile_type = /obj/projectile/energy/disruptorstun/flare,
			modifystate = "disruptorpistolstun",
			fire_sound = 'sound/weapons/gunshot/bolter.ogg'),
		list(
			mode_name = "lethal",
			projectile_type = /obj/projectile/energy/blaster/disruptor,
			modifystate = "disruptorpistolkill",
			fire_sound = 'sound/weapons/gunshot/bolter.ogg',
			recoil = 1),
		list(
			mode_name = "heavy",
			projectile_type = /obj/projectile/energy/blaster/disruptor/heavy,
			charge_cost = 300, // paying double for +10 damage and 5 AP. OVERALL, does less damage, just does more in a shorter amount of time (5*30 = 150 dam VS. 10*20 = 200 dam). better hit those shots.
			modifystate = "disruptorpistolkill",
			accuracy = -2, //Better hit those shots I said :)
			fire_delay = 12, // 2x delay so you can't rapid fire these stronger blaster bolts
			recoil = 3,
			fire_sound = 'sound/weapons/gunshot/bolter.ogg')
	)

	var/selectframecheck = FALSE

	/// The message announced by the disruptor's loudspeaker on-command. Takes an input from the user OR plays a pre-set crowd control message
	var/message

	/// Stores the last world.time a message was announced via disruptor loudspeaker. Used to apply a cooldown.
	var/last_message_time

	/// Stores a  user (supplied by firing pin or user).
	var/disruptor_user

/obj/item/gun/energy/disruptorpistol/Initialize()
	. = ..()
	become_hearing_sensitive()

/obj/item/gun/energy/disruptorpistol/proc/check_disruptor_user(mob/user)
	if(!pin || (pin && !(istype(pin, /obj/item/device/firing_pin/wireless))))
		to_chat(usr, SPAN_WARNING("Incorrect firing pin installed."))
		return

	var/mob/living/carbon/human/H = user
	if (!H || !istype(H))
		return

	if(!disruptor_user)
		var/obj/item/device/firing_pin/wireless/pin_temp = pin
		disruptor_user = pin_temp.registered_user

	var/obj/item/card/id/user_id_card = user.GetIdCard()
	if(user_id_card.registered_name == disruptor_user)
		return 1
	else
		return 0

/obj/item/gun/energy/disruptorpistol/proc/play_message()
	if(!pin || (pin && !(istype(pin, /obj/item/device/firing_pin/wireless))))
		to_chat(usr, SPAN_WARNING("Incorrect firing pin installed."))
		return

	if(world.time - last_message_time <= 5)
		return

	last_message_time = world.time

	audible_message(SPAN_WARNING("[disruptor_user]'s [src.name] broadcasts: [message]"))
	playsound(get_turf(src), 'sound/machines/synth_no.ogg', 100, 1, vary = 0)


/obj/item/gun/energy/disruptorpistol/hear_talk(mob/living/M in range(0,src), msg)
	if(!pin || (pin && !(istype(pin, /obj/item/device/firing_pin/wireless))))
		to_chat(usr, SPAN_WARNING("Incorrect firing pin installed."))
		return

	if(check_disruptor_user(M)) // Voice commands probably would go off a voice sample instead of ID credentials, but this is consistent with other ownership checks.
		hear(msg)
	return

/obj/item/gun/energy/disruptorpistol/proc/hear(var/msg)
	if(!pin || (pin && !(istype(pin, /obj/item/device/firing_pin/wireless))))
		to_chat(usr, SPAN_WARNING("Incorrect firing pin installed."))
		return

	var/list/replacechars = list("'" = "","\"" = "",">" = "","<" = "","(" = "",")" = ""," " = "")
	msg = sanitize_old(msg, replacechars)

	if(findtext(msg, "disruptor"))
		/* Firing Modes*/   // Gross If-Else tree. tell me if there's a way to wrangle findtext or something similar into a Switch
		var/datum/firemode/old_mode = firemodes[sel_mode]
		old_mode.unapply_to(src)
		if(findtext(msg,"stun"))
			sel_mode = 1
			to_chat(usr, SPAN_WARNING("[src.name] is now set to: Stun."))
			playsound(src, safetyoff_sound, 25)
		else if(findtext(msg,"flash") || findtext(msg,"illuminate"))
			sel_mode = 2
			to_chat(usr, SPAN_WARNING("[src.name] is now set to: Flash/Illuminate."))
			playsound(src, safetyoff_sound, 25)
		else if(findtext(msg,"lethal"))
			sel_mode = 3
			to_chat(usr, SPAN_WARNING("[src.name] is now set to: Lethal."))
			playsound(src, safetyoff_sound, 25)
		else if(findtext(msg,"heavy"))
			sel_mode = 4
			to_chat(usr, SPAN_WARNING("[src.name] is now set to: Heavy."))
			playsound(src, safetyoff_sound, 25)
		/* Messages */
		else if((findtext(msg,"crowdcontrol") || findtext(msg,"crowd control")))
			message = "This is an active incident scene; make space for security contractors!"
			play_message()
		else if((findtext(msg,"loudspeaker") || findtext(msg,"amplify")))
			message = msg
			play_message()

		//Update firing mode
		var/datum/firemode/new_mode = firemodes[sel_mode]
		if(new_mode != old_mode)
			new_mode.apply_to(src)
			update_firing_delays()
			update_icon()

/obj/item/gun/energy/disruptorpistol/AltClick(mob/user)
	if(!pin || (pin && !(istype(pin, /obj/item/device/firing_pin/wireless))))
		to_chat(usr, SPAN_WARNING("Incorrect firing pin installed."))
		return

	if(!check_disruptor_user(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return

	var/new_message = tgui_input_text(user, "Set your disruptor's loudspeaker message.", "Disruptor Loudspeaer", max_length = MAX_MESSAGE_LEN)
	if(!new_message)
		to_chat(user, SPAN_WARNING("Loudspeaker message cancelled."))
	else
		message = new_message
		to_chat(user, SPAN_NOTICE("Loudspeaker message set."))

/obj/item/gun/energy/disruptorpistol/unique_action(mob/living/carbon/user)
	if(!pin || (pin && !(istype(pin, /obj/item/device/firing_pin/wireless))))
		to_chat(usr, SPAN_WARNING("Incorrect firing pin installed."))
		return

	if(!check_disruptor_user(user))
		to_chat(usr, SPAN_WARNING("Access denied."))
		return

	if(!message)
		to_chat(usr, SPAN_WARNING("No message set!"))
		return
	play_message()

/obj/item/gun/energy/disruptorpistol/practice
	name = "practice disruptor pistol"
	desc = "A variant of the NEXUS DP-8. It fires less concentrated energy bolts that are visible, but ultimately harmless, designed for target practice."
	projectile_type = /obj/projectile/energy/disruptorstun/practice
	secondary_projectile_type = /obj/projectile/energy/blaster/disruptor/practice
	firemodes = list(
		list(
			mode_name = "stun (practice)",
			projectile_type = /obj/projectile/energy/disruptorstun/practice,
			modifystate = "disruptorpistolstun",
			fire_sound = 'sound/weapons/gunshot/bolter.ogg'),
		list(
			mode_name = "flash",
			projectile_type = /obj/projectile/energy/disruptorstun/flare,
			modifystate = "disruptorpistolstun",
			fire_sound = 'sound/weapons/gunshot/bolter.ogg'),
		list(
			mode_name = "lethal (practice)",
			projectile_type = /obj/projectile/energy/blaster/disruptor/practice,
			modifystate = "disruptorpistolkill",
			fire_sound = 'sound/weapons/gunshot/bolter.ogg',
			recoil = 1),
		list(
			mode_name = "heavy (practice)",
			projectile_type = /obj/projectile/energy/blaster/disruptor/heavy/practice,
			charge_cost = 300,
			modifystate = "disruptorpistolkill",
			accuracy = -2,
			fire_delay = 18,
			recoil = 3,
			fire_sound = 'sound/weapons/gunshot/bolter.ogg')
	)


/obj/item/gun/energy/disruptorpistol/miniature
	name = "miniature disruptor pistol"
	desc = "A Nexus Corporate Security designed blaster pistol with variable settings. This is the NEXUS DP8 Mini variant."
	icon = 'icons/obj/guns/disruptorpistol/disruptorpistolc.dmi'
	max_shots = 8
	force = 3
	slot_flags = SLOT_BELT|SLOT_HOLSTER|SLOT_POCKET
	w_class = WEIGHT_CLASS_SMALL

/obj/item/gun/energy/disruptorpistol/magnum // ERT variant
	name = "magnum disruptor pistol"
	desc = "A Nexus Corporate Security designed blaster pistol with variable settings. This is the NEXUS DP8 Magnum version, used by NCS' asset protection and trauma response team contractors."
	icon = 'icons/obj/guns/disruptorpistol/disruptorpistolm.dmi'
	max_shots = 30
	force = 14

	firemodes = list(
		list(
			mode_name = "stun",
			projectile_type = /obj/projectile/energy/disruptorstun,
			modifystate = "disruptorpistolstun",
			fire_sound = 'sound/weapons/gunshot/bolter.ogg'),
		list(
			mode_name = "flash",
			projectile_type = /obj/projectile/energy/disruptorstun/flare,
			modifystate = "disruptorpistolstun",
			fire_sound = 'sound/weapons/gunshot/bolter.ogg'),
		list(
			mode_name = "extra-lethal",
			projectile_type = /obj/projectile/energy/blaster/disruptor/heavy, //normal lethal bolts replaced with heavy variant
			modifystate = "disruptorpistolkill",
			fire_sound = 'sound/weapons/gunshot/bolter.ogg',
			recoil = 1),
		list(
			mode_name = "heavy (explosive)",
			projectile_type = /obj/projectile/energy/blaster/disruptor/explosive,
			charge_cost = 300,
			modifystate = "disruptorpistolkill",
			accuracy = -2,
			fire_delay = 18, // 3x delay so you can't rapid fire these explosive blaster bolts
			recoil = 3,
			fire_sound = 'sound/weapons/gunshot/bolter.ogg')
	)

/obj/item/gun/energy/disruptorpistol/unlocked
	pin = /obj/item/device/firing_pin/wireless/unlocked

/obj/item/gun/energy/disruptorpistol/miniature/unlocked
	pin = /obj/item/device/firing_pin/wireless/unlocked

/obj/item/gun/energy/disruptorpistol/magnum/unlocked
	pin = /obj/item/device/firing_pin/wireless/unlocked
