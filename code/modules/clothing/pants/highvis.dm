/obj/item/clothing/pants/highvis
	name = "high visibility pants"
	desc = "A pair of loose-fitting, high visibility pants to help the wearer be recognizable in high traffic areas with large industrial equipment."
	icon = 'icons/obj/item/clothing/pants/highvis.dmi'
	icon_state = "pants_highvis"
	item_state = "pants_highvis"
	contained_sprite = TRUE
	body_parts_covered = LOWER_TORSO|LEGS
	siemens_coefficient = 0.8
	armor = list(
		MELEE = ARMOR_MELEE_MINOR,
		BIO = ARMOR_BIO_MINOR
	)

/obj/item/clothing/pants/highvis/get_mob_emissive_overlays(mob/living/carbon/human/H, mob_icon, mob_state, slot)
	if(slot != slot_pants_str)
		return
	return emissive_appearance(mob_icon, "[icon_state][species_sprite_adaption_type]-emis", H, alpha = src.alpha)

/obj/item/clothing/pants/highvis/colorable
	icon_state = "pants_highvis_colorable"
	item_state = "pants_highvis_colorable"
	build_from_parts = TRUE
	worn_overlay = "lining"
	has_accents = TRUE

/obj/item/clothing/pants/highvis/alt
	icon_state = "pants_highvis_alt"
	item_state = "pants_highvis_alt"

/obj/item/clothing/pants/highvis/red
	icon_state = "pants_highvis_red"
	item_state = "pants_highvis_red"

/obj/item/clothing/pants/highvis/orange
	icon_state = "pants_highvis_orange"
	item_state = "pants_highvis_orange"
