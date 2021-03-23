/datum/gear/augment
	display_name = "integrated timepiece"
	description = "An augment that allows the user to consult the time anywhere."
	path = /obj/item/organ/internal/augment/timepiece
	cost = 1
	augment = TRUE
	sort_category = "Augments"
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI, SPECIES_SKRELL, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR)
	flags = GEAR_NO_SELECTION

/datum/gear/augment/eye_sensors
	display_name = "integrated eye sensors"
	description = "An eye augment that allows the user to deploy medical or security sensors."
	path = /obj/item/organ/internal/augment/eye_sensors
	cost = 3
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI, SPECIES_UNATHI, SPECIES_SKRELL, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR)

/datum/gear/augment/cyber_hair
	display_name = "synthetic hair extensions"
	description = "A hair augment that allows the user to change the shape and color of their hair."
	path = /obj/item/organ/internal/augment/cyber_hair
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI, SPECIES_IPC_SHELL)

/datum/gear/augment/synthetic_cords
	display_name = "synthetic vocal cords"
	description = "Vocal cords of synthetic nature packed into an augment kit. This allows users who are mute due to structural damage of the throat to speak."
	path = /obj/item/organ/internal/augment/synthetic_cords
	cost = 1

/datum/gear/augment/combitool
	display_name = "retractable combitool"
	description = "An augment that allows the user to deploy a robotic combitool."
	path = /obj/item/organ/internal/augment/tool/combitool
	cost = 5

/datum/gear/augment/combitool/New()
	..()
	var/augs = list()
	augs["retractable combitool, right hand"] = /obj/item/organ/internal/augment/tool/combitool
	augs["retractable combitool, left hand"] = /obj/item/organ/internal/augment/tool/combitool/left
	gear_tweaks += new /datum/gear_tweak/path(augs)

/datum/gear/augment/lighter
	display_name = "retractable lighter"
	description = "An augment that allows the user to project a lighter out of their fingertip."
	path = /obj/item/organ/internal/augment/tool/combitool/lighter
	cost = 2

/datum/gear/augment/lighter/New()
	..()
	var/list/augs = list()
	augs["retractable lighter, right hand"] = /obj/item/organ/internal/augment/tool/combitool/lighter
	augs["retractable lighter, left hand"] = /obj/item/organ/internal/augment/tool/combitool/lighter/left
	gear_tweaks += new /datum/gear_tweak/path(augs)

/datum/gear/augment/cochlear
	display_name = "cochlear implant"
	description = "A synthetic replacement for the structures within the ear, allowing the user to hear without requiring external tools."
	path = /obj/item/organ/internal/augment/cochlear
	cost = 3

/datum/gear/augment/health_scanner
	display_name = "integrated health scanner"
	description = "An augment that allows the user scan their own health condition."
	path = /obj/item/organ/internal/augment/health_scanner
	cost = 3

/datum/gear/augment/suspension
	display_name = "calf suspension"
	description = "An augment that reduces the damage from falling from heights."
	path = /obj/item/organ/internal/augment/suspension
	cost = 4

/datum/gear/augment/taste_boosters
	display_name = "taste booster selection"
	description = "A selection of augments that modify the user's taste sensitivity."
	path = /obj/item/organ/internal/augment/taste_booster

/datum/gear/augment/taste_boosters/New()
	..()
	var/augs = list()
	augs["taste booster"] = /obj/item/organ/internal/augment/taste_booster
	augs["taste duller"] = /obj/item/organ/internal/augment/taste_booster/dull
	gear_tweaks += new /datum/gear_tweak/path(augs)

/datum/gear/augment/fuel_cell
	display_name = "integrated fuel cell"
	description = "An augment that allows the user to synthetize welding fuel into nutrients."
	path = /obj/item/organ/internal/augment/fuel_cell
	cost = 2

/datum/gear/augment/psiaug
	display_name = "psionic receiver"
	description = "An augment installed into the head that functions as a surrogate for a missing zona bovinae, also functioning as a filter for the psionically-challenged."
	path = /obj/item/organ/internal/augment/psi
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)

/datum/gear/augment/memory_inhibitor
	display_name = "memory inhibitor"
	description = "A Zeng Hu implant that allows one to have control over their memories, allowing you to set a timer and remove any memories developed within it."
	path = /obj/item/organ/internal/augment/memory_inhibitor
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_SKRELL)
	faction = "Zeng-Hu Pharmaceuticals"

/datum/gear/augment/emotional_manipulator
	display_name = "emotional manipulator"
	description = "A Zeng Hu brain implant to manipulate the brain's chemicals to induce a calming or happy feeling."
	path = /obj/item/organ/internal/augment/emotional_manipulator
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_SKRELL)
	faction = "Zeng-Hu Pharmaceuticals"

/datum/gear/augment/enhanced_vision
	display_name = "vision enhanced retinas"
	description = "Zeng Hu implants given to EMTs to assist with finding the injured. These eye implants allow one to see further than you normally could."
	path = /obj/item/organ/internal/augment/enhanced_vision
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_SKRELL, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	faction = "Zeng-Hu Pharmaceuticals"
	cost = 3

/datum/gear/augment/sightlights
	display_name = "ocular installed sightlights"
	description = "Designed to assist Zeng-Hu medical personnel in darker areas or places experiencing periodic power issues, Sightlights will allow one to be able to use their eyes as a flashlight."
	path = /obj/item/organ/internal/augment/sightlights
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_SKRELL, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	faction = "Zeng-Hu Pharmaceuticals"
	cost = 3

/datum/gear/augment/zenghu_plate
	display_name = "zeng-hu veterancy plate"
	description = "A clear sign of Zeng-Hu's best, this plate bearing the company's symbol is installed on those who prove themselves in the hyper-competitive environment"
	path = /obj/item/organ/internal/augment/zenghu_plate
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_SKRELL, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	faction = "Zeng-Hu Pharmaceuticals"
