#define ICECREAM_VANILLA 1
#define ICECREAM_CHOCOLATE 2
#define ICECREAM_STRAWBERRY 3
#define ICECREAM_BLUE 4
#define ICECREAM_CHERRY 5
#define ICECREAM_BANANA 6
#define CONE_WAFFLE 7
#define CONE_CHOC 8

// Ported wholesale from Apollo Station.

/obj/machinery/icecream_vat
	name = "icecream vat"
	desc = "Ding-aling ding dong. Get your SCC-approved ice cream!"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "icecream_vat"
	density = 1
	anchored = 0
	use_power = POWER_USE_OFF
	flags = OPENCONTAINER | NOREACT

	var/list/product_types = list()
	var/dispense_flavour = ICECREAM_VANILLA
	var/flavour_name = "vanilla"
	reagents_to_add = list(
		/singleton/reagent/drink/milk = 5,
		/singleton/reagent/nutriment/flour = 5,
		/singleton/reagent/sugar = 5,
		/singleton/reagent/drink/ice = 5
	)

/obj/machinery/icecream_vat/proc/get_ingredient_list(var/type)
	switch(type)
		if(ICECREAM_CHOCOLATE)
			return list(/singleton/reagent/drink/milk, /singleton/reagent/drink/ice, /singleton/reagent/nutriment/coco)
		if(ICECREAM_STRAWBERRY)
			return list(/singleton/reagent/drink/milk, /singleton/reagent/drink/ice, /singleton/reagent/drink/berryjuice)
		if(ICECREAM_BLUE)
			return list(/singleton/reagent/drink/milk, /singleton/reagent/drink/ice, /singleton/reagent/alcohol/singulo)
		if(ICECREAM_CHERRY)
			return list(/singleton/reagent/drink/milk, /singleton/reagent/drink/ice, /singleton/reagent/nutriment/cherryjelly)
		if(ICECREAM_BANANA)
			return list(/singleton/reagent/drink/milk, /singleton/reagent/drink/ice, /singleton/reagent/drink/banana)
		if(CONE_WAFFLE)
			return list(/singleton/reagent/nutriment/flour, /singleton/reagent/sugar)
		if(CONE_CHOC)
			return list(/singleton/reagent/nutriment/flour, /singleton/reagent/sugar, /singleton/reagent/nutriment/coco)
		else
			return list(/singleton/reagent/drink/milk, /singleton/reagent/drink/ice)

/obj/machinery/icecream_vat/proc/get_flavour_name(var/flavour_type)
	switch(flavour_type)
		if(ICECREAM_CHOCOLATE)
			return "chocolate"
		if(ICECREAM_STRAWBERRY)
			return "strawberry"
		if(ICECREAM_BLUE)
			return "blue"
		if(ICECREAM_CHERRY)
			return "cherry"
		if(ICECREAM_BANANA)
			return "banana"
		if(CONE_WAFFLE)
			return "waffle"
		if(CONE_CHOC)
			return "chocolate"
		else
			return "vanilla"

/obj/machinery/icecream_vat/Initialize()
	. = ..()
	create_reagents(100)
	while(length(product_types) < CONE_CHOC)
		product_types.Add(5)

