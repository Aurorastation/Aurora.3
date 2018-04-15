/obj/item/weapon/storage/box/syndicate/
	New()
		..()
		switch (pickweight(list("bloodyspai" = 1, "stealth" = 1, "screwed" = 1, "guns" = 1, "murder" = 1, "freedom" = 1, "hacker" = 1, "lordsingulo" = 1, "smoothoperator" = 1)))
			if("bloodyspai")
				new /obj/item/clothing/under/chameleon(src)
				new /obj/item/clothing/mask/gas/voice(src)
				new /obj/item/weapon/card/id/syndicate(src)
				new /obj/item/clothing/shoes/syndigaloshes(src)
				return

			if("stealth")
				new /obj/item/weapon/gun/energy/crossbow(src)
				new /obj/item/weapon/pen/reagent/paralysis(src)
				new /obj/item/device/chameleon(src)
				return

			if("screwed")
				new /obj/effect/spawner/newbomb/timer/syndicate(src)
				new /obj/effect/spawner/newbomb/timer/syndicate(src)
				new /obj/item/device/powersink(src)
				new /obj/item/clothing/suit/space/syndicate(src)
				new /obj/item/clothing/head/helmet/space/syndicate(src)
				new /obj/item/clothing/mask/gas/syndicate(src)
				new /obj/item/weapon/tank/emergency_oxygen/double(src)
				return

			if("guns")
				new /obj/item/weapon/gun/projectile/revolver(src)
				new /obj/item/ammo_magazine/a357(src)
				new /obj/item/weapon/card/emag(src)
				new /obj/item/weapon/plastique(src)
				new /obj/item/weapon/plastique(src)
				return

			if("murder")
				new /obj/item/weapon/melee/energy/sword(src)
				new /obj/item/clothing/glasses/thermal/syndi(src)
				new /obj/item/weapon/card/emag(src)
				new /obj/item/clothing/shoes/syndigaloshes(src)
				return

			if("freedom")
				var/obj/item/weapon/implanter/O = new /obj/item/weapon/implanter(src)
				O.imp = new /obj/item/weapon/implant/freedom(O)
				var/obj/item/weapon/implanter/U = new /obj/item/weapon/implanter(src)
				U.imp = new /obj/item/weapon/implant/uplink(U)
				return

			if("hacker")
				new /obj/item/device/encryptionkey/syndicate(src)
				new /obj/item/weapon/aiModule/syndicate(src)
				new /obj/item/weapon/card/emag(src)
				new /obj/item/device/encryptionkey/binary(src)
				return

			if("lordsingulo")
				new /obj/item/device/radio/beacon/syndicate(src)
				new /obj/item/clothing/suit/space/syndicate(src)
				new /obj/item/clothing/head/helmet/space/syndicate(src)
				new /obj/item/clothing/mask/gas/syndicate(src)
				new /obj/item/weapon/tank/emergency_oxygen/double(src)
				new /obj/item/weapon/card/emag(src)
				return

			if("smoothoperator")
				new /obj/item/weapon/storage/box/syndie_kit/g9mm(src)
				new /obj/item/weapon/storage/bag/trash(src)
				new /obj/item/weapon/soap/syndie(src)
				new /obj/item/bodybag(src)
				new /obj/item/clothing/under/suit_jacket(src)
				new /obj/item/clothing/shoes/laceup(src)
				return

/obj/item/weapon/storage/box/syndie_kit
	name = "box"
	desc = "A sleek, sturdy box"
	icon_state = "box_of_doom"

/obj/item/weapon/storage/box/syndie_kit/imp_freedom
	name = "boxed freedom implant (with injector)"

/obj/item/weapon/storage/box/syndie_kit/imp_freedom/fill()
	..()
	var/obj/item/weapon/implanter/O = new(src)
	O.imp = new /obj/item/weapon/implant/freedom(O)
	O.update()
	return

/obj/item/weapon/storage/box/syndie_kit/imp_compress
	name = "box (C)"

/obj/item/weapon/storage/box/syndie_kit/imp_compress/fill()
	new /obj/item/weapon/implanter/compressed(src)
	..()

/obj/item/weapon/storage/box/syndie_kit/imp_explosive
	name = "box (E)"

/obj/item/weapon/storage/box/syndie_kit/imp_explosive/fill()
	new /obj/item/weapon/implanter/explosive(src)
	..()
	return

/obj/item/weapon/storage/box/syndie_kit/imp_uplink
	name = "boxed uplink implant (with injector)"

