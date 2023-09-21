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
	name = "Donk-pocket"
	desc = "The cold, reheatable food of choice for the seasoned spaceman."
	icon = 'icons/obj/item/reagent_containers/food/baked.dmi'
	icon_state = "donkpocket"
	filling_color = "#DEDEAB"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/nutriment/protein = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("heartiness" = 1, "dough" = 2))

/obj/item/reagent_containers/food/snacks/donkpocket/warm
	name = "cooked Donk-pocket"
	desc = "The cooked, reheatable food of choice for the seasoned spaceman."
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein = 1, /singleton/reagent/tricordrazine = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("warm heartiness" = 1, "dough" = 2))

/obj/item/reagent_containers/food/snacks/donkpocket/sinpocket
	reagent_data = list(/singleton/reagent/nutriment = list("delicious cruelty" = 1, "dough" = 2))
	filling_color = "#6D6D00"
	desc_antag = "Use it in hand to heat and release chemicals."
	var/has_been_heated = FALSE

	reagents_to_add = list(/singleton/reagent/nutriment/protein = 1, /singleton/reagent/nutriment = 3)

/obj/item/reagent_containers/food/snacks/donkpocket/sinpocket/attack_self(mob/user)
	if(has_been_heated)
		to_chat(user, SPAN_NOTICE("The heating chemicals have already been spent."))
		return
	has_been_heated = TRUE
	user.visible_message(SPAN_NOTICE("[user] crushes \the [src] package."), "You crush \the [src] package and feel it rapidly heat up.")
	name = "cooked Donk-pocket"
	desc = "The cooked, reheatable food of choice for the seasoned spaceman."
	reagents.add_reagent(/singleton/reagent/drink/doctorsdelight, 5)
	reagents.add_reagent(/singleton/reagent/hyperzine, 1.5)
	reagents.add_reagent(/singleton/reagent/synaptizine, 1.25)

/obj/item/reagent_containers/food/snacks/spacylibertyduff
	name = "spacy liberty duff"
	desc = "Jello gelatin, from Alfred Hubbard's cookbook."
	icon = 'icons/obj/item/reagent_containers/food/baked.dmi'
	icon_state = "spacylibertyduff"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#42B873"
	center_of_mass = list("x"=16, "y"=8)
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/psilocybin = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("mushroom" = 6))
	bitesize = 3
