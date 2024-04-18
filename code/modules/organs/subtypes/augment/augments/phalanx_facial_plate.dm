/obj/item/organ/internal/augment/eye_sensors/phalanx
	name = "phalanx facial plate"
	desc = "This modular face plate accommodates a wide array of cybernetic augmentations, " \
		+ "enabling seamless integration with Phalanx's transhumanist doctrine. " \
		+ " Enhanced sensory overlays and HUDs offer Phalanx members superior situational " \
		+ "awareness and promote a sense of hive-thinking."
	icon_state = "vaurca_plate"
	action_button_name = "Toggle HUD"
	action_button_icon = "vaurca_plate"
	on_mob_icon = 'icons/mob/human_races/augments_external.dmi'
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/augments_external.dmi',
		BODYTYPE_VAURCA = 'icons/mob/species/vaurca/augments_external.dmi'
	)

/obj/item/organ/internal/augment/eye_sensors/phalanx/attack_self(var/mob/user)
	. = ..()

	if(selected_hud == "disabled")
		selected_hud = SEC_HUDTYPE
		to_chat(user, "You activate \the [src] security HUD.")
		return
	if(selected_hud == SEC_HUDTYPE)
		selected_hud = MED_HUDTYPE
		to_chat(user, "You activate \the [src] medical HUD.")
		return
	if(selected_hud == MED_HUDTYPE)
		selected_hud = "disabled"
		to_chat(user, "You deactivate \the [src].")
		return

/obj/item/organ/internal/augment/eye_sensors/phalanx/process()
	..()

	switch(selected_hud)
		if(SEC_HUDTYPE)
			req_access = list(ACCESS_SECURITY)
			if(allowed(owner))
				active_hud = "security"
				process_sec_hud(owner, 1)
			else
				active_hud = "disabled"
		if(MED_HUDTYPE)
			req_access = list(ACCESS_MEDICAL)
			if(allowed(owner))
				active_hud = "medical"
				process_med_hud(owner, 1)
			else
				active_hud = "disabled"
		else
			active_hud = "disabled"
