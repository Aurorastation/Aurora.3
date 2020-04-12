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
		var/obj/spawned_item = spawn_item()
		if(spawned_item)
			spawned_item.pixel_x = pixel_x
			spawned_item.pixel_y = pixel_y
			if(has_postspawn)
				post_spawn(spawned_item)

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
	icon = 'icons/obj/tools.dmi'
	icon_state = "welder_off"
	spawnlist = list(
		/obj/item/screwdriver,
		/obj/item/wirecutters,
		/obj/item/weldingtool,
		/obj/item/crowbar,
		/obj/item/wrench,
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
		/obj/item/cell/crap = 10,
		/obj/item/cell = 40,
		/obj/item/cell/high = 40,
		/obj/item/cell/super = 9,
		/obj/item/cell/hyper = 1
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
		/obj/item/storage/toolbox/mechanical = 3,
		/obj/item/storage/toolbox/electrical = 2,
		/obj/item/storage/toolbox/emergency = 1
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
		/obj/item/stack/packageWrap = 1,
		/obj/random/bomb_supply = 2,
		/obj/item/extinguisher = 1,
		/obj/item/clothing/gloves/fyellow = 1,
		/obj/item/stack/cable_coil = 3,
		/obj/random/toolbox = 2,
		/obj/item/storage/belt/utility = 2,
		/obj/random/tool = 5,
		/obj/item/tape_roll = 2
	)

/obj/random/medical
	name = "Random Medicine"
	desc = "This is a random medical item."
	icon = 'icons/obj/stacks/medical.dmi'
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
		/obj/item/storage/pill_bottle/kelotane = 2,
		/obj/item/storage/pill_bottle/antitox = 2,
		/obj/item/storage/pill_bottle/tramadol = 2,
		/obj/item/reagent_containers/syringe/dylovene = 2,
		/obj/item/reagent_containers/syringe/antiviral = 1,
		/obj/item/reagent_containers/syringe/norepinephrine = 2,
		/obj/item/stack/nanopaste = 1
	)

/obj/random/firstaid
	name = "Random First Aid Kit"
	desc = "This is a random first aid kit."
	icon = 'icons/obj/storage.dmi'
	icon_state = "firstaid"
	problist = list(
		/obj/item/storage/firstaid/regular = 3,
		/obj/item/storage/firstaid/toxin = 2,
		/obj/item/storage/firstaid/o2 = 2,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/storage/firstaid/fire = 2
	)

/obj/random/contraband
	name = "Random Illegal Item"
	desc = "Hot Stuff."
	icon = 'icons/obj/cosmetics.dmi'
	icon_state = "purplecomb"
//	spawn_nothing_percentage = 50
	problist = list(
		/obj/item/storage/pill_bottle/tramadol = 3,
		/obj/item/storage/pill_bottle/happy = 2,
		/obj/item/storage/pill_bottle/zoom = 2,
		/obj/item/reagent_containers/glass/beaker/vial/random/toxin = 1,
		/obj/item/contraband/poster = 5,
		/obj/item/material/knife/butterfly = 2,
		/obj/item/material/butterflyblade = 3,
		/obj/item/material/butterflyhandle = 3,
		/obj/item/material/wirerod = 3,
		/obj/item/melee/baton/cattleprod = 1,
		/obj/item/material/knife/tacknife = 1,
		/obj/item/material/kitchen/utensil/knife/boot = 2,
		/obj/item/storage/secure/briefcase/money = 1,
		/obj/item/material/knife/butterfly/switchblade = 1,
		/obj/item/reagent_containers/syringe/drugs = 1,
		/obj/item/reagent_containers/food/snacks/grown/mushroom/libertycap = 2,
		/obj/item/reagent_containers/food/snacks/grown/ambrosiavulgaris = 2,
		/obj/item/reagent_containers/food/snacks/grown/ambrosiadeus = 1,
		/obj/item/reagent_containers/food/snacks/grown/mushroom/reishi = 1,
		/obj/item/reagent_containers/food/snacks/grown/mushroom/destroyingangel = 1,
		/obj/item/reagent_containers/food/snacks/grown/mushroom/ghostmushroom = 0.5,
		/obj/item/seeds/ambrosiavulgarisseed = 2,
		/obj/item/seeds/ambrosiadeusseed = 1,
		/obj/item/clothing/mask/gas/voice = 1,
		/obj/item/clothing/gloves/brassknuckles = 2,
		/obj/item/reagent_containers/inhaler/space_drugs = 2
	)

/obj/random/energy
	name = "Random Energy Weapon"
	desc = "This is a random security weapon."
	icon = 'icons/obj/guns/ecarbine.dmi'
	icon_state = "energykill100"
	problist = list(
		/obj/item/gun/energy/rifle/laser = 2,
		/obj/item/gun/energy/gun = 2,
		/obj/item/gun/energy/stunrevolver = 1
	)

/obj/random/projectile
	name = "Random Projectile Weapon"
	desc = "This is a random security weapon."
	icon = 'icons/obj/guns/cshotgun.dmi'
	icon_state = "cshotgun"
	problist = list(
		/obj/item/gun/projectile/shotgun/pump = 3,
		/obj/item/gun/projectile/automatic/wt550 = 2,
		/obj/item/gun/projectile/shotgun/pump/combat = 1
	)

/obj/random/handgun
	name = "Random Handgun"
	desc = "This is a random security sidearm."
	icon = 'icons/obj/guns/secgun.dmi'
	icon_state = "secgun"
	problist = list(
		/obj/item/gun/projectile/sec = 3,
		/obj/item/gun/projectile/sec/wood = 1
	)

/obj/random/ammo
	name = "Random Ammunition"
	desc = "This is random ammunition."
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
		/obj/item/toy/plushie/ian,
		/obj/item/toy/plushie/drone,
		/obj/item/toy/plushie/carp,
		/obj/item/toy/plushie/beepsky,
		/obj/item/toy/plushie/ivancarp,
		/obj/item/toy/plushie/nymph,
		/obj/item/toy/plushie/mouse,
		/obj/item/toy/plushie/kitten,
		/obj/item/toy/plushie/lizard,
		/obj/item/toy/plushie/farwa,
		/obj/item/toy/plushie/squid,
		/obj/item/toy/plushie/bear,
		/obj/item/toy/plushie/bearfire
	)

