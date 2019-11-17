/* Surgery Tools
 * Contains:
 *		Retractor
 *		Hemostat
 *		Cautery
 *		Surgical Drill
 *		Scalpel
 *		Circular Saw
 *   	Tray
 */

/*
 * Retractor
 */
/obj/item/retractor
	name = "retractor"
	desc = "Retracts stuff."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "retractor"
	matter = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 5000)
	flags = CONDUCT
	w_class = 2.0
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	drop_sound = 'sound/items/drop/scrap.ogg'

/*
 * Hemostat
 */
/obj/item/hemostat
	name = "hemostat"
	desc = "You think you have seen this before."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "hemostat"
	matter = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 2500)
	flags = CONDUCT
	w_class = 2.0
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("attacked", "pinched")
	drop_sound = 'sound/items/drop/scrap.ogg'

/*
 * Cautery
 */
/obj/item/cautery
	name = "cautery"
	desc = "This stops bleeding."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "cautery"
	matter = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 2500)
	flags = CONDUCT
	w_class = 2.0
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("burnt")
	drop_sound = 'sound/items/drop/scrap.ogg'

/*
 * Surgical Drill
 */
/obj/item/surgicaldrill
	name = "surgical drill"
	desc = "You can drill using this item. You dig?"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "drill"
	hitsound = 'sound/weapons/saw/circsawhit.ogg'
	matter = list(DEFAULT_WALL_MATERIAL = 15000, "glass" = 10000)
	flags = CONDUCT
	force = 15.0
	w_class = 3
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("drilled")
	drop_sound = 'sound/items/drop/accessory.ogg'

/*
 * Scalpel
 */
/obj/item/scalpel
	name = "scalpel"
	desc = "Cut, cut, and once more cut."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "scalpel"
	flags = CONDUCT
	force = 10.0
	sharp = 1
	edge = 1
	w_class = 1
	slot_flags = SLOT_EARS
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 5000)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	drop_sound = 'sound/items/drop/knife.ogg'

/*
 * Researchable Scalpels
 */
/obj/item/scalpel/laser1
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks basic and could be improved."
	icon_state = "scalpel_laser1_on"
	damtype = "fire"

/obj/item/scalpel/laser2
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks somewhat advanced."
	icon_state = "scalpel_laser2_on"
	damtype = "fire"
	force = 12.0

/obj/item/scalpel/laser3
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks to be the pinnacle of precision energy cutlery!"
	icon_state = "scalpel_laser3_on"
	damtype = "fire"
	force = 15.0

/obj/item/scalpel/manager
	name = "incision management system"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	icon_state = "scalpel_manager_on"
	force = 7.5

/*
 * Circular Saw
 */
/obj/item/circular_saw
	name = "circular saw"
	desc = "For heavy duty cutting."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "saw"
	hitsound = 'sound/weapons/saw/circsawhit.ogg'
	flags = CONDUCT
	force = 15.0
	w_class = 3
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 20000,"glass" = 10000)
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	sharp = 1
	edge = 1
	drop_sound = 'sound/items/drop/accessory.ogg'

//misc, formerly from code/defines/weapons.dm
/obj/item/bonegel
	name = "bone gel"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone-gel"
	force = 0
	w_class = 2.0
	throwforce = 1.0
	drop_sound = 'sound/items/drop/bottle.ogg'

/obj/item/FixOVein
	name = "FixOVein"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "fixovein"
	force = 0
	throwforce = 1.0
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 3)
	w_class = 2.0
	var/usage_amount = 10
	drop_sound = 'sound/items/drop/accessory.ogg'

/obj/item/bonesetter
	name = "bone setter"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bonesetter"
	force = 8.0
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	w_class = 2.0
	attack_verb = list("attacked", "hit", "bludgeoned")
	drop_sound = 'sound/items/drop/scrap.ogg'

/obj/item/storage/fancy/tray
	name = "surgery tray"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "surgerytray"
	use_sound = null
	drop_sound = 'sound/items/drop/axe.ogg'
	force = 2
	w_class = 5.0
	storage_slots = 10
	attack_verb = list("slammed")
	icon_type = "surgery tool"
	storage_type = "tray"
	can_hold = list(
		/obj/item/bonesetter,
		/obj/item/cautery,
		/obj/item/circular_saw,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/scalpel,
		/obj/item/surgicaldrill,
		/obj/item/bonegel,
		/obj/item/FixOVein,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/nanopaste
		)

	starts_with = list(
		/obj/item/bonesetter = 1,
		/obj/item/cautery = 1,
		/obj/item/circular_saw = 1,
		/obj/item/hemostat = 1,
		/obj/item/retractor = 1,
		/obj/item/scalpel = 1,
		/obj/item/surgicaldrill = 1,
		/obj/item/bonegel = 1,
		/obj/item/FixOVein = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
	)

/obj/item/storage/fancy/tray/update_icon()
	cut_overlays()

	var/list/types_and_overlays = list(
		/obj/item/bonesetter = "tray_bonesetter",
		/obj/item/cautery = "tray_cautery",
		/obj/item/circular_saw = "tray_saw",
		/obj/item/hemostat = "tray_hemostat",
		/obj/item/retractor = "tray_retractor",
		/obj/item/scalpel = "tray_scalpel",
		/obj/item/surgicaldrill = "tray_drill",
		/obj/item/bonegel = "tray_bone-gel",
		/obj/item/FixOVein = "tray_fixovein",
		/obj/item/stack/medical/advanced/bruise_pack = "tray_bruise_pack"
	)
	for (var/obj/item/W in contents)
		if (types_and_overlays[W.type])
			add_overlay(types_and_overlays[W.type])
			types_and_overlays -= W.type

/obj/item/storage/fancy/tray/fill()
	. = ..()
	update_icon()

/obj/item/storage/fancy/tray/attackby(obj/item/W as obj, mob/user as mob)
	..()
	update_icon()

/obj/item/storage/fancy/tray/attack_hand(mob/user as mob)
	if(ishuman(user))
		src.open(user)

/obj/item/storage/fancy/tray/MouseDrop(mob/user as mob)
	if((user && (!use_check(user))) && (user.contents.Find(src) || in_range(src, user)))
		if(ishuman(user) && !user.get_active_hand())
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]

			if (H.hand)
				temp = H.organs_by_name["l_hand"]
			if(temp && !temp.is_usable())
				to_chat(user, "<span class='notice'>You try to move your [temp.name], but cannot!</span>")
				return

			to_chat(user, "<span class='notice'>You pick up the [src].</span>")
			pixel_x = 0
			pixel_y = 0
			forceMove(get_turf(user))
			user.put_in_hands(src)

	return

/obj/item/storage/fancy/tray/attack(mob/living/M as mob, mob/user as mob, var/target_zone)
	if(..() && contents.len)
		spill(3, get_turf(M))
		playsound(M, 'sound/items/trayhit2.ogg', 50, 1)  //sound playin' again
		user.visible_message(span("danger", "[user] smashes \the [src] into [M], causing it to spill its contents across the area!"))

/obj/item/storage/fancy/tray/throw_impact(atom/hit_atom)
	..()
	spill(3, src.loc)