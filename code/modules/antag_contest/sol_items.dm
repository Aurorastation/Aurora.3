/*
 * Sol Alliance military related items
 */


/obj/item/weapon/implant/loyalty/sol
	name = "loyalty implant"
	desc = "Makes you loyal to the Sol Alliance, or to a certain individual."

/obj/item/weapon/implant/loyalty/sol/implanted(mob/M)
	if(!istype(M, /mob/living/carbon/human))	return 0
	var/mob/living/carbon/human/H = M
	var/datum/antagonist/antag_data = get_antag_data(H.mind.special_role)
	if(antag_data && (antag_data.flags & ANTAG_IMPLANT_IMMUNE))
		H.visible_message("[H] seems to resist the implant!", "You feel the tendrils of the Sol Alliance try to invade your mind!")
		return 0
	else
		clear_antag_roles(H.mind, 1)
		to_chat(H, "<span class='notice'>You feel a surge of loyalty towards Admiral Michael Frost.</span>")
	return 1


//sol uniforms

/obj/item/clothing/under/rank/fatigues //regular sol navy combat fatigues
	name = "sol navy fatigues"
	desc = "Military looking uniform issued to Sol Alliance navy, to be used while in the field."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "sol_uniform"
	item_state = "sol_uniform"
	contained_sprite = 1
	armor = list(melee = 10, bullet = 10, laser = 10,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/rank/fatigues/marine //regular sol navy marine fatigues
	name = "sol marine fatigues"
	desc = "Military looking uniform issued to Sol Alliance marines, to be used while in the field."
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
	desc = "Military looking service uniform issued to Sol Alliance navy members."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "whiteservice"
	item_state = "whiteservice"
	contained_sprite = 1

/obj/item/clothing/under/rank/service/marine //sol marine service unniform
	name = "sol marine service uniform"
	desc = "Military looking service uniform issued to Sol Alliance marines."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "tanutility"
	item_state = "tanutility"
	contained_sprite = 1

/obj/item/clothing/under/rank/dress //navy personnel dress unniform
	name = "sol navy dress uniform"
	desc = "A fancy military looking dress uniform issued to Sol Alliance navy members."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "sailor"
	item_state = "sailor"
	contained_sprite = 1

/obj/item/clothing/under/rank/dress/marine //sol marine dress unniform
	name = "sol marine dress uniform"
	desc = "A fancy military looking dress uniform issued to Sol Alliance marine."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "mahreendress"
	item_state = "mahreendress"
	contained_sprite = 1

/obj/item/clothing/under/rank/dress/officer //sol marine officer dress unniform
	name = "sol navy commander dress uniform"
	desc = "A fancy military looking dress uniform issued to high ranking Sol Alliance navy officers. This one wears the rank of Commander"
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "dress"
	item_state = "dress"
	contained_sprite = 1

/obj/item/clothing/under/rank/dress/subofficer //sol marine officer dress unniform
	name = "sol navy lieutenant dress uniform"
	desc = "A fancy military looking dress uniform issued to lower ranking Sol Alliance navy officers. This one wears the rank of Lieutenant"
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "subdress"
	item_state = "subdress"
	contained_sprite = 1

/obj/item/clothing/under/rank/dress/admiral //admiral uniform
	name = "sol navy admiral uniform"
	desc = "A fancy military dress uniform issued to a higher member of the Sol Alliance navy."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "admiral_uniform"
	item_state = "admiral_uniform"
	contained_sprite = 1

//hats

/obj/item/clothing/head/navy
	name = "sol navy utility cover"
	desc = "An eight pointed cover issued to Sol Alliance navy members as part of their field uniform."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "greyutility"
	item_state = "greyutility"
	contained_sprite = 1
	armor = list(melee = 10, bullet = 10, laser = 10,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/head/navy/marine
	name = "sol marine utility cover"
	desc = "An eight pointed cover issued to Sol Alliance marines as part of their field uniform."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "greenutility"
	item_state = "greenutility"
	contained_sprite = 1

/obj/item/clothing/head/navy/garrison
	name = "sol marine garrison cap"
	desc = "A green garrison cap issued to Sol Alliance marines."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "greengarrisoncap"
	item_state = "greengarrisoncap"
	contained_sprite = 1

/obj/item/clothing/head/dress
	name = "sol navy dress cap"
	desc = "A white cap issued as part of the Sol Alliance navy dress uniform."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "whitepeakcap"
	item_state = "whitepeakcap"
	contained_sprite = 1

/obj/item/clothing/head/dress/marine
	name = "sol marine dress cap"
	desc = "A green cap issued as part of the Sol Alliance marine dress uniform."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "whitepeakcap"
	item_state = "whitepeakcap"
	contained_sprite = 1

/obj/item/clothing/head/dress/officer
	name = "sol navy officer dress cap"
	desc = "A white cap issued as part of the Sol Alliance navy officers dress uniform."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "whitewheelcap"
	item_state = "whitewheelcap"
	contained_sprite = 1

/obj/item/clothing/head/dress/admiral
	name = "sol navy admiral dress cap"
	desc = "A fancy looking cap issued to a higher member of the Sol Alliance navy."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "admiral_cap"
	item_state = "admiral_cap"
	contained_sprite = 1

//ceremonial swords

/obj/item/weapon/melee/ceremonial_sword
	name = "sol officer ceremonial sword"
	desc = "A ceremonial sword issued to Sol navy officers as part of their dress uniform."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "officersword"
	item_state = "officersword"
	contained_sprite = 1
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 15
	throwforce = 5
	w_class = 4
	sharp = 1
	edge = 1
	can_embed = 0
	origin_tech = list(TECH_COMBAT = 4)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/weapon/melee/ceremonial_sword/marine
	name = "sol marine ceremonial sword"
	desc = "A ceremonial sword issued to Sol marine officers as part of their dress uniform."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "marineofficersword"
	item_state = "marineofficersword"
	contained_sprite = 1

//vest and helmet

/obj/item/clothing/head/helmet/sol
	name = "sol combat helmet"
	desc = "A woodland colored helmet made from advanced ceramic."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "helmet_tac_sol"
	item_state = "helmet_tac_sol"
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 40, bio = 0, rad = 0)
	contained_sprite = 1

/obj/item/clothing/suit/storage/vest/sol
	name = "sol heavy armor vest"
	desc = "A high-quality armor vest in a deep green. It is surprisingly flexible and light, even with the added webbing and armor plating."
	icon = 'icons/obj/sol_uniform.dmi'
	icon_state = "solwebvest"
	item_state = "solwebvest"
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 40, bio = 0, rad = 0)
	contained_sprite = 1

