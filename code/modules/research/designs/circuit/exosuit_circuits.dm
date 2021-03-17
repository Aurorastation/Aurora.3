/datum/design/circuit/exosuit
	p_category = "Exosuit Software Designs"

/datum/design/circuit/exosuit/AssembleDesignDesc()
	if(!build_path)
		desc = "A circuitboard that contains exosystems software."
		return
	var/obj/item/circuitboard/exosystem/CB = new build_path
	var/list/softwares = CB.contains_software
	desc = "Contains software suited for: "
	for(var/i = 1 to softwares.len)
		desc += "<b>[capitalize_first_letters(softwares[i])]</b>"
		if(length(softwares) != i)
			desc += ", "

/datum/design/circuit/exosuit/engineering
	name = "Engineering System Control"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/exosystem/engineering

/datum/design/circuit/exosuit/utility
	name = "Utility System Control"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/exosystem/utility

/datum/design/circuit/exosuit/medical
	name = "Medical System Control"
	req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/circuitboard/exosystem/medical

/datum/design/circuit/exosuit/weapons
	name = "Basic Weapon Control"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/exosystem/weapons