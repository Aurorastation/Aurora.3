
/obj/machinery/microwave
	name = "Microwave"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "mw"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 2000
	flags = OPENCONTAINER | NOREACT
	var/operating = 0 // Is it on?
	var/dirty = 0 // = {0..100} Does it need cleaning?
	var/broken = 0 // ={0,1,2} How broken is it???
	var/global/list/acceptable_items // List of the items you can put in
	var/global/list/acceptable_reagents // List of the reagents you can put in
	var/global/max_n_of_items = 20
	var/appliancetype = MICROWAVE
	var/datum/looping_sound/microwave/soundloop

	component_types = list(
			/obj/item/circuitboard/microwave,
			/obj/item/stock_parts/capacitor = 3,
			/obj/item/stock_parts/scanning_module,
			/obj/item/stock_parts/matter_bin = 2
		)

// see code/modules/food/recipes_microwave.dm for recipes

/*******************
*   Initialising
********************/

/obj/machinery/microwave/Initialize(mapload)
	. = ..(mapload, 0, FALSE) // shadow-realm the parts for now, jimbo
	reagents = new/datum/reagents(100)
	reagents.my_atom = src
	soundloop = new(list(src), FALSE)
	if (mapload)
		addtimer(CALLBACK(src, .proc/setup_recipes), 0)
	else
		setup_recipes()

/obj/machinery/microwave/proc/setup_recipes()
	if (!LAZYLEN(acceptable_items))
		acceptable_items = list()
		acceptable_reagents = list()
		for (var/datum/recipe/recipe in RECIPE_LIST(appliancetype))
			for (var/item in recipe.items)
				acceptable_items[item] = TRUE

			for (var/reagent in recipe.reagents)
				acceptable_reagents[reagent] = TRUE

		// This will do until I can think of a fun recipe to use dionaea in -
		// will also allow anything using the holder item to be microwaved into
		// impure carbon. ~Z
		acceptable_items[/obj/item/holder] = TRUE
		acceptable_items[/obj/item/reagent_containers/food/snacks/grown] = TRUE

/*******************
*   Item Adding
********************/

