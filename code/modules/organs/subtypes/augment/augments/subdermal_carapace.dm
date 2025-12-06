/obj/item/organ/internal/augment/bioaug/subdermal_carapace
	name = "subdermal carapace"
	desc = "Used by the Galatean military to provide additional ballistic protection. This augment causes accelerated bone growth in the ribcage," \
		+ "transforming it into a solid, hardened plate of bone. This provides a small amount of protection to vital organs." \
		+ "In combination with armor, it can turn lethal injuries into merely serious wounds."
	icon_state = "subdermal_carapace"
	organ_tag = BP_AUG_SUBDERMAL_CARAPACE
	parent_organ = BP_CHEST
	var/melee_modifier = ARMOR_MELEE_SMALL
	var/ballistic_modifier = ARMOR_BALLISTIC_SMALL

/obj/item/organ/internal/augment/bioaug/subdermal_carapace/Initialize()
	. = ..()
	if(!owner)
		return

	EnsureComponent(owner, /datum/component/armor, armor_component)
	armor_component.armor_values[MELEE] += melee_modifier
	armor_component.armor_values[BULLET] += ballistic_modifier

/obj/item/organ/internal/augment/bioaug/subdermal_carapace/replaced()
	. = ..()
	if(!owner)
		return

	EnsureComponent(owner, /datum/component/armor, armor_component)
	armor_component.armor_values[MELEE] += melee_modifier
	armor_component.armor_values[BULLET] += ballistic_modifier

/obj/item/organ/internal/augment/bioaug/subdermal_carapace/removed()
	. = ..()
	if(!owner)
		return

	TryComponentOrReturn(owner, /datum/component/armor, armor_component, ..())
	armor_component.armor_values[MELEE] -= melee_modifier
	armor_component.armor_values[BULLET] -= ballistic_modifier
