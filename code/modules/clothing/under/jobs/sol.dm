
/obj/item/clothing/under/rank/fatigues //regular sol navy uniform
	name = "sol navy coveralls"
	desc = "Fire-retardant naval utility coveralls, worn by Solarian naval personnel serving aboard ships and in the field."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "sol_uniform"
	item_state = "sol_uniform"
	contained_sprite = 1
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR
		)

/obj/item/clothing/under/rank/fatigues/marine //regular sol navy marine fatigues
	name = "sol marine fatigues"
	desc = "A military uniform issued to Sol Alliance marines, to be used while in the field."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "marine_fatigue"
	item_state = "marine_fatigue"
	contained_sprite = 1

/obj/item/clothing/under/rank/fatigues/Initialize()
	.=..()
	rolled_sleeves = 0

/obj/item/clothing/under/rank/fatigues/rollsleeves()
	set name = "Roll Up Sleeves"
	set category = "Object"
	set src in usr

	if (use_check(usr, USE_DISALLOW_SILICONS))
		return

	rolled_sleeves = !rolled_sleeves
	if(rolled_sleeves)
		body_parts_covered &= ~(ARMS|HANDS)
		item_state = "[item_state]_r_s"
	else
		body_parts_covered = initial(body_parts_covered)
		item_state = initial(item_state)
	update_clothing_icon()

/obj/item/clothing/under/rank/service //navy personnel service unniform
	name = "sol navy service uniform"
	desc = "A military service uniform issued to Sol Alliance naval personnel, to be worn in environments where a utility uniform is unfitting."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "whiteservice"
	item_state = "whiteservice"
	contained_sprite = 1

/obj/item/clothing/under/rank/service/marine //sol marine service unniform
	name = "sol marine service uniform"
	desc = "A military service uniform issued to Sol Alliance marines, to be worn in environments where a utility uniform is unfitting."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "tanutility"
	item_state = "tanutility"
	contained_sprite = 1

/obj/item/clothing/under/rank/dress //navy personnel dress unniform
	name = "sol navy dress uniform"
	desc = "A fancy military dress uniform issued to Sol Alliance naval personnel, to be worn in environments where a service uniform isn't formal enough."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "sailor"
	item_state = "sailor"
	contained_sprite = 1

/obj/item/clothing/under/rank/dress/marine //sol marine dress unniform
	name = "sol marine dress uniform"
	desc = "A fancy military dress uniform issued to Sol Alliance marines, to be worn in environments where a service uniform isn't formal enough."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "mahreendress"
	item_state = "mahreendress"
	contained_sprite = 1

/obj/item/clothing/under/rank/dress/subofficer //sol marine officer dress unniform
	name = "sol navy junior officer uniform"
	desc = "A fancy military uniform issued to lower ranking Sol Alliance navy officers. An officer in this uniform would be an Ensign, Sub-Lieutenant, or Lieutenant."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "subdress"
	item_state = "subdress"
	contained_sprite = 1

/obj/item/clothing/under/rank/dress/officer //sol marine officer dress unniform
	name = "sol navy senior officer uniform"
	desc = "A fancy military uniform issued to high ranking Sol Alliance navy officers. An officer in this uniform would be a Lieutenant Commander, Commander, or Captain."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "dress"
	item_state = "dress"
	contained_sprite = 1

/obj/item/clothing/under/rank/dress/admiral //admiral uniform
	name = "sol navy admiral uniform"
	desc = "A fancy military uniform issued to a higher member of the Sol Alliance navy. An officer in this uniform would be some form of Admiral."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "admiral_uniform"
	item_state = "admiral_uniform"
	contained_sprite = 1