/obj/random/smalltank
	name = "random small tank"

/obj/random/smalltank/item_to_spawn()
	if (prob(40))
		return /obj/item/tank/emergency_oxygen
	else if (prob(60))
		return /obj/item/tank/emergency_oxygen/engi
	else
		return /obj/item/tank/emergency_oxygen/double

/obj/random/belt
	name = "random belt"
	problist = list(
		/obj/item/storage/belt/utility = 1,
		/obj/item/storage/belt/medical = 0.4,
		/obj/item/storage/belt/medical/emt = 0.4,
		/obj/item/storage/belt/security/tactical = 0.1,
		/obj/item/storage/belt/military = 0.1,
		/obj/item/storage/belt/janitor = 0.4
	)

// Spawns a random backpack.
// Novelty and rare backpacks have lower weights.
/obj/random/backpack
	name = "random backpack"
	problist = list(
		/obj/item/storage/backpack = 3,
		/obj/item/storage/backpack/holding = 0.5,
		/obj/item/storage/backpack/cultpack = 2,
		/obj/item/storage/backpack/clown = 2,
		/obj/item/storage/backpack/medic = 3,
		/obj/item/storage/backpack/security = 3,
		/obj/item/storage/backpack/captain = 2,
		/obj/item/storage/backpack/industrial = 3,
		/obj/item/storage/backpack/toxins = 3,
		/obj/item/storage/backpack/hydroponics = 3,
		/obj/item/storage/backpack/genetics = 3,
		/obj/item/storage/backpack/virology = 3,
		/obj/item/storage/backpack/pharmacy = 3,
		/obj/item/storage/backpack/cloak = 2,
		/obj/item/storage/backpack/syndie = 1,
		/obj/item/storage/backpack/wizard = 1,
		/obj/item/storage/backpack/satchel = 3,
		/obj/item/storage/backpack/satchel_norm = 3,
		/obj/item/storage/backpack/satchel_eng = 3,
		/obj/item/storage/backpack/satchel_med = 3,
		/obj/item/storage/backpack/satchel_vir = 3,
		/obj/item/storage/backpack/satchel_pharm = 3,
		/obj/item/storage/backpack/satchel_gen = 3,
		/obj/item/storage/backpack/satchel_tox = 3,
		/obj/item/storage/backpack/satchel_sec = 3,
		/obj/item/storage/backpack/satchel_hyd = 3,
		/obj/item/storage/backpack/satchel_cap = 1,
		/obj/item/storage/backpack/satchel_syndie = 1,
		/obj/item/storage/backpack/satchel_wizard = 1,
		/obj/item/storage/backpack/ert = 1,
		/obj/item/storage/backpack/ert/security = 1,
		/obj/item/storage/backpack/ert/engineer = 1,
		/obj/item/storage/backpack/ert/medical = 1,
		/obj/item/storage/backpack/duffel = 3,
		/obj/item/storage/backpack/duffel/cap = 1,
		/obj/item/storage/backpack/duffel/hyd = 3,
		/obj/item/storage/backpack/duffel/vir = 3,
		/obj/item/storage/backpack/duffel/med = 3,
		/obj/item/storage/backpack/duffel/eng = 3,
		/obj/item/storage/backpack/duffel/tox = 3,
		/obj/item/storage/backpack/duffel/sec = 3,
		/obj/item/storage/backpack/duffel/gen = 3,
		/obj/item/storage/backpack/duffel/pharm = 3,
		/obj/item/storage/backpack/duffel/syndie = 1,
		/obj/item/storage/backpack/duffel/wizard = 1,
		/obj/item/storage/backpack/messenger = 2,
		/obj/item/storage/backpack/messenger/pharm = 2,
		/obj/item/storage/backpack/messenger/med = 2,
		/obj/item/storage/backpack/messenger/viro = 2,
		/obj/item/storage/backpack/messenger/tox = 2,
		/obj/item/storage/backpack/messenger/gen = 2,
		/obj/item/storage/backpack/messenger/com = 1,
		/obj/item/storage/backpack/messenger/engi = 2,
		/obj/item/storage/backpack/messenger/hyd = 2,
		/obj/item/storage/backpack/messenger/sec = 2,
		/obj/item/storage/backpack/messenger/syndie = 1,
		/obj/item/storage/backpack/messenger/wizard = 1
	)

/obj/random/voidsuit
	name = "random voidsuit"
	var/damaged = 0
	var/for_vox = FALSE
	var/list/suitmap = list(
		/obj/item/clothing/suit/space/void = /obj/item/clothing/head/helmet/space/void,
		/obj/item/clothing/suit/space/void/engineering = /obj/item/clothing/head/helmet/space/void/engineering,
		/obj/item/clothing/suit/space/void/mining = /obj/item/clothing/head/helmet/space/void/mining,
		/obj/item/clothing/suit/space/void/medical = /obj/item/clothing/head/helmet/space/void/medical,
		/obj/item/clothing/suit/space/void/security = /obj/item/clothing/head/helmet/space/void/security,
		/obj/item/clothing/suit/space/void/atmos = /obj/item/clothing/head/helmet/space/void/atmos,
		/obj/item/clothing/suit/space/void/merc = /obj/item/clothing/head/helmet/space/void/merc,
		/obj/item/clothing/suit/space/void/captain = /obj/item/clothing/head/helmet/space/void/captain,
		/obj/item/clothing/suit/space/void/cruiser = /obj/item/clothing/head/helmet/space/void/cruiser,
		/obj/item/clothing/suit/space/void/coalition = /obj/item/clothing/head/helmet/space/void/coalition,
		/obj/item/clothing/suit/space/void/hos = /obj/item/clothing/head/helmet/space/void/hos,
		/obj/item/clothing/suit/space/void/lancer = /obj/item/clothing/head/helmet/space/void/lancer,
		/obj/item/clothing/suit/space/void/sci = /obj/item/clothing/head/helmet/space/void/sci,
		/obj/item/clothing/suit/space/void/sol = /obj/item/clothing/head/helmet/space/void/sol,
		/obj/item/clothing/suit/space/void/hephaestus = /obj/item/clothing/head/helmet/space/void/hephaestus,
		/obj/item/clothing/suit/space/void/zenghu = /obj/item/clothing/head/helmet/space/void/zenghu,
		/obj/item/clothing/suit/space/void/einstein = /obj/item/clothing/head/helmet/space/void/einstein,
		/obj/item/clothing/suit/space/void/necropolis = /obj/item/clothing/head/helmet/space/void/necropolis
	)
	problist = list(
		/obj/item/clothing/suit/space/void = 2,
		/obj/item/clothing/suit/space/void/engineering = 2,
		/obj/item/clothing/suit/space/void/mining = 2,
		/obj/item/clothing/suit/space/void/medical = 2.3,
		/obj/item/clothing/suit/space/void/security = 1,
		/obj/item/clothing/suit/space/void/atmos = 1.5,
		/obj/item/clothing/suit/space/void/merc = 0.5,
		/obj/item/clothing/suit/space/void/captain = 0.3,
		/obj/item/clothing/suit/space/void/cruiser = 0.5,
		/obj/item/clothing/suit/space/void/coalition = 1,
		/obj/item/clothing/suit/space/void/hos = 0.3,
		/obj/item/clothing/suit/space/void/lancer = 0.3,
		/obj/item/clothing/suit/space/void/sci = 2,
		/obj/item/clothing/suit/space/void/sol = 0.5,
		/obj/item/clothing/suit/space/void/necropolis = 0.5,
		/obj/item/clothing/suit/space/void/einstein = 0.5,
		/obj/item/clothing/suit/space/void/hephaestus = 0.5,
		/obj/item/clothing/suit/space/void/zenghu = 0.5
	)
	has_postspawn = TRUE

