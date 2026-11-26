/// Owns the installed weapon and its attachment state, independently of gun operation.
/datum/component/weapon_mount
	dupe_mode = COMPONENT_DUPE_UNIQUE
	VAR_PRIVATE/mount_class
	/// The original gun, retained inside the mount throughout attachment.
	VAR_PRIVATE/obj/item/gun/installed_gun
	/// Whether the mounting fasteners have been secured with a tool.
	VAR_PRIVATE/secured = FALSE
	/// Serializes attachment, fastening, removal, and folding checks.
	VAR_PRIVATE/busy = FALSE
	VAR_PRIVATE/mutable_appearance/weapon_overlay
	VAR_PRIVATE/mutable_appearance/magazine_overlay
	/// Operator control exists only while our installed gun is secured.
	VAR_PRIVATE/datum/component/mounted_weapon/mounted_controls
	VAR_FINAL/attachment_time = 2 SECONDS

/datum/component/weapon_mount/Initialize(_mount_class = GUN_MOUNT_HEAVY)
	if(!isobj(parent) || isitem(parent))
		return COMPONENT_INCOMPATIBLE
	mount_class = _mount_class

/datum/component/weapon_mount/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_ITEM_INTERACTION, PROC_REF(on_item_interaction))
	RegisterSignal(parent, COMSIG_ATOM_TOOL_ACT(TOOL_WRENCH), PROC_REF(on_wrench))
	RegisterSignal(parent, COMSIG_ITEM_UNDEPLOY_CHECK, PROC_REF(check_undeploy))
	RegisterSignal(parent, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_direction_change))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(on_mount_deleted))

/datum/component/weapon_mount/UnregisterFromParent()
	release_weapon()
	UnregisterSignal(parent, list(COMSIG_ATOM_ITEM_INTERACTION, COMSIG_ATOM_TOOL_ACT(TOOL_WRENCH), COMSIG_ITEM_UNDEPLOY_CHECK, COMSIG_ATOM_DIR_CHANGE, COMSIG_ATOM_EXAMINE, COMSIG_QDELETING))
	return ..()

/datum/component/weapon_mount/proc/get_weapon()
	return installed_gun

/datum/component/weapon_mount/proc/is_secured()
	return secured

