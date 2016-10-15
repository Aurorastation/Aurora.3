/obj/random
	name = "random object"
	desc = "This item type is used to spawn random objects at round-start"
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything


// creates a new object and deletes itself
/obj/random/New()
	..()
	if (!prob(spawn_nothing_percentage))
		spawn_item()
	qdel(src)


// this function should return a specific item to spawn
/obj/random/proc/item_to_spawn()
	return 0


// creates the random item
/obj/random/proc/spawn_item()
	var/build_path = item_to_spawn()
	return (new build_path(src.loc))


/obj/random/single
	name = "randomly spawned object"
	desc = "This item type is used to randomly spawn a given object at round-start"
	icon_state = "x3"
	var/spawn_object = null
	item_to_spawn()
		return ispath(spawn_object) ? spawn_object : text2path(spawn_object)


/obj/random/tool
	name = "random tool"
	desc = "This is a random tool"
	icon = 'icons/obj/items.dmi'
	icon_state = "welder"
	item_to_spawn()
		return pick(/obj/item/weapon/screwdriver,\
					/obj/item/weapon/wirecutters,\
					/obj/item/weapon/weldingtool,\
					/obj/item/weapon/crowbar,\
					/obj/item/weapon/wrench,\
					/obj/item/device/flashlight)


/obj/random/technology_scanner
	name = "random scanner"
	desc = "This is a random technology scanner."
	icon = 'icons/obj/device.dmi'
	icon_state = "atmos"
	item_to_spawn()
		return pick(prob(5);/obj/item/device/t_scanner,\
					prob(2);/obj/item/device/radio,\
					prob(5);/obj/item/device/analyzer)


/obj/random/powercell
	name = "random powercell"
	desc = "This is a random powercell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	item_to_spawn()
		return pick(prob(10);/obj/item/weapon/cell/crap,\
					prob(40);/obj/item/weapon/cell,\
					prob(40);/obj/item/weapon/cell/high,\
					prob(9);/obj/item/weapon/cell/super,\
					prob(1);/obj/item/weapon/cell/hyper)


/obj/random/bomb_supply
	name = "bomb supply"
	desc = "This is a random bomb supply."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "signaller"
	item_to_spawn()
		return pick(/obj/item/device/assembly/igniter,\
					/obj/item/device/assembly/prox_sensor,\
					/obj/item/device/assembly/signaler,\
					/obj/item/device/multitool)


/obj/random/toolbox
	name = "random toolbox"
	desc = "This is a random toolbox."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"
	item_to_spawn()
		return pick(prob(3);/obj/item/weapon/storage/toolbox/mechanical,\
					prob(2);/obj/item/weapon/storage/toolbox/electrical,\
					prob(1);/obj/item/weapon/storage/toolbox/emergency)


/obj/random/tech_supply
	name = "random tech supply"
	desc = "This is a random piece of technology supplies."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	spawn_nothing_percentage = 50
	item_to_spawn()
		return pick(prob(3);/obj/random/powercell,\
					prob(2);/obj/random/technology_scanner,\
					prob(1);/obj/item/weapon/packageWrap,\
					prob(2);/obj/random/bomb_supply,\
					prob(1);/obj/item/weapon/extinguisher,\
					prob(1);/obj/item/clothing/gloves/fyellow,\
					prob(3);/obj/item/stack/cable_coil,\
					prob(2);/obj/random/toolbox,\
					prob(2);/obj/item/weapon/storage/belt/utility,\
					prob(5);/obj/random/tool,\
					prob(2);/obj/item/weapon/tape_roll)

