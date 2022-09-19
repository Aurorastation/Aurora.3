/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH
	virtual_mob = null

/mob/living/carbon/human/dummy/mannequin
	mob_thinks = FALSE

INITIALIZE_IMMEDIATE(/mob/living/carbon/human/dummy/mannequin)

/mob/living/carbon/human/dummy/mannequin/Initialize()
	. = ..()
	mob_list -= src
	living_mob_list -= src
	dead_mob_list -= src
	human_mob_list -= src
	delete_inventory()

/mob/living/carbon/human/skrell/Initialize(mapload)
	h_style = "Skrell Average Tentacles"
	. = ..(mapload, SPECIES_SKRELL)

/mob/living/carbon/human/tajaran/Initialize(mapload)
	h_style = "Tajaran Ears"
	. = ..(mapload, SPECIES_TAJARA)

/mob/living/carbon/human/unathi/Initialize(mapload)
	h_style = "Unathi Horns"
	. = ..(mapload, SPECIES_UNATHI)

/mob/living/carbon/human/diona/Initialize(mapload, new_species = null)
	. = ..(mapload, new_species || SPECIES_DIONA)
	src.gender = NEUTER

/mob/living/carbon/human/diona/coeus/Initialize(mapload)
	. = ..(mapload, SPECIES_DIONA_COEUS)
	src.gender = NEUTER

/mob/living/carbon/human/machine/Initialize(mapload)
	h_style = "blue IPC screen"
	. = ..(mapload, SPECIES_IPC)

/mob/living/carbon/human/monkey/Initialize(mapload)
	. = ..(mapload, SPECIES_MONKEY)

/mob/living/carbon/human/farwa/Initialize(mapload)
	. = ..(mapload, SPECIES_MONKEY_TAJARA)

/mob/living/carbon/human/neaera/Initialize(mapload)
	. = ..(mapload, SPECIES_MONKEY_SKRELL)

/mob/living/carbon/human/stok/Initialize(mapload)
	. = ..(mapload, SPECIES_MONKEY_UNATHI)

/mob/living/carbon/human/bug/Initialize(mapload)
	. = ..(mapload, SPECIES_MONKEY_VAURCA)
	src.gender = FEMALE

/mob/living/carbon/human/type_a/Initialize(mapload)
	h_style = "Classic Antennae"
	. = ..(mapload, SPECIES_VAURCA_WORKER)
	src.gender = NEUTER

/mob/living/carbon/human/type_a/cargo/Initialize(mapload)
	. = ..()
	// Equip mask to allow the drone to breathe
	equip_to_slot_or_del(new /obj/item/clothing/mask/breath/vaurca/filter(src), slot_wear_mask)
	// Set internals
	var/obj/item/organ/internal/vaurca/preserve/P = internal_organs_by_name[BP_PHORON_RESERVE]
	internal = P
	// Set colour, default is grey, no biggie
	var/list/hive = splittext(name, " ")
	switch(hive[length(hive)])
		if("K'lax")
			change_skin_color(33, 63, 33)
		if("C'thur")
			change_skin_color(10, 35, 55)
		if("Zo'ra")
			change_skin_color(111, 21, 21)

/mob/living/carbon/human/type_b/Initialize(mapload)
	h_style = "Classic Antennae"
	. = ..(mapload, SPECIES_VAURCA_WARRIOR)
	src.gender = NEUTER

/mob/living/carbon/human/type_c/Initialize(mapload)
	. = ..(mapload, SPECIES_VAURCA_BREEDER)
	src.gender = FEMALE

/mob/living/carbon/human/type_c
	layer = 5

/mob/living/carbon/human/type_big/Initialize(mapload)
	. = ..(mapload, SPECIES_VAURCA_WARFORM)
	src.gender = NEUTER
	src.mutations.Add(HULK)

/mob/living/carbon/human/type_big
	layer = 5

/mob/living/carbon/human/type_e/Initialize(mapload)
	. = ..(mapload, SPECIES_VAURCA_BULWARK)

/mob/living/carbon/human/type_e/equipped/Initialize(mapload)
	. = ..(mapload, SPECIES_VAURCA_BULWARK)
	species.before_equip(src)
	species.after_equip(src)

/mob/living/carbon/human/axiori_skrell/Initialize(mapload)
	h_style = "Skrell Average Tentacles"
	. = ..(mapload, SPECIES_SKRELL_AXIORI)

/mob/living/carbon/human/msai_tajara/Initialize(mapload)
	h_style = "Tajaran Ears"
	. = ..(mapload, SPECIES_TAJARA_MSAI)

