// This folder contains code that was originally ported from Apollo Station and then refactored/optimized/changed.

// Tracks precooked food to stop deep fried baked grilled grilled grilled diona nymph cereal.
/obj/item/weapon/reagent_containers/food/snacks
	var/tmp/list/cooked = list()

// Root type for cooking machines. See following files for specific implementations.
/obj/machinery/appliance
	name = "cooker"
	desc = "You shouldn't be seeing this!"
	icon = 'icons/obj/cooking_machines.dmi'
	var/appliancetype = 0
	density = 1
	anchored = 1

	use_power = 0
	idle_power_usage = 5			// Power used when turned on, but not processing anything
	active_power_usage = 1000		// Power used when turned on and actively cooking something
	var/initalactive_power_usage = 1000

	var/cooking_power  = 1
	var/inital_cooking_power  = 1
	var/max_contents = 1			// Maximum number of things this appliance can simultaneously cook
	var/on_icon						// Icon state used when cooking.
	var/off_icon					// Icon state used when not cooking.
	var/cooking						// Whether or not the machine is currently operating.
	var/cook_type					// A string value used to track what kind of food this machine makes.
	var/can_cook_mobs				// Whether or not this machine accepts grabbed mobs.
	var/mobdamagetype = BRUTE		// Burn damage for cooking appliances, brute for cereal/candy
	var/food_color					// Colour of resulting food item.
	var/cooked_sound = 'sound/machines/ding.ogg'				// Sound played when cooking completes.
	var/can_burn_food				// Can the object burn food that is left inside?
	var/burn_chance = 10			// How likely is the food to burn?
	var/list/cooking_objs = list()	// List of things being cooked

	// If the machine has multiple output modes, define them here.
	var/selected_option
	var/list/output_options = list()

	var/container_type = null

	var/combine_first = 0//If 1, this appliance will do combinaiton cooking before checking recipes

	component_types = list(
			/obj/item/weapon/circuitboard/cooking,
			/obj/item/weapon/stock_parts/capacitor = 3,
			/obj/item/weapon/stock_parts/scanning_module,
			/obj/item/weapon/stock_parts/matter_bin = 2
		)

/obj/machinery/appliance/Initialize()
	. = ..()
	if(output_options.len)
		verbs += /obj/machinery/appliance/proc/choose_output
	inital_cooking_power = cooking_power
	initalactive_power_usage = active_power_usage
/obj/machinery/appliance/Destroy()
	for (var/a in cooking_objs)
		var/datum/cooking_item/CI = a
		qdel(CI.container)//Food is fragile, it probably doesnt survive the destruction of the machine
		cooking_objs -= CI
		qdel(CI)
	return ..()

/obj/machinery/appliance/examine(var/mob/user)
	..()
	if(Adjacent(usr))
		list_contents(user)
		return 1

/obj/machinery/appliance/proc/list_contents(var/mob/user)
	if (cooking_objs.len)
		var/string = "Contains..."
		for (var/a in cooking_objs)
			var/datum/cooking_item/CI = a
			string += "-\a [CI.container.label(null, CI.combine_target)], [report_progress(CI)]</br>"
		usr << string
	else
		usr << span("notice","It is empty.")

/obj/machinery/appliance/proc/report_progress(var/datum/cooking_item/CI)
	if (!CI || !CI.max_cookwork)
		return null

	if (!CI.cookwork)
		return "It is cold."
	var/progress = CI.cookwork / CI.max_cookwork

	if (progress < 0.25)
		return "It's barely started cooking."
	if (progress < 0.75)
		return span("notice","It's cooking away nicely.")
	if (progress < 1)
		return span("notice", "<b>It's almost ready!</b>")

	var/half_overcook = (CI.overcook_mult - 1)*0.5
	if (progress < 1+half_overcook)
		return span("soghun","<b>It is done !</b>")
	if (progress < CI.overcook_mult)
		return span("warning","It looks overcooked, get it out!")
	else
		return span("danger","It is burning!!")

