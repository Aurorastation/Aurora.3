/datum/ghostspawner/human/ert/iac
	name = "IAC Doctor"
	short_name = "iacdoctor"
	mob_name_prefix = "Dr. "
	max_count = 2
	desc = "A highly trained doctor. Can do most medical procedures even under severe stress. The de-facto lead of the IAC response team."
	welcome_message = "You are part of the Interstellar Aid Corps, an intergalactic entity set on aiding all in need."
	outfit = /datum/outfit/admin/ert/iac
	possible_species = list("Human", "Off-Worlder Human", "Tajara", "M'sai Tajara", "Zhan-Khazan Tajara", "Skrell", "Diona", "Unathi", "Aut'akh Unathi", "Vaurca Warrior", "Vaurca Worker", "Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame")

/datum/ghostspawner/human/ert/iac/bodyguard
	name = "IAC Bodyguard"
	short_name = "iacbodyguard"
	mob_name_prefix = "Bdg. "
	max_count = 1
	desc = "A highly trained bodyguard. Sticks close to the medics while they work."
	outfit = /datum/outfit/admin/ert/iac/bodyguard

/datum/ghostspawner/human/ert/iac/paramedic
	name = "IAC Paramedic"
	short_name = "iacparamedic"
	mob_name_prefix = "Pm. "
	max_count = 2
	desc = "A highly trained paramedic. You grab injured people and bring them to the doctor. You are trained in nursing duties as well."
	outfit = /datum/outfit/admin/ert/iac/paramedic