/obj/machinery/icecream_vat/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/machinery/icecream_vat/interact(mob/user as mob)
	var/dat
	dat += "<b>ICECREAM</b><br><div class='statusDisplay'>"
	dat += "<b>Dispensing: [flavour_name] icecream </b> <br><br>"
	dat += "<b>Vanilla icecream:</b> <a href='?src=\ref[src];select=[ICECREAM_VANILLA]'><b>Select</b></a> <a href='?src=\ref[src];make=[ICECREAM_VANILLA];amount=1'><b>Make</b></a> <a href='?src=\ref[src];make=[ICECREAM_VANILLA];amount=5'><b>x5</b></a> [product_types[ICECREAM_VANILLA]] scoops left. (Ingredients: milk, ice)<br>"
	dat += "<b>Strawberry icecream:</b> <a href='?src=\ref[src];select=[ICECREAM_STRAWBERRY]'><b>Select</b></a> <a href='?src=\ref[src];make=[ICECREAM_STRAWBERRY];amount=1'><b>Make</b></a> <a href='?src=\ref[src];make=[ICECREAM_STRAWBERRY];amount=5'><b>x5</b></a> [product_types[ICECREAM_STRAWBERRY]] dollops left. (Ingredients: milk, ice, berry juice)<br>"
	dat += "<b>Chocolate icecream:</b> <a href='?src=\ref[src];select=[ICECREAM_CHOCOLATE]'><b>Select</b></a> <a href='?src=\ref[src];make=[ICECREAM_CHOCOLATE];amount=1'><b>Make</b></a> <a href='?src=\ref[src];make=[ICECREAM_CHOCOLATE];amount=5'><b>x5</b></a> [product_types[ICECREAM_CHOCOLATE]] dollops left. (Ingredients: milk, ice, coco powder)<br>"
	dat += "<b>Blue icecream:</b> <a href='?src=\ref[src];select=[ICECREAM_BLUE]'><b>Select</b></a> <a href='?src=\ref[src];make=[ICECREAM_BLUE];amount=1'><b>Make</b></a> <a href='?src=\ref[src];make=[ICECREAM_BLUE];amount=5'><b>x5</b></a> [product_types[ICECREAM_BLUE]] dollops left. (Ingredients: milk, ice, singulo)<br>"
	dat += "<b>Cherry icecream:</b> <a href='?src=\ref[src];select=[ICECREAM_CHERRY]'><b>Select</b></a> <a href='?src=\ref[src];make=[ICECREAM_CHERRY];amount=1'><b>Make</b></a> <a href='?src=\ref[src];make=[ICECREAM_CHERRY];amount=5'><b>x5</b></a> [product_types[ICECREAM_CHERRY]] dollops left. (Ingredients: milk, ice, cherry jelly)<br>"
	dat += "<b>Banana icecream:</b> <a href='?src=\ref[src];select=[ICECREAM_BANANA]'><b>Select</b></a> <a href='?src=\ref[src];make=[ICECREAM_BANANA];amount=1'><b>Make</b></a> <a href='?src=\ref[src];make=[ICECREAM_BANANA];amount=5'><b>x5</b></a> [product_types[ICECREAM_BANANA]] dollops left. (Ingredients: milk, ice, banana)<br></div>"
	dat += "<br><b>CONES</b><br><div class='statusDisplay'>"
	dat += "<b>Waffle cones:</b> <a href='?src=\ref[src];cone=[CONE_WAFFLE]'><b>Dispense</b></a> <a href='?src=\ref[src];make=[CONE_WAFFLE];amount=1'><b>Make</b></a> <a href='?src=\ref[src];make=[CONE_WAFFLE];amount=5'><b>x5</b></a> [product_types[CONE_WAFFLE]] cones left. (Ingredients: flour, sugar)<br>"
	dat += "<b>Chocolate cones:</b> <a href='?src=\ref[src];cone=[CONE_CHOC]'><b>Dispense</b></a> <a href='?src=\ref[src];make=[CONE_CHOC];amount=1'><b>Make</b></a> <a href='?src=\ref[src];make=[CONE_CHOC];amount=5'><b>x5</b></a> [product_types[CONE_CHOC]] cones left. (Ingredients: flour, sugar, coco powder)<br></div>"
	dat += "<br>"
	dat += "<b>VAT CONTENT</b><br>"
	for(var/_R in reagents.reagent_volumes)
		var/singleton/reagent/R = GET_SINGLETON(_R)
		dat += "[R.name]: [reagents.reagent_volumes[_R]]"
		dat += "<A href='?src=\ref[src];disposeI=[_R]'>Purge</A><BR>"
	dat += "<a href='?src=\ref[src];refresh=1'>Refresh</a> <a href='?src=\ref[src];close=1'>Close</a>"

	var/datum/browser/popup = new(user, "icecreamvat","Icecream Vat", 700, 500, src)
	popup.set_content(dat)
	popup.open()

