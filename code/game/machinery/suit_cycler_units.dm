/obj/machinery/suit_cycler/engineering
	name = "engineering suit cycler"
	model_text = "Engineering"
	req_access = list(ACCESS_CONSTRUCTION)
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
	req_access = list(ACCESS_MINING)
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
	req_access = list(ACCESS_SECURITY)
	departments = list("Security")

/obj/machinery/suit_cycler/security/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/security
	suit = /obj/item/clothing/suit/space/void/security
	boots = /obj/item/clothing/shoes/magboots
	mask = /obj/item/clothing/mask/breath

/obj/machinery/suit_cycler/medical
	name = "medical suit cycler"
	model_text = "Medical"
	req_access = list(ACCESS_MEDICAL)
	departments = list("Medical")

/obj/machinery/suit_cycler/medical/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/medical
	suit = /obj/item/clothing/suit/space/void/medical
	boots = /obj/item/clothing/shoes/magboots
	mask = /obj/item/clothing/mask/breath

/obj/machinery/suit_cycler/syndicate
	name = "non-standard suit cycler"
	model_text = "Nonstandard"
	req_access = list(ACCESS_SYNDICATE)
	departments = list("Mercenary", "Unchanged") //So the merc suit cycler can refit relevant suits
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
	req_access = list(ACCESS_HOS)
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
	req_access = list(ACCESS_CAPTAIN)
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
	req_access = list(ACCESS_RESEARCH)
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
	req_access = list(ACCESS_DISTRESS)
	departments = list("Freelancers")
	species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_SKRELL, BODYTYPE_UNATHI, BODYTYPE_IPC)
	can_repair = TRUE

/obj/machinery/suit_cycler/freelancer/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/freelancer
	suit = /obj/item/clothing/suit/space/void/freelancer
	boots = /obj/item/clothing/shoes/magboots
	mask = /obj/item/clothing/mask/breath

//Offship and ghostrole suit cyclers
/obj/machinery/suit_cycler/offship //To be set up for various offships
	model_text = "Unbranded"
	req_access = null
	departments = list("N/A")
	can_repair = TRUE
	rename_on_refit = FALSE
	species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC, BODYTYPE_SKRELL, BODYTYPE_UNATHI, BODYTYPE_VAURCA)
	boots = /obj/item/clothing/shoes/magboots
	mask = /obj/item/clothing/mask/breath

/obj/machinery/suit_cycler/offship/biesel
	model_text = "Zavodskoi Interstellar"
	req_access = list(ACCESS_TCAF_SHIPS)
	departments = list("Tau Ceti Armed Forces")
	suit = /obj/item/clothing/suit/space/void/tcaf
	helmet = /obj/item/clothing/head/helmet/space/void/tcaf

/obj/machinery/suit_cycler/offship/coc
	model_text = "Coalition"
	req_access = list(ACCESS_COALITION)
	departments = list("Vulture")
	species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC, BODYTYPE_SKRELL)
	suit = /obj/item/clothing/suit/space/void/coalition
	helmet = /obj/item/clothing/head/helmet/space/void/coalition

/obj/machinery/suit_cycler/offship/gadpathur
	model_text = "Gadpathurian Navy"
	req_access = list(ACCESS_GADPATHUR_NAVY)
	departments = list("Gadpathur")
	species = list(BODYTYPE_HUMAN)
	suit = /obj/item/clothing/suit/space/void/coalition/gadpathur
	helmet = /obj/item/clothing/head/helmet/space/void/coalition/gadpathur
	mask = /obj/item/clothing/mask/breath/gadpathur

/obj/machinery/suit_cycler/offship/dominia
	model_text = "Zhurong Imperial Shipyards"
	req_access = list(ACCESS_IMPERIAL_FLEET_VOIDSMAN_SHIP)
	departments = list("Dominia")
	species = list(BODYTYPE_HUMAN, BODYTYPE_UNATHI)
	suit = /obj/item/clothing/suit/space/void/dominia
	helmet = /obj/item/clothing/head/helmet/space/void/dominia

