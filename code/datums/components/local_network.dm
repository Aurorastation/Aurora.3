/datum/component/local_network_member
	var/id_tag

/datum/component/local_network_member/Destroy()
	if(parent)
		var/datum/local_network/lan = get_local_network()
		if(lan)
			lan.remove_device(parent)
	. = ..()

/datum/component/local_network_member/Initialize(initial_id_tag)
	if(initial_id_tag)
		set_tag(null, initial_id_tag)

/datum/component/local_network_member/proc/set_tag(mob/user, new_ident)
	if(id_tag == new_ident)
		to_chat(user, SPAN_WARNING("\The [parent] is already part of the [new_ident] local network."))
		return FALSE

	if(id_tag)
		var/datum/local_network/old_lan = local_networks[id_tag]
		if(old_lan)
			if(!old_lan.remove_device(parent))
				to_chat(user, SPAN_WARNING("You encounter an error when trying to unregister \the [parent] from the [id_tag] local network."))
				return FALSE
			to_chat(user, SPAN_NOTICE("You unregister \the [parent] from the [id_tag] local network."))

	var/datum/local_network/lan = local_networks[new_ident]
	if(!lan)
		lan = new(new_ident)
		lan.add_device(parent)
		to_chat(user, SPAN_NOTICE("You create a new [new_ident] local network and register \the [parent] with it."))
	else if(lan.within_radius(parent))
		lan.add_device(parent)
		to_chat(user, SPAN_NOTICE("You register \the [parent] with the [new_ident] local network."))
	else
		to_chat(user, SPAN_WARNING("\The [parent] is out of range of the [new_ident] local network."))
		return FALSE
	id_tag = new_ident
	return TRUE

/datum/component/local_network_member/proc/get_local_network()
	var/datum/local_network/lan = id_tag ? local_networks[id_tag] : null
	if(lan && !lan.within_radius(parent))
		lan.remove_device(parent)
		id_tag = null
		lan = null
	return lan

/datum/component/local_network_member/nano_host()
	if(parent)
		return parent.nano_host()
	. = ..()

/datum/component/local_network_member/proc/get_new_tag(mob/user)
	var/new_ident = input(user, "Enter a new ident tag.", "[parent]", id_tag) as null|text
	if(new_ident && parent && user.Adjacent(parent) && CanInteract(user, physical_state))
		return set_tag(user, new_ident)

//

/datum/component/local_network_member/multilevel/set_tag(mob/user, new_ident)
	if(id_tag == new_ident)
		to_chat(user, SPAN_WARNING("\The [parent] is already part of the [new_ident] local network."))
		return FALSE

	if(id_tag)
		var/datum/local_network/multilevel/old_lan = multilevel_local_networks[id_tag]
		if(old_lan)
			if(!old_lan.remove_device(parent))
				to_chat(user, SPAN_WARNING("You encounter an error when trying to unregister \the [parent] from the [id_tag] local network."))
				return FALSE
			to_chat(user, SPAN_NOTICE("You unregister \the [parent] from the [id_tag] local network."))

	var/datum/local_network/multilevel/lan = multilevel_local_networks[new_ident]
	if(!lan)
		lan = new(new_ident)
		lan.add_device(parent)
		to_chat(user, SPAN_NOTICE("You create a new [new_ident] local network and register \the [parent] with it."))
	else if(lan.within_radius(parent))
		lan.add_device(parent)
		to_chat(user, SPAN_NOTICE("You register \the [parent] with the [new_ident] local network."))
	else
		to_chat(user, SPAN_WARNING("\The [parent] is out of range of the [new_ident] local network."))
		return FALSE
	id_tag = new_ident
	return TRUE

/datum/component/local_network_member/multilevel/get_local_network()
	var/datum/local_network/multilevel/lan = id_tag ? multilevel_local_networks[id_tag] : null
	if(lan && !lan.within_radius(parent))
		lan.remove_device(parent)
		id_tag = null
		lan = null
	return lan
