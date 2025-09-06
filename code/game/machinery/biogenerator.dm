/obj/machinery/biogenerator
	name = "biogenerator"
	desc = "An advanced machine that can be used to convert grown plantlike biological material into various other bio-goods."
	icon = 'icons/obj/biogenerator.dmi'
	icon_state = "biogen"
	density = 1
	anchored = 1
	idle_power_usage = 40
	var/processing = 0
	var/obj/item/reagent_containers/glass/beaker = null
	var/points = 0
	var/menustat = "menu"
	var/build_eff = 1
	var/eat_eff = 1
	var/capacity = 100

	component_types = list(
		/obj/item/circuitboard/biogenerator,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/manipulator
	)

/obj/machinery/biogenerator/upgrade_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Upgraded <b>manipulators</b> will increase the nutrients provided by new inputs."
	. += "Upgraded <b>matter bins</b> will decrease the conversion cost of bio-goods."

#define BIOGEN_FOOD "Food"
#define BIOGEN_ITEMS "Items"
#define BIOGEN_FLAGS "Corporate Flags"
#define BIOGEN_SPECIAL "Special"
#define BIOGEN_CONSTRUCTION "Construction"
#define BIOGEN_FERTILIZER "Fertilizer"
#define BIOGEN_MEDICAL "Medical"
#define BIOGEN_CLOTHES "Clothing"
#define BIOGEN_ILLEGAL "!@#$%^&*()"

/singleton/biorecipe
	var/name = "fixme"
	var/class = BIOGEN_ITEMS
	var/object
	var/cost = 100
	var/amount = list(1, 2, 3, 4, 5)
	var/emag = FALSE

/*
FOODSTUFFS
*/

/singleton/biorecipe/food
	name = "Meat Substitute"
	class = BIOGEN_FOOD
	object = /obj/item/reagent_containers/food/snacks/meat/biogenerated
	cost = 75

/singleton/biorecipe/food/fishfillet
	name = "Fish Fillet"
	object = /obj/item/reagent_containers/food/snacks/fish/fishfillet

/singleton/biorecipe/food/syntiflesh
	name = "Synthetic Meat"
	object = /obj/item/reagent_containers/food/snacks/meat/syntiflesh

/singleton/biorecipe/food/slimymeat
	name = "Slimy Meat"
	object = /obj/item/reagent_containers/food/snacks/fish/mollusc
	cost = 100

/singleton/biorecipe/food/soywafers
	name = "Soy Wafers"
	object = /obj/item/reagent_containers/food/snacks/soywafers
	cost = 150

/singleton/biorecipe/food/boba
	name = "Boba Pearls"
	object = /obj/item/reagent_containers/food/drinks/boba
	cost = 75

/singleton/biorecipe/food/egg_carton
	name = "Chicken Egg Carton"
	object = /obj/item/storage/box/fancy/egg_box
	cost = 350

/singleton/biorecipe/food/tunneler_egg_carton
	name = "Ice Tunneler Egg Carton"
	object = /obj/item/storage/box/fancy/egg_box/tunneler
	cost = 350

/singleton/biorecipe/food/bio_vitamin
	name = "Flavored Vitamin"
	object = /obj/item/reagent_containers/pill/bio_vitamin
	amount = list(1,5,10,25,50)

/singleton/biorecipe/food/liquidfood
	name = "Food Ration"
	object = /obj/item/reagent_containers/food/snacks/liquidfood
	cost = 50

/singleton/biorecipe/food/milk
	name = "Space Milk (50u)"
	object = /obj/item/reagent_containers/food/drinks/carton/milk
	cost = 125

/singleton/biorecipe/food/nutrispread
	name = "Nutri-spread"
	object = /obj/item/reagent_containers/food/snacks/spreads
	cost = 100

/singleton/biorecipe/food/lard
	name = "Lard"
	object = /obj/item/reagent_containers/food/snacks/spreads/lard
	cost = 100

/singleton/biorecipe/food/egg_carton
	name = "Chicken Egg Carton"
	object = /obj/item/storage/box/fancy/egg_box
	cost = 350

/singleton/biorecipe/food/tunneler_egg_carton
	name = "Ice Tunneler Egg Carton"
	object = /obj/item/storage/box/fancy/egg_box/tunneler
	cost = 350

