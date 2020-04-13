/obj/item/clothing
	name = "clothing"
	siemens_coefficient = 0.9
	drop_sound = 'sound/items/drop/clothing.ogg'
	var/flash_protection = FLASH_PROTECTION_NONE	// Sets the item's level of flash protection.
	var/tint = TINT_NONE							// Sets the item's level of visual impairment tint.
	var/list/species_restricted = null 				//Only these species can wear this kit.
	var/gunshot_residue //Used by forensics.

	var/list/accessories
	var/list/valid_accessory_slots
	var/list/restricted_accessory_slots
	var/list/starting_accessories
	/*
		Sprites used when the clothing item is refit. This is done by setting icon_override.
		For best results, if this is set then sprite_sheets should be null and vice versa, but that is by no means necessary.
		Ideally, sprite_sheets_refit should be used for "hard" clothing items that can't change shape very well to fit the wearer (e.g. helmets, voidsuits),
		while sprite_sheets should be used for "flexible" clothing items that do not need to be refitted (e.g. vox wearing jumpsuits).
	*/
	var/list/sprite_sheets_refit = null

	//material things
	var/material/material = null
	var/applies_material_color = TRUE
	var/unbreakable = FALSE
	var/default_material = null // Set this to something else if you want material attributes on init.
	var/material_armor_modifer = 1 // Adjust if you want seperate types of armor made from the same material to have different protectiveness (e.g. makeshift vs real armor)
	var/refittable = TRUE // If false doesn't let the clothing be refit in suit cyclers


/obj/item/clothing/Initialize(var/mapload, var/material_key)
	. = ..(mapload)
	if(!material_key)
		material_key = default_material
	if(material_key) // May still be null if a material was not specified as a default.
		set_material(material_key)
	if(starting_accessories)
		for(var/T in starting_accessories)
			var/obj/item/clothing/accessory/tie = new T(src)
			src.attach_accessory(null, tie)

/obj/item/clothing/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	QDEL_NULL_LIST(accessories)
	return ..()

//Updates the icons of the mob wearing the clothing item, if any.
/obj/item/clothing/proc/update_clothing_icon()
	return

// Aurora forensics port.
/obj/item/clothing/clean_blood()
	. = ..()
	gunshot_residue = null

/obj/item/proc/negates_gravity()
	return 0

//BS12: Species-restricted clothing check.
/obj/item/clothing/mob_can_equip(M as mob, slot)

	//if we can't equip the item anyway, don't bother with species_restricted (cuts down on spam)
	if (!..())
		return 0

	if(species_restricted && istype(M,/mob/living/carbon/human))
		var/exclusive = null
		var/wearable = null
		var/mob/living/carbon/human/H = M

		if("exclude" in species_restricted)
			exclusive = 1

		if(H.species)
			if(exclusive)
				if(!(H.species.get_bodytype() in species_restricted))
					wearable = 1
			else
				if(H.species.get_bodytype() in species_restricted)
					wearable = 1

			if(!wearable && !(slot in list(slot_l_store, slot_r_store, slot_s_store)))
				to_chat(H, "<span class='danger'>Your species cannot wear [src].</span>")
				return 0
	return 1

