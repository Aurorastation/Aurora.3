//Leg guards.
/obj/item/clothing/accessory/leg_guard
	name = "corporate leg guards"
	desc = "These will protect your legs."
	icon = 'icons/obj/item/clothing/suit/armor/modular_armor/modular_armor.dmi'
	icon_state = "legguards_sec"
	item_state = "legguards_sec"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_LEG_GUARDS
	accessory_layer = ACCESSORY_LAYER_LOWER
	w_class = WEIGHT_CLASS_NORMAL
	armor = list(
		MELEE = ARMOR_MELEE_KEVLAR,
		BULLET = ARMOR_BALLISTIC_MEDIUM,
		LASER = ARMOR_LASER_KEVLAR,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED
	)
	body_parts_covered = LEGS
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'

/obj/item/clothing/accessory/leg_guard/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "These must be attached to plate carriers for them to work."

/obj/item/clothing/accessory/leg_guard/before_attached(var/obj/item/clothing/clothing, var/mob/user)
	if(!clothing.valid_accessory_slots || !(slot in clothing.valid_accessory_slots))
		return
	var/obj/item/clothing/accessory/leg_guard/existing_guard = locate() in clothing.accessories
	if(!existing_guard)
		return
	clothing.remove_accessory(user, existing_guard)

/obj/item/clothing/accessory/leg_guard/generic
	name = "standard leg guards"
	icon_state = "legguards_generic"
	item_state = "legguards_generic"

/obj/item/clothing/accessory/leg_guard/scc
	name = "scc leg guards"
	icon_state = "legguards_scc"
	item_state = "legguards_scc"

/obj/item/clothing/accessory/leg_guard/ablative
	name = "ablative leg guards"
	desc = "These will protect your legs from energy weapons."
	icon_state = "legguards_ablative"
	item_state = "legguards_ablative"
	armor = list(
		MELEE = ARMOR_MELEE_MINOR,
		BULLET = ARMOR_BALLISTIC_MINOR,
		LASER = ARMOR_LASER_MAJOR,
		ENERGY = ARMOR_ENERGY_RESISTANT
	)
	slowdown = 0.3
	siemens_coefficient = 0

/obj/item/clothing/accessory/leg_guard/ballistic
	name = "ballistic leg guards"
	desc = "These will protect your legs from ballistic weapons."
	icon_state = "legguards_ballistic"
	item_state = "legguards_ballistic"
	armor = list(
		MELEE = ARMOR_MELEE_RESISTANT,
		BULLET = ARMOR_BALLISTIC_RIFLE,
		LASER = ARMOR_LASER_MINOR,
		ENERGY = ARMOR_ENERGY_MINOR,
		BOMB = ARMOR_BOMB_PADDED
	)
	slowdown = 0.3

/obj/item/clothing/accessory/leg_guard/riot
	name = "riot leg guards"
	desc = "These will protect your legs from close combat weapons."
	icon_state = "legguards_riot"
	item_state = "legguards_riot"
	armor = list(
		MELEE = ARMOR_MELEE_VERY_HIGH,
		BULLET = ARMOR_BALLISTIC_MINOR,
		LASER = ARMOR_LASER_MINOR,
		ENERGY = ARMOR_ENERGY_MINOR,
		BOMB = ARMOR_BOMB_PADDED
	)
	slowdown = 0.3

/obj/item/clothing/accessory/leg_guard/military
	name = "sol army leg guards"
	desc = "These will protect your legs from most things."
	icon_state = "legguards_military"
	item_state = "legguards_military"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
	)
	slowdown = 0.3

/obj/item/clothing/accessory/leg_guard/heavy
	name = "heavy leg guards"
	desc = "These leg guards will protect your legs from most things."
	icon_state = "legguards_heavy"
	item_state = "legguards_heavy"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
	)
	slowdown = 0.3

/obj/item/clothing/accessory/leg_guard/heavy/scc
	name = "heavy SCC leg guards"
	icon_state = "legguards_blue"
	item_state = "legguards_blue"
	slowdown = 0.3

