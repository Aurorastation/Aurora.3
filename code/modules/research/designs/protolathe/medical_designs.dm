/datum/design/item/medical
	materials = list(DEFAULT_WALL_MATERIAL = 30, MATERIAL_GLASS = 20)
	design_order = 4

/datum/design/item/medical/AssembleDesignName()
	..()
	name = "Biotech Device Design ([item_name])"

/datum/design/item/medical/health_analyzer
	name = "Health Analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	req_tech = list(TECH_MAGNET = 2, TECH_BIO = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 200)
	build_path = /obj/item/device/healthanalyzer

/datum/design/item/medical/robot_scanner
	name = "Robot Analyzer"
	desc = "A hand-held scanner able to diagnose robotic injuries."
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 500, MATERIAL_GLASS = 200)
	build_path = /obj/item/device/robotanalyzer

/datum/design/item/medical/mass_spectrometer
	name = "Mass Spectrometer"
	desc = "A device for analyzing chemicals in blood."
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/device/mass_spectrometer

/datum/design/item/medical/adv_mass_spectrometer
	name = "Advanced Mass Spectrometer"
	desc = "A device for analyzing chemicals in blood and their quantities."
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/device/mass_spectrometer/adv

/datum/design/item/medical/reagent_scanner
	name = "Reagent Scanner"
	desc = "A device for identifying chemicals."
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/device/reagent_scanner

/datum/design/item/medical/adv_reagent_scanner
	name = "Advanced Reagent Scanner"
	desc = "A device for identifying chemicals and their proportions."
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/device/reagent_scanner/adv

/datum/design/item/medical/nanopaste
	name = "Nanopaste"
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 7000, MATERIAL_GLASS = 7000)
	build_path = /obj/item/stack/nanopaste

/datum/design/item/medical/scalpel_laser1
	name = "Basic Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks basic and could be improved."
	req_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 12500, MATERIAL_GLASS = 7500)
	build_path = /obj/item/surgery/scalpel/laser1

/datum/design/item/medical/scalpel_laser2
	name = "Improved Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks somewhat advanced."
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 12500, MATERIAL_GLASS = 7500, MATERIAL_SILVER = 2500)
	build_path = /obj/item/surgery/scalpel/laser2

/datum/design/item/medical/scalpel_laser3
	name = "Advanced Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks to be the pinnacle of precision energy cutlery!"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 6, TECH_MAGNET = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 12500, MATERIAL_GLASS = 7500, MATERIAL_SILVER = 2000, MATERIAL_GOLD = 1500)
	build_path = /obj/item/surgery/scalpel/laser3

/datum/design/item/medical/scalpel_manager
	name = "Incision Management System"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 7, TECH_MAGNET = 5, TECH_DATA = 4)
	materials = list (DEFAULT_WALL_MATERIAL = 12500, MATERIAL_GLASS = 7500, MATERIAL_SILVER = 1500, MATERIAL_GOLD = 1500, MATERIAL_DIAMOND = 750)
	build_path = /obj/item/surgery/scalpel/manager

/datum/design/item/medical/inhaler
	name = "Inhaler"
	desc = "A very basic personal inhaler that directly injects chemicals into the lungs using a basic cartridge aerosol method."
	req_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/personal_inhaler

/datum/design/item/medical/inhaler_combat
	name = "Combat Inhaler"
	desc = "An improved inhaler design that injects the entirety of the chemicals in the loaded cartridge in a single button press."
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4, TECH_ENGINEERING = 4 )
	materials = list(DEFAULT_WALL_MATERIAL = 6000, MATERIAL_GLASS = 3000, MATERIAL_SILVER = 1500)
	build_path = /obj/item/personal_inhaler/combat

/datum/design/item/medical/inhaler_cartridge_small
	name = "Small Inhaler Cartridge"
	desc = "A small aerosol cartridge that can hold a small amount of chemicals. For use in an inhaler."
	req_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 500)
	build_path = /obj/item/reagent_containers/personal_inhaler_cartridge

/datum/design/item/medical/inhaler_cartridge_large
	name = "Large Inhaler Cartridge"
	desc = "A large aerosol cartridge that can hold a decent amount of chemicals. For use in an inhaler."
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 500, MATERIAL_SILVER = 500)
	build_path = /obj/item/reagent_containers/personal_inhaler_cartridge/large

/datum/design/item/medical/inhaler_cartridge_bluespace
	name = "Bluespace Inhaler Cartridge"
	desc = "A bluespace aerosol cartridge that can hold a robust amount of chemicals. For use in an inhaler."
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6, TECH_BIO = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, MATERIAL_PHORON = 3000, MATERIAL_DIAMOND = 500)
	build_path = /obj/item/reagent_containers/personal_inhaler_cartridge/bluespace

/datum/design/item/beaker
	design_order = 4.1

/datum/design/item/beaker/AssembleDesignName()
	name = "Advanced Beaker Design ([item_name])"

/datum/design/item/beaker/noreact
	name = "Cryostasis"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	req_tech = list(TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/reagent_containers/glass/beaker/noreact

/datum/design/item/beaker/bluespace
	name = "Bluespace"
	desc = "A bluespace beaker, powered by experimental bluespace technology and Element Cuban combined with the Compound Pete. Can hold up to 300 units."
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, MATERIAL_PHORON = 3000, MATERIAL_DIAMOND = 500)
	build_path = /obj/item/reagent_containers/glass/beaker/bluespace