/obj/machinery/biogenerator
	name = "biogenerator"
	desc = "An advanced machine that can be used to convert grown plantlike biological material into various other bio-goods."
	icon = 'icons/obj/biogenerator.dmi'
	icon_state = "biogen"
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

#define BIOGEN_FOOD "Food"
#define BIOGEN_ITEMS "Items"
#define BIOGEN_SPECIAL "Special"
#define BIOGEN_CONSTRUCTION "Construction"
#define BIOGEN_FERTILIZER "Fertilizer"
#define BIOGEN_MEDICAL "Medical"
#define BIOGEN_ILLEGAL "!@#$%^&*()"

/decl/biorecipe
	var/name = "fixme"
	var/class = BIOGEN_ITEMS
	var/object
	var/cost = 100
	var/amount = list(1, 2, 3, 4, 5)
	var/emag = FALSE

/decl/biorecipe/food
	name = "Meat Substitute"
	class = BIOGEN_FOOD
	object = /obj/item/reagent_containers/food/snacks/meat/biogenerated
	cost = 50

/decl/biorecipe/food/fishfillet
	name = "Fish Fillet"
	object = /obj/item/reagent_containers/food/snacks/fish/fishfillet

/decl/biorecipe/food/syntiflesh
	name = "Synthetic Meat"
	object = /obj/item/reagent_containers/food/snacks/meat/syntiflesh

/decl/biorecipe/food/soywafers
	name = "Soy Wafers"
	object = /obj/item/reagent_containers/food/snacks/soywafers
	cost = 150

/decl/biorecipe/food/bio_vitamin
	name = "Flavored Vitamin"
	object = /obj/item/reagent_containers/pill/bio_vitamin
	amount = list(1,5,10,25,50)

/decl/biorecipe/food/liquidfood
	name = "Food Ration"
	object = /obj/item/reagent_containers/food/snacks/liquidfood
	cost = 30

/decl/biorecipe/food/milk
	name = "Space Milk (50u)"
	object = /obj/item/reagent_containers/food/drinks/milk
	cost = 100

/decl/biorecipe/food/nutrispread
	name = "Nutri-spread"
	object = /obj/item/reagent_containers/food/snacks/spreads
	cost = 80

/decl/biorecipe/food/enzyme
	name = "Universal Enzyme (50u)"
	object = /obj/item/reagent_containers/food/condiment/enzyme

/*
 FERTILIZER
*/

/decl/biorecipe/fertilizer
	name = "E-Z-Nutrient (60u)"
	class = BIOGEN_FERTILIZER
	object = /obj/item/reagent_containers/glass/fertilizer/ez
	cost = 60

/decl/biorecipe/fertilizer/l4z
	name = "Left 4 Zed (60u)"
	object = /obj/item/reagent_containers/glass/fertilizer/l4z
	cost = 120

/decl/biorecipe/fertilizer/rh
	name = "Robust Harvest (60u)"
	object = /obj/item/reagent_containers/glass/fertilizer/rh
	cost = 180

/*
 ITEMS
*/
/decl/biorecipe/item
	name = "Towel"
	class = BIOGEN_ITEMS
	object = /obj/item/towel/random
	cost = 300

/decl/biorecipe/item/jug
	name = "Empty Jug"
	object = /obj/item/reagent_containers/glass/fertilizer
	cost = 100

/decl/biorecipe/item/custom_cigarettes
	name = "Empty Cigarettes (x6)"
	object = /obj/item/storage/box/fancy/cigarettes/blank
	cost = 500

/decl/biorecipe/item/tape_roll
	name = "Tape Roll"
	object = /obj/item/tape_roll
	cost = 250

/decl/biorecipe/item/botanic_leather
	name = "Botanical Gloves"
	object = /obj/item/clothing/gloves/botanic_leather
	cost = 250

/decl/biorecipe/item/utility
	name = "Utility Belt"
	object = /obj/item/storage/belt/utility

/decl/biorecipe/item/hydrobelt
	name = "Hydroponic Belt"
	object = /obj/item/storage/belt/hydro

/decl/biorecipe/item/plantbag
	name = "Plant Bag"
	object = /obj/item/storage/bag/plants
	cost = 500

/decl/biorecipe/item/wallet
	name = "Leather Wallet"
	object = /obj/item/storage/wallet
	cost = 100

/decl/biorecipe/item/satchel
	name = "Leather Satchel"
	object = /obj/item/storage/backpack/satchel
	cost = 400

