/*
	Screen objects
	Todo: improve/re-implement

	Screen objects are only used for the hud and should not appear anywhere "in-game".
	They are used with the client/screen list and the screen_loc var.
	For more information, see the byond documentation on the screen_loc and screen vars.
*/
/obj/screen
	name = ""
	icon = 'icons/mob/screen/generic.dmi'
	layer = HUD_BASE_LAYER
	unacidable = 1
	var/obj/master = null	//A reference to the object in the slot. Grabs or items, generally.
	var/datum/hud/hud = null // A reference to the owner HUD, if any.
	appearance_flags = NO_CLIENT_COLOR

/obj/screen/Initialize(mapload, ...)
	. = ..()
	//This is done with signals because the screen code sucks, blame the ancient developers
	if(hud)
		RegisterSignal(hud, COMSIG_QDELETING, PROC_REF(handle_hud_destruction))

/obj/screen/Destroy(force = FALSE)
	master = null
	screen_loc = null
	hud = null
	. = ..()

/**
 * Handles the deletion of the HUD this screen is associated to
 */
/obj/screen/proc/handle_hud_destruction()
	SIGNAL_HANDLER

	UnregisterSignal(hud, COMSIG_QDELETING)
	qdel(src)

/obj/screen/text
	icon = null
	icon_state = null
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	screen_loc = "CENTER-7,CENTER-7"
	maptext_height = 480
	maptext_width = 480

/obj/screen/inventory
	var/slot_id	//The identifier for the slot. It has nothing to do with ID cards.
	var/list/object_overlays = list() // Required for inventory/screen overlays.
	var/color_changed = FALSE

/obj/screen/inventory/MouseEntered()
	..()
	add_overlays()

/obj/screen/inventory/MouseExited()
	..()
	cut_overlay(object_overlays)
	object_overlays.Cut()

/obj/screen/inventory/proc/add_overlays()
	var/mob/user = hud.mymob

	if(hud && user && slot_id)
		var/obj/item/holding = user.get_active_hand()
		if(!holding || user.get_equipped_item(slot_id))
			return

		var/image/item_overlay = image(holding)
		item_overlay.alpha = 92
		if(!holding.mob_can_equip(user, slot_id, disable_warning = TRUE))
			item_overlay.color = "#ff0000"
		else
			item_overlay.color = "#00ff00"
		object_overlays += item_overlay
		add_overlay(object_overlays)

/obj/screen/inventory/proc/set_color_for(var/set_color, var/set_time)
	if(color_changed)
		return
	var/old_color = color
	color = set_color
	color_changed = TRUE
	addtimer(CALLBACK(src, PROC_REF(set_color_to), old_color), set_time)

/obj/screen/inventory/proc/set_color_to(var/set_color)
	color = set_color
	color_changed = FALSE

/obj/screen/close
	name = "close"

/obj/screen/close/Click()
	if(master)
		if(istype(master, /obj/item/storage))
			var/obj/item/storage/S = master
			S.close(usr)
	return 1


/obj/screen/item_action
	var/obj/item/owner

/obj/screen/item_action/Destroy()
	owner = null
	. = ..()

/obj/screen/item_action/Click()
	if(!usr || !owner)
		return 1
	if(!usr.canClick())
		return

	if(usr.stat || usr.restrained() || usr.stunned || usr.lying)
		return 1

	if(!(owner in usr))
		return 1

	owner.ui_action_click()
	return 1

/obj/screen/grab
	name = "grab"

/obj/screen/grab/Click()
	var/obj/item/grab/G = master
	G.s_click(src)
	return 1

/obj/screen/grab/attack_hand()
	return

/obj/screen/grab/attackby()
	return


/obj/screen/storage
	name = "storage"
	screen_loc = "7,7 to 10,8"

/obj/screen/storage/Click()
	if(!usr.canClick())
		return TRUE
	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened)
		return TRUE
	if(master)
		var/obj/item/I = usr.get_active_hand()
		if(I)
			usr.ClickOn(master)
	return TRUE

/obj/screen/storage/background
	name = "background storage"
	layer = HUD_BASE_LAYER

/obj/screen/storage/background/Initialize(mapload, var/obj/set_master, var/set_icon_state)
	. = ..()
	master = set_master
	if(master)
		name = master.name
	icon_state = set_icon_state

