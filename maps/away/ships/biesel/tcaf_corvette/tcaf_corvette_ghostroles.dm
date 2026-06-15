/datum/ghostspawner/human/tcaf_crewman
	name = "TCAF Republic Astroforce Enlisted Crew"
	short_name = "tcaf_crewman"
	desc = "You are an enlisted crewmember aboard a Republic Astroforce patrol vessel. \
	It's been month since you've felt firm ground beneath your feet or enjoyed good food, \
	but your duties are essential for keeping the Republic safe from pirates and foreign incursions. \
	As a Legionnaire Immunis of the Republic Astroforce, you have specialist responsibilities aboard the vessel, \
	be it medical, engineering, weapons operation, or otherwise."
	tags = list("External")
	mob_name_prefix = "LgnI. "

	spawnpoints = list("tcaf_crewman")
	max_count = 2

	outfit = /obj/outfit/admin/tcaf_crewman
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "TCAF Republic Astroforce Enlisted Crew"
	special_role = "TCAF Republic Astroforce Enlisted Crew"
	respawn_flag = null

/obj/outfit/admin/tcaf_crewman
	name = "TCAF Republic Astroforce Enlisted Crew"
	uniform = /obj/item/clothing/under/tcaf/rate
	gloves = /obj/item/clothing/gloves/black
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/tcaf
	head = /obj/item/clothing/head/tcaf_rate
	id = /obj/item/card/id/tcaf
	accessory = /obj/item/clothing/accessory/holster/hip
	l_ear = /obj/item/radio/headset/ship
	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife = 1)

	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/jackboots/toeless, // Vaurca shoes look odd with the uniforms.
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_ATTENDANT = /obj/item/clothing/shoes/jackboots/toeless
	)

/obj/outfit/admin/tcaf_crewman/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
		H.update_body()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)
	if(isipc(H))
		var/obj/item/organ/internal/machine/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
		if(istype(tag))
			tag.modify_tag_data()

/obj/outfit/admin/tcaf_crewman/get_id_access()
	return list(ACCESS_TCAF, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/tcaf_crewman/espatier
	name = "TCAF Republic Astroforce Espatier"
	short_name = "tcaf_espatier"
	max_count = 2
	outfit = /obj/outfit/admin/tcaf_crewman/espatier
	// Excludes vaurca workers, as it's a combatant role.
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	mob_name_prefix = "LgnI. "
	desc = "You are an espatier aboard a Republic Astroforce patrol vessel. \
	It's been month since you've felt firm ground beneath your feet or enjoyed good food, \
	but your duties are essential for keeping the Republic safe from pirates and foreign incursions. \
	As a Legionnaire Immunis of the Republic Espatiers, you are responsible for boarding and vessel security \
	operations: inspect suspicious vessels and ensure the safety of your vessel's crew."
	assigned_role = "Republican Fleet Legionnaire (Armsman)"
	special_role = "Republican Fleet Legionnaire (Armsman)"

/obj/outfit/admin/tcaf_crewman/espatier
	name = "TCAF Republic Astroforce Espatier"
	head = /obj/item/clothing/head/softcap/tcaf_cap
	uniform = /obj/item/clothing/under/tcaf/espatier
	gloves = /obj/item/clothing/gloves/tcaf

/datum/ghostspawner/human/tcaf_crewman/nco
	name = "TCAF Republic Astroforce Prefect"
	short_name = "tcaf_nco"
	max_count = 1
	outfit = /obj/outfit/admin/tcaf_crewman/nco
	// Excludes vaurca workers, as it's a combatant role.
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	mob_name_prefix = "Pfct. "
	desc = "You are a Prefect of either the Republic Espatiers or Republic Astroforce. \
	Supervises your subordinate espatiers or enlisted rates and ensure the commanding officer's orders are carried out. \
	With exceptional work, you could see yourself assigned to a more comfortable vessel..."
	assigned_role = "TCAF Republic Astroforce Prefect"
	special_role = "TCAF Republic Astroforce Prefect"

/obj/outfit/admin/tcaf_crewman/nco
	head = /obj/item/clothing/head/softcap/tcaf_cap
	uniform = /obj/item/clothing/under/tcaf/rate
	accessory = /obj/item/clothing/accessory/holster/hip
	gloves = /obj/item/clothing/gloves/tcaf
	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife = 1, /obj/item/shield/energy/tcaf = 1, /obj/item/clothing/accessory/tcaf_prefect_pauldron = 1)

/datum/ghostspawner/human/tcaf_crewman/officer
	name = "TCAF Republic Astroforce Astrarch"
	short_name = "tcaf_officer"
	max_count = 1
	spawnpoints = list("tcaf_officer")
	outfit = /obj/outfit/admin/tcaf_crewman/officer
	// More limited species selection than the non-officer roles - humans, skrell, IPCs, and vaurca warriors.
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT)
	mob_name_prefix = "Arch. "
	desc = "You are an Astrarch, a commissioned officer, in command of a Republic Astroforce's patrol vessel. Your patrol task force is stretched thin across this region of space, relying on powerful sensor arrays and high mobility to surveil the Republic's territories and ensure the safety of its citizens. Police your assigned sector for piracy, smuggling and foreign incursions. Your crew are counting on you to see them back to Tau Ceti."
	assigned_role = "TCAF Republic Astroforce Astrarch"
	special_role = "TCAF Republic Astroforce Astrarch"

/obj/outfit/admin/tcaf_crewman/officer
	head = /obj/item/clothing/head/tcaf_officer
	uniform = /obj/item/clothing/under/tcaf_officer
	suit = /obj/item/clothing/suit/storage/toggle/tcaf_officer_greatcoat
	gloves = /obj/item/clothing/gloves/tcaf
	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife = 1, /obj/item/shield/energy/tcaf = 1, /obj/item/clothing/accessory/tcaf/astrarch = 1)
	accessory = /obj/item/clothing/accessory/holster/hip
