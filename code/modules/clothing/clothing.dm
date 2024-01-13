/obj/item/clothing
	name = "clothing"
	siemens_coefficient = 0.9
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'
	var/flash_protection = FLASH_PROTECTION_NONE	// Sets the item's level of flash protection.
	var/tint = TINT_NONE							// Sets the item's level of visual impairment tint.
	var/list/species_restricted = null 				//Only these species can wear this kit.
	var/list/gunshot_residue //Used by forensics.

	var/list/accessories
	var/list/valid_accessory_slots
	var/list/restricted_accessory_slots
	var/list/starting_accessories
	/*
		Sprites used when the clothing item is refit. This is done by setting icon_override.
		For best results, if this is set then sprite_sheets should be null and vice versa, but that is by no means necessary.
		Ideally, sprite_sheets_refit should be used for "hard" clothing items that can't change shape very well to fit the wearer (e.g. helmets, voidsuits),
		while sprite_sheets should be used for "flexible" clothing items that do not need to be refitted (e.g. special species wearing jumpsuits).
	*/
	var/list/sprite_sheets_refit = null

	var/species_sprite_adaption_type = WORN_UNDER

	//material things
	var/material/material = null
	var/applies_material_color = TRUE
	var/unbreakable = FALSE
	var/default_material = null // Set this to something else if you want material attributes on init.
	var/material_armor_modifer = 1 // Adjust if you want seperate types of armor made from the same material to have different protectiveness (e.g. makeshift vs real armor)
	var/refittable = TRUE // If false doesn't let the clothing be refit in suit cyclers
	var/no_overheat = FALSE  // Checks to see if the clothing is ignored for the purpose of overheating messages.

	var/move_trail = /obj/effect/decal/cleanable/blood/tracks/footprints

	/// Measured in Celsius, when worn, the clothing modifies the baseline temperature by this much
	var/body_temperature_change = 0

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
	update_icon()

/obj/item/clothing/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	QDEL_NULL_LIST(accessories)
	return ..()

//Updates the icons of the mob wearing the clothing item, if any.
/obj/item/clothing/proc/update_clothing_icon()
	return

/obj/item/clothing/proc/build_and_apply_species_adaption()
	if(!contained_sprite)
		return
	if(type in GLOB.contained_clothing_species_adaption_cache)
		var/list/adaption_cache = GLOB.contained_clothing_species_adaption_cache[type]
		if(length(adaption_cache))
			icon_auto_adapt = TRUE
			icon_supported_species_tags = adaption_cache
		return
	var/list/new_adaption_cache = list()
	var/list/all_icon_states = icon_states(icon)
	for(var/short_name in GLOB.all_species_short_names)
		if((short_name + "_" + item_state + species_sprite_adaption_type) in all_icon_states)
			new_adaption_cache += short_name
	GLOB.contained_clothing_species_adaption_cache[type] = length(new_adaption_cache) ? new_adaption_cache : null
	if(length(new_adaption_cache))
		icon_auto_adapt = TRUE
		icon_supported_species_tags = new_adaption_cache

// Aurora forensics port.
/obj/item/clothing/clean_blood()
	. = ..()
	LAZYCLEARLIST(gunshot_residue)

/obj/item/proc/negates_gravity()
	return 0

//BS12: Species-restricted clothing check.
/obj/item/clothing/mob_can_equip(M as mob, slot, disable_warning = FALSE, bypass_blocked_check = FALSE)

	//if we can't equip the item anyway, don't bother with species_restricted (cuts down on spam)
	if (!..())
		return 0

	if(species_restricted && ishuman(M) && !(slot in list(slot_l_hand, slot_r_hand)))
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
				if(!disable_warning)
					to_chat(H, SPAN_DANGER("Your species cannot wear [src]."))
				return 0
	return 1

// putting on to a slot
/obj/item/clothing/equipped(mob/user, slot, assisted_equip)
	. = ..()
	if(tint)
		user.handle_vision()

// taking off
/obj/item/clothing/dropped(mob/user)
	. = ..()
	if(tint)
		user.handle_vision()

/obj/item/clothing/handle_middle_mouse_click(mob/user)
	if(Adjacent(user))
		var/obj/item/clothing/accessory/storage/S = locate() in accessories
		if(S?.hold)
			S.hold.open(user)
			return TRUE
	return FALSE

/obj/item/clothing/proc/return_own_image()
	var/image/our_image
	if(icon_override)
		our_image = image(icon_override, icon_state)
	else if(item_icons && (slot_head_str in item_icons))
		our_image = image(item_icons[slot_head_str], icon_state)
	our_image.color = color
	return our_image

/obj/item/clothing/proc/refit_for_species(var/target_species)
	if(!species_restricted)
		return //this item doesn't use the species_restricted system

	//Set species_restricted list
	switch(target_species)
		if(BODYTYPE_HUMAN, BODYTYPE_SKRELL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP)	//humanoid bodytypes
			species_restricted = list(
				BODYTYPE_HUMAN,
				BODYTYPE_SKRELL,
				BODYTYPE_IPC_ZENGHU,
				BODYTYPE_IPC_BISHOP
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
		if(BODYTYPE_SKRELL, BODYTYPE_HUMAN)
			species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_SKRELL, BODYTYPE_IPC) // skrell helmets like to share

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
	T.visible_message(SPAN_DANGER("\The [src] [material.destruction_desc]!"))
	if(istype(loc, /mob/living))
		var/mob/living/M = loc
		if(material.shard_type == SHARD_SHARD) // Wearing glass armor is a bad idea.
			var/obj/item/material/shard/S = material.place_shard(T)
			M.embed(S)

	playsound(src.loc, /singleton/sound_category/glass_break_sound, 70, 1)
	qdel(src)

