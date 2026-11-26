ABSTRACT_TYPE(/obj/item/gun/projectile/heavy_machinegun)
	name = "heavy machine gun"
	desc_mechanics = "Secure it to a weapon mount with a wrench and man it from directly behind with empty hands or compatible belt boxes. You can reload while manning it: use the feed-cover button, Eject to remove the old box, and click the mount with a new box to insert it. Close the cover and use Rack to charge it. Ctrl-click also operates the cover; Ctrl-Shift-click ejects ammunition. Put carried boxes down before firing. Hold left-click to fire within its forward arc. Click the mount with an empty hand or resist to release it. A second person can click it from either side with both hands free to feed the belt, reducing firing delay by 25%. Unsecure it while unmanned before removing it."
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_HUGE
	needspin = FALSE
	slot_flags = 0
	load_method = MAGAZINE
	can_autofire = TRUE
	VAR_PRIVATE/cover_open = FALSE
	VAR_PRIVATE/reload_busy = FALSE

/obj/item/gun/projectile/heavy_machinegun/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_GUN_FIRE_CHECK, PROC_REF(check_receiver))
	AddComponent(/datum/component/weapon_feed_assist)

/obj/item/gun/projectile/heavy_machinegun/get_reload_action_name()
	return "[cover_open ? "Close" : "Open"] Feed Cover"

/obj/item/gun/projectile/heavy_machinegun/reload_action(mob/user)
	if(!reload_step(user, cover_open ? "closing cover..." : "opening cover..."))
		return FALSE
	cover_open = !cover_open
	balloon_alert_to_viewers(cover_open ? "cover opened" : "cover closed")
	playsound(src, SFX_RELOAD_RIFLE_SLIDE, 40, TRUE)
	update_icon()
	return TRUE

/obj/item/gun/projectile/heavy_machinegun/proc/reload_step(mob/user, feedback)
	PRIVATE_PROC(TRUE)
	var/atom/interaction_target = isobj(loc) && !isitem(loc) ? loc : src
	if(reload_busy || chamber_firing || use_check_and_message(user, USE_ALLOW_NON_ADJACENT) || interaction_target.use_check_and_message(user))
		return FALSE
	var/atom/original_location = loc
	reload_busy = TRUE
	SEND_SIGNAL(src, COMSIG_GUN_RELOAD_STARTED, user)
	if(QDELETED(src))
		return FALSE
	if(QDELETED(user))
		reload_busy = FALSE
		return FALSE
	balloon_alert(user, feedback)
	var/completed = do_after(user, 2 SECONDS, src, DO_REPAIR_CONSTRUCT | DO_USER_UNIQUE_ACT | DO_PLACE_PROGRESSBAR_ON_USER)
	if(QDELETED(src))
		return FALSE
	reload_busy = FALSE
	return completed && !QDELETED(user) && loc == original_location && !use_check(user, USE_ALLOW_NON_ADJACENT) && !interaction_target.use_check(user)

/obj/item/gun/projectile/heavy_machinegun/load_ammo(obj/item/ammunition, mob/user)
	if(!cover_open)
		balloon_alert(user, "open the feed cover!")
		return
	if(!istype(ammunition, /obj/item/ammo_magazine/heavy_machinegun) || ammo_magazine)
		return ..()
	if(user.get_active_hand() != ammunition || !user.canUnEquip(ammunition))
		return
	if(!reload_step(user, "inserting belt box..."))
		return
	if(!cover_open || ammo_magazine || QDELETED(ammunition) || user.get_active_hand() != ammunition || !user.canUnEquip(ammunition))
		return
	..()

/obj/item/gun/projectile/heavy_machinegun/unload_ammo(mob/user, allow_dump = TRUE, drop_mag = FALSE)
	if(!cover_open)
		balloon_alert(user, "open the feed cover!")
		return
	var/obj/item/ammo_magazine/original_magazine = ammo_magazine
	if(!reload_step(user, "removing belt box..."))
		return
	if(!cover_open || ammo_magazine != original_magazine)
		return
	return ..()