/obj/item/clothing/proc/refit_for_species(var/target_species)
	if(!species_restricted)
		return //this item doesn't use the species_restricted system

	//Set species_restricted list
	switch(target_species)
		if("Human", "Skrell", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame")	//humanoid bodytypes
			species_restricted = list(
				"Human",
				"Skrell",
				"Zeng-Hu Mobility Frame",
				"Bishop Accessory Frame"
			) //skrell/humans like to share with IPCs
		else
			species_restricted = list(target_species)

	//Set icon
	if (sprite_sheets_refit && (target_species in sprite_sheets_refit))
		icon_override = sprite_sheets_refit[target_species]
	else
		icon_override = initial(icon_override)

	if (sprite_sheets_obj && (target_species in sprite_sheets_obj))
		icon = sprite_sheets_obj[target_species]
	else
		icon = initial(icon)

/obj/item/clothing/head/helmet/refit_for_species(var/target_species)
	if(!species_restricted)
		return //this item doesn't use the species_restricted system

	//Set species_restricted list
	switch(target_species)
		if("Skrell", "Human")
			species_restricted = list("Human", "Skrell", "Machine") // skrell helmets like to share

		else
			species_restricted = list(target_species)

	//Set icon
	if (sprite_sheets_refit && (target_species in sprite_sheets_refit))
		icon_override = sprite_sheets_refit[target_species]
	else
		icon_override = initial(icon_override)

	if (sprite_sheets_obj && (target_species in sprite_sheets_obj))
		icon = sprite_sheets_obj[target_species]
	else
		icon = initial(icon)

//material related procs

/obj/item/clothing/get_material()
	return material

/obj/item/clothing/proc/set_material(var/new_material)
	material = SSmaterials.get_material_by_name(new_material)
	if(!material)
		qdel(src)
	else
		name = "[material.display_name] [initial(name)]"
		health = round(material.integrity/10)
		if(applies_material_color)
			color = material.icon_colour
		if(material.products_need_process())
			START_PROCESSING(SSprocessing, src)
		update_armor()

// This is called when someone wearing the object gets hit in some form (melee, bullet_act(), etc).
// Note that this cannot change if someone gets hurt, as it merely reacts to being hit.
/obj/item/clothing/proc/clothing_impact(var/obj/source, var/damage)
	if(material && damage)
		material_impact(source, damage)

/obj/item/clothing/proc/material_impact(var/obj/source, var/damage)
	if(!material || unbreakable)
		return

	if(istype(source, /obj/item/projectile))
		var/obj/item/projectile/P = source
		if(P.pass_flags & PASSGLASS)
			if(material.opacity - 0.3 <= 0)
				return // Lasers ignore 'fully' transparent material.

	if(material.is_brittle())
		health = 0
	else if(!prob(material.hardness))
		health--

	if(health <= 0)
		shatter()

/obj/item/clothing/proc/shatter()
	if(!material)
		return
	var/turf/T = get_turf(src)
	T.visible_message("<span class='danger'>\The [src] [material.destruction_desc]!</span>")
	if(istype(loc, /mob/living))
		var/mob/living/M = loc
		if(material.shard_type == SHARD_SHARD) // Wearing glass armor is a bad idea.
			var/obj/item/material/shard/S = material.place_shard(T)
			M.embed(S)

	playsound(src.loc, "shatter", 70, 1)
	qdel(src)

/obj/item/clothing/suit/armor/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(!material) // No point checking for reflection.
		return ..()

	if(material.reflectivity)
		if(istype(damage_source, /obj/item/projectile/energy) || istype(damage_source, /obj/item/projectile/beam))
			var/obj/item/projectile/P = damage_source

			var/reflectchance = 40 - round(damage/3)
			if(!(def_zone in list(BP_CHEST, BP_GROIN)))
				reflectchance /= 2
			if(P.starting && prob(reflectchance))
				visible_message("<span class='danger'>\The [user]'s [src.name] reflects [attack_text]!</span>")

				// Find a turf near or on the original location to bounce to
				var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
				var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)

				// redirect the projectile
				P.firer = user
				P.old_style_target(locate(new_x, new_y, P.z))

				return PROJECTILE_CONTINUE // complete projectile permutation

/proc/calculate_material_armor(amount)
	var/result = 1 - MATERIAL_ARMOR_COEFFICENT * amount / (1 + MATERIAL_ARMOR_COEFFICENT * abs(amount))
	result = result * 100
	result = abs(result - 100)
	return round(result)


