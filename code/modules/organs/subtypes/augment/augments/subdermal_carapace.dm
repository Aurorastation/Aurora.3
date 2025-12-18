/obj/item/organ/internal/augment/bioaug/subdermal_carapace
	name = "subdermal carapace"
	desc = "Used by the Galatean military to provide additional ballistic protection. This augment causes accelerated bone growth in the ribcage," \
		+ "transforming it into a solid, hardened plate of bone. This provides a small amount of protection to vital organs." \
		+ "In combination with armor, it can turn lethal injuries into merely serious wounds."
	icon_state = "subdermal_carapace"
	organ_tag = BP_AUG_SUBDERMAL_CARAPACE
	parent_organ = BP_CHEST

	/// The set of armor component modifiers that this implant will provide to its implantee.
	var/armor_modifiers = alist(
		MELEE = ARMOR_MELEE_SMALL,
		BULLET = ARMOR_BALLISTIC_SMALL
	)

	/// Whether this implant is currently providing its modifiers to an implantee. This exists to catch edge cases.
	var/applied = FALSE

/obj/item/organ/internal/augment/bioaug/subdermal_carapace/Initialize()
	. = ..()
	if(!owner || applied)
		return

	applied = TRUE

	// Player characters (the intended recipient) are intended to always have an ArmorComponent.
	// The implant technically doesn't require or care if its in a human, so we can make the crazy assertion that
	// if you can put this implant in someone/something, then it should be able to have the armor component.
	EnsureComponent(owner, /datum/component/armor, armor_component)
	for(var/armor_type,armor_value in armor_modifiers)
		armor_component.armor_values[armor_type] += armor_value

/obj/item/organ/internal/augment/bioaug/subdermal_carapace/replaced()
	. = ..()
	if(!owner || applied)
		return

	applied = TRUE

	EnsureComponent(owner, /datum/component/armor, armor_component)
	for(var/armor_type,armor_value in armor_modifiers)
		armor_component.armor_values[armor_type] += armor_value

/obj/item/organ/internal/augment/bioaug/subdermal_carapace/removed()
	. = ..()
	applied = FALSE
	if(!owner)
		return

	// If we're removing the implant from someone who for whatever strange reason doesn't have an ArmorComponent,
	// then we exit immediately since there's nothing to reset.
	TryComponentOrReturn(owner, /datum/component/armor, armor_component, ..())
	for(var/armor_type,armor_value in armor_modifiers)
		armor_component.armor_values[armor_type] -= armor_value
