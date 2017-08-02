/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH

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

/mob/living/carbon/human/monkey
	mob_size = 2.6//Based on howler monkey, rough real world equivilant to on-mob sprite size

/mob/living/carbon/human/monkey/Initialize(mapload)
	. = ..(mapload, "Monkey")

/mob/living/carbon/human/farwa
	mob_size = 2.6//Roughly the same size as monkey

/mob/living/carbon/human/farwa/Initialize(mapload)
	. = ..(mapload, "Farwa")

/mob/living/carbon/human/neaera
	mob_size = 2.6//Roughly the same size as monkey

/mob/living/carbon/human/neaera/Initialize(mapload)
	. = ..(mapload, "Neaera")

/mob/living/carbon/human/stok
	mob_size = 2.6//Roughly the same size as monkey

/mob/living/carbon/human/stok/Initialize(mapload)
	. = ..(mapload, "Stok")

/mob/living/carbon/human/bug
	mob_size = 2.6//Roughly the same size as monkey

/mob/living/carbon/human/bug/Initialize(mapload)
	. = ..(mapload, "V'krexi")
	src.gender = FEMALE

/mob/living/carbon/human/type_a/Initialize(mapload)
	. = ..(mapload, "Vaurca Worker")
	src.gender = NEUTER

/mob/living/carbon/human/type_b/Initialize(mapload)
	. = ..(mapload, "Vaurca Warrior")
	src.gender = NEUTER

/mob/living/carbon/human/type_c/Initialize(mapload)
	. = ..(mapload, "Vaurca Breeder")
	src.gender = FEMALE

/mob/living/carbon/human/type_c
	layer = 5

/mob/living/carbon/human/industrial/Initialize(mapload)
	..(mapload, "Industrial Frame")

/mob/living/carbon/human/shell/Initialize(mapload)
	..(mapload, "Shell Frame")

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
