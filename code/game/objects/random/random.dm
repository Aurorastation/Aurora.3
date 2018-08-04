/obj/random
	name = "random object"
	desc = "This item type is used to spawn random objects at round-start"
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything
	var/list/spawnlist
	var/list/problist
	var/has_postspawn

// creates a new object and deletes itself

/obj/random/Initialize()
	. = ..()
	if (!prob(spawn_nothing_percentage))
		var/item = spawn_item()
		if (has_postspawn && item)
			post_spawn(item)

	return INITIALIZE_HINT_QDEL

// this function should return a specific item to spawn
/obj/random/proc/item_to_spawn()
	return 0

/obj/random/proc/post_spawn(obj/thing)
	log_debug("random_obj: [DEBUG_REF(src)] registered itself as having post_spawn, but did not override post_spawn()!")

// creates the random item
/obj/random/proc/spawn_item()
	if (spawnlist)
		var/itemtype = pick(spawnlist)
		. = new itemtype(loc)

	else if (problist)
		var/itemtype = pickweight(problist)
		. = new itemtype(loc)

	else
		var/itemtype = item_to_spawn()
		. = new itemtype(loc)

	if (!.)
		log_debug("random_obj: [DEBUG_REF(src)] returned null item!")

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
	spawnlist = list(
		/obj/item/weapon/screwdriver,
		/obj/item/weapon/wirecutters,
		/obj/item/weapon/weldingtool,
		/obj/item/weapon/crowbar,
		/obj/item/weapon/wrench,
		/obj/item/device/flashlight
	)

/obj/random/technology_scanner
	name = "random scanner"
	desc = "This is a random technology scanner."
	icon = 'icons/obj/device.dmi'
	icon_state = "atmos"
	problist = list(
		/obj/item/device/t_scanner = 5,
		/obj/item/device/radio = 2,
		/obj/item/device/analyzer = 5
	)

/obj/random/powercell
	name = "random powercell"
	desc = "This is a random powercell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	problist = list(
		/obj/item/weapon/cell/crap = 10,
		/obj/item/weapon/cell = 40,
		/obj/item/weapon/cell/high = 40,
		/obj/item/weapon/cell/super = 9,
		/obj/item/weapon/cell/hyper = 1
	)

/obj/random/bomb_supply
	name = "bomb supply"
	desc = "This is a random bomb supply."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "signaller"
	spawnlist = list(
		/obj/item/device/assembly/igniter,
		/obj/item/device/assembly/prox_sensor,
		/obj/item/device/assembly/signaler,
		/obj/item/device/multitool
	)

/obj/random/toolbox
	name = "random toolbox"
	desc = "This is a random toolbox."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"
	spawnlist = list(
		/obj/item/weapon/storage/toolbox/mechanical = 3,
		/obj/item/weapon/storage/toolbox/electrical = 2,
		/obj/item/weapon/storage/toolbox/emergency = 1
	)

/obj/random/tech_supply
	name = "random tech supply"
	desc = "This is a random piece of technology supplies."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
//	spawn_nothing_percentage = 50
	problist = list(
		/obj/random/powercell = 3,
		/obj/random/technology_scanner = 2,
		/obj/item/weapon/packageWrap = 1,
		/obj/random/bomb_supply = 2,
		/obj/item/weapon/extinguisher = 1,
		/obj/item/clothing/gloves/fyellow = 1,
		/obj/item/stack/cable_coil = 3,
		/obj/random/toolbox = 2,
		/obj/item/weapon/storage/belt/utility = 2,
		/obj/random/tool = 5,
		/obj/item/weapon/tape_roll = 2
	)

/obj/random/medical
	name = "Random Medicine"
	desc = "This is a random medical item."
	icon = 'icons/obj/items.dmi'
	icon_state = "brutepack"
	spawn_nothing_percentage = 25
	problist = list(
		/obj/item/stack/medical/bruise_pack = 4,
		/obj/item/stack/medical/ointment = 4,
		/obj/item/stack/medical/advanced/bruise_pack = 2,
		/obj/item/stack/medical/advanced/ointment = 2,
		/obj/item/stack/medical/splint = 1,
		/obj/item/bodybag = 2,
		/obj/item/bodybag/cryobag = 1,
		/obj/item/weapon/storage/pill_bottle/kelotane = 2,
		/obj/item/weapon/storage/pill_bottle/antitox = 2,
		/obj/item/weapon/storage/pill_bottle/tramadol = 2,
		/obj/item/weapon/reagent_containers/syringe/antitoxin = 2,
		/obj/item/weapon/reagent_containers/syringe/antiviral = 1,
		/obj/item/weapon/reagent_containers/syringe/inaprovaline = 2,
		/obj/item/stack/nanopaste = 1
	)

/obj/random/firstaid
	name = "Random First Aid Kit"
	desc = "This is a random first aid kit."
	icon = 'icons/obj/storage.dmi'
	icon_state = "firstaid"
	problist = list(
		/obj/item/weapon/storage/firstaid/regular = 3,
		/obj/item/weapon/storage/firstaid/toxin = 2,
		/obj/item/weapon/storage/firstaid/o2 = 2,
		/obj/item/weapon/storage/firstaid/adv = 1,
		/obj/item/weapon/storage/firstaid/fire = 2
	)

/obj/random/contraband
	name = "Random Illegal Item"
	desc = "Hot Stuff."
	icon = 'icons/obj/items.dmi'
	icon_state = "purplecomb"