/obj/machinery/icecream_vat/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/reagent_containers/food/snacks/icecream))
		var/obj/item/reagent_containers/food/snacks/icecream/I = O
		if(!I.ice_creamed)
			if(product_types[dispense_flavour] > 0)
				visible_message("\icon[src] <b>[user]</b> scoops [flavour_name] icecream into [I].")
				product_types[dispense_flavour]--
				I.add_ice_cream(flavour_name)
			//	if(beaker)
			//		beaker.reagents.trans_to(I, 10)
				if(I.reagents.total_volume < 10)
					I.reagents.add_reagent(/singleton/reagent/sugar, 10 - I.reagents.total_volume, temperature = T0C - 15)
					I.reagents.reagent_data = list(/singleton/reagent/nutriment = list("[flavour_name]" = 10))
			else
				to_chat(user, SPAN_WARNING("There is not enough icecream left!"))
		else
			to_chat(user, SPAN_NOTICE("[O] already has icecream in it."))
		return TRUE
	else if(O.is_open_container())
		return
	..()

/obj/machinery/icecream_vat/proc/make(var/mob/user, var/make_type, var/amount)
	for(var/R in get_ingredient_list(make_type))
		if(reagents.has_reagent(R, amount))
			continue
		amount = 0
		break
	if(amount)
		for(var/R in get_ingredient_list(make_type))
			reagents.remove_reagent(R, amount)
		product_types[make_type] += amount
		var/flavour = get_flavour_name(make_type)
		if(make_type > 6)
			visible_message("<b>[user]</b> cooks up some [flavour] cones.")
		else
			visible_message("<b>[user]</b> whips up some [flavour] icecream.")
	else
		to_chat(user, SPAN_WARNING("You don't have the ingredients to make this."))

/obj/machinery/icecream_vat/Topic(href, href_list)

	if(..())
		return

	if(href_list["select"])
		dispense_flavour = text2num(href_list["select"])
		flavour_name = get_flavour_name(dispense_flavour)
		visible_message("<b>[usr]</b> sets [src] to dispense [flavour_name] flavoured icecream.")

	if(href_list["cone"])
		var/dispense_cone = text2num(href_list["cone"])
		var/cone_name = get_flavour_name(dispense_cone)
		if(product_types[dispense_cone] <= 1)
			to_chat(usr, SPAN_WARNING("There are no [cone_name] cones left!"))
			return
		product_types[dispense_cone]--
		var/obj/item/reagent_containers/food/snacks/icecream/I = new(loc)
		I.cone_type = cone_name
		I.icon_state = "icecream_cone_[cone_name]"
		I.desc = "Delicious [cone_name] cone, but no ice cream."
		visible_message("<b>[usr]</b> dispenses a crunchy [cone_name] cone from [src].")

	if(href_list["make"])
		var/amount = (text2num(href_list["amount"]))
		var/C = text2num(href_list["make"])
		make(usr, C, amount)

	if(href_list["disposeI"])
		reagents.del_reagent(href_list["disposeI"])

	updateDialog()

	if(href_list["refresh"])
		updateDialog()

	if(href_list["close"])
		usr.unset_machine()
		show_browser(usr, null,"window=icecreamvat")
	return

/obj/item/reagent_containers/food/snacks/icecream
	name = "ice cream cone"
	desc = "Delicious waffle cone, but no ice cream."
	icon_state = "icecream_cone_waffle" //default for admin-spawned cones, href_list["cone"] should overwrite this all the time
	layer = 3.1
	bitesize = 3
	volume = 20
	reagents_to_add = list(/singleton/reagent/nutriment = 5)
	var/ice_creamed = 0
	var/cone_type

/obj/item/reagent_containers/food/snacks/icecream/proc/add_ice_cream(var/flavour_name)
	name = "[flavour_name] icecream"
	add_overlay("icecream_[flavour_name]")
	desc = "Delicious [cone_type] cone with a dollop of [flavour_name] ice cream."
	ice_creamed = 1

#undef ICECREAM_VANILLA
#undef ICECREAM_CHOCOLATE
#undef ICECREAM_STRAWBERRY
#undef ICECREAM_BLUE
#undef ICECREAM_CHERRY
#undef ICECREAM_BANANA
#undef CONE_WAFFLE
#undef CONE_CHOC