/obj/item/clothing/suit/armor/handle_shield(mob/user, var/on_back, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(!material) // No point checking for reflection.
		return ..()

	if(material.reflectivity)
		if(istype(damage_source, /obj/item/projectile/energy) || istype(damage_source, /obj/item/projectile/beam))
			var/obj/item/projectile/P = damage_source

			var/reflectchance = 40 - round(damage/3)
			if(!(def_zone in list(BP_CHEST, BP_GROIN)))
				reflectchance /= 2
			if(P.starting && prob(reflectchance))
				visible_message(SPAN_DANGER("\The [user]'s [src.name] reflects [attack_text]!"))

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

		var/datum/component/armor/armor_component = GetComponent(/datum/component/armor)
		if(istype(armor_component))
			armor_component.RemoveComponent()
		var/list/armor_list = list(
			melee = melee_armor,
			bullet = bullet_armor,
			laser = laser_armor,
			energy = energy_armor,
			bomb = bomb_armor
		)
		AddComponent(/datum/component/armor, armor_list)

		if(!isnull(material.conductivity))
			siemens_coefficient = between(0, material.conductivity / 10, 10)
		slowdown = between(0, round(material.weight / 10, 0.1), 6)

/obj/item/clothing/proc/get_accessory(var/typepath)
	if(istype(src, typepath))
		return src
	if(LAZYLEN(accessories))
		var/accessory = locate(typepath) in accessories
		if(accessory)
			return accessory
	return null

/obj/item/clothing/proc/recalculate_body_temperature_change()
	body_temperature_change = initial(body_temperature_change)
	for(var/obj/item/clothing/accessory/accessory as anything in accessories)
		body_temperature_change += accessory.body_temperature_change

///////////////////////////////////////////////////////////////////////
// Ears: headsets, earmuffs and tiny objects
/obj/item/clothing/ears
	name = "ears"
	icon = 'icons/obj/clothing/ears.dmi'
	species_sprite_adaption_type = WORN_LEAR
	w_class = ITEMSIZE_TINY
	throwforce = 2
	slot_flags = SLOT_EARS

	sprite_sheets = list(
		BODYTYPE_TAJARA = 'icons/mob/species/tajaran/l_ear.dmi',
		)

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

	if(slot_flags & SLOT_TWOEARS)
		var/obj/item/clothing/ears/OE = (H.l_ear == src ? H.r_ear : H.l_ear)
		qdel(OE)

	user.u_equip(src)
	user.put_in_hands(src)
	src.add_fingerprint(user)

/obj/item/clothing/ears/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_l_ear()
		M.update_inv_r_ear()

/obj/item/clothing/ears/offear
	name = "Other ear"
	w_class = ITEMSIZE_HUGE
	icon = 'icons/mob/screen/midnight.dmi'
	icon_state = "blocked"
	slot_flags = SLOT_EARS | SLOT_TWOEARS

	sprite_sheets = list(
		BODYTYPE_TAJARA = 'icons/mob/species/tajaran/r_ear.dmi',
		)

/obj/item/clothing/ears/offear/proc/copy_ear(var/obj/O)
	name = O.name
	desc = O.desc
	icon = O.icon
	icon_state = O.icon_state
	color = O.color
	overlays = O.overlays
	set_dir(O.dir)

/obj/item/clothing/ears/offear/attack_hand(mob/living/carbon/human/H)
	var/obj/item/clothing/ears/OE = (H.l_ear == src ? H.r_ear : H.l_ear)
	OE.attack_hand(H)
	qdel(src)

/obj/item/clothing/ears/offear/attackby(obj/item/I, mob/user)
	var/mob/living/carbon/human/H = loc // we will never not be on a humanoid
	var/obj/item/clothing/ears/OE = (H.l_ear == src ? H.r_ear : H.l_ear)
	OE.attackby(I, user)

///////////////////////////////////////////////////////////////////////
//Gloves
/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = ITEMSIZE_SMALL
	icon = 'icons/obj/clothing/gloves.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/clothing/lefthand_gloves.dmi',
		slot_r_hand_str = 'icons/mob/items/clothing/righthand_gloves.dmi'
		)
	species_sprite_adaption_type = WORN_GLOVES
	siemens_coefficient = 0.75
	var/wired = FALSE
	var/obj/item/cell/cell = 0
	var/clipped = 0
	var/fingerprint_chance = 0
	var/obj/item/clothing/ring/ring = null		//Covered ring
	var/mob/living/carbon/human/wearer = null	//Used for covered rings when dropping
	var/punch_force = 0			//How much damage do these gloves add to a punch?
	var/punch_damtype = DAMAGE_BRUTE	//What type of damage does this make fists be?
	body_parts_covered = HANDS
	slot_flags = SLOT_GLOVES
	attack_verb = list("challenged")
	species_restricted = list("exclude",BODYTYPE_UNATHI,BODYTYPE_TAJARA,BODYTYPE_VAURCA, BODYTYPE_GOLEM,BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_VAURCA_BULWARK,BODYTYPE_TESLA_BODY)
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/obj/item/clothing/gloves/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_gloves()

