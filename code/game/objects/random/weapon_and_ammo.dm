
/obj/random/weapon_and_ammo
	name = "random weapon and ammo"
	desc = "Summons a random weapon, with ammo if applicable."
	icon = 'icons/obj/guns/xenoblaster.dmi'
	icon_state = "xenoblaster"
	var/chosen_rarity //Can be set to force certain rarity
	var/concealable = FALSE //If the gun should fit in a backpack
	has_postspawn = TRUE

	var/list/Shoddy = list(
		/obj/item/gun/energy/blaster = 1,
		/obj/item/gun/energy/retro = 0.5,
		/obj/item/gun/energy/toxgun = 0.5,
		/obj/item/gun/projectile/automatic/improvised = 1,
		/obj/item/gun/projectile/contender = 0.5,
		/obj/item/gun/projectile/leyon = 1,
		/obj/item/gun/projectile/revolver/derringer = 1,
		/obj/item/gun/projectile/shotgun/pump/rifle/obrez = 1,
		/obj/item/gun/projectile/shotgun/pump/rifle/vintage = 1,
		/obj/item/gun/projectile/shotgun/pump/lever_action = 0.5,
		/obj/item/gun/launcher/harpoon = 1
		)

	var/list/Common = list(
		/obj/item/gun/energy/blaster/carbine = 1,
		/obj/item/gun/energy/crossbow/largecrossbow = 1,
		/obj/item/gun/energy/laser = 0.5,
		/obj/item/gun/energy/pistol = 1,
		/obj/item/gun/energy/rifle = 1,
		/obj/item/gun/projectile/automatic/c20r = 1,
		/obj/item/gun/projectile/automatic/mini_uzi = 1,
		/obj/item/gun/projectile/automatic/tommygun = 1,
		/obj/item/gun/projectile/automatic/lebman = 1,
		/obj/item/gun/projectile/automatic/wt550/lethal = 0.5,
		/obj/item/gun/projectile/colt = 0.5,
		/obj/item/gun/projectile/colt/super = 1,
		/obj/item/gun/projectile/pistol/sol = 1,
		/obj/item/gun/projectile/pistol/adhomai = 1,
		/obj/item/gun/projectile/revolver/detective = 0.5,
		/obj/item/gun/projectile/revolver/adhomian = 1,
		/obj/item/gun/projectile/revolver/lemat = 1,
		/obj/item/gun/projectile/sec/lethal= 0.5,
		/obj/item/gun/projectile/shotgun/doublebarrel/pellet = 1,
		/obj/item/gun/projectile/shotgun/pump/rifle = 1,
		/obj/item/gun/projectile/tanto = 1,
		/obj/item/gun/projectile/gauss = 1,
		/obj/item/gun/projectile/revolver/knife = 1
		)

	var/list/Rare = list(
		/obj/item/gun/energy/blaster/revolver = 1,
		/obj/item/gun/energy/blaster/rifle = 1,
		/obj/item/gun/energy/pistol/hegemony = 1,
		/obj/item/gun/energy/rifle/laser = 1,
		/obj/item/gun/energy/rifle/icelance = 1,
		/obj/item/gun/energy/rifle/ionrifle = 0.5,
		/obj/item/gun/energy/vaurca/blaster = 1,
		/obj/item/gun/energy/xray = 1,
		/obj/item/gun/energy/lasercannon = 1,
		/obj/item/gun/projectile/automatic/rifle/sts35 = 1,
		/obj/item/gun/projectile/automatic/rifle/shorty = 1,
		/obj/item/gun/projectile/automatic/rifle/carbine = 1,
		/obj/item/gun/projectile/automatic/x9 = 1,
		/obj/item/gun/projectile/deagle = 1,
		/obj/item/gun/projectile/deagle/adhomai = 1,
		/obj/item/gun/projectile/silenced = 1,
		/obj/item/gun/projectile/dragunov = 1,
		/obj/item/gun/projectile/plasma/bolter = 0.5,
		/obj/item/gun/projectile/shotgun/doublebarrel/sawn = 1,
		/obj/item/gun/projectile/shotgun/foldable = 1,
		/obj/item/gun/projectile/shotgun/pump/combat = 1,
		/obj/item/gun/projectile/shotgun/pump/combat/sol = 1,
		/obj/item/gun/projectile/automatic/rifle/adhomian = 1,
		/obj/item/gun/projectile/musket = 0.5,
		/obj/item/gun/launcher/grenade = 1,
		/obj/item/gun/energy/freeze = 0.5
		)

	var/list/Epic = list(
		/obj/item/gun/energy/decloner = 0.5,
		/obj/item/gun/energy/rifle/laser/xray = 1,
		/obj/item/gun/energy/rifle/laser/tachyon = 1,
		/obj/item/gun/energy/sniperrifle = 1,
		/obj/item/gun/energy/tesla = 1,
		/obj/item/gun/energy/laser/shotgun = 1,
		/obj/item/gun/energy/vaurca/gatlinglaser = 1,
		/obj/item/gun/projectile/automatic/rifle/shotgun = 0.5,
		/obj/item/gun/projectile/automatic/rifle/sol = 1,
		/obj/item/gun/projectile/automatic/rifle/w556 = 1,
		/obj/item/gun/projectile/automatic/rifle/z8 = 1,
		/obj/item/gun/projectile/cannon = 1,
		/obj/item/gun/projectile/plasma = 0.5,
		/obj/item/gun/projectile/revolver = 0.5
		)

	var/list/Legendary = list(
		/obj/item/gun/energy/lawgiver = 1,
		/obj/item/gun/energy/pulse = 1,
		/obj/item/gun/energy/pulse/pistol = 1,
		/obj/item/gun/energy/rifle/pulse = 1,
		/obj/item/gun/projectile/automatic/railgun = 1,
		/obj/item/gun/projectile/automatic/rifle/l6_saw = 1,
		/obj/item/gun/projectile/automatic/terminator = 1,
		/obj/item/gun/projectile/gyropistol = 1,
		/obj/item/gun/projectile/nuke = 1,
		/obj/item/gun/projectile/revolver/mateba = 1
		)