//	spawn_nothing_percentage = 50
	problist = list(
		/obj/item/weapon/storage/pill_bottle/tramadol = 3,
		/obj/item/weapon/storage/pill_bottle/happy = 2,
		/obj/item/weapon/storage/pill_bottle/zoom = 2,
		/obj/item/weapon/reagent_containers/glass/beaker/vial/random/toxin = 1,
		/obj/item/weapon/contraband/poster = 5,
		/obj/item/weapon/material/butterfly = 2,
		/obj/item/weapon/material/butterflyblade = 3,
		/obj/item/weapon/material/butterflyhandle = 3,
		/obj/item/weapon/material/wirerod = 3,
		/obj/item/weapon/melee/baton/cattleprod = 1,
		/obj/item/weapon/material/hatchet/tacknife = 1,
		/obj/item/weapon/material/kitchen/utensil/knife/boot = 2,
		/obj/item/weapon/storage/secure/briefcase/money = 1,
		/obj/item/weapon/material/butterfly/switchblade = 1,
		/obj/item/weapon/reagent_containers/syringe/drugs = 1,
		/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/libertycap = 2,
		/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiavulgaris = 2,
		/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiadeus = 1,
		/obj/item/seeds/ambrosiavulgarisseed = 2,
		/obj/item/seeds/ambrosiadeusseed = 1,
		/obj/item/clothing/mask/gas/voice = 1,
		/obj/item/clothing/gloves/brassknuckles = 2,
		/obj/item/weapon/reagent_containers/inhaler/space_drugs = 2
	)

/obj/random/energy
	name = "Random Energy Weapon"
	desc = "This is a random security weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "energykill100"
	problist = list(
		/obj/item/weapon/gun/energy/rifle/laser = 2,
		/obj/item/weapon/gun/energy/gun = 2,
		/obj/item/weapon/gun/energy/stunrevolver = 1
	)

/obj/random/projectile
	name = "Random Projectile Weapon"
	desc = "This is a random security weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "revolver"
	problist = list(
		/obj/item/weapon/gun/projectile/shotgun/pump = 3,
		/obj/item/weapon/gun/projectile/automatic/wt550 = 2,
		/obj/item/weapon/gun/projectile/shotgun/pump/combat = 1
	)

/obj/random/handgun
	name = "Random Handgun"
	desc = "This is a random security sidearm."
	icon = 'icons/obj/gun.dmi'
	icon_state = "secgundark"
	problist = list(
		/obj/item/weapon/gun/projectile/sec = 3,
		/obj/item/weapon/gun/projectile/sec/wood = 1
	)

/obj/random/ammo
	name = "Random Ammunition"
	desc = "This is random ammunition."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "45-10"
	problist = list(
		/obj/item/weapon/storage/box/beanbags = 6,
		/obj/item/weapon/storage/box/shotgunammo = 2,
		/obj/item/weapon/storage/box/shotgunshells = 4,
		/obj/item/weapon/storage/box/stunshells = 1,
		/obj/item/ammo_magazine/c45m = 2,
		/obj/item/ammo_magazine/c45m/rubber = 4,
		/obj/item/ammo_magazine/c45m/flash = 4,
		/obj/item/ammo_magazine/mc9mmt = 2,
		/obj/item/ammo_magazine/mc9mmt/rubber = 6
	)

/obj/random/action_figure
	name = "random action figure"
	desc = "This is a random action figure."
	icon = 'icons/obj/toy.dmi'
	icon_state = "assistant"
	spawnlist = list(
		/obj/item/toy/figure/cmo,
		/obj/item/toy/figure/assistant,
		/obj/item/toy/figure/atmos,
		/obj/item/toy/figure/bartender,
		/obj/item/toy/figure/borg,
		/obj/item/toy/figure/gardener,
		/obj/item/toy/figure/captain,
		/obj/item/toy/figure/cargotech,
		/obj/item/toy/figure/ce,
		/obj/item/toy/figure/chaplain,
		/obj/item/toy/figure/chef,
		/obj/item/toy/figure/chemist,
		/obj/item/toy/figure/clown,
		/obj/item/toy/figure/corgi,
		/obj/item/toy/figure/detective,
		/obj/item/toy/figure/dsquad,
		/obj/item/toy/figure/engineer,
		/obj/item/toy/figure/geneticist,
		/obj/item/toy/figure/hop,
		/obj/item/toy/figure/hos,
		/obj/item/toy/figure/qm,
		/obj/item/toy/figure/janitor,
		/obj/item/toy/figure/agent,
		/obj/item/toy/figure/librarian,
		/obj/item/toy/figure/md,
		/obj/item/toy/figure/mime,
		/obj/item/toy/figure/miner,
		/obj/item/toy/figure/ninja,
		/obj/item/toy/figure/wizard,
		/obj/item/toy/figure/rd,
		/obj/item/toy/figure/roboticist,
		/obj/item/toy/figure/scientist,
		/obj/item/toy/figure/syndie,
		/obj/item/toy/figure/secofficer,
		/obj/item/toy/figure/warden,
		/obj/item/toy/figure/psychologist,
		/obj/item/toy/figure/paramedic,
		/obj/item/toy/figure/ert
	)

/obj/random/plushie
	name = "random plushie"
	desc = "This is a random plushie."
	icon = 'icons/obj/toy.dmi'
	icon_state = "nymphplushie"
	spawnlist = list(
		/obj/structure/plushie/ian,
		/obj/structure/plushie/drone,
		/obj/structure/plushie/carp,
		/obj/structure/plushie/beepsky,
		/obj/structure/plushie/ivancarp,
		/obj/item/toy/plushie/nymph,
		/obj/item/toy/plushie/mouse,
		/obj/item/toy/plushie/kitten,
		/obj/item/toy/plushie/lizard
	)

/obj/random/smalltank
	name = "random small tank"

/obj/random/smalltank/item_to_spawn()
	if (prob(40))
		return /obj/item/weapon/tank/emergency_oxygen
	else if (prob(60))
		return /obj/item/weapon/tank/emergency_oxygen/engi
	else
		return /obj/item/weapon/tank/emergency_oxygen/double