/obj/item/clothing/gloves/get_mob_overlay(mob/living/carbon/human/H, mob_icon, mob_state, slot)
	var/image/I = ..()
	if(blood_DNA && slot != slot_l_hand_str && slot != slot_r_hand_str)
		var/image/bloodsies = image(H.species.blood_mask, "bloodyhands")
		bloodsies.color = blood_color
		I.add_overlay(bloodsies)
	return I

/obj/item/clothing/gloves/emp_act(severity)
	. = ..()

	if(cell)
		//why is this not part of the powercell code?
		cell.charge -= 1000 / severity
		if (cell.charge < 0)
			cell.charge = 0
	if(ring)
		ring.emp_act(severity)

// Called just before an attack_hand(), in mob/UnarmedAttack()
/obj/item/clothing/gloves/proc/Touch(var/atom/A, mob/user, var/proximity)
	return 0 // return 1 to cancel attack_hand()

/obj/item/clothing/gloves/attackby(obj/item/W, mob/user)
	..()
	if(is_sharp(W))
		if(clipped)
			to_chat(user, SPAN_NOTICE("\The [src] have already been clipped!"))
			update_icon()
			return

		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		user.visible_message(SPAN_WARNING("[user] cuts the fingertips off of \the [src]."),SPAN_WARNING("You cut the fingertips off of \the [src]."))

		clipped = 1
		siemens_coefficient += 0.25
		name = "modified [name]"
		desc = "[desc]<br>They have had the fingertips cut off of them."
		if("exclude" in species_restricted)
			species_restricted -= BODYTYPE_UNATHI
			species_restricted -= BODYTYPE_TAJARA
			species_restricted -= BODYTYPE_VAURCA
		return

/obj/item/clothing/gloves/mob_can_equip(mob/user, slot, disable_warning = FALSE)
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
		H.equip_to_slot(ring, slot_gloves)
		ring = null
	wearer = null

/obj/item/clothing/gloves/dropped()
	..()
	INVOKE_ASYNC(src, PROC_REF(update_wearer))

/obj/item/clothing/gloves/mob_can_unequip()
	. = ..()
	if (.)
		INVOKE_ASYNC(src, PROC_REF(update_wearer))

/obj/item/clothing/gloves/clothing_class()
	return "gloves"

///////////////////////////////////////////////////////////////////////
//Head
/obj/item/clothing/head
	name = "head"
	icon = 'icons/obj/clothing/hats.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/clothing/lefthand_hats.dmi',
		slot_r_hand_str = 'icons/mob/items/clothing/righthand_hats.dmi'
		)
	species_sprite_adaption_type = WORN_HEAD
	body_parts_covered = HEAD
	slot_flags = SLOT_HEAD
	w_class = ITEMSIZE_SMALL
	uv_intensity = 50 //Light emitted by this object or creature has limited interaction with diona
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)

	drop_sound = 'sound/items/drop/hat.ogg'
	pickup_sound = 'sound/items/pickup/hat.ogg'

	valid_accessory_slots = list(ACCESSORY_SLOT_HEAD)

	var/allow_hair_covering = TRUE //in case if you want to allow someone to switch the BLOCKHEADHAIR var from the helmet or not

	var/light_overlay = "helmet_light"
	var/light_applied
	var/brightness_on
	var/on = 0

/obj/item/clothing/head/Initialize(mapload, material_key)
	. = ..()
	if(allow_hair_covering)
		verbs += /obj/item/clothing/head/proc/toggle_block_hair

/obj/item/clothing/head/proc/toggle_block_hair()
	set name = "Toggle Hair Coverage"
	set category = "Object"
	set src in usr

	if(allow_hair_covering)
		flags_inv ^= BLOCKHEADHAIR
		to_chat(usr, SPAN_NOTICE("[src] will now [flags_inv & BLOCKHEADHAIR ? "hide" : "show"] hair."))
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			H.update_hair()

/obj/item/clothing/head/get_image_key_mod()
	return on

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

#define WEAR_HAT 1
#define ALREADY_WEARING_HAT 2
/obj/item/clothing/head/proc/mob_wear_hat(var/mob/user)
	if(!Adjacent(user))
		return FALSE
	var/success
	if(istype(user, /mob/living/silicon/robot/drone))
		var/mob/living/silicon/robot/drone/D = user
		if(D.hat)
			if(alert("You are already wearing a [D.hat]. Swap with [src]?",,"Yes","No") == "Yes")
				D.hat.forceMove(get_turf(src))
				D.hat = null
				D.cut_overlay(D.hat_overlay)
				success = WEAR_HAT
			else
				success = ALREADY_WEARING_HAT
		if(success != ALREADY_WEARING_HAT)
			D.wear_hat(src)
			success = WEAR_HAT
	else if(istype(user, /mob/living/carbon/alien/diona))
		var/mob/living/carbon/alien/diona/D = user
		if(D.hat)
			success = ALREADY_WEARING_HAT
		else
			D.wear_hat(src)
			success = WEAR_HAT

	if(!success)
		return FALSE
	else if(success == WEAR_HAT)
		to_chat(user, SPAN_NOTICE("You crawl under \the [src]."))
	return TRUE
#undef WEAR_HAT
#undef ALREADY_WEARING_HAT

