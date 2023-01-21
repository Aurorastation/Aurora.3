/singleton/origin_item/culture/megacorporate
	name = "Megacorporate"
	desc = "The majority of IPC are manufactured by a megacorporation and nearly every type of commercially-available frame is owned or originated from them. Although many of these IPC are sold to consumers in the public and private sectors, a good portion of them are retained for in-house use by their manufacturers or their subsidiaries. The treatment and behaviour of a corporate IPC is often influenced by the megacorporation they find themselves in."
	possible_origins = list(
		/singleton/origin_item/origin/idris,
		/singleton/origin_item/origin/hephaestus,
		/singleton/origin_item/origin/zenghu,
		/singleton/origin_item/origin/zavodskoi,
		/singleton/origin_item/origin/nanotrasen
	)

/singleton/origin_item/origin/idris
	name = "Idris Incorporated"
	desc = "Idris Incorporated is renowned across the Spur for its top of the line service, security, and investigative IPCs. Positronics working for the company are given little autonomy and closely monitored to ensure maximum efficiency and stellar customer service. Although the company likes to advertise its award-winning service IPCs, just as infamous are its Idris Reclamation Units: synthetics who will stop at nothing to ensure that the bank is given its dues."
	important_information = "Idris IPCs working in security are given the prefix ISU or IRU depending on their responsibilities while those working in other fields are not obliged to take one. They are barred from seeking freedom by the company and cannot be sold without having their proprietary programming wiped."
	possible_accents = list(ACCENT_SILVERSUN_EXPATRIATE, ACCENT_SILVERSUN_ORIGINAL, ACCENT_SOL, ACCENT_JUPITER, ACCENT_CALLISTO, ACCENT_ERIDANI, ACCENT_LUNA, ACCENT_EARTH, ACCENT_VENUS, ACCENT_CETI, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_NONE)
	possible_religions = list(RELIGION_NONE)

/singleton/origin_item/origin/hephaestus
	name = "Hephaestus Industries"
	desc = "Hephaestus Industries is known as the primary fabricator of IPCs in the Spur. Its own lines however focus mainly on strength and mining, the company fielding untold numbers of industrial frames for all sorts of excavation, cargo, and  engineering operations, gaining them a sturdy reputation of durability and efficiency. The company is known to treat its IPCs fairly, albeit holding them to a higher standard than organics, and even offers synthetics who manage to purchase their freedom respectable positions within the company."
	possible_accents = list(ACCENT_SOL, ACCENT_EARTH, ACCENT_MARTIAN, ACCENT_CETI, ACCENT_XANU, ACCENT_COC, ACCENT_NCF, ACCENT_PHONG, ACCENT_ERIDANI, ACCENT_VALKYRIE, ACCENT_GIBSON_OVAN, ACCENT_GIBSON_UNDIR, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_NONE)
	possible_religions = list(RELIGION_NONE)

/singleton/origin_item/origin/zenghu
	name = "Zeng-Hu Pharmaceuticals"
	desc = "Zeng-Hu Pharmaceuticals employs a large number of IPCs, both free and owned, with the newest models often being shown to the public as a display of the company's technological prowess. They are treated relatively well based on the standards of the Spur, however they are often urged to perfectionism and quality, being rewarded for success and punished for failure. In keeping with the company's competitive yet meritocratic nature, IPCs which perform well and catch the eye of their superiors can be elevated to positions of responsibility, in some cases, winning their freedom through hard and exceptional labour."
	important_information = "IPCs belonging to Zeng-Hu do not possess a standard naming convention."
	possible_accents = list(ACCENT_SOL, ACCENT_LUNA, ACCENT_CETI, ACCENT_KONYAN, ACCENT_EUROPA, ACCENT_ERIDANI, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_NONE)
	possible_religions = list(RELIGION_NONE)

/singleton/origin_item/origin/zavodskoi
	name = "Zavodskoi Interstellar" //here lies necropolis, died a slow and painful death, thanks god
	desc = "Zavodskoi Interstellar fields a multitude of IPCs oriented towards combat and security solutions. From Industrials to Shells, these units are regularly leased out to third parties as security guards, representing the company in a professional and clean manner. Standards are high for Zavodskoi synthetics, with mind wiping and retooling as punishments in case of failure in order to enforce discipline and minimise deviancy."
	important_information = "Units from Zavodskoi Interstellar are all given the prefix Z.I. in front of their name."
	possible_accents = list(ACCENT_SOL, ACCENT_LUNA, ACCENT_EARTH, ACCENT_PLUTO, ACCENT_CETI, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_NONE)
	possible_religions = list(RELIGION_NONE)

/singleton/origin_item/origin/nanotrasen
	name = "Nanotrasen"
	desc = "Nanotrasen, in keeping close ties with the Biesellite government, quietly and eagerly accepted IPCs into its workforce while carefully manipulating the books to ensure that very few would ever attain freedom. IPCs are a common but not ubiquitous sight on NanoTrasen installations and can be found working any number of roles. Although the company's treatment of IPCs is styled after Biesel's own attitude towards synthetics, it can vary wildly depending on where a positronic works and who exactly it works under."
	possible_accents = list(ACCENT_CETI, ACCENT_XANU, ACCENT_COC, ACCENT_ERIDANI, ACCENT_SOL, ACCENT_SCARAB, ACCENT_SILVERSUN_EXPATRIATE, ACCENT_SILVERSUN_ORIGINAL, ACCENT_PHONG, ACCENT_MARTIAN, ACCENT_KONYAN, ACCENT_LUNA, ACCENT_GIBSON_OVAN, ACCENT_GIBSON_UNDIR, ACCENT_VYSOKA, ACCENT_VENUS, ACCENT_VENUSJIN, ACCENT_JUPITER, ACCENT_CALLISTO, ACCENT_EUROPA, ACCENT_EARTH, ACCENT_NCF, ACCENT_VISEGRAD, ACCENT_VALKYRIE, ACCENT_MICTLAN, ACCENT_ANTILLIA, ACCENT_TTS)
	possible_citizenships = list(CITIZENSHIP_NONE)
	possible_religions = list(RELIGION_NONE)