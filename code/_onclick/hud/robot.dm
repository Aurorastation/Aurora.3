var/obj/screen/robot_inventory

/mob/living/silicon/robot/instantiate_hud(var/datum/hud/HUD)
	HUD.robot_hud()

/datum/hud/proc/robot_hud()

	src.adding = list()
	src.other = list()

	var/obj/screen/using

	if(!isrobot(mymob))
		return

	var/mob/living/silicon/robot/r = mymob

//Radio
	using = new /obj/screen()
	using.name = "radio"
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen/robot.dmi'
	using.icon_state = "radio"
	using.screen_loc = ui_movi
	using.layer = SCREEN_LAYER
	src.adding += using

//Module select

	using = new /obj/screen/module/one()
	src.adding += using
	r.inv1 = using

	using = new /obj/screen/module/two()
	src.adding += using
	r.inv2 = using

	using = new /obj/screen/module/three()
	src.adding += using
	r.inv3 = using

//End of module select

//Intent
	using = new /obj/screen()
	using.name = "act_intent"
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen/robot.dmi'
	using.icon_state = mymob.a_intent
	using.screen_loc = ui_acti
	using.layer = SCREEN_LAYER
	src.adding += using
	action_intent = using

// Up Hint
	mymob.up_hint = new /obj/screen()
	mymob.up_hint.icon = 'icons/mob/screen/robot.dmi'
	mymob.up_hint.icon_state = "uphint0"
	mymob.up_hint.name = "up hint"
	mymob.up_hint.screen_loc = ui_up_hint

//Cell
	r.cells = new /obj/screen()
	r.cells.icon = 'icons/mob/screen/robot.dmi'
	r.cells.icon_state = "charge-empty"
	r.cells.name = "cell"
	r.cells.screen_loc = ui_toxin

//Health
	mymob.healths = new /obj/screen()
	mymob.healths.icon = 'icons/mob/screen/robot.dmi'
	mymob.healths.icon_state = "health0"
	mymob.healths.name = "health"
	mymob.healths.screen_loc = ui_borg_health

//Installed Module
	mymob.hands = new /obj/screen()
	mymob.hands.icon = 'icons/mob/screen/robot.dmi'
	mymob.hands.icon_state = "nomod"
	mymob.hands.name = "module"
	mymob.hands.screen_loc = ui_borg_module

	if(r.module)
		mymob.hands.icon_state = lowertext(r.mod_type)

	if (istype(mymob, /mob/living/silicon/robot/shell))
		mymob.hands.icon = 'icons/mob/screen/ai.dmi'
		mymob.hands.icon_state = "remote_mech"
		mymob.hands.name = "Return-to-core"

//Module Panel
	using = new /obj/screen()
	using.name = "panel"
	using.icon = 'icons/mob/screen/robot.dmi'
	using.icon_state = "panel"
	using.screen_loc = ui_borg_panel
	using.layer = SCREEN_LAYER
	src.adding += using

//Store
	mymob.throw_icon = new /obj/screen()
	mymob.throw_icon.icon = 'icons/mob/screen/robot.dmi'
	mymob.throw_icon.icon_state = "store"
	mymob.throw_icon.name = "store"
	mymob.throw_icon.screen_loc = ui_borg_store

//Inventory
	robot_inventory = new /obj/screen()
	robot_inventory.name = "inventory"
	robot_inventory.icon = 'icons/mob/screen/robot.dmi'
	robot_inventory.icon_state = "inventory"
	robot_inventory.screen_loc = ui_borg_inventory

