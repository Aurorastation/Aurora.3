/obj/item/reagent_containers/food/snacks/loadedbakedpotato
	name = "loaded baked potato"
	desc = "Totally baked."
	icon = 'icons/obj/item/reagent_containers/food/baked.dmi'
	icon_state = "loadedbakedpotato"
	filling_color = "#9C7A68"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("baked potato" = 3))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit
	name = "plump helmet biscuit"
	desc = "This is a finely-prepared plump helmet biscuit. The ingredients are exceptionally minced plump helmet, and well-minced dwarven wheat flour."
	icon = 'icons/obj/item/reagent_containers/food/baked.dmi'
	icon_state = "phelmbiscuit"
	filling_color = "#CFB4C4"
	center_of_mass = list("x"=16, "y"=13)
	reagents_to_add = list(/singleton/reagent/nutriment = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("mushroom" = 4))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit/Initialize()
	. = ..()
	if(prob(10))
		name = "exceptional plump helmet biscuit"
		desc = "The chef is taken by a fey mood! It has cooked an exceptional plump helmet biscuit!"
		reagents.add_reagent(/singleton/reagent/nutriment, 8)
		reagents.add_reagent(/singleton/reagent/tricordrazine, 5)

/obj/item/reagent_containers/food/snacks/ribplate
	name = "plate of ribs"
	desc = "A half-rack of ribs, brushed with some sort of honey-glaze. Why are there no napkins on board?"
	icon = 'icons/obj/item/reagent_containers/food/baked.dmi'
	icon_state = "ribplate"
	trash = /obj/item/trash/plate
	filling_color = "#7A3D11"
	center_of_mass = list("x"=16, "y"=13)
	bitesize = 4
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6, /singleton/reagent/nutriment/triglyceride = 2, /singleton/reagent/blackpepper = 1, /singleton/reagent/nutriment/honey = 5)

/obj/item/reagent_containers/food/snacks/eggplantparm
	name = "eggplant parmigiana"
	desc = "The only good recipe for eggplant."
	icon = 'icons/obj/item/reagent_containers/food/baked.dmi'
	icon_state = "eggplantparm"
	trash = /obj/item/trash/plate
	filling_color = "#4D2F5E"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein/cheese = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("eggplant" = 3))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meat_pocket
	name = "meat pocket"
	desc = "Meat and cheese stuffed in a flatbread pocket, grilled to perfection."
	icon = 'icons/obj/item/reagent_containers/food/baked.dmi'
	icon_state = "meat_pocket"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("flatbread" = 3))
	filling_color = "#BD8939"

/obj/item/reagent_containers/food/snacks/donkpocket
	name = "\improper Donk-pocket"
	desc = "A mass produced shelf-stable turnover. The reheatable food of choice for the seasoned spaceman."
	icon = 'icons/obj/item/reagent_containers/food/baked.dmi'
	icon_state = "donkpocket"
	filling_color = "#DEDEAB"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/nutriment/protein = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("heartiness" = 1, "dough" = 2))

	/// Whether the donk pocket is currently hot. Hot donk pockets have additional reagents
	var/is_hot = FALSE

	/// Whether the donk pocket is able to be made hot without a microwave by using it in-hand
	var/can_self_heat = FALSE

	/// Whether the donk pocket was heated up already. Reheating does not re-add the extra reagents.
	var/was_heated = FALSE

	/// The reagents to be added to the donk pocket when it is made hot (and removed when made cold)
	var/list/hot_reagents = list(/singleton/reagent/tricordrazine = 5)

	/// The reagents to be added to the donk pocket when it is initialized
	var/list/filling_options

/obj/item/reagent_containers/food/snacks/donkpocket/Initialize()
	. = ..()
	if (. == INITIALIZE_HINT_QDEL)
		return
	if (filling_options)
		SetInitialReagents(filling_options)

/obj/item/reagent_containers/food/snacks/donkpocket/standard_feed_mob(mob/living/consumer, mob/living/feeder)
	if (can_self_heat)
		if (feeder)
			feeder.visible_message(
				SPAN_ITALIC("\The [feeder] tears open \a [src], destroying the self-heating packaging."),
				SPAN_ITALIC("You tear open \the [src], destroying the self-heating packaging."),
				SPAN_ITALIC("You hear plastic packaging crinkling."),
				range = 3
			)
		can_self_heat = FALSE
	..()


/obj/item/reagent_containers/food/snacks/donkpocket/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	. = ..()
	if (distance > 1)
		return
	if (!initial(can_self_heat))
		return
	to_chat(user, "This one can self-heat[can_self_heat ? "." : " but the heaters are used up."]")


/obj/item/reagent_containers/food/snacks/donkpocket/attack_self(mob/living/user)
	if (!initial(can_self_heat))
		return
	SetHot(user, TRUE)