/singleton/biorecipe/food/enzyme
	name = "Universal Enzyme (50u)"
	object = /obj/item/reagent_containers/food/condiment/enzyme
	cost = 125

/singleton/biorecipe/food/blood
	name = "Synthetic Blood (50u)"
	object = /obj/item/reagent_containers/food/condiment/blood
	cost = 125

/singleton/biorecipe/food/pepper
	name = "Pepper Grinder"
	object = /obj/item/reagent_containers/food/condiment/shaker/peppermill
	cost = 75

/singleton/biorecipe/food/salt
	name = "Salt Shaker"
	object = /obj/item/reagent_containers/food/condiment/shaker/salt
	cost = 75

/singleton/biorecipe/food/spacespice
	name = "Space Spice Shaker"
	object = /obj/item/reagent_containers/food/condiment/shaker/spacespice
	cost = 100

/singleton/biorecipe/food/sprinkles
	name = "Sprinkle Shaker"
	object = /obj/item/reagent_containers/food/condiment/shaker/sprinkles
	cost = 100

/*
FERTILIZER
*/

/singleton/biorecipe/fertilizer
	name = "E-Z-Nutrient (60u)"
	class = BIOGEN_FERTILIZER
	object = /obj/item/reagent_containers/glass/fertilizer/ez
	cost = 75

/singleton/biorecipe/fertilizer/l4z
	name = "Left 4 Zed (60u)"
	object = /obj/item/reagent_containers/glass/fertilizer/l4z
	cost = 130

/singleton/biorecipe/fertilizer/rh
	name = "Robust Harvest (60u)"
	object = /obj/item/reagent_containers/glass/fertilizer/rh
	cost = 180

/*
ITEMS
*/

/singleton/biorecipe/item
	name = "Towel"
	class = BIOGEN_ITEMS
	object = /obj/item/towel/random
	cost = 200

/singleton/biorecipe/item/jug
	name = "Empty Jug"
	object = /obj/item/reagent_containers/glass/fertilizer
	cost = 50

/singleton/biorecipe/item/glowstick
	name = "Glowstick"
	object = /obj/random/glowstick
	cost = 75

/singleton/biorecipe/item/plushie
	name = "Plushie"
	object = /obj/random/plushie
	cost = 200

/singleton/biorecipe/item/yarn
	name = "Ball of Yarn"
	object = /obj/random/yarn
	cost = 75

/singleton/biorecipe/item/knitting
	name = "Knitting Needles"
	object = /obj/item/knittingneedles
	cost = 150

/singleton/biorecipe/item/custom_cigarettes
	name = "Empty Cigarettes (x6)"
	object = /obj/item/storage/box/fancy/cigarettes/blank
	cost = 300

/singleton/biorecipe/item/tape_roll
	name = "Tape Roll"
	object = /obj/item/tape_roll
	cost = 150

/singleton/biorecipe/item/wallet
	name = "Leather Wallet"
	object = /obj/item/storage/wallet
	cost = 100

/singleton/biorecipe/item/lighter
	name = "Cheap Lighter"
	object = /obj/item/flame/lighter/random
	cost = 100

/singleton/biorecipe/item/pottedplant
	name = "Small Plant Pot"
	object = /obj/random/pottedplant_small
	cost = 300

/singleton/biorecipe/item/soap
	name = "Soap"
	object = /obj/item/soap/plant
	cost = 200

/singleton/biorecipe/item/crayon_box
	name = "Crayon Box"
	object = /obj/item/storage/box/fancy/crayons
	cost = 400

/singleton/biorecipe/item/goldstar
	name = "Gold Star Sticker Sheet"
	object = /obj/item/storage/stickersheet/goldstar
	cost = 600

/singleton/biorecipe/item/plantbag
	name = "Plant Bag"
	object = /obj/item/storage/bag/plants
	cost = 250

// Like soap, but better!
/singleton/biorecipe/item/mop
	name = "Mop"
	object = /obj/item/mop
	cost = 400

/singleton/biorecipe/item/filterbox
	name = "Cigarette Filters"
	object = /obj/item/storage/cigfilters
	cost = 200

/singleton/biorecipe/item/cigarettepaper
	name = "Cigarette Paper"
	object = /obj/item/storage/box/fancy/cigpaper
	cost = 200