/mob/living/carbon/human/zhankhazan_tajara/Initialize(mapload)
	h_style = "Tajaran Ears"
	. = ..(mapload, SPECIES_TAJARA_ZHAN)

/mob/living/carbon/human/industrial/Initialize(mapload)
	. = ..(mapload, SPECIES_IPC_G1)

/mob/living/carbon/human/shell/Initialize(mapload)
	. = ..(mapload, SPECIES_IPC_SHELL)

/mob/living/carbon/human/industrial_hephaestus/Initialize(mapload)
	. = ..(mapload, SPECIES_IPC_G2)

/mob/living/carbon/human/industrial_xion/Initialize(mapload)
	. = ..(mapload, SPECIES_IPC_XION)

/mob/living/carbon/human/industrial_xion_remote/Initialize(mapload)
	. = ..(mapload, SPECIES_IPC_XION_REMOTE)

	real_name = "Remote Robot [pick("Delta", "Theta", "Alpha")]-[rand(0, 999)]"
	name = real_name
	dna.real_name = real_name
	if(mind)
		mind.name = real_name
	status_flags |= NO_ANTAG

	remote_network = REMOTE_GENERIC_ROBOT
	SSvirtualreality.add_robot(src, remote_network)

/mob/living/carbon/human/industrial_xion_remote_mech/Initialize(mapload)
	. = ..(mapload, SPECIES_IPC_XION_REMOTE)

	real_name = "Remote Pilot [pick("Delta", "Theta", "Alpha")]-[rand(0, 999)]"
	name = real_name
	dna.real_name = real_name
	if(mind)
		mind.name = real_name
	status_flags |= NO_ANTAG

/mob/living/carbon/human/industrial_xion_remote_bunker/Initialize(mapload)
	. = ..(mapload, SPECIES_IPC_XION_REMOTE)

	real_name = "Remote Robot [pick("Greaves", "Chamberlain", "Slater")]-[rand(0, 999)]"
	name = real_name
	dna.real_name = real_name
	if(mind)
		mind.name = real_name
	status_flags |= NO_ANTAG

	equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(src), slot_wear_suit)
	equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(src), slot_shoes)
	equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_com(src), slot_l_ear)

	remote_network = REMOTE_BUNKER_ROBOT
	SSvirtualreality.add_robot(src, remote_network)

/mob/living/carbon/human/industrial_xion_remote_penal/Initialize(mapload)
	. = ..(mapload, "Remote Xion Industrial Frame")

	real_name = "Remote Robot [pick("Jim", "Slart", "Whacker")]-[rand(0, 999)]"
	name = real_name
	dna.real_name = real_name
	if(mind)
		mind.name = real_name
	status_flags |= NO_ANTAG

	equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_penal(src), slot_l_ear)

	remote_network = REMOTE_PRISON_ROBOT
	SSvirtualreality.add_robot(src, remote_network)

/mob/living/carbon/human/industrial_xion_remote_warden/Initialize(mapload)
	. = ..(mapload, "Remote Xion Industrial Frame")

	real_name = "Remote Robot Overseer-[rand(0, 999)]"
	name = real_name
	dna.real_name = real_name
	if(mind)
		mind.name = real_name
	status_flags |= NO_ANTAG

	var/obj/item/card/id/ID = new /obj/item/card/id(get_turf(src))
	ID.assignment = "Overseer"
	src.set_id_info(ID)
	ID.access = list(access_armory)
	equip_to_slot_or_del(ID, slot_wear_id)
	equip_to_slot_or_del(new /obj/item/clothing/under/rank/warden/remote(src), slot_w_uniform)
	equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(src), slot_shoes)
	equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_warden(src), slot_l_ear)

	remote_network = REMOTE_WARDEN_ROBOT
	SSvirtualreality.add_robot(src, remote_network)

/mob/living/carbon/human/industrial_zenghu/Initialize(mapload)
	. = ..(mapload, SPECIES_IPC_ZENGHU)

/mob/living/carbon/human/industrial_bishop/Initialize(mapload)
	. = ..(mapload, SPECIES_IPC_BISHOP)

/mob/living/carbon/human/unbranded_frame/Initialize(mapload)
	. = ..(mapload, SPECIES_IPC_UNBRANDED)

