/*
 * Contains:
 *		Fire protection
 *		Bomb protection
 *		Radiation protection
 */

/*
 * Fire protection
 */

/obj/item/clothing/suit/fire
	name = "firesuit"
	desc = "A suit that protects against fire and heat."
	icon = 'icons/clothing/kit/firefighter.dmi'
	icon_state = "firesuit"
	item_state = "firesuit"
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/fire.dmi'
	)
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("ada", "gol")
	contained_sprite = TRUE
	w_class = ITEMSIZE_LARGE//bulky item
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	siemens_coefficient = 0.5
	allowed = list(/obj/item/device/flashlight,/obj/item/tank/emergency_oxygen,/obj/item/extinguisher)
	slowdown = 0.8 // slightly better than voidsuits
	flags_inv = HIDEWRISTS|HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = FIRESUIT_MIN_PRESSURE
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS

/obj/item/clothing/suit/fire/atmos
	name = "atmospheric technician firesuit"
	desc = "A suit that protects against fire and heat, this one is designed for atmospheric technicians."
	siemens_coefficient = 0.35
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE + 15000
	icon_state = "atmos_firesuit"
	item_state = "atmos_firesuit"
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/fire.dmi'
	)

/*
 * Bomb protection
 */
/obj/item/clothing/head/bomb_hood
	name = "bomb hood"
	desc = "Use in case of bomb."
	icon_state = "bombsuit"
	w_class = ITEMSIZE_HUGE//Too large to fit in a backpack
	item_flags = THICKMATERIAL|BLOCK_GAS_SMOKE_EFFECT
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH, 
		bullet = ARMOR_BALLISTIC_MINOR, 
		laser = ARMOR_LASER_SMALL, 
		energy = ARMOR_ENERGY_RESISTANT, 
		bomb = ARMOR_BOMB_SHIELDED
	)
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	siemens_coefficient = 0.1
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES
	body_parts_covered = HEAD|FACE|EYES
	siemens_coefficient = 0
	tint = TINT_HEAVY


//Changes by Nanako
//Bomb suits should huge and robust. They used to have 100 bomb protection and nothing in other categories
//Bomb suits now have decent resistance in all categories, but with two major ergonomic drawbacks:
//1. Heavy. really heavy, massive slowdown on movement
//2. Bomb suit materials don't allow permeability of body heat, thus the wearer tends to overheat and can't wear them for long
/obj/item/clothing/suit/bomb_suit
	name = "bomb suit"
	desc = "A suit designed for safety when handling explosives. It looks heavy and uncomfortable to wear for even a short time."
	icon_state = "bombsuit"
	item_state = "bombsuit"
	w_class = ITEMSIZE_HUGE //bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	slowdown = 8
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH, 
		bullet = ARMOR_BALLISTIC_MINOR, 
		laser = ARMOR_LASER_SMALL, 
		energy = ARMOR_ENERGY_RESISTANT, 
		bomb = ARMOR_BOMB_SHIELDED
	)
	siemens_coefficient = 0.1
	item_flags = THICKMATERIAL
	flags_inv = HIDEJUMPSUIT|HIDETAIL
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	siemens_coefficient = 0
	var/mob/living/carbon/human/wearer = null
	var/suit_temp = T20C

/obj/item/clothing/suit/bomb_suit/equipped(var/mob/user, var/slot)
	if (slot == slot_wear_suit)
		var/mob/living/carbon/human/H = user
		H.visible_message("<span class='notice'>[H] starts putting on \the [src]...</span>", "<span class='notice'>You start putting on \the [src]...</span>")
		if(!do_after(H,50))
			if(H && H.wear_suit == src)
				H.wear_suit = null
				H.drop_from_inventory(src,get_turf(H))
			else
				src.forceMove(get_turf(H))
			return

		wearer = user
		to_chat(wearer, "<span class='Notice'>You struggle into the [src]. It feels hot, heavy and uncomfortable</span>")
		START_PROCESSING(SSprocessing, src)
	else
		wearer = null

	..(user, slot)