/obj/item/clothing/accessory/leg_guard/heavy/sec
	name = "heavy corporate leg guards"
	icon_state = "legguards_sec_heavy"
	item_state = "legguards_sec_heavy"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
	)
	slowdown = 0.3

/obj/item/clothing/accessory/leg_guard/tcaf
	name = "\improper TCAF legionnaire leg carapace"
	desc = "Try to sweep the leg against someone wearing these."
	icon = 'icons/obj/item/clothing/suit/armor/modular_armor/modular_armor.dmi'
	icon_state = "tcaf_boot_armor"
	item_state = "tcaf_boot_armor"
	contained_sprite = TRUE
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
	)
	slowdown = 0.3

/obj/item/clothing/accessory/leg_guard/konyang_navy
	name = "\improper Konyang navy leg guards"
	icon_state = "legguards_navy"
	item_state = "legguards_navy"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
	)
	slowdown = 0.3

/obj/item/clothing/accessory/leg_guard/hoplan
	name = "hoplan thigh protector"
	desc = "Ablative plating fashioned to sit around the thigh from the hips, \
	made to link together with an adjoining breastplate. This ancient style is reinvigorated with ablative metals and ballistic padding."
	icon = 'icons/obj/item/clothing/suit/armor/modular_armor/modular_armor.dmi'
	icon_state = "hoplan_thigh_protector"
	item_state = "hoplan_thigh_protector"
	contained_sprite = TRUE
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
	)
	slowdown = 0.3

/obj/item/clothing/accessory/leg_guard/hoplan/skirt
	name = "hoplan ballistic skirt"
	desc = "A long skirt that falls down to one's ankles with an outer layer of ballistic padding, and woven in pouches featuring ablative plates."
	icon = 'icons/obj/item/clothing/suit/armor/modular_armor/modular_armor.dmi'
	icon_state = "hoplan_ballistic_skirt"
	item_state = "hoplan_ballistic_skirt"
	contained_sprite = TRUE
	slowdown = 0.3

//Arm guards.
/obj/item/clothing/accessory/arm_guard
	name = "corporate arm guards"
	desc = "A pair of arm pads reinforced with armor plating. Attaches to a plate carrier."
	icon = 'icons/obj/item/clothing/suit/armor/modular_armor/modular_armor.dmi'
	icon_state = "armguards_sec"
	item_state = "armguards_sec"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_ARM_GUARDS
	accessory_layer = ACCESSORY_LAYER_LOWER
	body_parts_covered = ARMS
	armor = list(
		MELEE = ARMOR_MELEE_KEVLAR,
		BULLET = ARMOR_BALLISTIC_MEDIUM,
		LASER = ARMOR_LASER_KEVLAR,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED
	)
	w_class = WEIGHT_CLASS_NORMAL
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'

/obj/item/clothing/accessory/arm_guard/before_attached(var/obj/item/clothing/clothing, var/mob/user)
	if(!clothing.valid_accessory_slots || !(slot in clothing.valid_accessory_slots))
		return
	var/obj/item/clothing/accessory/arm_guard/existing_guard = locate() in clothing.accessories
	if(!existing_guard)
		return
	clothing.remove_accessory(user, existing_guard)

/obj/item/clothing/accessory/arm_guard/generic
	name = "standard arm guards"
	icon_state = "armguards_generic"
	item_state = "armguards_generic"

/obj/item/clothing/accessory/arm_guard/scc
	name = "scc arm guards"
	icon_state = "armguards_scc"
	item_state = "armguards_scc"

/obj/item/clothing/accessory/arm_guard/ablative
	name = "ablative arm guards"
	desc = "A pair of armored arm pads with advanced shielding to protect against energy weapons. Attaches to a plate carrier."
	icon_state = "armguards_ablative"
	item_state = "armguards_ablative"
	armor = list(
		MELEE = ARMOR_MELEE_MINOR,
		BULLET = ARMOR_BALLISTIC_MINOR,
		LASER = ARMOR_LASER_MAJOR,
		ENERGY = ARMOR_ENERGY_RESISTANT
	)
	slowdown = 0.3
	siemens_coefficient = 0

