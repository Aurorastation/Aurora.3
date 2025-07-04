/obj/item/mesmetron
	name = "mesmetron pocketwatch"
	desc = "An elaborate pocketwatch, with a captivating gold etching and an enchanting face. . ."
	icon = 'icons/obj/item/clothing/wrists/wrist.dmi'
	icon_state = "pocketwatch"
	item_state = "pocketwatch"
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'
	matter = list(MATERIAL_GLASS = 150, MATERIAL_GOLD = 50)
	recyclable = TRUE
	w_class = WEIGHT_CLASS_TINY
	atom_flags = ITEM_FLAG_NO_BLUDGEON
	var/datum/weakref/thrall = null
	var/time_counter = 0
	var/closed = FALSE

/obj/item/mesmetron/AltClick(mob/user)
	if(!closed)
		icon_state = "[initial(icon_state)]_closed"
		to_chat(user, "You clasp the [name] shut.")
		playsound(src.loc, 'sound/weapons/blade_close.ogg', 50, 1)
	else
		icon_state = "[initial(icon_state)]"
		to_chat(user, "You flip the [name] open.")
		playsound(src.loc, 'sound/weapons/blade_open.ogg', 50, 1)
	closed = !closed

/obj/item/mesmetron/Destroy()
	STOP_PROCESSING(SSfast_process, src)
	thrall = null
	. = ..()

/obj/item/mesmetron/process()
	if (!thrall)
		STOP_PROCESSING(SSfast_process, src)
		return

	var/mob/living/carbon/human/H = thrall.resolve()
	if(!H)
		thrall = null
		STOP_PROCESSING(SSfast_process, src)
		return

	if (time_counter > 20)
		time_counter += 0.5
		var/thrall_response = alert(H, "Do you believe in hypnosis?", "Willpower", "Yes", "No")
		if(thrall_response == "No")
			H.sleeping = max(H.sleeping - 40, 0)
			H.drowsiness = max(H.drowsiness - 60, 0)
			thrall = null
			STOP_PROCESSING(SSfast_process, src)
		else
			H.sleeping = max(H.sleeping, 40)
			H.drowsiness = max(H.drowsiness, 60)
	else
		STOP_PROCESSING(SSfast_process, src)

/obj/item/mesmetron/attack_self(mob/user as mob)
	if(closed)
		return
	if(!thrall || !thrall.resolve())
		thrall = null
		to_chat(user, "You decipher the watch's mesmerizing face, discerning the time to be: '[worldtime2text()]'. Today's date is '[time2text(world.time, "Month DD")]. [GLOB.game_year]'.")
		return

	var/mob/living/carbon/human/H = thrall.resolve()

	var/response = alert(user, "Would you like to make a suggestion to [thrall], or release them?", "Mesmetron", "Suggestion", "Release")

	if (response == "Release")
		thrall = null
		STOP_PROCESSING(SSfast_process, src)
	else
		if(get_dist(user, H) > 1)
			to_chat(user, "You must stand in whisper range of [H].")
			return

		text = tgui_input_text(user, "What would you like to suggest?", "Hypnotic Suggestion")
		if(!text)
			return

		var/thrall_response = alert(H, "Do you believe in hypnosis?", "Willpower", "Yes", "No")
		if(thrall_response == "Yes")
			to_chat(H, SPAN_NOTICE("<i>... [text] ...</i>"))
		else
			thrall = null

/obj/item/mesmetron/afterattack(mob/living/carbon/human/H, mob/user, proximity)
	if(closed)
		return

	if(!proximity)
		return

	if(!istype(H))
		return

	user.visible_message(SPAN_WARNING("[user] begins to mesmerizingly wave [src] like a pendulum before [H]'s very eyes!"))

	if(!do_mob(user, H, 10 SECONDS))
		return

	if(!(user in view(1, loc)))
		return

	var/response = alert(H, "Do you believe in hypnosis?", "Willpower", "Yes", "No")

	if(response == "Yes")
		H.visible_message(SPAN_WARNING("[H] falls into a deep slumber!</span>"), SPAN_DANGER("You fall into a deep slumber!"))

		H.sleeping = max(H.sleeping, 40)
		H.drowsiness = max(H.drowsiness, 60)
		thrall = WEAKREF(H)
		START_PROCESSING(SSfast_process, src)

/obj/structure/metronome
	name = "metronome"
	desc = "Tick. Tock. Tick. Tock. Tick. Tock."
	icon = 'icons/obj/structures.dmi'
	icon_state = "metronome1"
	anchored = 1
	density = 0
	var/time_last_ran = 0
	var/ticktock = "Tick"

/obj/structure/metronome/Destroy()
	STOP_PROCESSING(SSfast_process, src)
	. = ..()

/obj/structure/metronome/Initialize()
	. = ..()
	START_PROCESSING(SSfast_process, src)

/obj/structure/metronome/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswrench())
		attacking_item.play_tool_sound(get_turf(src), 50)
		if(anchored)
			to_chat(user, SPAN_NOTICE("You unanchor \the [src] and it destabilizes."))
			STOP_PROCESSING(SSfast_process, src)
			icon_state = "metronome0"
			anchored = 0
		else
			to_chat(user, SPAN_NOTICE("You anchor \the [src] and it restabilizes."))
			START_PROCESSING(SSfast_process, src)
			icon_state = "metronome1"
			anchored = 1
	else
		..()

/obj/structure/metronome/process()
	if (world.time - time_last_ran < 60)
		return

	time_last_ran = world.time
	var/counter = 0
	var/mob/living/carbon/human/H
	for(var/mob/living/L in view(3,src.loc))
		counter++
		if(ishuman(L))
			H = L

	if(counter == 1 && H)
		if(ticktock == "Tick")
			ticktock = "Tock"
		else
			ticktock = "Tick"
		to_chat(H, SPAN_NOTICE("<i>[ticktock]. . .</i>"))
		sound_to(H, 'sound/effects/singlebeat.ogg')
