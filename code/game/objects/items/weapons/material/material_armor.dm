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

/obj/item/clothing/suit/armor/material
	name = "armor"
	default_material = DEFAULT_WALL_MATERIAL

/obj/item/clothing/suit/armor/material/makeshift
	name = "sheet armor"
	desc = "This appears to be two 'sheets' of a material held together by cable."
	icon = 'icons/obj/clothing/material_armor.dmi'
	icon_state = "material_armor"
	item_state = "material_armor"
	contained_sprite = 1
	armor = list(
		MELEE = ARMOR_MELEE_MINOR
	)
	pocket_slots = 1

/obj/item/clothing/suit/armor/material/makeshift/plasteel
	default_material = "plasteel"

/obj/item/clothing/suit/armor/material/makeshift/glass
	default_material = "glass"

/obj/item/material/armor_plating
	name = "armor plating"
	desc = "A sheet designed to protect something."
	icon = 'icons/obj/clothing/material_armor.dmi'
	icon_state = "armor_plate"
	unbreakable = TRUE
	force_divisor = 0.05
	thrown_force_divisor = 0.2
	var/wired = FALSE

/obj/item/material/armor_plating/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/S = attacking_item
		if(wired)
			to_chat(user, SPAN_WARNING("This already has enough wires on it."))
			return
		if(S.use(20))
			to_chat(user, SPAN_NOTICE("You attach several wires to \the [src].."))
			wired = TRUE
			icon_state = "[initial(icon_state)]_wired"
			return
		else
			to_chat(user, SPAN_NOTICE("You need more wire for that."))
			return
	if(istype(attacking_item, /obj/item/material/armor_plating))
		var/obj/item/material/armor_plating/second_plate = attacking_item
		if(!wired && !second_plate.wired)
			to_chat(user, SPAN_WARNING("You need something to hold the two pieces of plating together."))
			return
		if(second_plate.material != src.material)
			to_chat(user, SPAN_WARNING("Both plates need to be the same type of material."))
			return
		//TODO: Possible better animations
		var/obj/item/clothing/suit/armor/material/makeshift/new_armor = new(src.loc, src.material.name)
		user.drop_from_inventory(src,new_armor)
		user.drop_from_inventory(second_plate,new_armor)
		user.put_in_hands(new_armor)
		qdel(second_plate)
		qdel(src)
	else
		..()


// Used to craft the makeshift helmet
/obj/item/clothing/head/helmet/bucket
	name = "bucket helmet"
	desc = "It's a bucket with a large hole cut into it.  You could wear it on your head."
	flags_inv = HIDEEARS|HIDEEYES|BLOCKHAIR
	icon = 'icons/obj/clothing/material_armor.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_janitor.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_janitor.dmi',
		)
	icon_state = "bucket"
	item_state = "bucket"
	armor = list(
		MELEE = ARMOR_MELEE_MINOR
	)
	contained_sprite = 1

	has_storage = FALSE

/obj/item/clothing/head/helmet/bucket/wood
	name = "wooden bucket helmet"
	icon = 'icons/obj/clothing/material_armor.dmi'
	icon_state = "woodbucket"
	item_state = "woodbucket"
	contained_sprite = 1

/obj/item/clothing/head/helmet/bucket/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/stack/material))
		var/obj/item/stack/material/S = attacking_item
		if(S.use(2))
			to_chat(user, SPAN_NOTICE("You apply some [S.material.use_name] to \the [src]. "))
			var/obj/item/clothing/head/helmet/material/makeshift/helmet = new(null, S.material.name)
			user.put_in_hands(helmet)
			user.drop_from_inventory(src)
			qdel(src)
			return
		else
			to_chat(user, SPAN_WARNING("You don't have enough material to build a helmet!"))
	else
		..()

/obj/item/clothing/head/helmet/material
	name = "helmet"
	flags_inv = HIDEEARS|HIDEEYES|BLOCKHAIR
	default_material = DEFAULT_WALL_MATERIAL
	has_storage = FALSE

/obj/item/clothing/head/helmet/material/makeshift
	name = "bucket helmet"
	desc = "A bucket with plating applied to the outside."
	icon = 'icons/obj/clothing/material_armor.dmi'
	icon_state = "material_helmet"
	item_state = "material_helmet"
	contained_sprite = 1

/obj/item/clothing/head/helmet/material/makeshift/plasteel
	default_material = "plasteel"

/obj/item/clothing/suit/armor/material/makeshift/trenchcoat
	name = "armored trenchcoat"
	desc = "A trenchcoat that has had some armor plating hastily attached to it."
	applies_material_color = FALSE
	pocket_slots = 2
	icon_state = "material_kelly"
	item_state = "material_kelly"

/obj/item/clothing/suit/armor/material/makeshift/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/clothing/suit/storage/toggle/trench))
		var/obj/item/clothing/suit/storage/toggle/trench/kelly = attacking_item
		user.drop_from_inventory(src)
		user.drop_from_inventory(kelly)
		var/obj/item/clothing/suit/armor/material/makeshift/trenchcoat/new_armor = new(null, src.material.name)
		user.put_in_hands(new_armor)
		qdel(src)
		qdel(kelly)
	else
		..()
