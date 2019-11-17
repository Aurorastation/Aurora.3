/obj/item/gun/projectile/revolver
	name = "revolver"
	desc = "The revised Mark II Necropolis Industries revolver, chambering .357 rounds and utilizing a robust firing mechanism to deliver deadly rounds downrange. This is a monster of a hand cannon with a beautiful cedar grip and a transparent plastic cover so as to not splinter your hands while firing."
	icon_state = "revolver"
	item_state = "revolver"
	accuracy = 1
	caliber = "357"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	handle_casings = CYCLE_CASINGS
	max_shells = 8
	ammo_type = /obj/item/ammo_casing/a357
	fire_sound = 'sound/weapons/gunshot/gunshot_revolver.ogg'
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
	name = "mateba"
	desc = "The Mateba .454 Autorevolver, a very rare weapon typical of special ops teams and mercenary teams. It packs quite the punch."
	icon_state = "mateba"
	max_shells = 7
	accuracy = 2
	caliber = "454"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_mateba.ogg'
	ammo_type = /obj/item/ammo_casing/a454

/obj/item/gun/projectile/revolver/detective
	name = "revolver"
	desc = "A cheap Martian knock-off of a Smith & Wesson Model 10. Uses .38-Special rounds."
	icon_state = "detective"
	max_shells = 6
	accuracy = 1
	caliber = "38"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	ammo_type = /obj/item/ammo_casing/c38

/obj/item/gun/projectile/revolver/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
	set desc = "Click to rename your gun. If you're the detective."

	var/mob/M = usr
	if(!M.mind)	return 0
	if(!M.mind.assigned_role == "Detective")
		to_chat(M, "<span class='notice'>You don't feel cool enough to name this gun, chump.</span>")
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		to_chat(M, "You name the gun [input]. Say hello to your new friend.")
		return 1

// Blade Runner pistol.
/obj/item/gun/projectile/revolver/deckard
	name = "\improper Deckard .44"
	desc = "A custom-built revolver, based off the semi-popular Detective Special model."
	max_shells = 6
	accuracy = 2
	icon_state = "deckard-empty"
	caliber = "38"
	ammo_type = /obj/item/ammo_casing/c38
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'

/obj/item/gun/projectile/revolver/deckard/update_icon()
	..()
	if(loaded.len)
		icon_state = "deckard-loaded"
	else
		icon_state = "deckard-empty"

/obj/item/gun/projectile/revolver/deckard/load_ammo(var/obj/item/A, mob/user)
	if(istype(A, /obj/item/ammo_magazine))
		flick("deckard-reload",src)
	..()

/obj/item/gun/projectile/revolver/deckard/emp
	ammo_type = /obj/item/ammo_casing/c38/emp

/obj/item/gun/projectile/revolver/derringer
	name = "derringer"
	desc = "A small pocket pistol, easily concealed. Uses .357 rounds."
	icon_state = "derringer"
	item_state = "concealed"
	accuracy = -1
	w_class = 2
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 3)
	handle_casings = CYCLE_CASINGS
	load_method = SINGLE_CASING
	max_shells = 2
	ammo_type = /obj/item/ammo_casing/a357

/obj/item/gun/projectile/revolver/capgun
	name = "cap gun"
	desc = "Looks almost like the real thing! Ages 8 and up."
	icon_state = "capgun"
	item_state = "revolver"
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
	name = "revolver"
	icon_state = "revolver"
	desc += " Someone snipped off the barrel's toy mark. How dastardly."
	return 1

/obj/item/gun/projectile/revolver/lemat
	name = "grapeshot revolver"
	desc = "A six shot revolver with a secondary firing barrel loading shotgun shells. Uses .38-Special and 12g rounds depending on the barrel."
	icon_state = "lemat"
	item_state = "lemat"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	handle_casings = CYCLE_CASINGS
	max_shells = 6
	caliber = "38"
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	ammo_type = /obj/item/ammo_casing/c38
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

/obj/item/gun/projectile/revolver/lemat/verb/swap_firingmode()
	set name = "Swap Firing Mode"
	set category = "Object"
	set desc = "Click to swap from one method of firing to another."

	var/mob/living/carbon/human/M = usr
	if(!M.mind)
		return 0

	to_chat(M, "<span class='notice'>You change the firing mode on \the [src].</span>")
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
	icon_state = "adhomian_revolver"
	caliber = "38"
	max_shells = 7
	load_method = SINGLE_CASING
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	ammo_type = /obj/item/ammo_casing/c38
