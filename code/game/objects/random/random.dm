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
//	spawn_nothing_percentage = 50
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
//	spawn_nothing_percentage = 50
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

/obj/random/smalltank/item_to_spawn()
	if (prob(40))
		return /obj/item/weapon/tank/emergency_oxygen
	else if (prob(60))
		return /obj/item/weapon/tank/emergency_oxygen/engi
	else
		return /obj/item/weapon/tank/emergency_oxygen/double

/obj/random/belt/item_to_spawn()
	var/list/belts = list("/obj/item/weapon/storage/belt/utility" = 1,
	"/obj/item/weapon/storage/belt/medical" = 0.4,
	"/obj/item/weapon/storage/belt/medical/emt" = 0.4,
	"/obj/item/weapon/storage/belt/security/tactical" = 0.1,
	"/obj/item/weapon/storage/belt/military" = 0.1,
	"/obj/item/weapon/storage/belt/janitor" = 0.4
	)
	return pickweight(belts)


//Spawns a random backpack
//Novelty and rare backpacks have lower weights
/obj/random/backpack/item_to_spawn()
	var/list/packs = list(
	"/obj/item/weapon/storage/backpack" = 3,
	"/obj/item/weapon/storage/backpack/holding" = 0.5,
	"/obj/item/weapon/storage/backpack/santabag" = 2,
	"/obj/item/weapon/storage/backpack/cultpack" = 2,
	"/obj/item/weapon/storage/backpack/clown" = 2,
	"/obj/item/weapon/storage/backpack/medic" = 3,
	"/obj/item/weapon/storage/backpack/security" = 3,
	"/obj/item/weapon/storage/backpack/captain" = 2,
	"/obj/item/weapon/storage/backpack/industrial" = 3,
	"/obj/item/weapon/storage/backpack/toxins" = 3,
	"/obj/item/weapon/storage/backpack/hydroponics" = 3,
	"/obj/item/weapon/storage/backpack/genetics" = 3,
	"/obj/item/weapon/storage/backpack/virology" = 3,
	"/obj/item/weapon/storage/backpack/chemistry" = 3,
	"/obj/item/weapon/storage/backpack/cloak" = 2,
	"/obj/item/weapon/storage/backpack/syndie" = 2,
	"/obj/item/weapon/storage/backpack/wizard" = 2,
	"/obj/item/weapon/storage/backpack/satchel" = 3,
	"/obj/item/weapon/storage/backpack/satchel_norm" = 3,
	"/obj/item/weapon/storage/backpack/satchel_eng" = 3,
	"/obj/item/weapon/storage/backpack/satchel_med" = 3,
	"/obj/item/weapon/storage/backpack/satchel_vir" = 3,
	"/obj/item/weapon/storage/backpack/satchel_chem" = 3,
	"/obj/item/weapon/storage/backpack/satchel_gen" = 3,
	"/obj/item/weapon/storage/backpack/satchel_tox" = 3,
	"/obj/item/weapon/storage/backpack/satchel_sec" = 3,
	"/obj/item/weapon/storage/backpack/satchel_hyd" = 3,
	"/obj/item/weapon/storage/backpack/satchel_cap" = 2,
	"/obj/item/weapon/storage/backpack/satchel_syndie" = 2,
	"/obj/item/weapon/storage/backpack/satchel_wizard" = 2,
	"/obj/item/weapon/storage/backpack/ert" = 2,
	"/obj/item/weapon/storage/backpack/ert/security" = 2,
	"/obj/item/weapon/storage/backpack/ert/engineer" = 2,
	"/obj/item/weapon/storage/backpack/ert/medical" = 2,
	"/obj/item/weapon/storage/backpack/duffel" = 3,
	"/obj/item/weapon/storage/backpack/duffel/cap" = 2,
	"/obj/item/weapon/storage/backpack/duffel/hyd" = 3,
	"/obj/item/weapon/storage/backpack/duffel/vir" = 3,
	"/obj/item/weapon/storage/backpack/duffel/med" = 3,
	"/obj/item/weapon/storage/backpack/duffel/eng" = 3,
	"/obj/item/weapon/storage/backpack/duffel/tox" = 3,
	"/obj/item/weapon/storage/backpack/duffel/sec" = 3,
	"/obj/item/weapon/storage/backpack/duffel/gen" = 3,
	"/obj/item/weapon/storage/backpack/duffel/chem" = 3,
	"/obj/item/weapon/storage/backpack/duffel/syndie" = 2,
	"/obj/item/weapon/storage/backpack/duffel/wizard" = 2
	)
	return pickweight(packs)


