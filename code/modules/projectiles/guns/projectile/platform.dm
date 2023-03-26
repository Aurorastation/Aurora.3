// a weapons platform that has accessories that replace the entire assembly
/obj/item/gun/projectile/platform
	name = "modular weapons platform"
	desc = "Designed by the greatest minds in the SCC, this weapons platform has a quick release receiver and barrel system that allows the wielder to hot-swap between various calibers in the field."
	icon = 'icons/obj/guns/weapons_platform.dmi'
	icon_state = "weapons_platform"
	item_state = "weapons_platform"
	w_class = ITEMSIZE_HUGE
	is_wieldable = TRUE
	pin = /obj/item/device/firing_pin/away_site
	slot_flags = SLOT_BACK

	load_method = null
	max_shells = null
	caliber = null
	allowed_magazines = null
	magazine_type = null
	ammo_type = null

	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4, TECH_ENGINEERING = 4)

	accuracy = 1
	multi_aim = 1
	burst_delay = 2

	firemodes = list()

	var/obj/item/weapon_platform_kit/installed_kit

/obj/item/gun/projectile/platform/Destroy()
	if(installed_kit)
		QDEL_NULL(installed_kit)
	return ..()

/obj/item/gun/projectile/platform/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		if(installed_kit)
			to_chat(user, SPAN_NOTICE("It currently has a <b>[installed_kit.caliber_label]</b> caliber kit installed."))
		else
			to_chat(user, SPAN_WARNING("It doesn't have a kit installed."))

/obj/item/gun/projectile/platform/consume_next_projectile()
	if(installed_kit)
		return installed_kit.consume_next_projectile()
	return null

/obj/item/gun/projectile/platform/unique_action(mob/living/user)
	if(installed_kit)
		return installed_kit.unique_action(user)
	return null

/obj/item/gun/projectile/platform/attackby(obj/item/A, mob/user)
	if(A.isscrewdriver())
		if(!installed_kit)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have an installed kit!"))
			return
		if(chambered)
			to_chat(user, SPAN_WARNING("\The [src] still has a round chambered!"))
			return
		if(ammo_magazine)
			to_chat(user, SPAN_WARNING("\The [src] still has a magazine loaded!"))
			return

		user.visible_message("\The [user] starts removing \the [installed_kit] from \the [src]...", SPAN_NOTICE("You start removing \the [installed_kit] from \the [src]..."))
		playsound(loc, A.usesound, 50, TRUE)
		if(do_after(user, 30 SECONDS, TRUE, src) && installed_kit)
			user.visible_message("\The [user] removes \the [installed_kit] from \the [src].", SPAN_NOTICE("You remove \the [installed_kit] from \the [src]."))
			uninstall_kit(user)

		return

	if(istype(A, /obj/item/weapon_platform_kit))
		if(installed_kit)
			to_chat(user, SPAN_WARNING("\The [src] already has an installed kit!"))
			return
		if(chambered)
			to_chat(user, SPAN_WARNING("\The [src] still has a round chambered!"))
			return
		if(ammo_magazine)
			to_chat(user, SPAN_WARNING("\The [src] still has a magazine loaded!"))
			return

		user.visible_message("\The [user] starts installing \the [A] into \the [src]...", SPAN_NOTICE("You start installing \the [A] into \the [src]..."))
		playsound(loc, A.usesound, 50, TRUE)
		if(do_after(user, 30 SECONDS, TRUE, src) && !installed_kit)
			user.visible_message("\The [user] installs \the [A] into \the [src].", SPAN_NOTICE("You install \the [A] into \the [src]."))
			install_kit(user, A)

		return

	return ..()

/obj/item/gun/projectile/platform/proc/install_kit(var/mob/user, var/obj/item/weapon_platform_kit/kit)
	load_method = kit.load_method
	max_shells = kit.max_shells
	caliber = kit.caliber
	if(allowed_magazines)
		allowed_magazines = kit.allowed_magazines.Copy()
	user.drop_from_inventory(kit, src)
	installed_kit = kit

	QDEL_NULL_LIST(firemodes)
	firemodes = list()
	for(var/i in 1 to length(kit.firemodes))
		firemodes += new /datum/firemode(src, kit.firemodes[i])

	kit.parent_gun = src

/obj/item/gun/projectile/platform/proc/uninstall_kit(var/mob/user)
	load_method = null
	max_shells = null
	caliber = null
	allowed_magazines = null
	user.put_in_hands(installed_kit)
	installed_kit.parent_gun = null
	installed_kit = null

	firemodes = list()

/obj/item/weapon_platform_kit
	name = "weapons platform kit"
	desc = "A weapons platform kit."

	var/caliber_label

	icon = 'icons/obj/guns/weapon_platform.dmi'
	icon_state = "weapon_platform"
	item_state = "weapon_platform"
	contained_sprite = TRUE

	var/load_method = null
	var/max_shells = null
	var/caliber = null
	var/list/allowed_magazines = null

	var/list/firemodes = list()

	var/obj/item/gun/projectile/platform/parent_gun

