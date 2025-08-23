/datum/gear/augment
	display_name = "integrated timepiece"
	description = "An augment that allows the user to consult the time anywhere."
	path = /obj/item/organ/internal/augment/timepiece
	cost = 1
	augment = TRUE
	sort_category = "Augments"
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER, SPECIES_UNATHI)
	flags = GEAR_NO_SELECTION

/datum/gear/augment/eye_sensors
	display_name = "integrated eye sensors selection"
	description = "An eye augment that allows the user to deploy medical or security sensors."
	path = /obj/item/organ/internal/augment/eye_sensors
	cost = 1
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI, SPECIES_UNATHI, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT)
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/augment/eye_sensors/New()
	..()
	var/list/sensors = list()
	sensors["eye sensors, security"] = /obj/item/organ/internal/augment/eye_sensors/security
	sensors["eye sensors, medical"] = /obj/item/organ/internal/augment/eye_sensors/medical
	gear_tweaks += new /datum/gear_tweak/path(sensors)

/datum/gear/augment/cyber_hair
	display_name = "synthetic hair extensions"
	description = "A hair augment that allows the user to change the shape and color of their hair."
	path = /obj/item/organ/internal/augment/cyber_hair
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI, SPECIES_IPC_SHELL)
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/augment/synthetic_cords
	display_name = "synthetic vocal cords selection"
	description = "Vocal cords of synthetic nature packed into an augment kit. This allows users who are mute due to structural damage of the throat to speak. The advanced model allows use of normal accents, while the cheaper basic model will set your accent to text-to-speech."
	path = /obj/item/organ/internal/augment/synthetic_cords
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER, SPECIES_UNATHI)
	cost = 1
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/augment/synthetic_cords/New()
	..()
	var/list/augs = list()
	augs["synthetic vocal cords, basic"] = /obj/item/organ/internal/augment/synthetic_cords/voice
	augs["synthetic vocal cords, advanced"] = /obj/item/organ/internal/augment/synthetic_cords
	gear_tweaks += new /datum/gear_tweak/path(augs)

/datum/gear/augment/combitool
	display_name = "retractable combitool"
	description = "An augment that allows the user to deploy a robotic combitool."
	path = /obj/item/organ/internal/augment/tool/combitool
	cost = 5
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/augment/combitool/New()
	..()
	var/list/augs = list()
	augs["retractable combitool, right hand"] = /obj/item/organ/internal/augment/tool/combitool
	augs["retractable combitool, left hand"] = /obj/item/organ/internal/augment/tool/combitool/left
	gear_tweaks += new /datum/gear_tweak/path(augs)

/datum/gear/augment/lighter
	display_name = "retractable lighter"
	description = "An augment that allows the user to project a lighter out of their fingertip."
	path = /obj/item/organ/internal/augment/tool/combitool/lighter
	cost = 2
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/augment/lighter/New()
	..()
	var/list/augs = list()
	augs["retractable lighter, right hand"] = /obj/item/organ/internal/augment/tool/combitool/lighter
	augs["retractable lighter, left hand"] = /obj/item/organ/internal/augment/tool/combitool/lighter/left
	gear_tweaks += new /datum/gear_tweak/path(augs)

/datum/gear/augment/pen
	display_name = "retractable pen"
	description = "An augment that allows the user to deploy a retractable pen."
	path = /obj/item/organ/internal/augment/tool/pen
	cost = 1
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/augment/pen/New()
	..()
	var/list/augs = list()
	augs["retractable pen, right hand"] = /obj/item/organ/internal/augment/tool/pen
	augs["retractable pen, left hand"] = /obj/item/organ/internal/augment/tool/pen/left
	gear_tweaks += new /datum/gear_tweak/path(augs)

/datum/gear/augment/crayon
	display_name = "retractable crayon"
	description = "An augment that allows the user to deploy a retractable crayon."
	path = /obj/item/organ/internal/augment/tool/crayon
	cost = 1
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/augment/crayon/New()
	..()
	var/list/augs = list()
	augs["retractable crayon, right hand"] = /obj/item/organ/internal/augment/tool/crayon
	augs["retractable crayon, left hand"] = /obj/item/organ/internal/augment/tool/crayon/left
	gear_tweaks += new /datum/gear_tweak/path(augs)

