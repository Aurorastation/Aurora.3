/obj/machinery/biogenerator
	name = "Biogenerator"
	desc = ""
	icon = 'icons/obj/biogenerator.dmi'
	icon_state = "biogen-stand"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 40
	var/processing = 0
	var/obj/item/reagent_containers/glass/beaker = null
	var/points = 0
	var/menustat = "menu"
	var/build_eff = 1
	var/eat_eff = 1
	var/capacity = 50

	component_types = list(
		/obj/item/circuitboard/biogenerator,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/manipulator
	)

	var/list/biorecipies = list(
		"biogenerated" = list(
			name = "Bio Meat",
			class = "Food",
			object = /obj/item/reagent_containers/food/snacks/meat/biogenerated,
			cost = 50,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"soywafers" = list(
			name = "Soy Wafers",
			class = "Food",
			object = /obj/item/reagent_containers/food/snacks/soywafers,
			cost = 150,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"bio_vitamin" = list(
			name = "Flavored Vitamin",
			class = "Food",
			object = /obj/item/reagent_containers/pill/bio_vitamin,
			cost = 50,
			amount = list(1,5,10,25,50),
			emag = 0
		),
		"liquidfood" = list(
			name = "Food Ration",
			class = "Food",
			object = /obj/item/reagent_containers/food/snacks/liquidfood,
			cost = 30,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"milk" = list(
			name = "Space Milk (50u)",
			class = "Food",
			object = /obj/item/reagent_containers/food/drinks/milk,
			cost = 100,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"nutri-spread" = list(
			name = "Nutri-spread",
			class = "Food",
			object = /obj/item/reagent_containers/food/snacks/spreads,
			cost = 80,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"enzyme" = list(
			name = "Universal Enzyme (50u)",
			class = "Food",
			object = /obj/item/reagent_containers/food/condiment/enzyme,
			cost = 200,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"ez" = list(
			name = "E-Z-Nutrient (60u)",
			class = "Fertilizer",
			object = /obj/item/reagent_containers/glass/fertilizer/ez,
			cost = 60,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"l4z" = list(
			name = "Left 4 Zed (60u)",
			class = "Fertilizer",
			object = /obj/item/reagent_containers/glass/fertilizer/l4z,
			cost = 120,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"rh" = list(
			name = "Robust Harvest (60u)",
			class = "Fertilizer",
			object = /obj/item/reagent_containers/glass/fertilizer/rh,
			cost = 180,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"custom_cigarettes" = list(
			name = "Empty Cigarettes (x6)",
			class = "Items",
			object = /obj/item/storage/fancy/cigarettes/blank,
			cost = 500,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"tape_roll" = list(
			name = "Tape Roll",
			class = "Items",
			object = /obj/item/tape_roll,
			cost = 250,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"botanic_leather" = list(
			name = "Botanical Gloves",
			class = "Items",
			object = /obj/item/clothing/gloves/botanic_leather,
			cost = 250,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"utility" = list(
			name = "Utility Belt",
			class = "Items",
			object = /obj/item/storage/belt/utility,
			cost = 300,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"hydrobelt" = list(
			name = "Hydroponic Belt",
			class = "Items",
			object = /obj/item/storage/belt/hydro,
			cost = 300,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"wallet" = list(
			name = "Leather Wallet",
			class = "Items",
			object = /obj/item/storage/wallet,
			cost = 100,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"satchel" = list(
			name = "Leather Satchel",
			class = "Items",
			object = /obj/item/storage/backpack/satchel,
			cost = 400,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"cash" = list(
			name = "Money Bag",
			class = "Items",
			object = /obj/item/storage/bag/money,
			cost = 400,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"soap" = list(
			name = "Soap",
			class = "Items",
			object = /obj/item/soap/plant,
			cost = 200,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"towel" = list(
			name = "Towel",
			class = "Items",
			object = /obj/item/towel/random,
			cost = 300,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"crayon_box" = list(
			name = "Crayon Box",
			class = "Items",
			object = /obj/item/storage/fancy/crayons,
			cost = 600,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"animalhide" = list(
			name = "Animal Hide",
			class = "Construction",
			object = /obj/item/stack/material/animalhide,
			cost = 100,
			amount = list(1,5,10,25,50),
			emag = 0
		),
		"leather" = list(
			name = "Leather",
			class = "Construction",
			object = /obj/item/stack/material/leather,
			cost = 100,
			amount = list(1,5,10,25,50),
			emag = 0
		),
		"cloth" = list(
			name = "Cloth",
			class = "Construction",
			object = /obj/item/stack/material/cloth,
			cost = 50,
			amount = list(1,5,10,25,50),
			emag = 0
		),
		"cardboard" = list(
			name = "Cardboard",
			class = "Construction",
			object = /obj/item/stack/material/cardboard,
			cost = 50,
			amount = list(1,5,10,25,50),
			emag = 0
		),
		"wax" = list(
			name = "Wax",
			class = "Construction",
			object = /obj/item/stack/wax,
			cost = 100,
			amount = list(1,5,10,25,50),
			emag = 0
		),
		"mushroom" = list(
			name = "Pet Mushroom",
			class = "Special",
			object = /mob/living/simple_animal/mushroom,
			cost = 1000,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"monkey" = list(
			name = "Monkey Cube",
			class = "Special",
			object = /obj/item/reagent_containers/food/snacks/monkeycube/wrapped,
			cost = 500,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"stok" = list(
			name = "Stok Cube",
			class = "Special",
			object = /obj/item/reagent_containers/food/snacks/monkeycube/wrapped/stokcube,
			cost = 500,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"farwa" = list(
			name = "Farwa Cube",
			class = "Special",
			object = /obj/item/reagent_containers/food/snacks/monkeycube/wrapped/farwacube,
			cost = 500,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"neaera" = list(
			name = "Neaera Cube",
			class = "Special",
			object = /obj/item/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube,
			cost = 500,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"cazador" = list(
			name = "V'krexi Cube",
			class = "Special",
			object = /obj/item/reagent_containers/food/snacks/monkeycube/wrapped/vkrexicube,
			cost = 500,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		// Antag Items (Emag)
		"bruise_pack" = list(
			name = "Bruise Pack",
			class = "!@#$%^&*()",
			object = /obj/item/stack/medical/bruise_pack,
			cost = 400,
			amount = list(1,2,3,4,5),
			emag = 1
		),
		"ointment" = list(
			name = "Burn Ointment",
			class = "!@#$%^&*()",
			object = /obj/item/stack/medical/ointment,
			cost = 400,
			amount = list(1,2,3,4,5),
			emag = 1
		),
		"humanhide" = list(
			name = "Human Hide",
			class = "!@#$%^&*()",
			object = /obj/item/stack/material/animalhide/human,
			cost = 50,
			amount = list(1,5,10,25,50),
			emag = 1
		),
		"syndie" = list(
			name = "Red Soap",
			class = "!@#$%^&*()",
			object = /obj/item/soap/syndie,
			cost = 200,
			amount = list(1,2,3,4,5),
			emag = 1
		),
		"buckler" = list(
			name = "Buckler",
			class = "!@#$%^&*()",
			object = /obj/item/shield/buckler,
			cost = 500,
			amount = list(1,2,3,4,5),
			emag = 1
		),
		"tree" = list(
			name = "Tree",
			class = "!@#$%^&*()",
			object = /mob/living/simple_animal/hostile/tree,
			cost = 1000,
			amount = list(1,2,3,4,5),
			emag = 1
		)

	)

/obj/machinery/biogenerator/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = 1
		visible_message(span("danger", "\The [src] makes a fizzling sound."))
		return 1

/obj/machinery/biogenerator/Initialize()
	. = ..()
	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src
	beaker = new /obj/item/reagent_containers/glass/bottle(src)

/obj/machinery/biogenerator/on_reagent_change()			//When the reagents change, change the icon as well.
	update_icon()

/obj/machinery/biogenerator/update_icon()
	if(!beaker)
		icon_state = "biogen-empty"
	else if(!processing)
		icon_state = "biogen-stand"
	else
		icon_state = "biogen-work"
	return

/obj/machinery/biogenerator/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(istype(O, /obj/item/reagent_containers/glass))
		if(beaker)
			to_chat(user, span("notice", "\The [src] is already loaded."))
		else
			user.remove_from_mob(O)
			O.forceMove(src)
			beaker = O
			updateUsrDialog()
	else if(processing)
		to_chat(user, span("notice", "\The [src] is currently processing."))
	else if(istype(O, /obj/item/storage/bag/plants))
		var/i = 0
		var/obj/item/storage/bag/P = O
		for(var/obj/item/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= capacity)
			to_chat(user, span("notice", "\The [src] is already full! Activate it."))
		else
			for(var/obj/item/reagent_containers/food/snacks/grown/G in P.contents)
				P.remove_from_storage(G,src)
				i++
				if(i >= capacity)
					to_chat(user, span("notice", "You fill \the [src] to its capacity."))
					break

				CHECK_TICK

			if(i < capacity)
				to_chat(user, span("notice", "You empty \the [O] into \the [src]."))


	else if(!istype(O, /obj/item/reagent_containers/food/snacks/grown))
		to_chat(user, span("notice", "You cannot put this in \the [src]."))
	else
		var/i = 0
		for(var/obj/item/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= capacity)
			to_chat(user, span("notice", "\The [src] is full! Activate it."))
		else
			user.remove_from_mob(O)
			O.forceMove(src)
			to_chat(user, span("notice", "You put \the [O] in \the [src]"))
	update_icon()
	return

/obj/machinery/biogenerator/interact(mob/user as mob)
	if(stat & BROKEN)
		return
	user.set_machine(src)
	var/dat ="<html>"
	dat += "<head><TITLE>Biogenerator MKII</TITLE><style>body{font-family:Garamond}</style></head>"
	dat += "<body><H1>Biogenerator MKII</H1>"
	dat += "Biomass: [points] points.<HR>"
	if (processing)
		dat += "<FONT COLOR=red>Biogenerator is processing! Please wait...</FONT>"
	else
		switch(menustat)
			if("menu")
				if (beaker)
					dat += "<table><tr><td colspan=7><H2>Commands</H2></td></tr>"
					dat += "<tr><td><A href='?src=\ref[src];action=activate'>Activate Biogenerator</A></td></tr>"
					dat += "<tr><td><A href='?src=\ref[src];action=detach'>Detach Container</A><BR></td></tr>"
					dat += "<tr><td>Name</td><td>Cost</td><td colspan=5>Production Amount</td></tr>"
					var/lastclass = "Commands"

					for (var/k in biorecipies)
						var/list/v = biorecipies[k]
						var/id = k
						var/name = v["name"]
						var/class = v["class"]
						var/cost = v["cost"]
						var/listamount = v["amount"]
						var/emag = v["emag"]

						if(emag == 0 || emagged == 1)
							if(lastclass != class)
								dat += "<tr><td colspan=7><H2>[class]</H2><td></tr>"
								lastclass = class
							dat += "<tr><td>[name]<td>[round(cost/build_eff)]</td>"
							for(var/num in listamount)
								dat += "<td>"
								var/fakenum = ""
								if(num <= 9)
									fakenum = "0"
								if(num*round(cost/build_eff) > points)
									dat += "([fakenum][num])"
								else
									dat += "<A href='?src=\ref[src];action=create;itemid=[id];count=[num]'>([fakenum][num])</A>"
								dat += "</td>"
							dat += "</tr>"

					dat += "</table>"

				else
					dat += "<BR><FONT COLOR=red>No beaker inside. Please insert a beaker.</FONT><BR>"
			if("nopoints")
				dat += "You do not have biomass to create products.<BR>Please, put growns into reactor and activate it.<BR>"
				dat += "<A href='?src=\ref[src];action=menu'>Return to menu</A>"
			if("complete")
				dat += "Operation complete.<BR>"
				dat += "<A href='?src=\ref[src];action=menu'>Return to menu</A>"
			if("void")
				dat += "<FONT COLOR=red>Error: No growns inside.</FONT><BR>Please, put growns into reactor.<BR>"
				dat += "<A href='?src=\ref[src];action=menu'>Return to menu</A>"
	dat += "</body><html>"

	user << browse(dat, "window=biogenerator")
	onclose(user, "biogenerator")
	return

/obj/machinery/biogenerator/attack_hand(mob/user as mob)
	interact(user)

/obj/machinery/biogenerator/proc/activate()
	if (usr.stat)
		return
	if (stat) //NOPOWER etc
		return
	if(processing)
		to_chat(usr, span("notice", "The biogenerator is in the process of working."))
		return
	var/S = 0
	for(var/obj/item/reagent_containers/food/snacks/grown/I in contents)
		S += 5
		if(I.reagents.get_reagent_amount("nutriment") < 0.1)
			points += 1
		else points += I.reagents.get_reagent_amount("nutriment") * 10 * eat_eff
		qdel(I)
		CHECK_TICK
	if(S)
		processing = 1
		update_icon()
		updateUsrDialog()
		playsound(src.loc, 'sound/machines/juicer.ogg', 50, 1)
		use_power(S * 30)
		sleep((S + 15) / eat_eff)
		processing = 0
		update_icon()
	else
		menustat = "void"
	return

/obj/machinery/biogenerator/proc/create_product(var/itemid, var/count)

	var/list/recipie_data = biorecipies[itemid]

	if (!istype(recipie_data))
		return 0

	if (recipie_data["emag"] && !emagged)
		return 0

	var/cost = recipie_data["cost"]
	var/totake = round(cost/build_eff)
	var/delay = totake/2
	//Meat = 5 seconds

	for(var/i = 1,i <= count; i++)
		if (totake > points)
			menustat = "nopoints"
			return 0
		else
			if(!processing)
				processing = 1
				update_icon()
				updateUsrDialog()
			points -= totake
			use_power(totake * 0.25)
			sleep( delay )
			playsound(src.loc, "switchsounds", 50, 1)
			var/new_object = recipie_data["object"]
			new new_object(loc)

	sleep(10)

	processing = 0
	menustat = "complete"
	update_icon()
	return 1

/obj/machinery/biogenerator/Topic(href, href_list)
	if(stat & BROKEN) return
	if(usr.stat || usr.restrained()) return
	if(!in_range(src, usr)) return

	usr.set_machine(src)

	switch(href_list["action"])
		if("activate")
			activate()
		if("detach")
			if(beaker)
				beaker.forceMove(src.loc)
				beaker = null
				update_icon()
		if("create")
			create_product(href_list["itemid"], text2num(href_list["count"]))
		if("menu")
			menustat = "menu"
	updateUsrDialog()

/obj/machinery/biogenerator/RefreshParts()
	..()
	var/man_rating = 1
	var/bin_rating = 1

	for(var/obj/item/stock_parts/P in component_parts)
		if(ismatterbin(P))
			bin_rating += P.rating
		else if(ismanipulator(P))
			man_rating += P.rating

	build_eff = man_rating
	eat_eff = bin_rating
