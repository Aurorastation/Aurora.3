/obj/item/organ/internal/augment/eye_sensors
	name = "integrated HUD sensors"
	icon_state = "augment_eyes"
	cooldown = 25
	activable = TRUE
	activated = TRUE
	organ_tag = BP_AUG_EYE_SENSORS
	parent_organ = BP_HEAD
	action_button_name = "Toggle Sensors"

/obj/item/organ/internal/augment/eye_sensors/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

	activated = !activated

	if (activated)
		to_chat(owner, "You activate \the [src].")
		enable_traits()
	else
		to_chat(owner, "You deactivate \the [src].")
		disable_traits()

/obj/item/organ/internal/augment/eye_sensors/process()
	..()

	if(!owner)
		return

/obj/item/organ/internal/augment/eye_sensors/emp_act(severity)
	. = ..()

	var/obj/item/organ/internal/eyes/E = owner.get_eyes()
	if(!E)
		return

	E.take_damage(5)

/obj/item/organ/internal/augment/eye_sensors/security
	name = "integrated security HUD sensors"
	action_button_name = "Toggle Security Sensors"
	organ_traits = list(TRAIT_SECURITY_HUD)
	req_access = list(ACCESS_SECURITY)

/obj/item/organ/internal/augment/eye_sensors/medical
	name = "integrated medical HUD sensors"
	action_button_name = "Toggle Medical Sensors"
	organ_traits = list(TRAIT_MEDICAL_HUD)
	req_access = list(ACCESS_MEDICAL)