/obj/machinery/microwave/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(src.broken > 0)
		if(src.broken == 2 && O.isscrewdriver()) // If it's broken and they're using a screwdriver
			user.visible_message( \
				"<span class='notice'>\The [user] starts to fix part of the microwave.</span>", \
				"<span class='notice'>You start to fix part of the microwave.</span>" \
			)
			if (do_after(user,20/O.toolspeed))
				user.visible_message( \
					"<span class='notice'>\The [user] fixes part of the microwave.</span>", \
					"<span class='notice'>You have fixed part of the microwave.</span>" \
				)
				src.broken = 1 // Fix it a bit
		else if(src.broken == 1 && O.iswrench()) // If it's broken and they're doing the wrench
			user.visible_message( \
				"<span class='notice'>\The [user] starts to fix part of the microwave.</span>", \
				"<span class='notice'>You start to fix part of the microwave.</span>" \
			)
			if (do_after(user,20/O.toolspeed))
				user.visible_message( \
					"<span class='notice'>\The [user] fixes the microwave.</span>", \
					"<span class='notice'>You have fixed the microwave.</span>" \
				)
				src.icon_state = "mw"
				src.broken = 0 // Fix it!
				src.dirty = 0 // just to be sure
				src.flags = OPENCONTAINER | NOREACT
		else
			to_chat(user, "<span class='warning'>It's broken!</span>")
			return 1
	else if(src.dirty==100) // The microwave is all dirty so can't be used!
		if(istype(O, /obj/item/reagent_containers/spray/cleaner) || istype(O, /obj/item/soap)) // If they're trying to clean it then let them
			user.visible_message( \
				"<span class='notice'>\The [user] starts to clean the microwave.</span>", \
				"<span class='notice'>You start to clean the microwave.</span>" \
			)
			if (do_after(user,20/O.toolspeed))
				user.visible_message( \
					"<span class='notice'>\The [user] has cleaned the microwave.</span>", \
					"<span class='notice'>You have cleaned the microwave.</span>" \
				)
				src.dirty = 0 // It's clean!
				src.broken = 0 // just to be sure
				src.icon_state = "mw"
				src.flags = OPENCONTAINER | NOREACT
		else //Otherwise bad luck!!
			to_chat(user, "<span class='warning'>It's dirty!</span>")
			return 1
	else if(is_type_in_list(O,acceptable_items))
		if (contents.len>=max_n_of_items)
			to_chat(user, "<span class='warning'>This [src] is full of ingredients, you cannot put more.</span>")
			return 1
		if(istype(O, /obj/item/stack) && O:get_amount() > 1) // This is bad, but I can't think of how to change it
			var/obj/item/stack/S = O
			new O.type (src)
			S.use(1)
			user.visible_message( \
				"<span class='notice'>\The [user] has added one of [O] to \the [src].</span>", \
				"<span class='notice'>You add one of [O] to \the [src].</span>")
			return
		else
		//	user.remove_from_mob(O)	//This just causes problems so far as I can tell. -Pete
			user.drop_from_inventory(O,src)
			user.visible_message( \
				"<span class='notice'>\The [user] has added \the [O] to \the [src].</span>", \
				"<span class='notice'>You add \the [O] to \the [src].</span>")
			return
	else if(istype(O,/obj/item/reagent_containers/glass) || \
	        istype(O,/obj/item/reagent_containers/food/drinks) || \
	        istype(O,/obj/item/reagent_containers/food/condiment) \
		)
		if (!O.reagents)
			return 1
		for (var/datum/reagent/R in O.reagents.reagent_list)
			if (!(R.id in acceptable_reagents))
				to_chat(user, "<span class='warning'>Your [O] contains components unsuitable for cookery.</span>")
				return 1
		return
	else if(istype(O,/obj/item/grab))
		var/obj/item/grab/G = O
		to_chat(user, "<span class='warning'>This is ridiculous. You can not fit \the [G.affecting] in this [src].</span>")
		return 1
	else if(O.isscrewdriver())
		default_deconstruction_screwdriver(user, O)
		return
	else if(O.iscrowbar())
		if(default_deconstruction_crowbar(user, O))
			return
		else
			user.visible_message( \
				"<span class='notice'>\The [user] begins [src.anchored ? "unsecuring" : "securing"] the microwave.</span>", \
				"<span class='notice'>You attempt to [src.anchored ? "unsecure" : "secure"] the microwave.</span>"
				)
			if (do_after(user,20/O.toolspeed))
				user.visible_message( \
				"<span class='notice'>\The [user] [src.anchored ? "unsecures" : "secures"] the microwave.</span>", \
				"<span class='notice'>You [src.anchored ? "unsecure" : "secure"] the microwave.</span>"
				)
				src.anchored = !src.anchored
			else
				to_chat(user, "<span class='notice'>You decide not to do that.</span>")
	else if(default_part_replacement(user, O))
		return
	else

		to_chat(user, "<span class='warning'>You have no idea what you can cook with this [O].</span>")
	..()
	src.updateUsrDialog()

/obj/machinery/microwave/attack_ai(mob/user as mob)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user))
		attack_hand(user)

/obj/machinery/microwave/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/*******************
*   Microwave Menu
********************/

