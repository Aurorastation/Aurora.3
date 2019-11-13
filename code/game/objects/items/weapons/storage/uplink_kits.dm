/obj/item/storage/box/syndicate/
	New()
		..()
		switch (pickweight(list("bloodyspai" = 1, "stealth" = 1, "screwed" = 1, "guns" = 1, "murder" = 1, "freedom" = 1, "hacker" = 1, "lordsingulo" = 1, "smoothoperator" = 1)))
			if("bloodyspai")
				new /obj/item/clothing/under/chameleon(src)
				new /obj/item/clothing/mask/gas/voice(src)
				new /obj/item/card/id/syndicate(src)
				new /obj/item/clothing/shoes/syndigaloshes(src)
				return

			if("stealth")
				new /obj/item/gun/energy/crossbow(src)
				new /obj/item/pen/reagent/paralysis(src)
				new /obj/item/device/chameleon(src)
				return

			if("screwed")
				new /obj/effect/spawner/newbomb/timer/syndicate(src)
				new /obj/effect/spawner/newbomb/timer/syndicate(src)
				new /obj/item/device/powersink(src)
				new /obj/item/clothing/suit/space/syndicate(src)
				new /obj/item/clothing/head/helmet/space/syndicate(src)
				new /obj/item/clothing/mask/gas/syndicate(src)
				new /obj/item/tank/emergency_oxygen/double(src)
				return

			if("guns")
				new /obj/item/gun/projectile/revolver(src)
				new /obj/item/ammo_magazine/a357(src)
				new /obj/item/card/emag(src)
				new /obj/item/plastique(src)
				new /obj/item/plastique(src)
				return

			if("murder")
				new /obj/item/melee/energy/sword(src)
				new /obj/item/clothing/glasses/thermal/syndi(src)
				new /obj/item/card/emag(src)
				new /obj/item/clothing/shoes/syndigaloshes(src)
				return

			if("freedom")
				var/obj/item/implanter/O = new /obj/item/implanter(src)
				O.imp = new /obj/item/implant/freedom(O)
				var/obj/item/implanter/U = new /obj/item/implanter(src)
				U.imp = new /obj/item/implant/uplink(U)
				return

			if("hacker")
				new /obj/item/device/encryptionkey/syndicate(src)
				new /obj/item/aiModule/syndicate(src)
				new /obj/item/card/emag(src)
				new /obj/item/device/encryptionkey/binary(src)
				return

			if("lordsingulo")
				new /obj/item/device/radio/beacon/syndicate(src)
				new /obj/item/clothing/suit/space/syndicate(src)
				new /obj/item/clothing/head/helmet/space/syndicate(src)
				new /obj/item/clothing/mask/gas/syndicate(src)
				new /obj/item/tank/emergency_oxygen/double(src)
				new /obj/item/card/emag(src)
				return

			if("smoothoperator")
				new /obj/item/storage/box/syndie_kit/g9mm(src)
				new /obj/item/storage/bag/trash(src)
				new /obj/item/soap/syndie(src)
				new /obj/item/bodybag(src)
				new /obj/item/clothing/under/suit_jacket(src)
				new /obj/item/clothing/shoes/laceup(src)
				return

/obj/item/storage/box/syndie_kit
	name = "box"
	desc = "A sleek, sturdy box"
	icon_state = "box_of_doom"

/obj/item/storage/box/syndie_kit/imp_freedom
	name = "box (F)"
	starts_with = list(/obj/item/implanter/freedom = 1)

/obj/item/storage/box/syndie_kit/imp_freedom/fill()
	..()
	var/obj/item/implanter/O = new(src)
	O.imp = new /obj/item/implant/freedom(O)
	O.update()
	return

/obj/item/storage/box/syndie_kit/imp_compress
	name = "box (C)"
	starts_with = list(/obj/item/implanter/compressed = 1)

/obj/item/storage/box/syndie_kit/imp_explosive
	name = "box (E)"
	starts_with = list(/obj/item/implanter/explosive = 1)

/obj/item/storage/box/syndie_kit/imp_uplink
	name = "boxed uplink implant (with injector)"
	starts_with = list(/obj/item/implanter/uplink = 1)

/obj/item/storage/box/syndie_kit/space
	name = "boxed space suit and helmet"
	starts_with = list(
		/obj/item/clothing/suit/space/syndicate = 1,
		/obj/item/clothing/head/helmet/space/syndicate = 1,
		/obj/item/clothing/mask/gas/syndicate = 1,
		/obj/item/tank/emergency_oxygen/double = 1
	)


/obj/item/storage/box/syndie_kit/chameleon
	name = "chameleon kit"
	desc = "Comes with all the clothes you need to impersonate most people.  Acting lessons sold seperately."
	starts_with = list(
		/obj/item/clothing/under/chameleon = 1,
		/obj/item/clothing/head/chameleon = 1,
		/obj/item/clothing/suit/chameleon = 1,
		/obj/item/clothing/shoes/chameleon = 1,
		/obj/item/storage/backpack/chameleon = 1,
		/obj/item/clothing/gloves/chameleon = 1,
		/obj/item/clothing/mask/chameleon = 1,
		/obj/item/clothing/glasses/chameleon = 1,
		/obj/item/gun/energy/chameleon = 1
	)