/obj/item/clothing/proc/update_armor()
	if(material)
		var/melee_armor = 0, bullet_armor = 0, laser_armor = 0, energy_armor = 0, bomb_armor = 0

		melee_armor = calculate_material_armor(material.protectiveness * material_armor_modifer)

		bullet_armor = calculate_material_armor((material.protectiveness * (material.hardness / 100) * material_armor_modifer) * 0.7)

		laser_armor = calculate_material_armor((material.protectiveness * (material.reflectivity + 1) * material_armor_modifer) * 0.7)
		if(material.opacity != 1)
			laser_armor *= max(material.opacity - 0.3, 0) // Glass and such has an opacity of 0.3, but lasers should go through glass armor entirely.

		energy_armor = calculate_material_armor((material.protectiveness * material_armor_modifer) * 0.4)

		bomb_armor = calculate_material_armor((material.protectiveness * material_armor_modifer) * 0.5)

		// Makes sure the numbers stay capped.
		for(var/number in list(melee_armor, bullet_armor, laser_armor, energy_armor, bomb_armor))
			number = between(0, number, 100)

		armor["melee"] = melee_armor
		armor["bullet"] = bullet_armor
		armor["laser"] = laser_armor
		armor["energy"] = energy_armor
		armor["bomb"] = bomb_armor

		if(!isnull(material.conductivity))
			siemens_coefficient = between(0, material.conductivity / 10, 10)
		slowdown = between(0, round(material.weight / 10, 0.1), 6)

///////////////////////////////////////////////////////////////////////
// Ears: headsets, earmuffs and tiny objects
/obj/item/clothing/ears
	name = "ears"
	w_class = 1.0
	throwforce = 2
	slot_flags = SLOT_EARS

/obj/item/clothing/ears/attack_hand(mob/user as mob)
	if (!user) return

	if (src.loc != user || !istype(user,/mob/living/carbon/human))
		..()
		return

	var/mob/living/carbon/human/H = user
	if(H.l_ear != src && H.r_ear != src)
		..()
		return

	if(!canremove)
		return

	var/obj/item/clothing/ears/O
	if(slot_flags & SLOT_TWOEARS )
		O = (H.l_ear == src ? H.r_ear : H.l_ear)
		user.u_equip(O)
		if(!istype(src,/obj/item/clothing/ears/offear))
			qdel(O)
			O = src
	else
		O = src

	user.u_equip(src)

	if (O)
		user.put_in_hands(O)
		O.add_fingerprint(user)

	if(istype(src,/obj/item/clothing/ears/offear))
		qdel(src)

/obj/item/clothing/ears/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_ears()

/obj/item/clothing/ears/offear
	name = "Other ear"
	w_class = 5.0
	icon = 'icons/mob/screen/midnight.dmi'
	icon_state = "blocked"
	slot_flags = SLOT_EARS | SLOT_TWOEARS

	New(var/obj/O)
		name = O.name
		desc = O.desc
		icon = O.icon
		icon_state = O.icon_state
		set_dir(O.dir)

///////////////////////////////////////////////////////////////////////
//Gloves
/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = 2.0
	icon = 'icons/obj/clothing/gloves.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_gloves.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_gloves.dmi'
		)
	siemens_coefficient = 0.75
	var/wired = 0
	var/obj/item/cell/cell = 0
	var/clipped = 0
	var/fingerprint_chance = 0
	var/obj/item/clothing/ring/ring = null		//Covered ring
	var/mob/living/carbon/human/wearer = null	//Used for covered rings when dropping
	var/punch_force = 0			//How much damage do these gloves add to a punch?
	var/punch_damtype = BRUTE	//What type of damage does this make fists be?
	body_parts_covered = HANDS
	slot_flags = SLOT_GLOVES
	attack_verb = list("challenged")
	species_restricted = list("exclude","Unathi","Tajara","Vaurca", "Golem","Vaurca Breeder","Vaurca Warform")
	sprite_sheets = list(
		"Vox" = 'icons/mob/species/vox/gloves.dmi'
		)
	drop_sound = 'sound/items/drop/gloves.ogg'

/obj/item/clothing/gloves/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_gloves()

/obj/item/clothing/gloves/emp_act(severity)
	if(cell)
		//why is this not part of the powercell code?
		cell.charge -= 1000 / severity
		if (cell.charge < 0)
			cell.charge = 0
	if(ring)
		ring.emp_act(severity)
	..()

// Called just before an attack_hand(), in mob/UnarmedAttack()
/obj/item/clothing/gloves/proc/Touch(var/atom/A, mob/user, var/proximity)
	return 0 // return 1 to cancel attack_hand()

