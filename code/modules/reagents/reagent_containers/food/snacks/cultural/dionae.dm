
/obj/item/reagent_containers/food/snacks/sliceable/dionaroast
	name = "roast diona"
	desc = "It's like an enormous, leathery carrot. With an eye."
	icon = 'icons/obj/item/reagent_containers/food/cultural/dionae.dmi'
	icon_state = "dionaroast"
	trash = /obj/item/trash/plate
	filling_color = "#75754B"
	center_of_mass = list("x"=16, "y"=7)
	reagents_to_add = list(/singleton/reagent/nutriment = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("dionae delicacy" = 3))
	bitesize = 2
	slice_path = /obj/item/reagent_containers/food/snacks/diona_cuts
	slices_num = 3

/obj/item/reagent_containers/food/snacks/diona_cuts
	name = "dionae cuts"
	desc = "A plate of succulent slow roasted dionae nymph slices."
	icon = 'icons/obj/item/reagent_containers/food/cultural/dionae.dmi'
	icon_state = "dionaecuts"
	trash = /obj/item/trash/waffles
	bitesize = 2

/obj/item/reagent_containers/food/snacks/diona_cuts/filled
	reagent_data = list(/singleton/reagent/nutriment = list("diona delicacy" = 5))
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/radium = 2)

/obj/item/reagent_containers/food/snacks/stew/diona
	name = "dionae stew"
	desc = "A steaming bowl of juicy dionae nymph. Extra cosy."
	icon = 'icons/obj/item/reagent_containers/food/cultural/dionae.dmi'
	icon_state = "dionaestew"
	reagent_data = list(/singleton/reagent/nutriment = list("diona delicacy" = 5))
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/drink/carrotjuice = 2, /singleton/reagent/drink/potatojuice = 2, /singleton/reagent/radium = 2)
	filling_color = "#BD8939"

/obj/item/reagent_containers/food/snacks/soup/diona
	name = "dionae soup"
	desc = "An aromatic, healthy dish made from boiled dionae nymph."
	icon = 'icons/obj/item/reagent_containers/food/cultural/dionae.dmi'
	icon_state = "dionaesoup"
	reagent_data = list(/singleton/reagent/nutriment = list("diona delicacy" = 5))
	reagents_to_add = list(/singleton/reagent/nutriment = 11, /singleton/reagent/water = 5, /singleton/reagent/radium = 2)