/obj/machinery/microwave/interact(mob/user as mob) // The microwave Menu
	var/dat = ""
	if(src.broken > 0)
		dat = {"<TT>Bzzzzttttt</TT>"}
	else if(src.operating)
		dat = {"<TT>Microwaving in progress!<BR>Please wait...!</TT>"}
	else if(src.dirty==100)
		dat = {"<TT>This microwave is dirty!<BR>Please clean it before use!</TT>"}
	else
		var/list/items_counts = new
		var/list/items_measures = new
		var/list/items_measures_p = new
		for (var/obj/O in contents)
			var/display_name = O.name
			if (istype(O,/obj/item/reagent_containers/food/snacks/egg))
				items_measures[display_name] = "egg"
				items_measures_p[display_name] = "eggs"
			if (istype(O,/obj/item/reagent_containers/food/snacks/tofu))
				items_measures[display_name] = "tofu chunk"
				items_measures_p[display_name] = "tofu chunks"
			if (istype(O,/obj/item/reagent_containers/food/snacks/meat)) //any meat
				items_measures[display_name] = "slab of meat"
				items_measures_p[display_name] = "slabs of meat"
			if (istype(O,/obj/item/reagent_containers/food/snacks/donkpocket))
				display_name = "Turnovers"
				items_measures[display_name] = "turnover"
				items_measures_p[display_name] = "turnovers"
			if (istype(O,/obj/item/reagent_containers/food/snacks/carpmeat))
				items_measures[display_name] = "fillet of meat"
				items_measures_p[display_name] = "fillets of meat"
			items_counts[display_name]++
		for (var/O in items_counts)
			var/N = items_counts[O]
			if (!(O in items_measures))
				dat += {"<B>[capitalize(O)]:</B> [N] [lowertext(O)]\s<BR>"}
			else
				if (N==1)
					dat += {"<B>[capitalize(O)]:</B> [N] [items_measures[O]]<BR>"}
				else
					dat += {"<B>[capitalize(O)]:</B> [N] [items_measures_p[O]]<BR>"}

		for (var/datum/reagent/R in reagents.reagent_list)
			var/display_name = R.name
			if (R.id == "capsaicin")
				display_name = "Hotsauce"
			if (R.id == "frostoil")
				display_name = "Coldsauce"
			dat += {"<B>[display_name]:</B> [R.volume] unit\s<BR>"}

		if (items_counts.len==0 && reagents.reagent_list.len==0)
			dat = {"<B>The microwave is empty</B><BR>"}
		else
			dat = {"<b>Ingredients:</b><br>[dat]"}
		dat += {"<HR><BR>\
<A href='?src=\ref[src];action=cook'>Turn on!<BR>\
<A href='?src=\ref[src];action=dispose'>Eject ingredients!<BR>\
"}

	user << browse("<HEAD><TITLE>Microwave Controls</TITLE></HEAD><TT>[dat]</TT>", "window=microwave")
	onclose(user, "microwave")
	return



/***********************************
*   Microwave Menu Handling/Cooking
************************************/

/obj/machinery/microwave/proc/cook()
	if(stat & (NOPOWER|BROKEN))
		return
	start()
	if (reagents.total_volume==0 && !(locate(/obj) in contents)) //dry run
		if (!wzhzhzh(16))
			abort()
			return
		stop()
		return

	var/datum/recipe/recipe = select_recipe(RECIPE_LIST(appliancetype),src)
	var/obj/cooked
	if (!recipe)
		dirty += 1
		if (prob(max(10,dirty*5)))
			if (!wzhzhzh(16))
				abort()
				return
			muck_start()
			wzhzhzh(16)
			muck_finish()
			cooked = fail()
			cooked.forceMove(src.loc)
			return
		else if (has_extra_item())
			if (!wzhzhzh(16))
				abort()
				return
			broke()
			cooked = fail()
			cooked.forceMove(src.loc)
			return
		else
			if (!wzhzhzh(40))
				abort()
				return
			stop()
			cooked = fail()
			cooked.forceMove(src.loc)
			return
	else
		var/halftime = round((recipe.time*4)/10/2)
		if (!wzhzhzh(halftime))
			abort()
			return
		if (!wzhzhzh(halftime))
			abort()
			cooked = fail()
			cooked.forceMove(src.loc)
			return


		//Making multiple copies of a recipe
		var/result = recipe.result
		var/valid = 1
		var/list/cooked_items = list()
		var/obj/temp = new /obj(src) //To prevent infinite loops, all results will be moved into a temporary location so they're not considered as inputs for other recipes
		while(valid)
			var/list/things = list()
			things.Add(recipe.make_food(src))
			cooked_items += things
			//Move cooked things to the buffer so they're not considered as ingredients
			for (var/atom/movable/AM in things)
				AM.forceMove(temp)

			valid = 0
			recipe = select_recipe(RECIPE_LIST(appliancetype),src)
			if (recipe && recipe.result == result)
				sleep(2)
				valid = 1

		for (var/r in cooked_items)
			var/atom/movable/R = r
			R.forceMove(src) //Move everything from the buffer back to the container

		qdel(temp)//Delete buffer object
		temp = null

		//Any leftover reagents are divided amongst the foods
		var/total = reagents.total_volume
		for (var/obj/item/reagent_containers/food/snacks/S in cooked_items)
			reagents.trans_to_holder(S.reagents, total/cooked_items.len)

		for (var/obj/item/reagent_containers/food/snacks/S in contents)
			S.cook()

		dispose(0) //clear out anything left
		stop()

		return