// Intended to accomodate hydroponicists preparing their own first-aid kits for themselves or the crew.
/singleton/biorecipe/item/emptyfirstaid
	name = "Empty First Aid Kit"
	object = /obj/item/storage/firstaid/empty
	cost = 200

/singleton/biorecipe/item/trash
	name = "Trash Bag"
	object = /obj/item/storage/bag/trash
	cost = 200

/*
CLOTHING
*/

/singleton/biorecipe/clothes
	name = "Hazard Vest"
	class = BIOGEN_CLOTHES
	object = /obj/item/clothing/suit/storage/hazardvest
	cost = 200

/singleton/biorecipe/clothes/satchel
	name = "Leather Satchel"
	object = /obj/item/storage/backpack/satchel/leather
	cost = 300

/singleton/biorecipe/clothes/duffel
	name = "Duffel Bag"
	object = /obj/item/storage/backpack/duffel
	cost = 200

/singleton/biorecipe/clothes/backpack
	name = "Generic Backpack"
	object = /obj/random/biogenerator/backpack
	cost = 200

/singleton/biorecipe/clothes/botanic_leather
	name = "Botanical Gloves"
	object = /obj/item/clothing/gloves/botanic_leather
	cost = 150

/singleton/biorecipe/clothes/gloves
	name = "Random Black Gloves"
	object = /obj/random/biogenerator/gloves
	cost = 125

/singleton/biorecipe/clothes/latexgloves
	name = "Latex Gloves"
	object = /obj/item/clothing/gloves/latex
	cost = 200

/singleton/biorecipe/clothes/randomgloves
	name = "Random Gloves"
	object = /obj/random/biogenerator/gloves/random
	cost = 125

/singleton/biorecipe/clothes/medicalbelt
	name = "Medical Belt"
	object = /obj/item/storage/belt/medical
	cost = 200

/singleton/biorecipe/clothes/utility
	name = "Utility Belt"
	object = /obj/item/storage/belt/utility
	cost = 200

/singleton/biorecipe/clothes/hydrobelt
	name = "Hydroponic Belt"
	object = /obj/item/storage/belt/hydro
	cost = 200

/*
MEDICAL
*/

/singleton/biorecipe/cube
	name = "Monkey Cube"
	class = BIOGEN_SPECIAL
	object = /obj/item/reagent_containers/food/snacks/monkeycube/wrapped
	cost = 125

/singleton/biorecipe/cube/stok
	name = "Stok Cube"
	object = /obj/item/reagent_containers/food/snacks/monkeycube/wrapped/stokcube
	cost = 125

/singleton/biorecipe/cube/farwa
	name = "Farwa Cube"
	object = /obj/item/reagent_containers/food/snacks/monkeycube/wrapped/farwacube
	cost = 125

/singleton/biorecipe/cube/neaera
	name = "Neaera Cube"
	object = /obj/item/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube
	cost = 125

/singleton/biorecipe/cube/cazador
	name = "V'krexi Cube"
	object = /obj/item/reagent_containers/food/snacks/monkeycube/wrapped/vkrexicube
	cost = 500

/singleton/biorecipe/medical
	name = "Bruise Pack"
	class = BIOGEN_MEDICAL
	object = /obj/item/stack/medical/bruise_pack
	cost = 400

/singleton/biorecipe/medical/ointment
	name = "Burn Ointment"
	object = /obj/item/stack/medical/ointment
	cost = 125

/singleton/biorecipe/medical/perconol_pill
	name = "Perconol Pill"
	object = /obj/item/reagent_containers/pill/perconol
	cost = 250
	amount = list(1,2,3,5,7)

/*
CONSTRUCTION
*/

/singleton/biorecipe/construction
	name = "Animal Hide"
	class = BIOGEN_CONSTRUCTION
	object = /obj/item/stack/material/animalhide
	cost = 100
	amount = list(1,5,10,25,50)

/singleton/biorecipe/construction/leather
	name = "Leather"
	object = /obj/item/stack/material/leather

/singleton/biorecipe/construction/cloth
	name = "Cloth"
	object = /obj/item/stack/material/cloth
	cost = 50

/singleton/biorecipe/construction/cardboard
	name = "Cardboard"
	object = /obj/item/stack/material/cardboard
	cost = 50

/singleton/biorecipe/construction/wax
	name = "Wax"
	object = /obj/item/stack/wax
	cost = 10

