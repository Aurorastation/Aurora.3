// Glass shards

/obj/item/material/shard
	name = "shard"
	icon = 'icons/obj/shards.dmi'
	desc = "Made of nothing. How does this even exist?" // set based on material, if this desc is visible it's a bug (shards default to being made of glass)
	icon_state = "large"
	randpixel = 8
	sharp = 1
	edge = TRUE
	recyclable = TRUE
	w_class = ITEMSIZE_SMALL
	force_divisor = 0.2 // 6 with hardness 30 (glass)
	thrown_force_divisor = 0.4 // 4 with weight 15 (glass)
	item_state = "shard-glass"
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	default_material = "glass"
	unbreakable = 1 //It's already broken.
	drops_debris = 0
	drop_sound = 'sound/effects/glass_step.ogg'

/obj/item/material/shard/set_material(var/new_material)
	..(new_material)
	if(!istype(material))
		return

	icon_state = "[material.shard_icon][pick("large", "medium", "small")]"
	randpixel_xy()
	update_icon()

	if(material.shard_type)
		name = "[material.display_name] [material.shard_type]"
		desc = "A small piece of [material.display_name]. It looks sharp, you wouldn't want to step on it barefoot. Could probably be used as ... a throwing weapon?"
		switch(material.shard_type)
			if(SHARD_SPLINTER, SHARD_SHRAPNEL)
				gender = PLURAL
			else
				gender = NEUTER
	else
		qdel(src)

/obj/item/material/shard/update_icon()
	if(material)
		color = material.icon_colour
		// 1-(1-x)^2, so that glass shards with 0.3 opacity end up somewhat visible at 0.51 opacity
		alpha = 255 * (1 - (1 - material.opacity)*(1 - material.opacity))
	else
		color = "#ffffff"
		alpha = 255

/obj/item/material/shard/attackby(obj/item/W as obj, mob/user as mob)
	if(W.iswelder() && material.shard_can_repair)
		var/obj/item/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			material.place_sheet(user.loc)
			qdel(src)
			return
	return ..()

/obj/item/material/shard/Crossed(AM as mob|obj)
	..()
	if(isliving(AM))
		var/mob/M = AM

		if(M.buckled_to) //wheelchairs, office chairs, rollerbeds
			return

		to_chat(M, SPAN_DANGER("You step on \the [src]!"))
		playsound(src.loc, 'sound/effects/glass_step.ogg', 50, 1) // not sure how to handle metal shards with sounds
		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			if(H.species.siemens_coefficient<0.5 || isunathi(H) || isvaurca(H) || (H.species.flags & (NO_EMBED))) //Thick skin.
				return

			if( H.shoes || ( H.wear_suit && (H.wear_suit.body_parts_covered & FEET) ) )
				return

			var/list/check = list(BP_L_FOOT, BP_R_FOOT)
			while(check.len)
				var/picked = pick(check)
				var/obj/item/organ/external/affecting = H.get_organ(picked)
				if(affecting)
					if(affecting.status & ORGAN_ROBOT)
						return
					if(affecting.take_damage(5, 0))
						H.UpdateDamageIcon()
					H.updatehealth()
					if(H.can_feel_pain())
						H.Weaken(3)
					return
				check -= picked
			return

// Preset types - left here for the code that uses them
/obj/item/material/shard/shrapnel/Initialize(newloc, material_key)
	. = ..(loc, MATERIAL_STEEL)

/obj/item/material/shard/shrapnel/flechette/Initialize(newloc, material_key)
	. = ..(loc, MATERIAL_TITANIUM)

/obj/item/material/shard/phoron/Initialize(newloc, material_key)
	. = ..(loc, MATERIAL_GLASS_PHORON)

/obj/item/material/shard/wood/Initialize(newloc, material_key)
	. = ..(loc, MATERIAL_WOOD)