/obj/item/clothing/head/return_own_image()
	var/image/our_image
	if(contained_sprite)
		auto_adapt_species(src)
		var/state = "[UNDERSCORE_OR_NULL(src.icon_species_tag)][item_state][WORN_HEAD]"
		our_image = image(icon_override || icon, state)
	else if(icon_override)
		our_image = image(icon_override, icon_state)
	else if(item_icons && (slot_head_str in item_icons))
		our_image = image(item_icons[slot_head_str], icon_state)
	else
		our_image = image(INV_HEAD_DEF_ICON, icon_state)
	our_image.color = color
	return our_image

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

	..()

	if(H)
		H.update_inv_head()

/obj/item/clothing/head/get_mob_overlay(mob/living/carbon/human/H, mob_icon, mob_state, slot)
	var/image/I = ..()
	if(slot == slot_l_hand_str || slot == slot_r_hand_str)
		for(var/obj/item/clothing/accessory/A in accessories)
			A.accessory_mob_overlay.cut_overlays()
	else
		for(var/obj/item/clothing/accessory/A in accessories)
			var/image/accessory_image = A.get_accessory_mob_overlay(H)
			I.add_overlay(accessory_image)

	if(blood_DNA && slot != slot_l_hand_str && slot != slot_r_hand_str)
		var/image/bloodsies = image(H.species.blood_mask, icon_state = "helmetblood")
		bloodsies.color = blood_color
		bloodsies.appearance_flags = RESET_ALPHA
		I.add_overlay(bloodsies)
	return I

/obj/item/clothing/head/build_shifted_additional_parts(mob/living/carbon/human/H, mob_icon, slot, var/icon/canvas, var/list/facing_list, use_dir)
	canvas = ..()
	if(on && slot == slot_head_str)
		var/icon/lights_icon = new('icons/mob/light_overlays.dmi', icon_state = light_overlay, dir = use_dir)
		canvas.Blend(lights_icon, ICON_OVERLAY, facing_list["x"]+1, facing_list["y"]+1)
	return canvas

/obj/item/clothing/head/build_additional_parts(mob/living/carbon/human/H, mob_icon, slot)
	var/image/I = ..()
	if(!I)
		I = image(null)
	var/cache_key = "[light_overlay]_[H.cached_bodytype || (H.cached_bodytype = H.species.get_bodytype())]"
	if(on && SSicon_cache.light_overlay_cache[cache_key] && slot == slot_head_str)
		I.add_overlay(SSicon_cache.light_overlay_cache[cache_key])
	return I

/obj/item/clothing/head/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_head()

/obj/item/clothing/head/clothing_class()
	return "helmet"

///////////////////////////////////////////////////////////////////////
//Mask
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/masks.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/clothing/lefthand_masks.dmi',
		slot_r_hand_str = 'icons/mob/items/clothing/righthand_masks.dmi'
		)
	species_sprite_adaption_type = WORN_MASK
	slot_flags = SLOT_MASK
	drop_sound = 'sound/items/drop/hat.ogg'
	pickup_sound = 'sound/items/pickup/hat.ogg'
	body_parts_covered = FACE|EYES
	sprite_sheets = list(
		BODYTYPE_TAJARA = 'icons/mob/species/tajaran/mask.dmi',
		BODYTYPE_UNATHI = 'icons/mob/species/unathi/mask.dmi'
		)

	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_VAURCA_BULWARK, BODYTYPE_TESLA_BODY)

	var/voicechange = 0
	var/list/say_messages
	var/list/say_verbs
	var/down_gas_transfer_coefficient = 0
	var/down_body_parts_covered = 0
	var/down_item_flags = 0
	var/down_flags_inv = 0
	var/adjustable = FALSE
	var/hanging = 0

	var/has_blood_overlay = TRUE

/obj/item/clothing/mask/Initialize()
	. = ..()
	if(adjustable)
		action_button_name = "Adjust Mask"
		verbs += /obj/item/clothing/mask/proc/adjust_mask

/obj/item/clothing/mask/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_mask()

/obj/item/clothing/mask/get_mob_overlay(mob/living/carbon/human/H, mob_icon, mob_state, slot)
	var/image/I = ..()
	if(blood_DNA && has_blood_overlay && slot != slot_l_hand_str && slot != slot_r_hand_str)
		var/image/bloodsies = image(H.species.blood_mask, "maskblood")
		bloodsies.color = blood_color
		bloodsies.appearance_flags = RESET_ALPHA
		I.add_overlay(bloodsies)
	return I

/obj/item/clothing/mask/proc/filter_air(datum/gas_mixture/air)
	return

/obj/item/clothing/mask/proc/adjust_mask(mob/user, var/self = TRUE)
	set name = "Adjust Mask"
	set category = "Object"
	set src in usr

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
		adjust_sprites()
		item_flags = down_item_flags
		flags_inv = down_flags_inv
		if(self)
			lower_message(user)
	else
		gas_transfer_coefficient = initial(gas_transfer_coefficient)
		body_parts_covered = initial(body_parts_covered)
		adjust_sprites()
		item_flags = initial(item_flags)
		flags_inv = initial(flags_inv)
		if(self)
			raise_message(user)
	usr.update_action_buttons()
	update_clothing_icon()

/obj/item/clothing/mask/proc/adjust_sprites()
	if(hanging)
		icon_state = "[icon_state]down"
		item_state = "[item_state]down"
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)