/obj/item/gun/projectile/heavy_machinegun/unique_action(mob/user)
	if(reload_busy)
		balloon_alert(user, "reloading!")
		return
	if(cover_open)
		balloon_alert(user, "close the feed cover!")
		return
	// The normal receiver action performs the actual extraction and chambering.
	return ..()

/obj/item/gun/projectile/heavy_machinegun/special_check(mob/user)
	if(loc == user || get_gun_user() != user)
		balloon_alert(user, "must be mounted!")
		return FALSE
	return ..()

/obj/item/gun/projectile/heavy_machinegun/proc/check_receiver(datum/source, mob/user, atom/target, atom/controller)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(cover_open || reload_busy)
		balloon_alert(user, cover_open ? "feed cover open!" : "reloading!")
		return COMPONENT_BLOCK_GUN_FIRE

/obj/item/gun/projectile/heavy_machinegun/update_icon()
	. = ..()
	SEND_SIGNAL(src, COMSIG_GUN_FEED_CHANGED)

/obj/item/gun/projectile/heavy_machinegun/feedback_hints(mob/user, distance, is_adjacent)
	. = ..()
	. += "The feed cover is [cover_open ? "open" : "closed"]."

/obj/item/gun/projectile/heavy_machinegun/model_3
	name = "\improper HMG-3 heavy machine gun"
	desc = "An air-cooled tripod-mounted heavy machine gun. Brutally simple, as it is effective for area denial."
	desc_extended = "Produced by the San Colette Interstellar Armaments Company (CAISC), the Colletish Armaments Heavy Machine Gun Model 3 is a heavy piece of equipment, perfect for area denial and suppressive fire. Brutally simple as it is effective, the HMG-3 excelled as the perfect emplacement weapon to secure outposts, convoys and as a secondary vehicle armament, due to its easy maintenance and low jam probability. Chambered in 12.5mm to shred even your best protected enemy."
	icon = 'icons/obj/guns/faction/caisc/hmg_3.dmi'
	icon_state = "hmg0"
	item_state = "hmg"
	caliber = "12.5mm"
	allowed_magazines = list(/obj/item/ammo_magazine/heavy_machinegun)
	max_shells = 100
	fire_delay = 1.5
	fire_sound = 'sound/weapons/gunshot/gunshot_hmg_temp.ogg' // Needs code to better handle firing, temp asset
	vary_fire_sound = FALSE
	chamber_rack_sound = SFX_CHAMBER_HMG

/obj/item/gun/projectile/heavy_machinegun/model_3/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/mountable_weapon, GUN_MOUNT_HEAVY, 'icons/obj/guns/faction/caisc/hmg_3_deployed.dmi', "hmg", "hmg_ammo", 'sound/weapons/hmg_setup.ogg', 'sound/weapons/hmg_rotate.ogg')

/obj/item/gun/projectile/heavy_machinegun/model_3/update_icon()
	icon_state = ammo_magazine ? "hmg1" : "hmg0"
	return ..()

/obj/item/ammo_magazine/heavy_machinegun
	name = "12.5mm belt box"
	desc = "A heavy stamped metal ammunition box containing a linked belt of 12.5mm rounds."
	icon = 'icons/obj/guns/faction/caisc/hmg_3_ammo.dmi'
	icon_state = "hmg_box"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = 0
	mag_type = MAGAZINE
	caliber = "12.5mm"
	ammo_type = /obj/item/ammo_casing/a125
	max_ammo = 100
	insert_sound = SFX_RELOAD_HMG

/obj/item/ammo_magazine/heavy_machinegun/update_icon()
	. = ..()
	icon_state = length(stored_ammo) ? "hmg_box" : "hmg_box0"

/obj/item/ammo_magazine/heavy_machinegun/empty
	initial_ammo = 0
