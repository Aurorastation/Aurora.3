/obj/item/gun/projectile/revolver
	name = "revolver"
	desc = "The revised Mark II Zavodskoi Interstellar revolver, utilizing a robust firing mechanism to deliver deadly rounds downrange. This is a monster of a hand cannon, with a beautiful cedar grip and a transparent plastic cover(so as to not splinter your hands while firing)."
	icon = 'icons/obj/guns/revolver.dmi'
	icon_state = "revolver"
	item_state = "revolver"
	accuracy = 1
	offhand_accuracy = 1
	caliber = "357"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	handle_casings = CYCLE_CASINGS
	max_shells = 8
	ammo_type = /obj/item/ammo_casing/a357
	magazine_type = /obj/item/ammo_magazine/a357
	fire_sound = 'sound/weapons/gunshot/gunshot_revolver.ogg'
	empty_sound = /singleton/sound_category/out_of_ammo_revolver
	fire_delay = ROF_RIFLE
	var/chamber_offset = 0 //how many empty chambers in the cylinder until you hit a round

/obj/item/gun/projectile/revolver/verb/spin_cylinder()
	set name = "Spin Cylinder"
	set desc = "Fun when you're bored out of your skull."
	set category = "Object.Held"
	set src in usr

	chamber_offset = 0
	usr.visible_message(SPAN_WARNING("\The [usr] spins the cylinder of \the [src]!"),
						SPAN_WARNING("You spin the cylinder of \the [src]!"),
						SPAN_NOTICE("You hear something metallic spin and click."))

	playsound(src.loc, 'sound/weapons/revolver_spin.ogg', 100, 1)
	loaded = shuffle(loaded)
	if(rand(1,max_shells) > loaded.len)
		chamber_offset = rand(0,max_shells - loaded.len)

/obj/item/gun/projectile/revolver/consume_next_projectile()
	if(chamber_offset)
		chamber_offset--
		return
	return ..()

/obj/item/gun/projectile/revolver/load_ammo(var/obj/item/A, mob/user)
	chamber_offset = 0
	return ..()

/obj/item/gun/projectile/revolver/mateba
	name = "automatic revolver"
	desc = "The Hammerhead .454 autorevolver, a very rare weapon typical of special ops teams and mercenary teams. It packs quite the punch."
	icon = 'icons/obj/guns/autorevolver.dmi'
	icon_state = "autorevolver"
	item_state = "autorevolver"
	max_shells = 7
	accuracy = 2
	caliber = "454"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_mateba.ogg'
	ammo_type = /obj/item/ammo_casing/a454
	magazine_type = /obj/item/ammo_magazine/a454

/obj/item/gun/projectile/revolver/mateba/captain
	name = "\improper SCC command autorevolver"
	desc = "A ludicrously powerful .454 autorevolver with equally ludicrous recoil which is issued by the SCC to the administrators of critical facilities and vessels. While revolvers may be a thing of the past, the stopping power displayed by this weapon is second to none."
	desc_extended = "A Zavodskoi Interstellar design from the mid 2450s intended for export to the Eridani Corporate Federation and the Republic of Biesel, the Protektor \
	revolver was never designed with practicality in mind. The .454 rounds fired from this weapon are liable to snap the wrist of an unprepared shooter and \
	any following shots will be difficult to place onto a human-sized target due to the recoil, let alone a skrell. But nobody buys a Protektor for the purpose of \
	practicality: they buy it due to having too much money and wanting a revolver large enough for their ego."
	icon = 'icons/obj/guns/captain_revolver.dmi'
	icon_state = "captain_revolver"
	item_state = "captain_revolver"
	is_wieldable = TRUE
	handle_casings = EJECT_CASINGS
	accuracy = -2
	accuracy_wielded = 1
	fire_delay = ROF_UNWIELDY
	fire_delay_wielded = ROF_SUPERHEAVY
	force = 15
	recoil = 10
	recoil_wielded = 5

/obj/item/gun/projectile/revolver/mateba/captain/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "In order to accurately fire this revolver, it must be wielded with both hands. Additionally, if you fire this revolver unwielded and you are not a G2 or Unathi, you will drop it."

/obj/item/gun/projectile/revolver/mateba/captain/handle_post_fire(mob/user)
	..()
	if(wielded)
		return
	else
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.mob_size <10)
				H.visible_message(SPAN_WARNING("\The [src] flies out of \the [H]'s' hand!"), SPAN_WARNING("\The [src] flies out of your hand!"))
				H.drop_item(src)
				src.throw_at(get_edge_target_turf(src, REVERSE_DIR(H.dir)), 2, 2)

