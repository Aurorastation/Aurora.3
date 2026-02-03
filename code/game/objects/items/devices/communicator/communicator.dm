GLOBAL_LIST_EMPTY_TYPED(all_communicators, /obj/item/communicator)

/obj/item/communicator
	name = "communicator"
	desc = "A T-14.2 communicator, popular across the galaxy for it's simplicity to use." // todo: "galaxy"?
	icon = 'icons/obj/devices/communicator.dmi'
	icon_state = "communicator"
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_ID | SLOT_BELT

	// Tech and mats vars

	// Video vars

	var/list/voice_mobs = list()
	var/list/voice_requests = list()
	var/list/voice_invites = list()

	// Instant messaging vars

	// Notepad vars

	/// TODO: Autodoc everything (copy proc comments from Polaris)
	var/flashlight_on = FALSE
	var/flashlight_lum = 2

	var/owner_name = ""
	var/owner_occupation = ""

	var/datum/exonet_protocol/exonet = null

/obj/item/communicator/Initialize(mapload)
	. = ..()
	GLOB.all_communicators += src

	//This is a pretty terrible way of doing this.
	addtimer(CALLBACK(src, PROC_REF(register_to_user), null, TRUE), 5 SECONDS)

/obj/item/communicator/Destroy()
	GLOB.all_communicators -= src
	QDEL_NULL(exonet)
	return ..()

/obj/item/communicator/attack_self(mob/user, modifiers)
	. = ..()
	if(!owner_name)
		register_to_user(user)
		// everything in this proc from here forwards is temp testing stuff
		return

	var/target_address = input(user) as anything in GLOB.all_exonet_connections - exonet.address
	exonet.send_message(target_address, EXONET_MSG_PING)

/obj/item/communicator/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	if(istype(attacking_item, /obj/item/card/id))
		var/obj/item/card/id/id_card = attacking_item

		if(!owner_name)
			register_to_user(user)

		if(owner_name == id_card.registered_name && id_card.assignment)
			owner_occupation = id_card.assignment
			to_chat(user, SPAN_NOTICE("Occupation updated."))
		else
			to_chat(user, SPAN_NOTICE("[src] rejects the ID."))

// called after initialize for if it's a loadout pick, on attack_self, and attackby an ID (temp comment)
/obj/item/communicator/proc/register_to_user(mob/user, silent = FALSE)
	user ||= get_holding_mob()
	if(!istype(user))
		return

	register_device(user.name)
	initialize_exonet(user)
	if(!silent)
		to_chat(user, SPAN_NOTICE("[icon2html(src, user)] Communicator registered."))

/obj/item/communicator/proc/initialize_exonet(mob/living/user)
	if(!istype(user) || exonet)
		return

	exonet = new(
		src,
		"communicator-[user.name]-[text_ref(src)]",
		CALLBACK(src, PROC_REF(receive_exonet_message))
	)
	//if(!node)
	//	node = get_exonet_node()
	//populate_known_devices()

/obj/item/communicator/proc/register_device(new_name)
	if(!new_name)
		return
	owner_name = new_name

	name = "[new_name]'s [initial(name)]"

/obj/item/communicator/proc/receive_exonet_message(datum/exonet_protocol/origin_datum, data_type, content)
	switch(data_type)
		if(EXONET_MSG_VOICE)
			return //todo
		if(EXONET_MSG_TEXT)
			return //todo
		if(EXONET_MSG_PING) // Recieved a ping.
			// Send a reply.
			exonet.send_message(origin_datum.address, EXONET_MSG_PING_REPLY, "64 bytes received from [exonet.address] ecmp_seq=1 ttl=51 time=[rand(20, 35)] ms")
		if(EXONET_MSG_PING_REPLY) // Recieved a ping reply.
			// Show the reply if it's being directly held by a mob.
			if(ismob(loc))
				to_chat(loc, SPAN_NOTICE("[icon2html(src, loc)] '[content]'"))
