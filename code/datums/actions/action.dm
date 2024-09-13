/datum/action
	var/name = "Generic Action"
	var/desc = null
	var/obj/target = null
	var/check_flags = 0
	var/processing = 0
	var/obj/screen/movable/action_button/button = null
	var/button_icon = 'icons/obj/action_buttons/actions.dmi'
	var/background_icon_state = ACTION_BUTTON_DEFAULT_BACKGROUND

	var/icon_icon = 'icons/obj/action_buttons/actions.dmi'
	var/button_icon_state = "default"
	var/mob/owner

/datum/action/New(Target)
	target = Target
	button = new
	button.linked_action = src
	button.name = name
	if(desc)
		button.desc = desc

/datum/action/Destroy()
	if(owner)
		Remove(owner)
	target = null
	qdel(button)
	button = null
	return ..()

/datum/action/proc/Grant(mob/M)
	if(owner)
		if(owner == M)
			return
		Remove(owner)
	owner = M

	//button id generation
	var/counter = 0
	var/bitfield = 0
	for(var/datum/action/A in M.actions)
		if(A.name == name && A.button.id)
			counter += 1
			bitfield |= A.button.id
	bitfield = ~bitfield
	var/bitflag = 1
	for(var/i in 1 to (counter + 1))
		if(bitfield & bitflag)
			button.id = bitflag
			break
		bitflag *= 2

	M.actions += src
	if(M.client)
		M.client.screen += button
		button.locked = M.client.prefs.buttons_locked || button.id ? M.client.prefs.action_buttons_screen_locs["[name]_[button.id]"] : FALSE //even if it's not defaultly locked we should remember we locked it before
		button.moved = button.id ? M.client.prefs.action_buttons_screen_locs["[name]_[button.id]"] : FALSE
	M.update_action_buttons()

/datum/action/proc/Remove(mob/M)
	if(M.client)
		M.client.screen -= button
	button.moved = FALSE //so the button appears in its normal position when given to another owner.
	button.locked = FALSE
	M.actions -= src
	M.update_action_buttons()
	owner = null
	button.id = null

/datum/action/proc/Trigger()
	if(!IsAvailable())
		return 0
	return 1

/datum/action/proc/Process()
	return

/datum/action/proc/IsAvailable()
	if(!owner)
		return FALSE
	if(check_flags & AB_CHECK_RESTRAINED)
		if(owner.restrained())
			return FALSE
	if(check_flags & AB_CHECK_STUNNED)
		if(owner.stunned || owner.weakened)
			return FALSE
	if(check_flags & AB_CHECK_LYING)
		if(owner.lying)
			return FALSE
	if(check_flags & AB_CHECK_CONSCIOUS)
		if(owner.stat)
			return FALSE
	return TRUE

/datum/action/proc/UpdateButtonIcon(status_only = FALSE)
	if(button)
		if(!status_only)
			button.name = name
			button.desc = desc
			if(owner && owner.hud_used && background_icon_state == ACTION_BUTTON_DEFAULT_BACKGROUND)
				var/list/settings = owner.hud_used.get_action_buttons_icons()
				if(button.icon != settings["bg_icon"])
					button.icon = settings["bg_icon"]
				if(button.icon_state != settings["bg_state"])
					button.icon_state = settings["bg_state"]
			else
				if(button.icon != button_icon)
					button.icon = button_icon
				if(button.icon_state != background_icon_state)
					button.icon_state = background_icon_state

			ApplyIcon(button)

		if(!IsAvailable())
			button.color = rgb(128,0,0,128)
		else
			button.color = rgb(255,255,255,255)
			return 1

/datum/action/proc/ApplyIcon(obj/screen/movable/action_button/current_button)
	if(icon_icon && button_icon_state && current_button.button_icon_state != button_icon_state)
		current_button.CutOverlays(cache_target = ATOM_ICON_CACHE_ALL)
		current_button.AddOverlays(mutable_appearance(icon_icon, button_icon_state))
		current_button.button_icon_state = button_icon_state



//Presets for item actions
/datum/action/item_action
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUNNED|AB_CHECK_LYING|AB_CHECK_CONSCIOUS

/datum/action/item_action/New(Target)
	..()
	var/obj/item/I = target
	I.actions += src

/datum/action/item_action/Destroy()
	var/obj/item/I = target
	I.actions -= src
	return ..()

/datum/action/item_action/Trigger()
	if(!..())
		return 0
	if(target)
		var/obj/item/I = target
		I.ui_action_click(owner, src.type)
	return 1

/datum/action/item_action/ApplyIcon(obj/screen/movable/action_button/current_button)
	var/obj/item/item_target = target
	if(button_icon && button_icon_state)
		// If set, use the custom icon that we set instead
		// of the item appearence
		..()
	if(target && current_button.appearance_cache != item_target.appearance) //replace with /ref comparison if this is not valid.
		var/old_layer = item_target.layer
		var/old_plane = item_target.plane
		item_target.layer = FLOAT_LAYER //AAAH
		item_target.plane = FLOAT_PLANE //^ what that guy said
		current_button.CutOverlays()
		current_button.AddOverlays(item_target)
		item_target.layer = old_layer
		item_target.plane = old_plane
		current_button.appearance_cache = item_target.appearance


//Preset for general and toggled actions
/datum/action/innate
	check_flags = 0
	var/active = 0

/datum/action/innate/Trigger()
	if(!..())
		return 0
	if(!active)
		Activate()
	else
		Deactivate()
	return 1

/datum/action/innate/proc/Activate()
	return

/datum/action/innate/proc/Deactivate()
	return



//Preset for action that call specific procs (consider innate).
/datum/action/generic
	check_flags = 0
	var/procname

/datum/action/generic/Trigger()
	if(!..())
		return 0
	if(target && procname)
		call(target, procname)(usr)
	return 1

///Eye action targets the parent datum.
#define PARENT_TARGET		0
///Eye action targets the eye mob itself.
#define EYE_TARGET			1
///Eye action targets the eye component.
#define COMPONENT_TARGET	2

/datum/action/generic/eye
	check_flags = AB_CHECK_LYING|AB_CHECK_STUNNED
	///The type of /mob/abstract/eye used by the action.
	var/eye_type = /mob/abstract/eye
	///The relevant owner of the proc to be called by the eye action.
	var/target_type = PARENT_TARGET

/datum/action/generic/eye/New(var/datum/component/eye/eye_component)
	if(!istype(eye_component))
		crash_with("Attempted to generate eye action [src], but no eye component was provided!")
	switch(target_type)
		if(PARENT_TARGET)
			return ..(eye_component.parent)
		if(EYE_TARGET)
			return ..(eye_component.component_eye)
		if(COMPONENT_TARGET)
			return ..(eye_component)
		else
			crash_with("Attempted to generate eye action [src] but an improper target_type ([target_type]) was defined.")
