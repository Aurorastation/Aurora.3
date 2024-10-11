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
	/// A list of language-related verbs granted by the augment.
	var/list/granted_verbs = list()

/obj/item/organ/internal/augment/language/replaced(var/mob/living/carbon/human/target, obj/item/organ/external/affected)
	. = ..()
	for(var/language in augment_languages)
		if(!(language in target.languages))
			target.add_language(language)
			added_languages += language
	add_verb(target, granted_verbs)

/obj/item/organ/internal/augment/language/removed(var/mob/living/carbon/human/target, mob/living/user)
	for(var/language in added_languages)
		target.remove_language(language)
	added_languages = list()
	remove_verb(target, granted_verbs)
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
	species_restricted = list(
		SPECIES_VAURCA_BREEDER,
		SPECIES_VAURCA_BULWARK,
		SPECIES_VAURCA_WARFORM,
		SPECIES_VAURCA_WARRIOR,
		SPECIES_VAURCA_ATTENDANT,
		SPECIES_VAURCA_WORKER,
	)

/obj/item/organ/internal/augment/language/cthur
	name = "C'thur language processor"
	augment_languages = list(LANGUAGE_SKRELLIAN)
	species_restricted = list(
		SPECIES_VAURCA_BREEDER,
		SPECIES_VAURCA_BULWARK,
		SPECIES_VAURCA_WARFORM,
		SPECIES_VAURCA_WARRIOR,
		SPECIES_VAURCA_ATTENDANT,
		SPECIES_VAURCA_WORKER,
	)


/obj/item/organ/internal/augment/language/mikuetz
	name = "Mi'kuetz language processor"
	augment_languages = list(LANGUAGE_AZAZIBA)
	species_restricted = list(
		SPECIES_VAURCA_BREEDER,
		SPECIES_VAURCA_BULWARK,
		SPECIES_VAURCA_WARFORM,
		SPECIES_VAURCA_WARRIOR,
		SPECIES_VAURCA_ATTENDANT,
		SPECIES_VAURCA_WORKER,
	)


/obj/item/organ/internal/augment/language/zino
	name = "Zino language processor"
	augment_languages = list(LANGUAGE_GUTTER)
	species_restricted = list(
		SPECIES_VAURCA_BREEDER,
		SPECIES_VAURCA_BULWARK,
		SPECIES_VAURCA_WARFORM,
		SPECIES_VAURCA_WARRIOR,
		SPECIES_VAURCA_ATTENDANT,
		SPECIES_VAURCA_WORKER,
	)


/obj/item/organ/internal/augment/language/tradeband
	name = "Tradeband language processor"
	augment_languages = list(LANGUAGE_TRADEBAND)
	species_restricted = list(
		SPECIES_VAURCA_BREEDER,
		SPECIES_VAURCA_BULWARK,
		SPECIES_VAURCA_WARFORM,
		SPECIES_VAURCA_WARRIOR,
		SPECIES_VAURCA_ATTENDANT,
		SPECIES_VAURCA_WORKER,
	)

/obj/item/organ/internal/augment/language/zeng
	name = "Zeng-Hu Nral'malic language processor"
	augment_languages = list(LANGUAGE_SKRELLIAN)
	species_restricted = list(
		SPECIES_VAURCA_BREEDER,
		SPECIES_VAURCA_BULWARK,
		SPECIES_VAURCA_WARFORM,
		SPECIES_VAURCA_WARRIOR,
		SPECIES_VAURCA_ATTENDANT,
		SPECIES_VAURCA_WORKER,
	)

/obj/item/organ/internal/augment/language/vekatak
	name = "Ve'katak Phalanx Hivenet receiver"
	icon_state = "phalanx_hivenet"
	dead_icon = "phalanx_hivenet_broken"
	on_mob_icon = 'icons/mob/human_races/augments_external.dmi'
	augment_languages = list(LANGUAGE_VAURCA)
	granted_verbs = list(/mob/living/carbon/human/proc/hivenet_recieve, /mob/living/carbon/human/proc/phalanx_transmit)
	var/decryption_key
	var/banned = FALSE
	var/muted = FALSE
	var/transmitting = FALSE
	var/disrupted = FALSE
	var/disrupttime = 0

/obj/item/organ/internal/augment/language/vekatak/process()
	. = ..()
	if(disrupted)
		if(disrupttime > world.time)
			disrupttime--
		else
			disrupted = FALSE

/obj/item/organ/internal/augment/language/vekatak/emp_act()
	. = ..()
	for(var/language in added_languages)
		if(prob(25))
			owner.remove_language(language)
	owner.set_default_language(pick(owner.languages))
	to_chat(owner, SPAN_DANGER("You feel thousands of voices, all clamoring inside your mind!"))
	owner.adjustHalLoss(15)
	owner.flash_pain(15)
	owner.adjustBrainLoss(5)