/obj/machinery/appliance/update_icon()
	if (!stat && cooking_objs.len)
		icon_state = on_icon

	else
		icon_state = off_icon

/obj/machinery/appliance/verb/toggle_power()
	set name = "Toggle Power"
	set category  = "Object"
	set src in view()

	attempt_toggle_power(usr)

/obj/machinery/appliance/proc/attempt_toggle_power(mob/user)
	if (!isliving(user))
		return

	if (!user.IsAdvancedToolUser())
		user << "You lack the dexterity to do that!"
		return

	if (user.stat || user.restrained() || user.incapacitated())
		return

	if (!Adjacent(user) && !issilicon(user))
		user << "You can't reach [src] from here."
		return

	if (stat & POWEROFF)//Its turned off
		stat &= ~POWEROFF
		use_power = 1
		user.visible_message("[user] turns [src] on.", "You turn on [src].")

	else //Its on, turn it off
		stat |= POWEROFF
		use_power = 0
		user.visible_message("[user] turns [src] off.", "You turn off [src].")

	playsound(src, 'sound/machines/click.ogg', 40, 1)
	update_icon()

/obj/machinery/appliance/AICtrlClick(mob/user)
	attempt_toggle_power(user)

/obj/machinery/appliance/proc/choose_output()
	set src in view()
	set name = "Choose output"
	set category = "Object"

	if (!isliving(usr))
		return

	if (!usr.IsAdvancedToolUser())
		usr << "You lack the dexterity to do that!"
		return

	if (usr.stat || usr.restrained() || usr.incapacitated())
		return

	if (!Adjacent(usr) && !issilicon(usr))
		usr << "You can't adjust the [src] from this distance, get closer!"
		return

	if(output_options.len)
		var/choice = input("What specific food do you wish to make with \the [src]?") as null|anything in output_options+"Default"
		if(!choice)
			return
		if(choice == "Default")
			selected_option = null
			usr << "<span class='notice'>You decide not to make anything specific with \the [src].</span>"
		else
			selected_option = choice
			usr << "<span class='notice'>You prepare \the [src] to make \a [selected_option] with the next thing you put in. Try putting several ingredients in a container!</span>"

//Handles all validity checking and error messages for inserting things
/obj/machinery/appliance/proc/can_insert(var/obj/item/I, var/mob/user)
	if(!dropsafety(I))
		return 0

	// We are trying to cook a grabbed mob.
	var/obj/item/weapon/grab/G = I
	if(istype(G))

		if(!can_cook_mobs)
			user << "<span class='warning'>That's not going to fit.</span>"
			return 0

		if(!isliving(G.affecting))
			user << "<span class='warning'>You can't cook that.</span>"
			return 0

		return 2


	if (!has_space(I))
		user << "<span class='warning'>There's no room in [src] for that!</span>"
		return 0


	if (container_type && istype(I, container_type))
		return 1

	// We're trying to cook something else. Check if it's valid.
	var/obj/item/weapon/reagent_containers/food/snacks/check = I
	if(istype(check) && islist(check.cooked) && (cook_type in check.cooked))
		user << "<span class='warning'>\The [check] has already been [cook_type].</span>"
		return 0
	else if(istype(check, /obj/item/weapon/reagent_containers/glass))
		user << "<span class='warning'>That would probably break [src].</span>"
		return 0
	else if(istype(check, /obj/item/weapon/disk/nuclear))
		user << "<span class='warning'>You can't cook that.</span>"
		return 0
	else if(!istype(check) && !istype(check, /obj/item/weapon/holder))
		user << "<span class='warning'>That's not edible.</span>"
		return 0

	return 1


//This function is overridden by cookers that do stuff with containers
/obj/machinery/appliance/proc/has_space(var/obj/item/I)
	if (cooking_objs.len >= max_contents)
		return 0

	else return 1

