/obj/item/clothing/mask/gas
	name = "gas mask"
	desc = "A face-covering mask that can be connected to an air supply. Filters harmful gases from the air."
	icon_state = "gas_alt"
	item_flags = BLOCK_GAS_SMOKE_EFFECT | AIRTIGHT | THICKMATERIAL
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	body_parts_covered = FACE|EYES
	w_class = ITEMSIZE_NORMAL
	item_state = "gas_alt"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	siemens_coefficient = 0.9
	var/gas_filter_strength = 1			//For gas mask filters
	var/list/filtered_gases = list(GAS_PHORON, GAS_N2O)
	armor = list(
		bio = ARMOR_BIO_STRONG
	)

/obj/item/clothing/mask/gas/filter_air(datum/gas_mixture/air)
	var/datum/gas_mixture/filtered = new

	for(var/g in filtered_gases)
		if(air.gas[g])
			filtered.gas[g] = air.gas[g] * gas_filter_strength
			air.gas[g] -= filtered.gas[g]

	air.update_values()
	filtered.update_values()

	return filtered

/obj/item/clothing/mask/gas/alt
	desc = "A face-covering mask that can be connected to an air supply. Filters harmful gases from the air. Doesn't seem to mask the face as much as older designs."
	flags_inv = HIDEEARS
	item_state = "gas_alt_alt"
	icon_state = "gas_alt_alt"

/obj/item/clothing/mask/gas/half
	name = "face mask"
	desc = "A respirator that covers the mouth and nose. It can be connected to an air supply. Filters harmful gases from the air."
	item_state = "halfgas"
	icon_state = "halfgas"
	w_class = ITEMSIZE_SMALL
	flags_inv = null
	body_parts_covered = FACE
	down_body_parts_covered = null
	adjustable = TRUE

/obj/item/clothing/mask/gas/old
	desc = "A face-covering mask that can be connected to an air supply. Seems to be an old, outdated design."
	filtered_gases = list(GAS_N2O)
	item_state = "gas_mask"
	icon_state = "gas_mask"

/obj/item/clothing/mask/gas/swat
	name = "\improper SWAT mask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "swat"
	item_state = "swat"
	siemens_coefficient = 0.7
	body_parts_covered = FACE|EYES

/obj/item/clothing/mask/gas/syndicate
	name = "tactical mask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "swat"
	item_state = "swat"
	siemens_coefficient = 0.7

/obj/item/clothing/mask/gas/mime
	name = "mime mask"
	desc = "The traditional mime's mask. It has an eerie facial posture."
	icon_state = "mime"
	item_state = "mime"

/obj/item/clothing/mask/gas/monkeymask
	name = "monkey mask"
	desc = "A mask used when acting as a monkey."
	icon_state = "monkeymask"
	item_state = "monkeymask"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/sexymime
	name = "sexy mime mask"
	desc = "A traditional female mime's mask."
	icon_state = "sexymime"
	item_state = "sexymime"

/obj/item/clothing/mask/gas/cyborg
	name = "cyborg visor"
	desc = "Beep boop"
	icon_state = "death"

/obj/item/clothing/mask/gas/owl_mask
	name = "owl mask"
	desc = "Twoooo!"
	icon_state = "owl"
	item_state = "owl"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/tactical
	name = "tactical mask"
	desc = "A compact carbon-fiber respirator covering the mouth and nose to protect against the inhalation of smoke and other harmful gasses."
	icon_state = "fullgas"
	item_state = "fullgas"
	w_class = ITEMSIZE_SMALL
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MINOR,
		bio = ARMOR_BIO_STRONG
	)
