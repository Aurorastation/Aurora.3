/obj/structure/bonfire
	name = "bonfire"
	desc = "A large pile of wood, ready to be burned."
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "bonfire"
	anchored = TRUE
	density = FALSE
	light_color = LIGHT_COLOR_FIRE
	var/fuel = 2000
	var/max_fuel = 2000
	var/on_fire = FALSE
	var/safe = FALSE
	var/obj/machinery/appliance/bonfire/cook_machine

/obj/structure/bonfire/Initialize()
	. = ..()
	fuel = rand(1000, 2000)

/obj/structure/bonfire/examine(mob/user)
	..()
	if(!Adjacent(user))
		return
	if(on_fire)
		switch(fuel)
			if(0 to 200)
				to_chat(user, "\The [src] is burning weakly.")
			if(200 to 600)
				to_chat(user, "\The [src] is gently burning.")
			if(600 to 900)
				to_chat(user, "\The [src] is burning steadily.")
			if(900 to 1300)
				to_chat(user, "The flames are dancing wildly!")
			if(1300 to 2000)
				to_chat(user, "The fire is roaring!")
	if(!cook_machine)
		return
	cook_machine.list_contents(user)

/obj/structure/bonfire/update_icon()
	if(on_fire)
		icon_state = "[initial(icon_state)]_fire"
	else
		icon_state = initial(icon_state)

/obj/structure/bonfire/attack_hand(var/mob/user)
	if(!cook_machine)
		return
	if (cook_machine.cooking_objs.len)
		if (cook_machine.removal_menu(user))
			return
		else
			..()

/obj/structure/bonfire/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(W.iswelder())
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.isOn())
			light(user)
	else if(istype(W, /obj/item/weapon/flame/candle))
		var/obj/item/weapon/flame/candle/C = W
		if(C.lit)
			light(user)
		else if(on_fire && !C.lit)
			C.light(user)
	else if(istype(W, /obj/item/device/flashlight/flare/torch))
		var/obj/item/device/flashlight/flare/torch/T = W
		if(T.on)
			light(user)
		else if(on_fire)
			T.light(user)
	else if(isflamesource(W) && !on_fire) // needs to go last or else nothing else will work
		light(user)

	if(istype(W,/obj/item/stack/material/wood) && (fuel < max_fuel))
		var/obj/item/stack/material/wood/I = W
		I.use(1)
		fuel = min(fuel + 200, max_fuel)
		to_chat(user, "<span class='notice'>You add some of \the [I] to \the [src].</span>")

	if(istype(W, /obj/item/weapon/reagent_containers/cooking_container/fire))
		cook_machine.attackby(W, user)

/obj/structure/bonfire/proc/light(mob/user)
	if(!fuel)
		to_chat(user, "<span class='warning'>There is not enough fuel to start a fire.</span>")
		return
	if(!on_fire)
		on_fire = TRUE
		check_light()
		update_icon()
		START_PROCESSING(SSprocessing, src)
	if(!cook_machine)
		cook_machine = new () // we don't want one before it's lit, to save memory and junk
		cook_machine.stat = 0 // since, presumably, it's on fire now
		cook_machine.cooking_power = 0.75

/obj/structure/bonfire/proc/check_light()
	if(on_fire)
		switch(fuel)
			if(0 to 200)
				set_light(2)
			if(200 to 600)
				set_light(3)
			if(600 to 900)
				set_light(4)
			if(900 to 1300)
				set_light(5)
			if(1300 to 2000)
				set_light(6)
	else
		set_light(0)

/obj/structure/bonfire/process()
	if(!on_fire)
		return

	fuel--

	if(!fuel)
		extinguish()

	if(istype(loc, /turf))
		var/turf/T = loc
		T.hotspot_expose(700, 5)

	if(locate(/mob/living, src.loc))
		var/mob/living/M = locate(/mob/living, src.loc)
		burn(M)

	check_light()
	heat()

/obj/structure/bonfire/proc/extinguish()
	on_fire = FALSE
	STOP_PROCESSING(SSprocessing, src)
	check_light()
	update_icon()
	if(cook_machine)
		cook_machine.stat |= POWEROFF

/obj/structure/bonfire/proc/heat()
	var/turf/simulated/L = loc
	if(istype(L))
		var/datum/gas_mixture/env = L.return_air()
		if(env.temperature >= T0C+10)
			return
		var/transfer_moles = 0.25 * env.total_moles
		var/datum/gas_mixture/removed = env.remove(transfer_moles)

		if(removed)
			removed.add_thermal_energy(10000)

			env.merge(removed)

/obj/structure/bonfire/Crossed(AM as mob|obj)
	if(on_fire)
		if(istype(AM, /mob/living))
			burn(AM, TRUE)
	..()

/obj/structure/bonfire/proc/burn(var/mob/living/M, var/entered = FALSE)
	if(safe)
		return
	if(M)
		if(entered)
			to_chat(M, "<span class='warning'>You are covered by fire and heat from entering \the [src]!</span>")
		if(isanimal(M))
			var/mob/living/simple_animal/H = M
			if(H.flying) //flying mobs will ignore the lava
				return
			else
				M.bodytemperature = min(M.bodytemperature + 150, 1000)
		else
			if(prob(50))
				M.adjust_fire_stacks(5)
				M.IgniteMob()
				return

