/obj/item/gun/projectile/revolver
	name = "revolver"
	desc = "The revised Mark II Zavodskoi Interstellar revolver, chambering .357 rounds and utilizing a robust firing mechanism to deliver deadly rounds downrange. This is a monster of a hand cannon with a beautiful cedar grip and a transparent plastic cover so as to not splinter your hands while firing."
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
	empty_sound = /decl/sound_category/out_of_ammo_revolver
	var/chamber_offset = 0 //how many empty chambers in the cylinder until you hit a round

/obj/item/gun/projectile/revolver/verb/spin_cylinder()
	set name = "Spin cylinder"
	set desc = "Fun when you're bored out of your skull."
	set category = "Object"

	chamber_offset = 0
	usr.visible_message("<span class='warning'>\The [usr] spins the cylinder of \the [src]!</span>", "<span class='warning'>You spin the cylinder of \the [src]!</span>", "<span class='notice'>You hear something metallic spin and click.</span>")
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

/obj/item/gun/projectile/revolver/detective
	name = "antique revolver"
	desc = "An old, obsolete revolver. It has no identifying marks. Chambered in the antiquated .38 caliber. Maybe the Tajara made it?"
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

/obj/item/gun/projectile/revolver/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
	set desc = "Click to rename your gun. If you're the detective."

	var/mob/M = usr
	if(!M.mind)	return 0
	if(!M.mind.assigned_role == "Investigator")
		to_chat(M, "<span class='notice'>You don't feel cool enough to name this gun, chump.</span>")
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		to_chat(M, "You name the gun [input]. Say hello to your new friend.")
		return 1

/obj/item/gun/projectile/revolver/derringer
	name = "derringer"
	desc = "A small pocket pistol, easily concealed. Uses .357 rounds."
	icon = 'icons/obj/guns/derringer.dmi'
	icon_state = "derringer"
	item_state = "derringer"
	accuracy = -1
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 3)
	handle_casings = CYCLE_CASINGS
	load_method = SINGLE_CASING
	max_shells = 2
	ammo_type = /obj/item/ammo_casing/a357
	magazine_type = null

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

/obj/item/gun/projectile/revolver/capgun/attackby(obj/item/W, mob/user)
	if(!W.iswirecutter() || icon_state == "revolver")
		return ..()
	to_chat(user, "<span class='notice'>You snip off the toy markings off the [src].</span>")
	icon = 'icons/obj/guns/revolver.dmi'
	name = "revolver"
	icon_state = "revolver"
	item_state = "revolvers"
	desc += " Someone snipped off the barrel's toy mark. How dastardly."
	return 1

/obj/item/gun/projectile/revolver/lemat
	name = "grapeshot revolver"
	desc = "A six shot revolver with a secondary firing barrel loading shotgun shells. Uses .38-Special and 12g rounds depending on the barrel."
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


/obj/item/gun/projectile/revolver/lemat/Initialize()
	. = ..()
	for(var/i in 1 to secondary_max_shells)
		secondary_loaded += new secondary_ammo_type(src)

/obj/item/gun/projectile/revolver/lemat/unique_action(mob/living/user)
	to_chat(user, "<span class='notice'>You change the firing mode on \the [src].</span>")
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
	set name = "Spin cylinder"
	set desc = "Fun when you're bored out of your skull."
	set category = "Object"

	chamber_offset = 0
	visible_message("<span class='warning'>\The [usr] spins the cylinder of \the [src]!</span>", \
	"<span class='notice'>You hear something metallic spin and click.</span>")
	playsound(src.loc, 'sound/weapons/revolver_spin.ogg', 100, 1)
	if(!flipped_firing)
		loaded = shuffle(loaded)
		if(rand(1,max_shells) > loaded.len)
			chamber_offset = rand(0,max_shells - loaded.len)

/obj/item/gun/projectile/revolver/lemat/examine(mob/user)
	..()
	if(secondary_loaded)
		var/to_print
		for(var/round in secondary_loaded)
			to_print += round
		to_chat(user, "\The [src] has a secondary barrel loaded with \a [to_print]")
	else
		to_chat(user, "\The [src] has a secondary barrel that is empty.")

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

	desc_lore = "A simple and reliable double action revolver, favored by the nobility, officers and law enforcement. The design is known for having an outdated reloading \
	mechanism, with the need to manually eject each of the used cartridges, and reload one cartridge at a time through a loading gate. However, their cheap manufacturing cost has \
	allowed countless copies to flood the Kingdom's markets."

/obj/item/gun/projectile/revolver/knife
	name = "knife-revolver"
	desc = "An adhomian revolver with a blade attached to its barrel."
	icon = 'icons/obj/guns/knifegun.dmi'
	icon_state = "knifegun"
	item_state = "knifegun"
	max_shells = 6
	caliber = "38"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	ammo_type = /obj/item/ammo_casing/c38
	magazine_type = /obj/item/ammo_magazine/c38
	force = 15
	sharp = TRUE
	edge = TRUE

/obj/item/gun/projectile/revolver/knife/handle_shield(mob/user, var/on_back, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(default_parry_check(user, attacker, damage_source) && prob(20))
		user.visible_message(SPAN_DANGER("\The [user] parries [attack_text] with \the [src]!"))
		playsound(user.loc, "punchmiss", 50, 1)
		return PROJECTILE_STOPPED
	return FALSE