/obj/random/voidsuit
	var/damaged = 0

/obj/random/voidsuit/New(var/_damaged = 0)
	damaged = _damaged
	..()

/obj/random/voidsuit/spawn_item()
	var/list/suit_types = list(
	"/space/void" = 2,
	"/space/void/engineering" = 2,
	"/space/void/mining" = 2,
	"/space/void/medical" = 2.3,
	"/space/void/security" = 1,
	"/space/void/atmos" = 1.5,
	"/space/void/merc" = 0.5,
	"/space/void/captain" = 0.3
	)
	var/atom/L = src.loc
	var/suffix = pickweight(suit_types)

	var/stype = "/obj/item/clothing/suit[suffix]"
	var/htype = "/obj/item/clothing/head/helmet[suffix]"
	var/obj/item/clothing/suit/space/newsuit = new stype(L)
	new htype(L)
	new /obj/item/clothing/shoes/magboots(L)
	if (damaged && prob(60))//put some damage on it
		var/damtype = pick(BRUTE,BURN)
		var/amount = rand(1,5)
		newsuit.create_breaches(damtype, amount)

/obj/random/vendor
	var/depleted  = 0

/obj/random/vendor/New(var/_depleted = 0)
	depleted = _depleted
	..()

/obj/random/vendor/spawn_item()
	var/list/options = list(
	"/obj/machinery/vending/boozeomat" = 1,
	"/obj/machinery/vending/coffee" = 1,
	"/obj/machinery/vending/snack" = 1,
	"/obj/machinery/vending/cola" = 1,
	"/obj/machinery/vending/cart" = 1.5,
	"/obj/machinery/vending/cigarette" = 1,
	"/obj/machinery/vending/medical" = 1.2,
	"/obj/machinery/vending/phoronresearch" = 0.7,
	"/obj/machinery/vending/security" = 0.3,
	"/obj/machinery/vending/hydronutrients" = 1,
	"/obj/machinery/vending/hydroseeds" = 1,
	"/obj/machinery/vending/magivend" = 0.5,//The things it dispenses are just costumes to non-wizards
	"/obj/machinery/vending/dinnerware" = 1,
	"/obj/machinery/vending/sovietsoda" = 2,
	"/obj/machinery/vending/tool" = 1,
	"/obj/machinery/vending/engivend" = 0.6,
	"/obj/machinery/vending/engineering" = 1,
	"/obj/machinery/vending/robotics" = 1
	)
	var/turf/L = get_turf(src)
	var/type = pickweight(options)
	var/obj/machinery/vending/V = new type(L)

	if (!depleted)
		return

	//Greatly reduce the contents. it will have 0-20% of what it usually has
	for (var/content in V.products)
		if (prob(40))
			V.products[content] = 0//40% chance to completely lose an item
		else
			var/multiplier = rand(0,20)//Else, we reduce it to a very low percentage
			if (multiplier)
				multiplier /= 100

			V.products[content] *= multiplier
			if (V.products[content] < 1 && V.products[content] > 0)//But we'll usually have at least 1 left
				V.products[content] = 0


/obj/random/pda_cart/item_to_spawn()
	var/list/options = typesof(/obj/item/weapon/cartridge)
	var/type = pick(options)

	//reroll syndicate cartridge once to make it less common
	if (type == /obj/item/weapon/cartridge/syndicate)
		type = pick(options)

	return type

/obj/random/glowstick
	name = "random glowstick"
	desc = "This is a random glowstick."
	icon = 'icons/obj/glowsticks.dmi'
	icon_state = "glowstick"

/obj/random/glowstick/item_to_spawn()
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

/obj/random/booze/item_to_spawn()
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

/obj/random/melee/item_to_spawn()
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
	name = "random coin"
	desc = "This is a random coin."
	icon = 'icons/obj/items.dmi'
	icon_state = "coin"

/obj/random/coin/item_to_spawn()
	var/list/coin = list("/obj/item/weapon/coin/iron" = 5,
	"/obj/item/weapon/coin/silver" = 3,
	"/obj/item/weapon/coin/gold" = 1,
	"/obj/item/weapon/coin/silver" = 0.7,
	"/obj/item/weapon/coin/phoron" = 0.5,
	"obj/item/weapon/coin/uranium" = 0.5,
	"/obj/item/weapon/coin/platinum" = 0.2,
	"/obj/item/weapon/coin/diamond" = 0.1,
	)
	return pickweight(coin)

/obj/random/energy_antag
	name = "random energy weapon"
	desc = "This is a random energy weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "retro100"

/obj/random/energy_antag/item_to_spawn()

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