/obj/item/gun/projectile/revolver/detective
	name = "antique revolver"
	desc = "An old, obsolete revolver. It has no identifying marks, and is chambered in an equally antiquated caliber."
	icon = 'icons/obj/guns/detective.dmi'
	icon_state = "detective"
	item_state = "detective"
	max_shells = 6
	accuracy = 1
	caliber = "38"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	ammo_type = /obj/item/ammo_casing/c38
	magazine_type = /obj/item/ammo_magazine/c38
	fire_delay = ROF_PISTOL

/obj/item/gun/projectile/revolver/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object.Held"
	set desc = "Click to rename your gun. If you're the detective."
	set src in usr

	var/mob/M = usr
	if(!M.mind)	return 0
	if(!M.mind.assigned_role == "Investigator")
		to_chat(M, SPAN_NOTICE("You don't feel cool enough to name this gun, chump."))
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		to_chat(M, "You name the gun [input]. Say hello to your new friend.")
		return 1

/obj/item/gun/projectile/revolver/derringer
	name = "derringer"
	desc = "A small pocket pistol, easily concealed."
	icon = 'icons/obj/guns/derringer.dmi'
	icon_state = "derringer"
	item_state = "derringer"
	accuracy = -1
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 3)
	handle_casings = CYCLE_CASINGS
	load_method = SINGLE_CASING
	max_shells = 2
	ammo_type = /obj/item/ammo_casing/a357
	magazine_type = null
	fire_delay = ROF_INTERMEDIATE

/obj/item/gun/projectile/revolver/capgun
	name = "cap gun"
	desc = "Looks almost like the real thing! Ages 8 and up."
	icon = 'icons/obj/guns/capgun.dmi'
	icon_state = "capgun"
	item_state = "capgun"
	caliber = "caps"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	handle_casings = CYCLE_CASINGS
	max_shells = 7
	ammo_type = /obj/item/ammo_casing/cap
	needspin = FALSE

/obj/item/gun/projectile/revolver/capgun/attackby(obj/item/attacking_item, mob/user)
	if(!attacking_item.iswirecutter() || icon_state == "revolver")
		return ..()
	to_chat(user, SPAN_NOTICE("You snip off the toy markings off the [src]."))
	icon = 'icons/obj/guns/revolver.dmi'
	name = "revolver"
	icon_state = "revolver"
	item_state = "revolvers"
	desc += " Someone snipped off the barrel's toy mark. How dastardly."
	return 1

/obj/item/gun/projectile/revolver/lemat
	name = "grapeshot revolver"
	desc = "A six shot revolver, with a secondary firing barrel for loading shotgun shells."
	icon = 'icons/obj/guns/lemat.dmi'
	icon_state = "lemat"
	item_state = "lemat"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	handle_casings = CYCLE_CASINGS
	max_shells = 6
	caliber = "38"
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	ammo_type = /obj/item/ammo_casing/c38
	magazine_type = /obj/item/ammo_magazine/c38
	var/secondary_max_shells = 1
	var/secondary_caliber = "shotgun"
	var/secondary_ammo_type = /obj/item/ammo_casing/shotgun/pellet
	var/flipped_firing = 0
	var/list/secondary_loaded = list()
	var/list/tertiary_loaded = list()
	fire_delay = ROF_INTERMEDIATE

/obj/item/gun/projectile/revolver/lemat/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "This is a unique ballistic weapon. It fires .38 ammunition, but may also load shotgun shells into a secondary barrel."
	. += "By using the Unique-Action macro, you can switch from one barrel to the other."

/obj/item/gun/projectile/revolver/lemat/Initialize()
	. = ..()
	for(var/i in 1 to secondary_max_shells)
		secondary_loaded += new secondary_ammo_type(src)

/obj/item/gun/projectile/revolver/lemat/Destroy()
	QDEL_LIST(secondary_loaded)
	QDEL_LIST(tertiary_loaded)

	. = ..()

/obj/item/gun/projectile/revolver/lemat/unique_action(mob/living/user)
	to_chat(user, SPAN_NOTICE("You change the firing mode on \the [src]."))
	if(!flipped_firing)
		if(max_shells && secondary_max_shells)
			max_shells = secondary_max_shells

		if(caliber && secondary_caliber)
			caliber = secondary_caliber
			fire_sound = 'sound/weapons/gunshot/gunshot_shotgun2.ogg'

		if(ammo_type && secondary_ammo_type)
			ammo_type = secondary_ammo_type

		if(secondary_loaded)
			tertiary_loaded = loaded.Copy()
			loaded = secondary_loaded

		flipped_firing = 1

	else
		if(max_shells)
			max_shells = initial(max_shells)

		if(caliber && secondary_caliber)
			caliber = initial(caliber)
			fire_sound = initial(fire_sound)

		if(ammo_type && secondary_ammo_type)
			ammo_type = initial(ammo_type)

		if(tertiary_loaded)
			secondary_loaded = loaded.Copy()
			loaded = tertiary_loaded

		flipped_firing = 0

