/obj/item/organ/internal/augment/translator
	name = "universal translator"
	parent_organ = BP_HEAD
	organ_tag = BP_AUG_TRANSLATOR
	/// List of languages that the augment can translate.
	var/list/languages = list(
		LANGUAGE_ELYRAN_STANDARD,
		LANGUAGE_GUTTER,
		LANGUAGE_SOL_COMMON,
		LANGUAGE_TCB,
		LANGUAGE_TRADEBAND,
	)
