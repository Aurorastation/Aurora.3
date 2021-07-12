/obj/item/material/star
	name = "shuriken"
	desc = "A sharp, perfectly weighted piece of metal."
	icon_state = "star"
	icon = 'icons/obj/weapons.dmi'
	force_divisor = 0.1 // 6 with hardness 60 (steel)
	thrown_force_divisor = 0.75 // 15 with weight 20 (steel)
	throw_speed = 10
	throw_range = 15
	sharp = 1
	edge = TRUE
	w_class = ITEMSIZE_SMALL

/obj/item/material/star/Initialize(newloc, material_key)
	. = ..()
	src.pixel_x = rand(-12, 12)
	src.pixel_y = rand(-12, 12)

/obj/item/material/star/throw_impact(atom/hit_atom)
	..()
	if (istype(hit_atom,/mob/living))

		var/mob/living/M = hit_atom

		if(material.radioactivity > 0)
			M.adjustToxLoss(material.radioactivity*2)

		if(prob(30))
			M.Weaken(7)