/datum/gear/augment/cochlear
	display_name = "cochlear implant"
	description = "A synthetic replacement for the structures within the ear, allowing the user to hear without requiring external tools."
	path = /obj/item/organ/internal/augment/cochlear
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER, SPECIES_UNATHI)
	cost = 1
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/augment/analyzer
	display_name = "retractable cyborg analyzer"
	description = "An augment that allows the user to deploy a retractable cyborg analyzer."
	path = /obj/item/organ/internal/augment/tool/cyborg_analyzer
	allowed_roles = list("Machinist", "Operations Personnel")
	cost = 3
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/augment/analyzer/New()
	..()
	var/list/augs = list()
	augs["retractable cyborg analyzer, right hand"] = /obj/item/organ/internal/augment/tool/cyborg_analyzer
	augs["retractable cyborg analyzer, left hand"] = /obj/item/organ/internal/augment/tool/cyborg_analyzer/left
	gear_tweaks += new /datum/gear_tweak/path(augs)

/datum/gear/augment/health_scanner
	display_name = "integrated health scanner"
	description = "An augment that allows the user scan their own health condition."
	path = /obj/item/organ/internal/augment/health_scanner
	cost = 3
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/augment/suspension
	display_name = "calf suspension"
	description = "An augment that allows the wearer to jump further and slightly reduces the damage from falling from heights."
	path = /obj/item/organ/internal/augment/suspension
	cost = 4
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_IPC, SPECIES_IPC_XION, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WORKER, SPECIES_UNATHI)
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/augment/taste_boosters
	display_name = "taste booster selection"
	description = "A selection of augments that modify the user's taste sensitivity."
	path = /obj/item/organ/internal/augment/taste_booster
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER, SPECIES_UNATHI)
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/augment/taste_boosters/New()
	..()
	var/list/augs = list()
	augs["taste booster"] = /obj/item/organ/internal/augment/taste_booster
	augs["taste duller"] = /obj/item/organ/internal/augment/taste_booster/dull
	gear_tweaks += new /datum/gear_tweak/path(augs)

/datum/gear/augment/fuel_cell
	display_name = "integrated fuel cell"
	description = "An augment that allows the user to synthetize welding fuel into nutrients."
	path = /obj/item/organ/internal/augment/fuel_cell
	cost = 2
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/augment/psiaug
	display_name = "psionic receiver"
	description = "An augment installed into the head that functions as a surrogate for a missing zona bovinae, also functioning as a filter for the psionically-challenged."
	path = /obj/item/organ/internal/augment/psi
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI, SPECIES_UNATHI, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/augment/memory_inhibitor
	display_name = "memory inhibitor"
	description = "A Zeng Hu implant that allows one to have control over their memories, allowing you to set a timer and remove any memories developed within it."
	path = /obj/item/organ/internal/augment/memory_inhibitor
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_VAURCA_BULWARK, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI)
	faction = "Zeng-Hu Pharmaceuticals"
	allowed_roles = list("Physician", "Surgeon", "Chief Medical Officer", "Pharmacist", "Paramedic", "Psychiatrist", "Medical Intern", "Corporate Liaison", "Research Director","Scientist", "Xenobiologist", "Xenobotanist", "Xenoarchaeologist", "Research Intern", "Assistant", "Off-Duty Crew Member", "Corporate Reporter", "Captain", "Bridge Crew", "Medical Personnel", "Science Personnel")

/datum/gear/augment/emotional_manipulator
	display_name = "emotional manipulator"
	description = "A Zeng Hu brain implant to manipulate the brain's chemicals to induce a calming or happy feeling."
	path = /obj/item/organ/internal/augment/emotional_manipulator
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_VAURCA_BULWARK, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI)
	faction = "Zeng-Hu Pharmaceuticals"
	allowed_roles = list("Physician", "Surgeon", "Chief Medical Officer", "Pharmacist", "Paramedic", "Psychiatrist", "Medical Intern", "Corporate Liaison", "Research Director","Scientist", "Xenobiologist", "Xenobotanist", "Xenoarchaeologist", "Research Intern", "Assistant", "Off-Duty Crew Member", "Corporate Reporter", "Captain", "Bridge Crew", "Medical Personnel", "Science Personnel")