/obj/item/reagent_containers/food/snacks/donkpocket/proc/SetHot(mob/living/user, attempt_self_heat)
	if (is_hot)
		to_chat(user, SPAN_NOTICE("\The [src] is already hot!"))
		return
	if (attempt_self_heat)
		if (!can_self_heat)
			if (!initial(can_self_heat))
				return
			to_chat(user, SPAN_WARNING("\The [src]'s heaters are used up. Use a microwave."))
			return
		can_self_heat = FALSE
	is_hot = TRUE
	if (attempt_self_heat)
		to_chat(user, SPAN_NOTICE("A comforting warmth spreads through \the [src]. It's ready to eat!"))
	if (!was_heated)
		for(var/reagent in hot_reagents)
			reagents.add_reagent(reagent, hot_reagents[reagent])
		was_heated = TRUE
	name = "hot [name]"
	addtimer(CALLBACK(src, PROC_REF(UnsetHot)), 7 MINUTES)

/obj/item/reagent_containers/food/snacks/donkpocket/proc/UnsetHot()
	if (!is_hot)
		return
	is_hot = FALSE
	name = initial(name)
	visible_message(SPAN_ITALIC("\The [src] cools down."), range = 1)
	for (var/reagent in hot_reagents)
		reagents.del_reagent(reagent)

/obj/item/reagent_containers/food/snacks/donkpocket/proc/SetInitialReagents(list/options, amount = 3)
	var/list/entry = pick(options)
	if (!islist(entry))
		reagents.add_reagent(entry, amount)
		return
	var/sub_amount = amount / length(entry)
	for (var/reagent in entry)
		reagents.add_reagent(reagent, sub_amount)

/obj/item/reagent_containers/food/snacks/donkpocket/sinpocket
	name = "premium Donk-pocket"
	desc = "A \"premium\" shelf-stable turnover. Possibly contains \"real\" fruit paste. Crush the packaging to cook it on the go!"
	filling_color = "#6d6d00"
	can_self_heat = TRUE
	reagent_data = list(/singleton/reagent/nutriment = list("delicious cruelty" = 1, "dough" = 2))
	hot_reagents = list(
		/singleton/reagent/drink/doctorsdelight = 4,
		/singleton/reagent/hyperzine = 0.5,
		/singleton/reagent/synaptizine = 0.1
	)

/obj/item/reagent_containers/food/snacks/donkpocket/sinpocket/antagonist_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Use it in hand to heat and release chemicals."

/obj/item/reagent_containers/food/snacks/donkpocket/teriyaki
	name = "teriyaki Donk-pocket"
	desc = "A mass produced shelf-stable turnover. The reheatable food of choice for the seasoned salaryman."
	filling_color = "#8e4619"
	reagent_data = list(/singleton/reagent/nutriment = list("sweet and savory" = 1, "dough" = 2))

/obj/item/reagent_containers/food/snacks/donkpocket/takoyaki
	name = "takoyaki Donk-pocket"
	desc = "A mass produced shelf-stable turnover. The reheatable food of choice for the seasoned salaryman."
	filling_color = "#8e4619"
	reagent_data = list(/singleton/reagent/nutriment = list("takoyaki" = 1, "dough" = 2))

/obj/item/reagent_containers/food/snacks/spacylibertyduff
	name = "spacy liberty duff"
	desc = "Jello gelatin, from Alfred Hubbard's cookbook."
	icon = 'icons/obj/item/reagent_containers/food/baked.dmi'
	icon_state = "spacylibertyduff"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#42B873"
	center_of_mass = list("x"=16, "y"=8)
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/drugs/psilocybin = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("mushroom" = 6))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sliceable/meat_lasagna_tray
	name = "meat lasagna tray"
	desc = "Who doesn't love a hot, meaty, cheesy lasagna? Don't worry, there's enough in this tray for everyone! Assuming 'everyone' is 6 people and nobody wants seconds."
	icon = 'icons/obj/item/reagent_containers/food/baked.dmi'
	icon_state = "lasagnatray_meat"
	slice_path = /obj/item/reagent_containers/food/snacks/lasagna_meat_slice
	slices_num = 6
	trash = /obj/item/trash/grease
	drop_sound = /singleton/sound_category/tray_hit_sound
	center_of_mass = list("x"=16, "y"=17)
	filling_color = "#e08b2a"
	reagents_to_add = list(/singleton/reagent/nutriment = 24, /singleton/reagent/nutriment/protein = 24, /singleton/reagent/nutriment/protein/cheese = 12)
	reagent_data = list(/singleton/reagent/nutriment = list("pasta" = 4, "tomato" = 2))
	bitesize = 6

