/obj/machinery/microwave
	name = "microwave"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "mw"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 2000
	flags = OPENCONTAINER | NOREACT
	var/operating = FALSE // Is it on?
	var/dirty = 0 // = {0..100} Does it need cleaning?
	var/broken = 0 // ={0,1,2} How broken is it???
	var/global/list/acceptable_items // List of the items you can put in
	var/global/list/acceptable_reagents // List of the reagents you can put in
	var/global/max_n_of_items = 20
	var/list/acceptable_containers = list(
		/obj/item/weapon/reagent_containers/glass,
		/obj/item/weapon/reagent_containers/food/drinks,
		/obj/item/weapon/reagent_containers/food/condiment
	)
	var/appliancetype = MICROWAVE
	var/abort = FALSE
	var/datum/looping_sound/microwave/soundloop

	component_types = list(
			/obj/item/weapon/circuitboard/microwave,
			/obj/item/weapon/stock_parts/capacitor = 3,
			/obj/item/weapon/stock_parts/scanning_module,
			/obj/item/weapon/stock_parts/matter_bin = 2
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
		acceptable_items[/obj/item/weapon/holder] = TRUE
		acceptable_items[/obj/item/weapon/reagent_containers/food/snacks/grown] = TRUE

/*******************
*   Item Adding
********************/

/obj/machinery/microwave/proc/add_item(var/obj/item/I as obj, var/mob/user as mob)
	user.drop_from_inventory(I, src)
	user.visible_message( \
		"<span class='notice'>\The [user] has added one of [I] to \the [src].</span>", \
		"<span class='notice'>You add one of [I] to \the [src].</span>")
	SSvueui.check_uis_for_change(src)

/obj/machinery/microwave/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(broken > 0)
		if(broken == 2 && O.isscrewdriver()) // If it's broken and they're using a screwdriver
			user.visible_message( \
				"<span class='notice'>\The [user] starts to fix part of the microwave.</span>", \
				"<span class='notice'>You start to fix part of the microwave.</span>" \
			)
			if (do_after(user,20/O.toolspeed))
				user.visible_message( \
					"<span class='notice'>\The [user] fixes part of the microwave.</span>", \
					"<span class='notice'>You have fixed part of the microwave.</span>" \
				)
				broken = 1 // Fix it a bit
		else if(broken == 1 && O.iswrench()) // If it's broken and they're doing the wrench
			user.visible_message( \
				"<span class='notice'>\The [user] starts to fix part of the microwave.</span>", \
				"<span class='notice'>You start to fix part of the microwave.</span>" \
			)
			if (do_after(user,20/O.toolspeed))
				user.visible_message( \
					"<span class='notice'>\The [user] fixes the microwave.</span>", \
					"<span class='notice'>You have fixed the microwave.</span>" \
				)
				icon_state = "mw"
				broken = 0 // Fix it!
				dirty = 0 // just to be sure
				flags = OPENCONTAINER | NOREACT
		else
			to_chat(user, "<span class='warning'>It's broken!</span>")
			return 1
	else if(dirty==100) // The microwave is all dirty so can't be used!
		if(istype(O, /obj/item/weapon/reagent_containers/spray/cleaner) || istype(O, /obj/item/weapon/soap)) // If they're trying to clean it then let them
			user.visible_message( \
				"<span class='notice'>\The [user] starts to clean the microwave.</span>", \
				"<span class='notice'>You start to clean the microwave.</span>" \
			)
			if (do_after(user,20/O.toolspeed))
				user.visible_message( \
					"<span class='notice'>\The [user] has cleaned the microwave.</span>", \
					"<span class='notice'>You have cleaned the microwave.</span>" \
				)
				dirty = 0 // It's clean!
				broken = 0 // just to be sure
				icon_state = "mw"
				flags = OPENCONTAINER | NOREACT
		else //Otherwise bad luck!!
			to_chat(user, "<span class='warning'>It's dirty!</span>")
			return 1
	else if(is_type_in_list(O,acceptable_items))
		if (contents.len>=max_n_of_items)
			to_chat(user, "<span class='warning'>This [src] is full of ingredients, you can't fit any more!</span>")
			return 1
		if(istype(O, /obj/item/stack))
			var/obj/item/stack/S = O
			if(S.get_amount() > 1)
				new O.type (src)
				S.use(1)
				user.visible_message( \
					"<span class='notice'>\The [user] has added one of [O] to \the [src].</span>", \
					"<span class='notice'>You add one of [O] to \the [src].</span>")
				SSvueui.check_uis_for_change(src)
				return
			else
				add_item(O, user)
		else
			add_item(O, user)
			return
	else if(is_type_in_list(O, acceptable_containers))
		if (!O.reagents)
			return 1
		for (var/datum/reagent/R in O.reagents.reagent_list)
			if (!(R.id in acceptable_reagents))
				to_chat(user, "<span class='warning'>Your [O] contains components unsuitable for cookery.</span>")
				return 1
		return // Note to the future: reagents are added after this in the container's afterattack().
	else if(istype(O,/obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = O
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
	SSvueui.check_uis_for_change(src)
	..()

/obj/machinery/microwave/attack_ai(mob/user as mob)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user))
		attack_hand(user)

/obj/machinery/microwave/attack_hand(mob/user as mob)
	user.set_machine(src)
	if(broken > 0)
		to_chat(user, "<span class='warning'>\The [name] is broken! You'll need to fix it before using it.</span>")
	else if(dirty == 100)
		to_chat(user, "<span class='warning'>\The [name] is dirty! You'll need to clean it before using it.</span>")
	else
		ui_interact(user)

/*******************
*   Microwave Menu
********************/

VUEUI_MONITOR_VARS(/obj/machinery/microwave, microwavemonitor)
	watch_var("operating", "on", CALLBACK(null, .proc/transform_to_boolean, FALSE))

/obj/machinery/microwave/vueui_data_change(var/list/newdata, var/mob/user, var/datum/vueui/ui)
	var/monitordata = ..()
	if(monitordata)
		. = newdata = monitordata

	newdata["cookingobjs"] = list()
	newdata["cookingreas"] = list()

	VUEUI_SET_CHECK_IFNOTSET(newdata["cook_time"], 40, ., newdata)
	VUEUI_SET_CHECK_IFNOTSET(newdata["cur_time"], 0, ., newdata)

	if (contents && contents.len)
		var/list/cook_count = list()
		for (var/obj/O in contents)
			cook_count[O.name]++
		for (var/C in cook_count)
			newdata["cookingobjs"] += list(list("name" = "[C]", "qty" = "[cook_count[C]]"))
	if (reagents.reagent_list && reagents.reagent_list.len)
		for (var/datum/reagent/R in reagents.reagent_list)
			newdata["cookingreas"] += list(list("name" = "[R.name]", "amt" = "[R.volume]"))

	if(newdata["cookingobjs"] && contents && newdata["cookingobjs"].len != contents.len)
		. = newdata
	if(newdata["cookingreas"] && reagents.reagent_list && newdata["cookingreas"].len != reagents.reagent_list.len)
		. = newdata

/obj/machinery/microwave/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new(user, src, "cooking-microwave", 300, 300, capitalize(name))
	ui.open()

/***********************************
*   Microwave Menu Handling/Cooking
************************************/

/obj/machinery/microwave/proc/cook()
	if(stat & (NOPOWER|BROKEN))
		return

	if (reagents.get_reagents() && !(locate(/obj) in contents)) //dry run
		cook_for_time()
		return

	var/datum/recipe/recipe = select_recipe(RECIPE_LIST(appliancetype),src)
	var/default_time = 20
	if (!recipe)
		dirty += 1
		if (prob(max(10, dirty*5)))
			// It's dirty enough to mess up the microwave
			cook_for_time(default_time, TRUE, TRUE)
			return
		else if (has_extra_item())
			// Something's in the microwave that shouldn't be! Time to break!
			// Can this even happen?
			cook_for_time(default_time, TRUE, FALSE, TRUE)
			return
		else
			cook_for_time(default_time, TRUE)
			return
	else
		var/cooking_time = round((recipe.time*4)/10)
		if(!cook_for_time(cooking_time))
			return

		//Making multiple copies of a recipe
		var/result = recipe.result
		var/valid = TRUE
		var/list/cooked_items = list()
		var/obj/temp = new /obj(src) //To prevent infinite loops, all results will be moved into a temporary location so they're not considered as inputs for other recipes
		while(valid)
			var/list/things = list()
			things.Add(recipe.make_food(src))
			cooked_items += things
			//Move cooked things to the buffer so they're not considered as ingredients
			for (var/atom/movable/AM in things)
				AM.forceMove(temp)

			valid = FALSE
			recipe = select_recipe(RECIPE_LIST(appliancetype),src)
			if (recipe && recipe.result == result)
				sleep(2)
				valid = TRUE

		for (var/r in cooked_items)
			var/atom/movable/R = r
			R.forceMove(src) //Move everything from the buffer back to the container

		QDEL_NULL(temp)//Delete buffer object

		//Any leftover reagents are divided amongst the foods
		var/total = reagents.total_volume
		for (var/obj/item/weapon/reagent_containers/food/snacks/S in cooked_items)
			reagents.trans_to_holder(S.reagents, total/cooked_items.len)

		for (var/obj/item/weapon/reagent_containers/food/snacks/S in contents)
			S.cook()

		eject(0) //clear out anything left

		return

/obj/machinery/microwave/proc/cook_for_time(var/cook_time = 20, var/failed = FALSE, var/dirt = FALSE, var/broke = FALSE) // Formerly proc/wzhzhzh, may it rest in peace
	start(dirt)

	var/half_time = cook_time / 2
	var/obj/cooked
	for (var/i=1 to half_time)
		if ((stat & (NOPOWER|BROKEN)) || abort) // Safe to abort early on
			stop(dirt, broke)
			return FALSE
		else
			use_power(active_power_usage)
			update_cooking_ui(cook_time, i)
			sleep(10)

	playsound(src, 'sound/machines/click.ogg', 20, 1) // Mid-way through cooking 'click'

	for (var/j=half_time to cook_time)
		if ((stat & (NOPOWER|BROKEN)))
			stop()
			return FALSE
		else if(abort) // Not safe to abort anymore - egads, the roast is ruined!
			if(failed)
				cooked = fail()
				cooked.forceMove(loc)
			stop(dirt, broke)
			return FALSE
		else
			use_power(active_power_usage)
			update_cooking_ui(cook_time, j)
			sleep(10)

	if(failed)
		cooked = fail()
		cooked.forceMove(loc)
		stop(dirt, broke)
		return FALSE

	stop(dirt, broke)

	return TRUE

/obj/machinery/microwave/proc/update_cooking_ui(var/cook_time, var/cur_time)
	for(var/datum/vueui/ui in SSvueui.get_open_uis(src))
		ui.data["cook_time"] = cook_time
		ui.data["cur_time"] = cur_time
	SSvueui.check_uis_for_change(src)

/obj/machinery/microwave/proc/close_cooking_uis()
	for(var/datum/vueui/ui in SSvueui.get_open_uis(src))
		ui.close()

/obj/machinery/microwave/proc/has_extra_item()
	for (var/obj/O in contents)
		if ( \
				!istype(O,/obj/item/weapon/reagent_containers/food) && \
				!istype(O, /obj/item/weapon/grown) \
			)
			return 1
	return 0

/obj/machinery/microwave/proc/start(var/muck = FALSE)
	visible_message("<span class='notice'>The microwave turns on.</span>", "<span class='notice'>You hear a microwave.</span>")
	operating = TRUE
	if(muck)
		playsound(loc, 'sound/effects/splat.ogg', 50, 1) // Play a splat sound
		icon_state = "mwbloody1" // Make it look dirty!!
	else
		icon_state = "mw1"
	set_light(1.5)
	soundloop.start()

/obj/machinery/microwave/proc/stop(var/muck = FALSE, var/broken = FALSE)
	after_finish_loop()
	operating = FALSE // Turn it off again aferwards
	if(muck || broken)
		flags = null //So you can't add condiments
		close_cooking_uis() // Can't use this anymore!
	if(muck)
		visible_message("<span class='warning'>The microwave gets covered in muck!</span>")
		dirty = 100 // Make it dirty so it can't be used util cleaned
		icon_state = "mwbloody" // Make it look dirty too
	else if(broken)
		spark(src, 2, alldirs)
		icon_state = "mwb" // Make it look all busted up and shit
		visible_message("<span class='warning'>The microwave breaks!</span>") //Let them know they're stupid
		broken = 2 // Make it broken so it can't be used util fixed
	else
		icon_state = "mw"
	abort = FALSE
	SSvueui.check_uis_for_change(src)

/obj/machinery/microwave/proc/fail()
	var/obj/item/weapon/reagent_containers/food/snacks/badrecipe/ffuu = new(src)
	var/amount = 0
	for (var/obj/O in contents-ffuu)
		amount++
		if (O.reagents)
			var/id = O.reagents.get_master_reagent_id()
			if (id)
				amount+=O.reagents.get_reagent_amount(id)
		qdel(O)
	reagents.clear_reagents()
	SSvueui.check_uis_for_change(src)
	ffuu.reagents.add_reagent("carbon", amount)
	ffuu.reagents.add_reagent("toxin", amount/10)
	return ffuu

/obj/machinery/microwave/Topic(href, href_list)
	SSvueui.check_uis_for_change(src)
	if(..())
		return

	usr.set_machine(src)

	if(operating)
		if(href_list["abort"])
			abort = TRUE
		SSvueui.check_uis_for_change(src)
		return

	if(href_list["cook"])
		cook()
		SSvueui.check_uis_for_change(src)
	else if(href_list["eject_all"])
		eject()
	else if(href_list["eject"])
		for (var/datum/reagent/R in reagents.reagent_list)
			if(R.name == href_list["eject"])
				eject_reagent(R)
				break
		for (var/obj/O in contents)
			if(O.name == href_list["eject"])
				eject(0, O)
				break

	return

/obj/machinery/microwave/proc/eject_reagent(datum/reagent/R)
	if(istype(usr.l_hand, /obj/item/weapon/reagent_containers) || istype(usr.r_hand, /obj/item/weapon/reagent_containers))
		var/obj/item/weapon/reagent_containers/RC = usr.l_hand || usr.r_hand
		var/free_space = RC.reagents.get_free_space()
		if(free_space > R.volume)
			to_chat(usr, "<span class='notice'>You empty [R.volume] units of [R.name] into your [RC.name].</span>")
			RC.reagents.add_reagent(R.id, R.volume)
			reagents.remove_reagent(R.id, R.volume)
		else if(free_space == 0)
			to_chat(usr, "<span class='warning'>[RC.name] is full!</span>")
		else
			to_chat(usr, "<span class='notice'>You empty [free_space] units of [R.name] into your [RC.name].</span>")
			RC.reagents.add_reagent(R.id, free_space)
			reagents.remove_reagent(R.id, free_space)
		SSvueui.check_uis_for_change(src)
	else
		to_chat(usr, "<span class='warning'>You need to be holding a valid container to empty [R.name]!</span>")

/obj/machinery/microwave/proc/eject(var/message = 1, var/obj/EJ = null)
	if (EJ)
		EJ.forceMove(loc)
	else
		for (var/atom/movable/A in contents)
			A.forceMove(loc)
		if (reagents.total_volume)
			dirty++
		reagents.clear_reagents()
		if (message)
			to_chat(usr, "<span class='notice'>You dispose of the microwave contents.</span>")
	SSvueui.check_uis_for_change(src)

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