/obj/random/voidsuit/Initialize(mapload, _damaged = 0)
	damaged = _damaged
	. = ..(mapload)

/obj/random/voidsuit/post_spawn(obj/item/clothing/suit/space/suit)
	var/helmet = suitmap[suit.type]
	if (helmet)
		new helmet(loc)
	else
		log_debug("random_obj (voidsuit): Type [suit.type] was unable to spawn a matching helmet!")
	if(!for_vox)
		new /obj/item/clothing/shoes/magboots(loc)
	else
		new /obj/item/clothing/shoes/magboots/vox(loc)
		new /obj/item/clothing/gloves/yellow/vox(loc)
	if (damaged && prob(60))
		suit.create_breaches(pick(BRUTE, BURN), rand(1, 5))

/obj/random/voidsuit/vox
	name = "random vox voidsuit"
	for_vox = TRUE
	suitmap = list(
		/obj/item/clothing/suit/space/vox/carapace = /obj/item/clothing/head/helmet/space/vox/carapace,
		/obj/item/clothing/suit/space/vox/medic = /obj/item/clothing/head/helmet/space/vox/medic,
		/obj/item/clothing/suit/space/vox/pressure = /obj/item/clothing/head/helmet/space/vox/pressure,
		/obj/item/clothing/suit/space/vox/stealth = /obj/item/clothing/head/helmet/space/vox/stealth
	)
	problist = list(
		/obj/item/clothing/suit/space/vox/carapace = 1,
		/obj/item/clothing/suit/space/vox/medic = 1,
		/obj/item/clothing/suit/space/vox/pressure = 1,
		/obj/item/clothing/suit/space/vox/stealth = 1
	)

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
	var/list/options = typesof(/obj/item/cartridge)
	var/type = pick(options)

	//reroll syndicate cartridge once to make it less common
	if (type == /obj/item/cartridge/syndicate)
		type = pick(options)

	return type

/obj/random/glowstick
	name = "random glowstick"
	desc = "This is a random glowstick."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "glowstick"
	spawnlist = list(
		/obj/item/device/flashlight/flare/glowstick,
		/obj/item/device/flashlight/flare/glowstick/red,
		/obj/item/device/flashlight/flare/glowstick/blue,
		/obj/item/device/flashlight/flare/glowstick/orange,
		/obj/item/device/flashlight/flare/glowstick/yellow
	)

