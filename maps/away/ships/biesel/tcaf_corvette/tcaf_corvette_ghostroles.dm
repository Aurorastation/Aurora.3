/datum/ghostspawner/human/tcaf_crewman
	name = "Republican Fleet Technician"
	short_name = "tcaf_crewman"
	desc = "It's been a long patrol. It's been months since you're felt firm ground beneath your feet, longer since you've eaten enviable food, and the rumbling of the hull is starting to get to you. You are a TCAF Legionnaire Technician with medical and engineering responsibilities serving aboard a scout corvette. You load the guns, keep the engine going, keep the decks clean, and keep the crew alive. You are not expected to enter active combat in normal operations, but you must be prepared to do so under desperate circumstances. You may fight for patriotism, or for liberty, or perhaps only for yourself, but you will fight nonetheless; obey your commanding officer, clear the sector of pirate activity, and serve the Republic of Biesel."
	tags = list("External")
	mob_name_prefix = "Lgn. "

	spawnpoints = list("tcaf_crewman")
	max_count = 2

	outfit = /obj/outfit/admin/tcaf_crewman
	// Vaurca workers are only playable as technicians, as it's a primarily non-combatatant role. Think engineers and ammo loaders.
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Republican Fleet Legionnaire (Technician)"
	special_role = "Republican Fleet Legionnaire (Technician)"
	respawn_flag = null

/obj/outfit/admin/tcaf_crewman
	name = "TCAF Crewman"
	uniform = /obj/item/clothing/under/legion/tcaf/technician
	gloves = /obj/item/clothing/gloves/black
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/tcaf
	head = /obj/item/clothing/head/tcaf_technician
	id = /obj/item/card/id/tcaf
	accessory = /obj/item/clothing/accessory/holster/hip
	l_ear = /obj/item/device/radio/headset/ship
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
		var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
		if(istype(tag))
			tag.modify_tag_data()

/obj/outfit/admin/tcaf_crewman/get_id_access()
	return list(ACCESS_TCAF_SHIPS, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/tcaf_crewman/armsman
	name = "Republican Fleet Armsman"
	short_name = "tcaf_armsman"
	max_count = 2
	outfit = /obj/outfit/admin/tcaf_crewman/armsman
	// Excludes vaurca workers, as it's a combatant role.
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	mob_name_prefix = "Lgn. "
	desc = "It's been a long patrol. It's been months since you're felt firm ground beneath your feet, longer since you've eaten enviable food, and the rumbling of the hull is starting to get to you. You are a TCAF Legionnaire Armsman serving aboard a scout corvette, responsible to protect the crew of your ship in the event of a boarding action and to put yourself on the front lines in the event of combat. You may fight for patriotism, or for liberty, or perhaps only for yourself, but you will fight nonetheless; obey your commanding officer, clear the sector of pirate activity, and serve the Republic of Biesel."
	assigned_role = "Republican Fleet Legionnaire (Armsman)"
	special_role = "Republican Fleet Legionnaire (Armsman)"

/obj/outfit/admin/tcaf_crewman/armsman
	name = "TCAF Armsman"
	head = /obj/item/clothing/head/softcap/tcaf_cap
	uniform = /obj/item/clothing/under/legion/tcaf
	gloves = /obj/item/clothing/gloves/tcaf

/datum/ghostspawner/human/tcaf_crewman/nco
	name = "Republican Fleet Prefect"
	short_name = "tcaf_nco"
	max_count = 1
	outfit = /obj/outfit/admin/tcaf_crewman/nco
	// Excludes vaurca workers, as it's a combatant role.
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	mob_name_prefix = "Pfct. "
	desc = "It's been a long patrol. It's been months since you're felt firm ground beneath your feet, longer since you've eaten enviable food, and the rumbling of the hull is starting to get to you. You are a TCAF Prefect serving aboard a scout corvette, responsible for keeping the ship functioning smoothly in matters beneath the notice of the Decurion, your superior. You outrank the Legionnaires on-board, but you are not an officer. You may fight for patriotism, or for liberty, or perhaps only for yourself, but you will fight nonetheless; obey your commanding officer, clear the sector of pirate activity, and serve the Republic of Biesel."
	assigned_role = "Republican Fleet Prefect"
	special_role = "Republican Fleet Prefect"

/obj/outfit/admin/tcaf_crewman/nco
	head = /obj/item/clothing/head/softcap/tcaf_cap
	uniform = /obj/item/clothing/under/legion/tcaf
	accessory = /obj/item/clothing/accessory/holster/hip
	gloves = /obj/item/clothing/gloves/tcaf
	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife = 1, /obj/item/shield/energy/legion = 1, /obj/item/clothing/accessory/tcaf_prefect_pauldron = 1, /obj/item/clothing/accessory/legion = 1)

/datum/ghostspawner/human/tcaf_crewman/officer
	name = "Republican Fleet Decurion"
	short_name = "tcaf_officer"
	max_count = 1
	spawnpoints = list("tcaf_officer")
	outfit = /obj/outfit/admin/tcaf_crewman/officer
	// More limited species selection than the non-officer roles - humans, skrell, IPCs, and vaurca warriors.
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT)
	mob_name_prefix = "Dcn. "
	desc = "You are a Decurion, a commissioned officer, serving with the Tau Ceti Armed Forces in command of a corvette. The Republican Fleets are stretched thin across too much territory, with too few ships and too few men, too divided and too disparate to ensure the safety of its own citizens. You may command only one small vessel, but the fate of the Republic may lie in you and officers like you. You are the eyes and ears of the Republic of Biesel - police your assigned sector for piracy and smuggling, monitor neighbouring powers, and above all else, keep your crew alive. They're counting on you."
	assigned_role = "Republican Fleet Decurion"
	special_role = "Republican Fleet Decurion"

/obj/outfit/admin/tcaf_crewman/officer
	head = /obj/item/clothing/head/tcaf_officer
	uniform = /obj/item/clothing/under/legion/tcaf_officer
	suit = /obj/item/clothing/suit/storage/toggle/tcaf_officer_greatcoat
	gloves = /obj/item/clothing/gloves/tcaf
	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife = 1, /obj/item/shield/energy/legion = 1, /obj/item/clothing/accessory/legion = 1)
	accessory = /obj/item/clothing/accessory/holster/hip
