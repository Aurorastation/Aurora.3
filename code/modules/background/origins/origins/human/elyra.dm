#define RELIGIONS_ELYRA list(RELIGION_NONE, RELIGION_CHRISTIANITY, RELIGION_ISLAM, RELIGION_SHINTO, RELIGION_BUDDHISM, RELIGION_HINDU, RELIGION_TAOISM, RELIGION_JUDAISM, RELIGION_OTHER)

/decl/origin_item/culture/elyran
	name = "Serene Republic of Elyra"
	desc = "A rich and prosperous nation, the Serene Republic of Elyra is one of the few locations in the Orion Spur where phoron can be found. This phoron has made the Republic extremely wealthy and has given them a technological edge over much of the Spur. Highly-controlled customs and harsh immigration requirements have kept much of Elyra isolated from the broader Spur, and have led to the growth of a large population of \"Non-Citizen Persons,\" that reside in the Republic. Recent attacks by the Lii'dra hive of the vaurca have led to the Republic becoming increasingly militarized."
	important_information = "Elyra's historic isolationism has made it nearly impossible for outsiders to become Elyran citizens. <b>Elyran citizens must have names and appearances consistent with the people of the modern day Middle-East, North Africa, Anatolia, and Persia.</b> Only native Elyran citizens or Elyran made IPCs may take the Elyran accent. This is enforceable by server moderators and admins."
	possible_origins = list(
		/decl/origin_item/origin/persepolis,
		/decl/origin_item/origin/damascus,
		/decl/origin_item/origin/medina,
		/decl/origin_item/origin/aemaq,
		/decl/origin_item/origin/new_suez,
		/decl/origin_item/origin/other_elyran
	)

/decl/origin_item/origin/persepolis
	name = "Persepolis"
	desc = "The crown jewel of the Serene Republic of Elyra, Persepolis is the Republic's capital and most populated planet. The planet's vast deserts are home to some of the largest deposits of phoron in the Orion Spur, which has made it exceedingly wealthy and immensely well-developed. Persepolis is one of the most liberal of Elyra's worlds, and Persepolitians are often stereotyped within the broader Republic as playing \"faster and looser,\" with typical social norms."
	possible_accents = list(ACCENT_PERSEPOLIS)
	possible_citizenships = list(CITIZENSHIP_ELYRA)
	possible_religions = RELIGIONS_ELYRA

/decl/origin_item/origin/damascus
	name = "Damascus II"
	desc = "The historical and cultural home of the modern Republic, Damascus II is the birthplace of the modern Serene Republic of Elyra. While no longer its official capital, Damascus II remains relevant thanks to its rich history, well-developed agricultural sector, and a multitude of universities. Culturally, the planet is more traditional than the rest of Elyra and has a very strong connection to its old Earth cultural roots. It is one of the most outwardly religious planets in the Republic."
	possible_accents = list(ACCENT_DAMASCUS)
	possible_citizenships = list(CITIZENSHIP_ELYRA)
	possible_religions = RELIGIONS_ELYRA

/decl/origin_item/origin/medina
	name = "Medina"
	desc = "A planet rich in phoron, Medina is known for two things: its prolific art scene, and the Phoron Bulletin. The environment outside of Medina's floating cities is extremely hazardous due to unpredictable tectonic activity, which has led to bounties being placed for phoron extraction and presented to non-Elyran citizens in order to ensure that Elyran citizens do not end up dead. The Phoron Bulletin is an immensely hazardous, yet potentially immensely profitable, line of work in which a Non-Citizen Person in Elyra can become rich. Assuming they survive."
	possible_accents = list(ACCENT_MEDINA)
	possible_citizenships = list(CITIZENSHIP_ELYRA)
	possible_religions = RELIGIONS_ELYRA

/decl/origin_item/origin/aemaq
	name = "Aemaq"
	desc = "An Elyran frontier world that is home to the majority of the Republic's chemical industry, Aemaq is most well-known for its chemical seas and the unusual creatures that reside in them known as leviathans. The cities of Aemaq float above its chemical oceans on complicated magpulse-based platforms designed by the Republic, and are centered around harvesting chemicals from the Aemaqii Ocean. Many of the Non-Citizen Persons on Aemaq are refugees from the Empire of Dominia's frontier conquests who have nowhere else to go, and must work in Aemaq's chemical industry to make ends meet."
	possible_accents = list(ACCENT_AEMAQ)
	possible_citizenships = list(CITIZENSHIP_ELYRA)
	possible_religions = RELIGIONS_ELYRA
	origin_traits = ORIGIN_TRAIT_IGNORE_CAPSAICIN

/decl/origin_item/origin/new_suez
	name = "New Suez"
	desc = "Persepolis' only moon, New Suez is the only location in the Republic where foreign megacorporations are allowed to host their headquarters. This has made the moon into an economic and trade hub of Elyra, and has created a unique fusion of Elyran and foreign culture on the moon itself. New Suez has one of the largest populations of Non-Citizen Persons of any Elyran population, with Elyran citizens only making up roughly a third of its total population."
	possible_accents = list(ACCENT_NEWSUEZ)
	possible_citizenships = list(CITIZENSHIP_ELYRA)
	possible_religions = RELIGIONS_ELYRA

/decl/origin_item/origin/other_elyran
	name = "Other Elyran"
	desc = "The Republic controls many worlds, from mostly-barren mining colonies on asteroids to the frigid climate of Bursa to the bustling capital of Persepolis. The citizens of these worlds and colonies are unified by their loyalty to the Republic and Elyra's unique culture, which has been influenced by its roots upon Earth."
	possible_accents = list(ACCENT_ELYRA)
	possible_citizenships = list(CITIZENSHIP_ELYRA)
	possible_religions = RELIGIONS_ELYRA