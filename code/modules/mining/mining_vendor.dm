//PROGRESSION SYSTEM: Miners start with a basic ass manual pickaxe. They can shortly buy an autodrill, or save up for a /TG/ Kinetic Accelerator.
//HARDSUITS: Miners all start with an *empty* industrial hardsuit. Many of the items they can buy here (auto-drill, kinetic accelerator) can be converted into modules
//			with a special machine.
//VENDOR: Obj/item's are immediately dispensed by the vendor. Machines, structures, vehicles, and etc get spawned on the cargo shuttle.
//Think up of lots of items. Not everything needs to be unique or even mining-special, but it should be neat. Convert most of /tg/'s items. 25% of this at least
//	should be bling. Things that shorten the distance between base and mining. Instant-teleporters should be one use.


/obj/machinery/mineral/equipment_vendor
	name = "mining equipment vendor"
	desc = "An equipment vendor for miners, points collected at an ore redemption machine can be spent here."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "mining"
	density = 1
	anchored = 1
	var/obj/item/weapon/card/id/inserted_id
	var/datum/shuttle/ferry/supply/shuttle
	var/list/prize_list = list( //keep in order of price
		new /datum/data/mining_equipment("Food Ration",			/obj/item/weapon/reagent_containers/food/snacks/liquidfood,				10),
		new /datum/data/mining_equipment("Poster",				/obj/item/weapon/contraband/poster,										25),
		new /datum/data/mining_equipment("Stimpack",			/obj/item/weapon/reagent_containers/hypospray/autoinjector/stimpack,	75),
		new /datum/data/mining_equipment("100 credits",			/obj/item/weapon/spacecash/c100,										100),
		new /datum/data/mining_equipment("Premium Cigar",		/obj/item/clothing/mask/smokable/cigarette/cigar/havana,							150),
		new /datum/data/mining_equipment("Material Scanners",	/obj/item/clothing/glasses/material,									200),
		new /datum/data/mining_equipment("Deep Ore Scanner",	/obj/item/weapon/mining_scanner,										250),
		new /datum/data/mining_equipment("Mining Drill",		/obj/item/weapon/pickaxe/drill,											300),
		new /datum/data/mining_equipment("Stimpack Bundle",		/obj/item/weapon/storage/box/autoinjectors/stims,						300),
		//new /datum/data/mining_equipment("Fulton Beacon",		/obj/item/fulton_core,													400),
		new /datum/data/mining_equipment("Explorer's Webbing",	/obj/item/weapon/storage/belt/mining,									500),
		new /datum/data/mining_equipment("Survival Autoinjector",/obj/item/weapon/reagent_containers/hypospray/autoinjector/survival,	600),
		new /datum/data/mining_equipment("Brute First-Aid Kit",	/obj/item/weapon/storage/firstaid/brute,								600),
		new /datum/data/mining_equipment("Jaunter",				/obj/item/device/wormhole_jaunter,										750),
		//new /datum/data/mining_equipment("Kinetic Accelerator",	/obj/item/weapon/gun/energy/kinetic_accelerator,						750),
		//new /datum/data/mining_equipment("Resonator",			/obj/item/weapon/resonator,												800),
		//new /datum/data/mining_equipment("Fulton Pack",			/obj/item/weapon/extraction_pack,										1000),
		new /datum/data/mining_equipment("Lazarus Injector",	/obj/item/weapon/lazarus_injector,										1000),
		new /datum/data/mining_equipment("Gold Pickaxe",		/obj/item/weapon/pickaxe/gold,											1000),
		new /datum/data/mining_equipment("Jetpack",				/obj/item/weapon/tank/jetpack,											1000),
		new /datum/data/mining_equipment("Space Cash",			/obj/item/weapon/spacecash/c100,										2000),
		//new /datum/data/mining_equipment("Mining Hardsuit",		/obj/item/clothing/suit/space/hardsuit/mining,							2000),
		new /datum/data/mining_equipment("Diamond Pickaxe",		/obj/item/weapon/pickaxe/diamond,										2000),
		//new /datum/data/mining_equipment("Super Resonator",		/obj/item/weapon/resonator/upgraded,									2500),
		//new /datum/data/mining_equipment("KA White Tracer Rounds",	/obj/item/borg/upgrade/modkit/tracer,								100),
		//new /datum/data/mining_equipment("KA Adjustable Tracer Rounds",	/obj/item/borg/upgrade/modkit/tracer/adjustable,				150),
		//new /datum/data/mining_equipment("KA Super Chassis",	/obj/item/borg/upgrade/modkit/chassis_mod,								250),
		//new /datum/data/mining_equipment("KA Hyper Chassis",	/obj/item/borg/upgrade/modkit/chassis_mod/orange,						300),
		//new /datum/data/mining_equipment("KA Range Increase",	/obj/item/borg/upgrade/modkit/range,									1000),
		//new /datum/data/mining_equipment("KA Damage Increase",	/obj/item/borg/upgrade/modkit/damage,									1000),
		//new /datum/data/mining_equipment("KA Cooldown Decrease",/obj/item/borg/upgrade/modkit/cooldown,									1000),
		//new /datum/data/mining_equipment("KA AoE Damage",		/obj/item/borg/upgrade/modkit/aoe/mobs,									2000),
		//new /datum/data/mining_equipment("Point Transfer Card",	/obj/item/weapon/card/mining_point_card,								500),
		//new /datum/data/mining_equipment("Mining Drone",		/mob/living/simple_animal/hostile/mining_drone,							800),
		//new /datum/data/mining_equipment("Drone Melee Upgrade",	/obj/item/device/mine_bot_ugprade,										400),
		//new /datum/data/mining_equipment("Drone Health Upgrade",/obj/item/device/mine_bot_ugprade/health,								400),
		//new /datum/data/mining_equipment("Drone Ranged Upgrade",/obj/item/device/mine_bot_ugprade/cooldown,								600),
		//new /datum/data/mining_equipment("Drone AI Upgrade",	/obj/item/slimepotion/sentience/mining,									1000),
		//new /datum/data/mining_equipment("Jump Boots",			/obj/item/clothing/shoes/bhop,											2500),
		)