/singleton/biorecipe/construction/plastic
	name = "Plastic"
	object = /obj/item/stack/material/plastic
	cost = 75

/singleton/biorecipe/construction/wood
	name = "Wood"
	object = /obj/item/stack/material/wood

/*
FLAGS
*/

/singleton/biorecipe/flag
	name = "SCC Flag, Small"
	class = BIOGEN_FLAGS
	object = /obj/item/flag/scc
	cost = 500

/singleton/biorecipe/flag/scclarge
	name = "SCC Flag, large"
	object = /obj/item/flag/scc/l
	cost = 500

/singleton/biorecipe/flag/heph
	name = "Hephaestus Flag, Small"
	object = /obj/item/flag/heph
	cost = 500

/singleton/biorecipe/flag/hephlarge
	name = "Hephaestus Flag, Large"
	object = /obj/item/flag/heph/l
	cost = 500

/singleton/biorecipe/flag/idris
	name = "Idris Flag, Small"
	object = /obj/item/flag/idris
	cost = 500

/singleton/biorecipe/flag/idrislarge
	name = "Idris Flag, Large"
	object = /obj/item/flag/idris/l
	cost = 500

/singleton/biorecipe/flag/zeng
	name = "Zeng-Hu Flag, Small"
	object = /obj/item/flag/zenghu
	cost = 500

/singleton/biorecipe/flag/zenglarge
	name = "Zeng-Hu Flag, Large"
	object = /obj/item/flag/zenghu/l
	cost = 500

/singleton/biorecipe/flag/zavod
	name = "Zavodskoi Flag, Small"
	object = /obj/item/flag/zavodskoi
	cost = 500

/singleton/biorecipe/flag/zavodlarge
	name = "Zavodskoi Flag, Large"
	object = /obj/item/flag/zavodskoi/l
	cost = 500

/singleton/biorecipe/flag/pmcg
	name = "PMCG Flag, Small"
	object = /obj/item/flag/pmcg
	cost = 500

/singleton/biorecipe/flag/pmcglarge
	name = "PMCG Flag, Large"
	object = /obj/item/flag/pmcg/l
	cost = 500

/singleton/biorecipe/flag/orion
	name = "Orion Flag, Small"
	object = /obj/item/flag/orion_express
	cost = 500

/singleton/biorecipe/flag/orionlarge
	name = "Orion Express Flag, Large"
	object = /obj/item/flag/orion_express/l
	cost = 500

/*
EMAG/ILLEGAL
*/
/singleton/biorecipe/illegal
	name = "Advanced Trauma Kit"
	class = BIOGEN_ILLEGAL
	object = /obj/item/stack/medical/advanced/bruise_pack
	cost = 600
	emag = TRUE

/singleton/biorecipe/illegal/adv_burn_kit
	name = "Advanced Burn Kit"
	object = /obj/item/stack/medical/advanced/ointment

/singleton/biorecipe/illegal/syndie
	name = "Red Soap"
	object = /obj/item/soap/syndie
	cost = 200

/singleton/biorecipe/illegal/buckler
	name = "Buckler"
	object = /obj/item/shield/buckler
	cost = 500

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
		icon_state = "[initial(icon_state)]"
	else if(!processing)
		icon_state = "[initial(icon_state)]-stand"
	else
		icon_state = "[initial(icon_state)]-work"

