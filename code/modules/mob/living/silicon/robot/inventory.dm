//These procs handle putting s tuff in your hand. It's probably best to use these rather than setting stuff manually
//as they handle all relevant stuff like adding it to the player's screen and such

//Returns the thing in our active hand (whatever is in our active module-slot, in this case)
/mob/living/silicon/robot/get_active_hand()
	return module_active

/mob/living/silicon/robot/proc/return_wirecutter()
	for(var/obj/I in list(module_state_1, module_state_2, module_state_3))
		if(I.iswirecutter())
			return I
	return

/mob/living/silicon/robot/proc/return_multitool()
	for(var/obj/I in list(module_state_1, module_state_2, module_state_3))
		if(I.ismultitool())
			return I
	return

/*-------TODOOOOOOOOOO--------*/

//Verbs used by hotkeys.
/mob/living/silicon/robot/verb/cmd_unequip_module()
	set name = "unequip-module"
	set hidden = 1
	drop_item()

/mob/living/silicon/robot/verb/cmd_toggle_module(module as num)
	set name = "toggle-module"
	set hidden = 1
	toggle_module(module)

/mob/living/silicon/robot/proc/uneq_active()
	if(isnull(module_active))
		return

	if(module_state_1 == module_active)
		store_module(module_state_1)
		set_module_active(null)
		module_state_1 = null
		inv1.icon_state = "inv1"
	else if(module_state_2 == module_active)
		store_module(module_state_2)
		set_module_active(null)
		module_state_2 = null
		inv2.icon_state = "inv2"
	else if(module_state_3 == module_active)
		store_module(module_state_3)
		set_module_active(null)
		module_state_3 = null
		inv3.icon_state = "inv3"

	hud_used.update_robot_modules_display()

/mob/living/silicon/robot/proc/uneq_all()
	set_module_active(null)

	if(module_state_1)
		store_module(module_state_1)
		module_state_1 = null
		inv1.icon_state = "inv1"
	if(module_state_2)
		store_module(module_state_2)
		module_state_2 = null
		inv2.icon_state = "inv2"
	if(module_state_3)
		store_module(module_state_3)
		module_state_3 = null
		inv3.icon_state = "inv3"
	update_icon()
	if(hud_used)
		hud_used.update_robot_modules_display()

/mob/living/silicon/robot/proc/activated(obj/item/O)
	update_icon()

	if(module_state_1 == O)
		return 1
	else if(module_state_2 == O)
		return 1
	else if(module_state_3 == O)
		return 1
	else
		return 0

//Helper procs for cyborg modules on the UI.
//These are hackish but they help clean up code elsewhere.

//module_selected(module) - Checks whether the module slot specified by "module" is currently selected.
/mob/living/silicon/robot/proc/module_selected(var/module) //Module is 1-3
	return module == get_selected_module()

//module_active(module) - Checks whether there is a module active in the slot specified by "module".
/mob/living/silicon/robot/proc/module_active(var/module) //Module is 1-3
	if(module < 1 || module > 3) return 0

	switch(module)
		if(1)
			if(module_state_1)
				return 1
		if(2)
			if(module_state_2)
				return 1
		if(3)
			if(module_state_3)
				return 1
	return 0

//get_selected_module() - Returns the slot number of the currently selected module.  Returns 0 if no modules are selected.
/mob/living/silicon/robot/proc/get_selected_module()
	if(module_state_1 && module_active == module_state_1)
		return 1
	else if(module_state_2 && module_active == module_state_2)
		return 2
	else if(module_state_3 && module_active == module_state_3)
		return 3

	return 0

//select_module(module) - Selects the module slot specified by "module"
/mob/living/silicon/robot/proc/select_module(var/module) //Module is 1-3
	if(module < 1 || module > 3) return

	if(!module_active(module)) return

	switch(module)
		if(1)
			if(module_active != module_state_1)
				inv1.icon_state = "inv1 +a"
				inv2.icon_state = "inv2"
				inv3.icon_state = "inv3"
				set_module_active(module_state_1)
				return
		if(2)
			if(module_active != module_state_2)
				inv1.icon_state = "inv1"
				inv2.icon_state = "inv2 +a"
				inv3.icon_state = "inv3"
				set_module_active(module_state_2)
				return
		if(3)
			if(module_active != module_state_3)
				inv1.icon_state = "inv1"
				inv2.icon_state = "inv2"
				inv3.icon_state = "inv3 +a"
				set_module_active(module_state_3)
				return
	return

//deselect_module(module) - Deselects the module slot specified by "module"
/mob/living/silicon/robot/proc/deselect_module(var/module) //Module is 1-3
	if(module < 1 || module > 3) return

	switch(module)
		if(1)
			if(module_active == module_state_1)
				inv1.icon_state = "inv1"
				set_module_active(null)
				return
		if(2)
			if(module_active == module_state_2)
				inv2.icon_state = "inv2"
				set_module_active(null)
				return
		if(3)
			if(module_active == module_state_3)
				inv3.icon_state = "inv3"
				set_module_active(null)
				return
	return