/obj/structure/bonfire/fireplace
	name = "fireplace"
	desc = "A large stone brick fireplace."
	icon = 'icons/adhomai/fireplace.dmi'
	icon_state = "fireplace"
	pixel_x = -16
	safe = TRUE

/obj/structure/bonfire/fireplace/update_icon()
	cut_overlays()
	if(on_fire)
		switch(fuel)
			if(0 to 500)
				add_overlay("fireplace_fire0")
			if(500 to 1000)
				add_overlay("fireplace_fire1")
			if(1000 to 1500)
				add_overlay("fireplace_fire2")
			if(1500 to 1700)
				add_overlay("fireplace_fire3")
			if(1700 to 2000)
				add_overlay("fireplace_fire4")
		add_overlay("fireplace_glow")

/////////////
// COOKING //
/////////////

/obj/item/weapon/reagent_containers/cooking_container/fire/
	var/appliancetype

/obj/item/weapon/reagent_containers/cooking_container/fire/pot
	name = "pot"
	shortname = "pot"
	desc = "Chuck ingredients in this to cook something over a fire."
	icon = 'icons/obj/food.dmi'
	icon_state = "stew_empty"
	appliancetype = POT

/obj/item/weapon/reagent_containers/cooking_container/fire/pot/New(var/newloc, var/mat_key)
	..(newloc)
	var/material/material = get_material_by_name(mat_key ? mat_key : "iron")
	name = "[material.display_name] [initial(name)]"

/obj/item/weapon/reagent_containers/cooking_container/fire/skewer
	name = "wooden skewer"
	shortname = "skewer"
	desc = "Not a kebab, so don't remove it."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "shaft"
	item_state = "rods"
	appliancetype = SKEWER

/obj/item/weapon/material/shaft/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/cooking_container/fire/skewer/S = new ()
		if (!user || !user.put_in_hands(S))
			S.forceMove(get_turf(user ? user : src))
		qdel(src)
		S.attackby(I, user)

/obj/item/weapon/reagent_containers/cooking_container/fire/skewer/do_empty(mob/user)
	. = ..()
	if(!contents.len)
		var/obj/item/weapon/material/shaft/S = new ()
		if (!user || !user.put_in_hands(S))
			S.forceMove(get_turf(user ? user : src))
		qdel(src)

/obj/machinery/appliance/bonfire
	name = "bonfire"
	desc = "Nice and hot."
	cook_type = "roasted"
	appliancetype = 0 // depends on the cooking utensil used
	food_color = "#A34719"
	can_burn_food = 1
	use_power = 0
	component_types = list()

	mobdamagetype = BURN
	cooking_power = 0.75
	max_contents = 5
	container_type = /obj/item/weapon/reagent_containers/cooking_container/fire

/obj/machinery/appliance/bonfire/Initialize()
	. = ..()
	verbs -= .verb/toggle_power

/obj/machinery/appliance/bonfire/can_remove_items(var/mob/user)
	if(isanimal(user))
		return 0
	if(user in view(1))
		return 1

/obj/machinery/appliance/bonfire/attempt_toggle_power()
	return // just in case

/obj/machinery/appliance/bonfire/AICtrlClick() // i don't even know how but might as well
	return

/obj/machinery/appliance/bonfire/finish_cooking(var/datum/cooking_item/CI)
	//Check recipes first, a valid recipe overrides other options
	var/datum/recipe/recipe = null
	var/atom/C = null
	if (CI.container)
		C = CI.container
	if(!istype(CI.container, /obj/item/weapon/reagent_containers/cooking_container/fire))
		return
	var/obj/item/weapon/reagent_containers/cooking_container/fire/F = CI.container
	if(F.appliancetype)
		recipe = select_recipe(RECIPE_LIST(F.appliancetype), C)
	if (recipe)
		CI.result_type = 4//Recipe type, a specific recipe will transform the ingredients into a new food
		var/list/results = recipe.make_food(C)

		var/obj/temp = new /obj(src) //To prevent infinite loops, all results will be moved into a temporary location so they're not considered as inputs for other recipes

		for (var/atom/movable/AM in results)
			AM.forceMove(temp)

		//making multiple copies of a recipe from one container. For example, tons of fries
		while (select_recipe(RECIPE_LIST(F.appliancetype), C) == recipe)
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

	else
		//Otherwise, we're just doing standard modification cooking. change a color + name
		for (var/obj/item/i in CI.container)
			modify_cook(i, CI)

	//Final step. Cook function just cooks batter for now.
	for (var/obj/item/weapon/reagent_containers/food/snacks/S in CI.container)
		S.cook()

/obj/structure/bonfire/stove
	name = "stove"
	desc = "A potbelly stove. How'd that get here."
	icon = 'icons/adhomai/fireplace.dmi'
	icon_state = "stove"
	pixel_x = -16
	safe = TRUE

/obj/structure/bonfire/stove/update_icon()
	cut_overlays()
	if(on_fire)
		switch(fuel)
			if(0 to 500)
				add_overlay("stove_fire0")
			if(500 to 1000)
				add_overlay("stove_fire1")
			if(1000 to 1500)
				add_overlay("stove_fire2")
			if(1500 to 1700)
				add_overlay("stove_fire3")
			if(1700 to 2000)
				add_overlay("stove_fire4")
		add_overlay("stove_glow")