/obj/machinery/suit_cycler/offship/dominia/voidsman
	species = list(BODYTYPE_HUMAN)
	suit = /obj/item/clothing/suit/space/void/dominia/voidsman
	helmet = /obj/item/clothing/head/helmet/space/void/dominia/voidsman

/obj/machinery/suit_cycler/offship/dpra
	model_text = "People's Volunteer Spacer Militia"
	req_access = list(ACCESS_DPRA)
	departments = list("DPRA")
	species = list(BODYTYPE_TAJARA)
	suit = /obj/item/clothing/suit/space/void/dpra
	helmet = /obj/item/clothing/head/helmet/space/void/dpra

/obj/machinery/suit_cycler/offship/elyra
	model_text = "Elyran Naval Infantry"
	req_access = list(ACCESS_ELYRAN_NAVAL_INFANTRY_SHIP)
	departments = list("Elyra")
	species = list(BODYTYPE_HUMAN, BODYTYPE_IPC)
	suit = /obj/item/clothing/suit/space/void/valkyrie
	helmet = /obj/item/clothing/head/helmet/space/void/valkyrie

/obj/machinery/suit_cycler/offship/hegemony
	model_text = "Izweski Navy"
	req_access = list(ACCESS_KATAPHRACT)
	departments = list("Izweski Hegemony")
	species = list(BODYTYPE_UNATHI)
	suit = /obj/item/clothing/suit/space/void/hegemony
	helmet = /obj/item/clothing/head/helmet/space/void/hegemony
	boots = /obj/item/clothing/shoes/magboots/hegemony

/obj/machinery/suit_cycler/offship/hegemony/specialist
	suit = /obj/item/clothing/suit/space/void/hegemony/specialist
	helmet = /obj/item/clothing/head/helmet/space/void/hegemony/specialist

/obj/machinery/suit_cycler/offship/hegemony/priest
	suit = /obj/item/clothing/suit/space/void/hegemony/priest
	helmet = /obj/item/clothing/head/helmet/space/void/hegemony/priest

/obj/machinery/suit_cycler/offship/hegemony/captain
	req_access = list(ACCESS_KATAPHRACT_KNIGHT)
	suit = /obj/item/clothing/suit/space/void/hegemony/captain
	helmet = /obj/item/clothing/head/helmet/space/void/hegemony/captain

/obj/machinery/suit_cycler/offship/hephaestus
	model_text = "Hephaestus Industries"
	req_access = list(ACCESS_HEPHAESTUS)
	departments = list("Hephaestus")
	species = list(BODYTYPE_HUMAN, BODYTYPE_UNATHI)
	suit = /obj/item/clothing/suit/space/void/hephaestus
	helmet = /obj/item/clothing/head/helmet/space/void/hephaestus

/obj/machinery/suit_cycler/offship/kataphract
	model_text = "Kataphract Guild"
	req_access = list(ACCESS_KATAPHRACT)
	departments = list("Kataphract")
	species = list(BODYTYPE_UNATHI)
	suit = /obj/item/clothing/suit/space/void/kataphract
	helmet = /obj/item/clothing/head/helmet/space/void/kataphract
	boots = /obj/item/clothing/shoes/magboots/hegemony

/obj/machinery/suit_cycler/offship/kataphract/specialist
	req_access = list(ACCESS_KATAPHRACT_KNIGHT)
	suit = /obj/item/clothing/suit/space/void/kataphract/spec
	helmet = /obj/item/clothing/head/helmet/space/void/kataphract/spec

/obj/machinery/suit_cycler/offship/kataphract/lead
	req_access = list(ACCESS_KATAPHRACT_KNIGHT)
	suit = /obj/item/clothing/suit/space/void/kataphract/lead
	helmet = /obj/item/clothing/head/helmet/space/void/kataphract/lead