/obj/item/storage/box/syndie_kit/clerical
	name = "clerical kit"
	desc = "Comes with all you need to fake paperwork. Assumes you have passed basic writing lessons."
	starts_with = list(
		/obj/item/stamp/chameleon = 1,
		/obj/item/pen/chameleon = 1,
		/obj/item/device/destTagger = 1,
		/obj/item/stack/packageWrap = 1,
		/obj/item/hand_labeler = 1
	)

/obj/item/storage/box/syndie_kit/spy
	name = "spy kit"
	desc = "For when you want to conduct voyeurism from afar."
	starts_with = list(/obj/item/device/spy_bug = 6, /obj/item/device/spy_monitor = 1)

/obj/item/storage/box/syndie_kit/g9mm
	name = "smooth operator"
	desc = "9mm with silencer kit."
	starts_with = list(/obj/item/gun/projectile/pistol = 1, /obj/item/silencer = 1)

/obj/item/storage/box/syndie_kit/toxin
	name = "toxin kit"
	desc = "An apple will not be enough to keep the doctor away after this."
	starts_with = list(/obj/item/reagent_containers/glass/beaker/vial/random/toxin = 1, /obj/item/reagent_containers/syringe = 1)

/obj/item/storage/box/syndie_kit/cigarette
	name = "tricky smokes"
	desc = "Comes with the following brands of cigarettes, in this order: 2xFlash, 2xSmoke, 1xMindBreaker, 1xTricordrazine. Avoid mixing them up."

/obj/item/storage/box/syndie_kit/cigarette/fill()
	..()
	var/obj/item/storage/fancy/cigarettes/pack
	pack = new /obj/item/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list("aluminum" = 5, "potassium" = 5, "sulfur" = 5))
	pack.desc += " 'F' has been scribbled on it."

	pack = new /obj/item/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list("aluminum" = 5, "potassium" = 5, "sulfur" = 5))
	pack.desc += " 'F' has been scribbled on it."

	pack = new /obj/item/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list("potassium" = 5, "sugar" = 5, "phosphorus" = 5))
	pack.desc += " 'S' has been scribbled on it."

	pack = new /obj/item/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list("potassium" = 5, "sugar" = 5, "phosphorus" = 5))
	pack.desc += " 'S' has been scribbled on it."

	pack = new /obj/item/storage/fancy/cigarettes(src)
	// Dylovene. Going with 1.5 rather than 1.6666666...
	fill_cigarre_package(pack, list("potassium" = 1.5, "ammonia" = 1.5, "silicon" = 1.5))
	// Mindbreaker
	fill_cigarre_package(pack, list("silicon" = 4.5, "hydrazine" = 4.5, "anti_toxin" = 4.5))

	pack.desc += " 'MB' has been scribbled on it."

	pack = new /obj/item/storage/fancy/cigarettes(src)
	pack.reagents.add_reagent("tricordrazine", 15 * pack.storage_slots)
	pack.desc += " 'T' has been scribbled on it."

	new /obj/item/flame/lighter/zippo(src)

/proc/fill_cigarre_package(var/obj/item/storage/fancy/cigarettes/C, var/list/reagents)
	for(var/reagent in reagents)
		C.reagents.add_reagent(reagent, reagents[reagent] * C.storage_slots)

/obj/item/storage/box/syndie_kit/ewar_voice
	name = "electrowarfare and voice synthesiser kit"
	desc = "Kit for confounding organic and synthetic entities alike."
	starts_with = list(/obj/item/rig_module/electrowarfare_suite = 1, /obj/item/rig_module/voice = 1)

/obj/item/storage/box/syndie_kit/armor
	name = "boxed armor kit"
	starts_with = list(/obj/item/clothing/suit/storage/vest/merc = 1, /obj/item/clothing/head/helmet/merc = 1)

/obj/item/storage/secure/briefcase/money
	name = "suspicious briefcase"
	desc = "An ominous briefcase that has the unmistakeable smell of old, stale, cigarette smoke, and gives those who look at it a bad feeling."
	starts_with = list(/obj/item/spacecash/c1000 = 10)

/obj/item/storage/box/syndie_kit/stimulants
	name = "box of stimulants"
	desc = "Comes with a combat inhaler, a large cartridge of hyperzine, a large cartridge of inaprovaline, and a large empty cartridge."
	starts_with = list(
		/obj/item/personal_inhaler/combat = 1,
		/obj/item/reagent_containers/personal_inhaler_cartridge/large/hyperzine = 1,
		/obj/item/reagent_containers/personal_inhaler_cartridge/large/inaprovaline = 1,
		/obj/item/reagent_containers/personal_inhaler_cartridge/large = 1,
	)
