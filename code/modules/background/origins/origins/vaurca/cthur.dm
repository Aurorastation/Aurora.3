/singleton/origin_item/culture/cthur
	name = "C'thur Hive"
	desc = "Known as 'The Weavers', they are the third Hive that has developed relationships with other sophonts of the Orion Spur. While their arrival was kept in secret by the Nralakk Federation, the revelation has reignited diplomatic disputes between K'lax and C'thur, with outright hostility met by the K'lax towards the C'thur."
	possible_origins = list(
		/singleton/origin_item/origin/cthur,
		/singleton/origin_item/origin/mouv,
		/singleton/origin_item/origin/vytel,
		/singleton/origin_item/origin/xetl,
		/singleton/origin_item/origin/klatxatl,
		/singleton/origin_item/origin/liikenka
	)
	origin_traits_descriptions = list("can speak Nral'malic")

/singleton/origin_item/culture/cthur/on_apply(mob/living/carbon/human/H)
	. = ..()
	var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/cthur(H)
	var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
	A.replaced(H, affected)

/singleton/origin_item/culture/cthur/on_remove(mob/living/carbon/human/H)
	. = ..()
	var/obj/item/organ/internal/augment/language/cthur/A = locate() in H.internal_organs
	if(istype(A))
		A.removed(H)
		qdel(A)

/singleton/origin_item/origin/cthur
	name = "C'thur Brood"
	desc = "The brood of the High Queen C'thur. Due to the Queen's health, many remain near Diulszi."
	possible_accents = list(ACCENT_CTHUR, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_NRALAKK, CITIZENSHIP_ERIDANI, CITIZENSHIP_NONE)
	possible_religions = list(RELIGION_HIVEPANTHEON, RELIGION_PREIMMINENNCE, RELIGION_NONE)

/singleton/origin_item/origin/mouv
	name = "Mouv Brood"
	desc = "Her brood leads Vaurca scientific research in Skrellian space, and is also brokering deals with the Eridani Federation. She is also known for purchasing a portion of Einstein Engines."
	possible_accents = list(ACCENT_CTHUR, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_NRALAKK, CITIZENSHIP_ERIDANI, CITIZENSHIP_NONE)
	possible_religions = list(RELIGION_HIVEPANTHEON, RELIGION_PREIMMINENNCE, RELIGION_NONE)
	origin_traits = list(TRAIT_ORIGIN_ELECTRONIC_WARFARE)
	origin_traits_descriptions = list("are more capable in Hivenet electronic warfare.")

/singleton/origin_item/origin/vytel
	name = "Vytel Brood"
	desc = "Known for upholding the law, Vytel is the Warrior brood of the C'thur. They are spread within Nralakk space, the Eridani Federation, and the Corporate Reconstruction Zone."
	possible_accents = list(ACCENT_CTHUR, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_NRALAKK, CITIZENSHIP_ERIDANI, CITIZENSHIP_NONE)
	possible_religions = list(RELIGION_HIVEPANTHEON, RELIGION_PREIMMINENNCE, RELIGION_NONE)

/singleton/origin_item/origin/xetl
	name = "Xetl Brood"
	desc = "While Queen Xetl is kept away from negotiations, her brood is usually exported to human space for their labor."
	possible_accents = list(ACCENT_CTHUR, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_NRALAKK, CITIZENSHIP_ERIDANI, CITIZENSHIP_NONE)
	possible_religions = list(RELIGION_HIVEPANTHEON, RELIGION_PREIMMINENNCE, RELIGION_NONE)

/singleton/origin_item/origin/klatxatl
	name = "Klat'xatl"
	desc = "This term is employed for the 'Punished' or rejected groups of the C'thur. In a short time, they have lost ties with the broader Hive, and have formed a culture of their own."
	possible_accents = list(ACCENT_CTHUR, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_NONE)
	possible_religions = list(RELIGION_HIVEPANTHEON, RELIGION_PREIMMINENNCE, RELIGION_OTHER, RELIGION_NONE)

/singleton/origin_item/origin/liikenka
	name = "Lii'kenka"
	desc = "The Lii'kenka are a group of Punished Vaurcae who reside primarily in Phoenixport and on Mictlan. Preferring to be called the Kynyk among themselves, most remain in secrecy."
	important_information = "Playing as an undercover Lii'kenka could result in your character being punished by the Stellar Corporate Conglomerate or the C'thur Hive. Lii'kenka born before 2461 will match the carapace color of the C'thur brood, while younger Lii'kenka will have slightly off coloration. Undercover Lii'kenka should take the corresponding citizenship option, while those who openly identify as Kynyk should publicly declare no citizenship."
	possible_accents = list(ACCENT_CTHUR, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_LIIKENKA, CITIZENSHIP_NONE)
	possible_religions = list(RELIGION_HIVEPANTHEON, RELIGION_PREIMMINENNCE, RELIGION_OTHER, RELIGION_NONE)