/obj/machinery/appliance/attackby(var/obj/item/I, var/mob/user)
	if(!cook_type || (stat & (BROKEN)))
		user << "<span class='warning'>\The [src] is not working.</span>"
		return

	var/result = can_insert(I, user)
	if(!result)
		if(default_deconstruction_screwdriver(user, I))
			return
		else if(default_part_replacement(user, I))
			return
		else
			return

	if(result == 2)
		var/obj/item/weapon/grab/G = I
		if (G && istype(G) && G.affecting)
			cook_mob(G.affecting, user)
			return

	//From here we can start cooking food
	add_content(I, user)
	update_icon()

//Override for container mechanics
/obj/machinery/appliance/proc/add_content(var/obj/item/I, var/mob/user)
	if(!user.unEquip(I))
		return

	var/datum/cooking_item/CI = has_space(I)
	if (istype(I, /obj/item/weapon/reagent_containers/cooking_container) && CI == 1)
		var/obj/item/weapon/reagent_containers/cooking_container/CC = I
		CI = new /datum/cooking_item/(CC)
		I.forceMove(src)
		cooking_objs.Add(CI)
		user.visible_message("<span class='notice'>\The [user] puts \the [I] into \the [src].</span>")
		if (CC.check_contents() == 0)//If we're just putting an empty container in, then dont start any processing.
			return
	else
		if (CI && istype(CI))
			I.forceMove(CI.container)

		else //Something went wrong
			return

	if (selected_option)
		CI.combine_target = selected_option

	// We can actually start cooking now.
	user.visible_message("<span class='notice'>\The [user] puts \the [I] into \the [src].</span>")

	get_cooking_work(CI)
	cooking = 1
	return CI

/obj/machinery/appliance/proc/get_cooking_work(var/datum/cooking_item/CI)
	for (var/obj/item/J in CI.container)
		oilwork(J, CI)

	for (var/r in CI.container.reagents.reagent_list)
		var/datum/reagent/R = r
		if (istype(R, /datum/reagent/nutriment))
			CI.max_cookwork += R.volume *2//Added reagents contribute less than those in food items due to granular form

			//Nonfat reagents will soak oil
			if (!istype(R, /datum/reagent/nutriment/triglyceride))
				CI.max_oil += R.volume * 0.25
		else
			CI.max_cookwork += R.volume
			CI.max_oil += R.volume * 0.10

	//Rescaling cooking work to avoid insanely long times for large things
	var/buffer = CI.max_cookwork
	CI.max_cookwork = 0
	var/multiplier = 1
	var/step = 4
	while (buffer > step)
		buffer -= step
		CI.max_cookwork += step*multiplier
		multiplier *= 0.95

	CI.max_cookwork += buffer*multiplier

//Just a helper to save code duplication in the above
/obj/machinery/appliance/proc/oilwork(var/obj/item/I, var/datum/cooking_item/CI)
	var/obj/item/weapon/reagent_containers/food/snacks/S = I
	var/work = 0
	if (istype(S))
		if (S.reagents)
			for (var/r in S.reagents.reagent_list)
				var/datum/reagent/R = r
				if (istype(R, /datum/reagent/nutriment))
					work += R.volume *3//Core nutrients contribute much more than peripheral chemicals

					//Nonfat reagents will soak oil
					if (!istype(R, /datum/reagent/nutriment/triglyceride))
						CI.max_oil += R.volume * 0.35
				else
					work += R.volume
					CI.max_oil += R.volume * 0.15


	else if(istype(I, /obj/item/weapon/holder))
		var/obj/item/weapon/holder/H = I
		if (H.contained)
			work += (H.contained.mob_size * H.contained.mob_size * 2)+2

	CI.max_cookwork += work

