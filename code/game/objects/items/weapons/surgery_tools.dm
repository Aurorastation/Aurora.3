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
/obj/item/surgery
	name = "surgery tool parent item"
	desc = DESC_PARENT
	icon = 'icons/obj/surgery.dmi'
	w_class = ITEMSIZE_SMALL
	drop_sound = 'sound/items/drop/weldingtool.ogg'
	pickup_sound = 'sound/items/pickup/weldingtool.ogg'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_medical.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_medical.dmi',
	)
	recyclable = TRUE

/*
 * Retractor
 */
/obj/item/surgery/retractor
	name = "retractor"
	desc = "A surgical instrument which allows careful opening of incisions to reach inside someone."
	icon_state = "retractor"
	item_state = "retractor"
	matter = list(DEFAULT_WALL_MATERIAL = 10000, MATERIAL_GLASS = 5000)
	flags = CONDUCT
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)

/*
 * Hemostat
 */
/obj/item/surgery/hemostat
	name = "hemostat"
	desc = "Primarily utilized to control initial incision bleeding, this instrument allows for careful removal of objects inside someone."
	icon_state = "hemostat"
	item_state = "hemostat"
	matter = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 2500)
	flags = CONDUCT
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("attacked", "pinched")

/*
 * Cautery
 */
/obj/item/surgery/cautery
	name = "cautery"
	desc = "A specialized surgical tool which applies just enough heat to safely close surgical incisions, when used correctly at least."
	icon_state = "cautery"
	item_state = "cautery"
	matter = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 2500)
	flags = CONDUCT
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("burnt")

/*
 * Surgical Drill
 */
/obj/item/surgery/surgicaldrill
	name = "surgical drill"
	desc = "A drill specialized for surgical use, capable of creating surgical cavities and safely breaching through Vaurcae carapace for initial incisions."
	icon_state = "drill"
	item_state = "drill"
	hitsound = /singleton/sound_category/drillhit_sound
	matter = list(DEFAULT_WALL_MATERIAL = 15000, MATERIAL_GLASS = 10000)
	flags = CONDUCT
	force = 15
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("drilled")
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/*
 * Scalpel
 */
/obj/item/surgery/scalpel
	name = "scalpel"
	desc = "A metallic scalpel with long-lasting edge. Used in a variety of surgical situations from incisions, to transplants, to debridements."
	icon_state = "scalpel"
	item_state = "scalpel"
	flags = CONDUCT
	force = 10
	sharp = 1
	edge = TRUE
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 10000, MATERIAL_GLASS = 5000)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	drop_sound = 'sound/items/drop/knife.ogg'
	pickup_sound = 'sound/items/pickup/knife.ogg'

/*
 * Researchable Scalpels
 */
/obj/item/surgery/scalpel/laser1
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks basic and could be improved."
	icon_state = "scalpel_laser1"
	damtype = "fire"

/obj/item/surgery/scalpel/laser2
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks somewhat advanced."
	icon_state = "scalpel_laser2"
	damtype = "fire"
	force = 12

/obj/item/surgery/scalpel/laser3
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks to be the pinnacle of precision energy cutlery!"
	icon_state = "scalpel_laser3"
	damtype = "fire"
	force = 15

/obj/item/surgery/scalpel/manager
	name = "incision management system"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	icon_state = "scalpel_manager"
	force = 7.5

/*
 * Circular Saw
 */
/obj/item/surgery/circular_saw
	name = "circular saw"
	desc = "A circular bone saw specialized for cutting through bones, amputations, and even hardsuits if required."
	icon_state = "saw"
	item_state = "saw"
	hitsound = 'sound/weapons/saw/circsawhit.ogg'
	flags = CONDUCT
	force = 15
	w_class = ITEMSIZE_NORMAL
	throwforce = 9
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 20000, MATERIAL_GLASS = 10000)
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	sharp = TRUE
	edge = TRUE
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

// Miscellanous
/obj/item/surgery/bone_gel
	name = "bone gel"
	desc = "A highly specialized gel which promotes fast bone healing."
	icon_state = "bone-gel"
	item_state = "bone-gel"
	force = 2
	throwforce = 5
	drop_sound = 'sound/items/drop/bottle.ogg'
	pickup_sound = 'sound/items/pickup/bottle.ogg'

/obj/item/surgery/fix_o_vein
	name = "FixOVein"
	desc = "A specialized surgical instrument capable of quickly and safely healing torn veins and arteries, being capable of repairing torn ligaments as well."
	icon_state = "fixovein"
	item_state = "fixovein"
	force = 2
	throwforce = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 3)
	var/usage_amount = 10
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/surgery/bonesetter
	name = "bone setter"
	desc = "A surgical tool designed to firmly set damaged bones back together for proper healing."
	icon_state = "bonesetter"
	item_state = "bonesetter"
	force = 8
	throwforce = 9
	throw_speed = 3
	throw_range = 5
	attack_verb = list("attacked", "hit", "bludgeoned")

/obj/item/storage/box/fancy/tray
	name = "surgery tray"
	desc = "A tray of surgical tools."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "surgerytray"
	use_sound = null
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'
	force = 2
	w_class = ITEMSIZE_HUGE
	storage_slots = 10
	attack_verb = list("slammed")
	icon_type = "surgery tool"
	storage_type = "tray"
	can_hold = list(
		/obj/item/surgery/bonesetter,
		/obj/item/surgery/cautery,
		/obj/item/surgery/circular_saw,
		/obj/item/surgery/hemostat,
		/obj/item/surgery/retractor,
		/obj/item/surgery/scalpel,
		/obj/item/surgery/surgicaldrill,
		/obj/item/surgery/bone_gel,
		/obj/item/surgery/fix_o_vein,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/nanopaste
	)

	starts_with = list(
		/obj/item/surgery/bonesetter = 1,
		/obj/item/surgery/cautery = 1,
		/obj/item/surgery/circular_saw = 1,
		/obj/item/surgery/hemostat = 1,
		/obj/item/surgery/retractor = 1,
		/obj/item/surgery/scalpel = 1,
		/obj/item/surgery/surgicaldrill = 1,
		/obj/item/surgery/bone_gel = 1,
		/obj/item/surgery/fix_o_vein = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1
	)

