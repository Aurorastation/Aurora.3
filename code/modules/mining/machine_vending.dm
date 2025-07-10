//PROGRESSION SYSTEM: Miners start with a basic ass manual pickaxe. They can shortly buy an autodrill, or save up for a /TG/ Kinetic Accelerator.
//HARDSUITS: Miners all start with an *empty* industrial hardsuit. Many of the items they can buy here (auto-drill, kinetic accelerator) can be converted into modules
//			with a special machine.
//VENDOR: Obj/item's are immediately dispensed by the vendor. Machines, structures, vehicles, and etc get spawned on the cargo elevator.
//Think up of lots of items. Not everything needs to be unique or even mining-special, but it should be neat. Convert most of /tg/'s items. 25% of this at least
//	should be bling. Things that shorten the distance between base and mining. Instant-teleporters should be one use.
GLOBAL_LIST_INIT(minevendor_list, list(
	/*
	Format:
	new /datum/data/mining_equipment(	[TYPEPATH], [AMOUNT], [COST], [SHUTTLE?]	),
	*/
	new /datum/data/mining_equipment(/obj/item/reagent_containers/food/snacks/liquidfood,		10,					5),
	new /datum/data/mining_equipment(/obj/item/contraband/poster,								10,					20),
	new /datum/data/mining_equipment(/obj/item/ore_radar,										10,					50),
	new /datum/data/mining_equipment(/obj/item/stack/flag/red,									10,					50),
	new /datum/data/mining_equipment(/obj/item/stack/flag/green,								10,					50),
	new /datum/data/mining_equipment(/obj/item/stack/flag/yellow,								10,					50),
	new /datum/data/mining_equipment(/obj/item/stack/flag/purple,								10,					50),
	new /datum/data/mining_equipment(/obj/item/storage/bag/ore,									25,					50),
	new /datum/data/mining_equipment(pick(subtypesof(/obj/item/pizzabox)), 									25,					50),
	new /datum/data/mining_equipment(/obj/item/device/flashlight/lantern,						10,					75),
	new /datum/data/mining_equipment(/obj/item/shovel,											15,					100),
	new /datum/data/mining_equipment(/obj/item/pickaxe,											10,					100),
	new /datum/data/mining_equipment(/obj/item/rfd_ammo,										50,					100),
	new /datum/data/mining_equipment(/obj/item/gun/custom_ka/frame01/prebuilt,					12,					200),
	new /datum/data/mining_equipment(/obj/structure/ore_box,									-1,					150,	1),
	new /datum/data/mining_equipment(/obj/item/deployable_kit, 									-1,					150,	1),
	new /datum/data/mining_equipment(/obj/item/clothing/mask/smokable/cigarette/cigar/havana, 	30,					150),
	new /datum/data/mining_equipment(/obj/item/plastique/seismic,								25,					150),
	new /datum/data/mining_equipment(/obj/item/ladder_mobile,									5,					200),
	new /datum/data/mining_equipment(/obj/item/hoist_kit,										5,					200),
	new /datum/data/mining_equipment(/obj/item/pickaxe/drill,									10,					200),
	new /datum/data/mining_equipment(/obj/item/mining_scanner,									10,					250),
	new /datum/data/mining_equipment(/obj/item/clothing/shoes/magboots,							10,					300),
	new /datum/data/mining_equipment(/obj/item/gun/custom_ka/frame02/prebuilt,					12,					400),
	new /datum/data/mining_equipment(/obj/item/autochisel,										10,					400),
	new /datum/data/mining_equipment(/obj/item/tank/jetpack,									10,					400),
	new /datum/data/mining_equipment(/obj/item/device/mine_bot_upgrade,							10,					400),
	new /datum/data/mining_equipment(/obj/machinery/mining/brace,								-1,					500,	1),
	new /datum/data/mining_equipment(/obj/item/card/mining_point_card,							-1,					500),
	new /datum/data/mining_equipment(/obj/item/storage/belt/mining,								10,					500),
	new /datum/data/mining_equipment(/obj/item/warp_core,										25,					500),
	new /datum/data/mining_equipment(/obj/item/extraction_pack,									25,					600),
	new /datum/data/mining_equipment(/obj/item/device/mine_bot_upgrade/health,					20,					600),
	new /datum/data/mining_equipment(/obj/item/storage/firstaid/trauma,							30,					600),
	new /datum/data/mining_equipment(/obj/item/oremagnet,										10,					600),
	new /datum/data/mining_equipment(/obj/item/resonator,										10,					700),
	new /datum/data/mining_equipment(/obj/item/device/wormhole_jaunter,							20,					750),
	new /datum/data/mining_equipment(/obj/item/rig/industrial,									5,					1000),
	new /datum/data/mining_equipment(/obj/item/mass_driver_diy,									5,					800),
	new /datum/data/mining_equipment(/mob/living/silicon/robot/drone/mining,					15,					800),
	new /datum/data/mining_equipment(/obj/item/device/mine_bot_upgrade/ka,						10,					800),
	new /datum/data/mining_equipment(/obj/item/oreportal,										35,					800),
	new /datum/data/mining_equipment(/obj/item/device/spaceflare,								5,					800),
	new /datum/data/mining_equipment(/obj/item/lazarus_injector,								25,					1000),
	new /datum/data/mining_equipment(/obj/item/storage/backpack/cell,							5,					1000),
	new /datum/data/mining_equipment(/obj/machinery/mining/drill,								-1,					1000,	1),
	new /datum/data/mining_equipment(/obj/item/resonator/upgraded,								10,					1250),
	new /datum/data/mining_equipment(/obj/item/pickaxe/diamond,									10,					1500),
	new /datum/data/mining_equipment(/obj/item/gun/energy/vaurca/thermaldrill,					5,					1750),
	new /datum/data/mining_equipment(/obj/item/device/orbital_dropper/minecart,					5,					2000),
	new /datum/data/mining_equipment(/obj/item/device/orbital_dropper/drill,					10,					3250),
	new /datum/data/mining_equipment(/obj/item/device/orbital_dropper/mecha/miner,				2,					3500)
	))