/obj/random/booze
	name = "random alcoholic drink"
	desc = "This is a random alcoholic drink."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "broken_bottle"
	spawnlist = list(
		/obj/item/reagent_containers/food/drinks/bottle/gin,
		/obj/item/reagent_containers/food/drinks/bottle/whiskey,
		/obj/item/reagent_containers/food/drinks/bottle/vodka,
		/obj/item/reagent_containers/food/drinks/bottle/tequilla,
		/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing,
		/obj/item/reagent_containers/food/drinks/bottle/rum,
		/obj/item/reagent_containers/food/drinks/bottle/champagne,
		/obj/item/reagent_containers/food/drinks/bottle/vermouth,
		/obj/item/reagent_containers/food/drinks/bottle/kahlua,
		/obj/item/reagent_containers/food/drinks/bottle/cognac,
		/obj/item/reagent_containers/food/drinks/bottle/wine,
		/obj/item/reagent_containers/food/drinks/bottle/absinthe,
		/obj/item/reagent_containers/food/drinks/bottle/melonliquor,
		/obj/item/reagent_containers/food/drinks/bottle/pwine,
		/obj/item/reagent_containers/food/drinks/bottle/brandy,
		/obj/item/reagent_containers/food/drinks/bottle/guinness,
		/obj/item/reagent_containers/food/drinks/bottle/drambuie,
		/obj/item/reagent_containers/food/drinks/bottle/cremeyvette,
		/obj/item/reagent_containers/food/drinks/bottle/cremewhite,
		/obj/item/reagent_containers/food/drinks/bottle/chartreuseyellow,
		/obj/item/reagent_containers/food/drinks/bottle/chartreusegreen,
		/obj/item/reagent_containers/food/drinks/bottle/grenadine,
		/obj/item/reagent_containers/food/drinks/bottle/bluecuracao,
		/obj/item/reagent_containers/food/drinks/bottle/bitters,
		/obj/item/reagent_containers/food/drinks/bottle/champagne,
		/obj/item/reagent_containers/food/drinks/bottle/mintsyrup,
		/obj/item/reagent_containers/food/drinks/bottle/sarezhiwine,
		/obj/item/reagent_containers/food/drinks/bottle/small/beer,
		/obj/item/reagent_containers/food/drinks/bottle/small/ale,
		/obj/item/reagent_containers/food/drinks/bottle/small/xuizijuice
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

/obj/random/coin
	name = "random coin"
	desc = "This is a random coin."
	icon = 'icons/obj/coins.dmi'
	icon_state = "coin__heads"
	problist = list(
		/obj/item/coin/iron = 5,
		/obj/item/coin/silver = 3,
		/obj/item/coin/gold = 0.7,
		/obj/item/coin/phoron = 0.5,
		/obj/item/coin/uranium = 0.5,
		/obj/item/coin/platinum = 0.2,
		/obj/item/coin/diamond = 0.1
	)

/obj/random/spacecash
	name = "random credit chips"
	desc = "This is a random credit chip."
	icon = 'icons/obj/cash.dmi'
	icon_state = "spacecash1"
	problist = list(
		/obj/item/spacecash/c1 = 6,
		/obj/item/spacecash/c10 = 3,
		/obj/item/spacecash/c20 = 2,
		/obj/item/spacecash/c50 = 1,
		/obj/item/spacecash/c100 = 0.3,
		/obj/item/spacecash/c200 = 0.2,
		/obj/item/spacecash/c1000 = 0.1
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
		/obj/item/gun/energy/decloner
	)

/obj/random/colored_jumpsuit
	name = "random colored jumpsuit"
	desc = "This is a random colored jumpsuit."
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
		/obj/item/assembly/shock_kit = 0.1,
		/obj/item/bluespace_crystal/artificial = 0.1,
		/obj/item/bodybag = 0.7,
		/obj/item/clothing/accessory/storage/knifeharness = 0.3,
		/obj/item/clothing/accessory/storage/webbing = 0.6,
		/obj/item/clothing/glasses/material = 0.8,
		/obj/item/clothing/glasses/meson = 0.5,
		/obj/item/clothing/glasses/meson/prescription = 0.25,
		/obj/item/clothing/glasses/sunglasses = 0.75,
		/obj/item/clothing/glasses/welding = 0.75,
		/obj/item/clothing/head/bearpelt = 0.4,
		/obj/item/clothing/head/collectable/petehat = 0.1,
		/obj/item/clothing/head/cueball = 0.25,
		/obj/item/clothing/head/hardhat = 1.2,
		/obj/item/clothing/head/helmet/augment = 0.1,
		/obj/item/clothing/head/kitty = 0.2,
		/obj/item/clothing/head/pirate = 0.2,
		/obj/item/clothing/head/plaguedoctorhat = 0.3,
		/obj/item/clothing/head/pumpkin/lantern = 0.4,
		/obj/item/clothing/head/redcoat = 0.2,
		/obj/item/clothing/head/richard = 0.3,
		/obj/item/clothing/head/soft/rainbow = 0.7,
		/obj/item/clothing/head/syndicatefake = 0.5,
		/obj/item/clothing/head/ushanka = 0.3,
		/obj/item/clothing/head/witchwig = 0.5,
		/obj/item/clothing/mask/balaclava = 0.75,
		/obj/item/clothing/mask/fakemoustache = 0.4,
		/obj/item/clothing/mask/gas = 1.25,
		/obj/item/clothing/mask/gas/clown_hat = 0.1,
		/obj/item/clothing/mask/gas/cyborg = 0.7,
		/obj/item/clothing/mask/gas/mime = 0.1,
		/obj/item/clothing/mask/gas/old = 0.75,
		/obj/item/clothing/mask/gas/owl_mask = 0.5,
		/obj/item/clothing/mask/gas/syndicate = 0.4,
		/obj/item/clothing/mask/horsehead = 0.5,
		/obj/item/clothing/mask/luchador = 0.1,
		/obj/item/clothing/mask/luchador/rudos = 0.1,
		/obj/item/clothing/mask/luchador/tecnicos = 0.1,
		/obj/item/clothing/mask/muzzle = 0.2,
		/obj/item/clothing/mask/pig = 0.3,
		/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba = 0.7,
		/obj/item/clothing/mask/smokable/pipe/cobpipe = 0.5,
		/obj/item/clothing/shoes/carp = 0.5,
		/obj/item/clothing/shoes/clown_shoes = 0.1,
		/obj/item/clothing/shoes/combat = 0.2,
		/obj/item/clothing/shoes/cyborg = 0.4,
		/obj/item/clothing/shoes/galoshes = 0.6,
		/obj/item/clothing/shoes/jackboots = 0.5,
		/obj/item/clothing/shoes/rainbow = 0.5,
		/obj/item/clothing/shoes/slippers_worn = 0.5,
		/obj/item/clothing/shoes/winter = 0.3,
		/obj/item/clothing/shoes/workboots = 0.75,
		/obj/item/clothing/suit/ianshirt = 0.5,
		/obj/item/clothing/suit/imperium_monk = 0.4,
		/obj/item/clothing/suit/storage/hazardvest = 0.75,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen = 0.7,
		/obj/item/clothing/suit/storage/vest = 0.2,
		/obj/item/clothing/suit/syndicatefake = 0.6,
		/obj/item/clothing/under/assistantformal = 0.75,
		/obj/item/clothing/under/captain_fly = 0.5,
		/obj/item/clothing/under/mime = 0.1,
		/obj/item/clothing/under/overalls = 1,
		/obj/item/clothing/under/rainbow = 0.9,
		/obj/item/clothing/under/rank/clown = 0.1,
		/obj/item/clothing/under/rank/dispatch = 0.8,
		/obj/item/clothing/under/rank/mailman = 0.6,
		/obj/item/clothing/under/rank/vice = 0.8,
		/obj/item/clothing/under/redcoat = 0.5,
		/obj/item/clothing/under/serviceoveralls = 0.75,
		/obj/item/clothing/under/syndicate/tacticool = 0.4,
		/obj/item/clothing/under/syndicate/tracksuit = 0.2,
		/obj/item/device/firing_pin = 0.3,
		/obj/item/device/firing_pin/clown = 0.01,
		/obj/item/device/flashlight = 1,
		/obj/item/device/flashlight/flare = 0.5,
		/obj/item/device/flashlight/heavy = 0.5,
		/obj/item/device/flashlight/lantern = 0.4,
		/obj/item/device/flashlight/maglight = 0.4,
		/obj/item/device/floor_painter = 0.6,
		/obj/item/device/gps/engineering = 0.6,
		/obj/item/device/kinetic_analyzer = 0.1,
		/obj/item/device/laser_pointer/purple = 0.1,
		/obj/item/device/light_meter = 0.1,
		/obj/item/device/magnetic_lock/engineering = 0.3,
		/obj/item/device/magnetic_lock/keypad = 0.1,
		/obj/item/device/magnetic_lock/security = 0.3,
		/obj/item/device/megaphone = 0.3,
		/obj/item/device/price_scanner = 0.1,
		/obj/item/device/taperecorder = 0.6,
		/obj/item/device/uv_light = 0.1,
		/obj/item/device/wormhole_jaunter = 0.1,
		/obj/item/inflatable/door/ = 0.1,
		/obj/item/seeds/random = 0.25,
		/obj/item/stack/material/bronze{amount=10},
		/obj/item/banhammer = 0.05,
		/obj/item/clothing/head/cone = 0.7,
		/obj/item/contraband/poster = 1.3,
		/obj/item/extinguisher = 1.3,
		/obj/item/extinguisher/mini = 0.9,
		/obj/item/flag/america = 0.1,
		/obj/item/flag/america/l = 0.1,
		/obj/item/flame/lighter = 0.9,
		/obj/item/flame/lighter/zippo = 0.7,
		/obj/item/grenade/chem_grenade/cleaner = 0.1,
		/obj/item/grenade/smokebomb = 0.05, //We /tg/ now.
		/obj/item/haircomb = 0.5,
		/obj/item/inflatable_duck = 0.2,
		/obj/item/lipstick = 0.6,
		/obj/item/material/hook = 0.3,
		/obj/item/material/knife/tacknife = 0.4,
		/obj/item/mesmetron = 0.1,
		/obj/item/pickaxe = 0.4,
		/obj/item/razor = 0.5,
		/obj/item/reagent_containers/extinguisher_refill = 0.1,
		/obj/item/reagent_containers/extinguisher_refill/filled = 0.5,
		/obj/item/reagent_containers/food/drinks/flask/lithium = 0.3,
		/obj/item/reagent_containers/food/drinks/flask/shiny = 0.3,
		/obj/item/reagent_containers/food/drinks/teapot = 0.4,
		/obj/item/reagent_containers/glass/beaker/bowl = 0.8,
		/obj/item/reagent_containers/inhaler/hyperzine = 0.1,
		/obj/item/reagent_containers/spray/cleaner = 0.6,
		/obj/item/reagent_containers/spray/sterilizine = 0.4,
		/obj/item/reagent_containers/spray/waterflower = 0.2,
		/obj/item/shovel = 0.5,
		/obj/item/spacecash/ewallet/lotto = 0.3,
		/obj/item/staff/broom = 0.5,
		/obj/item/storage/bag/plasticbag = 1,
		/obj/item/storage/box/condimentbottles = 0.2,
		/obj/item/storage/box/donkpockets = 0.6,
		/obj/item/storage/box/drinkingglasses = 0.2,
		/obj/item/storage/box/lights = 0.5,
		/obj/item/storage/box/lights/colored/blue = 0.1,
		/obj/item/storage/box/lights/colored/cyan = 0.1,
		/obj/item/storage/box/lights/colored/green = 0.1,
		/obj/item/storage/box/lights/colored/magenta = 0.1,
		/obj/item/storage/box/lights/colored/red = 0.1,
		/obj/item/storage/box/lights/colored/yellow = 0.1,
		/obj/item/storage/box/lights/coloredmixed = 0.2,
		/obj/item/storage/box/masks = 0.5,
		/obj/item/storage/box/mousetraps = 0.3,
		/obj/item/storage/box/pineapple = 0.1,
		/obj/item/storage/box/smokebombs = 0.1,
		/obj/item/storage/box/syringes = 0.3,
		/obj/item/storage/fancy/cigarettes = 1.2,
		/obj/item/storage/fancy/cigarettes/acmeco = 0.3,
		/obj/item/storage/fancy/cigarettes/blank = 1,
		/obj/item/storage/fancy/cigarettes/dromedaryco = 0.8,
		/obj/item/storage/fancy/crayons = 0.5,
		/obj/item/storage/wallet/random/ = 0.1,
		/obj/item/trap/animal = 0.8,
		/obj/random/arcade = 0.25,
		/obj/random/backpack = 0.7,
		/obj/random/belt = 0.9,
		/obj/random/booze = 1.1,
		/obj/random/chameleon = 0.5,
		/obj/random/coin = 1.2,
		/obj/random/colored_jumpsuit = 0.7,
		/obj/random/contraband = 0.9,
		/obj/random/document = 0.5,
		/obj/random/firstaid = 0.4,
		/obj/random/gloves = 2,
		/obj/random/glowstick = 0.4,
		/obj/random/hoodie = 0.5,
		/obj/random/junk = 0.4,
		/obj/random/medical = 0.4,
		/obj/random/pda_cart = 0.5,
		/obj/random/powercell = 0.8,
		/obj/random/smalltank = 0.5,
		/obj/random/soap = 0.5,
		/obj/random/spacecash = 0.3,
		/obj/random/tech_supply = 1.2,
		/obj/random/technology_scanner = 1,
		/obj/random/tool = 1,
		/obj/random/toolbox = 1,
		/obj/random_produce = 0.25,
		/obj/random/watches = 1
	)