/obj/item/clothing/mask/proc/lower_message(mob/user)
	user.visible_message("<b>[user]</b> pulls \the [src] down to hang around their neck.", SPAN_NOTICE("You pull \the [src] down to hang around your neck."))

/obj/item/clothing/mask/proc/raise_message(mob/user)
	user.visible_message("<b>[user]</b> pulls \the [src] up to cover their face.", SPAN_NOTICE("You pull \the [src] up to cover your face."))

/obj/item/clothing/mask/attack_self(mob/user)
	if(adjustable)
		adjust_mask(user)

///////////////////////////////////////////////////////////////////////
//Shoes
/obj/item/clothing/shoes
	name = "shoes"
	desc = "Comfortable-looking shoes."
	species_sprite_adaption_type = WORN_SHOES
	gender = PLURAL //Carn: for grammarically correct text-parsing
	siemens_coefficient = 0.9
	body_parts_covered = FEET
	slot_flags = SLOT_FEET
	var/blood_overlay_type = "shoe"
	drop_sound = 'sound/items/drop/shoes.ogg'
	pickup_sound = 'sound/items/pickup/shoes.ogg'

	var/can_hold_knife
	var/footstep = 1
	var/obj/item/holding

	var/shoes_under_pants = 0

	permeability_coefficient = 0.50
	force = 0
	var/overshoes = 0
	species_restricted = list("exclude",BODYTYPE_UNATHI,BODYTYPE_TAJARA,BODYTYPE_VAURCA,BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM, BODYTYPE_TESLA_BODY)
	var/silent = 0
	var/last_trip = 0

	var/footstep_sound_override

/obj/item/clothing/shoes/proc/draw_knife()
	set name = "Draw Boot Knife"
	set desc = "Pull out your boot knife."
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return

	holding.forceMove(get_turf(usr))

	if(usr.put_in_hands(holding))
		usr.visible_message(SPAN_DANGER("\The [usr] pulls \a [holding] out of their boot!"))
		holding = null
		playsound(get_turf(src), 'sound/weapons/holster/unholster_knife.ogg', 25)
	else
		to_chat(usr, SPAN_WARNING("Your need an empty, unbroken hand to do that."))
		holding.forceMove(src)

	if(!holding)
		verbs -= /obj/item/clothing/shoes/proc/draw_knife

	update_icon()
	return


/obj/item/clothing/shoes/attackby(var/obj/item/I, var/mob/user)
	if(can_hold_knife && is_type_in_list(I, list(/obj/item/material/shard, /obj/item/material/kitchen/utensil, /obj/item/material/knife)))
		if(holding)
			to_chat(user, SPAN_WARNING("\The [src] is already holding \a [holding]."))
			return
		user.unEquip(I)
		I.forceMove(src)
		holding = I
		user.visible_message(SPAN_NOTICE("\The [user] shoves \the [I] into \the [src]."))
		playsound(get_turf(src), 'sound/weapons/holster/holster_knife.ogg', 25)
		verbs |= /obj/item/clothing/shoes/proc/draw_knife
		update_icon()
	else
		return ..()

/obj/item/clothing/shoes/verb/toggle_layer()
	set name = "Switch Shoe Layer"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return 0

	if(shoes_under_pants == -1)
		to_chat(usr, SPAN_NOTICE("[src] cannot be worn above your suit!"))
		return
	shoes_under_pants = !shoes_under_pants
	update_icon()
	update_clothing_icon()

/obj/item/clothing/shoes/update_icon()
	cut_overlays()
	if(holding)
		add_overlay(overlay_image(icon, "[initial(icon_state)]_knife", flags=RESET_COLOR))
	if(ismob(usr))
		var/mob/M = usr
		M.update_inv_shoes()
	return ..()

/obj/item/clothing/shoes/get_mob_overlay(mob/living/carbon/human/H, mob_icon, mob_state, slot)
	var/image/I = ..()
	if(blood_DNA && slot != slot_l_hand_str && slot != slot_r_hand_str)
		for(var/limb_tag in list(BP_L_FOOT, BP_R_FOOT))
			var/obj/item/organ/external/E = H.get_organ(limb_tag)
			if(E && !E.is_stump())
				var/image/bloodsies = image(H.species.blood_mask, "shoeblood_[E.limb_name]")
				bloodsies.color = blood_color
				bloodsies.appearance_flags = RESET_ALPHA
				I.add_overlay(bloodsies)
	return I

/obj/item/clothing/shoes/proc/handle_movement(var/turf/walking, var/running)
	return

/obj/item/clothing/shoes/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_shoes()

/obj/item/clothing/shoes/proc/trip_up(var/turf/walking, var/running)
	if(!running)
		if(footstep >= 2)
			footstep = 0
		else
			footstep++
	else
		if(prob(5))
			if(last_trip <= world.time - 20) //So you don't trip immediately after.
				last_trip = world.time
				if(ismob(loc))
					var/mob/M = loc
					M.Weaken(3)
					to_chat(M, SPAN_WARNING("You trip from running in \the [src]!"))
			return

/obj/item/clothing/shoes/clothing_class()
	return "shoes"

/obj/item/clothing/shoes/clean_blood()
	. = ..()
	track_footprint = 0