/obj/item/clothing/gloves/attackby(obj/item/W, mob/user)
	..()
	if(W.iswirecutter() || istype(W, /obj/item/surgery/scalpel))
		if (clipped)
			to_chat(user, "<span class='notice'>\The [src] have already been clipped!</span>")
			update_icon()
			return

		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		user.visible_message("<span class='warning'>[user] cuts the fingertips off of \the [src].</span>","<span class='warning'>You cut the fingertips off of \the [src].</span>")

		clipped = 1
		siemens_coefficient += 0.25
		name = "modified [name]"
		desc = "[desc]<br>They have had the fingertips cut off of them."
		if("exclude" in species_restricted)
			species_restricted -= "Unathi"
			species_restricted -= "Tajara"
			species_restricted -= "Vaurca"
		return

/obj/item/clothing/gloves/mob_can_equip(mob/user, slot)
	var/mob/living/carbon/human/H = user
	if(slot && slot == slot_gloves)
		if(istype(H.gloves, /obj/item/clothing/ring))
			ring = H.gloves
			if(!ring.undergloves)
				to_chat(user, "You are unable to wear \the [src] as \the [H.gloves] are in the way.")
				ring = null
				return 0
			H.drop_from_inventory(ring,src)

	if(!..())
		if(ring) //Put the ring back on if the check fails.
			if(H.equip_to_slot_if_possible(ring, slot_gloves))
				src.ring = null
		return 0

	if (ring)
		to_chat(user, "You slip \the [src] on over \the [ring].")
	wearer = H
	return 1

/obj/item/clothing/gloves/proc/update_wearer()
	if(!wearer)
		return

	var/mob/living/carbon/human/H = wearer
	if(ring && istype(H))
		if(!H.equip_to_slot_if_possible(ring, slot_gloves))
			ring.forceMove(get_turf(src))
		src.ring = null
	wearer = null

/obj/item/clothing/gloves/dropped()
	..()
	addtimer(CALLBACK(src, .proc/update_wearer), 0)

/obj/item/clothing/gloves/mob_can_unequip()
	. = ..()
	if (.)
		addtimer(CALLBACK(src, .proc/update_wearer), 0)

///////////////////////////////////////////////////////////////////////
//Head
/obj/item/clothing/head
	name = "head"
	icon = 'icons/obj/clothing/hats.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_hats.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_hats.dmi'
		)
	body_parts_covered = HEAD
	slot_flags = SLOT_HEAD
	w_class = 2.0
	uv_intensity = 50 //Light emitted by this object or creature has limited interaction with diona
	species_restricted = list("exclude","Vaurca Breeder","Vaurca Warform")

	drop_sound = 'sound/items/drop/hat.ogg'

	var/light_overlay = "helmet_light"
	var/light_applied
	var/brightness_on
	var/on = 0

	sprite_sheets = list(
		"Vox" = 'icons/mob/species/vox/head.dmi'
		)

/obj/item/clothing/head/attack_self(mob/user)
	if(brightness_on)
		if(!isturf(user.loc))
			to_chat(user, "You cannot turn the light on while in this [user.loc]")
			return
		on = !on
		to_chat(user, "You [on ? "enable" : "disable"] the helmet light.")
		update_flashlight(user)
	else
		return ..(user)

/obj/item/clothing/head/proc/update_flashlight(var/mob/user = null)
	if(on && !light_applied)
		set_light(brightness_on)
		light_applied = 1
	else if(!on && light_applied)
		set_light(0)
		light_applied = 0
	update_icon(user)
	user.update_action_buttons()

/obj/item/clothing/head/attack_ai(var/mob/user)
	if(!mob_wear_hat(user))
		return ..()

/obj/item/clothing/head/attack_generic(var/mob/user)
	if(!mob_wear_hat(user))
		return ..()

/obj/item/clothing/head/proc/mob_wear_hat(var/mob/user)
	if(!Adjacent(user))
		return 0
	var/success
	if(istype(user, /mob/living/silicon/robot/drone))
		var/mob/living/silicon/robot/drone/D = user
		if(D.hat)
			success = 2
		else
			D.wear_hat(src)
			success = 1
	else if(istype(user, /mob/living/carbon/alien/diona))
		var/mob/living/carbon/alien/diona/D = user
		if(D.hat)
			success = 2
		else
			D.wear_hat(src)
			success = 1

	if(!success)
		return 0
	else if(success == 2)
		to_chat(user, "<span class='warning'>You are already wearing a hat.</span>")
	else if(success == 1)
		to_chat(user, "<span class='notice'>You crawl under \the [src].</span>")
	return 1

