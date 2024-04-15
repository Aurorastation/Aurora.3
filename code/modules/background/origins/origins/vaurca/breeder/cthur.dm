/singleton/origin_item/culture/cthur_breeder
	name = "C'thur Hive"
	desc = "Known as 'The Weavers', they are the third Hive that has developed relationships with other sophonts of the Orion Spur. While their arrival was kept in secret by the Nralakk Federation, the revelation has reignited diplomatic disputes between K'lax and C'thur, with outright hostility met by the K'lax towards the C'thur. "
	possible_origins = list(
		/singleton/origin_item/origin/cthur_b,
		/singleton/origin_item/origin/mouv_b,
		/singleton/origin_item/origin/vytel_b
	)
	origin_traits_descriptions = list("can speak Nral'malic")

/singleton/origin_item/culture/cthur_breeder/on_apply(mob/living/carbon/human/H)
	. = ..()
	var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/cthur(H)
	var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
	A.replaced(H, affected)

/singleton/origin_item/culture/cthur_breeder/on_remove(mob/living/carbon/human/H)
	. = ..()
	var/obj/item/organ/internal/augment/language/cthur/A = locate() in H.internal_organs
	if(istype(A))
		A.removed(H)
		qdel(A)

/singleton/origin_item/origin/cthur_b
	name = "C'thur Brood"
	desc = "The brood of the High Queen C'thur. Due to the Queen's health, many remain near Diulszi."
	possible_accents = list(ACCENT_CTHUR, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_CTHUR, CITIZENSHIP_NRALAKK)
	possible_religions = list(RELIGION_HIVEPANTHEON, RELIGION_PREIMMINENNCE, RELIGION_NONE)

/singleton/origin_item/origin/mouv_b
	name = "Mouv Brood"
	desc = "Her brood leads Vaurca scientific research in Skrellian space, and is also brokering deals with the Eridani Federation. She is also known for purchasing a portion of Einstein Engines."
	possible_accents = list(ACCENT_CTHUR, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_CTHUR, CITIZENSHIP_NRALAKK)
	possible_religions = list(RELIGION_HIVEPANTHEON, RELIGION_PREIMMINENNCE, RELIGION_NONE)
	origin_traits = list(TRAIT_ORIGIN_ELECTRONIC_WARFARE)
	origin_traits_descriptions = list("are more capable in Hivenet electronic warfare.")

/singleton/origin_item/origin/vytel_b
	name = "Vytel Brood"
	desc = "Known for upholding the law, Vytel is the Warrior brood of the C'thur. They are spread within Nralakk space, the Eridani Federation, and the Corporate Reconstruction Zone."
	possible_accents = list(ACCENT_CTHUR, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_CTHUR, CITIZENSHIP_NRALAKK)
	possible_religions = list(RELIGION_HIVEPANTHEON, RELIGION_PREIMMINENNCE, RELIGION_NONE)
