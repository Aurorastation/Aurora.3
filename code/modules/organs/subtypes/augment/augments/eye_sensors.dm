/obj/item/organ/internal/augment/eye_sensors
	name = "integrated HUD sensors"
	icon_state = "augment_eyes"
	cooldown = 25
	activable = TRUE
	organ_tag = BP_AUG_EYE_SENSORS
	parent_organ = BP_HEAD
	action_button_name = "Toggle Security Sensors"
	var/active_hud = "disabled"

	var/static/list/hud_types = list(
		"disabled",
		SEC_HUDTYPE,
		MED_HUDTYPE)

	var/selected_hud = "disabled"

/obj/item/organ/internal/augment/eye_sensors/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

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

/obj/item/organ/internal/augment/eye_sensors/proc/check_hud(var/hud)
	return (hud == active_hud)

/obj/item/organ/internal/augment/eye_sensors/security
	name = "integrated security HUD sensors"
	action_button_name = "Toggle Security Sensors"

/obj/item/organ/internal/augment/eye_sensors/security/attack_self(var/mob/user)
	. = ..()

	if(selected_hud == "disabled")
		selected_hud = SEC_HUDTYPE
		to_chat(user, "You activate \the [src].")
	else
		selected_hud = "disabled"
		to_chat(user, "You deactivate \the [src].")

/obj/item/organ/internal/augment/eye_sensors/security/process()
	..()

	switch(selected_hud)

		if(SEC_HUDTYPE)
			req_access = list(ACCESS_SECURITY)
			if(allowed(owner))
				active_hud = "security"
				process_sec_hud(owner, 1)
			else
				active_hud = "disabled"
		else
			active_hud = "disabled"
/obj/item/organ/internal/augment/eye_sensors/medical
	name = "integrated medical HUD sensors"
	action_button_name = "Toggle Medical Sensors"

/obj/item/organ/internal/augment/eye_sensors/medical/attack_self(var/mob/user)
	. = ..()

	if(selected_hud == "disabled")
		selected_hud = MED_HUDTYPE
		to_chat(user, "You activate \the [src].")
	else
		selected_hud = "disabled"
		to_chat(user, "You deactivate \the [src].")

/obj/item/organ/internal/augment/eye_sensors/medical/process()
	..()

	switch(selected_hud)

		if(MED_HUDTYPE)
			req_access = list(ACCESS_MEDICAL)
			if(allowed(owner))
				active_hud = "medical"
				process_med_hud(owner, 1)
			else
				active_hud = "disabled"
		else
			active_hud = "disabled"