#define 	BOMBSUIT_THERMAL	0.27
#define		BOMBHOOD_THERMAL	0.12
#define		BOMBSUIT_MAX_TEMPERATURE	420	//heat 2 for humans, heat 1 for unathi
/obj/item/clothing/suit/bomb_suit/process()
	if (!checkworn())//If nobody's wearing the suit, then it cools down
		suit_temp -= 0.5
		if (suit_temp < T20C)
			suit_temp = T20C
			STOP_PROCESSING(SSprocessing, src)
		return
	else
		var/amount = BOMBSUIT_THERMAL
		if (istype(wearer.head, /obj/item/clothing/head/bomb_hood))//wearing both parts heats up faster
			amount += BOMBHOOD_THERMAL

		suit_temp = min(suit_temp+amount, BOMBSUIT_MAX_TEMPERATURE)

		if (wearer.bodytemperature < suit_temp)
			wearer.bodytemperature += (suit_temp - wearer.bodytemperature)*0.5//Bodytemperature damps towards the suit temp
			if (wearer.bodytemperature >= wearer.species.heat_discomfort_level)
				wearer.species.get_environment_discomfort(wearer,"heat")
				//This is added here because normal discomfort messages proc off of breath rather than bodytemperature.
				//Since the surrounding environment isnt heated, they don't happen without it being specifically called here

/obj/item/clothing/suit/bomb_suit/proc/checkworn()
	if (wearer)
		if (wearer.wear_suit == src)
			return 1

	if (istype(loc, /mob/living/carbon/human))
		wearer = loc
		if (wearer.wear_suit == src)
			return 1
		else
			return 0

	else
		wearer = null
		return 0


/obj/item/clothing/suit/bomb_suit/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()


/obj/item/clothing/head/bomb_hood/security
	icon_state = "bombsuitsec"
	body_parts_covered = HEAD

/obj/item/clothing/suit/bomb_suit/security
	icon_state = "bombsuitsec"
	allowed = list(/obj/item/gun/energy, /obj/item/melee/baton, /obj/item/handcuffs, /obj/item/wirecutters/bomb)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

/*
 * Radiation protection
 */
/obj/item/clothing/head/radiation
	name = "radiation hood"
	desc = "A hood with radiation protective properties. Label: Made with lead, do not eat insulation."
	icon = 'icons/clothing/kit/radsuit.dmi'
	item_icons = null
	icon_state = "radhood"
	item_state = "radhood"
	contained_sprite = TRUE
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("skr", "una", "taj")
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	armor = list(
		bio = ARMOR_BIO_RESISTANT,
		rad = ARMOR_RAD_SHIELDED
	)
	siemens_coefficient = 0.35


/obj/item/clothing/suit/radiation
	name = "radiation suit"
	desc = "A suit that protects against radiation. Label: Made with lead, do not eat insulation."
	icon = 'icons/clothing/kit/radsuit.dmi'
	item_icons = null
	icon_state = "radsuit"
	item_state = "radsuit"
	contained_sprite = TRUE
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("una")
	w_class = ITEMSIZE_LARGE//bulky item
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/bag/inflatable,/obj/item/device/t_scanner,/obj/item/rfd/construction,/obj/item/material/twohanded/fireaxe,/obj/item/storage/backpack/cell,/obj/item/clothing/head/radiation,/obj/item/clothing/mask/gas,/obj/item/reagent_containers/hypospray/autoinjector)
	slowdown = 1.5
	armor = list(
		bio = ARMOR_BIO_RESISTANT, 
		rad = ARMOR_RAD_SHIELDED
	)
	siemens_coefficient = 0.35
	flags_inv = HIDEJUMPSUIT|HIDETAIL


#undef	 	BOMBSUIT_THERMAL
#undef		BOMBHOOD_THERMAL
#undef		BOMBSUIT_MAX_TEMPERATURE