/obj/machinery/microwave/proc/wzhzhzh(var/seconds as num) // Whoever named this proc is fucking literally Satan. ~ Z
	for (var/i=1 to seconds)
		if (stat & (NOPOWER|BROKEN))
			return 0
		use_power(active_power_usage)
		sleep(10)
	return 1

/obj/machinery/microwave/proc/has_extra_item()
	for (var/obj/O in contents)
		if ( \
				!istype(O,/obj/item/reagent_containers/food) && \
				!istype(O, /obj/item/grown) \
			)
			return 1
	return 0

/obj/machinery/microwave/proc/start()
	src.visible_message("<span class='notice'>The microwave turns on.</span>", "<span class='notice'>You hear a microwave.</span>")
	src.operating = 1
	src.icon_state = "mw1"
	src.updateUsrDialog()
	set_light(1.5)
	soundloop.start()

/obj/machinery/microwave/proc/abort()
	after_finish_loop()
	src.operating = 0 // Turn it off again aferwards
	src.icon_state = "mw"
	src.updateUsrDialog()

/obj/machinery/microwave/proc/stop()
	after_finish_loop()
	src.operating = 0 // Turn it off again aferwards
	src.icon_state = "mw"
	src.updateUsrDialog()

/obj/machinery/microwave/proc/dispose(var/message = 1)
	for (var/atom/movable/A in contents)
		A.forceMove(loc)
	if (src.reagents.total_volume)
		src.dirty++
	src.reagents.clear_reagents()
	if (message)
		to_chat(usr, "<span class='notice'>You dispose of the microwave contents.</span>")
	src.updateUsrDialog()

/obj/machinery/microwave/proc/muck_start()
	playsound(src.loc, 'sound/effects/splat.ogg', 50, 1) // Play a splat sound
	src.icon_state = "mwbloody1" // Make it look dirty!!

/obj/machinery/microwave/proc/muck_finish()
	after_finish_loop()
	src.visible_message("<span class='warning'>The microwave gets covered in muck!</span>")
	src.dirty = 100 // Make it dirty so it can't be used util cleaned
	src.flags = null //So you can't add condiments
	src.icon_state = "mwbloody" // Make it look dirty too
	src.operating = 0 // Turn it off again aferwards
	src.updateUsrDialog()

/obj/machinery/microwave/proc/broke()
	after_finish_loop()
	spark(src, 2, alldirs)
	src.icon_state = "mwb" // Make it look all busted up and shit
	src.visible_message("<span class='warning'>The microwave breaks!</span>") //Let them know they're stupid
	src.broken = 2 // Make it broken so it can't be used util fixed
	src.flags = null //So you can't add condiments
	src.operating = 0 // Turn it off again aferwards
	src.updateUsrDialog()

/obj/machinery/microwave/proc/fail()
	after_finish_loop()
	var/obj/item/reagent_containers/food/snacks/badrecipe/ffuu = new(src)
	var/amount = 0
	for (var/obj/O in contents-ffuu)
		amount++
		if (O.reagents)
			var/id = O.reagents.get_master_reagent_id()
			if (id)
				amount+=O.reagents.get_reagent_amount(id)
		qdel(O)
	src.reagents.clear_reagents()
	ffuu.reagents.add_reagent("carbon", amount)
	ffuu.reagents.add_reagent("toxin", amount/10)
	return ffuu

/obj/machinery/microwave/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	if(src.operating)
		src.updateUsrDialog()
		return

	switch(href_list["action"])
		if ("cook")
			cook()

		if ("dispose")
			dispose()
	return

/obj/machinery/microwave/verb/Eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject content"
	usr.visible_message(
	"<span class='notice'>[usr] is trying to open [src] to take out its content.</span>" ,
	"<span class='notice'>You are trying to open [src] to take out its content</span>"
	)

	if (!do_after(usr, 1 SECONDS, act_target = src))
		return

	usr.visible_message(
	"<span class='notice'>[usr] opened [src] and has taken out [english_list(contents)].</span>" ,
	"<span class='notice'>You have opened [src] and taken out [english_list(contents)].</span>"
	)
	dispose()

/obj/machinery/microwave/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (!mover)
		return 1
	if(mover.checkpass(PASSTABLE))
	//Animals can run under them, lots of empty space
		return 1
	return ..()

/obj/machinery/microwave/proc/after_finish_loop()
	set_light(0)
	soundloop.stop()
	update_icon()