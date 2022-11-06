//cyborgs presets, mostly used for events/admin bus
/mob/living/silicon/robot/military
	mod_type = "Military"
	spawn_module = /obj/item/robot_module/military
	cell_type = /obj/item/cell/super
	braintype = "Android" // Posibrain.

/mob/living/silicon/robot/military/ert
	scrambled_codes = TRUE
	law_update = FALSE
	law_preset = /datum/ai_laws/nanotrasen_aggressive
	id_card_type = /obj/item/card/id/ert
	key_type = /obj/item/device/encryptionkey/ert
	has_jetpack = TRUE

/mob/living/silicon/robot/scrambled //should not stand linked to the station or the ai
	scrambled_codes = TRUE
	law_update = FALSE

/mob/living/silicon/robot/bluespace
	mod_type = "Bluespace"
	spawn_module = /obj/item/robot_module/bluespace
	cell_type = /obj/item/cell/infinite
	overclocked = TRUE
	law_update = FALSE
	scrambled_codes = TRUE
	status_flags = GODMODE|NOFALL

/mob/living/silicon/robot/bluespace/verb/antigrav()
	set name = "Toggle Gravity"
	set desc = "Use bluespace technology to ignore gravity."
	set category = "BST"

	status_flags ^= NOFALL
	to_chat(src, SPAN_NOTICE("You will [status_flags & NOFALL ? "no longer fall" : "now fall normally"]."))

/mob/living/silicon/robot/bluespace/verb/bstwalk()
	set name = "Toggle Incorporeal Movement"
	set desc = "Use bluespace technology to phase through solid matter and move quickly."
	set category = "BST"
	set popup_menu = 0

	if(!src.incorporeal_move)
		src.incorporeal_move = INCORPOREAL_BSTECH
		to_chat(src, SPAN_NOTICE("You will now phase through solid matter."))
	else
		src.incorporeal_move = INCORPOREAL_DISABLE
		to_chat(src, SPAN_NOTICE("You will no-longer phase through solid matter."))
	return

/mob/living/silicon/robot/bluespace/verb/bstrecover()
	set name = "Restore Health"
	set desc = "Use bluespace to teleport in a fresh, healthy body."
	set category = "BST"
	set popup_menu = 0

	src.revive()

/mob/living/silicon/robot/bluespace/verb/bstquit()
	set name = "Teleport out"
	set desc = "Jump into bluespace and continue wherever you left off. Deletes the BSTech and returns to your original mob if you have one."
	set category = "BST"

	src.custom_emote(VISIBLE_MESSAGE, "politely beeps as its lights start to flash.")
	spark(src, 5, alldirs)
	QDEL_IN(src, 10)
	animate(src, alpha = 0, time = 9, easing = QUAD_EASING)

	if(key)
		if(client.holder && client.holder.original_mob)
			client.holder.original_mob.key = key
		else
			var/mob/abstract/observer/ghost = new(src)	//Transfer safety to observer spawning proc.
			ghost.key = key
			ghost.mind.name = "[ghost.key] BSTech"
			ghost.name = "[ghost.key] BSTech"
			ghost.real_name = "[ghost.key] BSTech"
			ghost.voice_name = "[ghost.key] BSTech"

/mob/living/silicon/robot/bluespace/verb/tgm()
	set name = "Toggle Godmode"
	set desc = "For when you want to be vulnerable."
	set category = "BST"

	status_flags ^= GODMODE
	to_chat(src, SPAN_NOTICE("God mode is now [status_flags & GODMODE ? "enabled" : "disabled"]"))