/obj/screen/storage/background/Click()
	if(usr.incapacitated())
		return TRUE
	if(master)
		usr.ClickOn(master)
	return TRUE

/obj/screen/zone_sel
	name = "damage zone"
	icon_state = "zone_sel"
	screen_loc = ui_zonesel
	var/selecting = BP_CHEST
	var/static/list/hover_overlays_cache = list()
	var/hovering_choice
	var/mutable_appearance/selecting_appearance

/obj/screen/zone_sel/Click(location, control,params)
	if(isobserver(usr))
		return

	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])
	var/choice = get_zone_at(icon_x, icon_y)
	if(!choice)
		return 1

	return set_selected_zone(choice, usr)

/obj/screen/zone_sel/MouseEntered(location, control, params)
	MouseMove(location, control, params)

/obj/screen/zone_sel/MouseMove(location, control, params)
	if(isobserver(usr))
		return

	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])
	var/choice = get_zone_at(icon_x, icon_y)

	if(hovering_choice == choice)
		return
	remove_vis_contents(hover_overlays_cache[hovering_choice])
	hovering_choice = choice

	var/obj/effect/overlay/zone_sel/overlay_object = hover_overlays_cache[choice]
	if(!overlay_object)
		overlay_object = new
		overlay_object.icon_state = "[choice]"
		hover_overlays_cache[choice] = overlay_object
	add_vis_contents(overlay_object)


/obj/effect/overlay/zone_sel
	icon = 'icons/mob/zone_sel.dmi'
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 128
	anchored = TRUE
	plane = HUD_ITEM_LAYER

/obj/screen/zone_sel/MouseExited(location, control, params)
	if(!isobserver(usr) && hovering_choice)
		remove_vis_contents(hover_overlays_cache[hovering_choice])
		hovering_choice = null

/obj/screen/zone_sel/proc/get_zone_at(icon_x, icon_y)
	switch(icon_y)
		if(1 to 3) //Feet
			switch(icon_x)
				if(10 to 15)
					return BP_R_FOOT
				if(17 to 22)
					return BP_L_FOOT
		if(4 to 9) //Legs
			switch(icon_x)
				if(10 to 15)
					return BP_R_LEG
				if(17 to 22)
					return BP_L_LEG
		if(10 to 13) //Hands and groin
			switch(icon_x)
				if(8 to 11)
					return BP_R_HAND
				if(12 to 20)
					return BP_GROIN
				if(21 to 24)
					return BP_L_HAND
		if(14 to 22) //Chest and arms to shoulders
			switch(icon_x)
				if(8 to 11)
					return BP_R_ARM
				if(12 to 20)
					return BP_CHEST
				if(21 to 24)
					return BP_L_ARM
		if(23 to 30) //Head, but we need to check for eye or mouth
			if(icon_x in 12 to 20)
				switch(icon_y)
					if(23 to 24)
						if(icon_x in 15 to 17)
							return BP_MOUTH
					if(26) //Eyeline, eyes are on 15 and 17
						if(icon_x in 14 to 18)
							return BP_EYES
					if(25 to 27)
						if(icon_x in 15 to 17)
							return BP_EYES
				return BP_HEAD

/obj/screen/zone_sel/proc/set_selected_zone(choice, mob/user)
	if(isobserver(user))
		return
	if(choice != selecting)
		selecting = choice
		update_icon()
		SEND_SIGNAL(user, COMSIG_MOB_ZONE_SEL_CHANGE, user)

/obj/screen/zone_sel/update_icon()
	cut_overlays()
	selecting_appearance = mutable_appearance('icons/mob/zone_sel.dmi', "[selecting]")
	add_overlay(selecting_appearance)

