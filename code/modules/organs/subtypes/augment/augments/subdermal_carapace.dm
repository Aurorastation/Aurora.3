/obj/item/organ/internal/augment/bioaug/subdermal_carapace
	name = "subdermal carapace"
	desc = "Used by the Galatean military to provide additional ballistic protection. This augment causes accelerated bone growth in the ribcage," \
		+ "transforming it into a solid, hardened plate of bone. This provides a small amount of protection to vital organs." \
		+ "In combination with armor, it can turn lethal injuries into merely serious wounds."
	icon_state = "subdermal_carapace"
	organ_tag = BP_AUG_SUBDERMAL_CARAPACE
	parent_organ = BP_CHEST

/obj/item/organ/internal/augment/bioaug/subdermal_carapace/Initialize()
	. = ..()
	if(!owner)
		return

	owner.AddComponent(/datum/component/armor, list(MELEE = ARMOR_MELEE_SMALL, BULLET = ARMOR_BALLISTIC_MINOR))

/obj/item/organ/internal/augment/bioaug/subdermal_carapace/replaced()
	. = ..()
	if(!owner)
		return

	owner.AddComponent(/datum/component/armor, list(MELEE = ARMOR_MELEE_SMALL, BULLET = ARMOR_BALLISTIC_MINOR))

/obj/item/organ/internal/augment/bioaug/subdermal_carapace/removed()
	. = ..()
	if(!owner)
		return

	var/datum/component/armor/armor_component = owner.GetComponent(/datum/component/armor)
	qdel(armor_component)
