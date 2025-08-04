/obj/item/clothing/wrists/watch
	name = "watch"
	desc = "It's a GaussIo ZeitMeister, a finely tuned wristwatch encased in black plastic."
	desc_extended = "For those who want too much time on their wrists instead."
	icon_state = "watch"
	item_state = "watch"
	var/wired = TRUE
	var/screwed = TRUE

/obj/item/clothing/wrists/watch/silver
	desc = "It's a GaussIo ZeitMeister, a finely tuned wristwatch encased in silver."
	desc_extended = "To unleash the telemarketer in you!"
	icon_state = "watch_silver"
	item_state = "watch_silver"

/obj/item/clothing/wrists/watch/gold
	desc = "It's a GaussIo ZeitMeister, a finely tuned wristwatch encased in <b>REAL</b> faux gold."
	desc_extended = "Be the jerk-ass pawn shop owner you'll never be."
	icon_state = "watch_gold"
	item_state = "watch_gold"

/obj/item/clothing/wrists/watch/holo
	desc = "It's a GaussIo ZeitMeister with a holographic screen."
	desc_extended = "The latest Elyran technology!"
	icon_state = "watch_holo"
	item_state = "watch_holo"

/obj/item/clothing/wrists/watch/leather
	desc = "It's a GaussIo ZeitMeister, a finely tuned wristwatch encased in leather."
	desc_extended = "Made from real synth leather."
	icon_state = "watch_leather"
	item_state = "watch_leather"

/obj/item/clothing/wrists/watch/spy
	desc = "It's a GENUINE Spy-Tech Invisi-watch! <b>WARNING</b> : Does not actually make you invisible."
	desc_extended = "Makes you want to wear a balaclava and smoke a cigarette."
	icon_state = "watch_spy"
	item_state = "watch_silver"

/obj/item/clothing/wrists/watch/spy/checktime()
	to_chat(usr, "You check your watch. Unfortunately for you, it's not a real watch, dork.")

/obj/item/clothing/wrists/watch/pocketwatch
	name = "pocketwatch"
	desc = "A watch that goes in your pocket."
	desc_extended = "Because your wrists have better things to do. Can go on your belt, suit storage, or on your wrist to create different appearances."
	icon_state = "pocketwatch"
	item_state = "pocketwatch"
	slot_flags = SLOT_WRISTS | SLOT_BELT | SLOT_S_STORE
	var/closed = FALSE

/obj/item/clothing/wrists/watch/pocketwatch/AltClick(mob/user)
	if(!closed)
		icon_state = "[initial(icon_state)]_closed"
		item_state = "[initial(icon_state)]_closed"
		update_held_icon()
		update_worn_icon()
		user.visible_message(SPAN_NOTICE("[user] clasps \the [name] shut."), SPAN_NOTICE("You clasp \the [name] shut."))
		playsound(src.loc, 'sound/weapons/blade_close.ogg', 50, 1)
	else
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(icon_state)]"
		update_held_icon()
		update_worn_icon()
		user.visible_message(SPAN_NOTICE("[user] flips \the [name] open."), SPAN_NOTICE("You flip \the [name] open."))
		playsound(src.loc, 'sound/weapons/blade_open.ogg', 50, 1)
	closed = !closed

/obj/item/clothing/wrists/watch/pocketwatch/get_wrist_examine_text(mob/user)
	var/mob/living/carbon/human/H = user
	return "in [user.get_pronoun("his")] pocket[H.pants ? ", the chain connected to [user.get_pronoun("his")] [H.pants.name]'s belt loop" : ""]"

/obj/item/clothing/wrists/watch/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	. = ..()
	if (distance <= 1)
		checktime()

/obj/item/clothing/wrists/watch/pocketwatch/checktime(mob/user)
	if(closed)
		to_chat(usr, "You check your watch, realising it's closed.")
	else
		to_chat(usr, "You check your watch, glancing over at the watch face, reading the time to be '[worldtime2text()]'. Today's date is '[time2text(world.time, "Month DD")]. [GLOB.game_year]'.")

/obj/item/clothing/wrists/watch/pocketwatch/pointatwatch()
	if(closed)
		usr.visible_message(SPAN_NOTICE("[usr] taps their foot on the floor, arrogantly pointing at the [src] in their hand with a look of derision in their eyes, not noticing it's closed."), SPAN_NOTICE("You point down at the [src], an arrogant look about your eyes."))
	else
		usr.visible_message(SPAN_NOTICE("[usr] taps their foot on the floor, arrogantly pointing at the [src] in their hand with a look of derision in their eyes."), SPAN_NOTICE("You point down at the [src], an arrogant look about your eyes."))

/obj/item/clothing/wrists/watch/verb/checktime()
	set category = "Object"
	set name = "Check Time"
	set src in usr

	if(wired && screwed)
		to_chat(usr, "You check your watch, spotting a digital collection of numbers reading '[worldtime2text()]'. Today's date is '[time2text(world.time, "Month DD")]. [GLOB.game_year]'.")
		if (GLOB.evacuation_controller.get_status_panel_eta())
			to_chat(usr, SPAN_WARNING("Time until Bluespace Jump: [GLOB.evacuation_controller.get_status_panel_eta()]."))
	else if(wired && !screwed)
		to_chat(usr, "You check your watch, realising it's still open.")
	else
		to_chat(usr, "You check your watch as it dawns on you that it's broken.")

/obj/item/clothing/wrists/watch/verb/pointatwatch()
	set category = "Object"
	set name = "Point At Watch"
	set src in usr

	if(wired && screwed)
		usr.visible_message (SPAN_NOTICE("<b>[usr]</b> taps their foot on the floor, arrogantly pointing at the [src] on their wrist with a look of derision in their eyes"), SPAN_NOTICE("You point down at the [src] with an arrogant look about your eyes."))
	else if(wired && !screwed)
		usr.visible_message (SPAN_NOTICE("<b>[usr]</b> taps their foot on the floor, arrogantly pointing at the [src] on their wrist with a look of derision in their eyes, not noticing it's open."), SPAN_NOTICE("You point down at the [src] with an arrogant look about your eyes."))
	else
		usr.visible_message (SPAN_NOTICE("<b>[usr]</b> taps their foot on the floor, arrogantly pointing at the [src] on their wrist with a look of derision in their eyes, not noticing it's broken."), SPAN_NOTICE("You point down at the [src] with an arrogant look about your eyes."))

/obj/item/clothing/wrists/watch/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.isscrewdriver())
		user.visible_message(SPAN_NOTICE("<b>[user]</b> [screwed ? "unscrews" : "screws"] the cover of the [src] [screwed ? "open" : "closed"]."),
							SPAN_NOTICE("You [screwed ? "unscrews" : "screws"] the cover of the [src] [screwed ? "open" : "closed"]."))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		screwed = !screwed
		return
	if(wired)
		return
	if(attacking_item.iscoil())
		var/obj/item/stack/cable_coil/C = attacking_item
		if(screwed)
			to_chat(user, SPAN_NOTICE("The [src] is not open."))
			return

		if(wired)
			to_chat(user, SPAN_NOTICE("The [src] are already wired."))
			return

		if(C.amount < 2)
			to_chat(user, SPAN_NOTICE("There is not enough wire to cover the [src]."))
			return

		C.use(2)
		wired = TRUE
		to_chat(user, SPAN_NOTICE("You repair some wires in the [src]."))
		return

/obj/item/clothing/wrists/watch/emp_act(severity)
	. = ..()

	if(prob(50/severity))
		wired = FALSE
