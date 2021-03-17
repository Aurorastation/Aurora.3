/datum/gear/computer
	display_name = "tablet"
	path = /obj/item/modular_computer/handheld/custom_loadout/cheap
	sort_category = "Modular Computers"
	cost = 2

/datum/gear/computer/laptop
	display_name = "laptop computer"
	path = /obj/item/modular_computer/laptop/preset
	cost = 3

/datum/gear/computer/handheld/wristbound
	display_name = "wristbound computer"
	path = /obj/item/modular_computer/handheld/wristbound/preset/cheap/generic

/datum/gear/computer/handheld/wristbound/cargo
	display_name = "wristbound computer (Cargo)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/cargo
	allowed_roles = list("Cargo Technician", "Shaft Miner", "Quartermaster")

/datum/gear/computer/handheld/wristbound/engineering
	display_name = "wristbound computer (Engineering)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/engineering
	allowed_roles = list("Station Engineer", "Engineering Apprentince", "Atmospheric Technician", "Engineering Apprentice")

/datum/gear/computer/handheld/wristbound/medical
	display_name = "wristbound computer (Medical)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/medical
	allowed_roles = list("Physician", "Surgeon", "Medical Intern", "Pharmacist", "Psychiatrist", "First Responder")

/datum/gear/computer/handheld/wristbound/security
	display_name = "wristbound computer (Security)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/security
	allowed_roles = list("Security Officer", "Warden", "Security Cadet")

/datum/gear/computer/handheld/wristbound/security/investigations
	display_name = "wristbound computer (Security Investigations)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/security/investigations
	allowed_roles = list("Investigator")

/datum/gear/computer/handheld/wristbound/security/research
	display_name = "wristbound computer (Research)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/research
	allowed_roles = list("Scientist", "Lab Assistant", "Roboticist", "Xenobiologist")

/datum/gear/computer/handheld/wristbound/ce
	display_name = "wristbound computer (Chief Engineer)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/command/ce
	allowed_roles = list("Chief Engineer")

/datum/gear/computer/handheld/wristbound/rd
	display_name = "wristbound computer (Research Director)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/command/rd
	allowed_roles = list("Research Director")

/datum/gear/computer/handheld/wristbound/cmo
	display_name = "wristbound computer (Chief Medical Officer)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/command/cmo
	allowed_roles = list("Chief Medical Officer")

/datum/gear/computer/handheld/wristbound/hop
	display_name = "wristbound computer (Head of Personnel)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/command/hop
	allowed_roles = list("Head of Personnel")

/datum/gear/computer/handheld/wristbound/hos
	display_name = "wristbound computer (Head of Security)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/command/hos
	allowed_roles = list("Head of Security")

/datum/gear/computer/handheld/wristbound/captain
	display_name = "wristbound computer (Captain)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/command/captain
	allowed_roles = list("Captain")