/obj/item/clothing/shoes/proc/do_special_footsteps(var/running)
	if(!footstep_sound_override)
		return FALSE
	if(ishuman(loc))
		var/mob/living/carbon/human/wearer = loc
		if(running)
			playsound(wearer, footstep_sound_override, 70, 1, required_asfx_toggles = ASFX_FOOTSTEPS)
		else
			footstep++
			if (footstep % 2)
				playsound(wearer, footstep_sound_override, 40, 1, required_asfx_toggles = ASFX_FOOTSTEPS)
	return TRUE
///////////////////////////////////////////////////////////////////////
//Suit
/obj/item/clothing/suit
	icon = 'icons/obj/clothing/suits.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/clothing/lefthand_suit.dmi',
		slot_r_hand_str = 'icons/mob/items/clothing/righthand_suit.dmi'
		)
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/suit.dmi'
	)
	name = "suit"
	species_sprite_adaption_type = WORN_SUIT
	var/fire_resist = T0C+100
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	allowed = list(/obj/item/tank/emergency_oxygen)
	armor = null
	slot_flags = SLOT_OCLOTHING
	var/blood_overlay_type = "suit"
	siemens_coefficient = 0.9
	w_class = ITEMSIZE_NORMAL
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)

	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_GENERIC, ACCESSORY_SLOT_CAPE, ACCESSORY_SLOT_UTILITY_MINOR)

/obj/item/clothing/suit/return_own_image()
	var/image/our_image
	if(contained_sprite)
		auto_adapt_species(src)
		var/state = "[UNDERSCORE_OR_NULL(src.icon_species_tag)][item_state][WORN_SUIT]"
		our_image = image(icon_override || icon, state)
	else if(icon_override)
		our_image = image(icon_override, icon_state)
	else if(item_icons && (slot_head_str in item_icons))
		our_image = image(item_icons[slot_head_str], icon_state)
	else
		our_image = image(INV_SUIT_DEF_ICON, icon_state)
	our_image.color = color
	return our_image

/obj/item/clothing/suit/get_mob_overlay(mob/living/carbon/human/H, mob_icon, mob_state, slot)
	var/image/I = ..()
	if(slot == slot_l_hand_str || slot == slot_r_hand_str)
		for(var/obj/item/clothing/accessory/A in accessories)
			A.accessory_mob_overlay.cut_overlays()
	else
		for(var/obj/item/clothing/accessory/A in accessories)
			var/image/accessory_image = A.get_accessory_mob_overlay(H)
			I.add_overlay(accessory_image)

	if(blood_DNA && slot != slot_l_hand_str && slot != slot_r_hand_str)
		var/image/bloodsies = image(icon = H.species.blood_mask, icon_state = "[blood_overlay_type]blood")
		bloodsies.color = blood_color
		I.add_overlay(bloodsies)
	return I

/obj/item/clothing/suit/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_suit()

/obj/item/clothing/suit/clothing_class()
	return "suit"

///////////////////////////////////////////////////////////////////////
//Under clothing
/obj/item/clothing/under
	icon = 'icons/obj/clothing/uniforms.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/clothing/lefthand_uniforms.dmi',
		slot_r_hand_str = 'icons/mob/items/clothing/righthand_uniforms.dmi'
		)
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/uniform.dmi'
	)
	name = "under"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	permeability_coefficient = 0.90
	slot_flags = SLOT_ICLOTHING
	armor = null
	w_class = ITEMSIZE_NORMAL
	equip_sound = 'sound/items/equip/jumpsuit.ogg'

	///SUIT_NO_SENSORS = No sensors, SUIT_HAS_SENSORS = Sensors, SUIT_LOCKED_SENSORS = Locked sensors
	var/has_sensor = SUIT_HAS_SENSORS

	///SUIT_SENSOR_OFF = Off, SUIT_SENSOR_BINARY = Report living/dead, SUIT_SENSOR_VITAL = Report detailed damages, SUIT_SENSOR_TRACKING = Report location
	var/sensor_mode = SUIT_SENSOR_OFF

	var/displays_id = 1

	///0 = unrolled, 1 = rolled, -1 = cannot be toggled
	var/rolled_down = -1

	///0 = unrolled, 1 = rolled, -1 = cannot be toggled
	var/rolled_sleeves = -1

	///If set, rolling up sleeves/rolling down will use this icon state instead of initial().
	var/initial_icon_override

	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_GOLEM, BODYTYPE_TESLA_BODY)

	///Convenience var for defining the icon state for the overlay used when the clothing is worn. Also used by rolling/unrolling.
	var/worn_state = null

	valid_accessory_slots = list(ACCESSORY_SLOT_UTILITY, ACCESSORY_SLOT_UTILITY_MINOR, ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_GENERIC, ACCESSORY_SLOT_CAPE)
	restricted_accessory_slots = list(ACCESSORY_SLOT_UTILITY)

/obj/item/clothing/under/attack_hand(var/mob/user)
	if(LAZYLEN(accessories))
		..()
	if ((ishuman(usr) || issmall(usr)) && src.loc == user)
		return
	..()