/obj/random/belt
	name = "random belt"
	problist = list(
		/obj/item/weapon/storage/belt/utility = 1,
		/obj/item/weapon/storage/belt/medical = 0.4,
		/obj/item/weapon/storage/belt/medical/emt = 0.4,
		/obj/item/weapon/storage/belt/security/tactical = 0.1,
		/obj/item/weapon/storage/belt/military = 0.1,
		/obj/item/weapon/storage/belt/janitor = 0.4
	)

// Spawns a random backpack.
// Novelty and rare backpacks have lower weights.
/obj/random/backpack
	name = "random backpack"
	problist = list(
		/obj/item/weapon/storage/backpack = 3,
		/obj/item/weapon/storage/backpack/holding = 0.5,
		/obj/item/weapon/storage/backpack/cultpack = 2,
		/obj/item/weapon/storage/backpack/clown = 2,
		/obj/item/weapon/storage/backpack/medic = 3,
		/obj/item/weapon/storage/backpack/security = 3,
		/obj/item/weapon/storage/backpack/captain = 2,
		/obj/item/weapon/storage/backpack/industrial = 3,
		/obj/item/weapon/storage/backpack/toxins = 3,
		/obj/item/weapon/storage/backpack/hydroponics = 3,
		/obj/item/weapon/storage/backpack/genetics = 3,
		/obj/item/weapon/storage/backpack/virology = 3,
		/obj/item/weapon/storage/backpack/chemistry = 3,
		/obj/item/weapon/storage/backpack/cloak = 2,
		/obj/item/weapon/storage/backpack/syndie = 1,
		/obj/item/weapon/storage/backpack/wizard = 1,
		/obj/item/weapon/storage/backpack/satchel = 3,
		/obj/item/weapon/storage/backpack/satchel_norm = 3,
		/obj/item/weapon/storage/backpack/satchel_eng = 3,
		/obj/item/weapon/storage/backpack/satchel_med = 3,
		/obj/item/weapon/storage/backpack/satchel_vir = 3,
		/obj/item/weapon/storage/backpack/satchel_chem = 3,
		/obj/item/weapon/storage/backpack/satchel_gen = 3,
		/obj/item/weapon/storage/backpack/satchel_tox = 3,
		/obj/item/weapon/storage/backpack/satchel_sec = 3,
		/obj/item/weapon/storage/backpack/satchel_hyd = 3,
		/obj/item/weapon/storage/backpack/satchel_cap = 1,
		/obj/item/weapon/storage/backpack/satchel_syndie = 1,
		/obj/item/weapon/storage/backpack/satchel_wizard = 1,
		/obj/item/weapon/storage/backpack/ert = 1,
		/obj/item/weapon/storage/backpack/ert/security = 1,
		/obj/item/weapon/storage/backpack/ert/engineer = 1,
		/obj/item/weapon/storage/backpack/ert/medical = 1,
		/obj/item/weapon/storage/backpack/duffel = 3,
		/obj/item/weapon/storage/backpack/duffel/cap = 1,
		/obj/item/weapon/storage/backpack/duffel/hyd = 3,
		/obj/item/weapon/storage/backpack/duffel/vir = 3,
		/obj/item/weapon/storage/backpack/duffel/med = 3,
		/obj/item/weapon/storage/backpack/duffel/eng = 3,
		/obj/item/weapon/storage/backpack/duffel/tox = 3,
		/obj/item/weapon/storage/backpack/duffel/sec = 3,
		/obj/item/weapon/storage/backpack/duffel/gen = 3,
		/obj/item/weapon/storage/backpack/duffel/chem = 3,
		/obj/item/weapon/storage/backpack/duffel/syndie = 1,
		/obj/item/weapon/storage/backpack/duffel/wizard = 1,
		/obj/item/weapon/storage/backpack/messenger = 2,
		/obj/item/weapon/storage/backpack/messenger/chem = 2,
		/obj/item/weapon/storage/backpack/messenger/med = 2,
		/obj/item/weapon/storage/backpack/messenger/viro = 2,
		/obj/item/weapon/storage/backpack/messenger/tox = 2,
		/obj/item/weapon/storage/backpack/messenger/gen = 2,
		/obj/item/weapon/storage/backpack/messenger/com = 1,
		/obj/item/weapon/storage/backpack/messenger/engi = 2,
		/obj/item/weapon/storage/backpack/messenger/hyd = 2,
		/obj/item/weapon/storage/backpack/messenger/sec = 2,
		/obj/item/weapon/storage/backpack/messenger/syndie = 1,
		/obj/item/weapon/storage/backpack/messenger/wizard = 1
	)

/obj/random/voidsuit
	name = "random voidsuit"
	var/damaged = 0
	var/list/suitmap = list(
		/obj/item/clothing/suit/space/void = /obj/item/clothing/head/helmet/space/void,
		/obj/item/clothing/suit/space/void/engineering = /obj/item/clothing/head/helmet/space/void/engineering,
		/obj/item/clothing/suit/space/void/mining = /obj/item/clothing/head/helmet/space/void/mining,
		/obj/item/clothing/suit/space/void/medical = /obj/item/clothing/head/helmet/space/void/medical,
		/obj/item/clothing/suit/space/void/security = /obj/item/clothing/head/helmet/space/void/security,
		/obj/item/clothing/suit/space/void/atmos = /obj/item/clothing/head/helmet/space/void/atmos,
		/obj/item/clothing/suit/space/void/merc = /obj/item/clothing/head/helmet/space/void/merc,
		/obj/item/clothing/suit/space/void/captain = /obj/item/clothing/head/helmet/space/void/captain
	)
	problist = list(
		/obj/item/clothing/suit/space/void = 2,
		/obj/item/clothing/suit/space/void/engineering = 2,
		/obj/item/clothing/suit/space/void/mining = 2,
		/obj/item/clothing/suit/space/void/medical = 2.3,
		/obj/item/clothing/suit/space/void/security = 1,
		/obj/item/clothing/suit/space/void/atmos = 1.5,
		/obj/item/clothing/suit/space/void/merc = 0.5,
		/obj/item/clothing/suit/space/void/captain = 0.3
	)
	has_postspawn = TRUE