/obj/item/clothing/head/update_icon(var/mob/user)

	cut_overlays()
	var/mob/living/carbon/human/H
	if(istype(user,/mob/living/carbon/human))
		H = user

	if(on)
		// Generate object icon.
		if(!SSicon_cache.light_overlay_cache["[light_overlay]_icon"])
			SSicon_cache.light_overlay_cache["[light_overlay]_icon"] = image("icon" = 'icons/obj/light_overlays.dmi', "icon_state" = "[light_overlay]")
		add_overlay(SSicon_cache.light_overlay_cache["[light_overlay]_icon"])

		// Generate and cache the on-mob icon, which is used in update_inv_head().
		var/cache_key = "[light_overlay][H ? "_[H.species.get_bodytype()]" : ""]"
		if(!SSicon_cache.light_overlay_cache[cache_key])
			var/use_icon = 'icons/mob/light_overlays.dmi'
			SSicon_cache.light_overlay_cache[cache_key] = image("icon" = use_icon, "icon_state" = "[light_overlay]")

	if(H)
		H.update_inv_head()

/obj/item/clothing/head/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_head()

///////////////////////////////////////////////////////////////////////
//Mask
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/masks.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_masks.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_masks.dmi'
		)
	slot_flags = SLOT_MASK
	drop_sound = 'sound/items/drop/hat.ogg'
	body_parts_covered = FACE|EYES
	sprite_sheets = list(
		"Vox" = 'icons/mob/species/vox/masks.dmi',
		"Tajara" = 'icons/mob/species/tajaran/mask.dmi',
		"Unathi" = 'icons/mob/species/unathi/mask.dmi')

	species_restricted = list("exclude","Vaurca Breeder","Vaurca Warform")

	var/voicechange = 0
	var/list/say_messages
	var/list/say_verbs
	var/down_gas_transfer_coefficient = 0
	var/down_body_parts_covered = 0
	var/down_item_flags = 0
	var/down_flags_inv = 0
	var/adjustable = FALSE
	var/hanging = 0

/obj/item/clothing/mask/Initialize()
	. = ..()
	if(adjustable)
		action_button_name = "Adjust Mask"
		verbs += /obj/item/clothing/mask/proc/adjust_mask

/obj/item/clothing/mask/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_mask()

/obj/item/clothing/mask/proc/filter_air(datum/gas_mixture/air)
	return

/obj/item/clothing/mask/proc/adjust_mask(mob/user, var/self = TRUE)
	set name = "Adjust Mask"
	set category = "Object"

	if(!adjustable)
		return

	if(self)
		if(use_check_and_message(user))
			return
	else
		if(use_check_and_message(user, USE_ALLOW_NON_ADJACENT))
			return

	hanging = !hanging

	if(hanging)
		gas_transfer_coefficient = down_gas_transfer_coefficient
		body_parts_covered = down_body_parts_covered
		icon_state = "[icon_state]down"
		item_flags = down_item_flags
		flags_inv = down_flags_inv
		if(self)
			user.visible_message(span("notice", "[user] pulls \the [src] down to hang around \his neck."), span("notice", "You pull \the [src] down to hang around your neck."))
	else
		gas_transfer_coefficient = initial(gas_transfer_coefficient)
		body_parts_covered = initial(body_parts_covered)
		icon_state = initial(icon_state)
		item_state = initial(icon_state)
		item_flags = initial(item_flags)
		flags_inv = initial(flags_inv)
		if(self)
			user.visible_message(span("notice", "[user] pulls \the [src] up to cover \his face."), span("notice", "You pull \the [src] up to cover your face."))
	usr.update_action_buttons()
	update_clothing_icon()

/obj/item/clothing/mask/attack_self(mob/user)
	if(adjustable)
		adjust_mask(user)

