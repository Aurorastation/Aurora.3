#define AB_CHECK_RESTRAINED 1
#define AB_CHECK_STUNNED 2
#define AB_CHECK_LYING 4
#define AB_CHECK_CONSCIOUS 8


/datum/action
	var/name = "Generic Action"
	var/obj/target = null
	var/check_flags = 0
	var/processing = 0
	var/obj/screen/movable/action_button/button = null
	var/button_icon = 'icons/obj/action_buttons/actions.dmi'
	var/button_icon_state = "default"
	var/background_icon_state = "bg_default"
	var/mob/living/owner

/datum/action/New(Target)
	target = Target
	button = new
	button.linked_action = src
	button.name = name

/datum/action/Destroy()
	if(owner)
		Remove(owner)
	target = null
	qdel(button)
	button = null
	return ..()

/datum/action/proc/Grant(mob/living/L)
	if(owner)
		if(owner == L)
			return
		Remove(owner)
	owner = L
	L.actions += src
	if(L.client)
		L.client.screen += button
	L.update_action_buttons()

/datum/action/proc/Remove(mob/living/L)
	if(L.client)
		L.client.screen -= button
	button.moved = FALSE //so the button appears in its normal position when given to another owner.
	L.actions -= src
	L.update_action_buttons()
	owner = null

/datum/action/proc/Trigger()
	if(!IsAvailable())
		return 0
	return 1

/datum/action/proc/Process()
	return

/datum/action/proc/IsAvailable()
	if(!owner)
		return 0
	if(check_flags & AB_CHECK_RESTRAINED)
		if(owner.restrained())
			return 0
	if(check_flags & AB_CHECK_STUNNED)
		if(owner.stunned || owner.weakened)
			return 0
	if(check_flags & AB_CHECK_LYING)
		if(owner.lying)
			return 0
	if(check_flags & AB_CHECK_CONSCIOUS)
		if(owner.stat)
			return 0
	return 1

/datum/action/proc/UpdateButtonIcon()
	if(button)
		button.icon = button_icon
		button.icon_state = background_icon_state

		ApplyIcon(button)

		if(!IsAvailable())
			button.color = rgb(128,0,0,128)
		else
			button.color = rgb(255,255,255,255)
			return 1

/datum/action/proc/ApplyIcon(obj/screen/movable/action_button/current_button)
	current_button.overlays.Cut()
	if(button_icon && button_icon_state)
		var/image/img
		img = image(button_icon, current_button, button_icon_state)
		img.pixel_x = 0
		img.pixel_y = 0
		current_button.overlays += img



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
	current_button.overlays.Cut()
	if(target)
		var/obj/item/I = target
		var/old = I.layer
		I.layer = FLOAT_LAYER //AAAH
		current_button.overlays += I
		I.layer = old

/datum/action/item_action/organ_action
	check_flags = AB_CHECK_CONSCIOUS

/datum/action/item_action/organ_action/New(Target)
	..()
	name = "Toggle [target.name]"
	button.name = name

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