/obj/random/voidsuit/Initialize(mapload, _damaged = 0)
	damaged = _damaged
	. = ..(mapload)

/obj/random/voidsuit/post_spawn(obj/item/clothing/suit/space/void/suit)
	var/helmet = suitmap[suit.type]
	if (helmet)
		new helmet(loc)
	else
		log_debug("random_obj (voidsuit): Type [suit.type] was unable to spawn a matching helmet!")
	new /obj/item/clothing/shoes/magboots(loc)
	if (damaged && prob(60))
		suit.create_breaches(pick(BRUTE, BURN), rand(1, 5))

/obj/random/vendor
	name = "random vendor"
	var/depleted = 0
	problist = list(
		/obj/machinery/vending/boozeomat = 1,
		/obj/machinery/vending/coffee = 1,
		/obj/machinery/vending/snack = 1,
		/obj/machinery/vending/cola = 1,
		/obj/machinery/vending/cart = 1.5,
		/obj/machinery/vending/cigarette = 1,
		/obj/machinery/vending/medical = 1.2,
		/obj/machinery/vending/phoronresearch = 0.7,
		/obj/machinery/vending/security = 0.3,
		/obj/machinery/vending/hydronutrients = 1,
		/obj/machinery/vending/hydroseeds = 1,
		/obj/machinery/vending/magivend = 0.5,	//The things it dispenses are just costumes to non-wizards
		/obj/machinery/vending/dinnerware = 1,
		/obj/machinery/vending/sovietsoda = 2,
		/obj/machinery/vending/tool = 1,
		/obj/machinery/vending/engivend = 0.6,
		/obj/machinery/vending/engineering = 1,
		/obj/machinery/vending/robotics = 1,
		/obj/machinery/vending/tacticool = 0.2,
		/obj/machinery/vending/tacticool/ert = 0.1
	)
	has_postspawn = TRUE

/obj/random/vendor/Initialize(mapload, _depleted = 0)
	depleted = _depleted
	. = ..()

/obj/random/vendor/post_spawn(obj/machinery/vending/V)
	if (!depleted)
		return

	//Greatly reduce the contents. it will have 0-20% of what it usually has
	for (var/content in V.products)
		if (prob(40))
			V.products[content] = 0	//40% chance to completely lose an item
		else
			var/multiplier = rand(0,20)	//Else, we reduce it to a very low percentage
			if (multiplier)
				multiplier /= 100

			V.products[content] *= multiplier
			if (V.products[content] < 1 && V.products[content] > 0)	//But we'll usually have at least 1 left
				V.products[content] = 0

			// Clamp to an integer so we don't get 0.78 of a screwdriver.
			V.products[content] = round(V.products[content])

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
	spawnlist = list(
		/obj/item/device/flashlight/glowstick,
		/obj/item/device/flashlight/glowstick/red,
		/obj/item/device/flashlight/glowstick/blue,
		/obj/item/device/flashlight/glowstick/orange,
		/obj/item/device/flashlight/glowstick/yellow
	)

/obj/random/booze
	name = "random alcoholic drink"
	desc = "This is a random alcoholic drink."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "broken_bottle"
	spawnlist = list(
		/obj/item/weapon/reagent_containers/food/drinks/bottle/gin,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/rum,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/champagne,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/vermouth,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/kahlua,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/wine,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/melonliquor,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/pwine,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/brandy,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/guinnes,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/drambuie,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/cremeyvette,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/cremewhite,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/chartreuseyellow,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/chartreusegreen,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/grenadine,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/bluecuracao,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/bitters,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/champagne,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/mintsyrup,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/sarezhiwine,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/small/ale,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/small/xuizijuice
	)

/obj/random/melee
	name = "random melee weapon"
	desc = "This is a random melee weapon."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "baton"
	spawnlist = list(
		/obj/item/weapon/melee/telebaton,
		/obj/item/weapon/melee/energy/sword,
		/obj/item/weapon/melee/energy/sword/pirate,
		/obj/item/weapon/melee/energy/glaive,
		/obj/item/weapon/melee/chainsword,
		/obj/item/weapon/melee/baton/stunrod,
		/obj/item/weapon/material/harpoon,
		/obj/random/sword,
		/obj/item/weapon/melee/hammer,
		/obj/item/weapon/melee/hammer/powered,
		/obj/item/weapon/material/twohanded/fireaxe,
		/obj/item/weapon/melee/classic_baton,
		/obj/item/weapon/material/twohanded/pike,
		/obj/item/weapon/material/twohanded/pike/halberd,
		/obj/item/weapon/material/twohanded/pike/pitchfork,
		/obj/item/weapon/melee/whip,
		/obj/item/clothing/accessory/storage/bayonet
	)

/obj/random/coin
	name = "random coin"
	desc = "This is a random coin."
	icon = 'icons/obj/items.dmi'
	icon_state = "coin"
	problist = list(
		/obj/item/weapon/coin/iron = 5,
		/obj/item/weapon/coin/silver = 3,
		/obj/item/weapon/coin/gold = 0.7,
		/obj/item/weapon/coin/phoron = 0.5,
		/obj/item/weapon/coin/uranium = 0.5,
		/obj/item/weapon/coin/platinum = 0.2,
		/obj/item/weapon/coin/diamond = 0.1
	)

/obj/random/spacecash
	name = "random credit chips"
	desc = "This is a random credit ships."
	icon = 'icons/obj/items.dmi'
	icon_state = "spacecash1"
	problist = list(
		/obj/item/weapon/spacecash/c1 = 6,
		/obj/item/weapon/spacecash/c10 = 3,
		/obj/item/weapon/spacecash/c20 = 2,
		/obj/item/weapon/spacecash/c50 = 1,
		/obj/item/weapon/spacecash/c100 = 0.3,
		/obj/item/weapon/spacecash/c200 = 0.2,
		/obj/item/weapon/spacecash/c1000 = 0.1
	)