/decl/biorecipe/item/cash
	name = "Money Bag"
	object = /obj/item/storage/bag/money
	cost = 400

/decl/biorecipe/item/soap
	name = "Soap"
	object = /obj/item/soap/plant
	cost = 200

/decl/biorecipe/item/crayon_box
	name = "Crayon Box"
	object = /obj/item/storage/box/fancy/crayons
	cost = 600

/*
 CONSTRUCTION
*/

/decl/biorecipe/construction
	name = "Animal Hide"
	class = BIOGEN_CONSTRUCTION
	object = /obj/item/stack/material/animalhide
	cost = 100
	amount = list(1,5,10,25,50)

/decl/biorecipe/construction/leather
	name = "Leather"
	object = /obj/item/stack/material/leather

/decl/biorecipe/construction/cloth
	name = "Cloth"
	object = /obj/item/stack/material/cloth
	cost = 50

/decl/biorecipe/construction/cardboard
	name = "Cardboard"
	object = /obj/item/stack/material/cardboard
	cost = 50

/decl/biorecipe/construction/wax
	name = "Wax"
	object = /obj/item/stack/wax

/decl/biorecipe/construction/plastic
	name = "Plastic"
	object = /obj/item/stack/material/plastic

/*
 SPECIAL
*/

/decl/biorecipe/mushroom
	name = "Pet Mushroom"
	class = BIOGEN_SPECIAL
	object = /mob/living/simple_animal/mushroom
	cost = 1000

/decl/biorecipe/cube
	name = "Monkey Cube"
	class = BIOGEN_SPECIAL
	object = /obj/item/reagent_containers/food/snacks/monkeycube/wrapped

/decl/biorecipe/cube/stok
	name = "Stok Cube"
	object = /obj/item/reagent_containers/food/snacks/monkeycube/wrapped/stokcube

/decl/biorecipe/cube/farwa
	name = "Farwa Cube"
	object = /obj/item/reagent_containers/food/snacks/monkeycube/wrapped/farwacube

/decl/biorecipe/cube/neaera
	name = "Neaera Cube"
	object = /obj/item/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube

/decl/biorecipe/cube/cazador
	name = "V'krexi Cube"
	object = /obj/item/reagent_containers/food/snacks/monkeycube/wrapped/vkrexicube
	cost = 500

/decl/biorecipe/medical
	name = "Bruise Pack"
	class = BIOGEN_MEDICAL
	object = /obj/item/stack/medical/bruise_pack
	cost = 400

/decl/biorecipe/medical/ointment
	name = "Burn Ointment"
	object = /obj/item/stack/medical/ointment

/decl/biorecipe/medical/perconol_pill
	name = "Perconol Pill"
	object = /obj/item/reagent_containers/pill/perconol
	cost = 250
	amount = list(1,2,3,5,7)

/decl/biorecipe/illegal
	name = "Advanced Trauma Kit"
	class = BIOGEN_ILLEGAL
	object = /obj/item/stack/medical/advanced/bruise_pack
	cost = 600
	emag = TRUE

/decl/biorecipe/illegal/adv_burn_kit
	name = "Advanced Burn Kit"
	object = /obj/item/stack/medical/advanced/ointment

		// Antag Items (Emag)
/decl/biorecipe/illegal/humanhide
	name = "Human Hide"
	object = /obj/item/stack/material/animalhide/human
	cost = 50
	amount = list(1,5,10,25,50)

/decl/biorecipe/illegal/syndie
	name = "Red Soap"
	object = /obj/item/soap/syndie
	cost = 200

/decl/biorecipe/illegal/buckler
	name = "Buckler"
	object = /obj/item/shield/buckler
	cost = 500

/decl/biorecipe/illegal/tree
	name = "Tree"
	object = /mob/living/simple_animal/hostile/tree
	cost = 1000

/obj/machinery/biogenerator/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = 1
		visible_message(SPAN_DANGER("\The [src] makes a fizzling sound."))
		return 1

/obj/machinery/biogenerator/Initialize()
	. = ..()
	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src
	beaker = new /obj/item/reagent_containers/glass/bottle(src)
	update_icon()

/obj/machinery/biogenerator/on_reagent_change()			//When the reagents change, change the icon as well.
	update_icon()

