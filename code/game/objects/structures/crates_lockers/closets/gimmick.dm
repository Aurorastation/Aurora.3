/obj/structure/closet/cabinet
	name = "cabinet"
	desc = "Old will forever be in fashion."
	icon_state = "cabinet"
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	storage_capacity = 45 //such a big closet deserves a little more capacity
	door_anim_angle = 160
	door_anim_squish = 0.22
	door_hinge_x_alt = 7.5
	double_doors = TRUE

/obj/structure/closet/cabinet/attackby(obj/item/attacking_item, mob/user)
	if(opened)
		if(istype(attacking_item, /obj/item/grab))
			var/obj/item/grab/G = attacking_item
			mouse_drop_receive(G.affecting, user)      //act like they were dragged onto the closet
			return 0
		if(!attacking_item.dropsafety())
			return
		if(attacking_item)
			user.drop_from_inventory(attacking_item, loc)
		else
			user.drop_item()
	else if(istype(attacking_item, /obj/item/stack/packageWrap))
		return
	else
		attack_hand(user)
	return

/obj/structure/closet/acloset
	name = "strange closet"
	desc = "It looks alien!"
	icon_state = "decursed"

/obj/structure/closet/gimmick
	name = "administrative supply closet"
	icon_state = "syndicate1"

/obj/structure/closet/gimmick/russian
	name = "russian surplus closet"
	desc = "It's a storage unit for Russian standard-issue surplus."

/obj/structure/closet/gimmick/russian/fill()
	new /obj/item/clothing/head/ushanka/grey(src)
	new /obj/item/clothing/head/ushanka/grey(src)
	new /obj/item/clothing/head/ushanka/grey(src)
	new /obj/item/clothing/head/ushanka/grey(src)
	new /obj/item/clothing/head/ushanka/grey(src)

/obj/structure/closet/gimmick/tacticool
	name = "tacticool gear closet"
	desc = "It's a storage unit for Tacticool gear."

/obj/structure/closet/gimmick/tacticool/fill()
	new /obj/item/clothing/glasses/eyepatch(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/gloves/swat(src)
	new /obj/item/clothing/gloves/swat(src)
	new /obj/item/clothing/head/helmet/swat(src)
	new /obj/item/clothing/head/helmet/swat(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/shoes/combat(src)
	new /obj/item/clothing/shoes/combat(src)
	new /obj/item/clothing/suit/armor/swat(src)
	new /obj/item/clothing/suit/armor/swat(src)
	new /obj/item/clothing/under/syndicate/tacticool(src)
	new /obj/item/clothing/under/syndicate/tacticool(src)


/obj/structure/closet/thunderdome
	name = "\improper Thunderdome closet"
	desc = "Everything you need!"
	icon_state = "syndicate"
	anchored = 1

/obj/structure/closet/thunderdome/tdred
	name = "red-team Thunderdome closet"

/obj/structure/closet/thunderdome/tdred/fill()
	new /obj/item/clothing/suit/armor/tdome/red(src)
	new /obj/item/clothing/suit/armor/tdome/red(src)
	new /obj/item/clothing/suit/armor/tdome/red(src)
	new /obj/item/melee/energy/sword(src)
	new /obj/item/melee/energy/sword(src)
	new /obj/item/melee/energy/sword(src)
	new /obj/item/gun/energy/laser(src)
	new /obj/item/gun/energy/laser(src)
	new /obj/item/gun/energy/laser(src)
	new /obj/item/melee/baton(src)
	new /obj/item/melee/baton(src)
	new /obj/item/melee/baton(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)

/obj/structure/closet/thunderdome/tdgreen
	name = "green-team Thunderdome closet"
	icon_state = "syndicate1"

/obj/structure/closet/thunderdome/tdgreen/fill()
	new /obj/item/clothing/suit/armor/tdome/green(src)
	new /obj/item/clothing/suit/armor/tdome/green(src)
	new /obj/item/clothing/suit/armor/tdome/green(src)
	new /obj/item/melee/energy/sword(src)
	new /obj/item/melee/energy/sword(src)
	new /obj/item/melee/energy/sword(src)
	new /obj/item/gun/energy/laser(src)
	new /obj/item/gun/energy/laser(src)
	new /obj/item/gun/energy/laser(src)
	new /obj/item/melee/baton(src)
	new /obj/item/melee/baton(src)
	new /obj/item/melee/baton(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)

/obj/structure/closet/skrell
	icon_state = "alien"
	layer = BELOW_OBJ_LAYER

/obj/structure/closet/outhouse
	name = "outhouse"
	desc = "A rustic sanitation structure."
	icon_state = "outhouse"
	anchored = TRUE
	canbemoved = FALSE
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'

/obj/structure/closet/sarcophagus
	name = "sandstone sarcophagus"
	desc = "An ancient sarcophagus made of sandstone."
	icon = 'icons/obj/unathi_ruins.dmi'
	icon_state = "wc_sarcophagus"
	dense_when_open = TRUE
	anchored = TRUE
	canbemoved = FALSE
	open_sound = 'sound/effects/stonedoor_openclose.ogg'
	close_sound = 'sound/effects/stonedoor_openclose.ogg'
	///Icon state for the open sarcophagus
	var/open_state = "wc_sarcophagus_open"
	///Icon state for the closed sarcophagus
	var/closed_state = "wc_sarcophagus"
	///Does this sarcophagus have a booby trap?
	var/trapped = FALSE
	///Has this sarcophagus's trap been triggered?
	var/triggered = FALSE

/obj/structure/closet/sarcophagus/update_icon()
	if(!opened)
		layer = OBJ_LAYER
		icon_state = closed_state

	else
		layer = BELOW_OBJ_LAYER
		icon_state = open_state

/obj/structure/closet/sarcophagus/animate_door(var/closing = FALSE)
	return

/obj/structure/closet/sarcophagus/attack_hand(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(trapped && !triggered)
			do_trap_effect(H)

///Sets off the sarcophagus's trap if not already triggered.
/obj/structure/closet/sarcophagus/proc/do_trap_effect(var/mob/living/carbon/human/H)
	if(triggered)
		return
	if(prob(33))
		var/turf/T = get_turf(src)
		var/obj/item/arrow/arrow = new(T)
		playsound(usr.loc, 'sound/weapons/crossbow.ogg', 75, 1)
		arrow.throw_at(H, 10, 9, src) //same values as a full draw crossbow shot would have

	else if(prob(33))
		visible_message(SPAN_DANGER("Flames engulf \the [H]!"))
		H.apply_damage(30, DAMAGE_BURN)
		H.IgniteMob(5)

	else
		var/datum/reagents/R = new/datum/reagents(20)
		R.my_atom = src
		R.add_reagent(/singleton/reagent/toxin,20)
		var/datum/effect/effect/system/smoke_spread/chem/S = new /datum/effect/effect/system/smoke_spread/chem(/singleton/reagent/toxin) // have to explicitly say the type to avoid issues with warnings
		S.show_log = 0
		S.set_up(R, 10, 0, src, 40)
		S.start()
		qdel(R)

	triggered = TRUE

/obj/structure/closet/sarcophagus/random/Initialize() //low chance of being trapped
	. = ..()
	if(prob(10))
		trapped = TRUE

/obj/structure/closet/sarcophagus/mador
	name = "granite sarcophagus"
	desc = "An ancient sarcophagus made of granite."
	icon_state = "mador_sarcophagus"
	closed_state = "mador_sarcophagus"
	open_state = "mador_sarcophagus_open"

/obj/structure/closet/sarcophagus/mador/random/Initialize()
	. = ..()
	if(prob(10))
		trapped = TRUE
