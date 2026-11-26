/datum/element/mountable_weapon
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	VAR_PRIVATE/mount_class
	VAR_PRIVATE/mounted_icon
	VAR_PRIVATE/mounted_icon_state
	VAR_PRIVATE/magazine_icon_state
	/// Sound played when attaching this weapon to a support.
	VAR_FINAL/sound_setup
	/// Sound played when rotating a support carrying this weapon.
	VAR_FINAL/sound_rotate

/datum/element/mountable_weapon/Attach(datum/target, _mount_class, _mounted_icon, _mounted_icon_state, _magazine_icon_state, _sound_setup, _sound_rotate)
	. = ..()
	if(. == ELEMENT_INCOMPATIBLE || !istype(target, /obj/item/gun))
		return ELEMENT_INCOMPATIBLE
	mount_class = _mount_class
	mounted_icon = _mounted_icon
	mounted_icon_state = _mounted_icon_state
	magazine_icon_state = _magazine_icon_state
	sound_setup = _sound_setup
	sound_rotate = _sound_rotate
	RegisterSignal(target, COMSIG_GUN_MOUNT_DATA, PROC_REF(get_mount_data))

/datum/element/mountable_weapon/Detach(datum/target)
	UnregisterSignal(target, COMSIG_GUN_MOUNT_DATA)
	return ..()

/datum/element/mountable_weapon/proc/get_mount_data(datum/source, requested_class, list/mount_data)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(requested_class != mount_class)
		return NONE
	mount_data["icon"] = mounted_icon
	mount_data["icon_state"] = mounted_icon_state
	mount_data["sound_setup"] = sound_setup
	mount_data["sound_rotate"] = sound_rotate
	if(magazine_icon_state && istype(source, /obj/item/gun/projectile))
		var/obj/item/gun/projectile/gun = source
		if(gun.ammo_magazine?.loc == gun)
			mount_data["magazine_icon_state"] = magazine_icon_state
	return COMPONENT_GUN_MOUNTABLE
