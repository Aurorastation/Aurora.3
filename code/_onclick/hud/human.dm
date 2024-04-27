/mob/living/carbon/human/instantiate_hud(datum/hud/HUD, ui_style, ui_color, ui_alpha)
	HUD.human_hud(ui_style, ui_color, ui_alpha, src)

/datum/hud/proc/human_hud(var/ui_style='icons/mob/screen/white.dmi', var/ui_color = "#ffffff", var/ui_alpha = 255, var/mob/living/carbon/human/target)
	var/datum/hud_data/hud_data
	if(!istype(target))
		hud_data = new()
	else
		hud_data = target.species.hud

	if(hud_data.icon)
		ui_style = hud_data.icon

	src.adding = list()
	src.other = list()
	src.hotkeybuttons = list() //These can be disabled for hotkey usersx

	var/list/hud_elements = list()
	var/obj/screen/using
	var/obj/screen/inventory/inv_box

	// Draw the various inventory equipment slots.
	var/has_hidden_gear
	for(var/gear_slot in hud_data.gear)
		var/list/slot_data = hud_data.gear[gear_slot]
		var/hud_type = /obj/screen/inventory
		if(slot_data["slot_type"])
			hud_type = slot_data["slot_type"]
		inv_box = new hud_type()
		inv_box.icon = ui_style
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha
		inv_box.hud = src

		inv_box.name =        slot_data["name"]
		inv_box.screen_loc =  slot_data["loc"]
		inv_box.slot_id =     slot_data["slot"]
		inv_box.icon_state =  slot_data["state"]

		if(slot_data["dir"])
			inv_box.set_dir(slot_data["dir"])

		if(slot_data["toggle"])
			src.other += inv_box
			has_hidden_gear = 1
		else
			src.adding += inv_box

	if(has_hidden_gear)
		using = new /obj/screen()
		using.name = "toggle"
		using.icon = ui_style
		using.icon_state = "other"
		using.screen_loc = ui_inventory
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using

	// Draw the attack intent dialogue.
	if(hud_data.has_a_intent)

		using = new /obj/screen()
		using.name = "act_intent"
		using.icon = ui_style
		using.icon_state = "intent_"+mymob.a_intent
		using.screen_loc = ui_acti
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using
		action_intent = using

		hud_elements |= using

		//intent small hud objects
		var/icon/ico

		ico = new(ui_style, "black")
		ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
		ico.DrawBox(rgb(255,255,255,1),1,ico.Height()/2,ico.Width()/2,ico.Height())
		using = new /obj/screen( src )
		using.name = I_HELP
		using.icon = ico
		using.screen_loc = ui_acti
		using.alpha = ui_alpha
		src.adding += using
		help_intent = using

		ico = new(ui_style, "black")
		ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
		ico.DrawBox(rgb(255,255,255,1),ico.Width()/2,ico.Height()/2,ico.Width(),ico.Height())
		using = new /obj/screen( src )
		using.name = I_DISARM
		using.icon = ico
		using.screen_loc = ui_acti
		using.alpha = ui_alpha
		src.adding += using
		disarm_intent = using

		ico = new(ui_style, "black")
		ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
		ico.DrawBox(rgb(255,255,255,1),ico.Width()/2,1,ico.Width(),ico.Height()/2)
		using = new /obj/screen( src )
		using.name = I_GRAB
		using.icon = ico
		using.screen_loc = ui_acti
		using.alpha = ui_alpha
		src.adding += using
		grab_intent = using

		ico = new(ui_style, "black")
		ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
		ico.DrawBox(rgb(255,255,255,1),1,1,ico.Width()/2,ico.Height()/2)
		using = new /obj/screen( src )
		using.name = I_HURT
		using.icon = ico
		using.screen_loc = ui_acti
		using.alpha = ui_alpha
		src.adding += using
		hurt_intent = using
		//end intent small hud objects

	if(hud_data.has_m_intent)
		using = new /obj/screen/movement_intent()
		using.icon = ui_style
		using.icon_state = (mymob.m_intent == M_RUN ? "running" : "walking")
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using
		move_intent = using

	if(hud_data.has_drop)
		using = new /obj/screen()
		using.name = "drop"
		using.icon = ui_style
		using.icon_state = "act_drop"
		using.screen_loc = ui_drop_throw
		using.color = ui_color
		using.alpha = ui_alpha
		src.hotkeybuttons += using

	if(hud_data.has_hands)

		using = new /obj/screen()
		using.name = "equip"
		using.icon = ui_style
		using.icon_state = "act_equip"
		using.screen_loc = ui_equip
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using

		inv_box = new /obj/screen/inventory/hand()
		inv_box.hud = src
		inv_box.name = "right hand"
		inv_box.icon = ui_style
		inv_box.icon_state = "r_hand_inactive"
		if(mymob && !mymob.hand)	//This being 0 or null means the right hand is in use
			inv_box.icon_state = "r_hand_active"
		inv_box.screen_loc = ui_rhand
		inv_box.slot_id = slot_r_hand
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha

		src.r_hand_hud_object = inv_box
		src.adding += inv_box

		inv_box = new /obj/screen/inventory/hand()
		inv_box.hud = src
		inv_box.name = "left hand"
		inv_box.icon = ui_style
		inv_box.icon_state = "l_hand_inactive"
		if(mymob && mymob.hand)	//This being 1 means the left hand is in use
			inv_box.icon_state = "l_hand_active"
		inv_box.screen_loc = ui_lhand
		inv_box.slot_id = slot_l_hand
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha
		src.l_hand_hud_object = inv_box
		src.adding += inv_box

		target.update_hud_hands()

		using = new /obj/screen/inventory()
		using.name = "hand"
		using.icon = ui_style
		using.icon_state = "hand1"
		using.screen_loc = ui_swaphand1
		using.color = ui_color
		using.alpha = ui_alpha
		using.hud = src
		src.adding += using

		using = new /obj/screen/inventory()
		using.name = "hand"
		using.icon = ui_style
		using.icon_state = "hand2"
		using.screen_loc = ui_swaphand2
		using.color = ui_color
		using.alpha = ui_alpha
		using.hud = src
		src.adding += using

	if(hud_data.has_resist)
		using = new /obj/screen()
		using.name = "resist"
		using.icon = ui_style
		using.icon_state = "act_resist"
		using.screen_loc = ui_pull_resist
		using.color = ui_color
		using.alpha = ui_alpha
		src.hotkeybuttons += using

	if(hud_data.has_throw)
		mymob.throw_icon = new /obj/screen()
		mymob.throw_icon.icon = ui_style
		mymob.throw_icon.icon_state = "act_throw_off"
		mymob.throw_icon.name = "throw"
		mymob.throw_icon.screen_loc = ui_drop_throw
		mymob.throw_icon.color = ui_color
		mymob.throw_icon.alpha = ui_alpha
		src.hotkeybuttons += mymob.throw_icon
		hud_elements |= mymob.throw_icon

		mymob.pullin = new /obj/screen()
		mymob.pullin.icon = ui_style
		mymob.pullin.icon_state = "pull0"
		mymob.pullin.name = "pull"
		mymob.pullin.screen_loc = ui_pull_resist
		src.hotkeybuttons += mymob.pullin
		hud_elements |= mymob.pullin

	if(hud_data.has_internals)
		mymob.internals = new /obj/screen/internals()
		mymob.internals.icon = ui_style
		hud_elements |= mymob.internals
		if(!isnull(target.internal))
			mymob.internals.icon_state = "internal1"

	if(hud_data.has_warnings)
		mymob.oxygen = new /obj/screen/oxygen()
		mymob.oxygen.icon = 'icons/mob/status_indicators.dmi'
		mymob.oxygen.icon_state = "oxy0"
		mymob.oxygen.name = "oxygen"
		mymob.oxygen.screen_loc = ui_temp
		hud_elements |= mymob.oxygen

		mymob.toxin = new /obj/screen/toxins()
		mymob.toxin.icon = 'icons/mob/status_indicators.dmi'
		mymob.toxin.icon_state = "tox0"
		mymob.toxin.name = "toxin"
		mymob.toxin.screen_loc = ui_temp
		hud_elements |= mymob.toxin

		mymob.fire = new /obj/screen()
		mymob.fire.icon = ui_style
		mymob.fire.icon_state = "fire0"
		mymob.fire.name = "fire"
		mymob.fire.screen_loc = ui_fire
		hud_elements |= mymob.fire

		mymob.paralysis_indicator = new /obj/screen/paralysis()
		mymob.paralysis_indicator.icon = 'icons/mob/status_indicators.dmi'
		mymob.paralysis_indicator.icon_state = "paralysis0"
		mymob.paralysis_indicator.name = "paralysis"
		mymob.paralysis_indicator.screen_loc = ui_paralysis
		hud_elements |= mymob.paralysis_indicator

		mymob.healths = new /obj/screen()
		mymob.healths.icon = ui_style
		mymob.healths.icon_state = "health0"
		mymob.healths.name = "health"
		mymob.healths.screen_loc = ui_health
		if(target.species.healths_x)
			var/ui_health_loc = replacetext(ui_health, ui_health_east_loc, "[ui_health_east_template][target.species.healths_x]")
			mymob.healths.screen_loc = ui_health_loc
		hud_elements |= mymob.healths

	if(hud_data.has_pressure)
		mymob.pressure = new /obj/screen/pressure()
		mymob.pressure.icon = 'icons/mob/status_indicators.dmi'
		mymob.pressure.icon_state = "pressure0"
		mymob.pressure.name = "pressure"
		mymob.pressure.screen_loc = ui_temp
		hud_elements |= mymob.pressure

	if(hud_data.has_bodytemp)
		mymob.bodytemp = new /obj/screen/bodytemp()
		mymob.bodytemp.icon = 'icons/mob/status_indicators.dmi'
		mymob.bodytemp.icon_state = "temp1"
		mymob.bodytemp.name = "body temperature"
		mymob.bodytemp.screen_loc = ui_temp
		hud_elements |= mymob.bodytemp

	if(hud_data.has_cell)
		mymob.cells = new /obj/screen()
		mymob.cells.icon = 'icons/mob/screen/robot.dmi'
		mymob.cells.icon_state = "charge-empty"
		mymob.cells.name = "cell"
		mymob.cells.screen_loc = ui_nutrition
		hud_elements |= target.cells

	if(hud_data.has_nutrition)
		mymob.nutrition_icon = new /obj/screen/food()
		mymob.nutrition_icon.icon = 'icons/mob/status_hunger.dmi'
		mymob.nutrition_icon.pixel_w = 8
		mymob.nutrition_icon.icon_state = "nutrition0"
		mymob.nutrition_icon.name = "nutrition"
		mymob.nutrition_icon.screen_loc = ui_nutrition
		hud_elements |= mymob.nutrition_icon

	if(hud_data.has_hydration)
		mymob.hydration_icon = new /obj/screen/thirst()
		mymob.hydration_icon.icon = 'icons/mob/status_hunger.dmi'
		mymob.hydration_icon.icon_state = "thirst0"
		mymob.hydration_icon.name = "thirst"
		mymob.hydration_icon.screen_loc = ui_nutrition
		hud_elements |= mymob.hydration_icon

	if(hud_data.has_up_hint)
		mymob.up_hint = new /obj/screen()
		mymob.up_hint.icon = ui_style
		mymob.up_hint.icon_state = "uphint0"
		mymob.up_hint.name = "up hint"
		mymob.up_hint.screen_loc = ui_up_hint
		hud_elements |= mymob.up_hint

	mymob.pain = new /obj/screen/fullscreen/pain(null)
	hud_elements |= mymob.pain

	mymob.instability_display = new /obj/screen/instability()
	mymob.instability_display.screen_loc = ui_instability_display
	mymob.instability_display.icon_state = "wiz_instability_none"
	hud_elements |= mymob.instability_display

	mymob.energy_display = new /obj/screen/energy()
	mymob.energy_display.screen_loc = ui_energy_display
	mymob.energy_display.icon_state = "wiz_energy"
	hud_elements |= mymob.energy_display

	mymob.zone_sel = new /obj/screen/zone_sel(null)
	mymob.zone_sel.icon = ui_style
	mymob.zone_sel.color = ui_color
	mymob.zone_sel.alpha = ui_alpha
	mymob.zone_sel.cut_overlays()
	mymob.zone_sel.add_overlay(image('icons/mob/zone_sel.dmi', "[mymob.zone_sel.selecting]"))
	hud_elements |= mymob.zone_sel

	//Handle the gun settings buttons
	mymob.gun_setting_icon = new /obj/screen/gun/mode(null)
	mymob.gun_setting_icon.icon = ui_style
	mymob.gun_setting_icon.color = ui_color
	mymob.gun_setting_icon.alpha = ui_alpha
	hud_elements |= mymob.gun_setting_icon

	mymob.item_use_icon = new /obj/screen/gun/item(null)
	mymob.item_use_icon.icon = ui_style
	mymob.item_use_icon.color = ui_color
	mymob.item_use_icon.alpha = ui_alpha

	mymob.gun_move_icon = new /obj/screen/gun/move(null)
	mymob.gun_move_icon.icon = ui_style
	mymob.gun_move_icon.color = ui_color
	mymob.gun_move_icon.alpha = ui_alpha

	mymob.radio_use_icon = new /obj/screen/gun/radio(null)
	mymob.radio_use_icon.icon = ui_style
	mymob.radio_use_icon.color = ui_color
	mymob.radio_use_icon.alpha = ui_alpha

	mymob.toggle_firing_mode = new /obj/screen/gun/burstfire(null)
	mymob.toggle_firing_mode.icon = ui_style
	mymob.toggle_firing_mode.color = ui_color
	mymob.toggle_firing_mode.alpha = ui_alpha
	hud_elements |= mymob.toggle_firing_mode

	mymob.unique_action_icon = new /obj/screen/gun/uniqueaction(null)
	mymob.unique_action_icon.icon = ui_style
	mymob.unique_action_icon.color = ui_color
	mymob.unique_action_icon.alpha = ui_alpha
	hud_elements |= mymob.unique_action_icon

	mymob.client.screen = null

	mymob.client.screen += hud_elements
	mymob.client.screen += src.adding + src.hotkeybuttons
	inventory_shown = 0;

	return


