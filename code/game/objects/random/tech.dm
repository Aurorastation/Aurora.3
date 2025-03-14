/obj/random/tool
	name = "random tool"
	desc = "This is a random tool"
	icon_state = "tool"
	spawnlist = list(
		/obj/item/screwdriver,
		/obj/item/wirecutters,
		/obj/item/weldingtool,
		/obj/item/crowbar,
		/obj/item/wrench,
		/obj/item/hammer,
		/obj/item/device/flashlight
	)

/obj/random/technology_scanner
	name = "random scanner"
	desc = "This is a random technology scanner."
	icon = 'icons/obj/item/device/air_analyzer.dmi'
	icon_state = "analyzer"
	problist = list(
		/obj/item/device/t_scanner = 5,
		/obj/item/device/radio = 2,
		/obj/item/device/analyzer = 5
	)

/obj/random/powercell
	name = "random powercell"
	desc = "This is a random powercell."
	icon_state = "cell"
	problist = list(
		/obj/item/cell = 40,
		/obj/item/cell/high = 40,
		/obj/item/cell/crap = 10,
		/obj/item/cell/mecha = 10,
		/obj/item/cell/super = 9,
		/obj/item/cell/mecha/nuclear = 5,
		/obj/item/cell/hyper = 1
	)

/obj/random/bomb_supply
	name = "bomb supply"
	desc = "This is a random bomb supply."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "signaller"
	problist = list(
		/obj/item/device/assembly/igniter = 2,
		/obj/item/device/assembly/prox_sensor = 2,
		/obj/item/device/assembly/signaler = 2,
		/obj/item/device/multitool = 1,
		/obj/item/device/transfer_valve = 0.5
	)

/obj/random/toolbox
	name = "random toolbox"
	desc = "This is a random toolbox."
	icon_state = "toolbox"
	spawnlist = list(
		/obj/item/storage/toolbox/mechanical = 3,
		/obj/item/storage/toolbox/electrical = 2,
		/obj/item/storage/toolbox/emergency = 1
	)

/obj/random/tech_supply
	name = "random tech supply"
	desc = "This is a random piece of technology supplies."
	icon_state = "tech_supply"
	problist = list(
		/obj/random/powercell = 3,
		/obj/random/technology_scanner = 2,
		/obj/item/stack/packageWrap = 1,
		/obj/random/bomb_supply = 2,
		/obj/item/extinguisher = 1,
		/obj/item/clothing/gloves/yellow/budget = 1,
		/obj/item/stack/cable_coil = 3,
		/obj/random/toolbox = 2,
		/obj/item/storage/belt/utility = 2,
		/obj/random/tool = 5,
		/obj/item/tape_roll = 2
	)

/// Spawns a random AI lawboard with 'evil' law sets
/obj/random/bad_ai
	name = "random evil AI module"
	desc = "Contains a random evil AI module."
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	spawnlist = list(
		/obj/item/aiModule/antimov = 0.5,
		/obj/item/aiModule/asimov = 1,
		/obj/item/aiModule/purge = 1,
		/obj/item/aiModule/robocop = 0.5,
		/obj/item/aiModule/tyrant = 0.5,
		/obj/item/aiModule/paladin = 0.5,
		/obj/item/aiModule/hadiist = 0.2,
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

/obj/random/voidsuit/freebooter
	name = "random freebooter voidsuit"
	suitmap = list(
		/obj/item/clothing/suit/space/void/engineering = /obj/item/clothing/head/helmet/space/void/engineering,
		/obj/item/clothing/suit/space/void/mining = /obj/item/clothing/head/helmet/space/void/mining,
		/obj/item/clothing/suit/space/void/merc = /obj/item/clothing/head/helmet/space/void/merc,
		/obj/item/clothing/suit/space/void/freelancer = /obj/item/clothing/head/helmet/space/void/freelancer,
		/obj/item/rig/industrial,
		/obj/item/rig/eva,
		/obj/item/rig/hazard,
		/obj/item/clothing/suit/space/syndicate/black/red = /obj/item/clothing/head/helmet/space/syndicate/black/red,
		/obj/item/clothing/suit/space/syndicate/black = /obj/item/clothing/head/helmet/space/syndicate/black
	)
	problist = list(
		/obj/item/clothing/suit/space/void/engineering = 3,
		/obj/item/clothing/suit/space/void/mining = 3,
		/obj/item/clothing/suit/space/void/merc = 1,
		/obj/item/clothing/suit/space/void/freelancer = 1,
		/obj/item/rig/industrial = 2,
		/obj/item/rig/hazard = 1,
		/obj/item/rig/eva = 2,
		/obj/item/clothing/suit/space/syndicate/black = 1,
		/obj/item/clothing/suit/space/syndicate/black/red = 1
	)
	has_postspawn = TRUE

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
		/obj/item/clothing/suit/space/void/zavodskoi = /obj/item/clothing/head/helmet/space/void/zavodskoi
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
		/obj/item/clothing/suit/space/void/zavodskoi = 0.5,
		/obj/item/clothing/suit/space/void/einstein = 0.5,
		/obj/item/clothing/suit/space/void/hephaestus = 0.5,
		/obj/item/clothing/suit/space/void/zenghu = 0.5
	)
	has_postspawn = TRUE

