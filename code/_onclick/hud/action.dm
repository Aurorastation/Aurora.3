#define AB_ITEM 1
#define AB_SPELL 2
#define AB_INNATE 3
#define AB_GENERIC 4
#define AB_ITEM_USE_ICON 5

#define AB_CHECK_RESTRAINED 1
#define AB_CHECK_STUNNED 2
#define AB_CHECK_LYING 4
#define AB_CHECK_ALIVE 8
#define AB_CHECK_INSIDE 16


/datum/action
	var/name = "Generic Action"
	var/action_type = AB_ITEM
	var/procname = null
	var/atom/movable/target = null
	var/check_flags = 0
	var/processing = 0
	var/active = 0
	var/obj/screen/movable/action_button/button = null
	var/button_icon = 'icons/obj/action_buttons/actions.dmi'
	var/button_icon_state = "default"
	var/button_icon_color
	var/background_icon_state = "bg_default"
	var/mob/living/owner

/datum/action/New(var/Target)
	target = Target

/datum/action/Destroy()
	if(owner)
		Remove(owner)
	target = null
	return ..()

/datum/action/proc/SetTarget(var/atom/Target)
	target = Target

/datum/action/proc/Grant(mob/living/T)
	if(owner)
		if(owner == T)
			return
		Remove(owner)
	owner = T
	owner.actions.Add(src)
	owner.update_action_buttons()
	return

/datum/action/proc/Remove(mob/living/T)
	if(button)
		if(T.client)
			T.client.screen -= button
		QDEL_NULL(button)
	T.actions.Remove(src)
	T.update_action_buttons()
	owner = null
	return

/datum/action/proc/Trigger()
	if(!Checks())
		return
	switch(action_type)
		if(AB_ITEM, AB_ITEM_USE_ICON)
			if(target)
				var/obj/item/item = target
				item.ui_action_click()
		//if(AB_SPELL)
		//	if(target)
		//		var/obj/effect/proc_holder/spell = target
		//		spell.Click()
		if(AB_INNATE)
			if(!active)
				Activate()
			else
				Deactivate()
		if(AB_GENERIC)
			if(target && procname)
				call(target,procname)(usr)
	return

/datum/action/proc/Activate()
	return

/datum/action/proc/Deactivate()
	return

/datum/action/proc/Process()
	return

/datum/action/proc/CheckRemoval(mob/living/user) // 1 if action is no longer valid for this mob and should be removed
	return 0

/datum/action/proc/IsAvailable()
	return Checks()

/datum/action/proc/Checks()// returns 1 if all checks pass
	if(!owner)
		return 0
	if(check_flags & AB_CHECK_RESTRAINED)
		if(owner.restrained())
			return 0
	if(check_flags & AB_CHECK_STUNNED)
		if(owner.stunned)
			return 0
	if(check_flags & AB_CHECK_LYING)
		if(owner.lying)
			return 0
	if(check_flags & AB_CHECK_ALIVE)
		if(owner.stat)
			return 0
	if(check_flags & AB_CHECK_INSIDE)
		if(!(target in owner))
			return 0
	return 1

/datum/action/proc/UpdateName()
	return name

/obj/screen/movable/action_button
	var/datum/action/owner
	screen_loc = "WEST,NORTH"

/obj/screen/movable/action_button/Destroy(force)
	owner = null
	. = ..()

/obj/screen/movable/action_button/Click(location,control,params)
	var/list/modifiers = params2list(params)
	if(modifiers["shift"])
		moved = 0
		return 1
	if(usr.next_move >= world.time) // Is this needed ?
		return
	owner.Trigger()
	return 1

/obj/screen/movable/action_button/update_icon()
	if(!owner)
		return
	icon = owner.button_icon
	icon_state = owner.background_icon_state

	cut_overlays()
	var/image/img
	if(owner.action_type == AB_ITEM && owner.target)
		var/obj/item/I = owner.target
		img = image(I.icon, src , I.icon_state)
	else if(owner.button_icon && owner.button_icon_state)
		img = image(owner.button_icon,src,owner.button_icon_state)
	img.pixel_x = 0
	img.pixel_y = 0
	if(owner.button_icon_color)
		img.color = owner.button_icon_color
	add_overlay(img)

	if(!owner.IsAvailable())
		color = rgb(128,0,0,128)
	else
		color = rgb(255,255,255,255)

//Hide/Show Action Buttons ... Button
/obj/screen/movable/action_button/hide_toggle
	name = "Hide Buttons"
	icon = 'icons/obj/action_buttons/actions.dmi'
	icon_state = "bg_default"
	var/hidden = 0

/obj/screen/movable/action_button/hide_toggle/Click()
	usr.hud_used.action_buttons_hidden = !usr.hud_used.action_buttons_hidden

	hidden = usr.hud_used.action_buttons_hidden
	if(hidden)
		name = "Show Buttons"
	else
		name = "Hide Buttons"
	update_icon()
	usr.update_action_buttons()


