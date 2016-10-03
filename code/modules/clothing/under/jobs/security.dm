/*
 * Contains:
 *		Security
 *		Detective
 *		Head of Security
 */

/*
 * Security
 */
/obj/item/clothing/under/rank/warden
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for more robust protection. It has the word \"Warden\" written on the shoulders."
	name = "warden's jumpsuit"
	icon_state = "warden"
//	item_state = "r_suit"
	worn_state = "warden"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/under/rank/security
	name = "security officer's jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon_state = "security"
//	item_state = "r_suit"
	worn_state = "secred"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/under/rank/dispatch
	name = "dispatcher's uniform"
	desc = "A dress shirt and khakis with a security patch sewn on."
	icon_state = "dispatch"
	//item_state = "dispatch"
	worn_state = "dispatch"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
	siemens_coefficient = 0.7

/obj/item/clothing/under/rank/security2
	name = "security officer's uniform"
	desc = "It's made of a slightly sturdier material, to allow for robust protection."
	icon_state = "redshirt2"
	item_state = "r_suit"
	worn_state = "redshirt2"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/under/rank/security/corp
	icon_state = "sec_corporate"
	//item_state = "sec_corporate"
	worn_state = "sec_corporate"

/obj/item/clothing/under/rank/warden/corp
	icon_state = "warden_corporate"
	//item_state = "warden_corporate"
	worn_state = "warden_corporate"

/obj/item/clothing/under/tactical
	name = "tactical jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon_state = "swatunder"
	//item_state = "swatunder"
	worn_state = "swatunder"
	armor = list(melee = 10, bullet = 5, laser = 5,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/*
 * Detective
 */
/obj/item/clothing/under/det
	name = "hard-worn suit"
	desc = "Someone who wears this means business."
	icon_state = "detective"
	item_state = "det"
	worn_state = "detective"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/under/det/black
	icon_state = "detective2"
	worn_state = "detective2"
	item_state = "sl_suit"

/obj/item/clothing/under/det/slob
	icon_state = "polsuit"
	worn_state = "polsuit"

/obj/item/clothing/under/det/slob/verb/rollup()
	set name = "Roll suit sleeves"
	set category = "Object"
	set src in usr
	worn_state = worn_state == "polsuit" ? "polsuit_rolled" : "polsuit"
	if (ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.update_inv_w_uniform(1)

/obj/item/clothing/head/det_hat
	name = "hat"
	desc = "Someone who wears this will look very smart."
	icon_state = "detective"
	allowed = list(/obj/item/weapon/reagent_containers/food/snacks/candy_corn, /obj/item/weapon/pen)
	armor = list(melee = 50, bullet = 5, laser = 25,energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7
	body_parts_covered = 0

/obj/item/clothing/head/det_hat/black
	icon_state = "detective2"

/obj/item/clothing/head/det_hat/technicolor
	desc = "A 23rd-century fedora. It's fibres are hyper-absorbent."
	icon = 'icons/obj/clothing/coloured_detective_coats.dmi'
	icon_state = "hat_detective_black"
	item_state = "hat_detective_black"
	var/hat_color
	contained_sprite = 1

/obj/item/clothing/head/det_hat/technicolor/New()
	if(prob(5))
		var/probably = rand(1, 8)
		switch(probably)
			if(1 to 2)
				icon_state = "hat_detective_yellow"
				item_state = "hat_detective_yellow"
			if(3)
				icon_state = "hat_detective_red"
				item_state = "hat_detective_red"
			if(4)
				icon_state = "hat_detective_purple"
				item_state = "hat_detective_purple"
			if(5)
				icon_state = "hat_detective_green"
				item_state = "hat_detective_green"
			if(6)
				icon_state = "hat_detective_blue"
				item_state = "hat_detective_blue"
			if(7)
				icon_state = "hat_detective_white"
				item_state = "hat_detective_white"
			if(8)
				icon_state = "hat_detective_orange"
				item_state = "hat_detective_orange"
	..()

obj/item/clothing/head/det_hat/technicolor/attackby(obj/item/weapon/O as obj, mob/user as mob)
	if(istype(O, /obj/item/weapon/reagent_containers/glass/paint))
		var/obj/item/weapon/reagent_containers/glass/paint/P = O
		hat_color = P.paint_type
		user.visible_message("<span class='warning'>[user] soaks \the [src] into [P]!</span>")
		icon_state = "hat_detective_[hat_color]"
		item_state = "hat_detective_[hat_color]"
	..()


/*
 * Head of Security
 */
/obj/item/clothing/under/rank/head_of_security
	desc = "It's a jumpsuit worn by those few with the dedication to achieve the position of \"Head of Security\". It has additional armor to protect the wearer."
	name = "head of security's jumpsuit"
	icon_state = "hos"
//	item_state = "r_suit"
	worn_state = "hosred"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/under/rank/head_of_security/corp
	icon_state = "hos_corporate"
	//item_state = "hos_corporate"
	worn_state = "hos_corporate"

/obj/item/clothing/head/helmet/HoS
	name = "head of security hat"
	desc = "The hat of the Head of Security. For showing the officers who's in charge."
	icon_state = "hoscap"
	flags = HEADCOVERSEYES
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 10, bomb = 25, bio = 10, rad = 0)
	flags_inv = HIDEEARS
	body_parts_covered = 0
	siemens_coefficient = 0.5

/obj/item/clothing/suit/armor/hos
	name = "head of security's jacket"
	desc = "An armoured jacket with golden rank pips and livery."
	icon_state = "hos"
	item_state = "hos"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	armor = list(melee = 65, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEJUMPSUIT
	siemens_coefficient = 0.5
	pocket_slots = 4//More slots because coat


/obj/item/clothing/head/helmet/HoS/dermal
	name = "dermal armour patch"
	desc = "You're not quite sure how you manage to take it on and off, but it implants nicely in your head."
	icon_state = "dermal"
	item_state = "dermal"
	siemens_coefficient = 0.5

//Jensen cosplay gear
/obj/item/clothing/under/rank/head_of_security/jensen
	desc = "You never asked for anything that stylish."
	name = "head of security's jumpsuit"
	icon_state = "jensen"
	item_state = "jensen"
	worn_state = "jensen"
	siemens_coefficient = 0.7

/obj/item/clothing/suit/armor/hos/jensen
	name = "armored trenchcoat"
	desc = "A trenchcoat augmented with a special alloy for some protection and style."
	icon_state = "jensencoat"
	item_state = "jensencoat"
	flags_inv = 0
	siemens_coefficient = 0.5
	body_parts_covered = UPPER_TORSO|ARMS
	pocket_slots = 4//More slots because coat

/*
 * Navy uniforms
 */

/obj/item/clothing/under/rank/security/navyblue
	name = "security officer's uniform"
	desc = "The latest in fashionable security outfits."
	icon_state = "officerblueclothes"
	item_state = "ba_suit"
	worn_state = "officerblueclothes"

/obj/item/clothing/under/rank/head_of_security/navyblue
	desc = "The insignia on this uniform tells you that this uniform belongs to the Head of Security."
	name = "head of security's uniform"
	icon_state = "hosblueclothes"
	item_state = "ba_suit"
	worn_state = "hosblueclothes"

/obj/item/clothing/under/rank/warden/navyblue
	desc = "The insignia on this uniform tells you that this uniform belongs to the Warden."
	name = "warden's uniform"
	icon_state = "wardenblueclothes"
	item_state = "ba_suit"
	worn_state = "wardenblueclothes"
