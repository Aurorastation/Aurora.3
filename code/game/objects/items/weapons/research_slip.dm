/obj/item/research_slip
	name = "research slip"
	desc = "A small slip of plastic with an embedded chip. It is commonly used to store small amounts of research data."
	icon = 'icons/obj/item/research_slip.dmi'
	icon_state = "slip_nt"
	contained_sprite = TRUE

/obj/item/research_slip/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "This item is to be used in the destructive analyzer to gain research points."

/obj/item/research_slip/Initialize(mapload, var/list/research_levels)
	. = ..()
	if(length(research_levels))
		origin_tech = research_levels