//closet uniform

/obj/structure/closet/sol
	name = "sol navy uniform closet"
	desc = "It's a storage unit for Sol Alliance navy uniforms."
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"

/obj/structure/closet/sol/navy/fill()
	..()
	new /obj/item/clothing/under/rank/fatigues(src)
	new /obj/item/clothing/under/rank/fatigues(src)
	new /obj/item/clothing/under/rank/fatigues(src)
	new /obj/item/clothing/under/rank/service(src)
	new /obj/item/clothing/under/rank/service(src)
	new /obj/item/clothing/under/rank/service(src)
	new /obj/item/clothing/head/navy(src)
	new /obj/item/clothing/head/navy(src)
	new /obj/item/clothing/head/navy(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)

/obj/structure/closet/sol/marine
	name = "sol marines uniform closet"
	desc = "It's a storage unit for Sol Alliance marine uniforms."

/obj/structure/closet/sol/marine/fill()
	..()
	new /obj/item/clothing/under/rank/fatigues/marine(src)
	new /obj/item/clothing/under/rank/fatigues/marine(src)
	new /obj/item/clothing/under/rank/fatigues/marine(src)
	new /obj/item/clothing/under/rank/service/marine(src)
	new /obj/item/clothing/under/rank/service/marine(src)
	new /obj/item/clothing/under/rank/service/marine(src)
	new /obj/item/clothing/head/navy/marine(src)
	new /obj/item/clothing/head/navy/marine(src)
	new /obj/item/clothing/head/navy/garrison(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)

/obj/structure/closet/sol/navy_dress
	name = "sol navy dress uniform closet"
	desc = "It's a storage unit for Sol Alliance navy dress uniforms."

/obj/structure/closet/sol/navy_dress/fill()
	..()
	new /obj/item/clothing/under/rank/dress(src)
	new /obj/item/clothing/under/rank/dress(src)
	new /obj/item/clothing/under/rank/dress(src)
	new /obj/item/clothing/head/dress(src)
	new /obj/item/clothing/head/dress(src)
	new /obj/item/clothing/head/dress(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/gloves/white(src)
	new /obj/item/clothing/gloves/white(src)
	new /obj/item/clothing/gloves/white(src)

/obj/structure/closet/sol/marine_dress
	name = "sol marine dress uniform closet"
	desc = "It's a storage unit for Sol Alliance marine dress uniforms."

/obj/structure/closet/sol/marine_dress/fill()
	..()
	new /obj/item/clothing/under/rank/dress/marine(src)
	new /obj/item/clothing/under/rank/dress/marine(src)
	new /obj/item/clothing/under/rank/dress/marine(src)
	new /obj/item/clothing/head/dress/marine(src)
	new /obj/item/clothing/head/dress/marine(src)
	new /obj/item/clothing/head/dress/marine(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/gloves/white(src)
	new /obj/item/clothing/gloves/white(src)
	new /obj/item/clothing/gloves/white(src)

/obj/structure/closet/secure_closet/soll_officer
	name = "sol alliance officer locker"
	req_access = list(access_captain)
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"

/obj/structure/closet/secure_closet/soll_officer/fill()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/captain(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_cap(src)
	new /obj/item/clothing/under/rank/dress/officer(src)
	new /obj/item/clothing/head/dress/officer(src)
	new /obj/item/clothing/suit/storage/vest(src)
	new /obj/item/weapon/cartridge/captain(src)
	new /obj/item/clothing/head/helmet(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/device/radio/headset/heads/captain(src)
	new /obj/item/clothing/gloves/white(src)
	new /obj/item/weapon/gun/energy/pistol(src)
	new /obj/item/device/flash(src)
	new /obj/item/weapon/melee/telebaton(src)
	new /obj/item/weapon/melee/ceremonial_sword(src)
	new /obj/item/clothing/under/rank/fatigues(src)
	new /obj/item/clothing/under/rank/service(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/accessory/holster/armpit(src)
	return