/datum/gear/augment/enhanced_vision
	display_name = "vision enhanced retinas"
	description = "Zeng Hu implants given to EMTs to assist with finding the injured. These eye implants allow one to see further than you normally could."
	path = /obj/item/organ/internal/augment/enhanced_vision
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_VAURCA_BULWARK, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	faction = "Zeng-Hu Pharmaceuticals"
	cost = 3
	allowed_roles = list("Physician", "Surgeon", "Chief Medical Officer", "Pharmacist", "Paramedic", "Psychiatrist", "Medical Intern", "Corporate Liaison", "Research Director","Scientist", "Xenobiologist", "Xenobotanist", "Xenoarchaeologist", "Research Intern", "Assistant", "Off-Duty Crew Member", "Corporate Reporter", "Captain", "Bridge Crew", "Medical Personnel", "Science Personnel")

/datum/gear/augment/sightlights
	display_name = "offbrand ocular sightlights"
	description = "Designed to assist personnel in darker areas or places experiencing periodic power issues, sightlights allow one to use their eyes as a flashlight. Later SCC-mediated negotiation loosened the augment's patent restrictions, allowing offbrand manufacture and use of lesser models by other members of the Chainlink."
	path = /obj/item/organ/internal/augment/sightlights
	cost = 3

/datum/gear/augment/sightlights/zenghu
	display_name = "Zeng-Hu ocular sightlights"
	description = "Designed to assist Zeng-Hu medical personnel in darker areas or places experiencing periodic power issues, Sightlights allow one to use their eyes as a flashlight. These are the original high-spec models available exclusively through Zeng-Hu."
	path = /obj/item/organ/internal/augment/sightlights/zenghu
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_VAURCA_BULWARK, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	faction = "Zeng-Hu Pharmaceuticals"
	allowed_roles = list("Physician", "Surgeon", "Chief Medical Officer", "Pharmacist", "Paramedic", "Psychiatrist", "Medical Intern", "Corporate Liaison", "Research Director","Scientist", "Xenobiologist", "Xenobotanist", "Xenoarchaeologist", "Research Intern", "Assistant", "Off-Duty Crew Member", "Corporate Reporter", "Captain", "Bridge Crew", "Medical Personnel", "Science Personnel")

/datum/gear/augment/zenghu_mask
	display_name = "zeng-hu facial augment selection"
	description = "A clear sign of Zeng-Hu's best, this plate bearing the company's symbol is installed on those who prove themselves in the hyper-competitive environment."
	path = /obj/item/organ/internal/augment/eye_sensors/medical/zenghu_plate
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_VAURCA_BULWARK, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	faction = "Zeng-Hu Pharmaceuticals"
	allowed_roles = list("Physician", "Surgeon", "Chief Medical Officer", "Pharmacist", "Paramedic", "Psychiatrist", "Medical Intern", "Corporate Liaison", "Research Director","Scientist", "Xenobiologist", "Xenobotanist", "Xenoarchaeologist", "Research Intern", "Assistant", "Off-Duty Crew Member", "Corporate Reporter", "Captain", "Bridge Crew", "Medical Personnel", "Science Personnel")

/datum/gear/augment/zenghu_mask/New()
	..()
	var/list/masks = list()
	masks["zeng-hu veterancy plate"] = /obj/item/organ/internal/augment/eye_sensors/medical/zenghu_plate
	masks["zeng-hu seniority mask"] = /obj/item/organ/internal/augment/eye_sensors/medical/zenghu_plate/mask
	gear_tweaks += new /datum/gear_tweak/path(masks)

