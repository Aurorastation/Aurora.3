/obj/random/energy
	name = "random energy weapon"
	desc = "This is a random energy weapon."
	icon = 'icons/obj/guns/ecarbine.dmi'
	icon_state = "energykill100"
	problist = list(
		/obj/item/gun/energy/rifle/laser = 2,
		/obj/item/gun/energy/gun = 2,
		/obj/item/gun/energy/stunrevolver = 1
	)

/obj/random/projectile
	name = "random projectile weapon"
	desc = "This is a random projectile weapon."
	icon = 'icons/obj/guns/cshotgun.dmi'
	icon_state = "cshotgun"
	problist = list(
		/obj/item/gun/projectile/shotgun/pump = 3,
		/obj/item/gun/projectile/automatic/wt550 = 2,
		/obj/item/gun/projectile/shotgun/pump/combat = 1
	)

/obj/random/handgun
	name = "random handgun"
	desc = "This is a random handgun."
	icon = 'icons/obj/guns/secgun.dmi'
	icon_state = "secgun"
	problist = list(
		/obj/item/gun/projectile/sec = 3,
		/obj/item/gun/projectile/sec/wood = 1
	)

/obj/random/ammo
	name = "random ammunition"
	desc = "This is some random ammunition."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "45-10"
	problist = list(
		/obj/item/storage/box/beanbags = 6,
		/obj/item/storage/box/shotgunammo = 2,
		/obj/item/storage/box/shotgunshells = 4,
		/obj/item/storage/box/stunshells = 1,
		/obj/item/ammo_magazine/c45m = 2,
		/obj/item/ammo_magazine/c45m/rubber = 4,
		/obj/item/ammo_magazine/c45m/flash = 4,
		/obj/item/ammo_magazine/mc9mmt = 2,
		/obj/item/ammo_magazine/mc9mmt/rubber = 6
	)

/obj/random/melee
	name = "random melee weapon"
	desc = "This is a random melee weapon."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "baton"
	spawnlist = list(
		/obj/item/melee/telebaton,
		/obj/item/melee/energy/sword,
		/obj/item/melee/energy/sword/pirate,
		/obj/item/melee/energy/glaive,
		/obj/item/melee/chainsword,
		/obj/item/melee/baton/stunrod,
		/obj/item/material/harpoon,
		/obj/random/sword,
		/obj/item/melee/hammer,
		/obj/item/melee/hammer/powered,
		/obj/item/material/twohanded/fireaxe,
		/obj/item/melee/classic_baton,
		/obj/item/material/twohanded/pike,
		/obj/item/material/twohanded/pike/halberd,
		/obj/item/material/twohanded/pike/pitchfork,
		/obj/item/melee/whip,
		/obj/item/clothing/accessory/storage/bayonet
	)

/obj/random/melee/highvalue
	name = "random high value melee weapon"
	desc = "This is a random high value melee weapon."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "baton"
	spawnlist = list(
		/obj/item/melee/energy/sword,
		/obj/item/melee/energy/glaive,
		/obj/item/melee/chainsword,
		/obj/item/melee/hammer,
		/obj/item/melee/hammer/powered
	)

/obj/random/energy_antag
	name = "random energy weapon"
	desc = "This is a random energy weapon."
	icon = 'icons/obj/guns/retro.dmi'
	icon_state = "retro100"
	spawnlist = list(
		/obj/item/gun/energy/retro,
		/obj/item/gun/energy/xray,
		/obj/item/gun/energy/gun,
		/obj/item/gun/energy/pistol,
		/obj/item/gun/energy/mindflayer,
		/obj/item/gun/energy/toxgun,
		/obj/item/gun/energy/vaurca/gatlinglaser,
		/obj/item/gun/energy/vaurca/blaster,
		/obj/item/gun/energy/crossbow/largecrossbow,
		/obj/item/gun/energy/rifle,
		/obj/item/gun/energy/rifle/laser,
		/obj/item/gun/energy/rifle/laser/heavy,
		/obj/item/gun/energy/rifle/laser/xray,
		/obj/item/gun/energy/net,
		/obj/item/gun/energy/laser/shotgun,
		/obj/item/gun/energy/decloner,
		/obj/item/gun/energy/freeze
	)

/obj/random/sword
	name = "random sword"
	desc = "This is a random sword."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "claymore"
	spawnlist = list(
		/obj/item/material/sword,
		/obj/item/material/sword/katana,
		/obj/item/material/sword/rapier,
		/obj/item/material/sword/longsword,
		/obj/item/material/sword/sabre,
		/obj/item/material/sword/axe,
		/obj/item/material/sword/khopesh,
		/obj/item/material/sword/dao,
		/obj/item/material/sword/gladius
	)

