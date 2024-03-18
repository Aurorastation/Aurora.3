/datum/ghostspawner/human/ert/izweski
	name = "Izweski Navy Crewman"
	short_name = "ertizweski"
	desc = "A soldier of the Izweski Hegemony response team."
	max_count = 2
	outfit = /obj/outfit/admin/ert/izweski
	uses_species_whitelist = FALSE // Anyone should be able to play an ERT Unathi
	possible_species = list(SPECIES_UNATHI)
	extra_languages = list(LANGUAGE_UNATHI)
	welcome_message = "You are a soldier of the Izweski Hegemony Navy, responding to a distress call. Obey the orders of your commander, and uphold the Warrior's Code."
	assigned_role = "Izweski Navy Crewman"

/datum/ghostspawner/human/ert/izweski/medic
	name = "Izweski Navy Healer"
	short_name = "ertizweskim"
	desc = "The medical specialist of the Izweski Hegemony response team."
	max_count = 1
	outfit = /obj/outfit/admin/ert/izweski/medic
	assigned_role = "Izweski Navy Medic"

/datum/ghostspawner/human/ert/izweski/klax
	name = "Izweski Navy K'laxan Warrior"
	short_name = "ertizweskik"
	desc = "A K'lax Vaurca Warrior, assigned to the Izweski Hegemony response team."
	max_count = 1
	outfit = /obj/outfit/admin/ert/izweski/klax
	possible_species = list(SPECIES_VAURCA_WARRIOR)
	extra_languages = list(LANGUAGE_VAURCA)

/datum/ghostspawner/human/ert/izweski/leader
	name = "Izweski Navy Squad Leader"
	short_name = "ertizweskil"
	desc = "The commander of the Izweski Hegemony response team."
	max_count = 1
	outfit = /obj/outfit/admin/ert/izweski/leader
	welcome_message = "You are the leader of an Izweski Hegemony naval squad, investigating a distress signal. Act with honor, and uphold the interests of the Hegemon."
	assigned_role = "Izweski Navy Officer"
