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

/obj/item/storage/internal_storage
	name = "internal storage"
	desc = "You shouldn't see this."
	max_w_class = WEIGHT_CLASS_NORMAL
	max_storage_space = DEFAULT_LARGEBOX_STORAGE
	allow_quick_empty = FALSE
