/obj/item/forensics/slide
	name = "microscope slide"
	desc = "A pair of thin glass panes used in the examination of samples beneath a microscope."
	icon_state = "slide"
	var/obj/item/forensics/swab/has_swab
	var/obj/item/sample/fibers/has_sample

/obj/item/forensics/slide/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Used with fibers and GSR swab tests to examine the samples in the microscope."
	. += "To empty them, use in hand."

/obj/item/forensics/slide/Initialize(mapload, ...)
	. = ..()
	create_reagents(5)

/obj/item/forensics/slide/attackby(obj/item/attacking_item, mob/user)
	if(has_swab || has_sample || reagents.total_volume)
		to_chat(user, SPAN_WARNING("There is already a sample in the slide."))
		return
	if(istype (attacking_item, /obj/item/forensics/swab))
		has_swab = attacking_item
	else if(istype(attacking_item, /obj/item/sample/fibers))
		has_sample = attacking_item
	else if(istype(attacking_item, /obj/item/reagent_containers) && REAGENT_VOLUME(attacking_item.reagents, /singleton/reagent/biological_tissue))
		attacking_item.reagents.trans_type_to(reagents, /singleton/reagent/biological_tissue, 5)
	else
		to_chat(user, SPAN_WARNING("You don't think this will fit."))
		return
	to_chat(user, SPAN_NOTICE("You insert the sample into the slide."))
	user.unEquip(attacking_item)
	attacking_item.forceMove(src)
	update_icon()

/obj/item/forensics/slide/attack_self(var/mob/user)
	if(has_swab || has_sample)
		to_chat(user, SPAN_NOTICE("You remove \the sample from \the [src]."))
		if(has_swab)
			user.put_in_hands(has_swab)
			has_swab = null
		if(has_sample)
			user.put_in_hands(has_sample)
			has_sample = null
		update_icon()
		return

/obj/item/forensics/slide/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(istype(target,  /obj/item/reagent_containers) && reagents.total_volume)
		reagents.trans_to_holder(target.reagents, 5)
		to_chat(user, SPAN_NOTICE("You remove the sample from \the [src]."))

/obj/item/forensics/slide/update_icon()
	if(!has_swab && !has_sample)
		icon_state = "slide"
	else if(has_swab)
		icon_state = "slideswab"
	else if(has_sample)
		icon_state = "slidefiber"
	else if(reagents.total_volume)
		icon_state = "slidecells"