///////////////////////////////////////////////////////////////////////
//Shoes
/obj/item/clothing/shoes
	name = "shoes"
	icon = 'icons/obj/clothing/shoes.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_shoes.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_shoes.dmi'
		)
	desc = "Comfortable-looking shoes."
	gender = PLURAL //Carn: for grammarically correct text-parsing
	siemens_coefficient = 0.9
	body_parts_covered = FEET
	slot_flags = SLOT_FEET
	drop_sound = 'sound/items/drop/shoes.ogg'

	var/can_hold_knife
	var/obj/item/holding

	var/shoes_under_pants = 0

	permeability_coefficient = 0.50
	force = 0
	var/overshoes = 0
	species_restricted = list("exclude","Unathi","Tajara","Vox","Vaurca","Vaurca Breeder","Vaurca Warform")
	sprite_sheets = list("Vox" = 'icons/mob/species/vox/shoes.dmi')
	var/silent = 0
	sprite_sheets = list(
		"Vox" = 'icons/mob/species/vox/shoes.dmi'
		)

/obj/item/clothing/shoes/proc/draw_knife()
	set name = "Draw Boot Knife"
	set desc = "Pull out your boot knife."
	set category = "Object"
	set src in usr

	if(usr.stat || usr.restrained() || usr.incapacitated())
		return

	holding.forceMove(get_turf(usr))

	if(usr.put_in_hands(holding))
		usr.visible_message("<span class='danger'>\The [usr] pulls \a [holding] out of their boot!</span>")
		holding = null
		playsound(get_turf(src), 'sound/weapons/holster/sheathout.ogg', 25)
	else
		to_chat(usr, "<span class='warning'>Your need an empty, unbroken hand to do that.</span>")
		holding.forceMove(src)

	if(!holding)
		verbs -= /obj/item/clothing/shoes/proc/draw_knife

	update_icon()
	return


/obj/item/clothing/shoes/attackby(var/obj/item/I, var/mob/user)
	if(can_hold_knife && is_type_in_list(I, list(/obj/item/material/shard, /obj/item/material/kitchen/utensil, /obj/item/material/knife)))
		if(holding)
			to_chat(user, "<span class='warning'>\The [src] is already holding \a [holding].</span>")
			return
		user.unEquip(I)
		I.forceMove(src)
		holding = I
		user.visible_message("<span class='notice'>\The [user] shoves \the [I] into \the [src].</span>")
		verbs |= /obj/item/clothing/shoes/proc/draw_knife
		update_icon()
	else
		return ..()

/obj/item/clothing/shoes/verb/toggle_layer()
	set name = "Switch Shoe Layer"
	set category = "Object"

	if(shoes_under_pants == -1)
		usr << "<span class='notice'>\The [src] cannot be worn above your suit!</span>"
		return
	shoes_under_pants = !shoes_under_pants
	update_icon()

/obj/item/clothing/shoes/update_icon()
	overlays.Cut()
	if(holding)
		overlays += image(icon, "[icon_state]_knife")
	if(ismob(usr))
		var/mob/M = usr
		M.update_inv_shoes()
	return ..()

/obj/item/clothing/shoes/update_icon()
	cut_overlays()
	if(holding)
		add_overlay("[icon_state]_knife")
	return ..()

/obj/item/clothing/shoes/proc/handle_movement(var/turf/walking, var/running)
	return

/obj/item/clothing/shoes/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_shoes()

///////////////////////////////////////////////////////////////////////
//Suit
/obj/item/clothing/suit
	icon = 'icons/obj/clothing/suits.dmi'
	name = "suit"
	var/fire_resist = T0C+100
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	allowed = list(/obj/item/tank/emergency_oxygen)
	armor = null
	slot_flags = SLOT_OCLOTHING
	var/blood_overlay_type = "suit"
	siemens_coefficient = 0.9
	w_class = 3
	species_restricted = list("exclude","Vaurca Breeder","Vaurca Warform")

	sprite_sheets = list(
		"Vox" = 'icons/mob/species/vox/suit.dmi'
		)

	valid_accessory_slots = list("armband","decor", "over")

/obj/item/clothing/suit/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_suit()

