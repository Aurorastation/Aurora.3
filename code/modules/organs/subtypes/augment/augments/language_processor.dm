/obj/item/organ/internal/augment/language
	name = "language processor"
	desc = "An augment installed into the head that interfaces with the user's neural interface, " \
		+ "intercepting and assisting language faculties."
	organ_tag = BP_AUG_LANGUAGE
	parent_organ = BP_HEAD
	/// A list of languages that this augment will add. add your language to this
	var/list/augment_languages = list()
	/// A list of languages that get added when it's installed. used to remove languages later. don't touch this.
	var/list/added_languages = list()

/obj/item/organ/internal/augment/language/replaced(var/mob/living/carbon/human/target, obj/item/organ/external/affected)
	. = ..()
	for(var/language in augment_languages)
		if(!(language in target.languages))
			target.add_language(language)
			added_languages += language

/obj/item/organ/internal/augment/language/removed(var/mob/living/carbon/human/target, mob/living/user)
	for(var/language in added_languages)
		target.remove_language(language)
	added_languages = list()
	..()

/obj/item/organ/internal/augment/language/emp_act()
	. = ..()

	for(var/language in added_languages)
		if(prob(25))
			owner.remove_language(language)

	owner.set_default_language(pick(owner.languages))

/obj/item/organ/internal/augment/language/klax
	name = "K'laxan language processor"
	augment_languages = list(LANGUAGE_UNATHI)

/obj/item/organ/internal/augment/language/cthur
	name = "C'thur language processor"
	augment_languages = list(LANGUAGE_SKRELLIAN)

/obj/item/organ/internal/augment/language/mikuetz
	name = "Mi'kuetz language processor"
	augment_languages = list(LANGUAGE_AZAZIBA)

/obj/item/organ/internal/augment/language/zino
	name = "Zino language processor"
	augment_languages = list(LANGUAGE_GUTTER)

/obj/item/organ/internal/augment/language/eridani
	name = "Eridani language processor"
	augment_languages = list(LANGUAGE_TRADEBAND)

/obj/item/organ/internal/augment/language/zeng
	name = "Zeng-Hu Nral'malic language processor"
	augment_languages = list(LANGUAGE_SKRELLIAN)
