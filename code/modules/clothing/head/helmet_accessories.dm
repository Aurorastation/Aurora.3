/obj/item/helmet_accessory
	icon = 'icons/clothing/kit/helmet_accessories.dmi'
	contained_sprite = TRUE
	default_action_type = /datum/action/item_action/deep
	var/datum/weakref/helmet_ref

/obj/item/helmet_accessory/proc/get_helmet()
	if(!helmet_ref)
		return null
	return helmet_ref.resolve()

/obj/item/helmet_accessory/proc/inserted_into_helmet(var/obj/item/clothing/head/helmet/helmet)
	helmet_ref = WEAKREF(helmet)

/obj/item/helmet_accessory/proc/removed_into_helmet(var/obj/item/clothing/head/helmet/helmet)
	helmet_ref = null


/obj/item/helmet_accessory/faceplate
	name = "faceplate"
	desc = "A faceplate that can be attached to a helmet."
	icon_state = "faceplate"
	item_state = "faceplate"
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("una", "taj")

	action_button_name = "Toggle Visor"

	var/helmet_type = ""
	var/list/supported_helmet_types = list(
		"helm_blue",
		"helm_generic",
		"helm_sec",
		"helm_sec_commander",
		"helm_sec_heavy",
		"helm_ballistic",
		"helm_ablative",
		"helm_military"
	)
	var/deployed = FALSE

/obj/item/helmet_accessory/faceplate/inserted_into_helmet(var/obj/item/clothing/head/helmet/helmet)
	. = ..()
	var/helm_icon_state = initial(helmet.icon_state)
	helmet_type = (helm_icon_state in supported_helmet_types) ? helm_icon_state : "helm_generic"
	update_helmet_coverage(helmet)
	update_icon()

/obj/item/helmet_accessory/faceplate/removed_into_helmet(var/obj/item/clothing/head/helmet/helmet)
	. = ..()
	helmet_type = initial(helmet_type)
	update_helmet_coverage(helmet, TRUE)
	update_icon()

/obj/item/helmet_accessory/faceplate/proc/update_helmet_coverage(var/obj/item/clothing/head/helmet/helmet, var/removed)
	if(deployed && !removed)
		helmet.body_parts_covered |= FACE|EYES
	else
		var/helmet_initial_parts_covered = initial(helmet.body_parts_covered)
		if(HAS_FLAG(helmet.body_parts_covered, FACE) && !HAS_FLAG(helmet_initial_parts_covered, FACE)) helmet.body_parts_covered &= ~FACE
		if(HAS_FLAG(helmet.body_parts_covered, EYES) && !HAS_FLAG(helmet_initial_parts_covered, EYES)) helmet.body_parts_covered &= ~EYES

/obj/item/helmet_accessory/faceplate/update_icon()
	icon_state = "[initial(icon_state)][deployed ? "_deployed" : ""]"
	item_state = icon_state

	var/obj/item/clothing/head/helmet/helmet = get_helmet()
	if(helmet)
		helmet.update_clothing_icon()

/obj/item/helmet_accessory/faceplate/attack_self(mob/user)
	if(use_check_and_message(user))
		return
	do_flip(user)

/obj/item/helmet_accessory/faceplate/proc/do_flip(var/mob/user)
	deployed = !deployed
	var/obj/item/clothing/head/helmet/helmet = get_helmet()
	if(helmet)
		update_helmet_coverage(helmet)
	update_icon()

/obj/item/helmet_accessory/faceplate/apply_sprite_to_helmet(var/image/mob_overlay, var/obj/item/clothing/head/helmet/helmet, var/mob/living/carbon/human/wearer)
	auto_adapt_species(wearer, TRUE)
	var/overlay_state = icon_species_tag ? "[icon_species_tag]_[icon_state]" : icon_state
	mob_overlay.add_overlay(image('icons/clothing/kit/helmet_garb.dmi', null, overlay_state))
