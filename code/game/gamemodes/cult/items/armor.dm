/obj/item/clothing/head/culthood/magus
	name = "magus helm"
	icon_state = "magus"
	desc = "A helm worn by the followers of Nar-Sie."
	flags_inv = HIDEFACE | BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/suit/cultrobes/magusred
	name = "magus robes"
	desc = "A set of armored robes worn by the followers of Nar-Sie."
	icon_state = "magusred"
	item_state = "magusred"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEWRISTS|HIDEGLOVES|HIDEJUMPSUIT

/obj/item/clothing/head/helmet/space/cult
	name = "eldritch voidsuit helmet"
	desc = "A bulky armored voidsuit helmet, bristling with menacing spikes. It looks space proof."
	icon_state = "cult_helmet"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_CARBINE,
		laser = ARMOR_LASER_RIFLE,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)
	siemens_coefficient = 0
	light_overlay = "helmet_light_dual_red"
	light_color = COLOR_RED_LIGHT
	contained_sprite = FALSE
	icon = 'icons/obj/clothing/hats.dmi'

/obj/item/clothing/head/helmet/space/cult/cultify()
	return

/obj/item/clothing/suit/space/cult
	name = "eldritch voidsuit"
	icon_state = "cult_armor"
	item_state = "cult_armor"
	desc = "A bulky armored voidsuit, bristling with menacing spikes. It looks space proof."
	w_class = ITEMSIZE_NORMAL
	allowed = list(/obj/item/book/tome, /obj/item/melee/cultblade, /obj/item/gun/energy/rifle/cult, /obj/item/tank, /obj/item/device/suit_cooling_unit)
	slowdown = 1
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_CARBINE,
		laser = ARMOR_LASER_RIFLE,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)
	siemens_coefficient = 0
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS
	flags_inv = HIDEWRISTS|HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL|HIDESHOES
	contained_sprite = FALSE
	icon = 'icons/obj/clothing/suits.dmi'

/obj/item/clothing/suit/space/cult/cultify()
	return
