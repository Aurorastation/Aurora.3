/singleton/origin_item/culture/queendom
	name = "Queendom of Sezk-Hakh"
	desc = "Situated across Moghes’ eastern hemisphere, within the Tzuszah Wastes, the Queendom of Sezk-Hakh has managed to thrive somewhat, isolated from the ires of the Izweski Hegemony thanks to the extensive, growing Wasteland. Led by the elderly Queen Lazak Szek’Hakh alongside her daughters, Zasza and Tzansa. Though the Wasteland has made resources within the previously lush region somewhat scarce, the Queendom manages to teeter between thriving and surviving thanks to the extensive aquaculture industry that exists within the capital of Yu’kal – expanded upon by Queen Lazak following the death of her husband during the Contact War."
	possible_origins = list(
		/singleton/origin_item/origin/queendom
	)

/singleton/origin_item/origin/queendom
	name = "Queendom"
	desc = "A wildly different culture compared to most Unathi, the Queendom is a matriarchal society where the normal gender roles are inverted. Born out of the fire of the contact war, only time will tell if their new culture will continue onwards, or fall forgotten into the sands of the Wasteland."
	possible_accents = list(ACCENT_QUEENDOM)
	possible_citizenships = list(CITIZENSHIP_IZWESKI)
	possible_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_SIAKH, RELIGION_OTHER, RELIGION_NONE)
	origin_traits_descriptions = list("have a small resistance to radiation") //they live in the wasteland

/singleton/origin_item/origin/queendom/on_apply(var/mob/living/carbon/human/H)
	. = ..()
	H.AddComponent(/datum/component/armor, list(RAD = ARMOR_RAD_MINOR))

/singleton/origin_item/origin/queendom/on_remove(mob/living/carbon/human/H)
	. = ..()
	var/datum/component/armor/armor_component = H.GetComponent(/datum/component/armor)
	qdel(armor_component)
