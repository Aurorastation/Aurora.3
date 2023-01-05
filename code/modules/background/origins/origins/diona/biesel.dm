/decl/origin_item/culture/diona_biesel
	name = "Republic of Biesel"
	desc = "Relatively new compared to other cultures across the Orion Spur, the Biesellite culture was forged from the fire borne by its independence. Since its inception, it has continued to evolve, especially with the recent expansion of the Republic of Biesel into the Solarian Alliance's Outer Ring after its abandonment during the collapse. Despite its recent acquisition, the Corporate Reconstruction Zone as it is now known has begun adjusting and blending their own cultures into the Biesellite way of life, those not bending the knee and aligning are often bastions of insurgency and unrest."
	possible_origins = list(
		/decl/origin_item/origin/biesel_grown,
		/decl/origin_item/origin/diona_district_11,
		/decl/origin_item/origin/titan_prime,
		/decl/origin_item/origin/biesel_wildborn
	)

/decl/origin_item/origin/biesel_grown
	name = "Biesel Grown"
	desc = "Dionae who were grown in and largely influenced by the Republic of Biesel."
	important_information = "While Dionae do still face some discrimination in the Republic, Dionae can expect to live a fairly comfortable life. The Republic itself does not apply any sort of \"debt\" to Dionae they uplift, however, a megacorp may rope them into a contract to work for them if they played any part in growing them."
	possible_accents = list(ACCENT_ROOTSONG, ACCENT_VOIDSONG)
	possible_citizenships = list(CITIZENSHIP_BIESEL, CITIZENSHIP_NRALAKK, CITIZENSHIP_EUM, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_ETERNAL, RELIGION_OTHER, RELIGION_NONE)

/decl/origin_item/origin/diona_district_11
	name = "District 11"
	desc = "Dionae who were grown in and largely influenced by Mendel City's District 11 on Biesel. This includes both those grown in areas affected by the church and in the outskirts of its influence."
	important_information = "Dionae originating from the Eternal Temple in D11 are not beholden to following the Eternal faith, however, the church still ensures that all Dionae grown within its walls are educated and made ready for the outside world."
	possible_accents = list(ACCENT_ROOTSONG, ACCENT_VOIDSONG)
	possible_citizenships = list(CITIZENSHIP_BIESEL, CITIZENSHIP_NRALAKK, CITIZENSHIP_EUM, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_ETERNAL, RELIGION_OTHER, RELIGION_NONE)

/decl/origin_item/origin/titan_prime
	name = "Pests of Titan Prime" //this might be the most metal origin name
	desc = "Dionae who were originally grown in or picked up by Titan Prime on its way to Biesel. Prior to Titan Prime reaching Biesel, these Dionae had an incredibly hard time as they were constantly hunted by the ship's Vaurca inhabitants, believing them to be nothing more than pests and the Dionae not being able to communicate back with them. Once reaching Biesel many Dionae left the ship and went on to seek a new life on the planet. Those that didn't leave were willingly allowed to stay with the Zo'ra on a special garden-deck constructed specifically for them as a sort of apology for hunting them for so long."
	important_information = "These Dionae are likely to have a massive distrust of the Zo'ra hive or vaurca in general as a result of their time being hunted on the ship for so long."
	possible_accents = list(ACCENT_ROOTSONG, ACCENT_VOIDSONG)
	possible_citizenships = list(CITIZENSHIP_BIESEL)
	possible_religions = list(RELIGION_ETERNAL, RELIGION_OTHER, RELIGION_NONE)

/decl/origin_item/origin/biesel_wildborn
	name = "Wildborn"
	desc = "Dionae who were originally considered wild Dionae before being uplifted and integrated by the Republic of Biesel or one of the megacorporations active within its borders."
	important_information = "While Dionae do still face some discrimination in the Republic, Dionae can expect to live a fairly comfortable life. The Republic itself does not apply any sort of \"debt\" to Dionae they uplift, however, a megacorp may rope them into a contract to work for them if they played any part in uplifting them."
	possible_accents = list(ACCENT_ROOTSONG, ACCENT_VOIDSONG)
	possible_citizenships = list(CITIZENSHIP_BIESEL, CITIZENSHIP_NRALAKK, CITIZENSHIP_EUM, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_ETERNAL, RELIGION_OTHER, RELIGION_NONE)