/obj/machinery/biogenerator/update_icon()
	if(!beaker)
		icon_state = "[initial(icon_state)]-empty"
	else if(!processing)
		icon_state = "[initial(icon_state)]-stand"
	else
		icon_state = "[initial(icon_state)]-work"

/obj/machinery/biogenerator/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(istype(O, /obj/item/reagent_containers/glass))
		if(beaker)
			to_chat(user, SPAN_NOTICE("\The [src] is already loaded."))
		else
			user.remove_from_mob(O)
			O.forceMove(src)
			beaker = O
			updateUsrDialog()
	else if(processing)
		to_chat(user, SPAN_NOTICE("\The [src] is currently processing."))
	else if(istype(O, /obj/item/storage/bag/plants))
		var/i = 0
		var/obj/item/storage/bag/P = O
		for(var/obj/item/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= capacity)
			to_chat(user, SPAN_NOTICE("\The [src] is already full! Activate it."))
		else
			for(var/obj/item/reagent_containers/food/snacks/grown/G in P.contents)
				P.remove_from_storage(G,src)
				i++
				if(i >= capacity)
					to_chat(user, SPAN_NOTICE("You fill \the [src] to its capacity."))
					break

				CHECK_TICK

			if(i < capacity)
				to_chat(user, SPAN_NOTICE("You empty \the [O] into \the [src]."))


	else if(!istype(O, /obj/item/reagent_containers/food/snacks/grown))
		to_chat(user, SPAN_NOTICE("You cannot put this in \the [src]."))
	else
		var/i = 0
		for(var/obj/item/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= capacity)
			to_chat(user, SPAN_NOTICE("\The [src] is full! Activate it."))
		else
			user.remove_from_mob(O)
			O.forceMove(src)
			to_chat(user, SPAN_NOTICE("You put \the [O] in \the [src]"))
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
					dat += "<table style='width:100%'><tr><td colspan='6'><H2>Commands</H2></td></tr>"
					dat += "<tr><td colspan='2'><A href='?src=\ref[src];action=activate'>Activate Biogenerator</A></td></tr>"
					dat += "<tr><td colspan='2'><A href='?src=\ref[src];action=detach'>Detach Container</A><BR></td></tr>"
					dat += "<tr><td colspan='2'>Name</td><td colspan='2'>Cost</td><td colspan='4'>Production Amount</td></tr>"
					var/lastclass = "Commands"

					for (var/k in decls_repository.get_decls_of_subtype(/decl/biorecipe))
						var/decl/biorecipe/current_recipe = decls_repository.get_decl(k)

						if(emagged || !current_recipe.emag)
							if(lastclass != current_recipe.class)
								dat += "<tr><td colspan='6'><H2>[current_recipe.class]</H2></td></tr>"
								lastclass = current_recipe.class
							dat += "<tr class='build'><td colspan='2'>[current_recipe.name]</td><td colspan='2'>[round(current_recipe.cost/build_eff)]</td>"
							dat += "<td colspan='4'>"
							for(var/num in current_recipe.amount)
								var/fakenum = ""
								if(num <= 9)
									fakenum = "0"
								if(num*round(current_recipe.cost/build_eff) > points)
									dat += "<div class='no-build inline'>([fakenum][num])</div>"
								else
									dat += "<A href='?src=\ref[src];action=create;itemtype=[current_recipe.type];count=[num]'>([fakenum][num])</A>"
							dat += "</td>"
							dat += "</tr>"

					dat += "</table>"

				else
					dat += "<BR><FONT COLOR=red>No beaker inside. Please insert a beaker.</FONT><BR>"
			if("nopoints")
				dat += "You do not have biomass to create products.<BR>Please put growns into the reactor and activate it.<BR>"
				dat += "<A href='?src=\ref[src];action=menu'>Return to menu</A>"
			if("complete")
				dat += "Operation complete.<BR>"
				dat += "<A href='?src=\ref[src];action=menu'>Return to menu</A>"
			if("void")
				dat += "<FONT COLOR=red>Error: No growns inside.</FONT><BR>Please put growns into the reactor.<BR>"
				dat += "<A href='?src=\ref[src];action=menu'>Return to menu</A>"
	dat += "</body></html>"

	var/datum/browser/biogen_win = new(user, "biogenerator", "Biogenerator", 450, 500)
	biogen_win.set_content(dat)
	biogen_win.add_stylesheet("misc", 'html/browser/misc.css')
	biogen_win.open()

/obj/machinery/biogenerator/attack_hand(mob/user as mob)
	interact(user)