/obj/item/storage/box/fancy/tray/update_icon()
	cut_overlays()

	var/list/types_and_overlays = list(
		/obj/item/surgery/bonesetter = "tray_bonesetter",
		/obj/item/surgery/cautery = "tray_cautery",
		/obj/item/surgery/circular_saw = "tray_saw",
		/obj/item/surgery/hemostat = "tray_hemostat",
		/obj/item/surgery/retractor = "tray_retractor",
		/obj/item/surgery/scalpel = "tray_scalpel",
		/obj/item/surgery/scalpel/laser1 = "tray_scalpel_laser1",
		/obj/item/surgery/scalpel/laser2 = "tray_scalpel_laser2",
		/obj/item/surgery/scalpel/laser3 = "tray_scalpel_laser3",
		/obj/item/surgery/scalpel/manager = "tray_scalpel_manager",
		/obj/item/surgery/surgicaldrill = "tray_drill",
		/obj/item/surgery/bone_gel = "tray_bone-gel",
		/obj/item/surgery/fix_o_vein = "tray_fixovein",
		/obj/item/stack/medical/advanced/bruise_pack = "tray_bruise_pack",
		/obj/item/autopsy_scanner = "tray_autopsy_scanner",
		/obj/item/device/mass_spectrometer = "tray_mass_spectrometer",
		/obj/item/reagent_containers/glass/beaker/vial = "tray_vial",
		/obj/item/reagent_containers/syringe = "tray_syringe"
	)
	for (var/obj/item/W in contents)
		if (types_and_overlays[W.type])
			add_overlay(types_and_overlays[W.type])
			types_and_overlays -= W.type

/obj/item/storage/box/fancy/tray/fill()
	. = ..()
	update_icon()

/obj/item/storage/box/fancy/tray/attackby(obj/item/W as obj, mob/user as mob)
	..()
	update_icon()

/obj/item/storage/box/fancy/tray/attack_hand(mob/user as mob)
	if(ishuman(user))
		src.open(user)

/obj/item/storage/box/fancy/tray/MouseDrop(mob/user as mob)
	if((user && (!use_check(user))) && (user.contents.Find(src) || in_range(src, user)))
		if(ishuman(user) && !user.get_active_hand())
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]

			if (H.hand)
				temp = H.organs_by_name[BP_L_HAND]
			if(temp && !temp.is_usable())
				to_chat(user, "<span class='notice'>You try to move your [temp.name], but cannot!</span>")
				return

			to_chat(user, "<span class='notice'>You pick up the [src].</span>")
			pixel_x = 0
			pixel_y = 0
			forceMove(get_turf(user))
			user.put_in_hands(src)

	return

/obj/item/storage/box/fancy/tray/attack(mob/living/M as mob, mob/user as mob, var/target_zone)
	if(..() && contents.len)
		spill(3, get_turf(M))
		playsound(M, /singleton/sound_category/tray_hit_sound, 50, 1)  //sound playin' again
		user.visible_message(SPAN_DANGER("[user] smashes \the [src] into [M], causing it to spill its contents across the area!"))

/obj/item/storage/box/fancy/tray/throw_impact(atom/hit_atom)
	..()
	spill(3, src.loc)

/obj/item/storage/box/fancy/tray/autopsy
	name = "autopsy tray"
	starts_with = list(
		/obj/item/surgery/circular_saw = 1,
		/obj/item/surgery/hemostat = 1,
		/obj/item/surgery/retractor = 1,
		/obj/item/surgery/scalpel = 1,
		/obj/item/surgery/surgicaldrill = 1,
		/obj/item/surgery/cautery = 1,
		/obj/item/autopsy_scanner = 1,
		/obj/item/device/mass_spectrometer = 1,
		/obj/item/reagent_containers/glass/beaker/vial = 1,
		/obj/item/reagent_containers/syringe = 1
	)

	can_hold = list(
		/obj/item/surgery/circular_saw,
		/obj/item/surgery/hemostat,
		/obj/item/surgery/retractor,
		/obj/item/surgery/scalpel,
		/obj/item/surgery/surgicaldrill,
		/obj/item/surgery/cautery,
		/obj/item/autopsy_scanner,
		/obj/item/device/mass_spectrometer,
		/obj/item/reagent_containers/glass/beaker/vial,
		/obj/item/reagent_containers/syringe
	)

/obj/item/storage/box/fancy/tray/machinist
	name = "machinist operation tray"
	desc = "A tray of various tools for use by machinists in repairing robots."
	can_hold = list(
		/obj/item/surgery/cautery,
		/obj/item/surgery/circular_saw,
		/obj/item/surgery/hemostat,
		/obj/item/surgery/retractor,
		/obj/item/surgery/scalpel,
		/obj/item/stack/nanopaste
		)

	starts_with = list(
		/obj/item/surgery/cautery = 1,
		/obj/item/surgery/circular_saw = 1,
		/obj/item/surgery/hemostat = 1,
		/obj/item/surgery/retractor = 1,
		/obj/item/surgery/scalpel = 1
	)