/datum/gear/augment/corrective_lenses
	display_name = "retractable corrective lenses"
	description = "A set of corrective lenses that can be deployed & retracted."
	path = /obj/item/organ/internal/augment/tool/correctivelens
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/augment/glare_dampeners
	display_name = "retractable glare dampeners"
	description = "A subdermal implant installed just above the brow line that deploys a thin sheath of hyperpolycarbonate that protects from eye damage associated with arc flash."
	path = /obj/item/organ/internal/augment/tool/correctivelens/glare_dampener
	allowed_roles = list("Chief Engineer", "Engineer", "Atmospheric Technician", "Engineering Apprentice", "Machinist", "Engineering Personnel", "Operations Personnel")
	cost = 2
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/augment/drill
	display_name = "integrated drill"
	description = "A mining drill integrated in the hand. The drill is heavy enough that it is only usable by industrial IPCs, as well as Vaurca Bulwarks and Bound Workers."
	path = /obj/item/organ/internal/augment/tool/drill
	whitelisted = list(SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_WORKER)
	allowed_roles = list("Shaft Miner", "Operations Personnel")
	cost = 5
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/augment/head_fluff
	display_name = "custom head augmentation"
	description = "A fluff based augmentation that can be renamed/redescribed to appear as something else for RP purposes."
	path = /obj/item/organ/internal/augment/head_fluff
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER, SPECIES_UNATHI)

/datum/gear/augment/chest_fluff
	display_name = "custom chest augmentation"
	description = "A fluff based augmentation that can be renamed/redescribed to appear as something else for RP purposes."
	path = /obj/item/organ/internal/augment/head_fluff/chest_fluff
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER, SPECIES_UNATHI)

/datum/gear/augment/rhand_fluff
	display_name = "custom right hand augmentation"
	description = "A fluff based augmentation that can be renamed/redescribed to appear as something else for RP purposes."
	path = /obj/item/organ/internal/augment/head_fluff/rhand_fluff
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER, SPECIES_UNATHI)

/datum/gear/augment/lhand_fluff
	display_name = "custom left hand augmentation"
	description = "A fluff based augmentation that can be renamed/redescribed to appear as something else for RP purposes."
	path = /obj/item/organ/internal/augment/head_fluff/lhand_fluff
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER, SPECIES_UNATHI)

/datum/gear/augment/skrell_language
	display_name = "Zeng-Hu Nral'malic language processor"
	description = "An augmentation developed by Zeng-Hu Pharmaceuticals' Nralakk Division to enable the recipient to understand the complex and inaudible tones of Nral'malic."
	path = /obj/item/organ/internal/augment/language/zeng
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)
	faction = "Zeng-Hu Pharmaceuticals"
	allowed_roles = list("Physician", "Surgeon", "Chief Medical Officer", "Pharmacist", "Paramedic", "Psychiatrist", "Medical Intern", "Corporate Liaison", "Research Director","Scientist", "Xenobiologist", "Xenobotanist", "Xenoarchaeologist", "Research Intern", "Assistant", "Off-Duty Crew Member", "Corporate Reporter", "Captain", "Bridge Crew", "Medical Personnel", "Science Personnel")
	cost = 3

/datum/gear/augment/phalanx_plate
	display_name = "phalanx facial plate"
	description = "This modular face plate accommodates a wide array of cybernetic augmentations, enabling seamless integration with Phalanx's transhumanist doctrine. Enhanced sensory overlays and HUDs offer Phalanx members superior situational awareness and promote a sense of hive-thinking."
	path = /obj/item/organ/internal/augment/eye_sensors/phalanx
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_VAURCA_BULWARK, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI)
	allowed_roles = list("Physician", "Surgeon", "Pharmacist", "Paramedic", "Psychiatrist", "Medical Intern", "Medical Personnel", "Security Officer", "Warden", "Security Cadet", "Investigator", "Security Personnel", "Corporate Liaison", "Assistant", "Off-Duty Crew Member", "Corporate Reporter", "Bridge Crew")
	faction = "Private Military Contracting Group"
	cost = 1

/datum/gear/augment/vekatak_hivenet
	display_name = "Ve'katak Phalanx Hivenet receiver"
	description = "An experimental augment developed for the non-Vaurca members of the Ve'katak Phalanx, allowing them to receive Hivenet transmissions and send preset messages."
	path = /obj/item/organ/internal/augment/language/vekatak
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_UNATHI)
	faction = "Private Military Contracting Group"
	cost = 4
	allowed_roles = list("Physician", "Surgeon", "Pharmacist", "Paramedic", "Psychiatrist", "Medical Intern", "Medical Personnel", "Security Officer", "Warden", "Security Cadet", "Investigator", "Security Personnel", "Corporate Liaison", "Assistant", "Off-Duty Crew Member", "Corporate Reporter", "Bridge Crew")

