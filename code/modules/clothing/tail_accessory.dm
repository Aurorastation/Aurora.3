/obj/item/clothing/tail_accessory
	name = "tail accessory"
	desc = DESC_PARENT
	w_class = ITEMSIZE_SMALL

	var/list/compatible_species_type = list()
	var/list/compatible_tail_type = list()
	var/list/compatible_animated_tail = list()

/obj/item/clothing/tail_accessory/proc/compatible_with_human(var/mob/living/carbon/human/H)
	if(!is_type_in_list(H.species, compatible_species_type))
		to_chat(H, SPAN_WARNING("\The [src] doesn't fit on your tail!"))
		return FALSE

	if(!(H.tail_style in compatible_tail_type))
		to_chat(H, SPAN_WARNING("\The [src] doesn't fit on your tail!"))
		return FALSE

	return TRUE

/obj/item/clothing/tail_accessory/tail_cloth
	name = "tail cloth"
	desc = "A simple cloth that can be wrapped around the tail."
	icon = 'icons/clothing/tail/tajtailcloth.dmi'
	icon_state = "tail_cloth"

	compatible_species_type = list(/datum/species/tajaran)
	compatible_tail_type = list("Tail")
	compatible_animated_tail = list("Tail")
