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

/mob/living/carbon/human/resomi/Initialize(mapload)
	h_style = "Resomi Plumage"
	. = ..(mapload, "Resomi")

/mob/living/carbon/human/skrell/Initialize(mapload)
	h_style = "Skrell Male Tentacles"
	. = ..(mapload, "Skrell")

/mob/living/carbon/human/tajaran/Initialize(mapload)
	h_style = "Tajaran Ears"
	. = ..(mapload, "Tajara")

/mob/living/carbon/human/unathi/Initialize(mapload)
	h_style = "Unathi Horns"
	. = ..(mapload, "Unathi")

/mob/living/carbon/human/vox/Initialize(mapload)
	h_style = "Short Vox Quills"
	. = ..(mapload, "Vox")

/mob/living/carbon/human/voxarmalis/Initialize(mapload)
	h_style = "Bald"
	. = ..(mapload, "Vox Armalis")

/mob/living/carbon/human/diona/Initialize(mapload)
	. = ..(mapload, "Diona")
	src.gender = NEUTER

/mob/living/carbon/human/machine/Initialize(mapload)
	h_style = "blue IPC screen"
	. = ..(mapload, "Baseline Frame")

/mob/living/carbon/human/monkey/Initialize(mapload)
	. = ..(mapload, "Monkey")

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
	. = ..(mapload, "Vaurca Worker")
	src.gender = NEUTER

/mob/living/carbon/human/type_b/Initialize(mapload)
	h_style = "Classic Antennae"
	. = ..(mapload, "Vaurca Warrior")
	src.gender = NEUTER

/mob/living/carbon/human/type_c/Initialize(mapload)
	. = ..(mapload, "Vaurca Breeder")
	src.gender = FEMALE

/mob/living/carbon/human/type_c
	layer = 5

/mob/living/carbon/human/type_big/Initialize(mapload)
	. = ..(mapload, "Vaurca Warform")
	src.gender = NEUTER
	src.mutations.Add(HULK)

/mob/living/carbon/human/type_big
	layer = 5

/mob/living/carbon/human/msai_tajara/Initialize(mapload)
	h_style = "Tajaran Ears"
	. = ..(mapload, "M'sai Tajara")

/mob/living/carbon/human/zhankhazan_tajara/Initialize(mapload)
	h_style = "Tajaran Ears"
	. = ..(mapload, "Zhan-Khazan Tajara")

/mob/living/carbon/human/industrial/Initialize(mapload)
	. = ..(mapload, "Hephaestus G1 Industrial Frame")

/mob/living/carbon/human/shell/Initialize(mapload)
	. = ..(mapload, "Shell Frame")

/mob/living/carbon/human/industrial_hephaestus/Initialize(mapload)
	. = ..(mapload, "Hephaestus G2 Industrial Frame")

/mob/living/carbon/human/industrial_xion/Initialize(mapload)
	. = ..(mapload, "Xion Industrial Frame")

/mob/living/carbon/human/industrial_zenghu/Initialize(mapload)
	. = ..(mapload, "Zeng-Hu Mobility Frame")

/mob/living/carbon/human/industrial_bishop/Initialize(mapload)
	. = ..(mapload, "Bishop Accessory Frame")

/mob/living/carbon/human/unbranded_frame/Initialize(mapload)
	. = ..(mapload, "Unbranded Frame")

/mob/living/carbon/human/terminator/Initialize(mapload)
	. = ..(mapload, "Hunter-Killer")
	add_language(LANGUAGE_SOL_COMMON, 1)
	add_language(LANGUAGE_UNATHI, 1)
	add_language(LANGUAGE_SIIK_MAAS, 1)
	add_language(LANGUAGE_SKRELLIAN, 1)
	add_language(LANGUAGE_TRADEBAND, 1)
	add_language(LANGUAGE_GUTTER, 1)
	add_language(LANGUAGE_EAL, 1)
	src.equip_to_slot_or_del(new /obj/item/weapon/rig/terminator(src),slot_back)
	src.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/terminator(src),slot_l_hand)
	src.equip_to_slot_or_del(new /obj/item/clothing/under/gearharness, slot_w_uniform)
	src.equip_to_slot_or_del(new /obj/item/device/radio/headset/syndicate(src), slot_l_ear)
	src.equip_to_slot_or_del(new /obj/item/weapon/grenade/frag(src), slot_l_store)
	src.equip_to_slot_or_del(new /obj/item/weapon/melee/energy/sword(src), slot_r_store)

	var/obj/item/weapon/storage/belt/security/tactical/commando_belt = new(src)
	commando_belt.contents += new /obj/item/ammo_magazine/flechette
	commando_belt.contents += new /obj/item/ammo_magazine/flechette/explosive
	commando_belt.contents += new /obj/item/ammo_magazine/flechette/explosive
	commando_belt.contents += new /obj/item/weapon/melee/baton/loaded
	commando_belt.contents += new /obj/item/weapon/shield/energy
	commando_belt.contents += new /obj/item/weapon/handcuffs
	commando_belt.contents += new /obj/item/weapon/handcuffs
	commando_belt.contents += new /obj/item/weapon/plastique
	src.equip_to_slot_or_del(commando_belt, slot_belt)
	src.gender = NEUTER

/mob/living/carbon/human/terminator
	mob_size = 30

/mob/living/carbon/human/golem/Initialize(mapload)
	. = ..(mapload, "Coal Golem")

/mob/living/carbon/human/iron_golem/Initialize(mapload)
	. = ..(mapload, "Iron Golem")

/mob/living/carbon/human/bronze_golem/Initialize(mapload)
	. = ..(mapload, "Bronze Golem")

/mob/living/carbon/human/steel_golem/Initialize(mapload)
	. = ..(mapload, "Steel Golem")

/mob/living/carbon/human/plasteel_golem/Initialize(mapload)
	. = ..(mapload, "Plasteel Golem")

/mob/living/carbon/human/titanium_golem/Initialize(mapload)
	. = ..(mapload, "Titanium Golem")

/mob/living/carbon/human/cloth_golem/Initialize(mapload)
	. = ..(mapload, "Cloth Golem")

/mob/living/carbon/human/cardboard_golem/Initialize(mapload)
	. = ..(mapload, "Cardboard Golem")

/mob/living/carbon/human/glass_golem/Initialize(mapload)
	. = ..(mapload, "Glass Golem")

/mob/living/carbon/human/phoron_golem/Initialize(mapload)
	. = ..(mapload, "Phoron Golem")

/mob/living/carbon/human/mhydrogen_golem/Initialize(mapload)
	. = ..(mapload, "Metallic Hydrogen Golem")

/mob/living/carbon/human/wood_golem/Initialize(mapload)
	. = ..(mapload, "Wood Golem")

/mob/living/carbon/human/diamond_golem/Initialize(mapload)
	. = ..(mapload, "Diamond Golem")

/mob/living/carbon/human/sand_golem/Initialize(mapload)
	. = ..(mapload, "Sand Golem")

/mob/living/carbon/human/uranium_golem/Initialize(mapload)
	. = ..(mapload, "Uranium Golem")

/mob/living/carbon/human/homunculus/Initialize(mapload)
	. = ..(mapload, "Homunculus")

/mob/living/carbon/human/adamantine_golem/Initialize(mapload)
	. = ..(mapload, "Adamantine Golem")