/obj/random/civgun
	name = "random civilian handgun"
	desc = "This is a random civilian gun."
	icon = 'icons/obj/random.dmi'
	icon_state = "pistol"
	has_postspawn = TRUE
	spawnlist = list(
		/obj/item/gun/projectile/leyon,
		/obj/item/gun/energy/blaster,
		/obj/item/gun/energy/pistol,
		/obj/item/gun/projectile/revolver/detective,
		/obj/item/gun/projectile/sec/lethal,
		/obj/item/gun/projectile/colt,
		/obj/item/gun/projectile/pistol,
		/obj/item/gun/projectile/pistol/detective,
		/obj/item/gun/projectile/pistol/adhomai,
		/obj/item/gun/projectile/pistol/sol,
		/obj/item/gun/energy/blaster/revolver,
		/obj/item/gun/projectile/revolver/lemat,
		/obj/item/gun/projectile/tanto,
		/obj/item/gun/projectile/automatic/x9,
		/obj/item/gun/energy/disruptorpistol,
		/obj/item/gun/energy/retro,
		/obj/item/gun/projectile/revolver/konyang/pirate
	)

/obj/random/civgun/post_spawn(var/obj/item/gun/projectile/spawned)
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

/obj/random/civgun/rifle
	name = "random civilian longarm"
	desc = "This is a random civilian long gun."
	icon = 'icons/obj/random.dmi'
	icon_state = "rifle"
	has_postspawn = TRUE
	spawnlist = list(
		/obj/item/gun/projectile/automatic/mini_uzi,
		/obj/item/gun/projectile/automatic/c20r,
		/obj/item/gun/projectile/automatic/wt550/lethal,
		/obj/item/gun/projectile/automatic/rifle/carbine,
		/obj/item/gun/projectile/automatic/rifle/carbine/civcarbine,
		/obj/item/gun/projectile/automatic/tommygun,
		/obj/item/gun/projectile/shotgun/pump/rifle,
		/obj/item/gun/projectile/shotgun/pump/rifle/pipegun,
		/obj/item/gun/projectile/shotgun/pump/rifle/obrez,
		/obj/item/gun/projectile/contender,
		/obj/item/gun/projectile/shotgun/pump/rifle/vintage,
		/obj/item/gun/projectile/shotgun/pump/lever_action,
		/obj/item/gun/projectile/gauss,
		/obj/item/gun/projectile/gauss/carbine,
		/obj/item/gun/projectile/shotgun/pump,
		/obj/item/gun/projectile/shotgun/doublebarrel,
		/obj/item/gun/projectile/shotgun/doublebarrel/sawn,
		/obj/item/gun/projectile/shotgun/foldable,
		/obj/item/gun/projectile/revolver,
		/obj/item/gun/energy/blaster/carbine,
		/obj/item/gun/energy/laser/shotgun,
		/obj/item/gun/energy/rifle,
		/obj/item/gun/energy/rifle/laser,
		/obj/item/gun/energy/gun,
		/obj/item/gun/custom_ka/frame04/illegal,
		/obj/item/gun/projectile/automatic/lebman,
		/obj/item/gun/projectile/pistol/super_heavy,
		/obj/item/gun/projectile/deagle,
		/obj/item/gun/custom_ka/frame01/illegal,
		/obj/item/gun/projectile/automatic/rifle/konyang/pirate_rifle,
		/obj/item/gun/projectile/automatic/konyang_pirate
	)

/obj/random/vault_weapon
	name = "random vault weapon"
	desc = "This is a random vault weapon."
	icon = 'icons/obj/guns/caplaser.dmi'
	icon_state = "caplaser"
	spawnlist = list(
		/obj/item/gun/custom_ka/frameA/prebuilt = 1,
		/obj/item/gun/custom_ka/frameB/prebuilt = 0.5,
		/obj/item/gun/custom_ka/frameC/prebuilt = 0.25,
		/obj/item/gun/custom_ka/frameD/prebuilt = 0.125,
		/obj/item/gun/custom_ka/frameF/prebuilt01 = 0.03125,
		/obj/item/gun/custom_ka/frameF/prebuilt02 = 0.03125,
		/obj/item/gun/custom_ka/frameE/prebuilt = 0.03125,
		/obj/item/gun/energy/captain/xenoarch = 0.5,
		/obj/item/gun/energy/laser/xenoarch = 0.5,
		/obj/item/gun/energy/laser/practice/xenoarch = 0.25,
		/obj/item/gun/energy/xray/xenoarch = 0.25,
		/obj/item/gun/energy/net = 1
	)

/obj/random/vault_weapon/post_spawn(var/obj/item/gun/spawned)
	spawned.name = "prototype [spawned.name]"
	if(istype(spawned,/obj/item/gun/custom_ka/))
		var/obj/item/gun/custom_ka/KA = spawned
		KA.can_disassemble_barrel = FALSE
		KA.can_disassemble_cell = FALSE

	if(istype(spawned,/obj/item/gun/energy/))
		var/obj/item/gun/energy/E = spawned
		E.charge_cost *= 2
		E.self_recharge = 0
		E.reliability = 90
