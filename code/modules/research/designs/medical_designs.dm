////////////////////////////////////////////
///////////Medical Designs/////////////////
////////////////////////////////////////////

/datum/design/item/medical
	materials = list(DEFAULT_WALL_MATERIAL = 30, "glass" = 20)

/datum/design/item/medical/AssembleDesignName()
	..()
	name = "Biotech device prototype ([item_name])"

/datum/design/item/medical/health_analyzer
	name = "Health Analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	id = "health_analyzer"
	req_tech = list(TECH_MAGNET = 2, TECH_BIO = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 200)
	build_path = /obj/item/device/healthanalyzer
	sort_string = "MBCAF"
	
/datum/design/item/medical/adv_health_analyzer/
	name = "Advanced Health Analyzer"
	desc = "An advanced hand-held body scanner able to accurately distinguish vital signs of the subject. Now in gold!"
	id = "adv_health_analyzer"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 250)
	build_path = /obj/item/device/healthanalyzer/adv
	sort_string = "MBCAG"

/datum/design/item/medical/robot_scanner
	desc = "A hand-held scanner able to diagnose robotic injuries."
	id = "robot_scanner"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 200)
	build_path = /obj/item/device/robotanalyzer
	sort_string = "MACFA"

/datum/design/item/medical/mass_spectrometer
	desc = "A device for analyzing chemicals in blood."
	id = "mass_spectrometer"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/device/mass_spectrometer
	sort_string = "MACAA"

/datum/design/item/medical/adv_mass_spectrometer
	desc = "A device for analyzing chemicals in blood and their quantities."
	id = "adv_mass_spectrometer"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/device/mass_spectrometer/adv
	sort_string = "MACAB"

/datum/design/item/medical/reagent_scanner
	desc = "A device for identifying chemicals."
	id = "reagent_scanner"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/device/reagent_scanner
	sort_string = "MACBA"

/datum/design/item/medical/adv_reagent_scanner
	desc = "A device for identifying chemicals and their proportions."
	id = "adv_reagent_scanner"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/device/reagent_scanner/adv
	sort_string = "MACBB"

/datum/design/item/beaker/AssembleDesignName()
	name = "Beaker prototype ([item_name])"

/datum/design/item/beaker/noreact
	name = "cryostasis"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	id = "splitbeaker"
	req_tech = list(TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/reagent_containers/glass/beaker/noreact
	sort_string = "MADAA"

/datum/design/item/beaker/bluespace
	name = TECH_BLUESPACE
	desc = "A bluespace beaker, powered by experimental bluespace technology and Element Cuban combined with the Compound Pete. Can hold up to 300 units."
	id = "bluespacebeaker"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "phoron" = 3000, "diamond" = 500)
	build_path = /obj/item/reagent_containers/glass/beaker/bluespace
	sort_string = "MADAB"

/datum/design/item/medical/nanopaste
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	id = "nanopaste"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 7000, "glass" = 7000)
	build_path = /obj/item/stack/nanopaste
	sort_string = "MBAAA"

/datum/design/item/scalpel_laser1
	name = "Basic Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks basic and could be improved."
	id = "scalpel_laser1"
	req_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 12500, "glass" = 7500)
	build_path = /obj/item/scalpel/laser1
	sort_string = "MBBAA"

/datum/design/item/scalpel_laser2
	name = "Improved Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks somewhat advanced."
	id = "scalpel_laser2"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 12500, "glass" = 7500, "silver" = 2500)
	build_path = /obj/item/scalpel/laser2
	sort_string = "MBBAB"

/datum/design/item/scalpel_laser3
	name = "Advanced Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks to be the pinnacle of precision energy cutlery!"
	id = "scalpel_laser3"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 6, TECH_MAGNET = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 12500, "glass" = 7500, "silver" = 2000, "gold" = 1500)
	build_path = /obj/item/scalpel/laser3
	sort_string = "MBBAC"

/datum/design/item/scalpel_manager
	name = "Incision Management System"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	id = "scalpel_manager"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 7, TECH_MAGNET = 5, TECH_DATA = 4)
	materials = list (DEFAULT_WALL_MATERIAL = 12500, "glass" = 7500, "silver" = 1500, "gold" = 1500, "diamond" = 750)
	build_path = /obj/item/scalpel/manager
	sort_string = "MBBAD"

/datum/design/item/medical/inhaler
	name = "Inhaler"
	desc = "A very basic personal inhaler that directly injects chemicals into the lungs using a basic cartridge aerosol method."
	id = "inhaler"
	req_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 1000)
	build_path = /obj/item/personal_inhaler
	sort_string = "MBCAA"

/datum/design/item/medical/inhaler_combat
	name = "Combat Inhaler"
	desc = "An improved inhaler design that injects the entirety of the chemicals in the loaded cartridge in a single button press."
	id = "inhaler_combat"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4, TECH_ENGINEERING = 4 )
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 3000, "silver" = 1500)
	build_path = /obj/item/personal_inhaler/combat
	sort_string = "MBCAB"

/datum/design/item/medical/inhaler_cartridge_small
	name = "Small Inhaler Cartridge"
	desc = "A small aerosol cartridge that can hold a small amount of chemicals. For use in an inhaler."
	id = "inhaler_cartridge_small"
	req_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 500)
	build_path = /obj/item/reagent_containers/personal_inhaler_cartridge
	sort_string = "MBCAC"

/datum/design/item/medical/inhaler_cartridge_large
	name = "Large Inhaler Cartridge"
	desc = "A large aerosol cartridge that can hold a decent amount of chemicals. For use in an inhaler."
	id = "inhaler_cartridge_large"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 500, "silver" = 500)
	build_path = /obj/item/reagent_containers/personal_inhaler_cartridge/large
	sort_string = "MBCAD"

/datum/design/item/medical/inhaler_cartridge_bluespace
	name = "Bluespace Inhaler Cartridge"
	desc = "A bluespace aerosol cartridge that can hold a robust amount of chemicals. For use in an inhaler."
	id = "inhaler_cartridge_bluespace"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6, TECH_BIO = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "phoron" = 3000, "diamond" = 500)
	build_path = /obj/item/reagent_containers/personal_inhaler_cartridge/bluespace
	sort_string = "MBCAE"