/obj/item/reagent_containers/food/snacks/lasagna_meat_slice
	name = "meat lasagna"
	desc = "Not Adhomian food, yet... Very popular among Tajarans on Mondays for some reason."
	icon = 'icons/obj/item/reagent_containers/food/baked.dmi'
	icon_state = "lasagna_meat"
	trash = /obj/item/trash/plate
	filling_color = "#e08b2a"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/snacks/lasagna_meat_slice/update_icon()
	var/percent_lasagna_meat_slice = round((reagents.total_volume / 10) * 100)
	switch(percent_lasagna_meat_slice)
		if(0 to 50)
			icon_state = "lasagna_meat_half"
		if(51 to INFINITY)
			icon_state = "lasagna_meat"

/obj/item/reagent_containers/food/snacks/sliceable/veggie_lasagna_tray
	name = "veggie lasagna tray"
	desc = "Cheesy, delicious, and vegetarian! Don't worry, there's enough in this tray for everyone! Assuming 'everyone' is 6 people and nobody wants seconds."
	icon = 'icons/obj/item/reagent_containers/food/baked.dmi'
	icon_state = "lasagnatray_veg"
	slice_path = /obj/item/reagent_containers/food/snacks/lasagna_veggie_slice
	slices_num = 6
	trash = /obj/item/trash/grease
	drop_sound = /singleton/sound_category/tray_hit_sound
	center_of_mass = list("x"=16, "y"=17)
	filling_color = "#e08b2a"
	reagents_to_add = list(/singleton/reagent/nutriment = 48, /singleton/reagent/nutriment/protein/cheese = 12)
	reagent_data = list(/singleton/reagent/nutriment = list("pasta" = 4, "tomato" = 2, "mushrooms" = 2))
	bitesize = 6

/obj/item/reagent_containers/food/snacks/lasagna_veggie_slice
	name = "veggie lasagna"
	desc = "Layers of pasta, sauce, veggies and mushrooms carefully stacked on each other into an apartment block of deliciousness."
	icon = 'icons/obj/item/reagent_containers/food/baked.dmi'
	icon_state = "lasagna_veg"
	trash = /obj/item/trash/plate
	filling_color = "#e08b2a"
	bitesize = 3
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/snacks/lasagna_veggie_slice/update_icon()
	var/percent_lasagna_veggie_slice = round((reagents.total_volume / 10) * 100)
	switch(percent_lasagna_veggie_slice)
		if(0 to 50)
			icon_state = "lasagna_veg_half"
		if(51 to INFINITY)
			icon_state = "lasagna_veg"

/obj/item/reagent_containers/food/snacks/pig_in_a_blanket
	name = "pig in a blanket"
	desc = "A mini sausage wrapped in dough. Like a tiny hot dog but cuter. Oink oink zzz..."
	icon = 'icons/obj/item/reagent_containers/food/baked.dmi'
	icon_state = "pig_blanket"
	reagents_to_add = list(/singleton/reagent/nutriment = 1, /singleton/reagent/nutriment/protein = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("baked dough" = 5), /singleton/reagent/nutriment/protein = list("sausage" = 5))
	filling_color = "#a02d1e"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/stuffed_pepper_meat
	name = "stuffed pepper with meat"
	desc = "Half a bell pepper stuffed with meat, cheese, tomato sauce and chives. Who even needs bowls?"
	icon = 'icons/obj/item/reagent_containers/food/baked.dmi'
	icon_state = "pepper_rice1"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein = 3, /singleton/reagent/nutriment/protein/cheese = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("bell pepper" = 5), /singleton/reagent/nutriment/protein = list("meat" = 5))
	filling_color = "#b84e1e"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/stuffed_pepper_meat/Initialize()
	. = ..()
	var/variant = pick("pepper_meat1", "pepper_meat2")
	icon = 'icons/obj/item/reagent_containers/food/baked.dmi'
	icon_state = "[variant]"
	update_icon()

/obj/item/reagent_containers/food/snacks/stuffed_pepper_rice
	name = "stuffed pepper with rice"
	desc = "Half a bell pepper stuffed with rice, beans and corn. Who even needs bowls when you're THIS vegan?"
	icon = 'icons/obj/item/reagent_containers/food/baked.dmi'
	icon_state = "pepper_rice1"
	reagents_to_add = list(/singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("bell pepper" = 5, "beans" = 3, "corn" = 3))
	filling_color = "#c5ddb6"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/stuffed_pepper_rice/Initialize()
	. = ..()
	var/variant = pick("pepper_rice1", "pepper_rice2")
	icon = 'icons/obj/item/reagent_containers/food/baked.dmi'
	icon_state = "[variant]"
	update_icon()

/obj/item/reagent_containers/food/snacks/baked_apple
	name = "baked apple"
	desc = "A soft, vegan baked apple stufed with raisins, nuts, cinnamon and brown sugar. All of the nature without any of the healthy!" //Grammar bad on purpose because funny.
	icon = 'icons/obj/item/reagent_containers/food/baked.dmi'
	icon_state = "baked_apple"
	trash = /obj/item/trash/plate
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/glucose = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("apple" = 5, "raisins" = 5, "nuts" = 3, "cinnamon" = 3))
	filling_color = "#a04e1e"