//Called every tick while we're cooking something
/obj/machinery/appliance/proc/do_cooking_tick(var/datum/cooking_item/CI)
	if (!CI.max_cookwork)
		return 0

	var/was_done = 0
	if (CI.cookwork >= CI.max_cookwork)
		was_done = 1

	CI.cookwork += cooking_power

	if (!was_done && CI.cookwork >= CI.max_cookwork)
		//If cookwork has gone from above to below 0, then this item finished cooking
		finish_cooking(CI)

	else if (!CI.burned && CI.cookwork > CI.max_cookwork * CI.overcook_mult)
		burn_food(CI)

	// Gotta hurt.
	for(var/obj/item/weapon/holder/H in CI.container.contents)
		var/mob/living/M = H.contained
		if (M)
			M.apply_damage(rand(1,3), mobdamagetype, "chest")

	return 1

/obj/machinery/appliance/machinery_process()
	if (cooking_power > 0 && cooking)
		for (var/i in cooking_objs)
			do_cooking_tick(i)


/obj/machinery/appliance/proc/finish_cooking(var/datum/cooking_item/CI)

	src.visible_message("<span class='notice'>\The [src] pings!</span>")
	if(cooked_sound)
		playsound(get_turf(src), cooked_sound, 50, 1)
	//Check recipes first, a valid recipe overrides other options
	var/datum/recipe/recipe = null
	var/atom/C = null
	if (CI.container)
		C = CI.container
	else
		C = src
	recipe = select_recipe(RECIPE_LIST(appliancetype), C)

	if (recipe)
		CI.result_type = 4//Recipe type, a specific recipe will transform the ingredients into a new food
		var/list/results = recipe.make_food(C)

		var/obj/temp = new /obj(src) //To prevent infinite loops, all results will be moved into a temporary location so they're not considered as inputs for other recipes

		for (var/atom/movable/AM in results)
			AM.forceMove(temp)

		//making multiple copies of a recipe from one container. For example, tons of fries
		while (select_recipe(RECIPE_LIST(appliancetype), C) == recipe)
			var/list/TR = list()
			TR += recipe.make_food(C)
			for (var/atom/movable/AM in TR) //Move results to buffer
				AM.forceMove(temp)
			results += TR


		for (var/r in results)
			var/obj/item/weapon/reagent_containers/food/snacks/R = r
			R.forceMove(C) //Move everything from the buffer back to the container
			R.cooked |= cook_type

		QDEL_NULL(temp) //delete buffer object
		. = 1 //None of the rest of this function is relevant for recipe cooking

	else if(CI.combine_target)
		CI.result_type = 3//Combination type. We're making something out of our ingredients
		. = combination_cook(CI)


	else
		//Otherwise, we're just doing standard modification cooking. change a color + name
		for (var/obj/item/i in CI.container)
			modify_cook(i, CI)

	//Final step. Cook function just cooks batter for now.
	for (var/obj/item/weapon/reagent_containers/food/snacks/S in CI.container)
		S.cook()


//Combination cooking involves combining the names and reagents of ingredients into a predefined output object
//The ingredients represent flavours or fillings. EG: donut pizza, cheese bread
/obj/machinery/appliance/proc/combination_cook(var/datum/cooking_item/CI)
	var/cook_path = output_options[CI.combine_target]

	var/list/words = list()
	var/list/cooktypes = list()
	var/datum/reagents/buffer = new /datum/reagents(1000)
	var/totalcolour

	for (var/obj/item/I in CI.container)
		var/obj/item/weapon/reagent_containers/food/snacks/S
		if (istype(I, /obj/item/weapon/holder))
			S = create_mob_food(I, CI)
		else if (istype(I, /obj/item/weapon/reagent_containers/food/snacks))
			S = I

		if (!S)
			continue

		words |= dd_text2List(S.name," ")
		cooktypes |= S.cooked

		if (S.reagents && S.reagents.total_volume > 0)
			if (S.filling_color)
				if (!totalcolour || !buffer.total_volume)
					totalcolour = S.filling_color
				else
					var/t = buffer.total_volume + S.reagents.total_volume
					t = buffer.total_volume / y
					totalcolour = BlendRGB(totalcolour, S.filling_color, t)
					//Blend colours in order to find a good filling color


			S.reagents.trans_to_holder(buffer, S.reagents.total_volume)
		//Cleanup these empty husk ingredients now
		if (I)
			qdel(I)
		if (S)
			qdel(S)

	CI.container.reagents.trans_to_holder(buffer, CI.container.reagents.total_volume)

	var/obj/item/weapon/reagent_containers/food/snacks/result = new cook_path(CI.container)
	buffer.trans_to(result, buffer.total_volume)

	//Filling overlay
	var/image/I = image(result.icon, "[result.icon_state]_filling")
	I.color = totalcolour
	result.add_overlay(I)
	result.filling_color = totalcolour

	//Set the name.
	words -= list("and", "the", "in", "is", "bar", "raw", "sticks", "boiled", "fried", "deep", "-o-", "warm", "two", "flavored")
	//Remove common connecting words and unsuitable ones from the list. Unsuitable words include those describing
	//the shape, cooked-ness/temperature or other state of an ingredient which doesn't apply to the finished product
	words.Remove(result.name)
	shuffle(words)
	var/num = 6 //Maximum number of words
	while (num > 0)
		num--
		if (!words.len)
			break
		//Add prefixes from the ingredients in a random order until we run out or hit limit
		result.name = "[pop(words)] [result.name]"

	//This proc sets the size of the output result
	result.update_icon()
	return result

