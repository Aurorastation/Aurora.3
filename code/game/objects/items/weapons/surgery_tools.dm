/* Surgery Tools
 * Contains:
 * * Retractor
 * * Hemostat
 * * Cautery
 * * Surgical Drill
 * * Scalpel
 * * Circular Saw
 * * Tray
 */
/obj/item/surgery
	name = "surgery tool parent item"
	desc = DESC_PARENT
	icon = 'icons/obj/surgery.dmi'
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_SMALL
	drop_sound = 'sound/items/drop/weldingtool.ogg'
	pickup_sound = 'sound/items/pickup/weldingtool.ogg'
	recyclable = TRUE

/obj/item/surgery/Initialize(mapload, ...)
	. = ..()
	item_flags |= ITEM_FLAG_SURGERY

/*
 * Retractor
 */
/obj/item/surgery/retractor
	name = "retractor"
	desc = "A pair of retractor forceps. Allows careful opening of incisions to reach inside someone."
	icon_state = "retractor"
	item_state = "retractor"
	surgerysound = 'sound/items/surgery/retractor.ogg'
	matter = list(DEFAULT_WALL_MATERIAL = 10000, MATERIAL_GLASS = 5000)
	obj_flags = OBJ_FLAG_CONDUCTABLE
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)

/*
 * Hemostat
 */
/obj/item/surgery/hemostat
	name = "hemostat"
	desc = "A pair of hemostatic forceps, able to clamp blood vessels shut to stop bleeding during surgery. Its narrow tip also lets it double as a tool for removing things from surgical sites."
	icon_state = "hemostat"
	item_state = "hemostat"
	surgerysound = 'sound/items/surgery/hemostat.ogg'
	matter = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 2500)
	obj_flags = OBJ_FLAG_CONDUCTABLE
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("attacked", "pinched")

/*
 * Cautery
 */
/obj/item/surgery/cautery
	name = "cautery"
	desc = "An electrocautery pen. Uses electrical currents to burn tissue closed, useful for quickly sealing wounds or incisions."
	icon_state = "cautery"
	item_state = "cautery"
	surgerysound = 'sound/items/surgery/cautery.ogg'
	matter = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 2500)
	obj_flags = OBJ_FLAG_CONDUCTABLE
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("burnt")

/*
 * Surgical Drill
 */
/obj/item/surgery/surgicaldrill
	name = "surgical drill"
	desc = "A drill specialized for surgical use. Capable of creating surgical cavities and safely breaching through Vaurcae carapace for initial incisions."
	icon_state = "drill"
	item_state = "drill"
	surgerysound = 'sound/items/surgery/surgicaldrill.ogg'
	hitsound = /singleton/sound_category/drillhit_sound
	matter = list(DEFAULT_WALL_MATERIAL = 15000, MATERIAL_GLASS = 10000)
	obj_flags = OBJ_FLAG_CONDUCTABLE
	force = 22
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("drilled")
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/*
 * Scalpel
 */
/obj/item/surgery/scalpel
	name = "scalpel"
	desc = "A surgical-grade scalpel with an incredibly sharp blade that keeps its edge. Used in a variety of surgical situations from incisions, to transplants, to debridements."
	icon_state = "scalpel"
	item_state = "scalpel"
	surgerysound = 'sound/items/surgery/scalpel.ogg'
	obj_flags = OBJ_FLAG_CONDUCTABLE
	force = 15
	sharp = 1
	edge = TRUE
	w_class = WEIGHT_CLASS_TINY
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

/obj/item/surgery/scalpel/laser
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field."
	icon_state = "scalpel_laser"
	surgerysound = 'sound/items/surgery/cautery.ogg'
	matter = list(DEFAULT_WALL_MATERIAL = 12500, MATERIAL_GLASS = 7500)
	damtype = "fire"
	force = 18

/obj/item/surgery/scalpel/manager
	name = "incision management system"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	icon_state = "scalpel_manager"
	surgerysound = 'sound/items/surgery/cautery.ogg'
	matter = list (DEFAULT_WALL_MATERIAL = 12500, MATERIAL_GLASS = 7500, MATERIAL_SILVER = 1500, MATERIAL_GOLD = 1500, MATERIAL_DIAMOND = 750)
	force = 8

/*
 * Circular Saw
 */