/obj/machinery/mineral/equipment_vendor
	name = "mining equipment vendor"
	desc = "An equipment vendor for miners, points collected at an ore redemption machine can be spent here."
	icon = 'icons/obj/machinery/mining_machines.dmi'
	icon_state = "mining"
	density = TRUE
	anchored = TRUE

/datum/data/mining_equipment
	var/equipment_name = "generic"
	var/equipment_description = ""
	var/equipment_path = null
	var/amount = 0 // -1 is the special number for infinite items like things that can be ordered from the shuttle
	var/cost = 0
	var/shuttle = FALSE

/datum/data/mining_equipment/New(set_path, set_amount, set_cost, set_shuttle)
	var/atom/equipment = set_path
	equipment_name = capitalize_first_letters(initial(equipment.name))
	equipment_description = initial(equipment.desc)
	equipment_path = set_path
	amount = set_amount
	cost = set_cost
	shuttle = set_shuttle

/obj/item/circuitboard/machine/mining_equipment_vendor
	name = "circuit board (Mining Equipment Vendor)"
	build_path = /obj/machinery/mineral/equipment_vendor
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	req_components = list(	/obj/item/stock_parts/console_screen = 1,
							/obj/item/stock_parts/matter_bin = 3)

/obj/machinery/mineral/equipment_vendor/power_change()
	..()
	update_icon()

/obj/machinery/mineral/equipment_vendor/update_icon()
	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"
	return

/obj/machinery/mineral/equipment_vendor/attack_hand(mob/user)
	if(..())
		return
	ui_interact(user)

/obj/machinery/mineral/equipment_vendor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MiningVendor", "Mining Equipment Vendor", ui_x=500, ui_y=500)
		ui.autoupdate = FALSE
		ui.open()

/obj/machinery/mineral/equipment_vendor/ui_data(mob/user)
	var/list/data = list()
	var/obj/item/card/id/ID = user.GetIdCard()
	if(ID)
		data["hasId"] = TRUE
		data["miningPoints"] = ID.mining_points ? ID.mining_points : 0
	else
		data["hasId"] = FALSE
	var/list/prize_list = list()
	for(var/datum/data/mining_equipment/prize as anything in GLOB.minevendor_list)
		prize_list += list(list("name" = prize.equipment_name, "desc" = prize.equipment_description, "cost" = prize.cost, "stock" = prize.amount, "ref" = "[REF(prize)]"))
	data["prizeList"] = prize_list
	return data

/obj/machinery/mineral/equipment_vendor/ui_act(action, params)
	. = ..()
	if(.)
		return

	if(action == "purchase")
		var/obj/item/card/id/ID = usr.GetIdCard()
		if(ID)
			var/datum/data/mining_equipment/prize = locate(params["purchase"])
			if(!prize || !(prize in GLOB.minevendor_list))
				return
			if(prize.amount <= 0 && prize.amount != -1)
				return
			if(prize.cost <= ID.mining_points)
				if(prize.shuttle)
					if(SScargo.order_mining(prize.equipment_path))
						ID.mining_points -= prize.cost
						to_chat(usr, SPAN_NOTICE("Order passed. Your order has been placed on the next available supply shuttle."))
					else
						to_chat(usr, SPAN_DANGER("{ERR Code: NO_SHUTTLE_SPACE} Order failed! Please try again."))
				else
					ID.mining_points -= prize.cost
					if(prize.amount != -1)
						prize.amount--
					new prize.equipment_path(get_turf(src))
					intent_message(MACHINE_SOUND)
		return TRUE

/obj/machinery/mineral/equipment_vendor/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/coin/mining))
		var/list/equipment_choices = list(
			"Kinetic Accelerator Kit" = /obj/item/storage/toolbox/ka,
			"Industrial Drilling Kit" = /obj/item/storage/toolbox/drill,
			"Autonomous Mining Drone" = /mob/living/silicon/robot/drone/mining
		)
		var/choice = input(user, "Which special equipment would you like to dispense from \the [src]?", capitalize_first_letters(name)) as null|anything in equipment_choices
		if(!choice || QDELETED(attacking_item) || !Adjacent(user))
			return
		var/equipment_path = equipment_choices[choice]
		var/obj/dispensed_equipment = new equipment_path(get_turf(src))
		if(dispensed_equipment)
			to_chat(user, SPAN_NOTICE("\The [src] accepts your coin and dispenses \a [dispensed_equipment]."))
			qdel(attacking_item)
			if(dispensed_equipment && isobj(dispensed_equipment))
				user.put_in_hands(dispensed_equipment)
		return
	if(default_deconstruction_screwdriver(user, "mining-open", "mining", attacking_item))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(attacking_item))
		return
	return ..()