/obj/item/weapon/storage/box/syndie_kit/imp_uplink/fill()
	..()
	var/obj/item/weapon/implanter/O = new(src)
	O.imp = new /obj/item/weapon/implant/uplink(O)
	O.update()
	return

/obj/item/weapon/storage/box/syndie_kit/space
	name = "boxed space suit and helmet"

/obj/item/weapon/storage/box/syndie_kit/space/fill()
	..()
	new /obj/item/clothing/suit/space/syndicate(src)
	new /obj/item/clothing/head/helmet/space/syndicate(src)
	new /obj/item/clothing/mask/gas/syndicate(src)
	new /obj/item/weapon/tank/emergency_oxygen/double(src)


/obj/item/weapon/storage/box/syndie_kit/chameleon
	name = "chameleon kit"
	desc = "Comes with all the clothes you need to impersonate most people.  Acting lessons sold seperately."

/obj/item/weapon/storage/box/syndie_kit/chameleon/fill()
	..()
	new /obj/item/clothing/under/chameleon(src)
	new /obj/item/clothing/head/chameleon(src)
	new /obj/item/clothing/suit/chameleon(src)
	new /obj/item/clothing/shoes/chameleon(src)
	new /obj/item/weapon/storage/backpack/chameleon(src)
	new /obj/item/clothing/gloves/chameleon(src)
	new /obj/item/clothing/mask/chameleon(src)
	new /obj/item/clothing/glasses/chameleon(src)
	new /obj/item/weapon/gun/energy/chameleon(src)

/obj/item/weapon/storage/box/syndie_kit/clerical
	name = "clerical kit"
	desc = "Comes with all you need to fake paperwork. Assumes you have passed basic writing lessons."

/obj/item/weapon/storage/box/syndie_kit/clerical/fill()
	..()
	new /obj/item/weapon/stamp/chameleon(src)
	new /obj/item/weapon/pen/chameleon(src)
	new /obj/item/device/destTagger(src)
	new /obj/item/weapon/packageWrap(src)
	new /obj/item/weapon/hand_labeler(src)

/obj/item/weapon/storage/box/syndie_kit/spy
	name = "spy kit"
	desc = "For when you want to conduct voyeurism from afar."

/obj/item/weapon/storage/box/syndie_kit/spy/fill()
	..()
	new /obj/item/device/spy_bug(src)
	new /obj/item/device/spy_bug(src)
	new /obj/item/device/spy_bug(src)
	new /obj/item/device/spy_bug(src)
	new /obj/item/device/spy_bug(src)
	new /obj/item/device/spy_bug(src)
	new /obj/item/device/spy_monitor(src)

/obj/item/weapon/storage/box/syndie_kit/g9mm
	name = "smooth operator"
	desc = "9mm with silencer kit."

/obj/item/weapon/storage/box/syndie_kit/g9mm/fill()
	..()
	new /obj/item/weapon/gun/projectile/pistol(src)
	new /obj/item/weapon/silencer(src)

/obj/item/weapon/storage/box/syndie_kit/g9mm/plus
	name = "smooth operator+"
	desc = "9mm with silencer kit, and extra ammo."

/obj/item/weapon/storage/box/syndie_kit/g9mm/plus/fill()
	..()
	new /obj/item/weapon/gun/projectile/pistol(src)
	new /obj/item/weapon/silencer(src)
	new /obj/item/ammo_magazine/mc9mm(src)
	new /obj/item/ammo_magazine/mc9mm(src)

/obj/item/weapon/storage/box/syndie_kit/toxin
	name = "toxin kit"
	desc = "An apple will not be enough to keep the doctor away after this."

/obj/item/weapon/storage/box/syndie_kit/toxin/fill()
	..()
	new /obj/item/weapon/reagent_containers/glass/beaker/vial/random/toxin(src)
	new /obj/item/weapon/reagent_containers/syringe(src)

/obj/item/weapon/storage/box/syndie_kit/cigarette
	name = "tricky smokes"
	desc = "Comes with the following brands of cigarettes, in this order: 2xFlash, 2xSmoke, 1xMindBreaker, 1xTricordrazine. Avoid mixing them up."