/obj/screen/Click(location, control, params)
	if(!usr)
		return TRUE
	var/list/modifiers = params2list(params)
	switch(name)
		if("toggle")
			if(usr.hud_used.inventory_shown)
				usr.hud_used.inventory_shown = 0
				usr.client.screen -= usr.hud_used.other
			else
				usr.hud_used.inventory_shown = 1
				usr.client.screen += usr.hud_used.other

			usr.hud_used.hidden_inventory_update()

		if("equip")
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				H.quick_equip()

		if("resist")
			if(isliving(usr))
				var/mob/living/L = usr
				L.resist()

		if("act_intent")
			usr.a_intent_change("right")
		if(I_HELP)
			usr.set_intent(I_HELP)
			usr.hud_used.action_intent.icon_state = "intent_help"
		if(I_HURT)
			usr.set_intent(I_HURT)
			usr.hud_used.action_intent.icon_state = "intent_harm"
		if(I_GRAB)
			usr.set_intent(I_GRAB)
			usr.hud_used.action_intent.icon_state = "intent_grab"
		if(I_DISARM)
			usr.set_intent(I_DISARM)
			usr.hud_used.action_intent.icon_state = "intent_disarm"

		if("pull")
			usr.stop_pulling()
		if("throw")
			if(!usr.stat && isturf(usr.loc) && !usr.restrained())
				usr:toggle_throw_mode()
		if("drop")
			if(usr.client)
				usr.client.drop_item()

		if("up hint")
			if(modifiers["shift"])
				if(ishuman(usr))
					var/mob/living/carbon/human/H = usr
					if(H.last_special + 50 > world.time)
						return
					H.last_special = world.time
				to_chat(usr, SPAN_NOTICE("You take look around to see if there are any holes in the roof around."))
				for(var/turf/T in view(usr.client.view + 3, usr)) // slightly extra to account for moving while looking for openness
					if(T.density)
						continue
					var/turf/above_turf = GetAbove(T)
					if(!isopenspace(above_turf))
						continue
					var/image/up_image = image(icon = 'icons/mob/screen/generic.dmi', icon_state = "arrow_up", loc = T)
					up_image.plane = LIGHTING_LAYER + 1
					up_image.layer = LIGHTING_LAYER + 1
					usr << up_image
					QDEL_IN(up_image, 12)
				return
			var/turf/T = GetAbove(usr)
			if (!T)
				to_chat(usr, SPAN_NOTICE("There is nothing above you!"))
			else if (T.is_hole)
				to_chat(usr, "<span class='notice'>There's no roof above your head! You can see up!</span>")
			else
				to_chat(usr, "<span class='notice'>You see a ceiling staring back at you.</span>")

		if("module")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				if(modifiers["shift"])
					if(R.module)
						to_chat(R, SPAN_NOTICE("You currently have the [R.module.name] active."))
					else
						to_chat(R, SPAN_WARNING("You don't have a module active currently."))
					return
				R.pick_module()

		if("Return-to-core")
			if (istype(usr, /mob/living/silicon/robot/shell))
				usr.body_return()
				return

		if("health")
			if(isrobot(usr))
				if(modifiers["shift"])
					var/mob/living/silicon/robot/R = usr
					R.self_diagnosis_verb()

		if("inventory")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				if(R.module)
					R.hud_used.toggle_show_robot_modules()
					return 1
				else
					to_chat(R, "You haven't selected a module yet.")

		if("radio")
			if(issilicon(usr))
				if(isrobot(usr))
					if(modifiers["shift"])
						var/mob/living/silicon/robot/R = usr
						if(!R.radio.radio_desc)
							R.radio.setupRadioDescription()
						to_chat(R, SPAN_NOTICE("You analyze your integrated radio:"))
						to_chat(R, R.radio.radio_desc)
						return
				usr:radio_menu()
		if("panel")
			if(issilicon(usr))
				usr:installed_modules()

		if("store")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				if(!R.module)
					to_chat(R, SPAN_WARNING("You haven't selected a module yet."))
					return
				if(modifiers["alt"])
					R.uneq_all()
					return
				R.uneq_active()

		else
			return 0
	return 1

/obj/screen/inventory/Click()
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	if(!usr.canClick())
		return TRUE
	if(use_check_and_message(usr, USE_ALLOW_NON_ADJACENT|USE_ALLOW_NON_ADV_TOOL_USR)) //You're always adjacent to your inventory in practice.
		return TRUE
	switch(name)
		if("right hand")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.activate_hand("r")
		if("left hand")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.activate_hand("l")
		if("swap")
			usr:swap_hand()
		if("hand")
			usr:swap_hand()
		else
			if(usr.attack_ui(slot_id))
				usr.update_inv_l_hand(0)
				usr.update_inv_r_hand(0)

	return 1

/obj/screen/movement_intent
	name = "mov_intent"
	screen_loc = ui_movi