/obj/item/gun/projectile/revolver/lemat/spin_cylinder()
	set name = "Spin Cylinder"
	set desc = "Fun when you're bored out of your skull."
	set category = "Object.Held"
	set src in usr

	chamber_offset = 0
	visible_message(SPAN_WARNING("\The [usr] spins the cylinder of \the [src]!"), \
	SPAN_NOTICE("You hear something metallic spin and click."))
	playsound(src.loc, 'sound/weapons/revolver_spin.ogg', 100, 1)
	if(!flipped_firing)
		loaded = shuffle(loaded)
		if(rand(1,max_shells) > loaded.len)
			chamber_offset = rand(0,max_shells - loaded.len)

/obj/item/gun/projectile/revolver/lemat/feedback_hints(mob/user, distance, is_adjacent, infix, suffix)
	. = list()
	. += ..()
	if(secondary_loaded)
		var/to_print
		for(var/round in secondary_loaded)
			to_print += round
		. += "\The [src] has a secondary barrel loaded with \a [to_print]."
	else
		. += "\The [src] has a secondary barrel that is empty."

/obj/item/gun/projectile/revolver/adhomian
	name = "adhomian service revolver"
	desc = "The Royal Firearms Service Revolver is a simple and reliable design, favored by the nobility of the New Kingdom of Adhomai."
	icon = 'icons/obj/guns/adhomian_revolver.dmi'
	icon_state = "adhomian_revolver"
	item_state = "adhomian_revolver"
	caliber = "38"
	max_shells = 7
	load_method = SINGLE_CASING
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	ammo_type = /obj/item/ammo_casing/c38
	magazine_type = null
	fire_delay = ROF_PISTOL

	desc_extended = "A simple and reliable double action revolver, favored by the nobility, officers and law enforcement. The design is known for having an outdated reloading \
	mechanism, with the need to manually eject each of the used cartridges, and reload one cartridge at a time through a loading gate. However, their cheap manufacturing cost has \
	allowed countless copies to flood the Kingdom's markets."

/obj/item/gun/projectile/revolver/knife
	name = "knife-revolver"
	desc = "An Adhomian revolver with a blade attached to its barrel."
	icon = 'icons/obj/guns/knifegun.dmi'
	icon_state = "knifegun"
	item_state = "knifegun"
	max_shells = 6
	caliber = "38"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	ammo_type = /obj/item/ammo_casing/c38
	magazine_type = /obj/item/ammo_magazine/c38
	force = 22
	sharp = TRUE
	edge = TRUE
	fire_delay = ROF_PISTOL

/obj/item/gun/projectile/revolver/knife/handle_shield(mob/user, var/on_back, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(default_parry_check(user, attacker, damage_source) && prob(20))
		user.visible_message(SPAN_DANGER("\The [user] parries [attack_text] with \the [src]!"))
		playsound(user.loc, "punchmiss", 50, 1)
		return BULLET_ACT_BLOCK
	return BULLET_ACT_HIT

/obj/item/gun/projectile/revolver/konyang/pirate
	name = "reclaimed revolver"
	desc = "A revolver, made out of cheap scrap metal. Often used by Konyang's pirates."
	desc_extended = "A six-shot revolver, crudely hacked together out of different kinds of scrap metal and wood. Made working by the ingenuity Konyang's pirates often need to show. Chambered in .38 ammo."
	icon = 'icons/obj/guns/konyang_weapons.dmi'
	icon_state = "38_revolver"
	item_state = "38_revolver"
	caliber = "38"
	ammo_type = /obj/item/ammo_casing/c38
	magazine_type = /obj/item/ammo_magazine/c38
	max_shells = 6

/obj/item/gun/projectile/revolver/konyang/pirate/update_icon()
	..()
	if(loaded.len)
		icon_state = "38_revolver"
	else
		icon_state = "38_revolver-e"

/obj/item/gun/projectile/revolver/konyang/police
	name = "police service revolver"
	desc = "A compact and reliable .45 caliber revolver. This one has Konyang National Police markings as well as a lanyard attached to it."
	desc_extended = "The Nam-Kawada model .45 caliber revolver, named after its two inventors, is an adaptation of an old Zavodskoi design designed to be easily made from colony ship autolathes. \
	The original design was first introduced in 2307 due to a growing need to arm the nascent Konyang National Police (then known as the Suwon Colonial Constabulary) in the face of both wildlife and the occasional criminal activity.\
	The lack of a need for an upgrade, as well as institutional attachment to the design, has led to its continued use for almost two centuries."
	icon = 'icons/obj/guns/konyang_weapons.dmi'
	icon_state = "police_gun"
	item_state = "police_gun"
	w_class = WEIGHT_CLASS_NORMAL
	caliber = ".45"
	ammo_type = /obj/item/ammo_casing/c45/revolver
	magazine_type = /obj/item/ammo_magazine/c45/revolver
	max_shells = 6
