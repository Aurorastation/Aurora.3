//Todo: add leather and cloth for arbitrary coloured stools.

/obj/item/stool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "stool_preview" //set for the map
	randpixel = 0
	center_of_mass = null
	force = 10
	throwforce = 10
	w_class = ITEMSIZE_HUGE
	item_state_slots = list(
		slot_l_hand_str = "stool",
		slot_r_hand_str = "stool"
	)
	var/base_icon = "stool"
	var/material/material
	var/material/padding_material

/obj/item/stool/padded
	icon_state = "stool_padded_preview" //set for the map

/obj/item/stool/New(var/newloc, var/new_material, var/new_padding_material)
	..(newloc)
	if(!new_material)
		new_material = DEFAULT_WALL_MATERIAL
	material = SSmaterials.get_material_by_name(new_material)
	if(new_padding_material)
		padding_material = SSmaterials.get_material_by_name(new_padding_material)
	if(!istype(material))
		qdel(src)
		return
	force = round(material.get_blunt_damage()*0.4)
	update_icon()

/obj/item/stool/padded/New(var/newloc, var/new_material)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/item/stool/wood/New(var/newloc, var/new_material)
	..(newloc, MATERIAL_WOOD)

/obj/item/stool/bar
	name = "bar stool"
	base_icon = "bar_stool"
	icon_state = "bar_stool_preview"

/obj/item/stool/bar/padded
	icon_state = "bar_stool_padded_preview"

/obj/item/stool/bar/padded/New(var/newloc, var/new_material)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/item/stool/hover
	name = "hoverstool"
	desc = "Apply butt. Now as comfortable as a cloud."
	icon_state = "hover_stool"
	item_state_slots = null

/obj/item/stool/hover/New(var/newloc, var/new_material)
	..(newloc, MATERIAL_SHUTTLE_SKRELL)

/obj/item/stool/hover/Initialize()
	.=..()
	set_light(1,1,LIGHT_COLOR_CYAN)

/obj/item/stool/hover/update_icon()
	return

/obj/item/stool/update_icon()
	// Prep icon.
	icon_state = ""
	cut_overlays()
	var/list/stool_cache = SSicon_cache.stool_cache
	// Base icon.
	var/cache_key = "[initial(name)]-[material.name]"
	if(!stool_cache[cache_key])
		var/image/I = image(icon, base_icon)
		I.color = material.icon_colour
		stool_cache[cache_key] = I
	add_overlay(stool_cache[cache_key])
	// Padding overlay.
	if(padding_material)
		var/padding_cache_key = "[initial(name)]-padding-[padding_material.name]"
		if(!stool_cache[padding_cache_key])
			var/image/I = image(icon, "[base_icon]_padding")
			I.color = padding_material.icon_colour
			stool_cache[padding_cache_key] = I
		add_overlay(stool_cache[padding_cache_key])
	// Strings.
	if(padding_material)
		name = "[padding_material.display_name] [initial(name)]" //this is not perfect but it will do for now.
		desc = "A padded stool. Apply butt. It's made of [material.use_name] and covered with [padding_material.use_name]."
	else
		name = "[material.display_name] [initial(name)]"
		desc = "A stool. Apply butt with care. It's made of [material.use_name]."

/obj/item/stool/proc/add_padding(var/padding_type)
	padding_material = SSmaterials.get_material_by_name(padding_type)
	update_icon()

/obj/item/stool/proc/remove_padding()
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
		padding_material = null
	update_icon()

/obj/item/stool/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	if (prob(5))
		user.visible_message("<span class='danger'>[user] breaks [src] over [target]'s back!</span>")
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(target)

		user.remove_from_mob(src)
		dismantle()
		qdel(src)

		var/blocked = target.get_blocked_ratio(hit_zone, BRUTE)
		target.Weaken(10 * (1 - blocked))
		target.apply_damage(20, BRUTE, hit_zone, blocked, src)
		return

	..()

/obj/item/stool/ex_act(severity)
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

/obj/item/stool/proc/dismantle()
	if(material)
		material.place_sheet(get_turf(src))
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
	qdel(src)

/obj/item/stool/attackby(obj/item/W as obj, mob/user as mob)
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
		if(!istype(src.loc, /turf))
			user.drop_from_inventory(src)
			src.forceMove(get_turf(src))
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
