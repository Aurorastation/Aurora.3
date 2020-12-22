/obj/structure/bed/stool
	name = "stool"
	desc = "Apply butt."
	icon_state = "stool_preview"
	base_icon = "stool"
	anchored = FALSE
	can_buckle = FALSE
	buckle_dir = 0
	buckle_lying = FALSE //force people to sit up in chairs when buckled
	build_amt = 2
	held_item = /obj/item/material/stool // if null it can't be picked up. Automatically applies materials.

/obj/structure/bed/stool/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(over_object == usr && Adjacent(usr))
		if(!held_item || use_check_and_message(usr) || buckled_mob || !can_dismantle)
			return
		usr.visible_message(SPAN_NOTICE("[usr] grabs \the [src.name]."), SPAN_NOTICE("You grab \the [src.name]."))
		var/obj/item/material/stool/S = new held_item(src.loc, material, padding_material ? padding_material : null) // Handles all the material code so you don't have to.
		TransferComponents(S)
		if(material_alteration & MATERIAL_ALTERATION_COLOR)
			S.color = material.icon_colour
		if(material_alteration & MATERIAL_ALTERATION_NAME)
			S.name = name // Get the name and desc of the stool, rather. We already went through all the trouble in New in bed.dm
		if(material_alteration & MATERIAL_ALTERATION_DESC)
			S.desc = desc
		if(blood_DNA)
			S.blood_DNA |= blood_DNA // Transfer blood.
			S.add_blood()
		S.base_icon = base_icon
		S.dir = dir
		S.origin_type = src.type
		usr.put_in_hands(S)
		qdel(src)

/obj/structure/bed/stool/wood/New(var/newloc)
	..(newloc, MATERIAL_WOOD)

/obj/structure/bed/stool/padded
	icon_state = "stool_padded_preview" //set for the map

/obj/structure/bed/stool/padded/brown/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_LEATHER)

/obj/structure/bed/stool/padded/red/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/structure/bed/stool/padded/teal/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_TEAL)

/obj/structure/bed/stool/padded/black/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLACK)

/obj/structure/bed/stool/padded/green/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_GREEN)

/obj/structure/bed/stool/padded/purp/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_PURPLE)

/obj/structure/bed/stool/padded/blue/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLUE)

/obj/structure/bed/stool/padded/beige/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BEIGE)

/obj/structure/bed/stool/padded/lime/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_LIME)

/obj/structure/bed/stool/bar
	name = "bar stool"
	desc = "It has some unsavory stains on it..."
	base_icon = "bar_stool"
	icon_state = "bar_stool_preview"
	item_state = "bar_stool"

/obj/structure/bed/stool/bar/wood/New(var/newloc)
	..(newloc, MATERIAL_WOOD)

/obj/structure/bed/stool/bar/padded
	icon_state = "bar_stool_padded_preview"

/obj/structure/bed/stool/bar/padded/brown/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_LEATHER)

/obj/structure/bed/stool/bar/padded/red/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/structure/bed/stool/bar/padded/red/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/structure/bed/stool/bar/padded/teal/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_TEAL)

/obj/structure/bed/stool/bar/padded/black/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLACK)

/obj/structure/bed/stool/bar/green/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_GREEN)

/obj/structure/bed/stool/bar/purp/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_PURPLE)

/obj/structure/bed/stool/bar/blue/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BLUE)

/obj/structure/bed/stool/bar/beige/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_BEIGE)

/obj/structure/bed/stool/bar/lime/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH_LIME)

/obj/structure/bed/stool/bar/wood/New(var/newloc)
	..(newloc, MATERIAL_WOOD)

/obj/structure/bed/stool/hover
	name = "hoverstool"
	desc = "Apply butt. Now as comfortable as a cloud."
	icon_state = "hover_stool"
	item_state = "hoverstool"
	material_alteration = MATERIAL_ALTERATION_NAME || MATERIAL_ALTERATION_DESC
	held_item = /obj/item/material/stool/hover

/obj/structure/bed/stool/hover/New(var/newloc, var/new_material)
	..(newloc, MATERIAL_SHUTTLE_SKRELL)

/obj/structure/bed/stool/hover/Initialize()
	.=..()
	set_light(1,1,LIGHT_COLOR_CYAN)

/obj/item/material/stool
	icon = 'icons/obj/furniture.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_chairs.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_chairs.dmi',
		)
	icon_state = "stool_preview" //Ideally you shouldn't be able to see this
	item_state = "stool"
	var/base_icon = "stool"
	randpixel = 0
	center_of_mass = null
	force = 10	// Doesn't really matter. Will get overriden by set_material.
	throwforce = 10
	throw_range = 5
	force_divisor = 0.4
	w_class = ITEMSIZE_HUGE
	use_material_name = FALSE
	applies_material_colour = FALSE
	var/material/padding_material
	var/obj/structure/bed/stool/origin_type = /obj/structure/bed/stool

/obj/item/material/stool/New(var/newloc, var/new_material, var/new_padding_material)
	..(newloc, new_material)	// new_material handled in material_weapons.dm
	if(new_padding_material)
		padding_material = new_padding_material
	update_icon()

/obj/item/material/stool/attack_self(mob/user)
	deploy(user)

/obj/item/material/stool/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	if(prob(300 / force)) // Weaker materials are more likely to shatter on people randomly.
		var/blocked = target.run_armor_check(hit_zone, "melee")
		target.Weaken(force * BLOCKED_MULT(blocked))
		target.apply_damage(force * 2, BRUTE, hit_zone, blocked, src)
		user.visible_message(SPAN_DANGER("[user] [material.destruction_desc] \the [src] to pieces against \the [target]'s [hit_zone]!"), SPAN_DANGER("\The [src] [material.destruction_desc] to pieces against \the [target]'s [hit_zone]!"))
		use_material_shatter = FALSE
		shatter()

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

/obj/item/material/stool/proc/deploy(mob/user)
	for(var/obj/A in get_turf(loc))
		if(istype(A, /obj/structure/bed))
			to_chat(user, SPAN_DANGER("There is already a [A.name] here."))
			return
		if(A.density)
			to_chat(user, SPAN_DANGER("There is already something here."))
			return

	user.visible_message(SPAN_NOTICE("[user] rights \the [src.name]."), SPAN_NOTICE("You right \the [name]."))
	// playsound(src, deploy_sound ? deploy_sound : drop_sound, DROP_SOUND_VOLUME)
	user.drop_from_inventory(src)
	var/obj/structure/bed/stool/S = new origin_type(get_turf(loc))
	TransferComponents(S)
	S.dir = user.dir // Plant it where the user's facing
	if(blood_DNA)
		S.blood_DNA |= blood_DNA // Transfer blood.
	qdel(src)

/obj/item/material/stool/update_icon()
	icon_state = base_icon
	cut_overlays()
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
	if(istype(M)) // Update inhands.
		M.update_inv_l_hand()
		M.update_inv_r_hand()

/obj/item/material/stool/shatter()
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
		padding_material = null
	update_icon()
	..()

/obj/item/material/stool/ex_act(severity)
	switch(severity)
		if(1.0)
			shatter(src)
			return
		if(2.0)
			if(prob(50))
				shatter(src)
				return
		if(3.0)
			if(prob(5))
				shatter(src)
				return

/obj/item/material/stool/hover
	name = "hoverstool"
	desc = "Apply butt. Now as comfortable as a cloud."
	icon_state = "hover_stool"
	item_state = "hoverstool"
