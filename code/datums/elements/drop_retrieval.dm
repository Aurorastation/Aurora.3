/datum/element/drop_retrieval
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY|ELEMENT_BESPOKE
	var/compatible_types = list(/obj/item)

/datum/element/drop_retrieval/Attach(datum/target)
	. = ..()
	if(!is_type_in_list(target, compatible_types))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_MOVABLE_PRE_THROW, PROC_REF(cancel_throw))
	RegisterSignal(target, COMSIG_ITEM_DROPPED, PROC_REF(dropped))
	RegisterSignal(target, COMSIG_DROP_RETRIEVAL_CHECK, PROC_REF(dr_check))

/datum/element/drop_retrieval/Detach(datum/source, force)
	UnregisterSignal(source, list(
		COMSIG_MOVABLE_PRE_THROW,
		COMSIG_ITEM_DROPPED,
		COMSIG_DROP_RETRIEVAL_CHECK
	))
	return ..()

/datum/element/drop_retrieval/proc/cancel_throw(datum/source, mob/thrower)
	SIGNAL_HANDLER

	if(thrower)
		to_chat(thrower, SPAN_WARNING("\The [source] clanks on the ground."))
	return COMPONENT_CANCEL_THROW

/datum/element/drop_retrieval/proc/dropped(obj/item/I, mob/user)
	SIGNAL_HANDLER

/datum/element/drop_retrieval/proc/dr_check(obj/item/I)
	SIGNAL_HANDLER

	return COMPONENT_DROP_RETRIEVAL_PRESENT

/datum/element/drop_retrieval/pouch_sling
	var/obj/item/storage/pouch/sling/container

/datum/element/drop_retrieval/pouch_sling/Attach(datum/target, obj/item/storage/pouch/sling/new_container)
	. = ..()
	if(.)
		return
	container = new_container

/datum/element/drop_retrieval/pouch_sling/dropped(obj/item/I, mob/user)
	container.handle_retrieval(user)