//toggle_module(module) - Toggles the selection of the module slot specified by "module".
/mob/living/silicon/robot/proc/toggle_module(var/module) //Module is 1-3
	if(module < 1 || module > 3) return

	if(module_selected(module))
		deselect_module(module)
	else
		if(module_active(module))
			select_module(module)
		else
			deselect_module(get_selected_module()) //If we can't do select anything, at least deselect the current module.
	return

//cycle_modules() - Cycles through the list of selected modules.
/mob/living/silicon/robot/proc/cycle_modules()
	var/slot_start = get_selected_module()
	if(slot_start) deselect_module(slot_start) //Only deselect if we have a selected slot.

	var/slot_num
	if(slot_start == 0)
		slot_num = 1
		slot_start = 2
	else
		slot_num = slot_start + 1

	while(slot_start != slot_num) //If we wrap around without finding any free slots, just give up.
		if(module_active(slot_num))
			select_module(slot_num)
			return
		slot_num++
		if(slot_num > 3) slot_num = 1 //Wrap around.

	return

/mob/living/silicon/robot/proc/activate_module(var/obj/item/O)
	if(!(locate(O) in src.module.modules) && O != src.module.emag)
		return
	if(activated(O))
		to_chat(src, "<span class='notice'>Already activated</span>")
		return
	if(!module_state_1)
		module_state_1 = O
		O.hud_layerise()
		O.screen_loc = inv1.screen_loc
		contents += O
		O.on_module_hotbar(src)
	else if(!module_state_2)
		module_state_2 = O
		O.hud_layerise()
		O.screen_loc = inv2.screen_loc
		contents += O
		O.on_module_hotbar(src)
	else if(!module_state_3)
		module_state_3 = O
		O.hud_layerise()
		O.screen_loc = inv3.screen_loc
		contents += O
		O.on_module_hotbar(src)
	else
		to_chat(src, "<span class='notice'>You need to disable a module first!</span>")

/mob/living/silicon/robot/put_in_hands(var/obj/item/W) // Maybe hands.
	var/obj/item/gripper/G = get_active_hand()
	if (istype(G))
		if(!G.wrapped && G.grip_item(W, src, TRUE))
			return TRUE
	if (istype(module_state_1, /obj/item/gripper))
		G = module_state_1
		if (!G.wrapped && G.grip_item(W, src, TRUE))
			return TRUE
	else if (istype(module_state_2, /obj/item/gripper))
		G = module_state_2
		if (!G.wrapped && G.grip_item(W, src, TRUE))
			return TRUE
	else if (istype(module_state_3, /obj/item/gripper))
		G = module_state_3
		if (!G.wrapped && G.grip_item(W, src, TRUE))
			return TRUE

	W.forceMove(get_turf(src))
	return FALSE

/mob/living/silicon/robot/remove_from_mob(var/obj/O) //Necessary to clear gripper when trying to place items in things (grinders, smartfridges, vendors, etc)
	if(istype(module_active, /obj/item/gripper))
		var/obj/item/gripper/G = module_active
		if(G.wrapped == O)
			G.drop(get_turf(src), src, FALSE) //We don't need to see the "released X item" message if we're putting stuff in fridges and the like.

/mob/living/silicon/robot/drop_item()
	if(istype(module_active, /obj/item/gripper))
		var/obj/item/gripper/G = module_active
		if(G.wrapped)
			G.drop_item()
			return
	uneq_active()

/mob/living/silicon/robot/drop_from_inventory(var/obj/item/W, var/atom/target = null)
	var/do_feedback = target ? FALSE : TRUE //Do not do feedback messages if dropping to a target, to avoid duplicate "You release X" messages.
	if(W)
		if(!target)
			target = loc
		if (istype(W.loc, /obj/item/gripper))
			var/obj/item/gripper/G = W.loc
			G.drop(target, src, do_feedback)
			return TRUE
	return FALSE

/mob/living/silicon/robot/canUnEquip(obj/item/I)
	if(!I) //If there's nothing to drop, the drop is automatically successful.
		return TRUE
	if (I.loc != src)
		return TRUE //Allows objects inside grippers
	return FALSE //don't allow dropping our modules

/mob/living/silicon/robot/proc/describe_module(var/slot)
	var/list/index_module = list(module_state_1,module_state_2,module_state_3)
	var/result = "   Hardpoint [slot] holds "
	result += (index_module[slot]) ? "[icon2html(index_module[slot], viewers(get_turf(src)))] [index_module[slot]]." : "nothing."
	return result

/mob/living/silicon/robot/proc/describe_all_modules()
	var/result="It has three tool hardpoints."
	for (var/x = 1; x <=3; x++)
		result += describe_module(x)
	var/selected = get_selected_module()
	if (selected)
		result += "The activity light on hardpoint [selected] is on."
	return result