/obj/random/chameleon
	name = "random possible chameleon item"
	desc = "A random possible chameleon item. What could possibly go wrong?"
	icon = 'icons/obj/clothing/gloves.dmi'
	icon_state = "yellow"
	problist = list(

		/obj/item/clothing/gloves/chameleon = 1,
		/obj/item/clothing/gloves/black = 10,

		/obj/item/clothing/head/chameleon = 0.5,
		/obj/item/clothing/head/soft/grey = 5,

		/obj/item/clothing/mask/chameleon = 1,
		/obj/item/clothing/mask/gas/ = 10,

		/obj/item/clothing/shoes/chameleon = 0.5,
		/obj/item/clothing/shoes/black = 5,

		/obj/item/clothing/suit/chameleon = 0.1,
		/obj/item/clothing/suit/armor/vest = 1,

		/obj/item/clothing/under/chameleon = 0.75,
		/obj/item/clothing/under/color/black = 7.5,

		/obj/item/gun/energy/chameleon = 0.1,
		/obj/item/gun/bang/deagle = 0.1,

		/obj/item/storage/backpack/chameleon = 1,
		/obj/item/storage/backpack/ = 10,

		/obj/item/clothing/glasses/chameleon = 1,
		/obj/item/clothing/glasses/meson = 1

	)