/obj/screen/movable/action_button/hide_toggle/proc/InitialiseIcon(var/mob/living/user)
	if(isalien(user))
		icon_state = "bg_alien"
	else
		icon_state = "bg_default"
	update_icon()
	return

/obj/screen/movable/action_button/hide_toggle/update_icon()
	cut_overlays()
	add_overlay(hidden ? "show" : "hide")

//This is the proc used to update all the action buttons. Properly defined in /mob/living/
/mob/proc/update_action_buttons()
	return

#define AB_WEST_OFFSET 4
#define AB_NORTH_OFFSET 26
#define AB_MAX_COLUMNS 10

/datum/hud/proc/ButtonNumberToScreenCoords(var/number) // TODO : Make this zero-indexed for readabilty
	var/row = round((number-1)/AB_MAX_COLUMNS)
	var/col = ((number - 1)%(AB_MAX_COLUMNS)) + 1
	var/coord_col = "+[col-1]"
	var/coord_col_offset = AB_WEST_OFFSET+2*col
	var/coord_row = "[-1 - row]"
	var/coord_row_offset = AB_NORTH_OFFSET
	return "WEST[coord_col]:[coord_col_offset],NORTH[coord_row]:[coord_row_offset]"

/datum/hud/proc/SetButtonCoords(var/obj/screen/button,var/number)
	var/row = round((number-1)/AB_MAX_COLUMNS)
	var/col = ((number - 1)%(AB_MAX_COLUMNS)) + 1
	var/x_offset = 32*(col-1) + AB_WEST_OFFSET + 2*col
	var/y_offset = -32*(row+1) + AB_NORTH_OFFSET

	var/matrix/M = matrix()
	M.Translate(x_offset,y_offset)
	button.transform = M

//Presets for item actions
/datum/action/item_action
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUNNED|AB_CHECK_LYING|AB_CHECK_ALIVE|AB_CHECK_INSIDE

/datum/action/item_action/CheckRemoval(mob/living/user)
	return !(target in user)

/datum/action/item_action/hands_free
	check_flags = AB_CHECK_ALIVE|AB_CHECK_INSIDE

/datum/action/item_action/hands_free/activate
	name = "Activate"

/datum/action/item_action/hands_free/activate/implant
	action_type = AB_ITEM_USE_ICON
	button_icon = 'icons/obj/action_buttons/implants.dmi'
	button_icon_state = "default"

/datum/action/item_action/hands_free/activate/implant/adrenaline
	button_icon_state = "adrenal"

/datum/action/item_action/hands_free/activate/implant/chemical
	button_icon_state = "reagents"

/datum/action/item_action/hands_free/activate/implant/compressed
	button_icon_state = "storage"

/datum/action/item_action/hands_free/activate/implant/emp
	button_icon_state = "emp"

/datum/action/item_action/hands_free/activate/implant/explosive
	button_icon_state = "explosive"

/datum/action/item_action/hands_free/activate/implant/freedom
	button_icon_state = "freedom"

/datum/action/item_action/organ
	action_type = AB_ITEM_USE_ICON
	button_icon = 'icons/obj/action_buttons/organs.dmi'

/datum/action/item_action/organ/SetTarget(var/atom/Target)
	. = ..()
	var/obj/item/organ/O = target
	if(istype(O))
		O.refresh_action_button()

/datum/action/item_action/organ/night_eyes
	check_flags = AB_CHECK_STUNNED|AB_CHECK_ALIVE|AB_CHECK_INSIDE
	button_icon_state = "night_eyes"

/datum/action/item_action/organ/night_eyes/rev
	check_flags = AB_CHECK_ALIVE|AB_CHECK_INSIDE
	button_icon_state = "rev_eyes"

/datum/action/item_action/integrated_circuit
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUNNED|AB_CHECK_ALIVE|AB_CHECK_INSIDE

/datum/action/item_action/integrated_circuit/Trigger()
	if(!Checks())
		return
	var/obj/item/clothing/target_clothing = target
	to_chat(usr, SPAN_NOTICE("You press the button on the exterior of \the [target_clothing]."))
	target_clothing.action_circuit.activate_pin(1)

#undef AB_WEST_OFFSET
#undef AB_NORTH_OFFSET
#undef AB_MAX_COLUMNS

#undef AB_ITEM
#undef AB_SPELL
#undef AB_INNATE
#undef AB_GENERIC
#undef AB_ITEM_USE_ICON

#undef AB_CHECK_RESTRAINED
#undef AB_CHECK_STUNNED
#undef AB_CHECK_LYING
#undef AB_CHECK_ALIVE
#undef AB_CHECK_INSIDE