/obj/random/colored_jumpsuit
	name = "random colored jumpsuit"
	desc = "This is a random colowerd jumpsuit."
	icon = 'icons/obj/clothing/uniforms.dmi'
	icon_state = "black"

/obj/random/colored_jumpsuit/item_to_spawn()

	return pick(/obj/item/clothing/under/color/black,\
				/obj/item/clothing/under/color/blackf,\
				/obj/item/clothing/under/color/blue,\
				/obj/item/clothing/under/color/green,\
				/obj/item/clothing/under/color/grey,\
				/obj/item/clothing/under/color/orange,\
				/obj/item/clothing/under/color/pink,\
				/obj/item/clothing/under/color/red,\
				/obj/item/clothing/under/color/white,\
				/obj/item/clothing/under/color/yellow,\
				/obj/item/clothing/under/lightblue,\
				/obj/item/clothing/under/aqua,\
				/obj/item/clothing/under/purple,\
				/obj/item/clothing/under/lightpurple,\
				/obj/item/clothing/under/lightgreen,\
				/obj/item/clothing/under/lightbrown,\
				/obj/item/clothing/under/brown,\
				/obj/item/clothing/under/yellowgreen,\
				/obj/item/clothing/under/darkblue,\
				/obj/item/clothing/under/lightred,\
				/obj/item/clothing/under/darkred)

/obj/random/loot
	name = "random maintenance loot items"
	desc = "Stuff for the maint-dwellers."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift3"

