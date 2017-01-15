/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH

/mob/living/carbon/human/resomi/New(var/new_loc)
	h_style = "Resomi Plumage"
	..(new_loc, "Resomi")

/mob/living/carbon/human/skrell/New(var/new_loc)
	h_style = "Skrell Male Tentacles"
	..(new_loc, "Skrell")

/mob/living/carbon/human/tajaran/New(var/new_loc)
	h_style = "Tajaran Ears"
	..(new_loc, "Tajara")

/mob/living/carbon/human/unathi/New(var/new_loc)
	h_style = "Unathi Horns"
	..(new_loc, "Unathi")

/mob/living/carbon/human/vox/New(var/new_loc)
	h_style = "Short Vox Quills"
	..(new_loc, "Vox")

/mob/living/carbon/human/voxarmalis/New(var/new_loc)
	h_style = "Bald"
	..(new_loc, "Vox Armalis")

/mob/living/carbon/human/diona/New(var/new_loc)
	..(new_loc, "Diona")
	src.gender = NEUTER

/mob/living/carbon/human/machine/New(var/new_loc)
	h_style = "blue IPC screen"
	..(new_loc, "Baseline Frame")

/mob/living/carbon/human/monkey
	mob_size = 2.6//Based on howler monkey, rough real world equivilant to on-mob sprite size

/mob/living/carbon/human/monkey/New(var/new_loc)
	..(new_loc, "Monkey")

/mob/living/carbon/human/farwa
	mob_size = 2.6//Roughly the same size as monkey

/mob/living/carbon/human/farwa/New(var/new_loc)
	..(new_loc, "Farwa")

/mob/living/carbon/human/neaera
	mob_size = 2.6//Roughly the same size as monkey

/mob/living/carbon/human/neaera/New(var/new_loc)
	..(new_loc, "Neaera")

/mob/living/carbon/human/stok
	mob_size = 2.6//Roughly the same size as monkey

/mob/living/carbon/human/neaera/New(var/new_loc)
	..(new_loc, "Neaera")

/mob/living/carbon/human/bug
	mob_size = 2.6//Roughly the same size as monkey

/mob/living/carbon/human/bug/New(var/new_loc)
	..(new_loc, "V'krexi")
	src.gender = FEMALE

/mob/living/carbon/human/type_a/New(var/new_loc)
	..(new_loc, "Vaurca Worker")
	src.gender = NEUTER

/mob/living/carbon/human/type_b/New(var/new_loc)
	..(new_loc, "Vaurca Warrior")
	src.gender = NEUTER

/mob/living/carbon/human/type_c/New(var/new_loc)
	..(new_loc, "Vaurca Breeder")
	src.gender = FEMALE

/mob/living/carbon/human/type_c
	layer = 5

/mob/living/carbon/human/industrial/New(var/new_loc)
	..(new_loc, "Industrial Frame")

/mob/living/carbon/human/shell/New(var/new_loc)
	..(new_loc, "Shell Frame")

/mob/living/carbon/human/terminator/New(var/new_loc)
	..(new_loc, "Hunter-Killer")
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
	offset_light = 1
