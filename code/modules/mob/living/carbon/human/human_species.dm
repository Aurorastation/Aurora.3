/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH

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

/mob/living/carbon/human/vox/Initialize(mapload)
	h_style = "Short Vox Quills"
	. = ..(mapload, SPECIES_VOX)

/mob/living/carbon/human/voxarmalis/Initialize(mapload)
	h_style = "Bald"
	. = ..(mapload, "Vox Armalis")

/mob/living/carbon/human/diona/Initialize(mapload)
	. = ..(mapload, SPECIES_DIONA)
	src.gender = NEUTER

/mob/living/carbon/human/machine/Initialize(mapload)
	h_style = "blue IPC screen"
	. = ..(mapload, SPECIES_IPC)

/mob/living/carbon/human/machine/Stat()
	..()

	if(client?.statpanel == "Status")
		stat("Battery Charge: ", "[nutrition]/[max_nutrition]")

/mob/living/carbon/human/monkey/Initialize(mapload)
	. = ..(mapload, SPECIES_MONKEY)

/mob/living/carbon/human/farwa/Initialize(mapload)
	. = ..(mapload, "Farwa")

/mob/living/carbon/human/neaera/Initialize(mapload)
	. = ..(mapload, "Neaera")

/mob/living/carbon/human/stok/Initialize(mapload)
	. = ..(mapload, "Stok")

/mob/living/carbon/human/bug/Initialize(mapload)
	. = ..(mapload, "V'krexi")
	src.gender = FEMALE

/mob/living/carbon/human/type_a/Initialize(mapload)
	h_style = "Classic Antennae"
	. = ..(mapload, SPECIES_VAURCA_WORKER)
	src.gender = NEUTER

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

/mob/living/carbon/human/msai_tajara/Initialize(mapload)
	h_style = "Tajaran Ears"
	. = ..(mapload, SPECIES_MSAI_TJARA)

/mob/living/carbon/human/zhankhazan_tajara/Initialize(mapload)
	h_style = "Tajaran Ears"
	. = ..(mapload, SPECIES_ZHAN_KHAZAN_TAJARA
)

/mob/living/carbon/human/industrial/Initialize(mapload)
	. = ..(mapload, SPECIES_HEPHAESTUS_G1_IPC)

/mob/living/carbon/human/industrial/Stat()
	..()

	if(client?.statpanel == "Status")
		stat("Battery Charge: ", "[nutrition]/[max_nutrition]")

/mob/living/carbon/human/shell/Initialize(mapload)
	. = ..(mapload, SPECIES_SHELL_IPC)

/mob/living/carbon/human/shell/Stat()
	..()

	if(client?.statpanel == "Status")
		stat("Battery Charge: ", "[nutrition]/[max_nutrition]")

/mob/living/carbon/human/industrial_hephaestus/Initialize(mapload)
	. = ..(mapload, SPECIES_HEPHAESTUS_G2_IPC)

/mob/living/carbon/human/industrial_hephaestus/Stat()
	..()

	if(client?.statpanel == "Status")
		stat("Battery Charge: ", "[nutrition]/[max_nutrition]")

/mob/living/carbon/human/industrial_xion/Initialize(mapload)
	. = ..(mapload, SPECIES_XION_IPC)

/mob/living/carbon/human/industrial_xion/Stat()
	..()

	if(client?.statpanel == "Status")
		stat("Battery Charge: ", "[nutrition]/[max_nutrition]")

/mob/living/carbon/human/industrial_xion_remote/Initialize(mapload)
	. = ..(mapload, SPECIES_XION_REMOTE_IPC)

	real_name = "Remote Robot [pick("Delta", "Theta", "Alpha")]-[rand(0, 999)]"
	name = real_name
	dna.real_name = real_name
	if(mind)
		mind.name = real_name
	status_flags |= NO_ANTAG

	remote_network = "remoterobots"
	SSvirtualreality.add_robot(src, remote_network)

/mob/living/carbon/human/industrial_xion_remote/Stat()
	..()

	if(client?.statpanel == "Status")
		stat("Battery Charge: ", "[nutrition]/[max_nutrition]")

/mob/living/carbon/human/industrial_xion_remote_mech/Initialize(mapload)
	. = ..(mapload, SPECIES_XION_REMOTE_IPC)

	real_name = "Remote Pilot [pick("Delta", "Theta", "Alpha")]-[rand(0, 999)]"
	name = real_name
	dna.real_name = real_name
	if(mind)
		mind.name = real_name
	status_flags |= NO_ANTAG

/mob/living/carbon/human/industrial_xion_remote_mech/Stat()
	..()

	if(client?.statpanel == "Status")
		stat("Battery Charge: ", "[nutrition]/[max_nutrition]")

/mob/living/carbon/human/industrial_xion_remote_bunker/Initialize(mapload)
	. = ..(mapload, SPECIES_XION_REMOTE_IPC)

	real_name = "Remote Robot [pick("Greaves", "Chamberlain", "Slater")]-[rand(0, 999)]"
	name = real_name
	dna.real_name = real_name
	if(mind)
		mind.name = real_name
	status_flags |= NO_ANTAG

	equip_to_slot_or_del(new /obj/item/clothing/under/assistantformal(src), slot_w_uniform)
	equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(src), slot_wear_suit)
	equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(src), slot_shoes)
	equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_com(src), slot_l_ear)

	remote_network = "bunkerrobots"
	SSvirtualreality.add_robot(src, remote_network)