//Temp

	mymob.pullin = new /obj/screen()
	mymob.pullin.icon = 'icons/mob/screen/robot.dmi'
	mymob.pullin.icon_state = "pull0"
	mymob.pullin.name = "pull"
	mymob.pullin.screen_loc = ui_borg_pull

	mymob.zone_sel = new /obj/screen/zone_sel()
	mymob.zone_sel.icon = 'icons/mob/screen/robot.dmi'
	mymob.zone_sel.cut_overlays()
	mymob.zone_sel.add_overlay(image('icons/mob/zone_sel.dmi', "[mymob.zone_sel.selecting]"))

	// Computer device hud
	if(r.computer)
		r.computer.screen_loc = ui_oxygen
		r.computer.layer = SCREEN_LAYER


	//Handle the gun settings buttons
	mymob.gun_setting_icon = new /obj/screen/gun/mode(null)
	mymob.item_use_icon = new /obj/screen/gun/item(null)
	mymob.gun_move_icon = new /obj/screen/gun/move(null)
	mymob.radio_use_icon = new /obj/screen/gun/radio(null)
	mymob.toggle_firing_mode = new /obj/screen/gun/burstfire(null)
	mymob.unique_action_icon = new /obj/screen/gun/uniqueaction(null)

	mymob.client.screen = null

	mymob.client.screen += list(
		mymob.throw_icon,
		mymob.zone_sel,
		mymob.hands,
		mymob.healths,
		r.cells,
		mymob.up_hint,
		mymob.pullin,
		robot_inventory,
		mymob.gun_setting_icon,
		mymob.toggle_firing_mode,
		mymob.unique_action_icon,
		r.computer
		)
	mymob.client.screen += src.adding + src.other

	return


/datum/hud/proc/toggle_show_robot_modules()
	if(!isrobot(mymob))
		return

	var/mob/living/silicon/robot/r = mymob

	r.shown_robot_modules = !r.shown_robot_modules
	update_robot_modules_display()


/datum/hud/proc/update_robot_modules_display()
	if(!isrobot(mymob))
		return

	var/mob/living/silicon/robot/r = mymob

	if(!r.client || !r)
		return

	if(r.shown_robot_modules)
		//Modules display is shown
		//r.client.screen += robot_inventory	//"store" icon

		if(!r.module)
			to_chat(usr, "<span class='danger'>No module selected</span>")
			return

		if(!r.module.modules)
			to_chat(usr, "<span class='danger'>Selected module has no modules to select</span>")
			return

		if(!r.robot_modules_background)
			return

		var/display_rows = -round(-(r.module.modules.len) / 8)
		r.robot_modules_background.screen_loc = "CENTER-4:16,SOUTH+1:7 to CENTER+3:16,SOUTH+[display_rows]:7"
		r.client.screen += r.robot_modules_background

		var/x = -4	//Start at CENTER-4,SOUTH+1
		var/y = 1

		//Unfortunately adding the emag module to the list of modules has to be here. This is because a borg can
		//be emagged before they actually select a module. - or some situation can cause them to get a new module
		// - or some situation might cause them to get de-emagged or something.
		if(r.emagged)
			if(!(r.module.emag in r.module.modules))
				r.module.modules += r.module.emag
		else
			if(r.module.emag in r.module.modules)
				r.module.modules -= r.module.emag

		if(r.malf_AI_module)
			if(!((r.module.malf_AI_module in r.module.modules) || r.module.malf_AI_module == null))
				r.module.modules += r.module.malf_AI_module
		else
			if(r.module.malf_AI_module in r.module.modules)
				r.module.modules -= r.module.malf_AI_module

		for(var/atom/movable/A in r.module.modules)
			if( (A != r.module_state_1) && (A != r.module_state_2) && (A != r.module_state_3) )
				//Module is not currently active
				r.client.screen += A
				if(x < 0)
					A.screen_loc = "CENTER[x]:16,SOUTH+[y]:7"
				else
					A.screen_loc = "CENTER+[x]:16,SOUTH+[y]:7"
				A.layer = SCREEN_LAYER

				x++
				if(x == 4)
					x = -4
					y++

	else
		//Modules display is hidden
		//r.client.screen -= robot_inventory	//"store" icon
		for(var/atom/A in r.module.modules)
			if( (A != r.module_state_1) && (A != r.module_state_2) && (A != r.module_state_3) )
				//Module is not currently active
				r.client.screen -= A
		r.shown_robot_modules = 0
		r.client.screen -= r.robot_modules_background
