// Armbands
ABSTRACT_TYPE(/obj/item/clothing/accessory/armband)
	name = "armband parent item"
	desc = DESC_PARENT
	icon = 'icons/obj/item/clothing/accessory/armband.dmi'
	contained_sprite = TRUE
	flippable = TRUE
	slot = ACCESSORY_SLOT_ARMBAND

// Colourable
/obj/item/clothing/accessory/armband/colourable
	name = "armband"
	desc = "An armband in 16,777,216 designer colours."
	icon_state = "armband_colourable"
	item_state = "armband_colourable"

/obj/item/clothing/accessory/armband/colourable/double
	name = "double armband"
	desc = "A double armband in 16,777,216 designer colours."
	icon_state = "armband_colourable_double"
	item_state = "armband_colourable_double"
	flippable = FALSE

// Colours
/obj/item/clothing/accessory/armband/white
	name = "white armband"
	desc = "A white armband."
	icon_state = "armband_white"
	item_state = "armband_white"

/obj/item/clothing/accessory/armband/black
	name = "black armband"
	desc = "A black armband."
	icon_state = "armband_black"
	item_state = "armband_black"

/obj/item/clothing/accessory/armband/red
	name = "red armband"
	desc = "A red armband."
	icon_state = "armband_red"
	item_state = "armband_red"

// Departments
/obj/item/clothing/accessory/armband/science
	name = "research armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is purple."
	icon_state = "armband_research"
	item_state = "armband_research"

/obj/item/clothing/accessory/armband/med
	name = "medical armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is white and green."
	icon_state = "armband_medical"
	item_state = "armband_medical"

/obj/item/clothing/accessory/armband/engine
	name = "engineering armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is orange with a reflective strip!"
	icon_state = "armband_engineering"
	item_state = "armband_engineering"

/obj/item/clothing/accessory/armband/sec
	name = "security armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is navy blue."
	icon_state = "armband_security"
	item_state = "armband_security"

/obj/item/clothing/accessory/armband/hydro
	name = "hydroponics armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is green and blue."
	icon_state = "armband_hydroponics"
	item_state = "armband_hydroponics"

/obj/item/clothing/accessory/armband/operations
	name = "operations armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is brown."
	icon_state = "armband_operations"
	item_state = "armband_operations"

// Factions
/obj/item/clothing/accessory/armband/iac
	name = "\improper Interstellar Aid Corps armband"
	desc = "An armband denoting its wearer as a medical worker of the Interstellar Aid Corps. This one is white and blue."
	icon_state = "armband_iac"
	item_state = "armband_iac"

/obj/item/clothing/accessory/armband/idris
	name = "\improper Idris Incorporated armband"
	desc = "An armband, worn by contractors to denote which company they're from. This one shows the Idris Incorporated logo displayed on a cyan background."
	icon_state = "armband_idris"
	item_state = "armband_idris"

/obj/item/clothing/accessory/armband/pmc
	name = "\improper PMCG armband"
	desc = "An armband, worn by contractors to denote which company they're from. This one bears the Private Military Contractor Group logo."
	icon_state = "armband_pmcg"
	item_state = "armband_pmcg"

/obj/item/clothing/accessory/armband/pmc/alt
	icon_state = "armband_pmcg_alt"
	item_state = "armband_pmcg_alt"

/obj/item/clothing/accessory/armband/tauceti
	name = "\improper Tau Ceti armband"
	desc = "An armband tailored to look like the flag of the Republic of Biesel."
	desc_extended = "While initially adopted during the early days of the TCFL to account for a sudden increase in volunteers and a lack of uniforms, during the height of the Republic of Biesel's conflicts with the Sol Alliance, it has been worn as a symbol of independence and patriotism."
	icon_state = "armband_tau_ceti"
	item_state = "armband_tau_ceti"

/obj/item/clothing/accessory/armband/scc
	name = "\improper Stellar Corporate Conglomerate armband"
	desc = "An armband, tailored with all the colors of the Sellar Corporate Conglomerate."
	desc_extended = "The Stellar Corporate Conglomerate, also known as Chainlink, is a joint alliance between the NanoTrasen Corporation, Hephaestus Industries, Idris Incorporated, Zeng-Hu Pharmaceuticals and Zavodskoi Interstellar to exercise an undisputed economic dominance over the Orion Spur."
	icon_state = "armband_scc"
	item_state = "armband_scc"

// Offworlder
/obj/item/clothing/accessory/armband/offworlder
	name = "research exo-stellar ribbon"
	desc = "Durable cloth meant to be worn over or attached to the chest pieces of the ESS modules. This one is purple."
	icon = 'icons/obj/item/clothing/accessory/offworlder.dmi'
	icon_state = "ribbon_sci"
	flippable = FALSE
	slot = ACCESSORY_SLOT_CAPE

/obj/item/clothing/accessory/armband/offworlder/engineering
	name = "engineering exo-stellar ribbon"
	desc = "Durable cloth meant to be worn over or attached to the chest pieces of the ESS modules. This one is orange with a reflective strip."
	icon_state = "ribbon_engi"

/obj/item/clothing/accessory/armband/offworlder/medical
	name = "medical exo-stellar ribbon"
	desc = "Durable cloth meant to be worn over or attached to the chest pieces of the ESS modules. This one is white and green."
	icon_state = "ribbon_med"
