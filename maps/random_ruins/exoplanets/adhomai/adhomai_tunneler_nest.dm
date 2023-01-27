/datum/map_template/ruin/exoplanet/adhomai_tunneler_nest
	name = "Ice Tunneler Nest"
	id = "adhomai_tunneler_nest"
	description = "A nest used by the ice tunnelers to lay their eggs."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/adhomai_tunneler_nest.dmm")


/obj/structure/ice_tunneler_nest
	name = "ice tunneler nest"
	desc = "A burrow used by the Adhomian ice tunnelers to deposit their eggs."
	icon = 'icons/mob/npc/adhomai.dmi'
	icon_state = "tunneler_nest0"
	anchored = TRUE
	var/eggs = 3

/obj/structure/ice_tunneler_nest/Initialize()
	. = ..()
	update_icon()

/obj/structure/ice_tunneler_nest/update_icon()
	icon_state = "tunneler_nest[eggs]"

/obj/structure/ice_tunneler_nest/attack_hand(mob/user)
	if(!eggs)
		to_chat(user, SPAN_WARNING("\The [src] is empty."))
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/reagent_containers/food/snacks/egg/ice_tunnelers/E = new/obj/item/reagent_containers/food/snacks/egg/ice_tunnelers (get_turf(src))
		H.put_in_hands(E)
		eggs--
		update_icon()