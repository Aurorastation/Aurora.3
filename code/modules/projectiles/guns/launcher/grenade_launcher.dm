/obj/item/gun/launcher/grenade
	name = "grenade launcher"
	desc = "A bulky pump-action grenade launcher. Holds up to 6 grenades in a revolving magazine."
	icon = 'icons/obj/guns/grenade_launcher.dmi'
	icon_state = "grenadelauncher"
	item_state = "grenadelauncher"
	w_class = WEIGHT_CLASS_BULKY
	force = 15

	fire_sound = 'sound/weapons/grenadelaunch.ogg'
	fire_sound_text = "a metallic thunk"
	recoil = 0
	throw_distance = 7
	release_force = 5

	needspin = FALSE

	var/blacklisted_grenades = list(
		/obj/item/grenade/flashbang/clusterbang,
		/obj/item/grenade/frag
		)

	var/obj/item/grenade/chambered
	var/list/grenades = new/list()
	var/max_grenades = 5 //holds this + one in the chamber
	matter = list(MATERIAL_STEEL = 2000)


/obj/item/gun/launcher/grenade/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(is_adjacent)
		. += SPAN_NOTICE("It has [get_ammo()] grenade\s remaining.")
		if(chambered)
			. += SPAN_NOTICE("\A [chambered] is chambered.")

//revolves the magazine, allowing players to choose between multiple grenade types
/obj/item/gun/launcher/grenade/proc/pump(mob/M as mob)
	playsound(M, 'sound/weapons/reloads/shotgun_pump.ogg', 60, 1)

	var/obj/item/grenade/next
	if(grenades.len)
		next = grenades[1] //get this first, so that the chambered grenade can still be removed if the grenades list is empty
	if(chambered)
		grenades += chambered //rotate the revolving magazine
		chambered = null
	if(next)
		grenades -= next //Remove grenade from loaded list.
		chambered = next
		to_chat(M, SPAN_WARNING("You pump [src], loading \a [next] into the chamber."))
	else
		to_chat(M, SPAN_WARNING("You pump [src], but the magazine is empty."))
	update_icon()

/obj/item/gun/launcher/grenade/proc/load(obj/item/grenade/G, mob/user)
	if(!can_load_grenade_type(G, user))
		return
	if(grenades.len >= max_grenades)
		to_chat(user, SPAN_WARNING("[src] is full."))
		return
	user.remove_from_mob(G)
	G.forceMove(src)
	grenades.Insert(1, G) //add to the head of the list, so that it is loaded on the next pump
	user.visible_message("[user] inserts \a [G] into [src].", SPAN_NOTICE("You insert \a [G] into [src]."))
	update_maptext()

/obj/item/gun/launcher/grenade/proc/unload(mob/user)
	if(grenades.len)
		var/obj/item/grenade/G = grenades[grenades.len]
		grenades.len--
		user.put_in_hands(G)
		user.visible_message("[user] removes \a [G] from [src].", SPAN_NOTICE("You remove \a [G] from [src]."))
	else
		to_chat(user, SPAN_WARNING("[src] is empty."))
	update_maptext()

/obj/item/gun/launcher/grenade/proc/can_load_grenade_type(obj/item/grenade/G, mob/user)
	if(is_type_in_list(G, blacklisted_grenades))
		to_chat(user, SPAN_WARNING("\The [G] doesn't seem to fit in \the [src]!"))
		return FALSE
	return TRUE

/obj/item/gun/launcher/grenade/unique_action(mob/user)
	pump(user)

/obj/item/gun/launcher/grenade/attackby(obj/item/attacking_item, mob/user)
	if((istype(attacking_item, /obj/item/grenade)))
		load(attacking_item, user)
	else
		..()

/obj/item/gun/launcher/grenade/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		unload(user)
	else
		..()

/obj/item/gun/launcher/grenade/consume_next_projectile()
	if(chambered)
		chambered.det_time = 10
		chambered.activate(null)
	return chambered

/obj/item/gun/launcher/grenade/process_projectile(obj/item/projectile, mob/user, atom/target, target_zone, params, pointblank, reflex)
	var/obj/item/grenade/grenade = projectile
	if(grenade.special_launcher_handling)
		return grenade.process_launcher_projectile(src, user, target, target_zone, params)
	return ..()

/obj/item/gun/launcher/grenade/handle_post_fire(mob/user)
	if(chambered.notify_admins_on_launcher_fire)
		message_admins("[key_name_admin(user)] fired a grenade ([chambered.name]) from a grenade launcher ([src.name]).")
	log_game("[key_name_admin(user)] used a grenade ([chambered.name]).")
	if(chambered.special_launcher_handling)
		chambered.handle_launcher_post_fire(src)
	chambered = null
	update_maptext()

/obj/item/gun/launcher/grenade/get_ammo()
	return grenades.len + (chambered? 1 : 0)

/**
 * A less-lethal round which the grenade launcher converts into a conventional
 * beanbag projectile when fired. The inert item cannot be activated by hand
 * or produce the beanbag effect when thrown by other means.
 */
/obj/projectile/bullet/shotgun/beanbag/grenade_launcher
	icon_state = "beanbag"
	damage = 20
	agony = 70

/obj/item/grenade/beanbag
	name = "beanbag round"
	desc = "A less-than-lethal round intended to be fired by a standard grenade launcher."
	icon_state = "beanbag"
	item_state = "grenade"
	throwforce = 0
	special_launcher_handling = TRUE
	notify_admins_on_launcher_fire = FALSE

/obj/item/grenade/beanbag/attack_self(mob/user)
	to_chat(user, SPAN_WARNING("\The [src] has no hand-operated firing mechanism. It must be loaded into a grenade launcher."))

/obj/item/grenade/beanbag/activate(atom/user)
	return

/obj/item/grenade/beanbag/process_launcher_projectile(obj/item/gun/launcher/grenade/launcher, mob/user, atom/target, target_zone, params)
	var/obj/projectile/bullet/shotgun/beanbag/grenade_launcher/beanbag = new(get_turf(user))
	if(!beanbag.preparePixelProjectile(target, launcher, params))
		qdel(beanbag)
		return FALSE
	beanbag.firer = user
	beanbag.fired_from = launcher
	beanbag.def_zone = target_zone
	return !beanbag.fire()

/obj/item/grenade/beanbag/handle_launcher_post_fire(obj/item/gun/launcher/grenade/launcher)
	launcher.play_fire_sound()
	qdel(src)

//Underslung grenade launcher to be used with the Z8
/obj/item/gun/launcher/grenade/underslung
	name = "underslung grenade launcher"
	desc = "Not much more than a tube and a firing mechanism, this grenade launcher is designed to be fitted to a rifle."
	w_class = WEIGHT_CLASS_NORMAL
	force = 11
	max_grenades = 0

//load and unload directly into chambered
/obj/item/gun/launcher/grenade/underslung/load(obj/item/grenade/G, mob/user)
	if(chambered)
		to_chat(user, SPAN_WARNING("[src] is already loaded."))
		return
	user.remove_from_mob(G)
	G.forceMove(src)
	chambered = G
	user.visible_message("[user] load \a [G] into [src].", SPAN_NOTICE("You load \a [G] into [src]."))

/obj/item/gun/launcher/grenade/underslung/unload(mob/user)
	if(chambered)
		user.put_in_hands(chambered)
		user.visible_message("[user] removes \a [chambered] from [src].", SPAN_NOTICE("You remove \a [chambered] from [src]."))
		chambered = null
	else
		to_chat(user, SPAN_WARNING("[src] is empty."))