/obj/item/weapon_platform_kit/Initialize()
	. = ..()
	name = "[name] ([caliber_label])"

/obj/item/weapon_platform_kit/proc/consume_next_projectile()
	if(parent_gun.jam_num)
		return FALSE
	//get the next casing
	if(parent_gun.loaded.len)
		parent_gun.chambered = parent_gun.loaded[1] //load next casing.
		if(parent_gun.handle_casings != HOLD_CASINGS)
			parent_gun.loaded -= parent_gun.chambered
	else if(parent_gun.ammo_magazine && parent_gun.ammo_magazine.stored_ammo.len)
		parent_gun.chambered = parent_gun.ammo_magazine.stored_ammo[1]
		if(parent_gun.handle_casings != HOLD_CASINGS)
			parent_gun.ammo_magazine.stored_ammo -= parent_gun.chambered

	if(parent_gun.chambered)
		return parent_gun.chambered.BB
	return null

/obj/item/weapon_platform_kit/proc/unique_action(mob/living/user)
	return

/obj/item/weapon_platform_kit/nine_mm
	load_method = MAGAZINE
	caliber_label = "9mm"
	caliber = "9mm"
	allowed_magazines = list(/obj/item/ammo_magazine/wp_nine_mm)

	firemodes = list(
		list(mode_name="semiauto",       can_autofire=0, burst=1),
		list(mode_name="3-round bursts", can_autofire=0, burst=3, burst_accuracy=list(1,0,0), dispersion=list(0, 10, 15)),
		list(mode_name="short bursts",   can_autofire=0, burst=5, burst_accuracy=list(1,0,,-1,-1), dispersion=list(5, 10, 15, 20)),
		list(mode_name="full auto",      can_autofire=1, burst=1, fire_delay=5, fire_delay_wielded=1, one_hand_fa_penalty=12, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(5, 10, 15, 20, 25))
	)

/obj/item/ammo_magazine/wp_nine_mm
	name = "weapons platform magazine (9mm)"
	icon_state = "9x19p"
	origin_tech = list(TECH_COMBAT = 3)
	mag_type = MAGAZINE
	matter = list(DEFAULT_WALL_MATERIAL = 600)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 30
	multiple_sprites = TRUE

/obj/item/weapon_platform_kit/five_five_six
	load_method = MAGAZINE
	caliber_label = "5.56"
	caliber = "a556"
	allowed_magazines = list(/obj/item/ammo_magazine/wp_five_five_six)

	firemodes = list(mode_name="semiauto", burst=1, fire_delay=12, fire_delay_wielded=12)

/obj/item/ammo_magazine/wp_five_five_six
	name = "weapons platform magazine (5.56mm)"
	icon_state = "5.56"
	origin_tech = list(TECH_COMBAT = 3)
	mag_type = MAGAZINE
	caliber = "a556"
	insert_sound = /singleton/sound_category/rifle_slide_reload
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	ammo_type = /obj/item/ammo_casing/a556
	max_ammo = 40
	multiple_sprites = TRUE

/obj/item/weapon_platform_kit/shotgun
	load_method = SINGLE_CASING|SPEEDLOADER
	max_shells = 6
	caliber_label = "shotgun"
	caliber = "shotgun"

	var/recentpump = 0 // to prevent spammage
	var/rack_sound = /singleton/sound_category/shotgun_pump
	var/rack_verb = "pump"

/obj/item/weapon_platform_kit/shotgun/consume_next_projectile()
	if(parent_gun.chambered)
		return parent_gun.chambered.BB
	return null

/obj/item/weapon_platform_kit/shotgun/unique_action(mob/living/user)
	if(parent_gun.jam_num)
		to_chat(user, SPAN_WARNING("\The [parent_gun] is jammed!"))
		return
	if(world.time >= recentpump + 10)
		pump(user)
		recentpump = world.time

/obj/item/weapon_platform_kit/shotgun/proc/pump(mob/M)
	if(!parent_gun.wielded)
		if(!do_after(M, 20, TRUE)) // have to stand still for 2 seconds instead of doing it instantly. bad idea during a shootout
			return

	playsound(M, rack_sound, 60, FALSE)
	to_chat(M, SPAN_NOTICE("You [rack_verb] \the [parent_gun]!"))

	if(parent_gun.chambered)//We have a shell in the chamber
		parent_gun.chambered.forceMove(get_turf(src)) //Eject casing
		playsound(parent_gun.loc, parent_gun.chambered.drop_sound, DROP_SOUND_VOLUME, FALSE, required_asfx_toggles = ASFX_DROPSOUND)
		parent_gun.chambered = null

	handle_pump_loading()

	parent_gun.update_maptext()
	parent_gun.update_icon()

/obj/item/weapon_platform_kit/shotgun/proc/handle_pump_loading()
	if(length(parent_gun.loaded))
		var/obj/item/ammo_casing/AC = parent_gun.loaded[1] //load next casing.
		parent_gun.loaded -= AC //Remove casing from loaded list.
		parent_gun.chambered = AC