/obj/random/weapon_and_ammo/concealable
	concealable = TRUE

/obj/random/weapon_and_ammo/post_spawn(var/obj/item/gun/projectile/spawned)
	if(istype(spawned, /obj/item/gun/energy))
		return

	else if(istype(spawned, /obj/item/gun/projectile))
		if(spawned.magazine_type)
			var/obj/item/ammo_magazine/am = spawned.magazine_type
			new am(spawned.loc)
			new am(spawned.loc)
		else if(istype(spawned, /obj/item/gun/projectile/shotgun) && spawned.caliber == "shotgun")
			if(istype(spawned.loc, /obj/item/storage/box))
				spawned.loc.icon_state = "largebox"
			var/obj/item/storage/box/b = new /obj/item/storage/box(spawned.loc)
			for(var/i = 0; i < 8; i++)
				new spawned.ammo_type(b)
		else if(spawned.ammo_type)
			var/list/provided_ammo = list()
			for(var/i = 0; i < (spawned.max_shells * 2); i++)
				provided_ammo += new spawned.ammo_type(spawned.loc)
			if(provided_ammo.len)
				new /obj/item/ammo_pile(spawned.loc, provided_ammo)

		if(istype(spawned, /obj/item/gun/projectile/musket))
			new /obj/item/reagent_containers/powder_horn(spawned.loc)

	else if(istype(spawned, /obj/item/gun/launcher))
		if(istype(spawned, /obj/item/gun/launcher/harpoon))
			for(var/i in 1 to 4)
				new /obj/item/material/harpoon(spawned.loc)
		if(istype(spawned, /obj/item/gun/launcher/grenade))
			var/list/grenade_types = list(
				/obj/item/grenade/smokebomb,
				/obj/item/grenade/flashbang,
				/obj/item/grenade/empgrenade,
				/obj/item/grenade/chem_grenade/incendiary
				)
			var/obj/item/storage/bag/plasticbag/bag = new /obj/item/storage/bag/plasticbag(spawned.loc)
			for(var/i in 1 to 7)
				var/chosen_type = pick(grenade_types)
				new chosen_type(bag)

/obj/random/weapon_and_ammo/spawn_item()
	var/obj/item/W = pick_gun()
	. = new W(loc)

/obj/random/weapon_and_ammo/proc/pick_gun()
	var/list/possible_rarities = list(
		"Shoddy" = 25,
		"Common" = 35,
		"Rare" = 25,
		"Epic" = 14,
		"Legendary" = 1
		)
	if(!chosen_rarity)
		chosen_rarity = pickweight(possible_rarities)
	var/obj/item/W
	switch(chosen_rarity)
		if("Shoddy")
			W = pickweight(Shoddy)
		if("Common")
			W = pickweight(Common)
		if("Rare")
			W = pickweight(Rare)
		if("Epic")
			W = pickweight(Epic)
		if("Legendary")
			W = pickweight(Legendary)
	if(concealable)
		var/weapon_w_class = initial(W.w_class)
		if(weapon_w_class > 3)
			chosen_rarity = null
			return pick_gun()

	return W
