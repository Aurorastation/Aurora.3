/obj/item/material/harpoon
	name = "harpoon"
	sharp = 1
	edge = TRUE
	desc = "Tharr she blows!"
	icon_state = "harpoon"
	item_state = "harpoon"
	force_divisor = 0.3 // 18 with hardness 60 (steel)
	thrown_force_divisor = 0.85
	attack_verb = list("jabbed","stabbed","ripped")

/obj/item/material/harpoon/proc/prime()
	return

/obj/item/material/harpoon/explosive
	name = "explosive harpoon"

/obj/item/material/harpoon/explosive/prime()
	playsound(get_turf(src), 'sound/items/countdown.ogg', 125, 1)
	addtimer(CALLBACK(src, .proc/detonate), 3 SECONDS)
	return

/obj/item/material/harpoon/explosive/proc/detonate()
	explosion(get_turf(src), -1, -1, 2)
	qdel(src)

/obj/item/material/hatchet
	name = "hatchet"
	desc = "A very sharp axe blade upon a short fibremetal handle. It has a long history of chopping things, but now it is used for chopping wood."
	icon = 'icons/obj/weapons.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_hydro.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_hydro.dmi',
		)
	icon_state = "hatchet"
	item_state = "hatchet"
	force_divisor = 0.2 // 12 with hardness 60 (steel)
	thrown_force_divisor = 0.75 // 15 with weight 20 (steel)
	w_class = ITEMSIZE_SMALL
	sharp = 1
	edge = TRUE
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 1)
	attack_verb = list("chopped", "torn", "cut")
	applies_material_colour = 0
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'

/obj/item/material/hatchet/butch
	name = "butcher's cleaver"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "butch"
	item_state = "butch"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_kitchen.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_kitchen.dmi',
		)
	desc = "A huge thing used for chopping and chopping up meat."
	force_divisor = 0.25 // 15 when wielded with hardness 60 (steel)
	slot_flags = SLOT_BELT
	attack_verb = list("cleaved", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/material/hatchet/unathiknife
	name = "duelling knife"
	desc = "A length of leather-bound wood studded with razor-sharp teeth. How crude."
	icon = 'icons/obj/weapons.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/weapons/lefthand_knives.dmi',
		slot_r_hand_str = 'icons/mob/items/weapons/righthand_knives.dmi',
		)
	icon_state = "unathiknife"
	attack_verb = list("ripped", "torn", "cut")

/obj/item/material/hook
	name = "meat hook"
	desc = "A sharp, metal hook that sticks into things."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "hook_knife"
	item_state = "hook_knife"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_kitchen.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_kitchen.dmi',
		)
	sharp = 1
	edge = TRUE
	force_divisor = 0.25

/obj/item/material/minihoe // -- Numbers
	name = "mini hoe"
	desc = "It's used for removing weeds or scratching your back."
	icon = 'icons/obj/weapons.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_hydro.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_hydro.dmi',
		)
	icon_state = "hoe"
	item_state = "hoe"
	force_divisor = 0.25 // 5 with weight 20 (steel)
	thrown_force_divisor = 0.25 // as above
	w_class = ITEMSIZE_SMALL
	attack_verb = list("slashed", "sliced", "cut", "clawed")

/obj/item/material/scythe
	name = "scythe"
	desc = "A sharp and curved blade on a long fibremetal handle, this tool makes it easy to reap what you sow."
	icon_state = "scythe"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_hydro.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_hydro.dmi',
		)
	force_divisor = 0.275 // 16 with hardness 60 (steel)
	thrown_force_divisor = 0.25 // 5 with weight 20 (steel)
	sharp = 1
	edge = TRUE
	throw_speed = 1
	throw_range = 3
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 2)
	attack_verb = list("chopped", "sliced", "cut", "reaped")

/obj/item/material/scythe/sickle
	name = "sickle"
	desc = "A short sharp and curved blade on a handle, this tool makes it easy to cut grass."
	icon_state = "sickle"
	force_divisor = 0.175 // 16 with hardness 60 (steel)
	thrown_force_divisor = 0.04 // 5 with weight 20 (steel)
	throw_speed = 2
	throw_range = 3
	w_class = ITEMSIZE_SMALL