/obj/random/medical
	name = "Random Medicine"
	desc = "This is a random medical item."
	icon = 'icons/obj/items.dmi'
	icon_state = "brutepack"
	spawn_nothing_percentage = 25
	item_to_spawn()
		return pick(prob(4);/obj/item/stack/medical/bruise_pack,\
					prob(4);/obj/item/stack/medical/ointment,\
					prob(2);/obj/item/stack/medical/advanced/bruise_pack,\
					prob(2);/obj/item/stack/medical/advanced/ointment,\
					prob(1);/obj/item/stack/medical/splint,\
					prob(2);/obj/item/bodybag,\
					prob(1);/obj/item/bodybag/cryobag,\
					prob(2);/obj/item/weapon/storage/pill_bottle/kelotane,\
					prob(2);/obj/item/weapon/storage/pill_bottle/antitox,\
					prob(2);/obj/item/weapon/storage/pill_bottle/tramadol,\
					prob(2);/obj/item/weapon/reagent_containers/syringe/antitoxin,\
					prob(1);/obj/item/weapon/reagent_containers/syringe/antiviral,\
					prob(2);/obj/item/weapon/reagent_containers/syringe/inaprovaline,\
					prob(1);/obj/item/stack/nanopaste)


/obj/random/firstaid
	name = "Random First Aid Kit"
	desc = "This is a random first aid kit."
	icon = 'icons/obj/storage.dmi'
	icon_state = "firstaid"
	item_to_spawn()
		return pick(prob(3);/obj/item/weapon/storage/firstaid/regular,\
					prob(2);/obj/item/weapon/storage/firstaid/toxin,\
					prob(2);/obj/item/weapon/storage/firstaid/o2,\
					prob(1);/obj/item/weapon/storage/firstaid/adv,\
					prob(2);/obj/item/weapon/storage/firstaid/fire)


/obj/random/contraband
	name = "Random Illegal Item"
	desc = "Hot Stuff."
	icon = 'icons/obj/items.dmi'
	icon_state = "purplecomb"
	spawn_nothing_percentage = 50
	item_to_spawn()
		return pick(prob(3);/obj/item/weapon/storage/pill_bottle/tramadol,\
					prob(4);/obj/item/weapon/haircomb,\
					prob(2);/obj/item/weapon/storage/pill_bottle/happy,\
					prob(2);/obj/item/weapon/storage/pill_bottle/zoom,\
					prob(5);/obj/item/weapon/contraband/poster,\
					prob(2);/obj/item/weapon/material/butterfly,\
					prob(3);/obj/item/weapon/material/butterflyblade,\
					prob(3);/obj/item/weapon/material/butterflyhandle,\
					prob(3);/obj/item/weapon/material/wirerod,\
					prob(1);/obj/item/weapon/material/butterfly/switchblade,\
					prob(1);/obj/item/weapon/reagent_containers/syringe/drugs)


/obj/random/energy
	name = "Random Energy Weapon"
	desc = "This is a random security weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "energykill100"
	item_to_spawn()
		return pick(prob(2);/obj/item/weapon/gun/energy/rifle/laser,\
					prob(2);/obj/item/weapon/gun/energy/gun,\
					prob(1);/obj/item/weapon/gun/energy/stunrevolver)

/obj/random/projectile
	name = "Random Projectile Weapon"
	desc = "This is a random security weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "revolver"
	item_to_spawn()
		return pick(prob(3);/obj/item/weapon/gun/projectile/shotgun/pump,\
					prob(2);/obj/item/weapon/gun/projectile/automatic/wt550,\
					prob(1);/obj/item/weapon/gun/projectile/shotgun/pump/combat)

/obj/random/handgun
	name = "Random Handgun"
	desc = "This is a random security sidearm."
	icon = 'icons/obj/gun.dmi'
	icon_state = "secgundark"
	item_to_spawn()
		return pick(prob(3);/obj/item/weapon/gun/projectile/sec,\
					prob(1);/obj/item/weapon/gun/projectile/sec/wood)


/obj/random/ammo
	name = "Random Ammunition"
	desc = "This is random ammunition."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "45-10"
	item_to_spawn()
		return pick(prob(6);/obj/item/weapon/storage/box/beanbags,\
					prob(2);/obj/item/weapon/storage/box/shotgunammo,\
					prob(4);/obj/item/weapon/storage/box/shotgunshells,\
					prob(1);/obj/item/weapon/storage/box/stunshells,\
					prob(2);/obj/item/ammo_magazine/c45m,\
					prob(4);/obj/item/ammo_magazine/c45m/rubber,\
					prob(4);/obj/item/ammo_magazine/c45m/flash,\
					prob(2);/obj/item/ammo_magazine/mc9mmt,\
					prob(6);/obj/item/ammo_magazine/mc9mmt/rubber)