/obj/item/weapon/storage/box/syndie_kit/cigarette/fill()
	..()
	var/obj/item/weapon/storage/fancy/cigarettes/pack
	pack = new /obj/item/weapon/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list("aluminum" = 5, "potassium" = 5, "sulfur" = 5))
	pack.desc += " 'F' has been scribbled on it."

	pack = new /obj/item/weapon/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list("aluminum" = 5, "potassium" = 5, "sulfur" = 5))
	pack.desc += " 'F' has been scribbled on it."

	pack = new /obj/item/weapon/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list("potassium" = 5, "sugar" = 5, "phosphorus" = 5))
	pack.desc += " 'S' has been scribbled on it."

	pack = new /obj/item/weapon/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list("potassium" = 5, "sugar" = 5, "phosphorus" = 5))
	pack.desc += " 'S' has been scribbled on it."

	pack = new /obj/item/weapon/storage/fancy/cigarettes(src)
	// Dylovene. Going with 1.5 rather than 1.6666666...
	fill_cigarre_package(pack, list("potassium" = 1.5, "ammonia" = 1.5, "silicon" = 1.5))
	// Mindbreaker
	fill_cigarre_package(pack, list("silicon" = 4.5, "hydrazine" = 4.5, "anti_toxin" = 4.5))

	pack.desc += " 'MB' has been scribbled on it."

	pack = new /obj/item/weapon/storage/fancy/cigarettes(src)
	pack.reagents.add_reagent("tricordrazine", 15 * pack.storage_slots)
	pack.desc += " 'T' has been scribbled on it."

	new /obj/item/weapon/flame/lighter/zippo(src)

/proc/fill_cigarre_package(var/obj/item/weapon/storage/fancy/cigarettes/C, var/list/reagents)
	for(var/reagent in reagents)
		C.reagents.add_reagent(reagent, reagents[reagent] * C.storage_slots)

/obj/item/weapon/storage/box/syndie_kit/ewar_voice
	name = "electrowarfare and voice synthesiser kit"
	desc = "Kit for confounding organic and synthetic entities alike."

/obj/item/weapon/storage/box/syndie_kit/ewar_voice/fill()
	..()
	new /obj/item/rig_module/electrowarfare_suite(src)
	new /obj/item/rig_module/voice(src)

/obj/item/weapon/storage/box/syndie_kit/armor
	name = "boxed armor kit"

/obj/item/weapon/storage/box/syndie_kit/armor/fill()
	..()
	new /obj/item/clothing/suit/storage/vest/merc(src)
	new /obj/item/clothing/head/helmet/merc(src)

/obj/item/weapon/storage/box/syndie_kit/mafia
	name = "mafia kit"
	desc = "Put heads in this box and ship it off to their loved ones after you're done taking the contents out."

/obj/item/weapon/storage/box/syndie_kit/mafia/fill()
	..()
	new /obj/item/clothing/under/gentlesuit/traitor(src)
	new /obj/item/clothing/head/fedora/sharp(src)
	new /obj/item/clothing/shoes/leather(src)

/obj/item/weapon/storage/secure/briefcase/money
	name = "suspicious briefcase"
	desc = "An ominous briefcase that has the unmistakeable smell of old, stale, cigarette smoke, and gives those who look at it a bad feeling."


/obj/item/weapon/storage/secure/briefcase/money/fill()
	..()
	new /obj/item/weapon/spacecash/c1000(src)
	new /obj/item/weapon/spacecash/c1000(src)
	new /obj/item/weapon/spacecash/c1000(src)
	new /obj/item/weapon/spacecash/c1000(src)
	new /obj/item/weapon/spacecash/c1000(src)
	new /obj/item/weapon/spacecash/c1000(src)
	new /obj/item/weapon/spacecash/c1000(src)
	new /obj/item/weapon/spacecash/c1000(src)
	new /obj/item/weapon/spacecash/c1000(src)
	new /obj/item/weapon/spacecash/c1000(src)

//Value Packs
/obj/item/weapon/storage/backpack/clown/tratior/fill()
	..()
	new /obj/item/clothing/mask/gas/voice/clown(src)
	new /obj/item/clothing/under/rank/clown/traitor(src) //About 2
	new /obj/item/clothing/shoes/clown_shoes/traitor(src) //About 2
	new /obj/item/clothing/gloves/force/clown(src) //About 6
	new /obj/item/device/firing_pin/clown(src) //Free because why
	new /obj/item/weapon/material/twohanded/chainsaw/fueled(src) //About 10
	new /obj/item/weapon/card/id/syndicate(src) //About 3
	//Total: 24

/obj/item/weapon/storage/secure/briefcase/beginner
	name = "insecure briefcase"
	desc = "A strange briefcase that oddly smells of crayons and training wheel rubber."