/obj/random/energy_antag
	name = "random energy weapon"
	desc = "This is a random energy weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "retro100"
	spawnlist = list(
		/obj/item/weapon/gun/energy/retro,
		/obj/item/weapon/gun/energy/xray,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/weapon/gun/energy/pistol,
		/obj/item/weapon/gun/energy/mindflayer,
		/obj/item/weapon/gun/energy/toxgun,
		/obj/item/weapon/gun/energy/vaurca/gatlinglaser,
		/obj/item/weapon/gun/energy/vaurca/blaster,
		/obj/item/weapon/gun/energy/crossbow/largecrossbow,
		/obj/item/weapon/gun/energy/rifle,
		/obj/item/weapon/gun/energy/rifle/laser,
		/obj/item/weapon/gun/energy/rifle/laser/heavy,
		/obj/item/weapon/gun/energy/rifle/laser/xray,
		/obj/item/weapon/gun/energy/net,
		/obj/item/weapon/gun/energy/laser/shotgun,
		/obj/item/weapon/gun/energy/decloner
	)

/obj/random/colored_jumpsuit
	name = "random colored jumpsuit"
	desc = "This is a random colowerd jumpsuit."
	icon = 'icons/obj/clothing/uniforms.dmi'
	icon_state = "black"
	spawnlist = list(
		/obj/item/clothing/under/color/black,
		/obj/item/clothing/under/color/blackf,
		/obj/item/clothing/under/color/blue,
		/obj/item/clothing/under/color/green,
		/obj/item/clothing/under/color/grey,
		/obj/item/clothing/under/color/orange,
		/obj/item/clothing/under/color/pink,
		/obj/item/clothing/under/color/red,
		/obj/item/clothing/under/color/white,
		/obj/item/clothing/under/color/yellow,
		/obj/item/clothing/under/lightblue,
		/obj/item/clothing/under/aqua,
		/obj/item/clothing/under/purple,
		/obj/item/clothing/under/lightpurple,
		/obj/item/clothing/under/lightgreen,
		/obj/item/clothing/under/lightbrown,
		/obj/item/clothing/under/brown,
		/obj/item/clothing/under/yellowgreen,
		/obj/item/clothing/under/darkblue,
		/obj/item/clothing/under/lightred,
		/obj/item/clothing/under/darkred
	)

