/obj/item/organ/internal/augment/health_scanner
	name = "integrated health scanner"
	action_button_name = "Activate Health Scanner"
	action_button_icon = "health"
	organ_tag = BP_AUG_HEALTHSCAN
	activable = TRUE
	cooldown = 8

/obj/item/organ/internal/augment/health_scanner/attack_self(var/mob/user)
	. = ..()
	if(!.)
		return FALSE

	health_scan_mob(owner, owner, TRUE, TRUE)
