/obj/item/material/stool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/furniture.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_chairs.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_chairs.dmi',
		)
	icon_state = "stool_preview" //set for the map
	item_state = "stool"
	randpixel = 0
	center_of_mass = null
	force = 10
	throwforce = 10
	force_divisor = 0.4
	w_class = ITEMSIZE_HUGE
	use_material_name = FALSE
	applies_material_colour = FALSE
	var/base_icon = "stool"
	var/material/padding_material

/obj/item/material/stool/update_icon()
	icon_state = base_icon
	cut_overlays()
	color = material.icon_colour
	if(padding_material)
		build_from_parts = TRUE
		worn_overlay = "padding"
		var/image/padding_overlay = image(icon, "[base_icon]_padding")
		padding_overlay.appearance_flags = RESET_COLOR
		if(padding_material.icon_colour)
			padding_overlay.color = padding_material.icon_colour
			worn_overlay_color = padding_material.icon_colour
		add_overlay(padding_overlay)
	else
		build_from_parts = FALSE
	var/mob/M = loc
	if(istype(M))
		M.update_inv_l_hand()
		M.update_inv_r_hand()

/obj/item/material/stool/proc/add_padding(var/padding_type)
	padding_material = SSmaterials.get_material_by_name(padding_type)
	update_icon()

/obj/item/material/stool/proc/remove_padding()
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
		padding_material = null
	update_icon()

/obj/item/material/stool/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	if(prob(50))
		var/blocked = target.run_armor_check(hit_zone, "melee")
		target.Weaken(force * BLOCKED_MULT(blocked))
		target.apply_damage(force * 2, BRUTE, hit_zone, blocked, src)
		user.visible_message("<span class='danger'>[user] [material.destruction_desc] \the [src] over [target]'s [hit_zone]!</span>")
		use_material_shatter = FALSE
		shatter()

/obj/item/material/stool/shatter()
	if(padding_material)
		remove_padding()
	..()

/obj/item/material/stool/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				qdel(src)
				return

/obj/item/material/stool/proc/dismantle()
	if(material)
		material.place_sheet(get_turf(src))
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
	qdel(src)

/obj/item/material/stool/attackby(obj/item/W as obj, mob/user as mob)
	if(W.iswrench())
		playsound(src.loc, W.usesound, 50, 1)
		dismantle()
		qdel(src)
	else if(istype(W,/obj/item/stack))
		if(padding_material)
			to_chat(user, "\The [src] is already padded.")
			return
		var/obj/item/stack/C = W
		if(C.get_amount() < 1) // How??
			qdel(C)
			return
		var/padding_type //This is awful but it needs to be like this until tiles are given a material var.
		if(istype(W,/obj/item/stack/tile/carpet))
			padding_type = MATERIAL_CARPET
		else if(istype(W,/obj/item/stack/material))
			var/obj/item/stack/material/M = W
			if(M.material && (M.material.flags & MATERIAL_PADDING))
				padding_type = "[M.material.name]"
		if(!padding_type)
			to_chat(user, "You cannot pad \the [src] with that.")
			return
		C.use(1)
		to_chat(user, "You add padding to \the [src].")
		add_padding(padding_type)
		return
	else if (W.iswirecutter())
		if(!padding_material)
			to_chat(user, "\The [src] has no padding to remove.")
			return
		to_chat(user, "You remove the padding from \the [src].")
		playsound(src, 'sound/items/wirecutter.ogg', 100, 1)
		remove_padding()
	else
		..()

/obj/item/material/stool/New(var/newloc, var/new_material, var/new_padding_material)
	..(newloc, new_material)	// new_material handled in material_weapons.dm
	if(new_padding_material)
		padding_material = SSmaterials.get_material_by_name(new_padding_material)
		worn_overlay_color = padding_material.icon_colour	// Apply the padding to the inhands.
		build_from_parts = TRUE
	if(!istype(material))
		qdel(src)
		return
	update_icon()

/obj/item/material/stool/padded
	icon_state = "stool_padded_preview" //set for the map

/obj/item/material/stool/padded/brown/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_LEATHER)

/obj/item/material/stool/padded/red/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/item/material/stool/padded/red/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/item/material/stool/padded/teal/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_TEAL)

/obj/item/material/stool/padded/black/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLACK)

/obj/item/material/stool/padded/green/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_GREEN)

/obj/item/material/stool/padded/purp/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_PURPLE)

/obj/item/material/stool/padded/blue/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLUE)

/obj/item/material/stool/padded/beige/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BEIGE)

/obj/item/material/stool/padded/lime/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_LIME)

/obj/item/material/stool/wood/New(var/newloc)
	..(newloc, MATERIAL_WOOD)

/obj/item/material/stool/bar
	name = "bar stool"
	desc = "It has some unsavory stains on it..."
	base_icon = "bar_stool"
	icon_state = "bar_stool_preview"
	item_state = "bar_stool"

/obj/item/material/stool/bar/wood/New(var/newloc)
	..(newloc, MATERIAL_WOOD)

/obj/item/material/stool/bar/padded
	icon_state = "bar_stool_padded_preview"

/obj/item/material/stool/bar/padded/brown/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_LEATHER)

/obj/item/material/stool/bar/padded/red/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/item/material/stool/bar/padded/red/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/item/material/stool/bar/padded/teal/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_TEAL)

/obj/item/material/stool/bar/padded/black/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLACK)

/obj/item/material/stool/bar/green/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_GREEN)

/obj/item/material/stool/bar/purp/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_PURPLE)

/obj/item/material/stool/bar/blue/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLUE)

/obj/item/material/stool/bar/beige/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BEIGE)

/obj/item/material/stool/bar/lime/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_LIME)

/obj/item/material/stool/bar/wood/New(var/newloc)
	..(newloc, MATERIAL_WOOD)


/obj/item/material/stool/bar/padded/red/New(var/newloc, var/new_material)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/item/material/stool/hover
	name = "hoverstool"
	desc = "Apply butt. Now as comfortable as a cloud."
	icon_state = "hover_stool"
	item_state = "hoverstool"

/obj/item/material/stool/hover/New(var/newloc, var/new_material)
	..(newloc, MATERIAL_SHUTTLE_SKRELL)

/obj/item/material/stool/hover/Initialize()
	.=..()
	set_light(1,1,LIGHT_COLOR_CYAN)

/obj/item/material/stool/hover/update_icon()
	return