/mob/living/carbon/human/industrial_xion_remote_bunker/Stat()
	..()

	if(client?.statpanel == "Status")
		stat("Battery Charge: ", "[nutrition]/[max_nutrition]")

/mob/living/carbon/human/industrial_zenghu/Initialize(mapload)
	. = ..(mapload, SPECIES_ZENGHU_IPC)

/mob/living/carbon/human/industrial_zenghu/Stat()
	..()

	if(client?.statpanel == "Status")
		stat("Battery Charge: ", "[nutrition]/[max_nutrition]")

/mob/living/carbon/human/industrial_bishop/Initialize(mapload)
	. = ..(mapload, SPECIES_BISHOP_IPC)

/mob/living/carbon/human/industrial_bishop/Stat()
	..()

	if(client?.statpanel == "Status")
		stat("Battery Charge: ", "[nutrition]/[max_nutrition]")

/mob/living/carbon/human/unbranded_frame/Initialize(mapload)
	. = ..(mapload, SPECIES_UNBRANDED_IPC)

/mob/living/carbon/human/unbranded_frame/Stat()
	..()

	if(client?.statpanel == "Status")
		stat("Battery Charge: ", "[nutrition]/[max_nutrition]")

/mob/living/carbon/human/unbranded_frame_remote/Initialize(mapload)
	. = ..(mapload, SPECIES_UNBRANDED_REMOTE_IPC)

	real_name = "Remote Robot [pick("Delta", "Theta", "Alpha")]-[rand(0, 999)]"
	name = real_name
	dna.real_name = real_name
	if(mind)
		mind.name = real_name
	status_flags |= NO_ANTAG

	remote_network = "remoterobots"
	SSvirtualreality.add_robot(src, remote_network)

/mob/living/carbon/human/unbranded_frame_remote/Stat()
	..()

	if(client?.statpanel == "Status")
		stat("Battery Charge: ", "[nutrition]/[max_nutrition]")

/mob/living/carbon/human/unbranded_frame_remote_bunker/Initialize(mapload)
	. = ..(mapload, SPECIES_UNBRANDED_REMOTE_IPC)

	real_name = "Remote Robot [pick("Greaves", "Chamberlain", "Slater")]-[rand(0, 999)]"
	name = real_name
	dna.real_name = real_name
	if(mind)
		mind.name = real_name
	status_flags |= NO_ANTAG

	equip_to_slot_or_del(new /obj/item/clothing/under/assistantformal(src), slot_w_uniform)
	equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(src), slot_wear_suit)
	equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(src), slot_shoes)
	equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_com(src), slot_l_ear)

	remote_network = "bunkerrobots"
	SSvirtualreality.add_robot(src, remote_network)

/mob/living/carbon/human/unbranded_frame_remote_bunker/Stat()
	..()

	if(client?.statpanel == "Status")
		stat("Battery Charge: ", "[nutrition]/[max_nutrition]")

/mob/living/carbon/human/terminator/Initialize(mapload)
	. = ..(mapload, SPECIES_TERMINATOR_IPC)
	add_language(LANGUAGE_SOL_COMMON, 1)
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

/mob/living/carbon/human/terminator/Stat()
	..()

	if(client?.statpanel == "Status")
		stat("Battery Charge: ", "[nutrition]/[max_nutrition]")

/mob/living/carbon/human/terminator
	mob_size = 30

/mob/living/carbon/human/golem/Initialize(mapload)
	. = ..(mapload, SPECIES_COAL_GOLEM)

/mob/living/carbon/human/iron_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_IRON_GOLEM)

/mob/living/carbon/human/bronze_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_BRONZE_GOLEM)

/mob/living/carbon/human/steel_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_STEEL_GOLEM)

/mob/living/carbon/human/plasteel_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_PLASTEEL_GOLEM)

/mob/living/carbon/human/titanium_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_TITANIUM_GOLEM)

/mob/living/carbon/human/cloth_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_CLOTH_GOLEM)

/mob/living/carbon/human/cardboard_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_CARDBOARD_GOLEM)

/mob/living/carbon/human/glass_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_GLASS_GOLEM)

/mob/living/carbon/human/phoron_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_PHORON_GOLEM)

/mob/living/carbon/human/mhydrogen_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_MHYDROGEN_GOLEM)

/mob/living/carbon/human/wood_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_WOOD_GOLEM)

/mob/living/carbon/human/diamond_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_DIAMOND_GOLEM)

/mob/living/carbon/human/sand_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_SAND_GOLEM)

/mob/living/carbon/human/uranium_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_URANIUM_GOLEM)

/mob/living/carbon/human/homunculus/Initialize(mapload)
	. = ..(mapload, SPECIES_HOMONCULUS_GOLEM)

/mob/living/carbon/human/adamantine_golem/Initialize(mapload)
	. = ..(mapload, SPECIES_ADAMANTINE_GOLEM)

/mob/living/carbon/human/autakh/Initialize(mapload)
	. = ..(mapload, SPECIES_AUTAKH_UNATHI)