//Helper proc for standard modification cooking
/obj/machinery/appliance/proc/modify_cook(var/obj/item/input, var/datum/cooking_item/CI)
	var/obj/item/weapon/reagent_containers/food/snacks/result
	if (istype(input, /obj/item/weapon/holder))
		result = create_mob_food(input, CI)
	else if (istype(input, /obj/item/weapon/reagent_containers/food/snacks))
		result = input
	else
		//Nonviable item
		return

	if (!result)
		return

	result.cooked |= cook_type

	// Set icon and appearance.
	change_product_appearance(result, CI)

	// Update strings.
	change_product_strings(result, CI)

/obj/machinery/appliance/proc/burn_food(var/datum/cooking_item/CI)
	// You dun goofed.
	CI.burned = 1
	CI.container.clear()
	new /obj/item/weapon/reagent_containers/food/snacks/badrecipe(CI.container)

	// Produce nasty smoke.
	visible_message("<span class='danger'>\The [src] vomits a gout of rancid smoke!</span>")
	var/datum/effect/effect/system/smoke_spread/bad/smoke = new /datum/effect/effect/system/smoke_spread/bad
	smoke.attach(src)
	smoke.set_up(10, 0, get_turf(src), 300)
	smoke.start()

/obj/machinery/appliance/attack_hand(var/mob/user)
	if (cooking_objs.len)
		if (removal_menu(user))
			return
		else
			..()

/obj/machinery/appliance/proc/removal_menu(var/mob/user)
	if (can_remove_items(user))
		var/list/menuoptions = list()
		for (var/a in cooking_objs)
			var/datum/cooking_item/CI = a
			if (CI.container)
				menuoptions[CI.container.label(menuoptions.len)] = CI

		var/selection = input(user, "Which item would you like to remove?", "Remove ingredients") as null|anything in menuoptions
		if (selection)
			var/datum/cooking_item/CI = menuoptions[selection]
			eject(CI, user)
			update_icon()
		return 1
	return 0

/obj/machinery/appliance/proc/can_remove_items(var/mob/user)
	if (!Adjacent(user))
		return 0

	if (isanimal(user))
		return 0

	return 1

/obj/machinery/appliance/proc/eject(var/datum/cooking_item/CI, var/mob/user = null)
	var/obj/item/thing
	var/delete = 1
	var/status = CI.container.check_contents()
	if (status == 1)//If theres only one object in a container then we extract that
		thing = locate(/obj/item) in CI.container
		delete = 0
	else//If the container is empty OR contains more than one thing, then we must extract the container
		thing = CI.container
	if (!user || !user.put_in_hands(thing))
		thing.forceMove(get_turf(src))

	if (delete)
		cooking_objs -= CI
		qdel(CI)
	else
		CI.reset()//reset instead of deleting if the container is left inside