/obj/random/loot/item_to_spawn()

	var/list/maint = list("/obj/item/clothing/glasses/meson" = 1,
	"/obj/item/clothing/glasses/meson/prescription" = 0.7,
	"/obj/item/clothing/glasses/material" = 0.8,
	"/obj/item/clothing/glasses/sunglasses" = 1.5,
	"/obj/item/clothing/glasses/welding" = 1.2,
	"/obj/item/clothing/under/captain_fly" = 0.7,
	"/obj/item/clothing/under/rank/mailman" = 0.6,
	"/obj/item/clothing/under/rank/vice" = 0.8,
	"/obj/item/clothing/under/assistantformal" = 1,
	"/obj/item/clothing/under/rainbow" = 0.9,
	"/obj/item/clothing/under/overalls" = 1,
	"/obj/item/clothing/under/redcoat" = 0.5,
	"/obj/item/clothing/under/serviceoveralls" = 1,
	"/obj/item/clothing/under/psyche" = 0.5,
	"/obj/item/clothing/under/track" = 0.9,
	"/obj/item/clothing/under/rank/dispatch" = 1,
	"/obj/item/clothing/under/syndicate/tacticool" = 1,
	"/obj/item/clothing/under/syndicate/tracksuit" = 0.2,
	"/obj/item/clothing/accessory/badge" = 0.2,
	"/obj/item/clothing/accessory/badge/old" = 0.2,
	"/obj/item/clothing/accessory/storage/webbing" = 0.6,
	"/obj/item/clothing/accessory/storage/knifeharness" = 0.3,
	"/obj/item/clothing/head/collectable/petehat" = 0.3,
	"/obj/item/clothing/head/hardhat" = 1.2,
	"/obj/item/clothing/head/redcoat" = 0.4,
	"/obj/item/clothing/head/syndicatefake" = 0.5,
	"/obj/item/clothing/head/richard" = 0.3,
	"/obj/item/clothing/head/soft/rainbow" = 0.7,
	"/obj/item/clothing/head/plaguedoctorhat" = 0.5,
	"/obj/item/clothing/head/cueball" = 0.5,
	"/obj/item/clothing/head/pirate" = 0.4,
	"/obj/item/clothing/head/bearpelt" = 0.4,
	"/obj/item/clothing/head/witchwig" = 0.5,
	"/obj/item/clothing/head/pumpkinhead" = 0.6,
	"/obj/item/clothing/head/kitty" = 0.2,
	"/obj/item/clothing/head/ushanka" = 0.6,
	"/obj/item/clothing/head/helmet/augment" = 0.1,
	"/obj/item/clothing/mask/balaclava" = 1,
	"/obj/item/clothing/mask/gas" = 1.5,
	"/obj/item/clothing/mask/gas/cyborg" = 0.7,
	"/obj/item/clothing/mask/gas/owl_mask" = 0.8,
	"/obj/item/clothing/mask/gas/syndicate" = 0.4,
	"/obj/item/clothing/mask/fakemoustache" = 0.4,
	"/obj/item/clothing/mask/horsehead" = 0.9,
	"/obj/item/clothing/shoes/rainbow" = 1,
	"/obj/item/clothing/shoes/jackboots" = 1,
	"/obj/item/clothing/shoes/workboots" = 1,
	"/obj/item/clothing/shoes/cyborg" = 0.4,
	"/obj/item/clothing/shoes/galoshes" = 0.6,
	"/obj/item/clothing/shoes/slippers_worn" = 0.5,
	"/obj/item/clothing/shoes/combat" = 0.2,
	"/obj/item/clothing/shoes/clown_shoes" = 0.1,
	"/obj/item/clothing/suit/storage/hazardvest" = 1,
	"/obj/item/clothing/suit/storage/leather_jacket/nanotrasen" = 0.7,
	"/obj/item/clothing/suit/storage/toggle/tracksuit" = 0.7,
	"/obj/item/clothing/suit/ianshirt" = 0.5,
	"/obj/item/clothing/suit/syndicatefake" = 0.6,
	"/obj/item/clothing/suit/imperium_monk" = 0.4,
	"/obj/item/clothing/suit/storage/vest" = 0.2,
	"/obj/item/clothing/gloves/black" = 1,
	"/obj/item/clothing/gloves/fyellow" = 1.2,
	"/obj/item/clothing/gloves/yellow" = 0.9,
	"/obj/item/clothing/gloves/watch" = 0.3,
	"/obj/item/clothing/gloves/boxing" = 0.3,
	"/obj/item/clothing/gloves/boxing/green" = 0.8,
	"/obj/item/clothing/gloves/botanic_leather" = 0.7,
	"/obj/item/clothing/gloves/combat" = 0.2,
	"/obj/item/toy/bosunwhistle" = 0.5,
	"/obj/item/toy/balloon" = 0.4,
	"/obj/item/weapon/haircomb" = 0.5,
	"/obj/item/weapon/lipstick" = 0.6,
	"/obj/item/weapon/material/knife/hook" = 0.3,
	"/obj/item/weapon/material/hatchet/tacknife" = 0.4,
	"/obj/item/weapon/storage/fancy/cigarettes/dromedaryco" = 1.2,
	"/obj/item/weapon/storage/bag/plasticbag" = 1,
	"/obj/item/weapon/extinguisher" = 1.3,
	"/obj/item/weapon/extinguisher/mini" = 0.9,
	"/obj/item/device/flashlight" = 1,
	"/obj/item/device/flashlight/heavy" = 0.5,
	"/obj/item/device/flashlight/maglight" = 0.4,
	"/obj/item/device/flashlight/flare" = 0.5,
	"/obj/item/device/flashlight/lantern" = 0.4,
	"/obj/item/weapon/reagent_containers/food/drinks/teapot" = 0.4,
	"/obj/item/weapon/reagent_containers/food/drinks/flask/shiny" = 0.3,
	"/obj/item/weapon/reagent_containers/food/drinks/flask/lithium" = 0.3,
	"/obj/item/bodybag" = 0.7,
	"/obj/item/weapon/reagent_containers/spray/cleaner" = 0.6,
	"/obj/item/weapon/tank/emergency_oxygen" = 0.7,
	"/obj/item/weapon/tank/emergency_oxygen/double" = 0.4,
	"/obj/item/clothing/mask/smokable/pipe/cobpipe" = 0.5,
	"/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba" = 0.7,
	"/obj/item/weapon/flame/lighter" = 0.9,
	"/obj/item/weapon/flame/lighter/zippo" = 0.7,
	"/obj/item/device/gps/engineering" = 0.6,
	"/obj/item/device/megaphone" = 0.5,
	"/obj/item/device/floor_painter" = 0.6,
	"/obj/random/toolbox" = 1,
	"/obj/random/coin" = 1.2,
	"/obj/random/tech_supply" = 1.2,
	"/obj/random/powercell" = 0.8,
	"/obj/random/colored_jumpsuit" = 0.7,
	"/obj/random/booze" = 1.1,
	"/obj/random/belt" = 0.9,
	"/obj/random/contraband" = 0.9,
	"/obj/random/glowstick" = 0.7,
	"/obj/item/weapon/caution/cone" = 0.7,
	"/obj/item/weapon/staff/broom" = 0.5,
	"/obj/item/weapon/soap" = 0.4,
	"/obj/item/weapon/material/wirerod" = 0.4,
	"/obj/item/weapon/storage/box/donkpockets" = 0.6,
	"/obj/item/weapon/contraband/poster" = 1.3,
	"/obj/item/device/magnetic_lock/security" = 0.3,
	"/obj/item/device/magnetic_lock/engineering" = 0.3
	)
	return pickweight(maint)