/obj/random/action_figure
	name = "random action figure"
	desc = "This is a random action figure."
	icon = 'icons/obj/toy.dmi'
	icon_state = "assistant"
	item_to_spawn()
		return pick(/obj/item/toy/figure/cmo,\
					/obj/item/toy/figure/assistant,\
					/obj/item/toy/figure/atmos,\
					/obj/item/toy/figure/bartender,\
					/obj/item/toy/figure/borg,\
					/obj/item/toy/figure/gardener,\
					/obj/item/toy/figure/captain,\
					/obj/item/toy/figure/cargotech,\
					/obj/item/toy/figure/ce,\
					/obj/item/toy/figure/chaplain,\
					/obj/item/toy/figure/chef,\
					/obj/item/toy/figure/chemist,\
					/obj/item/toy/figure/clown,\
					/obj/item/toy/figure/corgi,\
					/obj/item/toy/figure/detective,\
					/obj/item/toy/figure/dsquad,\
					/obj/item/toy/figure/engineer,\
					/obj/item/toy/figure/geneticist,\
					/obj/item/toy/figure/hop,\
					/obj/item/toy/figure/hos,\
					/obj/item/toy/figure/qm,\
					/obj/item/toy/figure/janitor,\
					/obj/item/toy/figure/agent,\
					/obj/item/toy/figure/librarian,\
					/obj/item/toy/figure/md,\
					/obj/item/toy/figure/mime,\
					/obj/item/toy/figure/miner,\
					/obj/item/toy/figure/ninja,\
					/obj/item/toy/figure/wizard,\
					/obj/item/toy/figure/rd,\
					/obj/item/toy/figure/roboticist,\
					/obj/item/toy/figure/scientist,\
					/obj/item/toy/figure/syndie,\
					/obj/item/toy/figure/secofficer,\
					/obj/item/toy/figure/warden,\
					/obj/item/toy/figure/psychologist,\
					/obj/item/toy/figure/paramedic,\
					/obj/item/toy/figure/ert)


/obj/random/plushie
	name = "random plushie"
	desc = "This is a random plushie."
	icon = 'icons/obj/toy.dmi'
	icon_state = "nymphplushie"
	item_to_spawn()
		return pick(/obj/structure/plushie/ian,\
					/obj/structure/plushie/drone,\
					/obj/structure/plushie/carp,\
					/obj/structure/plushie/beepsky,\
					/obj/item/toy/plushie/nymph,\
					/obj/item/toy/plushie/mouse,\
					/obj/item/toy/plushie/kitten,\
					/obj/item/toy/plushie/lizard)

/obj/random/glowstick
	name = "random glowstick"
	desc = "This is a random glowstick."
	icon = 'icons/obj/glowsticks.dmi'
	icon_state = "glowstick"
	item_to_spawn()
		return pick(/obj/item/device/flashlight/glowstick,\
					/obj/item/device/flashlight/glowstick/red,\
					/obj/item/device/flashlight/glowstick/blue,\
					/obj/item/device/flashlight/glowstick/orange,\
					/obj/item/device/flashlight/glowstick/yellow)

/obj/random/booze
	name = "random alcoholic drink"
	desc = "This is a random alcoholic drink."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "broken_bottle"
	item_to_spawn()
		return pick(/obj/item/weapon/reagent_containers/food/drinks/bottle/gin,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/rum,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/vermouth,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/kahlua,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/wine,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/melonliquor,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/pwine,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/brandy,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/guinnes,\
					/obj/item/weapon/reagent_containers/food/drinks/bottle/drambuie,\
					/obj/item/weapon/reagent_containers/food/drinks/cans/beer,\
					/obj/item/weapon/reagent_containers/food/drinks/cans/ale)