/obj/machinery/suit_cycler/offship/konyang
	model_text = "Konyang Aerospace Force"
	req_access = list(ACCESS_KONYANG_POLICE)
	departments = list("Konyang")
	species = list(BODYTYPE_HUMAN, BODYTYPE_IPC)
	suit = /obj/item/clothing/suit/space/void/sol/konyang
	helmet = /obj/item/clothing/head/helmet/space/void/sol/konyang

/obj/machinery/suit_cycler/offship/nka
	model_text = "Her Majesty's Mercantile Flotilla"
	req_access = list(ACCESS_NKA)
	departments = list("NKA")
	species = list(BODYTYPE_TAJARA)
	suit = /obj/item/clothing/suit/space/void/nka
	helmet = /obj/item/clothing/head/helmet/space/void/nka

/obj/machinery/suit_cycler/offship/pra
	model_text = "People's Republic of Adhomai"
	req_access = list(ACCESS_PRA)
	departments = list("PRA")
	species = list(BODYTYPE_TAJARA)
	suit = /obj/item/clothing/suit/space/void/pra
	helmet = /obj/item/clothing/head/helmet/space/void/pra

/obj/machinery/suit_cycler/offship/sol
	model_text = "Sol Alliance"
	req_access = list(ACCESS_SOL_SHIPS)
	departments = list("Sol")
	species = list(BODYTYPE_HUMAN)
	suit = /obj/item/clothing/suit/space/void/sol
	helmet = /obj/item/clothing/head/helmet/space/void/sol
	mask = /obj/item/clothing/mask/gas/half

/obj/machinery/suit_cycler/offship/sol/fsf
	suit = /obj/item/clothing/suit/space/void/sol/fsf
	helmet = /obj/item/clothing/head/helmet/space/void/sol/fsf

/obj/machinery/suit_cycler/offship/sol/sfa
	suit = /obj/item/clothing/suit/space/void/sol/sfa
	helmet = /obj/item/clothing/head/helmet/space/void/sol/sfa

/obj/machinery/suit_cycler/offship/sol/ssmd
	suit = /obj/item/clothing/suit/space/void/sol/ssmd
	helmet = /obj/item/clothing/head/helmet/space/void/sol/ssmd

/obj/machinery/suit_cycler/offship/sol/splf
	req_access = list(ACCESS_SPLF)
	suit = /obj/item/clothing/suit/space/void/sol/splf
	helmet = /obj/item/clothing/head/helmet/space/void/sol/splf

/obj/machinery/suit_cycler/offship/xanu
	model_text = "All-Xanu Spacefleet"
	req_access = list(ACCESS_COALITION_NAVY)
	departments = list("Xanu")
	species = list(BODYTYPE_HUMAN)
	suit = /obj/item/clothing/suit/space/void/coalition/xanu
	helmet = /obj/item/clothing/head/helmet/space/void/coalition/xanu

/obj/machinery/suit_cycler/offship/skrell
	model_text = "Qerr'Zolvq Industries"
	req_access = list(ACCESS_SKRELL)
	departments = list("Nralakk")
	species = list(BODYTYPE_SKRELL)
	mask = /obj/item/clothing/mask/breath/skrell

/obj/machinery/suit_cycler/offship/skrell/black
	suit = /obj/item/clothing/suit/space/void/skrell/black
	helmet = /obj/item/clothing/head/helmet/space/void/skrell/black

/obj/machinery/suit_cycler/offship/skrell/white
	suit = /obj/item/clothing/suit/space/void/skrell/white
	helmet = /obj/item/clothing/head/helmet/space/void/skrell/white

/obj/machinery/suit_cycler/offship/skrell/kala
	model_text = "Qukala"
	suit = /obj/item/clothing/suit/space/void/kala
	helmet = /obj/item/clothing/head/helmet/space/void/kala

/obj/machinery/suit_cycler/offship/skrell/kala/engineering
	suit = /obj/item/clothing/suit/space/void/kala/engineering
	helmet = /obj/item/clothing/head/helmet/space/void/kala/engineering

