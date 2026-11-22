/obj/item/organ/internal/machine/internal_storage
	name = "internal storage system"
	desc = "A simple internal casing used by G2 frames for internal storage."
	icon = 'icons/obj/organs/augments.dmi'
	icon_state = "anchor"
	organ_tag = BP_INTERNAL_STORAGE
	parent_organ = BP_GROIN

	action_button_name = "Access Internal Storage"

	max_damage = 35
	relative_size = 25

	/// The actual, physical storage item.
	var/obj/item/storage/internal_storage/storage
	/// Whether other people may access this storage through the strip menu.
	var/locked = TRUE

/obj/item/organ/internal/machine/internal_storage/Initialize()
	. = ..()
	storage = new(src)

/obj/item/organ/internal/machine/internal_storage/Destroy()
	QDEL_NULL(storage)
	return ..()

/obj/item/organ/internal/machine/internal_storage/removed()
	. = ..()
	for(var/thing in storage)
		storage.remove_from_storage(thing, get_turf(src))

/obj/item/organ/internal/machine/internal_storage/attack_self(mob/user)
	if(is_broken())
		to_chat(user, SPAN_WARNING("The hatch to the internal storage is completely destroyed!"))
		return

	if(get_integrity() < IPC_INTEGRITY_THRESHOLD_LOW)
		to_chat(user, SPAN_NOTICE("You struggle to pry open the hatch to the internal storage..."))
		if(!do_after(1 SECOND, src))
			return

	storage.open(user)

/obj/item/organ/internal/machine/internal_storage/proc/toggle_lock(mob/user)
	if(user != owner)
		return FALSE
	locked = !locked
	to_chat(owner, SPAN_MACHINE_WARNING("Your internal storage is now [locked ? "locked" : "unlocked"] to external access."))
	if(locked && !is_panel_open())
		owner.strip_menu?.close_storage(storage)
	return TRUE

/// The groin maintenance hatch physically bypasses the software-controlled storage lock.
/obj/item/organ/internal/machine/internal_storage/proc/is_panel_open()
	if(!owner)
		return FALSE
	var/obj/item/organ/external/groin/G = owner.organs_by_name[BP_GROIN]
	return G && !!G.open

/obj/item/organ/internal/machine/internal_storage/proc/is_externally_accessible()
	return !locked || is_panel_open()

/// Called when surgery restores the physical hatch, allowing a queued software lock to take effect immediately.
/obj/item/organ/internal/machine/internal_storage/proc/on_panel_closed()
	if(locked)
		owner?.strip_menu?.close_storage(storage)

/obj/item/storage/internal_storage
	name = "internal storage"
	desc = "You shouldn't see this."
	max_w_class = WEIGHT_CLASS_NORMAL
	max_storage_space = DEFAULT_LARGEBOX_STORAGE
	allow_quick_empty = FALSE
	care_about_storage_depth = FALSE