/obj/random/loot
	name = "random maintenance loot items"
	desc = "Stuff for the maint-dwellers."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift3"
	problist = list(
		/obj/item/clothing/glasses/meson = 1,
		/obj/item/clothing/glasses/meson/prescription = 0.7,
		/obj/item/clothing/glasses/material = 0.8,
		/obj/item/clothing/glasses/sunglasses = 1.5,
		/obj/item/clothing/glasses/welding = 1.2,
		/obj/item/clothing/under/captain_fly = 0.5,
		/obj/item/clothing/under/rank/mailman = 0.6,
		/obj/item/clothing/under/rank/vice = 0.8,
		/obj/item/clothing/under/assistantformal = 1,
		/obj/item/clothing/under/rainbow = 0.9,
		/obj/item/clothing/under/overalls = 1,
		/obj/item/clothing/under/redcoat = 0.5,
		/obj/item/clothing/under/serviceoveralls = 1,
		/obj/item/clothing/under/rank/dispatch = 0.8,
		/obj/item/clothing/under/syndicate/tacticool = 1,
		/obj/item/clothing/under/syndicate/tracksuit = 0.2,
		/obj/item/clothing/under/rank/clown = 0.1,
		/obj/item/clothing/under/mime = 0.1,
		/obj/item/clothing/accessory/storage/webbing = 0.6,
		/obj/item/clothing/accessory/storage/knifeharness = 0.3,
		/obj/item/clothing/head/collectable/petehat = 0.1,
		/obj/item/clothing/head/hardhat = 1.2,
		/obj/item/clothing/head/redcoat = 0.4,
		/obj/item/clothing/head/syndicatefake = 0.5,
		/obj/item/clothing/head/richard = 0.3,
		/obj/item/clothing/head/soft/rainbow = 0.7,
		/obj/item/clothing/head/plaguedoctorhat = 0.5,
		/obj/item/clothing/head/cueball = 0.5,
		/obj/item/clothing/head/pirate = 0.4,
		/obj/item/clothing/head/bearpelt = 0.4,
		/obj/item/clothing/head/witchwig = 0.5,
		/obj/item/clothing/head/pumpkinhead = 0.6,
		/obj/item/clothing/head/kitty = 0.2,
		/obj/item/clothing/head/ushanka = 0.6,
		/obj/item/clothing/head/helmet/augment = 0.1,
		/obj/item/clothing/mask/balaclava = 1,
		/obj/item/clothing/mask/gas = 1.5,
		/obj/item/clothing/mask/gas/cyborg = 0.7,
		/obj/item/clothing/mask/gas/owl_mask = 0.5,
		/obj/item/clothing/mask/gas/syndicate = 0.4,
		/obj/item/clothing/mask/fakemoustache = 0.4,
		/obj/item/clothing/mask/horsehead = 0.5,
		/obj/item/clothing/mask/gas/clown_hat = 0.1,
		/obj/item/clothing/mask/gas/mime = 0.1,
		/obj/item/clothing/mask/pig = 0.3,
		/obj/item/clothing/mask/muzzle = 0.2,
		/obj/item/clothing/mask/luchador = 0.1,
		/obj/item/clothing/mask/luchador/tecnicos = 0.1,
		/obj/item/clothing/mask/luchador/rudos = 0.1,
		/obj/item/clothing/shoes/rainbow = 1,
		/obj/item/clothing/shoes/jackboots = 1,
		/obj/item/clothing/shoes/workboots = 1,
		/obj/item/clothing/shoes/cyborg = 0.4,
		/obj/item/clothing/shoes/galoshes = 0.6,
		/obj/item/clothing/shoes/slippers_worn = 0.5,
		/obj/item/clothing/shoes/combat = 0.2,
		/obj/item/clothing/shoes/clown_shoes = 0.1,
		/obj/item/clothing/shoes/winter = 0.3,
		/obj/item/clothing/suit/storage/hazardvest = 1,
		/obj/item/clothing/suit/storage/leather_jacket/nanotrasen = 0.7,
		/obj/item/clothing/suit/ianshirt = 0.5,
		/obj/item/clothing/suit/syndicatefake = 0.6,
		/obj/item/clothing/suit/imperium_monk = 0.4,
		/obj/item/clothing/suit/storage/vest = 0.2,
		/obj/item/clothing/gloves/black = 1,
		/obj/item/clothing/gloves/fyellow = 1.2,
		/obj/item/clothing/gloves/yellow = 0.9,
		/obj/item/clothing/gloves/watch = 0.3,
		/obj/item/clothing/gloves/boxing = 0.3,
		/obj/item/clothing/gloves/boxing/green = 0.3,
		/obj/item/clothing/gloves/botanic_leather = 0.7,
		/obj/item/clothing/gloves/combat = 0.2,
		/obj/item/clothing/gloves/latex = 0.5,
		/obj/item/clothing/gloves/latex/nitrile = 0.4,
		/obj/item/toy/bosunwhistle = 0.5,
		/obj/item/toy/balloon = 0.4,
		/obj/item/weapon/haircomb = 0.5,
		/obj/item/weapon/lipstick = 0.6,
		/obj/item/weapon/material/knife/hook = 0.3,
		/obj/item/weapon/material/hatchet/tacknife = 0.4,
		/obj/item/weapon/storage/fancy/cigarettes = 1.2,
		/obj/item/weapon/storage/fancy/cigarettes/dromedaryco = 0.8,
		/obj/item/weapon/storage/fancy/cigarettes/killthroat = 0.3,
		/obj/item/weapon/storage/fancy/cigarettes/custom = 1,
		/obj/item/weapon/storage/bag/plasticbag = 1,
		/obj/item/weapon/extinguisher = 1.3,
		/obj/item/weapon/extinguisher/mini = 0.9,
		/obj/item/device/flashlight = 1,
		/obj/item/device/flashlight/heavy = 0.5,
		/obj/item/device/flashlight/maglight = 0.4,
		/obj/item/device/flashlight/flare = 0.5,
		/obj/item/device/flashlight/lantern = 0.4,
		/obj/item/device/taperecorder = 0.6,
		/obj/item/weapon/reagent_containers/food/drinks/teapot = 0.4,
		/obj/item/weapon/reagent_containers/food/drinks/flask/shiny = 0.3,
		/obj/item/weapon/reagent_containers/food/drinks/flask/lithium = 0.3,
		/obj/item/bodybag = 0.7,
		/obj/item/weapon/reagent_containers/spray/cleaner = 0.6,
		/obj/item/weapon/reagent_containers/spray/sterilizine = 0.4,
		/obj/item/weapon/reagent_containers/spray/waterflower = 0.2,
		/obj/item/weapon/tank/emergency_oxygen = 0.7,
		/obj/item/weapon/tank/emergency_oxygen/double = 0.4,
		/obj/item/clothing/mask/smokable/pipe/cobpipe = 0.5,
		/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba = 0.7,
		/obj/item/weapon/flame/lighter = 0.9,
		/obj/item/weapon/flame/lighter/zippo = 0.7,
		/obj/item/device/gps/engineering = 0.6,
		/obj/item/device/megaphone = 0.5,
		/obj/item/device/floor_painter = 0.6,
		/obj/item/device/wormhole_jaunter = 0.1,
		/obj/random/toolbox = 1,
		/obj/random/coin = 1.2,
		/obj/random/tech_supply = 1.2,
		/obj/random/powercell = 0.8,
		/obj/random/colored_jumpsuit = 0.7,
		/obj/random/booze = 1.1,
		/obj/random/belt = 0.9,
		/obj/random/backpack = 0.7,
		/obj/random/contraband = 0.9,
		/obj/random/firstaid = 0.4,
		/obj/random/medical = 0.4,
		/obj/random/glowstick = 0.7,
		/obj/random/tool = 1,
		/obj/random/plushie = 0.7,
		/obj/item/weapon/caution/cone = 0.7,
		/obj/item/weapon/staff/broom = 0.5,
		/obj/item/weapon/soap = 0.4,
		/obj/item/weapon/storage/fancy/crayons = 0.5,
		/obj/item/weapon/storage/box/donkpockets = 0.6,
		/obj/item/weapon/storage/box/masks = 0.5,
		/obj/item/weapon/storage/box/syringes = 0.3,
		/obj/item/weapon/storage/box/smokebombs = 0.1,
		/obj/item/weapon/storage/box/drinkingglasses = 0.2,
		/obj/item/weapon/storage/box/condimentbottles = 0.2,
		/obj/item/weapon/storage/box/mousetraps = 0.3,
		/obj/item/weapon/storage/box/lights = 0.5,
		/obj/item/weapon/storage/box/lights/coloredmixed = 0.2,
		/obj/item/weapon/storage/box/lights/colored/red = 0.1,
		/obj/item/weapon/storage/box/lights/colored/green = 0.1,
		/obj/item/weapon/storage/box/lights/colored/blue = 0.1,
		/obj/item/weapon/storage/box/lights/colored/cyan = 0.1,
		/obj/item/weapon/storage/box/lights/colored/yellow = 0.1,
		/obj/item/weapon/storage/box/lights/colored/magenta = 0.1,
		/obj/item/weapon/contraband/poster = 1.3,
		/obj/item/device/magnetic_lock/security = 0.3,
		/obj/item/device/magnetic_lock/engineering = 0.3,
		/obj/item/weapon/shovel = 0.5,
		/obj/item/weapon/pickaxe = 0.4,
		/obj/item/weapon/inflatable_duck = 0.2,
		/obj/random/hoodie = 0.5,
		/obj/random/junk = 0.9,
		/obj/item/weapon/spacecash/ewallet/lotto = 0.3,
		/obj/random/spacecash = 0.3,
		/obj/item/device/firing_pin = 0.3,
		/obj/item/weapon/reagent_containers/inhaler/hyperzine = 0.1,
		/obj/item/weapon/storage/box/pineapple = 0.1
	)

