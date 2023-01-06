/material/proc/get_recipes()
	if(!recipes)
		generate_recipes()
	return recipes

/material/proc/generate_recipes()
	recipes = list()

	// If is_brittle() returns true, these are only good for a single strike.
	recipes += new /datum/stack_recipe_list("generic crafts",
		list(
			new /datum/stack_recipe("[display_name] baseball bat", /obj/item/material/twohanded/baseballbat, 10, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]"),
			new /datum/stack_recipe("[display_name] sword hilt", /obj/item/material/sword_hilt, 10, time = 100, one_per_turf = 0, on_floor = 1, supplied_material = "[name]"),
			new /datum/stack_recipe("[display_name] sword blade", /obj/item/material/sword_blade, 15, time = 100, one_per_turf = 0, on_floor = 1, supplied_material = "[name]"),
			new /datum/stack_recipe("[display_name] ring", /obj/item/clothing/ring/material, 1, on_floor = 1, supplied_material = "[name]"),
			new /datum/stack_recipe("[display_name] armor plating", /obj/item/material/armor_plating, 3, time = 20, on_floor = 1, supplied_material = "[name]")
		))

	if(integrity >= 50)
		recipes += new /datum/stack_recipe_list("generic construction",
		list(
			new /datum/stack_recipe("[display_name] door", /obj/structure/simple_door, BUILD_AMT, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"),
			new /datum/stack_recipe("[display_name] blocker", /obj/structure/blocker, BUILD_AMT, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"),
			new /datum/stack_recipe("[display_name] railing", /obj/structure/railing, BUILD_AMT, time = 25, one_per_turf = FALSE, on_floor = TRUE, supplied_material = "[name]"),
			new /datum/stack_recipe("[display_name] stool", /obj/structure/bed/stool, BUILD_AMT, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"),
			new /datum/stack_recipe("[display_name] chair", /obj/structure/bed/stool/chair, BUILD_AMT, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"),
			new /datum/stack_recipe("[display_name] bed", /obj/structure/bed, BUILD_AMT, one_per_turf = 1, on_floor = 1, supplied_material = "[name]"),
			new /datum/stack_recipe("[display_name] lock", /obj/item/material/lock_construct, 1, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]"),
			new /datum/stack_recipe("[display_name] urn", /obj/item/material/urn, 10, time = 30, one_per_turf = FALSE, on_floor = 1, supplied_material = "[name]")
		))

	var/list/hardness_craftables = list()
	if(hardness >= 10)
		hardness_craftables += new /datum/stack_recipe("[display_name] ashtray", /obj/item/material/ashtray, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")

	if(hardness > 50)
		hardness_craftables += new /datum/stack_recipe("[display_name] fork", /obj/item/material/kitchen/utensil/fork/plastic, 1, on_floor = 1, supplied_material = "[name]")
		hardness_craftables += new /datum/stack_recipe("[display_name] spoon", /obj/item/material/kitchen/utensil/spoon/plastic, 1, on_floor = 1, supplied_material = "[name]")
		hardness_craftables += new /datum/stack_recipe("[display_name] knife", /obj/item/material/kitchen/utensil/knife/plastic, 1, on_floor = 1, supplied_material = "[name]")
		hardness_craftables += new /datum/stack_recipe("[display_name] blade", /obj/item/material/butterflyblade, 6, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]")
		hardness_craftables += new /datum/stack_recipe("[display_name] spearhead", /obj/item/material/spearhead, 6, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]")
		hardness_craftables += new /datum/stack_recipe("[display_name] drill head", /obj/item/material/drill_head, 6, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]")

	if(length(hardness_craftables))
		recipes += new /datum/stack_recipe_list("generic miscellaneous", hardness_craftables)

/material/steel/generate_recipes()
	..()
	recipes += new /datum/stack_recipe_list("construction recipes",
		list(
			new /datum/stack_recipe("regular floor tile", /obj/item/stack/tile/floor, 1, 4, 20),
			new /datum/stack_recipe("full regular floor tile", /obj/item/stack/tile/floor/full, 1, 4, 20),
			new /datum/stack_recipe("metal rod", /obj/item/stack/rods, 1, 2, 60),
			new /datum/stack_recipe("steel barricade", /obj/structure/barricade/metal, BUILD_AMT, time = 10 SECONDS, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("barbed wire", /obj/item/stack/barbed_wire, 1, 2, 20),
			new /datum/stack_recipe("table frame", /obj/structure/table, BUILD_AMT, time = 10, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("wall girders", /obj/structure/girder, BUILD_AMT, time = 50, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("steel window frame", /obj/structure/window_frame/unanchored, BUILD_AMT, time = 25, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("computer frame", /obj/structure/computerframe, BUILD_AMT, time = 25, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("machine blueprint", /obj/machinery/constructable_frame/machine_frame, 2, time = 25, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("light fixture frame", /obj/item/frame/light, 2),
			new /datum/stack_recipe("small light fixture frame", /obj/item/frame/light/small, 1),
			new /datum/stack_recipe("apc frame", /obj/item/frame/apc, 2),
			new /datum/stack_recipe("air alarm frame", /obj/item/frame/air_alarm, 2),
			new /datum/stack_recipe("fire alarm frame", /obj/item/frame/fire_alarm, 2)
		))

	recipes += new /datum/stack_recipe_list("miscellaneous construction",
		list(
			new /datum/stack_recipe("key", /obj/item/key, 1, time = 10, one_per_turf = 0, on_floor = 1),
			new /datum/stack_recipe("custodial cart", /obj/structure/janitorialcart, BUILD_AMT, time = 120, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("steel closet", /obj/structure/closet, BUILD_AMT, time = 15, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("canister", /obj/machinery/portable_atmospherics/canister, 10, time = 15, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("target stake", /obj/structure/target_stake, BUILD_AMT, time = 15, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("shooting target", /obj/item/target, 5, time = 10, one_per_turf = 0, on_floor = 1),
			new /datum/stack_recipe("dark office chair", /obj/structure/bed/stool/chair/office/dark, BUILD_AMT, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("light office chair", /obj/structure/bed/stool/chair/office/light, BUILD_AMT, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("plain padded chair", /obj/structure/bed/stool/chair/padded, BUILD_AMT, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("sofa (middle)", /obj/structure/bed/stool/chair/sofa, BUILD_AMT, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("sofa (left)", /obj/structure/bed/stool/chair/sofa/left, BUILD_AMT, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("sofa (right)", /obj/structure/bed/stool/chair/sofa/right, BUILD_AMT, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("sofa (corner)", /obj/structure/bed/stool/chair/sofa/corner, BUILD_AMT, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("steel crate", /obj/structure/closet/crate, BUILD_AMT, time = 50, one_per_turf = 1)
		))

	recipes += new /datum/stack_recipe_list("airlock assemblies",
		list(
			new /datum/stack_recipe("standard airlock assembly", /obj/structure/door_assembly, BUILD_AMT, time = 50, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("service airlock assembly", /obj/structure/door_assembly/door_assembly_ser, BUILD_AMT, time = 50, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("command airlock assembly", /obj/structure/door_assembly/door_assembly_com, BUILD_AMT, time = 50, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("security airlock assembly", /obj/structure/door_assembly/door_assembly_sec, BUILD_AMT, time = 50, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("engineering airlock assembly", /obj/structure/door_assembly/door_assembly_eng, BUILD_AMT, time = 50, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("mining airlock assembly", /obj/structure/door_assembly/door_assembly_min, BUILD_AMT, time = 50, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("atmospherics airlock assembly", /obj/structure/door_assembly/door_assembly_atmo, BUILD_AMT, time = 50, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("research airlock assembly", /obj/structure/door_assembly/door_assembly_research, BUILD_AMT, time = 50, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("medical airlock assembly", /obj/structure/door_assembly/door_assembly_med, BUILD_AMT, time = 50, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("maintenance airlock assembly", /obj/structure/door_assembly/door_assembly_mai, BUILD_AMT, time = 50, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("external airlock assembly", /obj/structure/door_assembly/door_assembly_ext, BUILD_AMT, time = 50, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("freezer airlock assembly", /obj/structure/door_assembly/door_assembly_fre, BUILD_AMT, time = 50, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("airtight hatch assembly", /obj/structure/door_assembly/door_assembly_hatch, BUILD_AMT, time = 50, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("maintenance hatch assembly", /obj/structure/door_assembly/door_assembly_mhatch, BUILD_AMT, time = 50, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("high security airlock assembly", /obj/structure/door_assembly/door_assembly_highsecurity, BUILD_AMT, time = 50, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("vault assembly", /obj/structure/door_assembly/door_assembly_vault, BUILD_AMT, time = 100, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("emergency shutter", /obj/structure/firedoor_assembly, BUILD_AMT, time = 50, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("multi-tile airlock assembly", /obj/structure/door_assembly/multi_tile, BUILD_AMT, time = 50, one_per_turf = 1, on_floor = 1)
		))

	recipes += new /datum/stack_recipe_list("turret frames",
		list(
			new /datum/stack_recipe("light turret frame", /obj/machinery/porta_turret_construct, 5, time = 25, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("dark turret frame", /obj/machinery/porta_turret_construct/dark, 5, time = 25, one_per_turf = 1, on_floor = 1)
		))

	recipes += new /datum/stack_recipe_list("modular computers",
		list(
			new /datum/stack_recipe("modular console frame", /obj/item/modular_computer/console, 20, time = 25, one_per_turf = TRUE),
			new /datum/stack_recipe("modular laptop frame", /obj/item/modular_computer/laptop, 10, time = 25),
			new /datum/stack_recipe("modular tablet frame", /obj/item/modular_computer/handheld, 5, time = 25)
		))

	recipes += new /datum/stack_recipe_list("[display_name] weaponry",
		list(
			new /datum/stack_recipe("makeshift magazine (5.56mm)", /obj/item/ammo_magazine/a556/makeshift/empty, 5, time = 20),
			new /datum/stack_recipe("grenade casing", /obj/item/grenade/chem_grenade),
			new /datum/stack_recipe("firearm receiver", /obj/item/receivergun, 15, time = 25, one_per_turf = 0, on_floor = 0),
			new /datum/stack_recipe("shield fittings", /obj/item/material/shieldbits, 10, time = 25),
			new /datum/stack_recipe("cannon frame", /obj/item/cannonframe, 10, time = 15, one_per_turf = 0, on_floor = 0),
			new /datum/stack_recipe("large trap foundation", /obj/item/large_trap_foundation, 4, time = 40)
		))

/material/plasteel/generate_recipes()
	..()
	recipes += new /datum/stack_recipe_list("[display_name] recipes",
		list(
			new /datum/stack_recipe("AI core", /obj/structure/AIcore, BUILD_AMT, time = 50, one_per_turf = 1),
			new /datum/stack_recipe("plateel barricade", /obj/structure/barricade/plasteel, BUILD_AMT, time = 12 SECONDS, one_per_turf = 1),
			new /datum/stack_recipe("knife grip", /obj/item/material/butterflyhandle, 4, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]"),
			new /datum/stack_recipe("dark floor tile", /obj/item/stack/tile/floor_dark, 1, 4, 20),
			new /datum/stack_recipe("full dark floor tile", /obj/item/stack/tile/floor_dark/full, 1, 4, 20)
		))

/material/plastic/generate_recipes()
	..()
	recipes += new /datum/stack_recipe_list("[display_name] recipes",
		list(
			new /datum/stack_recipe("plastic rack", /obj/structure/table/rack, BUILD_AMT, time = 5, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("plastic crate", /obj/structure/closet/crate/plastic, BUILD_AMT, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("plastic bag", /obj/item/storage/bag/plasticbag, 3, on_floor = 1),
			new /datum/stack_recipe("blood pack", /obj/item/reagent_containers/blood/empty, 4, on_floor = 0),
			new /datum/stack_recipe("reagent dispenser cartridge (large)", /obj/item/reagent_containers/chem_disp_cartridge,        5, on_floor=0), // 500u
			new /datum/stack_recipe("reagent dispenser cartridge (med)",   /obj/item/reagent_containers/chem_disp_cartridge/medium, 3, on_floor=0), // 250u
			new /datum/stack_recipe("reagent dispenser cartridge (small)", /obj/item/reagent_containers/chem_disp_cartridge/small,  1, on_floor=0), // 100u
			new /datum/stack_recipe("white floor tile", /obj/item/stack/tile/floor_white, 1, 4, 20),
			new /datum/stack_recipe("freezer floor tile", /obj/item/stack/tile/floor_freezer, 1, 4, 20),
			new /datum/stack_recipe("plastic flaps", /obj/structure/plasticflaps, BUILD_AMT, 1, 1)
		))

/material/wood/generate_recipes()
	..()
	recipes += new /datum/stack_recipe_list("[display_name] recipes",
		list(
			new /datum/stack_recipe("wooden barricade", /obj/structure/barricade/wooden, BUILD_AMT, time = 5 SECONDS, one_per_turf = TRUE, on_floor = TRUE),
			new /datum/stack_recipe("wooden sandals", /obj/item/clothing/shoes/sandal, 1),
			new /datum/stack_recipe("wood circlet", /obj/item/woodcirclet, 1),
			new /datum/stack_recipe("wood floor tile", /obj/item/stack/tile/wood, 1, 4, 20),
			new /datum/stack_recipe("wooden chair", /obj/structure/bed/stool/chair/wood, BUILD_AMT, time = 10, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("crossbow frame", /obj/item/crossbowframe, 5, time = 25, one_per_turf = 0, on_floor = 0),
			new /datum/stack_recipe("coffin", /obj/structure/closet/crate/coffin, BUILD_AMT, time = 15, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("rifle stock", /obj/item/stock, 10, time = 25, one_per_turf = 0, on_floor = 0),
			new /datum/stack_recipe("beehive assembly", /obj/item/beehive_assembly, 4),
			new /datum/stack_recipe("beehive frame", /obj/item/honey_frame, 1),
			new /datum/stack_recipe("book shelf", /obj/structure/bookcase, BUILD_AMT, time = 15, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("ore box", /obj/structure/ore_box, BUILD_AMT, time = 15, one_per_turf = 1, on_floor = 1),
			new /datum/stack_recipe("wooden bucket", /obj/item/reagent_containers/glass/bucket/wood, 2, time = 4, one_per_turf = 0, on_floor = 0),
			new /datum/stack_recipe("shaft", /obj/item/material/shaft, 10, time = 25, one_per_turf = 0, on_floor = 0),
			new /datum/stack_recipe("buckler donut", /obj/item/material/woodenshield, 20, time = 25, one_per_turf = 0, on_floor = 0),
			new /datum/stack_recipe("torch handle", /obj/item/torch, 3, time = 5, one_per_turf = 0, on_floor = 0),
			new /datum/stack_recipe("easel", /obj/structure/easel, BUILD_AMT, time = 15, one_per_turf = 1, on_floor = 1)
		))

/material/stone/generate_recipes()
	..()
	recipes += new /datum/stack_recipe_list("[display_name] recipes",
		list(
			new /datum/stack_recipe("planting bed", /obj/machinery/portable_atmospherics/hydroponics/soil, 3, time = 10, one_per_turf = 1, on_floor = 1)
		))

/material/cardboard/generate_recipes()
	..()
	recipes += new /datum/stack_recipe_list("[display_name] recipes",
		list(
			new /datum/stack_recipe("box", /obj/item/storage/box),
			new /datum/stack_recipe("donut box", /obj/item/storage/box/fancy/donut/empty),
			new /datum/stack_recipe("egg carton", /obj/item/storage/box/fancy/egg_box),
			new /datum/stack_recipe("candle pack", /obj/item/storage/box/fancy/candle_box/empty),
			new /datum/stack_recipe("crayon box", /obj/item/storage/box/fancy/crayons/empty),
			new /datum/stack_recipe("pizza box", /obj/item/pizzabox),
			new /datum/stack_recipe("papersack", /obj/item/storage/box/papersack),
			new /datum/stack_recipe("cardborg suit", /obj/item/clothing/suit/cardborg, 3),
			new /datum/stack_recipe("cardborg helmet", /obj/item/clothing/head/cardborg)
		))
	recipes += new /datum/stack_recipe_list("[display_name] folders",
		list(
			new /datum/stack_recipe("blue folder", /obj/item/folder/blue),
			new /datum/stack_recipe("grey folder", /obj/item/folder),
			new /datum/stack_recipe("red folder", /obj/item/folder/red),
			new /datum/stack_recipe("white folder", /obj/item/folder/white),
			new /datum/stack_recipe("yellow folder", /obj/item/folder/yellow)
		))

/material/cloth/generate_recipes()
	..()
	recipes += new /datum/stack_recipe_list("[display_name] curtains",
		list(
			new /datum/stack_recipe("white curtain", /obj/structure/curtain, BUILD_AMT, time = 10),
			new /datum/stack_recipe("bed curtain", /obj/structure/curtain/open/bed, BUILD_AMT, time = 10),
			new /datum/stack_recipe("black curtain", /obj/structure/curtain/black, BUILD_AMT, time = 10),
			new /datum/stack_recipe("shower curtain", /obj/structure/curtain/open/shower, BUILD_AMT, time = 10),
			new /datum/stack_recipe("orange shower curtain", /obj/structure/curtain/open/shower/engineering, BUILD_AMT, time = 10),
			new /datum/stack_recipe("red shower curtain", /obj/structure/curtain/open/shower/security, BUILD_AMT, time = 10),
			new /datum/stack_recipe("privacy curtain", /obj/structure/curtain/open/privacy, BUILD_AMT, time = 10)
		))
	recipes += new /datum/stack_recipe_list("[display_name] canvases",
		list(
			new /datum/stack_recipe("canvas 11x11", /obj/item/canvas, 3),
			new /datum/stack_recipe("canvas 19x19", /obj/item/canvas/nineteen_nineteen, 5),
			new /datum/stack_recipe("canvas 23x19", /obj/item/canvas/twentythree_nineteen, 6),
			new /datum/stack_recipe("canvas 23x23", /obj/item/canvas/twentythree_twentythree, 8)
		))

/material/hide/corgi/generate_recipes()
	..()
	recipes += new /datum/stack_recipe_list("[display_name] costumes",
		list(
			new /datum/stack_recipe("corgi costume", /obj/item/clothing/suit/storage/hooded/wintercoat/corgi, 3)
		))

/material/hide/monkey/generate_recipes()
	..()
	recipes += new /datum/stack_recipe_list("[display_name] costumes",
		list(
			new /datum/stack_recipe("monkey mask", /obj/item/clothing/mask/gas/monkeymask),
			new /datum/stack_recipe("monkey suit", /obj/item/clothing/suit/monkeysuit, 2)
		))

/material/silver/generate_recipes()
	..()
	recipes += new /datum/stack_recipe_list("[display_name] construction",
		list(
			new /datum/stack_recipe("silver floor tile", /obj/item/stack/tile/silver, 1, 4, 20)
		))

/material/gold/generate_recipes()
	..()
	recipes += new /datum/stack_recipe_list("[display_name] construction",
		list(
			new /datum/stack_recipe("golden floor tile", /obj/item/stack/tile/gold, 1, 4, 20)
		))

/material/uranium/generate_recipes()
	..()
	recipes += new /datum/stack_recipe_list("[display_name] construction",
		list(
			new /datum/stack_recipe("uranium floor tile", /obj/item/stack/tile/uranium, 1, 4, 20)
		))

/material/phoron/generate_recipes()
	..()
	recipes += new /datum/stack_recipe_list("[display_name] construction",
		list(
			new /datum/stack_recipe("phoron floor tile", /obj/item/stack/tile/phoron, 1, 4, 20)
		))

/material/diamond/generate_recipes()
	..()
	recipes += new /datum/stack_recipe_list("[display_name] construction",
		list(
			new /datum/stack_recipe("diamond floor tile", /obj/item/stack/tile/diamond, 1, 4, 20)
		))

/material/stone/marble/generate_recipes()
	..()
	recipes += new /datum/stack_recipe_list("[display_name] construction",
		list(
			new /datum/stack_recipe("light marble floor tile", /obj/item/stack/tile/marble, 1, 4, 20),
			new /datum/stack_recipe("dark marble floor tile", /obj/item/stack/tile/marble/dark, 1, 4, 20)
		))

/material/leather/generate_recipes()
	..()
	recipes += new /datum/stack_recipe_list("[display_name] construction",
		list(
			new /datum/stack_recipe("leather briefcase", /obj/item/storage/briefcase/real, 4, 1, time = 20),
			new /datum/stack_recipe("leather whip", /obj/item/melee/whip, 15, 1, time = 20)
		))
