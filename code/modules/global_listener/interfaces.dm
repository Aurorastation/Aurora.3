
// -- Global Listeners --
/*
This is basically just a simple way to add a reference to an object to an automatically maintained & named global list.
 Lists are indexed by a string ID, and the lists can contain any /datum type.

Creating a listener:

/obj/myobj
	var/listener/listener

/obj/myobj/Initialize()
	. = ..()
	listener = new("myid", src)

/obj/myobj/Destroy()
	QDEL_NULL(listener)
	return ..()

Iterating through a listener list:

/proc/print_myobj()
	for (var/thing in GET_LISTENERS("myid"))
		var/listener/L = thing
		to_world(L.target)

*/

/listener
	var/datum/target
	var/channel

/listener/New(listening_channel, datum/target)
	channel = listening_channel
	if (istype(target))
		src.target = target

	SSlistener.register(src)

/listener/Destroy()
	SSlistener.unregister(src)
	target = null
	return ..()

//-------------------------------
// Record listener
//-------------------------------

/listener/record/New(datum/target)
	..("SSrecords", target)

/listener/record/proc/on_delete(var/datum/record/r)
	return

/listener/record/proc/on_modify(var/datum/record/r)
	return

//-------------------------------
// Wifi (Deprecated, use /listener instead)
//-------------------------------
/datum/wifi
	var/obj/parent
	var/id

/datum/wifi/New(new_id, obj/O)
	id = new_id
	if(istype(O))
		parent = O

/datum/wifi/Destroy()
	parent = null
	return ..()

//-------------------------------
// Receiver
//-------------------------------
/datum/wifi/receiver
	var/listener/listener

/datum/wifi/receiver/New()
	..()
	listener = new(id, src)

/datum/wifi/receiver/Destroy()
	QDEL_NULL(listener)
	return ..()

//-------------------------------
// Sender
//-------------------------------
/datum/wifi/sender/proc/set_target(new_target)
	id = new_target

/datum/wifi/sender/proc/activate(mob/living/user)
	return

/datum/wifi/sender/proc/deactivate(mob/living/user)
	return