/obj/random/hoodie
	name = "random winter coat"
	desc = "This is a random winter coat."
	icon = 'icons/obj/hoodies.dmi'
	icon_state = "coatwinter"
	problist = list(
		/obj/item/clothing/suit/storage/hooded/wintercoat = 5,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/science = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hydro = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/cargo = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/miner = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security = 2,
		/obj/item/clothing/suit/storage/hooded/wintercoat/captain = 1
	)

/obj/random/highvalue
	name = "random high valuable item"
	desc = "This is a random high valuable item."
	icon = 'icons/obj/items.dmi'
	icon_state = "coin_diamond"
	problist = list(
		/obj/item/bluespace_crystal = 5,
		/obj/item/stack/telecrystal{amount = 10} = 5,
		/obj/item/clothing/suit/armor/reactive = 0.5,
		/obj/item/clothing/glasses/thermal = 0.5,
		/obj/item/weapon/gun/projectile/automatic/rifle/shotgun = 0.5,
		/obj/random/sword = 0.5,
		/obj/item/weapon/gun/energy/lawgiver = 0.5,
		/obj/item/weapon/melee/energy/axe = 0.5,
		/obj/item/weapon/gun/projectile/automatic/terminator = 0.5,
		/obj/item/weapon/rig/military = 0.5,
		/obj/item/weapon/rig/unathi/fancy = 0.5,
		/obj/item/weapon/anomaly_core = 0.5
	)

/obj/random/junk
	name = "random trash"
	desc = "This is toss."
	icon = 'icons/obj/trash.dmi'
	icon_state = "koisbar"
	spawn_nothing_percentage = 5
	problist = list(
		/obj/item/trash/koisbar = 0.5,
		/obj/item/trash/raisins = 1,
		/obj/item/trash/candy = 1,
		/obj/item/trash/cheesie = 2,
		/obj/item/trash/chips = 0.75,
		/obj/item/trash/popcorn = 0.75,
		/obj/item/trash/sosjerky = 0.5,
		/obj/item/trash/syndi_cakes = 0.25,
		/obj/item/trash/waffles = 0.75,
		/obj/item/trash/plate  = 0.75,
		/obj/item/trash/snack_bowl = 0.75,
		/obj/item/trash/pistachios = 0.75,
		/obj/item/trash/semki = 0.5,
		/obj/item/trash/tray = 0.75,
		/obj/item/trash/candle = 0.75,
		/obj/item/trash/liquidfood = 0.75,
		/obj/item/trash/tastybread= 0.75,
		/obj/item/trash/meatsnack = 0.5,
		/obj/item/trash/maps = 0.5,
		/obj/effect/decal/cleanable/ash = 1.5,
		/obj/effect/decal/cleanable/dirt = 2,
		/obj/effect/decal/cleanable/flour = 1,
		/obj/effect/decal/cleanable/greenglow = 1,
		/obj/effect/decal/cleanable/molten_item = 1,
		/obj/effect/decal/cleanable/vomit = 2,
		/obj/effect/decal/cleanable/generic = 2,
		/obj/effect/decal/cleanable/liquid_fuel = 0.5,
		/obj/effect/decal/cleanable/mucus = 1.5,
		/obj/effect/decal/cleanable/blood/drip = 1.5,
		/obj/item/weapon/storage/box = 1,
		/obj/item/weapon/material/shard = 1,
		/obj/item/weapon/material/shard/shrapnel = 1,
		/obj/item/weapon/broken_bottle = 1,
		/obj/item/stack/material/cardboard = 1,
		/obj/item/stack/rods = 1,
		/obj/item/weapon/corncob = 1,
		/obj/item/weapon/paper/crumpled = 1,
		/obj/item/inflatable/torn = 1,
		/obj/item/ammo_casing/c45/rubber = 0.5,
		/obj/item/ammo_casing/c9mm/rubber = 0.5,
		/obj/item/ammo_casing/c45/flash = 0.5,
		/obj/item/ammo_casing/shotgun/beanbag = 0.5,
		/obj/item/weapon/flag/america = 1,
		/obj/item/weapon/flag/america/l = 1
	)

//Sometimes the chef will have spare oil in storage.
//Sometimes they wont, and will need to order it from cargo
//Variety is the spice of life!
/obj/random/cookingoil
	name = "random cooking oil"
	desc = "Has a 50% chance of spawning a tank of cooking oil, otherwise nothing"
	icon = 'icons/obj/objects.dmi'
	icon_state = "oiltank"
	spawn_nothing_percentage = 50

	spawnlist = list(
		/obj/structure/reagent_dispensers/cookingoil
	)

/obj/random/sword
	name = "random sword"
	desc = "This is a random sword."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "claymore"
	spawnlist = list(
		/obj/item/weapon/material/sword,
		/obj/item/weapon/material/sword/katana,
		/obj/item/weapon/material/sword/rapier,
		/obj/item/weapon/material/sword/longsword,
		/obj/item/weapon/material/sword/trench,
		/obj/item/weapon/material/sword/sabre,
		/obj/item/weapon/material/sword/axe,
		/obj/item/weapon/material/sword/khopesh,
		/obj/item/weapon/material/sword/dao,
		/obj/item/weapon/material/sword/gladius
	)