/obj/item/clothing/accessory/arm_guard/ballistic
	name = "ballistic arm guards"
	desc = "A pair of armored arm pads with heavy plates to protect against ballistic projectiles. Attaches to a plate carrier."
	icon_state = "armguards_ballistic"
	item_state = "armguards_ballistic"
	armor = list(
		MELEE = ARMOR_MELEE_RESISTANT,
		BULLET = ARMOR_BALLISTIC_RIFLE,
		LASER = ARMOR_LASER_MINOR,
		ENERGY = ARMOR_ENERGY_MINOR,
		BOMB = ARMOR_BOMB_PADDED
	)
	slowdown = 0.3

/obj/item/clothing/accessory/arm_guard/riot
	name = "riot arm guards"
	desc = "A pair of armored arm and hand pads with heavy padding to protect against melee attacks."
	icon_state = "armguards_riot"
	item_state = "armguards_riot"
	armor = list(
		MELEE = ARMOR_MELEE_VERY_HIGH,
		BULLET = ARMOR_BALLISTIC_MINOR,
		LASER = ARMOR_LASER_MINOR,
		ENERGY = ARMOR_ENERGY_MINOR,
		BOMB = ARMOR_BOMB_PADDED
	)
	slowdown = 0.3
	body_parts_covered = ARMS|HANDS

/obj/item/clothing/accessory/arm_guard/military
	name = "sol army arm guards"
	desc = "A pair of green arm and hands pads reinforced with armor plating. Attaches to a plate carrier."
	icon_state = "armguards_military"
	item_state = "armguards_military"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
	)
	slowdown = 0.3
	body_parts_covered = ARMS|HANDS

/obj/item/clothing/accessory/arm_guard/heavy
	name = "heavy arm guards"
	desc = "A pair of armored arm pads reinforced with heavy armor plating. Attaches to a plate carrier."
	icon_state = "armguards_heavy"
	item_state = "armguards_heavy"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
	)
	slowdown = 0.3

/obj/item/clothing/accessory/arm_guard/heavy/scc
	name = "heavy SCC arm guards"
	desc = "A pair of armored arm and hand pads reinforced with heavy armor plating. Attaches to a plate carrier."
	icon_state = "armguards_blue"
	item_state = "armguards_blue"
	slowdown = 0.3
	body_parts_covered = ARMS|HANDS

/obj/item/clothing/accessory/arm_guard/heavy/sec
	name = "heavy corporate arm guards"
	icon_state = "armguards_sec_heavy"
	item_state = "armguards_sec_heavy"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
	)
	slowdown = 0.3

/obj/item/clothing/accessory/arm_guard/kala
	name = "kala arm guards"
	desc = "These arm guards are made out of an advanced lightweight alloy. Attaches to a plate carrier."
	icon_state = "armguards_sec_heavy"
	item_state = "armguards_sec_heavy"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
	)

/obj/item/clothing/accessory/arm_guard/tcaf
	name = "\improper TCAF carapace arm guards"
	desc = "Blue carapace armguards to protect you in the modern battlefield of 2465. Attaches to a plate carrier."
	icon = 'icons/obj/item/clothing/suit/armor/modular_armor/modular_armor.dmi'
	icon_state = "tcaf_armguards"
	item_state = "tcaf_armguards"
	contained_sprite = TRUE
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
	)
	slowdown = 0.3
	body_parts_covered = ARMS|HANDS

/obj/item/clothing/accessory/arm_guard/tcaf/tcaf_stripe
	name = "striped TCAF carapace arm guards"
	icon_state = "tcaf_armguards_stripe"
	item_state = "tcaf_armguards_stripe"

/obj/item/clothing/accessory/arm_guard/hoplan
	name = "hoplan sleeves"
	desc = "Big and poofy and reminiscent of an era more enlightened. \
	These are lined with special fabric woven in the laboratories of Pactolus to provide armor to an otherwise gaudy fashion piece."
	icon = 'icons/obj/item/clothing/suit/armor/modular_armor/modular_armor.dmi'
	icon_state = "hoplan_sleeves"
	item_state = "hoplan_sleeves"
	contained_sprite = TRUE
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
	)
	slowdown = 0.3