/mob/living/carbon/human/verb/toggle_hotkey_verbs()
	set category = "OOC"
	set name = "Toggle hotkey buttons"
	set desc = "This disables or enables the user interface buttons which can be used with hotkeys."

	if(hud_used.hotkey_ui_hidden)
		client.screen += hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 0
	else
		client.screen -= hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 1

//Used for new human mobs created by cloning/goleming/etc.
/mob/living/carbon/human/proc/set_cloned_appearance()
	f_style = "Shaved"
	if(dna.species == SPECIES_HUMAN) //no more xenos losing ears/tentacles
		h_style = pick("Bedhead", "Bedhead 2", "Bedhead 3")
	all_underwear.Cut()
	regenerate_icons()

// Yes, these use icon state. Yes, these are terrible. The alternative is duplicating
// a bunch of fairly blobby logic for every click override on these objects.

/obj/screen/food/Click(var/location, var/control, var/params)
	if(istype(usr) && usr.nutrition_icon == src)
		switch(icon_state)
			if("nutrition0")
				to_chat(usr, SPAN_WARNING("You are completely stuffed."))
			if("nutrition1")
				to_chat(usr, SPAN_NOTICE("You are not hungry."))
			if("nutrition2")
				to_chat(usr, SPAN_NOTICE("You are a bit peckish."))
			if("nutrition3")
				to_chat(usr, SPAN_WARNING("You are quite hungry."))
			if("nutrition4")
				to_chat(usr, SPAN_WARNING("You are really hungry."))
			if("nutrition5")
				to_chat(usr, SPAN_DANGER("You are starving!"))
			if("charge0")
				to_chat(usr, SPAN_GOOD("You are fully charged."))
			if("charge1")
				to_chat(usr, SPAN_NOTICE("You're almost topped up."))
			if("charge2")
				to_chat(usr, SPAN_NOTICE("You could go for a recharge."))
			if("charge3")
				to_chat(usr, SPAN_WARNING("You're running a bit low."))
			if("charge4")
				to_chat(usr, SPAN_WARNING("You're getting close to running out."))
			if("charge5")
				to_chat(usr, SPAN_DANGER("You have almost no charge left!"))

