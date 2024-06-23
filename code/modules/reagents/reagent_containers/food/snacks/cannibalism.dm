/obj/item/reagent_containers/food/snacks/human
	var/hname = ""
	var/job = null
	filling_color = "#D63C3C"

/obj/item/reagent_containers/food/snacks/human/burger
	name = "-burger"
	desc = "A bloody burger."
	icon = 'icons/obj/item/reagent_containers/food/burger.dmi'
	icon_state = "hburger"
	center_of_mass = list("x"=16, "y"=11)
	bitesize = 2

	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("buns" = 3))

// Human Burger + cheese wedge = cheeseburger
/obj/item/reagent_containers/food/snacks/human/burger/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/reagent_containers/food/snacks/cheesewedge))
		new /obj/item/reagent_containers/food/snacks/burger/cheese(src)
		to_chat(user, "You make a cheeseburger.")
		qdel(attacking_item)
		qdel(src)
		return
	else
		..()

/obj/item/reagent_containers/food/snacks/human/kabob
	name = "-kabob"
	icon = 'icons/obj/item/reagent_containers/food/mix.dmi'
	icon_state = "kabob"
	desc = "A human meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#A85340"
	center_of_mass = list("x"=17, "y"=15)
	bitesize = 2

	reagents_to_add = list(/singleton/reagent/nutriment/protein = 8)

/obj/item/reagent_containers/food/snacks/organ
	name = "organ"
	desc = "Sorry, this isn't the instrument."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"
	filling_color = "#E00D34"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/organ/Initialize()
	. = ..()
	reagents.add_reagent(/singleton/reagent/nutriment/protein, rand(3,5))
	reagents.add_reagent(/singleton/reagent/toxin, rand(1,3))