/datum/gear/augment/auxiliary_heart
	display_name = "Auxiliary Heart"
	description = "Primarily intended for soldiers and the elderly, the auxiliary heart is a small secondary heart implanted below the original. Should the original heart shut down, the secondary heart will activate, keeping the user alive until the original can be restarted or replaced."
	path = /obj/item/organ/internal/augment/bioaug/auxiliary_heart
	origin_restriction = list(/singleton/origin_item/origin/galatea)
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)
	cost = 2

/datum/gear/augment/boosted_heart
	display_name = "Boosted Heart"
	description = "Intended for athletes, some workers, and soldiers, this improved heart increases blood flow and circulation. It provides an improvement to blood oxygenation and stamina, at the cost of requiring more food and water. Outside of Galatea, this augment is popular among professional athletes."
	path = /obj/item/organ/internal/heart/boosted_heart
	origin_restriction = list(/singleton/origin_item/origin/galatea)
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)
	cost = 3

/datum/gear/augment/boosted_liver
	display_name = "Boosted Liver"
	description = "Designed primarily for diplomats or Galateans abroad, the boosted liver improves toxin filtering, giving a resistance to toxin damage. As a consequence, it makes it impossible for the user to get drunk."
	path = /obj/item/organ/internal/liver/boosted_liver
	origin_restriction = list(/singleton/origin_item/origin/galatea)
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)
	cost = 2

/datum/gear/augment/mind_blanker
	display_name = "Galatean Mind Blanker"
	description = "A small, discrete organ attached near the base of the brainstem. Any attempt to read the mind of an individual with this augment installed will fail, as will attempts at psychic brainwashing."
	path = /obj/item/organ/internal/augment/bioaug/mind_blanker
	origin_restriction = list(/singleton/origin_item/origin/galatea)
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)
	cost = 2

/datum/gear/augment/mind_blanker_lethal
	display_name = "Galatean Mind Blanker (Lethal)"
	description = "Available only to higher-up MfAS agents and members of the Galatean government. This enhanced variant of a mind blanker introduces a psionic trap which inflicts severe neural damage on anyone attempting to read the user's mind."
	path = /obj/item/organ/internal/augment/bioaug/mind_blanker_lethal
	origin_restriction = list(/singleton/origin_item/origin/galatea)
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)
	cost = 4
	allowed_roles = list("Consular Officer")

/datum/gear/augment/bio_head_fluff
	display_name = "custom head bioaug"
	description = "A fluff based bioaug that can be renamed/redescribed to appear as something else for RP purposes."
	path = /obj/item/organ/internal/augment/bioaug/head_fluff
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
	origin_restriction = list(/singleton/origin_item/origin/galatea)
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)

/datum/gear/augment/bio_chest_fluff
	display_name = "custom chest bioaug"
	description = "A fluff based bioaug that can be renamed/redescribed to appear as something else for RP purposes."
	path = /obj/item/organ/internal/augment/bioaug/head_fluff/chest_fluff
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
	origin_restriction = list(/singleton/origin_item/origin/galatea)
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)

/datum/gear/augment/bio_rhand_fluff
	display_name = "custom right hand bioaug"
	description = "A fluff based bioaug that can be renamed/redescribed to appear as something else for RP purposes."
	path = /obj/item/organ/internal/augment/bioaug/head_fluff/rhand_fluff
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
	origin_restriction = list(/singleton/origin_item/origin/galatea)
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)

/datum/gear/augment/bio_lhand_fluff
	display_name = "custom left hand bioaug"
	description = "A fluff based bioaug that can be renamed/redescribed to appear as something else for RP purposes."
	path = /obj/item/organ/internal/augment/bioaug/head_fluff/lhand_fluff
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
	origin_restriction = list(/singleton/origin_item/origin/galatea)
	whitelisted = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)
