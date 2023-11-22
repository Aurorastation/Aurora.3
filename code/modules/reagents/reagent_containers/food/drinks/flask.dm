/obj/item/reagent_containers/food/drinks/flask
	name = "captain's flask"
	desc = "A metal flask belonging to the captain."
	icon = 'icons/obj/item/reagent_containers/food/drinks/flask.dmi'
	icon_state = "flask"
	volume = 60
	center_of_mass = list("x"=17, "y"=7)

/obj/item/reagent_containers/food/drinks/flask/detflask
	name = "detective's flask"
	desc = "A metal flask with a leather band and golden badge belonging to the detective."
	icon_state = "detflask"
	volume = 60
	center_of_mass = list("x"=17, "y"=8)

/obj/item/reagent_containers/food/drinks/flask/barflask
	name = "flask"
	desc = "For those who can't be bothered to hang out at the bar to drink."
	icon_state = "barflask"
	volume = 60
	center_of_mass = list("x"=17, "y"=7)

/obj/item/reagent_containers/food/drinks/flask/vacuumflask
	name = "vacuum flask"
	desc = "Keeping your drinks at the perfect temperature since 1892."
	icon_state = "vacuumflask"
	volume = 60
	center_of_mass = list("x"=15, "y"=4)

	var/obj/item/reagent_containers/food/drinks/flask/flask_cup/cup

/obj/item/reagent_containers/food/drinks/flask/vacuumflask/Initialize()
	. = ..()
	cup = new(src)
	flags ^= OPENCONTAINER

/obj/item/reagent_containers/food/drinks/flask/vacuumflask/attack_self(mob/user)
	if(cup)
		to_chat(user, SPAN_NOTICE("You remove \the [src]'s cap."))
		user.put_in_hands(cup)
		flags |= OPENCONTAINER
		cup = null
		update_icon()

/obj/item/reagent_containers/food/drinks/flask/vacuumflask/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/reagent_containers/food/drinks/flask/flask_cup))
		if(cup)
			to_chat(user, SPAN_WARNING("\The [src] already has a cap."))
			return TRUE
		if(W.reagents.total_volume + reagents.total_volume > volume)
			to_chat(user, SPAN_WARNING("There's too much fluid in both the cap and \the [src]!"))
			return TRUE
		to_chat(user, SPAN_NOTICE("You put the cap onto \the [src]."))
		user.drop_from_inventory(W, src)
		flags ^= OPENCONTAINER
		cup = W
		cup.reagents.trans_to_holder(reagents, cup.reagents.total_volume)
		update_icon()
		return TRUE
	return ..()

/obj/item/reagent_containers/food/drinks/flask/vacuumflask/update_icon()
	icon_state = cup ? initial(icon_state) : "[initial(icon_state)]-nobrim"

/obj/item/reagent_containers/food/drinks/flask/flask_cup
	name = "vacuum flask cup"
	desc = "The cup that appears in your hands after you unscrew the cap of the flask and turn it over. Magic!"
	icon_state = "vacuumflask-brim"
	volume = 10
	center_of_mass = list("x" = 16, "y" = 16)

/obj/item/reagent_containers/food/drinks/flask/flask_cup/afterattack(atom/target, mob/user, proximity, params)
	if(istype(target, /obj/item/reagent_containers/food/drinks/flask/vacuumflask))
		return
	return ..()