/obj/screen/thirst/Click(var/location, var/control, var/params)
	if(istype(usr) && usr.hydration_icon == src)
		switch(icon_state)
			if("thirst0")
				to_chat(usr, SPAN_WARNING("You are completely hydrated."))
			if("thirst1")
				to_chat(usr, SPAN_NOTICE("You are not thirsty"))
			if("thirst2")
				to_chat(usr, SPAN_NOTICE("You are a bit thirsty."))
			if("thirst3")
				to_chat(usr, SPAN_WARNING("You are quite thirsty."))
			if("thirst4")
				to_chat(usr, SPAN_DANGER("You are entirely dehydrated!"))

/obj/screen/bodytemp/Click(var/location, var/control, var/params)
	if(istype(usr) && usr.bodytemp == src)
		switch(icon_state)
			if("temp4")
				to_chat(usr, SPAN_DANGER("You are being cooked alive!"))
			if("temp3")
				to_chat(usr, SPAN_DANGER("Your body is burning up!"))
			if("temp2")
				to_chat(usr, SPAN_DANGER("You are overheating."))
			if("temp1")
				to_chat(usr, SPAN_WARNING("You are uncomfortably hot."))
			if("temp-4")
				to_chat(usr, SPAN_DANGER("You are being frozen solid!"))
			if("temp-3")
				to_chat(usr, SPAN_DANGER("You are freezing cold!"))
			if("temp-2")
				to_chat(usr, SPAN_WARNING("You are dangerously chilled"))
			if("temp-1")
				to_chat(usr, SPAN_NOTICE("You are uncomfortably cold."))
			else
				to_chat(usr, SPAN_NOTICE("Your body is at a comfortable temperature."))