/datum/component/weapon_mount/proc/rotate_mount(mob/living/user)
	if(!can_interact(user))
		return FALSE
	var/obj/mount = parent
	if(busy)
		mount.balloon_alert(user, "mount busy!")
		return FALSE
	if(installed_gun?.get_gun_user())
		mount.balloon_alert(user, "gun in use!")
		return FALSE
	if(installed_gun)
		var/list/mount_data = list()
		SEND_SIGNAL(installed_gun, COMSIG_GUN_MOUNT_DATA, mount_class, mount_data)
		if(mount_data["sound_rotate"])
			playsound(mount, mount_data["sound_rotate"], 25, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
	mount.set_dir(turn(mount.dir, 90))
	mount.update_icon()
	return TRUE

/datum/component/weapon_mount/proc/on_item_interaction(obj/source, mob/living/user, obj/item/tool, list/modifiers)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(user.a_intent == I_HURT || !istype(tool, /obj/item/gun))
		return
	var/list/mount_data = list()
	if(!(SEND_SIGNAL(tool, COMSIG_GUN_MOUNT_DATA, mount_class, mount_data) & COMPONENT_GUN_MOUNTABLE))
		return
	if(installed_gun || busy)
		source.balloon_alert(user, "mount occupied!")
	else
		INVOKE_ASYNC(src, PROC_REF(install_weapon), user, tool)
	return ITEM_INTERACT_SUCCESS

/datum/component/weapon_mount/proc/can_interact(mob/living/user)
	PRIVATE_PROC(TRUE)
	var/obj/mount = parent
	return !QDELETED(user) && !QDELETED(mount) && isturf(mount.loc) && mount.anchored && !mount.use_check(user)

/datum/component/weapon_mount/proc/install_weapon(mob/living/user, obj/item/gun/gun)
	PRIVATE_PROC(TRUE)
	if(busy || installed_gun || !can_interact(user) || user.get_active_hand() != gun || !user.canUnEquip(gun))
		return
	var/obj/mount = parent
	var/list/mount_data = list()
	if(!(SEND_SIGNAL(gun, COMSIG_GUN_MOUNT_DATA, mount_class, mount_data) & COMPONENT_GUN_MOUNTABLE))
		return
	busy = TRUE
	mount.balloon_alert(user, "attaching...")
	if(mount_data["sound_setup"])
		playsound(mount, mount_data["sound_setup"], 50, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
	var/completed = do_after(user, attachment_time, mount, DO_REPAIR_CONSTRUCT | DO_USER_UNIQUE_ACT)
	if(QDELETED(src))
		return
	busy = FALSE
	if(!completed || !can_interact(user) || installed_gun || QDELETED(gun) || user.get_active_hand() != gun || !user.canUnEquip(gun))
		return
	mount_data = list()
	if(!(SEND_SIGNAL(gun, COMSIG_GUN_MOUNT_DATA, mount_class, mount_data) & COMPONENT_GUN_MOUNTABLE))
		return
	busy = TRUE
	var/transferred = user.unEquip(gun, FALSE, mount)
	if(QDELETED(src))
		return
	busy = FALSE
	if(!transferred || QDELETED(gun) || gun.loc != mount)
		return
	installed_gun = gun
	secured = FALSE
	RegisterSignal(gun, COMSIG_MOVABLE_MOVED, PROC_REF(on_weapon_moved))
	RegisterSignal(gun, COMSIG_QDELETING, PROC_REF(on_weapon_deleted))
	RegisterSignal(gun, COMSIG_GUN_FEED_CHANGED, PROC_REF(update_weapon_overlay))
	update_weapon_overlay()
	mount.balloon_alert(user, "attached; needs securing")

/datum/component/weapon_mount/proc/on_wrench(obj/source, mob/living/user, obj/item/tool)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(!installed_gun)
		return
	INVOKE_ASYNC(src, PROC_REF(toggle_securing), user, tool)
	return ITEM_INTERACT_SUCCESS

/datum/component/weapon_mount/proc/toggle_securing(mob/living/user, obj/item/tool)
	PRIVATE_PROC(TRUE)
	if(busy || !installed_gun || !can_interact(user) || user.get_active_hand() != tool)
		return
	var/obj/mount = parent
	var/obj/item/gun/gun = installed_gun
	if(gun.get_gun_user())
		mount.balloon_alert(user, "gun in use!")
		return
	busy = TRUE
	mount.balloon_alert(user, secured ? "unsecuring..." : "securing...")
	tool.play_tool_sound(mount, 50)
	var/completed = do_after(user, attachment_time, mount, DO_REPAIR_CONSTRUCT | DO_USER_UNIQUE_ACT)
	if(QDELETED(src))
		return
	busy = FALSE
	if(!completed || !can_interact(user) || QDELETED(tool) || user.get_active_hand() != tool || installed_gun != gun || QDELETED(gun) || gun.get_gun_user())
		return
	secured = !secured
	if(secured)
		mounted_controls = mount.AddComponent(/datum/component/mounted_weapon, gun)
	else
		QDEL_NULL(mounted_controls)
	mount.balloon_alert(user, secured ? "secured" : "unsecured")
	tool.play_tool_sound(mount, 50)

// Called by mounts with an empty-hand interaction; other mount types can expose their own control.
/datum/component/weapon_mount/proc/remove_weapon(mob/living/user)
	if(busy || !installed_gun || !can_interact(user) || user.get_active_hand())
		return FALSE
	var/obj/mount = parent
	if(secured)
		mount.balloon_alert(user, "unsecure it first!")
		return TRUE
	var/obj/item/gun/gun = installed_gun
	busy = TRUE
	mount.balloon_alert(user, "detaching...")
	var/completed = do_after(user, attachment_time, mount, DO_REPAIR_CONSTRUCT | DO_USER_UNIQUE_ACT)
	if(QDELETED(src))
		return TRUE
	busy = FALSE
	if(!completed || !can_interact(user) || installed_gun != gun || QDELETED(gun) || secured || user.get_active_hand())
		return TRUE
	release_weapon()
	if(!QDELETED(gun))
		user.put_in_hands(gun)
	return TRUE

/datum/component/weapon_mount/proc/check_undeploy(datum/source, mob/user)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(installed_gun || busy)
		return COMPONENT_BLOCK_UNDEPLOY

/datum/component/weapon_mount/proc/on_examine(obj/source, mob/user, list/examine_text)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	examine_text += SPAN_SUBTLE("Alt-click to rotate while the mount is idle and the gun is unmanned.")
	if(installed_gun)
		examine_text += "It holds \a [installed_gun], which is [secured ? "secured" : "unsecured"]."
	else
		examine_text += "Its mounting cradle is empty."

/datum/component/weapon_mount/proc/on_direction_change(obj/source, old_dir, new_dir)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	update_weapon_overlay(null, new_dir)

/datum/component/weapon_mount/proc/update_weapon_overlay(datum/source, direction)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	var/obj/mount = parent
	if(weapon_overlay)
		mount.CutOverlays(weapon_overlay)
		weapon_overlay = null
	if(magazine_overlay)
		mount.CutOverlays(magazine_overlay)
		magazine_overlay = null
	if(!installed_gun)
		return
	var/list/mount_data = list()
	SEND_SIGNAL(installed_gun, COMSIG_GUN_MOUNT_DATA, mount_class, mount_data)
	weapon_overlay = mutable_appearance(mount_data["icon"], mount_data["icon_state"])
	weapon_overlay.dir = direction || mount.dir
	mount.AddOverlays(weapon_overlay)
	if(mount_data["magazine_icon_state"])
		magazine_overlay = mutable_appearance(mount_data["icon"], mount_data["magazine_icon_state"])
		magazine_overlay.dir = direction || mount.dir
		mount.AddOverlays(magazine_overlay)

/datum/component/weapon_mount/proc/on_weapon_moved(obj/item/gun/source, atom/old_loc)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(source.loc != parent)
		clear_weapon()

/datum/component/weapon_mount/proc/on_weapon_deleted(datum/source)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	clear_weapon()

/datum/component/weapon_mount/proc/on_mount_deleted(datum/source)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	release_weapon()

/datum/component/weapon_mount/proc/clear_weapon()
	PRIVATE_PROC(TRUE)
	QDEL_NULL(mounted_controls)
	if(installed_gun)
		UnregisterSignal(installed_gun, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING, COMSIG_GUN_FEED_CHANGED))
	installed_gun = null
	secured = FALSE
	var/obj/mount = parent
	if(weapon_overlay)
		mount.CutOverlays(weapon_overlay)
		weapon_overlay = null
	if(magazine_overlay)
		mount.CutOverlays(magazine_overlay)
		magazine_overlay = null

/datum/component/weapon_mount/proc/release_weapon()
	PRIVATE_PROC(TRUE)
	var/obj/item/gun/gun = installed_gun
	clear_weapon()
	if(!QDELETED(gun) && gun.loc == parent)
		gun.forceMove(get_turf(parent))