///////////////////////////////////////////////////////////////////////
//Under clothing
/obj/item/clothing/under
	icon = 'icons/obj/clothing/uniforms.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_uniforms.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_uniforms.dmi'
		)
	name = "under"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	permeability_coefficient = 0.90
	slot_flags = SLOT_ICLOTHING
	armor = null
	w_class = 3
	var/has_sensor = 1 //For the crew computer 2 = unable to change mode
	var/sensor_mode = 0
		/*
		1 = Report living/dead
		2 = Report detailed damages
		3 = Report location
		*/
	var/displays_id = 1
	var/rolled_down = -1 //0 = unrolled, 1 = rolled, -1 = cannot be toggled
	var/rolled_sleeves = -1 //0 = unrolled, 1 = rolled, -1 = cannot be toggled
	sprite_sheets = list(
		"Vox" = 'icons/mob/species/vox/uniform.dmi',
		"Golem" = 'icons/mob/uniform_fat.dmi')
	species_restricted = list("exclude","Vaurca Breeder","Vaurca Warform")

	//convenience var for defining the icon state for the overlay used when the clothing is worn.
	//Also used by rolling/unrolling.
	var/worn_state = null
	valid_accessory_slots = list("utility","armband","decor", "over")
	restricted_accessory_slots = list("utility")


/obj/item/clothing/under/attack_hand(var/mob/user)
	if(LAZYLEN(accessories))
		..()
	if ((ishuman(usr) || issmall(usr)) && src.loc == user)
		return
	..()

/obj/item/clothing/under/Initialize()
	. = ..()
	if(worn_state)
		LAZYINITLIST(item_state_slots)
		item_state_slots[slot_w_uniform_str] = worn_state
	else
		worn_state = icon_state

	//autodetect rollability
	if(rolled_down < 0)
		if (!SSicon_cache.uniform_states)
			SSicon_cache.setup_uniform_mappings()

		if (SSicon_cache.uniform_states["[worn_state]_d_s"])
			rolled_down = 0

/obj/item/clothing/under/proc/update_rolldown_status()
	var/mob/living/carbon/human/H
	if(istype(src.loc, /mob/living/carbon/human))
		H = src.loc

	var/icon/under_icon
	if(icon_override)
		under_icon = icon_override
	else if(H && sprite_sheets && sprite_sheets[H.species.get_bodytype()])
		under_icon = sprite_sheets[H.species.get_bodytype()]
	else if(item_icons && item_icons[slot_w_uniform_str])
		under_icon = item_icons[slot_w_uniform_str]
	else
		under_icon = INV_W_UNIFORM_DEF_ICON

	// The _s is because the icon update procs append it.
	if(("[worn_state]_d_s") in icon_states(under_icon))
		if(rolled_down != 1)
			rolled_down = 0
	else
		rolled_down = -1
	if(H) update_clothing_icon()

/obj/item/clothing/under/proc/update_rollsleeves_status()
	var/mob/living/carbon/human/H
	if(istype(src.loc, /mob/living/carbon/human))
		H = src.loc

	var/icon/under_icon
	if(icon_override)
		under_icon = icon_override
	else if(H && sprite_sheets && sprite_sheets[H.species.get_bodytype(H)])
		under_icon = sprite_sheets[H.species.get_bodytype(H)]
	else if(item_icons && item_icons[slot_w_uniform_str])
		under_icon = item_icons[slot_w_uniform_str]
	else
		under_icon = INV_W_UNIFORM_DEF_ICON

	// The _s is because the icon update procs append it.
	if(("[worn_state]_r_s") in icon_states(under_icon))
		if(rolled_sleeves != 1)
			rolled_sleeves = 0
	else
		rolled_sleeves = -1
	if(H) update_clothing_icon()

/obj/item/clothing/under/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_w_uniform()


/obj/item/clothing/under/examine(mob/user)
	..(user)
	switch(src.sensor_mode)
		if(0)
			to_chat(user, "Its sensors appear to be disabled.")
		if(1)
			to_chat(user, "Its binary life sensors appear to be enabled.")
		if(2)
			to_chat(user, "Its vital tracker appears to be enabled.")
		if(3)
			to_chat(user, "Its vital tracker and tracking beacon appear to be enabled.")