/obj/screen/pressure/Click(var/location, var/control, var/params)
	if(istype(usr) && usr.pressure == src)
		switch(icon_state)
			if("pressure2")
				to_chat(usr, SPAN_DANGER("The air pressure here is crushing!"))
			if("pressure1")
				to_chat(usr, SPAN_WARNING("The air pressure here is dangerously high."))
			if("pressure-1")
				to_chat(usr, SPAN_WARNING("The air pressure here is dangerously low."))
			if("pressure-2")
				to_chat(usr, SPAN_DANGER("There is nearly no air pressure here!"))
			else
				to_chat(usr, SPAN_NOTICE("The local air pressure is comfortable."))

/obj/screen/toxins/Click(var/location, var/control, var/params)
	if(istype(usr) && usr.toxin == src)
		if(icon_state == "tox0")
			to_chat(usr, SPAN_NOTICE("The air is clear of toxins."))
		else
			to_chat(usr, SPAN_DANGER("The air is eating away at your skin!"))

/obj/screen/oxygen/Click(var/location, var/control, var/params)
	if(istype(usr) && usr.oxygen == src)
		if(icon_state == "oxy0")
			to_chat(usr, SPAN_NOTICE("You are breathing easy."))
		else
			to_chat(usr, SPAN_DANGER("You cannot breathe!"))

/obj/screen/paralysis/Click(var/location, var/control, var/params)
	if(istype(usr) && usr.paralysis_indicator == src)
		if(usr.paralysis)
			to_chat(usr, SPAN_WARNING("You are completely paralyzed and cannot move!"))
		else
			to_chat(usr, SPAN_NOTICE("You are walking around completely fine."))

/obj/screen/instability
	name = "instability"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "instability-1"
	invisibility = 101

/obj/screen/energy
	name = "energy"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "wiz_energy"
	invisibility = 101

/obj/screen/status
	icon = 'icons/mob/screen/midnight.dmi'
	icon_state = "status_template"
	var/status_message

/obj/screen/status/Initialize(mapload, var/set_icon, var/set_overlay, var/set_status_message)
	icon = set_icon
	var/image/status_overlay = image('icons/mob/screen/hud_status.dmi', null, set_overlay)
	status_overlay.appearance_flags = RESET_COLOR
	add_overlay(status_overlay)
	status_message = set_status_message
	return ..()

/obj/screen/status/Click(var/location, var/control, var/params)
	var/list/modifiers = params2list(params)
	if(status_message && modifiers["shift"])
		to_chat(usr, status_message)

