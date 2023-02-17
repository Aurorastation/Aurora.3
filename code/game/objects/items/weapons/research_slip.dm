/obj/item/research_slip
	name = "research slip"
	desc = "A small slip of plastic with an embedded chip. It is commonly used to store small amounts of research data."
	desc_info = "This item is to be used in the destructive analyzer to gain research points."
	icon = 'icons/obj/item/tools/research_slip.dmi'
	icon_state = "slip"
	contained_sprite = TRUE

/obj/item/research_slip/Initialize(mapload, var/list/research_levels)
	. = ..()
	if(length(research_levels))
		origin_tech = research_levels