/obj/item/surgery/circular_saw
	name = "surgical saw"
	desc = "A reciprocating electric bonesaw. While designed to cut through bone, it's powerful enough to cut limbs and even hardsuits if necessary. Watch your fingers."
	icon_state = "saw"
	item_state = "saw"
	surgerysound = 'sound/items/surgery/circularsaw.ogg'
	hitsound = 'sound/weapons/saw/circsawhit.ogg'
	obj_flags = OBJ_FLAG_CONDUCTABLE
	force = 22
	w_class = WEIGHT_CLASS_NORMAL
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
	desc = "A bottle-and-nozzle applicator containing a specialized gel. When applied to bone tissue, it can reinforce and repair breakages and act as a glue to keep bones in place while they heal."
	icon_state = "bone-gel"
	item_state = "bone-gel"
	surgerysound = 'sound/items/surgery/bonegel.ogg'
	force = 2
	throwforce = 5
	drop_sound = 'sound/items/drop/bottle.ogg'
	pickup_sound = 'sound/items/pickup/bottle.ogg'

/obj/item/surgery/fix_o_vein
	name = "vascular recoupler"
	desc = "An advanced automatic surgical instrument that operates with extreme finesse. It can quickly and safely repair and recouple ruptured blood vessels and ligaments using highly elaborate, biodegradable microsutures. It can also be used for transplantations to attach organs to the body."
	icon_state = "fixovein"
	item_state = "fixovein"
	surgerysound = 'sound/items/surgery/fixovein.ogg'
	force = 2
	throwforce = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 3)
	var/usage_amount = 10
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/surgery/bonesetter
	name = "bone setter"
	desc = "A pair of forceps with a screw. It's designed to manipulate bones and hold them together, and is best paired with a bottle of bone gel for mending fractures."
	icon_state = "bonesetter"
	item_state = "bonesetter"
	surgerysound = 'sound/items/surgery/bonesetter.ogg'
	force = 18
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
	w_class = WEIGHT_CLASS_HUGE
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
	ClearOverlays()

	var/list/types_and_overlays = list(
		/obj/item/surgery/bonesetter = "tray_bonesetter",
		/obj/item/surgery/cautery = "tray_cautery",
		/obj/item/surgery/circular_saw = "tray_saw",
		/obj/item/surgery/hemostat = "tray_hemostat",
		/obj/item/surgery/retractor = "tray_retractor",
		/obj/item/surgery/scalpel = "tray_scalpel",
		/obj/item/surgery/scalpel/laser = "tray_scalpel_laser",
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
			AddOverlays(types_and_overlays[W.type])
			types_and_overlays -= W.type

/obj/item/storage/box/fancy/tray/fill()
	. = ..()
	update_icon()

/obj/item/storage/box/fancy/tray/attackby(obj/item/attacking_item, mob/user)
	..()
	update_icon()

/obj/item/storage/box/fancy/tray/attack_hand(mob/user as mob)
	if(ishuman(user))
		src.open(user)

/obj/item/storage/box/fancy/tray/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if((over && (!use_check(over))) && (over.contents.Find(src) || in_range(src, over)))
		var/mob/dropped_onto_mob = over
		if(ishuman(dropped_onto_mob) && !dropped_onto_mob.get_active_hand())
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/external/temp = H.organs_by_name[H.hand?BP_L_HAND:BP_R_HAND]

			if(temp && !temp.is_usable())
				to_chat(H, SPAN_NOTICE("You try to move your [temp.name], but cannot!"))
				return

			to_chat(H, SPAN_NOTICE("You pick up the [src]."))
			pixel_x = 0
			pixel_y = 0
			forceMove(get_turf(H))
			H.put_in_hands(src)

	return

/obj/item/storage/box/fancy/tray/attack(mob/living/target_mob, mob/living/user, target_zone)
	if(..() && contents.len)
		spill(3, get_turf(target_mob))
		playsound(target_mob, /singleton/sound_category/tray_hit_sound, 50, 1)  //sound playin' again
		user.visible_message(SPAN_DANGER("[user] smashes \the [src] into [target_mob], causing it to spill its contents across the area!"))

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
		/obj/item/surgery/bone_gel,
		/obj/item/stack/nanopaste
		)

	starts_with = list(
		/obj/item/surgery/cautery = 1,
		/obj/item/surgery/circular_saw = 1,
		/obj/item/surgery/hemostat = 1,
		/obj/item/surgery/retractor = 1,
		/obj/item/surgery/scalpel = 1,
		/obj/item/surgery/bone_gel = 1
	)
