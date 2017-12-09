#define MATERIAL_ARMOR_COEFFICENT 0.05
/*
SEE code/modules/materials/materials.dm FOR DETAILS ON INHERITED DATUM.
This class of armor takes armor and appearance data from a material "datum".
They are also fragile based on material data and many can break/smash apart when hit.
Materials has a var called protectiveness which plays a major factor in how good it is for armor.
With the coefficent being 0.05, this is how strong different levels of protectiveness are (for melee)
For bullets and lasers, material hardness and reflectivity also play a major role, respectively.
Protectiveness | Armor %
			0  = 0%
			5  = 20%
			10 = 33%
			15 = 42%
			20 = 50%
			25 = 55%
			30 = 60%
			40 = 66%
			50 = 71%
			60 = 75%
			70 = 77%
			80 = 80%
*/


// Putting these at /clothing/ level saves a lot of code duplication in armor/helmets/gauntlets/etc
/obj/item/clothing
	var/material/material = null
	var/applies_material_color = TRUE
	var/unbreakable = FALSE
	var/default_material = null // Set this to something else if you want material attributes on init.
	var/material_armor_modifer = 1 // Adjust if you want seperate types of armor made from the same material to have different protectiveness (e.g. makeshift vs real armor)

/obj/item/clothing/Initialize(var/mapload, var/material_key)
	. = ..(mapload)
	if(!material_key)
		material_key = default_material
	if(material_key) // May still be null if a material was not specified as a default.
		set_material(material_key)

/obj/item/clothing/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/clothing/get_material()
	return material

/obj/item/clothing/proc/set_material(var/new_material)
	material = get_material_by_name(new_material)
	if(!material)
		qdel(src)
	else
		name = "[material.display_name] [initial(name)]"
		health = round(material.integrity/10)
		if(applies_material_color)
			color = material.icon_colour
		if(material.products_need_process())
			STOP_PROCESSING(SSprocessing, src)
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
		M.drop_from_inventory(src)
		if(material.shard_type == SHARD_SHARD) // Wearing glass armor is a bad idea.
			var/obj/item/weapon/material/shard/S = material.place_shard(T)
			M.embed(S)

	playsound(src, "shatter", 70, 1)
	qdel(src)

/obj/item/clothing/suit/armor/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(!material) // No point checking for reflection.
		return ..()

	if(material.reflectivity)
		if(istype(damage_source, /obj/item/projectile/energy) || istype(damage_source, /obj/item/projectile/beam))
			var/obj/item/projectile/P = damage_source

			var/reflectchance = 40 - round(damage/3)
			if(!(def_zone in list("chest", "groin")))
				reflectchance /= 2
			if(P.starting && prob(reflectchance))
				visible_message("<span class='danger'>\The [user]'s [src.name] reflects [attack_text]!</span>")

				// Find a turf near or on the original location to bounce to
				var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
				var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
				var/turf/curloc = get_turf(user)

				// redirect the projectile
				P.redirect(new_x, new_y, curloc, user)

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

/obj/item/clothing/suit/material
	name = "armor"
	default_material = DEFAULT_WALL_MATERIAL

/obj/item/clothing/suit/armor/makeshift
	name = "sheet armor"
	desc = "This appears to be two 'sheets' of a material held together by cable."
	icon = 'icons/obj/clothing/material_armor.dmi'
	icon_state = "material_armor"
	item_state = "material_armor"
	contained_sprite = 1
	armor = list(melee = 5, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/material/makeshift/plasteel
	default_material = "plasteel"

/obj/item/clothing/suit/armor/material/makeshift/glass
	default_material = "glass"

// Used to craft sheet armor, and possibly other things in the Future(tm).
/obj/item/weapon/material/armor_plating
	name = "armor plating"
	desc = "A sheet designed to protect something."
	icon = 'icons/obj/items.dmi'
	icon_state = "armor_plate"
	unbreakable = TRUE
	force_divisor = 0.05
	thrown_force_divisor = 0.2
	var/wired = FALSE

/obj/item/weapon/material/armor_plating/attackby(var/obj/O, mob/user)
	if(istype(O, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/S = O
		if(wired)
			to_chat(user, "<span class='warning'>This already has enough wires on it.</span>")
			return
		if(S.use(20))
			to_chat(user, "<span class='notice'>You attach several wires to \the [src]..</span>")
			wired = TRUE
			icon_state = "[initial(icon_state)]_wired"
			return
		else
			to_chat(user, "<span class='notice'>You need more wire for that.</span>")
			return
	if(istype(O, /obj/item/weapon/material/armor_plating))
		var/obj/item/weapon/material/armor_plating/second_plate = O
		if(!wired && !second_plate.wired)
			to_chat(user, "<span class='warning'>You need something to hold the two pieces of plating together.</span>")
			return
		if(second_plate.material != src.material)
			to_chat(user, "<span class='warning'>Both plates need to be the same type of material.</span>")
			return
		user.drop_from_inventory(src)
		user.drop_from_inventory(second_plate)
		var/obj/item/clothing/suit/armor/material/makeshift/new_armor = new(src.material.name)
		user.put_in_hands(new_armor)
		qdel(second_plate)
		qdel(src)
	else
		..()


// Used to craft the makeshift helmet
/obj/item/clothing/head/helmet/bucket
	name = "bucket"
	desc = "It's a bucket with a large hole cut into it.  You could wear it on your head."
	flags_inv = HIDEEARS|HIDEEYES|BLOCKHAIR
	icon = 'icons/obj/clothing/material_armor.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	armor = list(melee = 5, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	contained_sprite = 1

/obj/item/clothing/head/helmet/bucket/wood
	name = "wooden bucket"
	icon = 'icons/obj/clothing/material_armor.dmi'
	icon_state = "woodbucket"
	item_state = "woodbucket"
	contained_sprite = 1

/obj/item/clothing/head/helmet/bucket/attackby(var/obj/O, mob/user)
	if(istype(O, /obj/item/stack/material))
		var/obj/item/stack/material/S = O
		if(S.use(2))
			to_chat(user, "<span class='notice'>You apply some [S.material.use_name] to \the [src]. </span>")
			var/obj/item/clothing/head/helmet/material/makeshift/helmet = new(S.material.name)
			user.put_in_hands(helmet)
			user.drop_from_inventory(src)
			qdel(src)
			return
		else
			to_chat(user, "<span class='warning'>You don't have enough material to build a helmet!</span>")
	else
		..()

/obj/item/clothing/head/helmet/material
	name = "helmet"
	flags_inv = HIDEEARS|HIDEEYES|BLOCKHAIR
	default_material = DEFAULT_WALL_MATERIAL

/obj/item/clothing/head/helmet/material/makeshift
	name = "bucket"
	desc = "A bucket with plating applied to the outside."
	icon = 'icons/obj/clothing/material_armor.dmi'
	icon_state = "material_helmet"
	item_state = "material_helmet"
	contained_sprite = 1

/obj/item/clothing/head/helmet/material/makeshift/plasteel
	default_material = "plasteel"