/obj/random/melee
	name = "random melee weapon"
	desc = "This is a random melee weapon."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "baton"
	item_to_spawn()
		return pick(/obj/item/weapon/melee/telebaton,\
					/obj/item/weapon/melee/energy/sword,\
					/obj/item/weapon/melee/energy/sword/pirate,\
					/obj/item/weapon/melee/energy/glaive,\
					/obj/item/weapon/melee/chainsword,\
					/obj/item/weapon/melee/baton/stunrod,\
					/obj/item/weapon/material/harpoon,\
					/obj/item/weapon/material/scythe,\
					/obj/item/weapon/material/twohanded/spear/plasteel,\
					/obj/item/weapon/material/sword/trench,\
					/obj/item/weapon/material/sword/rapier)

/obj/random/coin
	name = "Random Coin"
	desc = "This is a random coin."
	icon = 'icons/obj/items.dmi'
	icon_state = "coin"
	item_to_spawn()
		return pick(prob(5);/obj/item/weapon/coin/iron,\
					prob(3);/obj/item/weapon/coin/silver,\
					prob(2);/obj/item/weapon/coin/gold,\
					prob(2);/obj/item/weapon/coin/phoron,\
					prob(2);/obj/item/weapon/coin/uranium,\
					prob(1);/obj/item/weapon/coin/platinum,\
					prob(1);/obj/item/weapon/coin/diamond)
/obj/random/energy_antag
	name = "Random Energy Weapon"
	desc = "This is a random energy weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "retro100"
	item_to_spawn()
		return pick(/obj/item/weapon/gun/energy/retro,\
					/obj/item/weapon/gun/energy/xray,\
					/obj/item/weapon/gun/energy/gun,\
					/obj/item/weapon/gun/energy/pistol,\
					/obj/item/weapon/gun/energy/rifle,\
					/obj/item/weapon/gun/energy/mindflayer,\
					/obj/item/weapon/gun/energy/toxgun,\
					/obj/item/weapon/gun/energy/vaurca/gatlinglaser,\
					/obj/item/weapon/gun/energy/vaurca/blaster,\
					/obj/item/weapon/gun/energy/crossbow/largecrossbow)

