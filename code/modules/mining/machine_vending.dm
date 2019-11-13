//PROGRESSION SYSTEM: Miners start with a basic ass manual pickaxe. They can shortly buy an autodrill, or save up for a /TG/ Kinetic Accelerator.
//HARDSUITS: Miners all start with an *empty* industrial hardsuit. Many of the items they can buy here (auto-drill, kinetic accelerator) can be converted into modules
//			with a special machine.
//VENDOR: Obj/item's are immediately dispensed by the vendor. Machines, structures, vehicles, and etc get spawned on the cargo shuttle.
//Think up of lots of items. Not everything needs to be unique or even mining-special, but it should be neat. Convert most of /tg/'s items. 25% of this at least
//	should be bling. Things that shorten the distance between base and mining. Instant-teleporters should be one use.
var/global/list/minevendor_list = list( //keep in order of price
	new /datum/data/mining_equipment("Food Ration",					/obj/item/reagent_containers/food/snacks/liquidfood,	10,					5),
	new /datum/data/mining_equipment("Poster",						/obj/item/contraband/poster,							10,					20),
	new /datum/data/mining_equipment("Ore Scanner Pad",				/obj/item/ore_radar,									10,					50),
	new /datum/data/mining_equipment("5 Red Flags",					/obj/item/stack/flag/red,									10,					50),
	new /datum/data/mining_equipment("5 Green Flags",				/obj/item/stack/flag/green,									10,					50),
	new /datum/data/mining_equipment("5 Yellow Flags",				/obj/item/stack/flag/yellow,								10,					50),
	new /datum/data/mining_equipment("5 Purple Flags",				/obj/item/stack/flag/purple,								10,					50),
	new /datum/data/mining_equipment("Ore-bag",						/obj/item/storage/bag/ore,							25,					50),
	new /datum/data/mining_equipment("Meat Pizza",					/obj/item/pizzabox/meat,									25,					50),
	new /datum/data/mining_equipment("Lantern",						/obj/item/device/flashlight/lantern,						10,					75),
	new /datum/data/mining_equipment("Shovel",						/obj/item/shovel,									15,					100),
	new /datum/data/mining_equipment("Pickaxe",						/obj/item/pickaxe,									10,					100),
	new /datum/data/mining_equipment("Compressed matter cartridge",	/obj/item/rfd_ammo,									50,					100),
	new /datum/data/mining_equipment("Class E Kinetic Accelerator",	/obj/item/gun/custom_ka/frame01/prebuilt,			12,					200),
	new /datum/data/mining_equipment("Ore Box",						/obj/structure/ore_box,										-1,					150,	1),
	new /datum/data/mining_equipment("Emergency Floodlight",		/obj/item/floodlight_diy, 							-1,					150,	1),
	new /datum/data/mining_equipment("Premium Cigar",				/obj/item/clothing/mask/smokable/cigarette/cigar/havana, 	30,					150),
	new /datum/data/mining_equipment("Seismic Charge",				/obj/item/plastique/seismic,							25,					150),
	new /datum/data/mining_equipment("Deployable Ladder",			/obj/item/ladder_mobile,								5,					200),
	new /datum/data/mining_equipment("Deployable Hoist Kit",		/obj/item/hoist_kit,										5,					200),
	new /datum/data/mining_equipment("Ripley Paint Kit",			/obj/item/device/kit/paint/ripley/random,					15,					200),
	new /datum/data/mining_equipment("Material Scanners",			/obj/item/clothing/glasses/material,						15,					200),
	new /datum/data/mining_equipment("Mining Drill",				/obj/item/pickaxe/drill,								10,					200),
	new /datum/data/mining_equipment("Deep Ore Scanner",			/obj/item/mining_scanner,							10,					250),
	new /datum/data/mining_equipment("Magboots",					/obj/item/clothing/shoes/magboots,							10,					300),
	new /datum/data/mining_equipment("Class D Kinetic Accelerator", /obj/item/gun/custom_ka/frame02/prebuilt,			12,					400),
	new /datum/data/mining_equipment("Autochisel",					/obj/item/autochisel,								10,					400),
	new /datum/data/mining_equipment("Jetpack",						/obj/item/tank/jetpack,								10,					400),
	new /datum/data/mining_equipment("Drone Drill Upgrade",			/obj/item/device/mine_bot_ugprade,							10,					400),
	new /datum/data/mining_equipment("Industrial Drill Brace",		/obj/machinery/mining/brace,								-1,					500,	1),
	new /datum/data/mining_equipment("Point Transfer Card",			/obj/item/card/mining_point_card,					-1,					500),
	new /datum/data/mining_equipment("Explorer's Belt",				/obj/item/storage/belt/mining,						10,					500),
	new /datum/data/mining_equipment("Item-Warp Beacon",			/obj/item/warp_core,										25,					500),
	new /datum/data/mining_equipment("Item-Warp Pack",				/obj/item/extraction_pack,							25,					600),
	new /datum/data/mining_equipment("Drone Health Upgrade", 		/obj/item/device/mine_bot_ugprade/health,					20,					600),
	new /datum/data/mining_equipment("RFD M-Class",             	/obj/item/rfd/mining,								10,					600),
	new /datum/data/mining_equipment("Brute First-Aid Kit",			/obj/item/storage/firstaid/brute,					30,					600),
	new /datum/data/mining_equipment("Ore Magnet",					/obj/item/oremagnet,									10,					600),
	new /datum/data/mining_equipment("Minecart",					/obj/vehicle/train/cargo/trolley/mining,					-1,					600,	1),
	new /datum/data/mining_equipment("Resonator",					/obj/item/resonator,									10,					700),
	new /datum/data/mining_equipment("Jaunter",						/obj/item/device/wormhole_jaunter,							20,					750),
	new /datum/data/mining_equipment("Mining RIG",					/obj/item/rig/industrial,							5,					1000),
	new /datum/data/mining_equipment("Mass Driver",					/obj/item/mass_driver_diy,							5,					800),
	new /datum/data/mining_equipment("Mining Drone",				/mob/living/silicon/robot/drone/mining,						15,					800),
	new /datum/data/mining_equipment("Minecart Engine",				/obj/vehicle/train/cargo/engine/mining,						-1,					800,	1),
	new /datum/data/mining_equipment("Drone KA Upgrade",			/obj/item/device/mine_bot_ugprade/ka,						10,					800),
	new /datum/data/mining_equipment("Ore Summoner",				/obj/item/oreportal,									35,					800),
	new /datum/data/mining_equipment("Lazarus Injector",			/obj/item/lazarus_injector,							25,					1000),
	new /datum/data/mining_equipment("Industrial Drill Head",		/obj/machinery/mining/drill,								-1,					1000,	1),
	new /datum/data/mining_equipment("Super Resonator",				/obj/item/resonator/upgraded,						10,					1250),
	new /datum/data/mining_equipment("Diamond Pickaxe",				/obj/item/pickaxe/diamond,							10,					1500),
	new /datum/data/mining_equipment("Thermal Drill",				/obj/item/gun/energy/vaurca/thermaldrill,			5,					3750)
	)