/datum/data/mining_equipment
	var/equipment_name = "generic"
	var/equipment_path = null
	var/cost = 0
	var/shuttle

/datum/data/mining_equipment/New(name, path, cost, shuttle)
	src.equipment_name = name
	src.equipment_path = path
	src.cost = cost
	src.shuttle = shuttle

/obj/item/weapon/circuitboard/machine/mining_equipment_vendor
	name = "circuit board (Mining Equipment Vendor)"
	build_path = /obj/machinery/mineral/equipment_vendor
	origin_tech = "programming=1;engineering=3"
	req_components = list(
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/matter_bin = 3)

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
	for(var/datum/data/mining_equipment/prize in prize_list)
		dat += "<tr><td>[prize.equipment_name]</td><td>[prize.cost]</td><td><A href='?src=\ref[src];purchase=\ref[prize]'>Purchase</A></td></tr>"
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
				inserted_id.loc = loc
				if(!usr.get_active_hand())
					usr.put_in_hands(inserted_id)
				inserted_id = null
		else if(href_list["choice"] == "insert")
			var/obj/item/weapon/card/id/I = usr.get_active_hand()
			if(istype(I))
				usr.drop_item()
				I.loc = src
				inserted_id = I
			else usr << "<span class='danger'>No valid ID.</span>"
	if(href_list["purchase"])
		if(istype(inserted_id))
			var/datum/data/mining_equipment/prize = locate(href_list["purchase"])
			if (!prize || !(prize in prize_list))
				return
			if(prize.cost > inserted_id.mining_points)
			else
				if(prize.shuttle)
					var/area/area_shuttle = shuttle.get_location_area()
					if(!area_shuttle)
						usr << "<span class='danger'>{ERR Code: NO_SHUTTLE} Order failed! Please try again.</span>"
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
						usr << "<span class='danger'>{ERR Code: NO_SHUTTLE_SPACE} Order failed! Please try again.</span>"
						return

					var/i = rand(1,clear_turfs.len)
					var/turf/pickedloc = clear_turfs[i]

					if(pickedloc)
						inserted_id.mining_points -= prize.cost
						new prize.equipment_path(pickedloc)
					else
						usr << "<span class='danger'>{ERR Code: NO_SHUTTLE_SPACE} Order failed! Please try again.</span>"
						return
				else
					inserted_id.mining_points -= prize.cost
					new prize.equipment_path(src.loc)

	updateUsrDialog()
	return

/obj/machinery/mineral/equipment_vendor/attackby(obj/item/I, mob/user, params)
	if(istype(I,/obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/C = usr.get_active_hand()
		if(istype(C) && !istype(inserted_id))
			if(!usr.drop_item())
				return
			C.loc = src
			inserted_id = C
			interact(user)
		return
	if(default_deconstruction_screwdriver(user, "mining-open", "mining", I))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(I))
		return
	return ..()