/mob/living/carbon/human/unbranded_frame_remote/Initialize(mapload)
	. = ..(mapload, SPECIES_IPC_UNBRANDED_REMOTE)

	real_name = "Remote Robot [pick("Delta", "Theta", "Alpha")]-[rand(0, 999)]"
	name = real_name
	dna.real_name = real_name
	if(mind)
		mind.name = real_name
	status_flags |= NO_ANTAG

	remote_network = REMOTE_GENERIC_ROBOT
	SSvirtualreality.add_robot(src, remote_network)

/mob/living/carbon/human/unbranded_frame_remote_bunker/Initialize(mapload)
	. = ..(mapload, SPECIES_IPC_UNBRANDED_REMOTE)

	real_name = "Remote Robot [pick("Greaves", "Chamberlain", "Slater")]-[rand(0, 999)]"
	name = real_name
	dna.real_name = real_name
	if(mind)
		mind.name = real_name
	status_flags |= NO_ANTAG

	equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(src), slot_wear_suit)
	equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(src), slot_shoes)
	equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_com(src), slot_l_ear)

	remote_network = REMOTE_BUNKER_ROBOT
	SSvirtualreality.add_robot(src, remote_network)

/mob/living/carbon/human/terminator/Initialize(mapload)
	. = ..(mapload, SPECIES_IPC_TERMINATOR)
	add_language(LANGUAGE_SOL_COMMON, 1)
	add_language(LANGUAGE_ELYRAN_STANDARD, 1)
	add_language(LANGUAGE_UNATHI, 1)
	add_language(LANGUAGE_SIIK_MAAS, 1)
	add_language(LANGUAGE_SKRELLIAN, 1)
	add_language(LANGUAGE_TRADEBAND, 1)
	add_language(LANGUAGE_GUTTER, 1)
	add_language(LANGUAGE_EAL, 1)
	src.equip_to_slot_or_del(new /obj/item/rig/terminator(src),slot_back)
	src.equip_to_slot_or_del(new /obj/item/gun/projectile/automatic/terminator(src),slot_l_hand)
	src.equip_to_slot_or_del(new /obj/item/clothing/under/gearharness, slot_w_uniform)
	src.equip_to_slot_or_del(new /obj/item/device/radio/headset/syndicate(src), slot_l_ear)
	src.equip_to_slot_or_del(new /obj/item/grenade/frag(src), slot_l_store)
	src.equip_to_slot_or_del(new /obj/item/melee/energy/sword(src), slot_r_store)

	var/obj/item/storage/belt/security/tactical/commando_belt = new(src)
	commando_belt.contents += new /obj/item/ammo_magazine/flechette
	commando_belt.contents += new /obj/item/ammo_magazine/flechette/explosive
	commando_belt.contents += new /obj/item/ammo_magazine/flechette/explosive
	commando_belt.contents += new /obj/item/melee/baton/loaded
	commando_belt.contents += new /obj/item/shield/energy
	commando_belt.contents += new /obj/item/handcuffs
	commando_belt.contents += new /obj/item/handcuffs
	commando_belt.contents += new /obj/item/plastique
	src.equip_to_slot_or_del(commando_belt, slot_belt)
	src.gender = NEUTER

/mob/living/carbon/human/terminator
	mob_size = 30

/mob/living/carbon/human/golem/Initialize(mapload)
	. = ..(mapload, SPECIES_GOLEM_COAL)

/mob/living/carbon/human/iron_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_GOLEM_IRON)

/mob/living/carbon/human/bronze_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_GOLEM_BRONZE)

/mob/living/carbon/human/steel_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_GOLEM_STEEL)

/mob/living/carbon/human/plasteel_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_GOLEM_PLASTEEL)

/mob/living/carbon/human/titanium_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_GOLEM_TITANIUM)

/mob/living/carbon/human/cloth_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_GOLEM_CLOTH)

/mob/living/carbon/human/cardboard_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_GOLEM_CARDBOARD)

/mob/living/carbon/human/glass_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_GOLEM_GLASS)

/mob/living/carbon/human/phoron_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_GOLEM_PHORON)

/mob/living/carbon/human/mhydrogen_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_GOLEM_HYDROGEN)

/mob/living/carbon/human/wood_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_GOLEM_WOOD)

/mob/living/carbon/human/diamond_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_GOLEM_DIAMOND)

/mob/living/carbon/human/sand_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_GOLEM_SAND)

/mob/living/carbon/human/uranium_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_GOLEM_URANIUM)

/mob/living/carbon/human/homunculus/Initialize(mapload)
	. = ..(mapload, SPECIES_GOLEM_MEAT)

/mob/living/carbon/human/adamantine_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_GOLEM_ADAMANTINE)

/mob/living/carbon/human/technomancer_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_GOLEM_TECHOMANCER)