/obj/machinery/biogenerator/proc/activate()
	if (usr.stat)
		return
	if (stat) //NOPOWER etc
		return
	if(processing)
		to_chat(usr, SPAN_NOTICE("The biogenerator is in the process of working."))
		return
	var/S = 0
	for(var/obj/item/reagent_containers/food/snacks/grown/I in contents)
		S += 5
		if(REAGENT_VOLUME(I.reagents, /decl/reagent/nutriment) < 0.1)
			points += 1
		else points += REAGENT_VOLUME(I.reagents, /decl/reagent/nutriment) * 10 * eat_eff
		qdel(I)
		CHECK_TICK
	if(S)
		processing = 1
		update_icon()
		updateUsrDialog()
		playsound(src.loc, 'sound/machines/juicer.ogg', 50, 1)
		intent_message(MACHINE_SOUND)
		use_power(S * 30)
		sleep((S + 1.5 SECONDS) / eat_eff)
		processing = 0
		update_icon()
	else
		menustat = "void"
	return

/obj/machinery/biogenerator/proc/create_product(var/itemtype, var/count)
	if (!ispath(itemtype, /decl/biorecipe))
		return FALSE

	var/decl/biorecipe/recipe = decls_repository.get_decl(itemtype)

	if (!ispath(recipe.object)) // this shouldn't happen unless someone tries to create /decl/biorecipe with href hacking
		return FALSE

	if (recipe.emag && !emagged)
		return FALSE

	if (!(count in recipe.amount)) // l-l-look at you, href h-hacker...
		return FALSE

	var/totake = round(recipe.cost/build_eff)
	var/delay = totake/2
	//Meat = 5 seconds

	if(!processing)
		processing = TRUE
		update_icon()
		updateUsrDialog()

	sleep(delay)
	var/obj/made_container
	for(var/i = 1,i <= count; i++)
		updateUsrDialog()
		if(totake > points)
			processing = FALSE
			menustat = "nopoints"
			update_icon()
			return FALSE
		else
			points -= totake
			use_power(totake * 0.25)
			playsound(src.loc, /decl/sound_category/switch_sound, 50, 1)
			intent_message(PING_SOUND)
			if(ispath(recipe.object, /obj/item/reagent_containers/pill))
				if(!made_container)
					made_container = new /obj/item/storage/pill_bottle(loc)
				new recipe.object(made_container)
			else if(ispath(recipe.object, /obj/item/stack/medical)) // we want full amounts of medical supplies
				new recipe.object(loc)
				sleep(delay)
			else if(ispath(recipe.object, /obj/item/stack))
				var/subtract_amount = totake * (count - 1)
				points -= subtract_amount
				use_power(subtract_amount * 0.25)
				new recipe.object(loc, count)
				break
			else
				new recipe.object(loc)
				sleep(delay)

	sleep(1 SECOND)

	processing = 0
	menustat = "complete"
	update_icon()
	updateUsrDialog()
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
				usr.put_in_hands(beaker)
				beaker = null
				update_icon()
		if("create")
			create_product(text2path(href_list["itemtype"]), text2num(href_list["count"]))
		if("menu")
			menustat = "menu"
	updateUsrDialog()

/obj/machinery/biogenerator/RefreshParts()
	..()
	var/man_rating = 0
	var/bin_rating = 0

	for(var/obj/item/stock_parts/P in component_parts)
		if(ismatterbin(P))
			bin_rating += P.rating
		else if(ismanipulator(P))
			man_rating += P.rating

	build_eff = man_rating
	eat_eff = bin_rating

/obj/machinery/biogenerator/small
	icon_state = "biogen_small"
	density = FALSE
	capacity = 25

	component_types = list(
		/obj/item/circuitboard/biogenerator/small,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/manipulator
	)

/obj/machinery/biogenerator/small/north
	dir = NORTH
	pixel_y = -13
	layer = MOB_LAYER + 0.1

/obj/machinery/biogenerator/small/south
	dir = SOUTH
	pixel_y = 20
	layer = OBJ_LAYER + 0.3

/obj/machinery/biogenerator/small/east
	dir = EAST
	pixel_x = -12

/obj/machinery/biogenerator/small/west
	dir = WEST
	pixel_x = 11

/obj/machinery/biogenerator/small/RefreshParts()
	..()
	build_eff = max(build_eff - 1, 1)
	eat_eff = max(eat_eff - 1, 1)
