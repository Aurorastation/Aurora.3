/*
	Armor
*/
/obj/item/clothing/suit/armor/riot/laser_tag
	name = "laser tag armor"
	desc = "A set of laser tag armor. Very swanky."
	desc_info = "You can alt-click this while holding or wearing it to set how many laser tag shots you want to be able to take before going down."
	icon = 'icons/obj/item/clothing/kit/laser_tag.dmi'
	icon_state = "vest"
	item_state = "vest"
	contained_sprite = TRUE
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO
	slowdown = 0
	armor = list( // still somewhat sturdy, but ultimately not very
		melee = ARMOR_MELEE_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR
	)
	siemens_coefficient = 1.0
	var/laser_tag_color = "red"

	var/set_health = 3
	var/current_health

/obj/item/clothing/suit/armor/riot/laser_tag/Initialize(mapload, material_key)
	. = ..()
	get_tag_color(laser_tag_color)
	current_health = set_health

/obj/item/clothing/suit/armor/riot/laser_tag/AltClick(mob/user)
	if(loc == user)
		set_health = input(user, "Set the amount of shots you want your armour to take.", "Laser Armor", 3) as null|anything in list(1, 2, 3, 4, 5)
		if(!set_health)
			return
		current_health = set_health
		var/user_name = "Unknown User"
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			var/obj/item/card/id/ID = H.GetIdCard()
			if(ID)
				user_name = ID.registered_name
		var/list/num_to_word = list("one", "two", "three", "four", "five")
		visible_message("<b>[capitalize_first_letters(name)]</b> says, \"[SPAN_NOTICE("[user_name] armor health set to [num_to_word[set_health]].")]\".")
		return
	return ..()

/obj/item/clothing/suit/armor/riot/laser_tag/attackby(obj/item/I, mob/user)
	if(I.ismultitool())
		var/chosen_color = input(user, "Which color do you wish your vest to be?", "Color Selection") as null|anything in list("blue", "red")
		if(!chosen_color)
			return
		laser_tag_color = chosen_color
		get_tag_color(chosen_color)
		to_chat(user, SPAN_NOTICE("\The [src] is now a [chosen_color] laser tag vest."))
		return
	return ..()

/obj/item/clothing/suit/armor/riot/laser_tag/proc/laser_hit()
	current_health--
	if(current_health <= 0 && ismob(loc))
		var/mob/M = loc
		M.Weaken(5)
		current_health = set_health

/obj/item/clothing/suit/armor/riot/laser_tag/blue
	laser_tag_color = "blue"

/obj/item/clothing/head/helmet/riot/laser_tag
	name = "laser tag helmet"
	desc = "A helmet in the form of a riot helm, made for high-impact laser tag gameplay."
	icon = 'icons/obj/item/clothing/kit/laser_tag.dmi'
	icon_state = "helmet"
	item_state = "helmet"
	contained_sprite = TRUE
	armor = list( // still somewhat sturdy, but ultimately not very
		melee = ARMOR_MELEE_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR
	)
	siemens_coefficient = 1.0
	var/laser_tag_color = "red"

/obj/item/clothing/head/helmet/riot/laser_tag/Initialize(mapload, material_key)
	. = ..()
	get_tag_color(laser_tag_color)

/obj/item/clothing/head/helmet/riot/laser_tag/attackby(obj/item/I, mob/user)
	if(I.ismultitool())
		var/chosen_color = input(user, "Which color do you wish your helmet to be?", "Color Selection") as null|anything in list("blue", "red")
		if(!chosen_color)
			return
		laser_tag_color = chosen_color
		get_tag_color(chosen_color)
		to_chat(user, SPAN_NOTICE("\The [src] is now a [chosen_color] laser tag helmet."))
		return
	return ..()

/obj/item/clothing/head/helmet/riot/laser_tag/do_flip(mob/user)
	if(item_state == initial(item_state))
		item_state = "[item_state]-up"
	else
		item_state = initial(item_state)
	..()

/obj/item/clothing/head/helmet/riot/laser_tag/blue
	laser_tag_color = "blue"

/*
	Helpers
*/
/obj/item/clothing/proc/get_tag_color(var/set_color)
	var/list/color_to_color = list("red" = COLOR_RED, "blue" = COLOR_BLUE)
	color = color_to_color[set_color]
	update_clothing_icon()


/*
	Closets
*/
/obj/structure/closet/lasertag
	name = "red laser tag equipment"
	desc = "It's a storage unit for laser tag equipment."
	icon_door = "red"
	var/helmet_path = /obj/item/clothing/head/helmet/riot/laser_tag
	var/armor_path = /obj/item/clothing/suit/armor/riot/laser_tag
	var/gun_path = /obj/item/gun/energy/lasertag/red

/obj/structure/closet/lasertag/fill()
	new /obj/item/device/multitool(src)
	for(var/i = 1 to 3)
		new helmet_path(src)
		new armor_path(src)
		new gun_path(src)
		new /obj/item/clothing/ears/earmuffs(src)

/obj/structure/closet/lasertag/blue
	name = "blue laser tag equipment"
	icon_door = "blue"
	helmet_path = /obj/item/clothing/head/helmet/riot/laser_tag/blue
	armor_path = /obj/item/clothing/suit/armor/riot/laser_tag/blue
	gun_path = /obj/item/gun/energy/lasertag/blue
