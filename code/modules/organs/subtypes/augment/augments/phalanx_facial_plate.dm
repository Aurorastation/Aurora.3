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
	organ_traits = list(TRAIT_MEDICAL_HUD, TRAIT_SECURITY_HUD)