/obj/random/voidsuit/no_nanotrasen
	suitmap = list(
		/obj/item/clothing/suit/space/void = /obj/item/clothing/head/helmet/space/void,
		/obj/item/clothing/suit/space/void/merc = /obj/item/clothing/head/helmet/space/void/merc,
		/obj/item/clothing/suit/space/void/cruiser = /obj/item/clothing/head/helmet/space/void/cruiser,
		/obj/item/clothing/suit/space/void/coalition = /obj/item/clothing/head/helmet/space/void/coalition,
		/obj/item/clothing/suit/space/void/lancer = /obj/item/clothing/head/helmet/space/void/lancer,
		/obj/item/clothing/suit/space/void/sol = /obj/item/clothing/head/helmet/space/void/sol,
		/obj/item/clothing/suit/space/void/hephaestus = /obj/item/clothing/head/helmet/space/void/hephaestus,
		/obj/item/clothing/suit/space/void/zenghu = /obj/item/clothing/head/helmet/space/void/zenghu,
		/obj/item/clothing/suit/space/void/einstein = /obj/item/clothing/head/helmet/space/void/einstein,
		/obj/item/clothing/suit/space/void/zavodskoi = /obj/item/clothing/head/helmet/space/void/zavodskoi
	)
	problist = list(
		/obj/item/clothing/suit/space/void = 2,
		/obj/item/clothing/suit/space/void/merc = 0.5,
		/obj/item/clothing/suit/space/void/cruiser = 0.5,
		/obj/item/clothing/suit/space/void/coalition = 1,
		/obj/item/clothing/suit/space/void/lancer = 0.3,
		/obj/item/clothing/suit/space/void/sol = 0.5,
		/obj/item/clothing/suit/space/void/zavodskoi = 0.5,
		/obj/item/clothing/suit/space/void/einstein = 0.5,
		/obj/item/clothing/suit/space/void/hephaestus = 0.5,
		/obj/item/clothing/suit/space/void/zenghu = 0.5
	)

/obj/random/voidsuit/Initialize(mapload, _damaged = 0)
	damaged = _damaged
	. = ..(mapload)

/obj/random/voidsuit/post_spawn(obj/item/clothing/suit/space/suit)
	var/helmet = suitmap[suit.type]
	if (helmet)
		new helmet(loc)
	else
		log_debug("random_obj (voidsuit): Type [suit.type] was unable to spawn a matching helmet!")
	new /obj/item/clothing/shoes/magboots(loc)
	if (damaged && prob(60))
		suit.create_breaches(pick(DAMAGE_BRUTE, DAMAGE_BURN), rand(1, 5))
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

/obj/random/safe_rig
	name = "random rigsuit"
	desc = "contains a random highvalue rigsuit found in the vault"
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "breacher_rig"
	spawnlist = list(
		/obj/item/rig/combat/equipped = 0.8,
		/obj/item/rig/military = 0.3,
		/obj/item/rig/hazard/equipped = 0.8,
		/obj/item/rig/retro/equipped = 0.8,
		/obj/item/rig/ert/security = 0.3,
		/obj/item/rig/unathi = 0.4
	)