/obj/random/gloves
	name = "random gloves"
	desc = "Random gloves, assorted usefulness."
	icon = 'icons/obj/clothing/gloves.dmi'
	icon_state = "yellow"
	problist = list(
		/obj/item/clothing/gloves/black = 1,
		/obj/item/clothing/gloves/black_leather = 0.5,
		/obj/item/clothing/gloves/botanic_leather = 0.7,
		/obj/item/clothing/gloves/boxing = 0.3,
		/obj/item/clothing/gloves/boxing/green = 0.3,
		/obj/item/clothing/gloves/captain = 0.1,
		/obj/item/clothing/gloves/combat = 0.2,
		/obj/item/clothing/gloves/fyellow = 1.2,
		/obj/item/clothing/gloves/latex = 0.5,
		/obj/item/clothing/gloves/latex/nitrile = 0.4,
		/obj/item/clothing/gloves/yellow = 0.9
	)

/obj/random/watches
	name = "random watches"
	desc = "Random watches, probably able to tell the time."
	icon = 'icons/obj/clothing/gloves.dmi'
	icon_state = "watch"
	problist = list(
		/obj/item/clothing/gloves/watch = 1,
		/obj/item/clothing/gloves/watch/silver = 0.7,
		/obj/item/clothing/gloves/watch/gold = 0.5,
		/obj/item/clothing/gloves/watch/spy = 0.3,
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
	icon = 'icons/obj/coins.dmi'
	icon_state = "coin_diamond_heads"
	problist = list(
		/obj/item/bluespace_crystal = 5,
		/obj/item/stack/telecrystal{amount = 10} = 5,
		/obj/item/clothing/suit/armor/reactive = 0.5,
		/obj/item/clothing/glasses/thermal = 0.5,
		/obj/item/gun/projectile/automatic/rifle/shotgun = 0.5,
		/obj/random/sword = 0.5,
		/obj/item/gun/energy/lawgiver = 0.5,
		/obj/item/melee/energy/axe = 0.5,
		/obj/item/gun/projectile/automatic/terminator = 0.5,
		/obj/item/rig/military = 0.5,
		/obj/item/rig/unathi/fancy = 0.5,
		/obj/item/rig/vaurca/minimal = 0.5,
		/obj/item/anomaly_core = 0.5
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
		/obj/item/trash/tuna = 0.5,
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
		/obj/item/storage/box = 1,
		/obj/item/material/shard = 1,
		/obj/item/material/shard/shrapnel = 1,
		/obj/item/broken_bottle = 1,
		/obj/item/stack/material/cardboard = 1,
		/obj/item/stack/rods = 1,
		/obj/item/corncob = 1,
		/obj/item/paper/crumpled = 1,
		/obj/item/inflatable/torn = 1,
		/obj/item/ammo_casing/c45/rubber = 0.5,
		/obj/item/ammo_casing/c9mm/rubber = 0.5,
		/obj/item/ammo_casing/c45/flash = 0.5,
		/obj/item/ammo_casing/shotgun/beanbag = 0.5,
		/obj/random/document/junk = 0.5,
		/obj/item/flame/lighter/random = 0.25,
		/obj/item/lipstick/random = 0.25,
		/obj/item/reagent_containers/glass/beaker/vial/random = 0.1,
		/obj/item/towel/random = 0.1,
		/obj/item/device/flashlight/flare/glowstick/random = 0.25,
		/obj/item/stack/cable_coil/random/ = 0.1,
		/obj/item/bananapeel = 0.1, //honk,
		/obj/item/key = 0.1,
		/obj/item/reagent_containers/blood/ripped = 0.1,
		/obj/item/shreddedp = 0.1

	)

//Sometimes the chef will have spare oil in storage.
//Sometimes they wont, and will need to order it from cargo
//Variety is the spice of life!
/obj/random/cookingoil
	name = "random cooking oil"
	desc = "Has a 50% chance of spawning a tank of cooking oil, otherwise nothing"
	icon = 'icons/obj/reagent_dispensers.dmi'
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

/obj/random/arcade
	name = "random arcade loot"
	desc = "Arcade loot!"
	icon = 'icons/obj/items.dmi'
	icon_state = "gift3"
	spawnlist = list(
		/obj/item/storage/box/snappops			= 11,
		/obj/item/clothing/under/syndicate/tacticool	= 5,
		/obj/item/toy/sword								= 22,
		/obj/item/gun/projectile/revolver/capgun	= 11,
		/obj/item/toy/crossbow							= 11,
		/obj/item/storage/fancy/crayons			= 11,
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
		/obj/item/storage/belt/champion			= 11,
		/obj/item/pen/invisible					= 5,
		/obj/item/grenade/fake					= 1,
		/obj/item/bikehorn						= 11,
		/obj/item/clothing/mask/fakemoustache			= 11,
		/obj/item/clothing/mask/gas/clown_hat			= 11,
		/obj/item/clothing/mask/gas/mime				= 11,
		/obj/item/clothing/shoes/carp					= 9,
		/obj/item/gun/energy/wand/toy			= 5,
		/obj/item/device/binoculars						= 11,
		/obj/item/device/megaphone						= 11,
		/obj/item/eightball								= 11,
		/obj/item/eightball/haunted						= 1,
		/obj/item/eightball/broken						= 1,
		/obj/item/spirit_board					= 5,
		/obj/item/device/laser_pointer					= 1,
		/obj/item/clothing/accessory/badge/press/plastic = 2


	)

/obj/random/arcade/orion
	name = "random arcade loot for orion trails"
	desc = "Arcade loot for orion trails aracde machine!"
	icon = 'icons/obj/items.dmi'
	icon_state = "gift3"
	spawnlist = list(
		/obj/item/clothing/under/syndicate/tacticool	= 7,
		/obj/item/toy/sword								= 22,
		/obj/item/gun/projectile/revolver/capgun	= 11,
		/obj/item/gun/bang						= 22,
		/obj/item/toy/crossbow							= 11,
		/obj/random/action_figure						= 11,
		/obj/item/toy/cultsword							= 7,
		/obj/item/toy/syndicateballoon					= 10,
		/obj/item/toy/nanotrasenballoon					= 5,
		/obj/item/toy/katana							= 11,
		/obj/random/plushie								= 55,
		/obj/item/storage/belt/champion			= 11,
		/obj/item/pen/invisible					= 10,
		/obj/item/grenade/fake					= 7,
		/obj/item/gun/energy/wand/toy			= 7,
		/obj/item/device/binoculars						= 11,
		/obj/item/device/megaphone						= 11,
		/obj/item/eightball								= 11,
		/obj/item/eightball/haunted						= 5,
		/obj/item/spirit_board					= 5,
		/obj/item/clothing/accessory/badge/press/plastic = 2
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
			/obj/item/gun/custom_ka/frame01 = 1,
			/obj/item/gun/custom_ka/frame02 = 2,
			/obj/item/gun/custom_ka/frame03 = 3,
			/obj/item/gun/custom_ka/frame04 = 2,
			/obj/item/gun/custom_ka/frame05 = 1
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
		var/obj/item/gun/custom_ka/spawned_frame = new frame_type(thing.loc)

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
		/obj/item/gun/custom_ka/frame01/prebuilt = 2.5,
		/obj/item/gun/custom_ka/frame02/prebuilt = 5,
		/obj/item/gun/custom_ka/frame03/prebuilt = 10,
		/obj/item/gun/custom_ka/frame04/prebuilt = 5,
		/obj/item/gun/custom_ka/frame05/prebuilt = 2.5,
		/obj/item/gun/custom_ka/frameA/prebuilt = 1,
		/obj/item/gun/custom_ka/frameB/prebuilt = 1,
		/obj/item/gun/custom_ka/frameC/prebuilt = 1,
		/obj/item/gun/custom_ka/frameD/prebuilt = 1,
		/obj/item/gun/custom_ka/frameF/prebuilt01 = 1,
		/obj/item/gun/custom_ka/frameF/prebuilt02 = 1
	)

/obj/random/vault_rig
	name = "random rigsuit"
	desc = "Contains a random rigsuit found in the vault."
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "breacher_rig"
	spawnlist = list(
		/obj/item/rig/ce = 1,
		/obj/item/rig/eva= 1,
		/obj/item/rig/hazard = 1,
		/obj/item/rig/hazmat = 1,
		/obj/item/rig/medical = 1,
		/obj/item/rig/industrial = 1
	)

/obj/random/telecrystals
	name = "random telecrystals"
	desc = "Contains a random amount of telecrystals."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "telecrystal"
	spawnlist = list(
		/obj/item/stack/telecrystal{amount = 5} = 0.7,
		/obj/item/stack/telecrystal{amount = 10} = 0.1,
		/obj/item/stack/telecrystal{amount = 15} = 0.2,
	)

/obj/random/bad_ai
	name = "random evil AI module"
	desc = "Contains a random evil AI module."
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	spawnlist = list(
		/obj/item/aiModule/antimov = 1,
		/obj/item/aiModule/asimov = 1,
		/obj/item/aiModule/purge = 1,
		/obj/item/aiModule/quarantine = 1,
		/obj/item/aiModule/freeform = 1,
		/obj/item/aiModule/oneHuman = 0.5,
		/obj/item/aiModule/oxygen = 1
	)

/obj/random/rig_module
	name = "random rig module"
	desc = "Contains a random rig module worthy of vault protection."
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "actuators"
	spawnlist = list(
		/obj/item/rig_module/actuators/combat = 1,
		/obj/item/rig_module/chem_dispenser/combat = 1,
		/obj/item/rig_module/chem_dispenser/injector = 1,
		/obj/item/rig_module/device/emag_hand = 1,
		/obj/item/rig_module/device/rfd_c = 1,
		/obj/item/rig_module/electrowarfare_suite = 0.5,
		/obj/item/rig_module/emp_shielding = 0.5,
		/obj/item/rig_module/fabricator/energy_net = 1,
		/obj/item/rig_module/fabricator = 0.5,
		/obj/item/rig_module/grenade_launcher = 0.5,
		/obj/item/rig_module/maneuvering_jets = 0.5,
		/obj/item/rig_module/mounted/egun = 1,
		/obj/item/rig_module/mounted/smg = 0.5,
		/obj/item/rig_module/vision/multi = 0.5
	)

/obj/random/finances
	name = "random valued item"
	desc = "Contains raw valued items like phoron, gold, and money."
	spawnlist = list(
		/obj/item/spacecash/bundle{worth = 5000} = 0.25,
		/obj/item/spacecash/bundle{worth = 10000} = 0.5,
		/obj/item/spacecash/bundle{worth = 25000} = 0.25,
		/obj/item/stack/material/phoron{amount = 50} = 1,
		/obj/item/stack/material/gold{amount = 50} = 1
	)

	has_postspawn = TRUE

/obj/random/finances/post_spawn(var/obj/item/spawned)
	spawned.update_icon()

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

/obj/random/animal_crate
	name = "random animal"
	desc = "Contains a random crate with some animal."
	icon = 'icons/obj/storage.dmi'
	icon_state = "densecrate"
	spawnlist = list(
		/obj/structure/largecrate/animal/corgi = 3,
		/obj/structure/largecrate/animal/cow = 4,
		/obj/structure/largecrate/animal/goat = 3,
		/obj/structure/largecrate/animal/cat = 2,
		/obj/structure/largecrate/animal/chick = 4,
		/obj/structure/largecrate/animal/adhomai = 0.5,
		/obj/structure/largecrate/animal/adhomai/fatshouter = 0.5,
		/obj/structure/largecrate/animal/adhomai/rafama = 0.5,
		/obj/structure/largecrate/animal/adhomai/schlorrgo = 0.2,
		/obj/structure/largecrate/animal/hakhma = 0.5
	)

/obj/random/random_flag
	name = "random flag"
	desc = "Contains a random boxed flag or banner."
	icon = 'icons/obj/decals.dmi'
	icon_state = "flag_boxed"
	spawnlist = list(
		/obj/item/flag/biesel,
		/obj/item/flag/biesel/l,
		/obj/item/flag/dominia,
		/obj/item/flag/dominia/l,
		/obj/item/flag/dpra,
		/obj/item/flag/dpra/l,
		/obj/item/flag/elyra,
		/obj/item/flag/elyra/l,
		/obj/item/flag/eridani,
		/obj/item/flag/eridani/l,
		/obj/item/flag/hegemony,
		/obj/item/flag/hegemony/l,
		/obj/item/flag/heph,
		/obj/item/flag/heph/l,
		/obj/item/flag/jargon,
		/obj/item/flag/jargon/l,
		/obj/item/flag/nanotrasen,
		/obj/item/flag/nanotrasen/l,
		/obj/item/flag/nka,
		/obj/item/flag/nka/l,
		/obj/item/flag/pra,
		/obj/item/flag/pra/l,
		/obj/item/flag/sol,
		/obj/item/flag/sol/l,
		/obj/item/flag/vaurca,
		/obj/item/flag/vaurca/l,
		/obj/item/flag/zenghu,
		/obj/item/flag/zenghu/l,
		/obj/item/flag/coalition,
		/obj/item/flag/coalition/l
	)

/obj/random/gift
	name = "random gift"
	desc = "Contains a randomly sized gift."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"
	spawnlist = list(
		/obj/item/xmasgift/small = 0.5,
		/obj/item/xmasgift/medium =  0.3,
		/obj/item/xmasgift/large = 0.2
	)

/obj/random/weapon_and_ammo
	name = "random weapon and ammo"
	desc = "Summons a random weapon, with ammo if applicable"
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
		/obj/item/gun/projectile/contender = 1,
		/obj/item/gun/projectile/leyon = 1,
		/obj/item/gun/projectile/revolver/derringer = 1,
		/obj/item/gun/projectile/shotgun/pump/rifle/obrez = 1,
		/obj/item/gun/projectile/shotgun/pump/rifle/vintage = 1,
		/obj/item/gun/launcher/harpoon = 0.5
		)

	var/list/Common = list(
		/obj/item/gun/energy/blaster/carbine = 1,
		/obj/item/gun/energy/crossbow/largecrossbow = 1,
		/obj/item/gun/energy/laser = 0.5,
		/obj/item/gun/energy/pistol = 1,
		/obj/item/gun/energy/rifle = 1,
		/obj/item/gun/projectile/automatic/c20r = 1,
		/obj/item/gun/projectile/automatic/mini_uzi = 1,
		/obj/item/gun/projectile/automatic/wt550/lethal = 0.5,
		/obj/item/gun/projectile/colt = 0.5,
		/obj/item/gun/projectile/pistol/sol = 1,
		/obj/item/gun/projectile/pistol/adhomai = 1,
		/obj/item/gun/projectile/revolver/detective = 0.5,
		/obj/item/gun/projectile/revolver/adhomian = 1,
		/obj/item/gun/projectile/revolver/lemat = 1,
		/obj/item/gun/projectile/sec/lethal= 0.5,
		/obj/item/gun/projectile/shotgun/doublebarrel/pellet = 1,
		/obj/item/gun/projectile/shotgun/pump/rifle = 1,
		/obj/item/gun/projectile/tanto = 1,
		/obj/item/gun/projectile/gauss = 1
		)

	var/list/Rare = list(
		/obj/item/gun/energy/blaster/revolver = 1,
		/obj/item/gun/energy/blaster/rifle = 1,
		/obj/item/gun/energy/pistol/hegemony = 1,
		/obj/item/gun/energy/rifle/laser = 1,
		/obj/item/gun/energy/rifle/ionrifle = 0.5,
		/obj/item/gun/energy/vaurca/blaster = 1,
		/obj/item/gun/energy/xray = 1,
		/obj/item/gun/energy/lasercannon = 1,
		/obj/item/gun/projectile/automatic/rifle/sts35 = 1,
		/obj/item/gun/projectile/automatic/x9 = 1,
		/obj/item/gun/projectile/deagle = 1,
		/obj/item/gun/projectile/deagle/adhomai = 1,
		/obj/item/gun/projectile/silenced = 1,
		/obj/item/gun/projectile/dragunov = 1,
		/obj/item/gun/projectile/plasma/bolter = 1,
		/obj/item/gun/projectile/shotgun/doublebarrel/sawn = 1,
		/obj/item/gun/projectile/shotgun/foldable = 1,
		/obj/item/gun/projectile/shotgun/pump/combat = 1,
		/obj/item/gun/projectile/shotgun/pump/combat/sol = 1
		)

	var/list/Epic = list(
		/obj/item/gun/energy/pulse/pistol = 1,
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
		/obj/item/gun/projectile/gyropistol = 0.5,
		/obj/item/gun/projectile/plasma = 1
		)

	var/list/Legendary = list(
		/obj/item/gun/energy/lawgiver = 1,
		/obj/item/gun/energy/pulse = 1,
		/obj/item/gun/energy/rifle/pulse = 1,
		/obj/item/gun/projectile/automatic/railgun = 1,
		/obj/item/gun/projectile/automatic/rifle/l6_saw = 1,
		/obj/item/gun/projectile/automatic/terminator = 1,
		/obj/item/gun/projectile/nuke = 1,
		/obj/item/gun/projectile/revolver/mateba = 1
		)

/obj/random/weapon_and_ammo/concealable
	concealable = TRUE

/obj/random/weapon_and_ammo/post_spawn(var/obj/item/gun/projectile/spawned)
	if(!istype(spawned, /obj/item/gun/projectile))
		return
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
		for(var/i = 0; i < (spawned.max_shells * 2); i++)
			new spawned.ammo_type(spawned.loc)

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

/obj/random/keg
	name = "random alcohol keg"
	desc = "Contains a random alcohol keg."
	icon = 'icons/obj/reagent_dispensers.dmi'
	icon_state = "beertankTEMP"
	spawnlist = list(
		/obj/structure/reagent_dispensers/keg/beerkeg = 2,
		/obj/structure/reagent_dispensers/keg/xuizikeg =  0.5,
		/obj/structure/reagent_dispensers/keg/mead = 0.5
	)