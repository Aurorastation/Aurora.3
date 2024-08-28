/datum/action
	var/name = "Generic Action"
	var/desc
	var/datum/target
	var/check_flags = NONE
	var/processing = FALSE
	var/buttontooltipstyle = ""
	var/transparent_when_unavailable = TRUE
	/// Where any buttons we create should be by default. Accepts screen_loc and location defines
	var/default_button_position = SCRN_OBJ_IN_LIST

	var/button_icon = 'icons/obj/action_buttons/actions.dmi' //This is the file for the BACKGROUND icon
	var/background_icon_state = ACTION_BUTTON_DEFAULT_BACKGROUND //And this is the state for the background icon

	var/icon_icon = 'icons/obj/action_buttons/actions.dmi' //This is the file for the ACTION icon
	var/button_icon_state = "default" //And this is the state for the action icon
	var/mob/owner
	///List of all mobs that are viewing our action button -> A unique movable for them to view.
	var/list/viewers = list()


/datum/action/New(Target)
	LinkTo(target)

/datum/action/proc/LinkTo(Target)
	target = Target
//	RegisterSignal(Target, COMSIG_ATOM_UPDATED_ICON, .proc/OnUpdatedIcon) //We need COMSIG_ATOM_UPDATED_ICON first
	RegisterSignal(target, COMSIG_QDELETING, .proc/clear_ref, override = TRUE)

/datum/action/Destroy()
	if(owner)
		Remove(owner)
	target = null
	return ..()

/datum/action/proc/Grant(mob/M)
	if(!M)
		Remove(owner)
		return
	if(owner)
		if(owner == M)
			return
		Remove(owner)
	owner = M
	RegisterSignal(owner, COMSIG_QDELETING, .proc/clear_ref, override = TRUE)
	GiveAction(M)

/datum/action/proc/clear_ref(datum/ref)
	SIGNAL_HANDLER
	if(ref == owner)
		Remove(owner)
	if(ref == target)
		qdel(src)

/datum/action/proc/Remove(mob/M)
	LAZYREMOVE(M.actions, src)

	if(owner)
		UnregisterSignal(owner, COMSIG_QDELETING)
		if(target == owner)
			RegisterSignal(target, COMSIG_QDELETING, .proc/clear_ref)
		owner = null

/datum/action/proc/Trigger(trigger_flags)
	if(!IsAvailable())
		return 0
	if(SEND_SIGNAL(src, COMSIG_ACTION_TRIGGER, src) & COMPONENT_ACTION_BLOCK_TRIGGER)
		return FALSE
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

/datum/action/proc/UpdateButtons(status_only, force)
	for(var/datum/hud/hud in viewers)
		var/obj/screen/movable/button = viewers[hud]
		UpdateButton(button, status_only, force)

/datum/action/proc/UpdateButton(obj/screen/movable/action_button/button, status_only = FALSE, force = FALSE)
	if(!button)
		return
	if(!status_only)
		button.name = name
		button.desc = desc
		if(owner?.hud_used && background_icon_state == ACTION_BUTTON_DEFAULT_BACKGROUND)
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

		ApplyIcon(button, force)

	if(!IsAvailable())
		button.color = transparent_when_unavailable ? rgb(128,0,0,128) : rgb(128,0,0)
	else
		button.color = rgb(255,255,255,255)
		return TRUE


/datum/action/proc/ApplyIcon(obj/screen/movable/action_button/current_button, force = FALSE)
	if(icon_icon && button_icon_state && (current_button.button_icon_state != button_icon_state || force))
		current_button.CutOverlays()
		current_button.AddOverlays(mutable_appearance(icon_icon, button_icon_state))
		current_button.button_icon_state = button_icon_state

/datum/action/proc/OnUpdatedIcon()
	SIGNAL_HANDLER
	UpdateButtons()

//Give our action button to the player
/datum/action/proc/GiveAction(mob/viewer)
	var/datum/hud/our_hud = viewer.hud_used
	if(viewers[our_hud]) // Already have a copy of us? go away
		return

	LAZYOR(viewer.actions, src) // Move this in
	ShowTo(viewer)

//Adds our action button to the screen of a player
/datum/action/proc/ShowTo(mob/viewer)
	var/datum/hud/our_hud = viewer.hud_used
	if(!our_hud || viewers[our_hud]) // There's no point in this if you have no hud in the first place
		return

	var/obj/screen/movable/action_button/button = CreateButton()
	SetId(button, viewer)

	button.our_hud = our_hud
	viewers[our_hud] = button
	if(viewer.client)
		viewer.client.screen += button

	button.load_position(viewer)
	viewer.update_action_buttons()

//Removes our action button from the screen of a player
/datum/action/proc/HideFrom(mob/viewer)
	var/datum/hud/our_hud = viewer.hud_used
	var/obj/screen/movable/action_button/button = viewers[our_hud]
	if(button)
		qdel(button)
	LAZYREMOVE(viewer.actions, src)

/datum/action/proc/CreateButton()
	var/obj/screen/movable/action_button/button = new()
	button.linked_action = src
	button.name = name
	button.actiontooltipstyle = buttontooltipstyle
	if(desc)
		button.desc = desc
	return button

/datum/action/proc/SetId(obj/screen/movable/action_button/our_button, mob/owner)
	//button id generation
	var/bitfield = 0
	for(var/datum/action/action in owner.actions)
		if(action == src) // This could be us, which is dumb
			continue
		var/obj/screen/movable/action_button/button = action.viewers[owner.hud_used]
		if(action.name == name && button.id)
			bitfield |= button.id

	bitfield = ~bitfield // Flip our possible ids, so we can check if we've found a unique one
	for(var/i in 0 to 23) // We get 24 possible bitflags in dm
		var/bitflag = 1 << i // Shift us over one
		if(bitfield & bitflag)
			our_button.id = bitflag
			return

//Presets for item actions
/datum/action/item_action
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUNNED|AB_CHECK_LYING|AB_CHECK_CONSCIOUS

/datum/action/item_action/New(Target)
	..()
	var/obj/item/I = target
	LAZYINITLIST(I.actions)
	I.actions += src

/datum/action/item_action/Destroy()
	var/obj/item/I = target
	I.actions -= src
	UNSETEMPTY(I.actions)
	return ..()

/datum/action/item_action/Trigger()
	if(!..())
		return 0
	if(target)
		var/obj/item/I = target
		I.ui_action_click(owner, src.type)
	return 1

/datum/action/item_action/ApplyIcon(obj/screen/movable/action_button/current_button, force)
	var/obj/item/item_target = target
	if(button_icon && button_icon_state)
		// If set, use the custom icon that we set instead
		// of the item appearence
		..()
	if(target && current_button.appearance_cache != target.appearance) //replace with /ref comparison if this is not valid.
		var/old_layer = item_target.layer
		var/old_plane = item_target.plane
		item_target.layer = FLOAT_LAYER //AAAH
		item_target.plane = FLOAT_PLANE //^ what that guy said
		current_button.CutOverlays()
		current_button.AddOverlays(item_target)
		item_target.layer = old_layer
		item_target.plane = old_plane
		current_button.appearance_cache = item_target.appearance

/datum/action/item_action/organ_action
	check_flags = AB_CHECK_CONSCIOUS

/datum/action/item_action/organ_action/IsAvailable()
	var/obj/item/organ/internal/I = target
	if(!I.owner)
		return 0
	return ..()


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