/obj/machinery/suit_cycler/offship/skrell/kala/med
	suit = /obj/item/clothing/suit/space/void/kala/med
	helmet = /obj/item/clothing/head/helmet/space/void/kala/med

/obj/machinery/suit_cycler/offship/skrell/kala/leader
	suit = /obj/item/clothing/suit/space/void/kala/leader
	helmet = /obj/item/clothing/head/helmet/space/void/kala/leader

/obj/machinery/suit_cycler/offship/tarwa
	model_text = "Tarwa Conglomerate"
	req_access = list(ACCESS_UNATHI_PIRATE)
	departments = list("Tarwa Conglomerate")
	species = list(BODYTYPE_UNATHI)
	suit = /obj/item/clothing/suit/space/void/unathi_pirate/tarwa
	helmet = /obj/item/clothing/head/helmet/space/void/unathi_pirate/tarwa

/obj/machinery/suit_cycler/offship/tarwa/captain
	suit = /obj/item/clothing/suit/space/void/unathi_pirate/tarwa/captain
	helmet = /obj/item/clothing/head/helmet/space/void/unathi_pirate/tarwa/captain

// For owned Golden Deep synthetics, Thesians, and other non-combatants.
/obj/machinery/suit_cycler/offship/golden_deep
	model_text = "Golden Deep"
	req_one_access = list(ACCESS_GOLDEN_DEEP_OWNED, ACCESS_GOLDEN_DEEP)
	departments = list("Golden Deep")
	species = list(BODYTYPE_IPC)
	suit = /obj/item/clothing/suit/space/void/golden_deep/menial
	helmet = /obj/item/clothing/head/helmet/space/void/golden_deep/menial

// For the Hoplan, armed guards of the ships of the Golden Deep.
/obj/machinery/suit_cycler/offship/golden_deep/hoplan
	model_text = "Golden Deep Hoplan"
	req_access = list(ACCESS_GOLDEN_DEEP)
	suit = /obj/item/clothing/suit/space/void/golden_deep/hoplan
	helmet = /obj/item/clothing/head/helmet/space/void/golden_deep/hoplan

// For merchants of the Golden Deep. Only they're rich enough, duh.
/obj/machinery/suit_cycler/offship/golden_deep/merchant
	model_text = "Golden Deep Merchant"
	req_access = list(ACCESS_GOLDEN_DEEP)
	suit = /obj/item/clothing/suit/space/void/golden_deep
	helmet = /obj/item/clothing/head/helmet/space/void/golden_deep

/obj/machinery/suit_cycler/offship/hiskyn
	model_text = "Hiskyn's Revanchists"
	req_access = list(ACCESS_UNATHI_PIRATE)
	departments = list("Hiskyn's Revanchists")
	species = list(BODYTYPE_UNATHI)
	suit = /obj/item/clothing/suit/space/void/unathi_pirate/hiskyn
	helmet = /obj/item/clothing/head/helmet/space/void/unathi_pirate/hiskyn

/obj/machinery/suit_cycler/offship/hiskyn/captain
	suit = /obj/item/clothing/suit/space/void/unathi_pirate/hiskyn/captain
	helmet = /obj/item/clothing/head/helmet/space/void/unathi_pirate/hiskyn/captain

// For the Himean Military vessel.
/obj/machinery/suit_cycler/offship/coalition/himeo
	model_text = "Himean Buzzard"
	req_access = list(ACCESS_HIMEO_PATROL_SHIP)
	departments = list("Himean Military")
	species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA)
	suit = /obj/item/clothing/suit/space/void/coalition/himeo
	helmet = /obj/item/clothing/head/helmet/space/void/coalition/himeo

/obj/machinery/suit_cycler/offship/coalition/himeo/engineer
	model_text = "Type-78 Fish Fur"
	req_access = list(ACCESS_HIMEO_PATROL_SHIP)
	departments = list("Himean Military")
	species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA)
	suit = /obj/item/clothing/suit/space/void/engineering/himeo
	helmet = /obj/item/clothing/head/helmet/space/void/engineering/himeo
