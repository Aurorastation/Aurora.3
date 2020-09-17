/obj/item/reagent_containers/food/snacks/fish
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"
	reagents_to_add = list(/datum/reagent/nutriment/protein/seafood = 3)
	bitesize = 6
	var/fish_type = "fish"

/obj/item/reagent_containers/food/snacks/fish/attackby(var/obj/item/W, var/mob/user)
	if(is_sharp(W) && (locate(/obj/structure/table) in loc))
		var/transfer_amt = Floor(reagents.total_volume/3)
		for(var/i = 1 to 3)
			var/obj/item/reagent_containers/food/snacks/sashimi/sashimi = new(get_turf(src), fish_type)
			reagents.trans_to(sashimi, transfer_amt)
		qdel(src)

/obj/item/reagent_containers/food/snacks/fish/carpmeat
	name = "carp fillet"
	desc = "A fillet of space carp meat."
	reagents_to_add = list(/datum/reagent/toxin/carpotoxin = 3, /datum/reagent/nutriment/protein/seafood = 3)
	fish_type = "space carp"

/obj/item/reagent_containers/food/snacks/fish/fishfillet
	name = "fish fillet"
	desc = "A fillet of fish."
