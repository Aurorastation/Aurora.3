/obj/machinery/suit_cycler/engineering
	name = "engineering suit cycler"
	model_text = "Engineering"
	req_access = list(access_construction)
	departments = list("Engineering", "Atmos")
	species = list(BODYTYPE_HUMAN, BODYTYPE_SKRELL, BODYTYPE_UNATHI, BODYTYPE_TAJARA, BODYTYPE_VAURCA, BODYTYPE_IPC)

/obj/machinery/suit_cycler/engineering/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/engineering
	suit = /obj/item/clothing/suit/space/void/engineering
	boots = /obj/item/clothing/shoes/magboots
	mask = /obj/item/clothing/mask/breath

/obj/machinery/suit_cycler/engineering/prepared/atmos
	helmet = /obj/item/clothing/head/helmet/space/void/atmos
	suit = /obj/item/clothing/suit/space/void/atmos

/obj/machinery/suit_cycler/mining
	name = "mining suit cycler"
	model_text = "Mining"
	req_access = list(access_mining)
	departments = list("Mining")
	species = list(BODYTYPE_HUMAN, BODYTYPE_SKRELL, BODYTYPE_UNATHI, BODYTYPE_TAJARA, BODYTYPE_VAURCA, BODYTYPE_IPC)

/obj/machinery/suit_cycler/mining/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/mining
	suit = /obj/item/clothing/suit/space/void/mining
	boots = /obj/item/clothing/shoes/magboots
	mask = /obj/item/clothing/mask/breath

/obj/machinery/suit_cycler/security
	name = "security suit cycler"
	model_text = "Security"
	req_access = list(access_security)
	departments = list("Security")

/obj/machinery/suit_cycler/security/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/security
	suit = /obj/item/clothing/suit/space/void/security
	boots = /obj/item/clothing/shoes/magboots
	mask = /obj/item/clothing/mask/breath

/obj/machinery/suit_cycler/medical
	name = "medical suit cycler"
	model_text = "Medical"
	req_access = list(access_medical)
	departments = list("Medical")

/obj/machinery/suit_cycler/medical/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/medical
	suit = /obj/item/clothing/suit/space/void/medical
	boots = /obj/item/clothing/shoes/magboots
	mask = /obj/item/clothing/mask/breath

/obj/machinery/suit_cycler/syndicate
	name = "non-standard suit cycler"
	model_text = "Nonstandard"
	req_access = list(access_syndicate)
	departments = list("Mercenary")
	can_repair = TRUE

/obj/machinery/suit_cycler/syndicate/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/merc
	suit = /obj/item/clothing/suit/space/void/merc
	boots = /obj/item/clothing/shoes/magboots
	mask = /obj/item/clothing/mask/breath

/obj/machinery/suit_cycler/wizard
	name = "magic suit cycler"
	model_text = "Wizardry"
	req_access = null
	departments = list("Wizardry")
	species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_SKRELL, BODYTYPE_UNATHI, BODYTYPE_IPC)
	can_repair = TRUE

/obj/machinery/suit_cycler/hos
	name = "head of security suit cycler"
	model_text = "head of Security"
	req_access = list(access_hos)
	departments = list("Head of Security") // ONE MAN DEPARTMENT HOO HA GIMME CRAYONS - Geeves
	species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_SKRELL, BODYTYPE_UNATHI, BODYTYPE_IPC)
	can_repair = TRUE

/obj/machinery/suit_cycler/hos/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/hos
	suit = /obj/item/clothing/suit/space/void/hos
	boots = /obj/item/clothing/shoes/magboots
	mask = /obj/item/clothing/mask/breath

/obj/machinery/suit_cycler/captain
	name = "captain suit cycler"
	model_text = "Captain"
	req_access = list(access_captain)
	departments = list("Captain")
	species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_SKRELL, BODYTYPE_UNATHI, BODYTYPE_IPC)
	can_repair = TRUE

/obj/machinery/suit_cycler/captain/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/captain
	suit = /obj/item/clothing/suit/space/void/captain
	boots = /obj/item/clothing/shoes/magboots
	mask = /obj/item/clothing/mask/breath

/obj/machinery/suit_cycler/science
	name = "research suit cycler"
	model_text = "Research"
	req_access = list(access_research)
	departments = list("Research")
	species = list(BODYTYPE_HUMAN, BODYTYPE_SKRELL, BODYTYPE_UNATHI, BODYTYPE_TAJARA, BODYTYPE_VAURCA, BODYTYPE_IPC)
	can_repair = TRUE

/obj/machinery/suit_cycler/science/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/sci
	suit = /obj/item/clothing/suit/space/void/sci
	boots = /obj/item/clothing/shoes/magboots
	mask = /obj/item/clothing/mask/breath

/obj/machinery/suit_cycler/freelancer
	name = "freelancers suit cycler"
	model_text = "Freelancers"
	req_access = list(access_distress)
	departments = list("Freelancers")
	species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_SKRELL, BODYTYPE_UNATHI, BODYTYPE_IPC)
	can_repair = TRUE

/obj/machinery/suit_cycler/freelancer/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/freelancer
	suit = /obj/item/clothing/suit/space/void/freelancer
	boots = /obj/item/clothing/shoes/magboots
	mask = /obj/item/clothing/mask/breath