/obj/item/weapon/storage/secure/briefcase/beginner/fill()
	..()
	new /obj/item/weapon/storage/box/syndie_kit/armor(src) //4
	new /obj/item/weapon/storage/belt/utility/full(src) //About 1
	new /obj/item/clothing/gloves/yellow(src) //About 1
	new /obj/item/clothing/mask/gas(src) //About 1
	new /obj/item/weapon/card/id/syndicate(src)
	new /obj/item/weapon/card/emag(src) //6
	new /obj/item/weapon/melee/energy/sword(src) //8
	new /obj/item/weapon/gun/energy/crossbow //6
	new /obj/item/weapon/storage/box/sinpockets //2
	//Total: 30

/obj/item/weapon/storage/backpack/cowboy
	name = "cowboy hat"
	desc = "A wide-brimmed hat, in the prevalent style of the frontier. The inside seems to house some crazy bluespace technology."
	icon_state = "cowboyhat"
	icon = 'icons/obj/clothing/hats.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_hats.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_hats.dmi'
		)
	body_parts_covered = HEAD
	slot_flags = SLOT_HEAD

/obj/item/weapon/storage/backpack/cowboy/fill()
	..()
	new /obj/item/weapon/gun/projectile/revolver/fast(src) //I'd say 16
	new /obj/item/clothing/suit/storage/vest/merc(src) //2
	new /obj/item/ammo_magazine/a357(src) //2
	new /obj/item/ammo_magazine/a357(src) //2
	new /obj/item/ammo_magazine/a357(src) //2
	new /obj/item/weapon/spacecash/bundle/cowboy(src) //About 1
	new /obj/item/clothing/accessory/holster/hip(src) //About 1
	new /obj/item/weapon/material/kitchen/utensil/knife/boot(src) //About 1
	new /obj/item/clothing/ears/bandanna(src)
	new /obj/item/clothing/under/pants/classic
	//Total: 27, but the hat backpack is probably worth a lot.

/obj/item/weapon/storage/secure/briefcase/mafia/fill()
	new /obj/item/weapon/storage/box/syndie_kit/mafia(src) //About 4
	new /obj/item/weapon/gun/projectile/automatic/tommygun/drum(src) //Probably 16
	new /obj/item/ammo_magazine/tommydrum(src) //Probably 4
	new /obj/item/ammo_magazine/tommydrum(src) //Probably 4
	new /obj/item/weapon/spacecash/bundle/mafia(src) //About 2
	//Total: 30

/obj/item/weapon/storage/secure/briefcase/stealth/fill()
	new /obj/item/clothing/glasses/eyepatch/hud/thermal //6
	new /obj/item/weapon/storage/box/syndie_kit/chameleon(src) //5
	new /obj/item/weapon/storage/box/syndie_kit/spy(src) //2
	new /obj/item/weapon/storage/box/syndie_kit/g9mm/plus // 10
	new /obj/item/weapon/card/id/syndicate(src) //3
	new /obj/item/clothing/mask/gas/voice(src) //5
	new /obj/item/weapon/pen/reagent/paralysis(src) //6
	new /obj/item/weapon/spacecash/bundle/cowboy(src) //About 1
	//Total: 35

/obj/item/weapon/storage/secure/briefcase/ninja/fill()
	new /obj/item/weapon/storage/box/syndie_kit/chameleon(src) //5
	new /datum/uplink_item/item/stealth_items/chameleon_projector(src) //5
	new /obj/item/weapon/card/id/syndicate(src) //3
	new /obj/item/weapon/material/sword/katana(src) //Probably 4
	new /obj/item/weapon/material/star(src) // Probably 2
	new /obj/item/weapon/material/star(src) // Probably 2
	new /obj/item/weapon/material/star(src) // Probably 2
	new /obj/item/clothing/accessory/storage/black_pouches(src) //Probably 1
	new /obj/item/clothing/gloves/force/syndicate(src) // 8
	new /obj/item/weapon/spacecash/bundle/cowboy(src) //About 1
	// Total: 33

/obj/item/weapon/storage/backpack/luchador/traitor/fill()
	new /obj/item/wrestling_manual(src) //6
	new /obj/item/weapon/storage/pill_bottle/steroids(src) //Probably like 10 honestly
	new /obj/item/clothing/under/shorts/green/luchador/(src) //2
	new /obj/item/clothing/gloves/force/luchador(src) //About 8
	new /obj/item/clothing/mask/gas/voice/luchador(src) //Probably 6
	new /obj/item/weapon/card/id/syndicate(src) //3
	new /obj/item/weapon/storage/belt/champion(src) //Free
	new /obj/item/clothing/shoes/jackboots(src) //Free
	new /obj/item/clothing/shoes/jackboots/unathi(src) //Free
	//Total 33