/obj/random/arcade
	name = "random arcade loot"
	desc = "Arcade loot!"
	icon = 'icons/obj/items.dmi'
	icon_state = "gift3"
	spawnlist = list(
		/obj/item/weapon/storage/box/snappops			= 11,
		/obj/item/clothing/under/syndicate/tacticool	= 5,
		/obj/item/toy/sword								= 22,
		/obj/item/weapon/gun/projectile/revolver/capgun	= 11,
		/obj/item/toy/crossbow							= 11,
		/obj/item/weapon/storage/fancy/crayons			= 11,
		/obj/item/toy/spinningtoy						= 11,
		/obj/item/toy/prize/ripley						= 1,
		/obj/item/toy/prize/fireripley					= 1,
		/obj/item/toy/prize/deathripley					= 1,
		/obj/item/toy/prize/gygax						= 1,
		/obj/item/toy/prize/durand						= 1,
		/obj/item/toy/prize/honk						= 1,
		/obj/item/toy/prize/marauder					= 1,
		/obj/item/toy/prize/seraph						= 1,
		/obj/item/toy/prize/mauler						= 1,
		/obj/item/toy/prize/odysseus					= 1,
		/obj/item/toy/prize/phazon						= 1,
		/obj/item/toy/waterflower						= 5,
		/obj/random/action_figure						= 11,
		/obj/random/plushie								= 44,
		/obj/item/toy/cultsword							= 5,
		/obj/item/toy/syndicateballoon					= 5,
		/obj/item/toy/nanotrasenballoon					= 5,
		/obj/item/toy/katana							= 11,
		/obj/item/toy/bosunwhistle						= 5,
		/obj/item/weapon/storage/belt/champion			= 11,
		/obj/item/weapon/pen/invisible					= 5,
		/obj/item/weapon/grenade/fake					= 1,
		/obj/item/weapon/bikehorn						= 11,
		/obj/item/clothing/mask/fakemoustache			= 11,
		/obj/item/clothing/mask/gas/clown_hat			= 11,
		/obj/item/clothing/mask/gas/mime				= 11,
		/obj/item/weapon/gun/energy/wand/toy			= 5,
		/obj/item/device/binoculars						= 11,
		/obj/item/device/megaphone						= 11
	)

/obj/random/custom_ka
	name = "random custom kinetic accelerator"
	desc = "Contains random assemblies. The parts may not always be compatible with eachother."
	icon = 'icons/obj/kinetic_accelerators.dmi'
	icon_state = "frame01"
	spawnlist = list(
		/obj/item/toy/prize/honk
	)
	has_postspawn = TRUE
	post_spawn(obj/thing)
		var/list/frames = list(
			/obj/item/weapon/gun/custom_ka/frame01 = 1,
			/obj/item/weapon/gun/custom_ka/frame02 = 2,
			/obj/item/weapon/gun/custom_ka/frame03 = 3,
			/obj/item/weapon/gun/custom_ka/frame04 = 2,
			/obj/item/weapon/gun/custom_ka/frame05 = 1
		)

		var/list/cells = list(
			/obj/item/custom_ka_upgrade/cells/cell01 = 2,
			/obj/item/custom_ka_upgrade/cells/cell02 = 3,
			/obj/item/custom_ka_upgrade/cells/cell03 = 2,
			/obj/item/custom_ka_upgrade/cells/cell04 = 1,
			/obj/item/custom_ka_upgrade/cells/cell05 = 1
		)

		var/list/barrels = list(
			/obj/item/custom_ka_upgrade/barrels/barrel01 = 2,
			/obj/item/custom_ka_upgrade/barrels/barrel02 = 3,
			/obj/item/custom_ka_upgrade/barrels/barrel03 = 2,
			/obj/item/custom_ka_upgrade/barrels/barrel04 = 1,
			/obj/item/custom_ka_upgrade/barrels/barrel05 = 1
		)

		var/frame_type = pickweight(frames)
		var/obj/item/weapon/gun/custom_ka/spawned_frame = new frame_type(thing.loc)

		var/cell_type = pickweight(cells)
		spawned_frame.installed_cell = new cell_type(spawned_frame)

		var/barrel_type = pickweight(barrels)
		spawned_frame.installed_barrel = new barrel_type(spawned_frame)

		spawned_frame.installed_upgrade_chip = new /obj/item/custom_ka_upgrade/upgrade_chips/capacity(spawned_frame)

		spawned_frame.update_icon()
		spawned_frame.update_stats()

		qdel(thing)

/obj/random/prebuilt_ka
	name = "random prebuilt kinetic accelerator"
	desc = "Contains working kinetic accelerators that were prebuilt in code."
	icon = 'icons/obj/kinetic_accelerators.dmi'
	icon_state = "frameA"
	spawnlist = list(
		/obj/item/weapon/gun/custom_ka/frame01/prebuilt = 2.5,
		/obj/item/weapon/gun/custom_ka/frame02/prebuilt = 5,
		/obj/item/weapon/gun/custom_ka/frame03/prebuilt = 10,
		/obj/item/weapon/gun/custom_ka/frame04/prebuilt = 5,
		/obj/item/weapon/gun/custom_ka/frame05/prebuilt = 2.5,
		/obj/item/weapon/gun/custom_ka/frameA/prebuilt = 1,
		/obj/item/weapon/gun/custom_ka/frameB/prebuilt = 1,
		/obj/item/weapon/gun/custom_ka/frameC/prebuilt = 1,
		/obj/item/weapon/gun/custom_ka/frameD/prebuilt = 1,
		/obj/item/weapon/gun/custom_ka/frameF/prebuilt01 = 1,
		/obj/item/weapon/gun/custom_ka/frameF/prebuilt02 = 1
	)