//This updates the run/walk button on the hud
/obj/screen/movement_intent/proc/update_move_icon(var/mob/living/user)
	if (!user.client)
		return

	if (user.max_stamina == -1 || user.stamina == user.max_stamina)
		if (user.stamina_bar)
			user.stamina_bar.endProgress()
			user.stamina_bar = null
	else
		if (!user.stamina_bar)
			user.stamina_bar = new(user, user.max_stamina, src)
		user.stamina_bar.goal = user.max_stamina
		user.stamina_bar.update(user.stamina)

	if (user.m_intent == M_RUN)
		icon_state = "running"
	else if (user.m_intent == M_LAY)
		icon_state = "lying"
	else
		icon_state = "walking"

#define BLACKLIST_SPECIES_RUNNING list(SPECIES_DIONA, SPECIES_DIONA_COEUS)

/obj/screen/movement_intent/Click(location, control, params)
	if(!usr)
		return 1
	var/list/modifiers = params2list(params)

	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if (modifiers["alt"])
			C.set_walk_speed()
			return

		if(C.legcuffed)
			to_chat(C, "<span class='notice'>You are legcuffed! You cannot run until you get [C.legcuffed] removed!</span>")
			C.m_intent = M_WALK	//Just incase
			C.hud_used.move_intent.icon_state = "walking"
			return 1
		switch(usr.m_intent)
			if(M_RUN)
				usr.m_intent = M_WALK
			if(M_WALK)
				if(!(usr.get_species() in BLACKLIST_SPECIES_RUNNING))
					usr.m_intent = M_RUN

			if(M_LAY)

				// No funny "haha i get the bonuses then stand up"
				var/obj/item/gun/gun_in_hand = C.get_type_in_hands(/obj/item/gun)
				if(gun_in_hand?.wielded)
					to_chat(C, SPAN_WARNING("You cannot wield and stand up!"))
					return

				if(C.lying_is_intentional)
					usr.m_intent = M_WALK

		if(modifiers["button"] == "middle" && !C.lying)	// See /mob/proc/update_canmove() for more logic on the lying FSM

			// You want this bonus weapon or not? Wield it when you are lying, not before!
			var/obj/item/gun/gun_in_hand = C.get_type_in_hands(/obj/item/gun)
			if(gun_in_hand?.wielded)
				to_chat(C, SPAN_WARNING("You cannot wield and lie down!"))
				return
			C.m_intent = M_LAY

	else if(istype(usr, /mob/living/simple_animal/hostile/morph))
		var/mob/living/simple_animal/hostile/morph/M = usr
		switch(usr.m_intent)
			if(M_RUN)
				usr.m_intent = M_WALK
			if(M_WALK)
				usr.m_intent = M_RUN
		M.update_speed()
	update_move_icon(usr)

#undef BLACKLIST_SPECIES_RUNNING

// Hand slots are special to handle the handcuffs overlay
/obj/screen/inventory/hand
	var/image/handcuff_overlay
	var/image/disabled_hand_overlay
	var/image/removed_hand_overlay

/obj/screen/inventory/hand/update_icon()
	..()
	if(!hud)
		return
	if(!handcuff_overlay)
		var/state = (hud.l_hand_hud_object == src) ? "l_hand_hud_handcuffs" : "r_hand_hud_handcuffs"
		handcuff_overlay = image("icon"='icons/mob/screen_gen.dmi', "icon_state" = state)
	if(!disabled_hand_overlay)
		var/state = (hud.l_hand_hud_object == src) ? "l_hand_disabled" : "r_hand_disabled"
		disabled_hand_overlay = image("icon" = 'icons/mob/screen_gen.dmi', "icon_state" = state)
	if(!removed_hand_overlay)
		var/state = (hud.l_hand_hud_object == src) ? "l_hand_removed" : "r_hand_removed"
		removed_hand_overlay = image("icon" = 'icons/mob/screen_gen.dmi', "icon_state" = state)
	cut_overlays()
	if(hud.mymob && ishuman(hud.mymob))
		var/mob/living/carbon/human/H = hud.mymob
		var/obj/item/organ/external/O
		if(hud.l_hand_hud_object == src)
			O = H.organs_by_name[BP_L_HAND]
		else
			O = H.organs_by_name[BP_R_HAND]
		if(!O || O.is_stump())
			add_overlay(removed_hand_overlay)
		else if(O && (!O.is_usable() || O.is_malfunctioning()))
			add_overlay(disabled_hand_overlay)
		if(H.handcuffed)
			add_overlay(handcuff_overlay)

/obj/screen/inventory/back
	name = "back"