/obj/machinery/appliance/proc/cook_mob(var/mob/living/victim, var/mob/user)
	return

/obj/machinery/appliance/proc/change_product_strings(var/obj/item/weapon/reagent_containers/food/snacks/product, var/datum/cooking_item/CI)
	product.name = "[cook_type] [product.name]"
	product.desc = "[product.desc]\nIt has been [cook_type]."


/obj/machinery/appliance/proc/change_product_appearance(var/obj/item/weapon/reagent_containers/food/snacks/product, var/datum/cooking_item/CI)
	if (!product.coating) //Coatings change colour through a new sprite
		product.color = food_color
	product.filling_color = food_color

//This function creates a food item which represents a dead mob
/obj/machinery/appliance/proc/create_mob_food(var/obj/item/weapon/holder/H, var/datum/cooking_item/CI)
	if (!istype(H) || !H.contained)
		qdel(H)
		return null
	var/mob/living/victim = H.contained
	if (victim.stat != DEAD)
		return null //Victim somehow survived the cooking, they do not become food

	victim.calculate_composition()

	var/obj/item/weapon/reagent_containers/food/snacks/variable/mob/result = new /obj/item/weapon/reagent_containers/food/snacks/variable/mob(CI.container)
	result.w_class = victim.mob_size
	result.reagents.add_reagent(victim.composition_reagent, victim.composition_reagent_quantity)

	if (victim.reagents)
		victim.reagents.trans_to_holder(result.reagents, victim.reagents.total_volume)

	if (isanimal(victim))
		var/mob/living/simple_animal/SA = victim
		result.kitchen_tag = SA.kitchen_tag

	result.appearance = victim

	var/matrix/M = matrix()
	M.Turn(45)
	M.Translate(1,-2)
	result.transform = M

	// all done, now delete the old objects
	H.contained = null
	qdel(victim)
	victim = null
	qdel(H)
	H = null

	return result

/datum/cooking_item
	var/max_cookwork
	var/cookwork
	var/overcook_mult = 3
	var/result_type = 0
	var/obj/item/weapon/reagent_containers/cooking_container/container = null
	var/combine_target = null

	//Result type is one of the following:
		//0 unfinished, no result yet
		//1 Standard modification cooking. eg Fried Donk Pocket, Baked wheat, etc
		//2 Modification but with a new object that's an inert copy of the old. Generally used for deepfried mice
		//3 Combination cooking, EG Donut Bread, Donk pocket pizza, etc
		//4:Specific recipe cooking. EG: Turning raw potato sticks into fries

	var/burned = 0

	var/oil = 0
	var/max_oil = 0//Used for fryers.

/datum/cooking_item/New(var/obj/item/I)
	container = I

//This is called for containers whose contents are ejected without removing the container
/datum/cooking_item/proc/reset()
	max_cookwork = 0
	cookwork = 0
	result_type = 0
	burned = 0
	max_oil = 0
	oil = 0
	combine_target = null
	//Container is not reset

/obj/machinery/appliance/RefreshParts()
	..()
	var/scan_rating = 0
	var/cap_rating = 0

	for(var/obj/item/weapon/stock_parts/P in component_parts)
		if(isscanner(P))
			scan_rating += P.rating
		else if(iscapacitor(P))
			cap_rating += P.rating

	active_power_usage = initalactive_power_usage - scan_rating*10
	cooking_power = inital_cooking_power + (scan_rating+cap_rating)/10

/obj/item/weapon/circuitboard/cooking
	name = "kitchen appliance circuitry"
	desc = "The circuitboard for many kitchen appliances. Not of much use."
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	req_components = list(
							"/obj/item/weapon/stock_parts/capacitor" = 3,
							"/obj/item/weapon/stock_parts/scanning_module" = 1,
							"/obj/item/weapon/stock_parts/matter_bin" = 2)
