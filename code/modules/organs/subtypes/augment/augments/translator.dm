/obj/item/organ/internal/augment/translator
	name = "universal translator"
	parent_organ = BP_HEAD
	organ_tag = BP_AUG_TRANSLATOR
	/// List of languages that the augment can translate.
	var/list/languages = list(
		LANGUAGE_TCB,
		LANGUAGE_SOL_COMMON,
		LANGUAGE_TRADEBAND,
		LANGUAGE_GUTTER,
	)