/obj/machinery/biogenerator/attackby(obj/item/attacking_item, mob/user)
	if(default_deconstruction_screwdriver(user, attacking_item))
		return TRUE
	if(default_deconstruction_crowbar(user, attacking_item))
		return TRUE
	if(default_part_replacement(user, attacking_item))
		return TRUE
	if(istype(attacking_item, /obj/item/reagent_containers/glass))
		if(beaker)
			to_chat(user, SPAN_NOTICE("\The [src] is already loaded."))
		else
			user.remove_from_mob(attacking_item)
			attacking_item.forceMove(src)
			beaker = attacking_item
			updateUsrDialog()
		. = TRUE
	else if(processing)
		to_chat(user, SPAN_NOTICE("\The [src] is currently processing."))
		. = TRUE
	else if(istype(attacking_item, /obj/item/storage/bag/plants))
		var/i = 0
		var/obj/item/storage/bag/P = attacking_item
		for(var/obj/item/reagent_containers/food/snacks/G in contents)
			i++
		if(i >= capacity)
			to_chat(user, SPAN_NOTICE("\The [src] is already full! Activate it."))
		else
			for(var/obj/item/reagent_containers/food/snacks/G in P.contents)
				P.remove_from_storage(G,src)
				i++
				if(i >= capacity)
					to_chat(user, SPAN_NOTICE("You fill \the [src] to its capacity."))
					break

				CHECK_TICK

			if(i < capacity)
				to_chat(user, SPAN_NOTICE("You empty \the [attacking_item] into \the [src]."))
		. = TRUE
	else if(!istype(attacking_item, /obj/item/reagent_containers/food/snacks))
		to_chat(user, SPAN_NOTICE("You cannot put this in \the [src]."))
		. = TRUE
	else
		var/i = 0
		for(var/obj/item/reagent_containers/food/snacks/G in contents)
			i++
		if(i >= capacity)
			to_chat(user, SPAN_NOTICE("\The [src] is full! Activate it."))
		else
			user.remove_from_mob(attacking_item)
			attacking_item.forceMove(src)
			to_chat(user, SPAN_NOTICE("You put \the [attacking_item] in \the [src]"))
			. = TRUE
	update_icon()

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
					dat += "<tr><td colspan='2'><A href='byond://?src=[REF(src)];action=activate'>Activate Biogenerator</A></td></tr>"
					dat += "<tr><td colspan='2'><A href='byond://?src=[REF(src)];action=detach'>Detach Container</A><BR></td></tr>"
					dat += "<tr><td colspan='2'>Name</td><td colspan='2'>Cost</td><td colspan='4'>Production Amount</td></tr>"
					var/lastclass = "Commands"

					for (var/k in GET_SINGLETON_SUBTYPE_MAP(/singleton/biorecipe))
						var/singleton/biorecipe/current_recipe = GET_SINGLETON(k)

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
									dat += "<A href='byond://?src=[REF(src)];action=create;itemtype=[current_recipe.type];count=[num]'>([fakenum][num])</A>"
							dat += "</td>"
							dat += "</tr>"

					dat += "</table>"

				else
					dat += "<BR><FONT COLOR=red>No beaker inside. Please insert a beaker.</FONT><BR>"
			if("nopoints")
				dat += "You do not have biomass to create products.<BR>Please put growns into the reactor and activate it.<BR>"
				dat += "<A href='byond://?src=[REF(src)];action=menu'>Return to menu</A>"
			if("complete")
				dat += "Operation complete.<BR>"
				dat += "<A href='byond://?src=[REF(src)];action=menu'>Return to menu</A>"
			if("void")
				dat += "<FONT COLOR=red>Error: No growns inside.</FONT><BR>Please put growns into the reactor.<BR>"
				dat += "<A href='byond://?src=[REF(src)];action=menu'>Return to menu</A>"
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
	for(var/obj/item/reagent_containers/food/snacks/I in contents)
		S += 5
		if(REAGENT_VOLUME(I.reagents, /singleton/reagent/nutriment) < 0.1)
			points += 1
		else points += REAGENT_VOLUME(I.reagents, /singleton/reagent/nutriment) * 10 * eat_eff
		qdel(I)
		CHECK_TICK
	if(S)
		processing = 1
		update_icon()
		updateUsrDialog()
		playsound(src.loc, 'sound/machines/juicer.ogg', 50, 1)
		intent_message(MACHINE_SOUND)
		use_power_oneoff(S * 30)
		sleep((S + 1.5 SECONDS) / eat_eff)
		processing = 0
		update_icon()
	else
		menustat = "void"
	return

/obj/machinery/biogenerator/proc/create_product(var/itemtype, var/count)
	if (!ispath(itemtype, /singleton/biorecipe))
		return FALSE

	var/singleton/biorecipe/recipe = GET_SINGLETON(itemtype)

	if (!ispath(recipe.object)) // this shouldn't happen unless someone tries to create /singleton/biorecipe with href hacking
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
	for(var/i = 1; i <= count; i++)
		updateUsrDialog()
		if(totake > points)
			processing = FALSE
			menustat = "nopoints"
			update_icon()
			return FALSE
		else
			points -= totake
			use_power_oneoff(totake * 0.25)
			playsound(src.loc, /singleton/sound_category/switch_sound, 50, 1)
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
				use_power_oneoff(subtract_amount * 0.25)
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
