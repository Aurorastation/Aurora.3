// --- Rare ---

STOCK_ITEM_RARE(gold, 2.5)
	new /obj/item/stack/material/gold(L, rand(2,15))

STOCK_ITEM_RARE(diamond, 1.5)
	new /obj/item/stack/material/diamond(L, rand(1,10))

STOCK_ITEM_RARE(uranium, 3)
	new /obj/item/stack/material/uranium(L, rand(5,30))

STOCK_ITEM_RARE(EMP, 0.75)
	new /obj/item/storage/box/emps(L)

STOCK_ITEM_RARE(hypercell, 3)
	new /obj/item/cell/hyper(L)

STOCK_ITEM_RARE(combatmeds, 3)
	new /obj/item/storage/firstaid/combat(L)

STOCK_ITEM_RARE(batterer, 0.75)
	new /obj/item/device/batterer(L)

STOCK_ITEM_RARE(posibrain, 3)
	new /obj/item/device/mmi/digital/posibrain(L)

STOCK_ITEM_RARE(bsbeaker, 3)
	new /obj/item/reagent_containers/glass/beaker/bluespace(L)
	if (prob(50))
		new /obj/item/reagent_containers/glass/beaker/bluespace(L)

STOCK_ITEM_RARE(energyshield, 2)
	new /obj/item/shield/energy(L)

// A random RIG/hardsuit.
// It'll come with some screwy electronics, possibly needing reprogramming.
STOCK_ITEM_RARE(hardsuit, 0.75)
	var/list/rigs = list(
		/obj/item/rig/unathi = 2,
		/obj/item/rig/unathi/fancy = 0.75,
		/obj/item/rig/combat = 0.1,
		/obj/item/rig/ert = 0.1,
		/obj/item/rig/ert/engineer = 0.1,
		/obj/item/rig/ert/medical = 0.15,
		/obj/item/rig/ert/security = 0.075,
		/obj/item/rig/light = 0.5,
		/obj/item/rig/light/hacker = 0.8,
		/obj/item/rig/light/stealth = 0.5,
		/obj/item/rig/merc/empty = 0.5,
		/obj/item/rig/industrial = 3,
		/obj/item/rig/eva = 3,
		/obj/item/rig/ce = 2,
		/obj/item/rig/hazmat = 4,
		/obj/item/rig/medical = 4,
		/obj/item/rig/hazard = 3,
		/obj/item/rig/diving = 1
	)

	var/type = pickweight(rigs)
	var/obj/item/rig/module = new type(L)

	//screw it up a bit
	var/cnd = rand(40,100)
	module.lose_modules(cnd)
	module.misconfigure(cnd)
	module.sabotage_cell()
	module.sabotage_tank()

STOCK_ITEM_RARE(cluster, 2.0)
	new /obj/item/grenade/flashbang/clusterbang(L)

STOCK_ITEM_RARE(ladder, 3)
	new /obj/item/ladder_mobile(L)

STOCK_ITEM_RARE(sword, 0.5)
	new /obj/random/sword(L)

STOCK_ITEM_RARE(ims, 1.5)
	new /obj/item/scalpel/manager(L)

STOCK_ITEM_RARE(exogear, 1.5)
	var/list/equips = list(
		/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp = 1,
		/obj/item/mecha_parts/mecha_equipment/tool/drill = 1,
		/obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill = 0.7,
		/obj/item/mecha_parts/mecha_equipment/tool/extinguisher = 1,
		/obj/item/mecha_parts/mecha_equipment/tool/rfd_c = 0.08,
		/obj/item/mecha_parts/mecha_equipment/teleporter = 0.3,
		/obj/item/mecha_parts/mecha_equipment/wormhole_generator = 0.5,
		/obj/item/mecha_parts/mecha_equipment/gravcatapult = 0.8,
		/obj/item/mecha_parts/mecha_equipment/armor_booster/anticcw_armor_booster = 1,
		/obj/item/mecha_parts/mecha_equipment/armor_booster/antiproj_armor_booster = 0.9,
		/obj/item/mecha_parts/mecha_equipment/repair_droid = 0.7,
		/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay = 0.4,
		/obj/item/mecha_parts/mecha_equipment/generator = 1.5,
		/obj/item/mecha_parts/mecha_equipment/generator/nuclear = 0.8,
		/obj/item/mecha_parts/mecha_equipment/tool/safety_clamp = 0.2,
		/obj/item/mecha_parts/mecha_equipment/tool/passenger = 1,
		/obj/item/mecha_parts/mecha_equipment/tool/sleeper = 0.9,
		/obj/item/mecha_parts/mecha_equipment/tool/cable_layer = 1.2,
		/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun = 1
	)

	for (var/i in 1 to rand(2,5))
		var/type = pickweight(equips)
		new type(L)

STOCK_ITEM_RARE(teleporter, 1)
	new /obj/item/hand_tele(L)

STOCK_ITEM_RARE(voice, 1.5)
	new /obj/item/clothing/mask/gas/voice(L)

STOCK_ITEM_RARE(xenohide, 0.5)
	new /obj/item/stack/material/animalhide/xeno(L, rand(2,15))

STOCK_ITEM_RARE(humanhide, 0.5)
	new /obj/item/stack/material/animalhide/human(L, rand(2,15))

STOCK_ITEM_RARE(modkit, 1)
	var/list/type = pick( \
		/obj/item/device/kit/paint/ripley, \
		/obj/item/device/kit/paint/ripley/death, \
		/obj/item/device/kit/paint/ripley/flames_red, \
		/obj/item/device/kit/paint/ripley/flames_blue, \
		/obj/item/device/kit/paint/ripley/titan, \
		/obj/item/device/kit/paint/ripley/earth, \
		/obj/item/device/kit/paint/durand, \
		/obj/item/device/kit/paint/durand/seraph, \
		/obj/item/device/kit/paint/durand/phazon, \
		/obj/item/device/kit/paint/gygax, \
		/obj/item/device/kit/paint/gygax/darkgygax, \
		/obj/item/device/kit/paint/gygax/recitence \
	)

	new type(L)

STOCK_ITEM_RARE(contraband, 0.8)
	new /obj/random/contraband(L)

STOCK_ITEM_RARE(prebuilt_ka, 0.5)
	new /obj/random/prebuilt_ka(L)

STOCK_ITEM_RARE(nothing, 0)