/obj/machinery/mineral/equipment_vendor
	name = "mining equipment vendor"
	desc = "An equipment vendor for miners, points collected at an ore redemption machine can be spent here."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "mining"
	density = 1
	anchored = 1
	var/obj/item/card/id/inserted_id

/datum/data/mining_equipment
	var/equipment_name = "generic"
	var/equipment_path = null
	var/amount = 0 // -1 is the special number for infinite items like things that can be ordered from the shuttle
	var/cost = 0
	var/shuttle

/datum/data/mining_equipment/New(name, path, amount, cost, shuttle)
	src.equipment_name = name
	src.equipment_path = path
	src.amount = amount
	src.cost = cost
	src.shuttle = shuttle

/obj/item/circuitboard/machine/mining_equipment_vendor
	name = "circuit board (Mining Equipment Vendor)"
	build_path = /obj/machinery/mineral/equipment_vendor
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	req_components = list(
							/obj/item/stock_parts/console_screen = 1,
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
	interact(user)

/obj/machinery/mineral/equipment_vendor/interact(mob/user)
	var/dat
	dat +="<div class='statusDisplay'>"
	if(istype(inserted_id))
		dat += "You have [inserted_id.mining_points] mining points collected. <A href='?src=\ref[src];choice=eject'>Eject ID.</A><br>"
	else
		dat += "No ID inserted.  <A href='?src=\ref[src];choice=insert'>Insert ID.</A><br>"
	dat += "</div>"
	dat += "<br><b>Equipment point cost list:</b><BR><table border='0' width='300'>"
	for(var/datum/data/mining_equipment/prize in minevendor_list)
		if(prize.amount > 0)
			dat += "<tr><td>[prize.equipment_name]</td><td>[prize.cost]</td><td><A href='?src=\ref[src];purchase=\ref[prize]'>Purchase</A> ([prize.amount])</td></tr>"
		else if(prize.amount == -1)
			dat += "<tr><td>[prize.equipment_name]</td><td>[prize.cost]</td><td><A href='?src=\ref[src];purchase=\ref[prize]'>Purchase</A> (No limit.)</td></tr>"
		else
			dat += "<tr><td>[prize.equipment_name]</td><td>(Out of stock!)</td></tr>"
	dat += "</table>"

	var/datum/browser/popup = new(user, "miningvendor", "Mining Equipment Vendor", 400, 350)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/mineral/equipment_vendor/Topic(href, href_list)
	if(..())
		return
	if(href_list["choice"])
		if(istype(inserted_id))
			if(href_list["choice"] == "eject")
				inserted_id.forceMove(loc)
				if(ishuman(usr))
					if(!usr.get_active_hand())
						usr.put_in_hands(inserted_id)
				else
					inserted_id.forceMove(get_turf(src))
				inserted_id = null
		else if(href_list["choice"] == "insert")
			var/obj/item/card/id/I = usr.get_active_hand()
			if(istype(I))
				usr.drop_from_inventory(I,src)
				inserted_id = I
			else to_chat(usr, "<span class='danger'>No valid ID.</span>")
	if(href_list["purchase"])
		if(istype(inserted_id))
			var/datum/data/mining_equipment/prize = locate(href_list["purchase"])
			if (!prize || !(prize in minevendor_list))
				return
			if(prize.amount <= 0 && prize.amount != -1)
				return
			if(prize.cost > inserted_id.mining_points)
			else
				if(prize.shuttle)
					var/datum/shuttle/ferry/supply/shuttle = SScargo.shuttle
					if(shuttle)
						var/area/area_shuttle = shuttle.get_location_area()
						if(!area_shuttle)
							to_chat(usr, "<span class='danger'>{ERR Code: NO_SHUTTLE} Order failed! Please try again.</span>")
							return


						var/list/clear_turfs = list()

						for(var/turf/T in area_shuttle)
							if(T.density)	continue
							var/contcount
							for(var/atom/A in T.contents)
								if(!A.simulated)
									continue
								contcount++
							if(contcount)
								continue
							clear_turfs += T

						if(!clear_turfs.len)
							to_chat(usr, "<span class='danger'>{ERR Code: NO_SHUTTLE_SPACE} Order failed! Please try again.</span>")
							return

						var/i = rand(1,clear_turfs.len)
						var/turf/pickedloc = clear_turfs[i]

						if(pickedloc)
							inserted_id.mining_points -= prize.cost
							new prize.equipment_path(pickedloc)
							to_chat(usr, "<span class='danger'>Order passed. Your order has been placed on the next available supply shuttle.</span>")
						else
							to_chat(usr, "<span class='danger'>{ERR Code: NO_SHUTTLE_SPACE} Order failed! Please try again.</span>")
							return
					else
						to_chat(usr, "<span class='danger'>{ERR Code: NO_SHUTTLE} Order failed! Please try again.</span>")
						return
				else
					inserted_id.mining_points -= prize.cost
					if(prize.amount != -1)
						prize.amount--
					new prize.equipment_path(src.loc)

	updateUsrDialog()
	return

/obj/machinery/mineral/equipment_vendor/attackby(obj/item/I, mob/user, params)
	if(istype(I,/obj/item/card/id))
		var/obj/item/card/id/C = usr.get_active_hand()
		if(istype(C) && !istype(inserted_id))
			usr.drop_from_inventory(C,src)
			inserted_id = C
			interact(user)
		return
	if(default_deconstruction_screwdriver(user, "mining-open", "mining", I))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(I))
		return
	return ..()