/obj/random/loot
	name = "Random Maintenance Loot Items"
	desc = "Stuff for the maint-dwellers."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift3"
	item_to_spawn()
		return pick(prob(2);/obj/item/clothing/glasses/meson,\
					prob(1);/obj/item/clothing/glasses/meson/prescription,\
					prob(1);/obj/item/clothing/glasses/monocle,\
					prob(1);/obj/item/clothing/glasses/material,\
					prob(2);/obj/item/clothing/glasses/sunglasses,\
					prob(2);/obj/item/clothing/glasses/welding,\
					prob(1);/obj/item/clothing/under/captain_fly,\
					prob(1);/obj/item/clothing/under/rank/mailman,\
					prob(1);/obj/item/clothing/under/rank/vice,\
					prob(1);/obj/item/clothing/under/assistantformal,\
					prob(2);/obj/item/clothing/under/rainbow,\
					prob(1);/obj/item/clothing/under/overalls,\
					prob(1);/obj/item/clothing/under/redcoat,\
					prob(1);/obj/item/clothing/under/psyche,\
					prob(1);/obj/item/clothing/under/track,\
					prob(1);/obj/item/clothing/under/rank/dispatch,\
					prob(1);/obj/item/clothing/under/syndicate/tacticool,\
					prob(1);/obj/item/clothing/head/collectable/petehat,\
					prob(2);/obj/item/clothing/head/hardhat,\
					prob(1);/obj/item/clothing/head/redcoat,\
					prob(1);/obj/item/clothing/head/syndicatefake,\
					prob(1);/obj/item/clothing/head/richard,\
					prob(1);/obj/item/clothing/head/soft/rainbow,\
					prob(1);/obj/item/clothing/mask/balaclava,\
					prob(3);/obj/item/clothing/mask/gas,\
					prob(1);/obj/item/clothing/mask/gas/cyborg,\
					prob(1);/obj/item/clothing/mask/gas/owl_mask,\
					prob(1);/obj/item/clothing/mask/fakemoustache,\
					prob(1);/obj/item/clothing/mask/horsehead,\
					prob(2);/obj/item/clothing/shoes/rainbow,\
					prob(1);/obj/item/clothing/shoes/jackboots,\
					prob(1);/obj/item/clothing/shoes/workboots,\
					prob(1);/obj/item/clothing/shoes/cyborg,\
					prob(2);/obj/item/clothing/suit/storage/hazardvest,\
					prob(1);/obj/item/clothing/suit/storage/toggle/labcoat/mad,\
					prob(1);/obj/item/clothing/suit/storage/leather_jacket/nanotrasen,\
					prob(1);/obj/item/clothing/suit/storage/toggle/tracksuit,\
					prob(1);/obj/item/clothing/suit/ianshirt,\
					prob(1);/obj/item/clothing/suit/syndicatefake,\
					prob(3);/obj/item/clothing/gloves/black,\
					prob(2);/obj/item/clothing/gloves/fyellow,\
					prob(1);/obj/item/clothing/gloves/yellow,\
					prob(1);/obj/item/clothing/gloves/watch,\
					prob(1);/obj/item/clothing/gloves/boxing,\
					prob(1);/obj/item/clothing/gloves/boxing/green,\
					prob(1);/obj/item/toy/bosunwhistle,\
					prob(1);/obj/item/toy/balloon,\
					prob(2);/obj/item/weapon/haircomb,\
					prob(2);/obj/item/weapon/lipstick,\
					prob(1);/obj/item/weapon/material/knife/hook,\
					prob(1);/obj/item/weapon/material/hatchet/tacknife,\
					prob(2);/obj/item/weapon/storage/fancy/cigarettes/dromedaryco,\
					prob(2);/obj/item/weapon/storage/bag/plasticbag,\
					prob(3);/obj/item/weapon/extinguisher,\
					prob(1);/obj/item/weapon/extinguisher/mini,\
					prob(1);/obj/item/device/radiojammer/improvised,\
					prob(3);/obj/item/device/flashlight,\
					prob(1);/obj/item/device/flashlight/heavy,\
					prob(1);/obj/item/device/flashlight/maglight,\
					prob(1);/obj/item/device/flashlight/flare,\
					prob(1);/obj/item/device/flashlight/lantern,\
					prob(1);/obj/item/weapon/reagent_containers/food/drinks/teapot,\
					prob(1);/obj/item/weapon/reagent_containers/food/drinks/flask/shiny,\
					prob(1);/obj/item/weapon/reagent_containers/food/drinks/flask/lithium,\
					prob(1);/obj/item/bodybag,\
					prob(3);/obj/item/stack/material/steel{amount = 25},\
					prob(2);/obj/item/stack/material/wood{amount = 25},\
					prob(2);/obj/item/stack/material/glass{amount = 25},\
					prob(1);/obj/item/stack/material/plasteel{amount = 10},\
					prob(1);/obj/item/weapon/reagent_containers/spray/cleaner,\
					prob(2);/obj/item/weapon/tank/emergency_oxygen,\
					prob(1);/obj/item/weapon/tank/emergency_oxygen/double,\
					prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba,\
					prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar/havana,\
					prob(1);/obj/item/clothing/mask/smokable/pipe/cobpipe,\
					prob(2);/obj/item/weapon/flame/lighter,\
					prob(1);/obj/item/weapon/flame/lighter/zippo,\
					prob(1);/obj/item/weapon/reagent_containers/glass/bottle/capsaicin,\
					prob(1);/obj/item/weapon/reagent_containers/glass/bottle/frostoil,\
					prob(1);/obj/item/device/gps/engineering,\
					prob(1);/obj/item/device/megaphone,\
					prob(1);/obj/item/device/floor_painter,\
					prob(2);/obj/random/toolbox,\
					prob(2);/obj/random/coin,\
					prob(2);/obj/random/tech_supply,\
					prob(1);/obj/random/plushie,\
					prob(2);/obj/random/booze,\
					prob(1);/obj/random/contraband,\
					prob(1);/obj/random/glowstick,\
					prob(1);/obj/item/weapon/caution/cone,\
					prob(1);/obj/item/weapon/staff/broom,\
					prob(1);/obj/item/weapon/soap,\
					prob(1);/obj/item/weapon/material/wirerod,\
					prob(2);/obj/item/weapon/storage/box/donkpockets,\
					prob(3);/obj/item/weapon/contraband/poster)