/obj/item/clothing/under/Initialize()
	. = ..()
	if(has_sensor)
		src.verbs += /obj/item/clothing/under/proc/toggle
	if(worn_state)
		LAZYINITLIST(item_state_slots)
		item_state_slots[slot_w_uniform_str] = worn_state
	else
		worn_state = icon_state

	//autodetect rollability. now working with contained sprites!
	var/icon/under_icon = INV_W_UNIFORM_DEF_ICON
	if(rolled_down < 0 || rolled_sleeves < 0)
		if(contained_sprite)
			under_icon = icon
		else if(icon_override)
			under_icon = icon_override
		else if(item_icons && item_icons[slot_w_uniform_str])
			under_icon = item_icons[slot_w_uniform_str]

	if(rolled_down < 0)
		if("[worn_state]_d[contained_sprite ? "_un" : "_s"]" in icon_states(under_icon))
			rolled_down = 0
			verbs += /obj/item/clothing/under/proc/rollsuit
	if(rolled_sleeves < 0)
		if("[worn_state]_r[contained_sprite ? "_un" : "_s"]" in icon_states(under_icon))
			rolled_sleeves = 0
			verbs += /obj/item/clothing/under/proc/rollsleeves

/obj/item/clothing/under/get_mob_overlay(mob/living/carbon/human/H, mob_icon, mob_state, slot)
	var/image/I = ..()
	if(slot == slot_l_hand_str | slot == slot_r_hand_str)
		for(var/obj/item/clothing/accessory/A in accessories)
			A.accessory_mob_overlay.cut_overlays()
	else
		for(var/obj/item/clothing/accessory/A in accessories)
			var/image/accessory_image = A.get_accessory_mob_overlay(H)
			I.add_overlay(accessory_image)

	if(blood_DNA && slot != slot_l_hand_str && slot != slot_r_hand_str)
		var/image/bloodsies = image(icon = H.species.blood_mask, icon_state = "uniformblood")
		bloodsies.color = blood_color
		I.add_overlay(bloodsies)
	return I

/obj/item/clothing/under/proc/update_rolldown_status()
	var/mob/living/carbon/human/H
	if(istype(src.loc, /mob/living/carbon/human))
		H = src.loc

	var/icon/under_icon
	if(contained_sprite)
		under_icon = icon
	else if(icon_override)
		under_icon = icon_override
	else if(H && sprite_sheets && sprite_sheets[H.species.get_bodytype()])
		under_icon = sprite_sheets[H.species.get_bodytype()]
	else if(item_icons && item_icons[slot_w_uniform_str])
		under_icon = item_icons[slot_w_uniform_str]
	else
		under_icon = INV_W_UNIFORM_DEF_ICON

	// The _s is because the icon update procs append it.
	if(("[worn_state]_d[contained_sprite ? "_un" : "_s"]") in icon_states(under_icon))
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
	if(contained_sprite)
		under_icon = icon
	else if(icon_override)
		under_icon = icon_override
	else if(H && sprite_sheets && sprite_sheets[H.species.get_bodytype(H)])
		under_icon = sprite_sheets[H.species.get_bodytype(H)]
	else if(item_icons && item_icons[slot_w_uniform_str])
		under_icon = item_icons[slot_w_uniform_str]
	else
		under_icon = INV_W_UNIFORM_DEF_ICON

	// The _s is because the icon update procs append it.
	if(("[worn_state]_r[contained_sprite ? "_un" : "_s"]") in icon_states(under_icon))
		if(rolled_sleeves != 1)
			rolled_sleeves = 0
	else
		rolled_sleeves = -1
	if(H) update_clothing_icon()

/obj/item/clothing/under/return_own_image()
	var/image/our_image
	if(contained_sprite)
		auto_adapt_species(src)
		var/state = "[UNDERSCORE_OR_NULL(src.icon_species_tag)][item_state][WORN_UNDER]"
		our_image = image(icon_override || icon, state)
	else if(icon_override)
		our_image = image(icon_override, icon_state)
	else if(item_icons && (slot_head_str in item_icons))
		our_image = image(item_icons[slot_head_str], icon_state)
	else
		our_image = image((icon ? icon : INV_W_UNIFORM_DEF_ICON), icon_state)
	our_image.color = color
	return our_image