/obj/item/clothing/under/proc/set_sensors(mob/usr as mob)
	var/mob/M = usr
	if(M.stat || M.paralysis || M.stunned || M.weakened || M.restrained())
		to_chat(usr, "You cannot reach your suit sensors like this...")
		return
	if(has_sensor >= 2)
		to_chat(usr, "The controls are locked.")
		return 0
	if(has_sensor <= 0)
		to_chat(usr, "This suit does not have any sensors.")
		return 0

	var/list/modes = list("Off", "Binary sensors", "Vitals tracker", "Tracking beacon")
	var/switchMode = input("Select a sensor mode:", "Suit Sensor Mode", modes[sensor_mode + 1]) in modes
	if(get_dist(usr, src) > 1)
		to_chat(usr, "You have moved too far away.")
		return
	sensor_mode = modes.Find(switchMode) - 1

	if (src.loc == usr)
		switch(sensor_mode)
			if(0)
				to_chat(usr, "You disable your suit's remote sensing equipment.")
			if(1)
				to_chat(usr, "Your suit will now report whether you are live or dead.")
			if(2)
				to_chat(usr, "Your suit will now report your vital lifesigns.")
			if(3)
				to_chat(usr, "Your suit will now report your vital lifesigns as well as your coordinate position.")
	else if (istype(src.loc, /mob))
		switch(sensor_mode)
			if(0)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("<span class='warning'>[usr] disables [src.loc]'s remote sensing equipment.</span>", 1)
			if(1)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("[usr] turns [src.loc]'s remote sensors to binary.", 1)
			if(2)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("[usr] sets [src.loc]'s sensors to track vitals.", 1)
			if(3)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("[usr] sets [src.loc]'s sensors to maximum.", 1)

/obj/item/clothing/under/verb/toggle()
	set name = "Toggle Suit Sensors"
	set category = "Object"
	set src in usr
	set_sensors(usr)

/obj/item/clothing/under/verb/rollsuit()
	set name = "Roll Down Jumpsuit"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	update_rolldown_status()
	if(rolled_down == -1)
		to_chat(usr, "<span class='notice'>You cannot roll down [src]!</span>")
	if((rolled_sleeves == 1) && !(rolled_down))
		rolled_sleeves = 0
		return

	rolled_down = !rolled_down
	if(rolled_down)
		body_parts_covered &= LOWER_TORSO|LEGS|FEET
		item_state_slots[slot_w_uniform_str] = "[worn_state]_d"
	else
		body_parts_covered = initial(body_parts_covered)
		item_state_slots[slot_w_uniform_str] = "[worn_state]"
	update_clothing_icon()

/obj/item/clothing/under/verb/rollsleeves()
	set name = "Roll Up Sleeves"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	update_rollsleeves_status()
	if(rolled_sleeves == -1)
		to_chat(usr, "<span class='notice'>You cannot roll up your [src]'s sleeves!</span>")
		return
	if(rolled_down == 1)
		to_chat(usr, "<span class='notice'>You must roll up your [src] first!</span>")
		return

	rolled_sleeves = !rolled_sleeves
	if(rolled_sleeves)
		body_parts_covered &= ~(ARMS|HANDS)
		item_state_slots[slot_w_uniform_str] = "[worn_state]_r"
		to_chat(usr, "<span class='notice'>You roll up your [src]'s sleeves.</span>")
	else
		body_parts_covered = initial(body_parts_covered)
		item_state_slots[slot_w_uniform_str] = "[worn_state]"
		to_chat(usr, "<span class='notice'>You roll down your [src]'s sleeves.</span>")
	update_clothing_icon()

/obj/item/clothing/under/rank/Initialize()
	sensor_mode = pick(0,1,2,3)
	. = ..()


//Rings

/obj/item/clothing/ring
	name = "ring"
	w_class = 1
	icon = 'icons/obj/clothing/rings.dmi'
	slot_flags = SLOT_GLOVES
	gender = NEUTER
	drop_sound = 'sound/items/drop/ring.ogg'
	var/undergloves = 1