/obj/item/clothing/under/update_clothing_icon()
	if(ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_w_uniform()
		playsound(M, /singleton/sound_category/rustle_sound, 15, 1, -5)

/obj/item/clothing/under/examine(mob/user, distance, is_adjacent)
	. = ..()
	if(has_sensor)
		switch(src.sensor_mode)
			if(SUIT_SENSOR_OFF)
				to_chat(user, "Its sensors appear to be disabled.")
			if(SUIT_SENSOR_BINARY)
				to_chat(user, "Its binary life sensors appear to be enabled.")
			if(SUIT_SENSOR_VITAL)
				to_chat(user, "Its vitals tracker appears to be enabled.")
			if(SUIT_SENSOR_TRACKING)
				to_chat(user, "Its vitals tracker and tracking beacon appear to be enabled.")

/obj/item/clothing/under/proc/set_sensors(mob/user as mob)
	var/mob/M = user
	if (isobserver(M) || user.incapacitated())
		return
	if(has_sensor >= SUIT_LOCKED_SENSORS)
		to_chat(user, "The controls are locked.")
		return 0
	if(has_sensor <= SUIT_NO_SENSORS)
		to_chat(user, "This suit does not have any sensors.")
		return 0

	var/switchMode = tgui_input_list(user, "Select a sensor mode.", "Suit Sensor Mode", SUIT_SENSOR_MODES)
	if(get_dist(user, src) > 1)
		to_chat(user, "You have moved too far away.")
		return
	sensor_mode = SUIT_SENSOR_MODES[switchMode]

	if (src.loc == user)
		switch(sensor_mode)
			if(SUIT_SENSOR_OFF)
				user.visible_message("[user] adjusts the tracking sensor on [get_pronoun("him")] [src.name].", "You disable your suit's remote sensing equipment.")
			if(SUIT_SENSOR_BINARY)
				user.visible_message("[user] adjusts the tracking sensor on [get_pronoun("him")] [src.name].", "Your suit will now report your pulse.")
			if(SUIT_SENSOR_VITAL)
				user.visible_message("[user] adjusts the tracking sensor on [get_pronoun("him")] [src.name].", "Your suit will now report your pulse and vital lifesigns.")
			if(SUIT_SENSOR_TRACKING)
				user.visible_message("[user] adjusts the tracking sensor on [get_pronoun("him")] [src.name].", "Your suit will now report your pulse, vital lifesigns, and your coordinate position.")
	else if (ismob(src.loc))
		if(sensor_mode == SUIT_SENSOR_OFF)
			user.visible_message(SPAN_WARNING("[user] disables [src.loc]'s remote sensing equipment."), "You disable [src.loc]'s remote sensing equipment.")
		else
			user.visible_message("[user] adjusts the tracking sensor on [src.loc]'s [src.name].", "You adjust [src.loc]'s sensors.")
	else
		user.visible_message("[user] adjusts the tracking sensor on [src]", "You adjust the sensor on [src].")

/obj/item/clothing/under/emp_act(severity)
	..()
	var/new_mode
	switch(severity)
		if (2)
			new_mode = pick(75;SUIT_SENSOR_OFF, 15;SUIT_SENSOR_BINARY, 10;SUIT_SENSOR_VITAL)
		if (1)
			new_mode = pick(50;SUIT_SENSOR_OFF, 25;SUIT_SENSOR_BINARY, 20;SUIT_SENSOR_VITAL, 5;SUIT_SENSOR_TRACKING)

	sensor_mode = new_mode

/obj/item/clothing/under/proc/toggle()
	set name = "Toggle Suit Sensors"
	set category = "Object"
	set src in usr
	set_sensors(usr)

/obj/item/clothing/under/proc/rollsuit()
	set name = "Roll Up/Down Jumpsuit"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	if(rolled_down == -1)
		to_chat(usr, SPAN_NOTICE("You cannot roll down \the [src]!"))
	if((rolled_sleeves == 1) && !(rolled_down))
		rolled_sleeves = 0
	update_rolldown_status()

	rolled_down = !rolled_down
	handle_rollsuit(usr)

/obj/item/clothing/under/proc/handle_rollsuit(mob/user)
	if(rolled_down)
		body_parts_covered &= LOWER_TORSO|LEGS|FEET
		if(contained_sprite || !LAZYLEN(item_state_slots))
			if(initial_icon_override)
				item_state = "[initial_icon_override]_d"
			else
				item_state = "[initial(item_state)]_d"
		else
			item_state_slots[slot_w_uniform_str] = "[worn_state]_d"
		if(user)
			to_chat(user, SPAN_NOTICE("You roll up \the [src]."))
	else
		body_parts_covered = initial(body_parts_covered)
		if(contained_sprite || !LAZYLEN(item_state_slots))
			if(initial_icon_override)
				item_state = initial_icon_override
			else
				item_state = initial(item_state)
		else
			item_state_slots[slot_w_uniform_str] = "[worn_state]"
		if(user)
			to_chat(user, SPAN_NOTICE("You roll down \the [src]."))
	update_clothing_icon()

/obj/item/clothing/under/proc/rollsleeves()
	set name = "Roll Up/Down Sleeves"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	if(rolled_sleeves == -1)
		to_chat(usr, SPAN_NOTICE("You cannot roll up \the [src]'s sleeves!"))
		return
	if(rolled_down == 1)
		to_chat(usr, SPAN_NOTICE("You must roll up \the [src] first!"))
		return
	update_rollsleeves_status()

	rolled_sleeves = !rolled_sleeves
	handle_rollsleeves(usr)

/obj/item/clothing/under/proc/handle_rollsleeves(mob/user)
	if(rolled_sleeves)
		body_parts_covered &= ~(ARMS|HANDS)
		if(contained_sprite || !LAZYLEN(item_state_slots))
			if(initial_icon_override)
				item_state = "[initial_icon_override]_r"
			else
				item_state = "[initial(item_state)]_r"
		else
			item_state_slots[slot_w_uniform_str] = "[worn_state]_r"
		if(user)
			to_chat(user, SPAN_NOTICE("You roll up \the [src]'s sleeves."))
	else
		body_parts_covered = initial(body_parts_covered)
		if(contained_sprite || !LAZYLEN(item_state_slots))
			if(initial_icon_override)
				item_state = initial_icon_override
			else
				item_state = initial(item_state)
		else
			item_state_slots[slot_w_uniform_str] = "[worn_state]"
		if(user)
			to_chat(user, SPAN_NOTICE("You roll down \the [src]'s sleeves."))
	update_clothing_icon()

/obj/item/clothing/under/clothing_class()
	return "uniform"

//Rings

/obj/item/clothing/ring
	name = "ring"
	w_class = ITEMSIZE_TINY
	icon = 'icons/obj/clothing/rings.dmi'
	species_sprite_adaption_type = WORN_GLOVES
	slot_flags = SLOT_GLOVES
	gender = NEUTER
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'
	var/undergloves = TRUE

/obj/item/clothing/proc/clothing_class()
	return "clothing"
