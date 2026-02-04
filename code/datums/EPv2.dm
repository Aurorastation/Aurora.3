// TODO: turn this into a component (??) (probably not actually)
// something to do with signals at least seems like it would make sense

GLOBAL_LIST_EMPTY(all_exonet_connections)

/datum/exonet_protocol
	var/address = "" //Resembles IPv6, but with only five 'groups', e.g. XXXX:XXXX:XXXX:XXXX:XXXX
	var/visible_on_network = TRUE
	var/obj/item/communicator/holder = null

	var/datum/callback/on_message_recieved

/datum/exonet_protocol/New(obj/item/communicator/holder, address_seed, datum/callback/on_message_recieved)
	. = ..()
	src.holder = holder

	make_address(address_seed)
	GLOB.all_exonet_connections[address] = src

	src.on_message_recieved = on_message_recieved

/datum/exonet_protocol/Destroy(force)
	GLOB.all_exonet_connections -= address
	holder = null
	return ..()

/datum/exonet_protocol/proc/make_address(seed)
	if(!seed)
		return

	var/new_address = null
	while(new_address == find_address(new_address)) //Collision test.
		var/hash = md5(seed)
		var/raw_address = copytext(hash, 1, 25)
		var/prefix = "fc00" //Used for unique local address in real-life IPv6.
		var/addr = hexadecimal_to_EPv2(raw_address)

		new_address = "[prefix]:[addr]"
		seed = "[seed]0" //If we did get a collision, this should make the next attempt not have one.
		//sleep(1) // may not need this?

	address = new_address

/datum/exonet_protocol/proc/find_exonet_datum(target_address)
	var/datum/exonet_protocol/target = GLOB.all_exonet_connections[target_address]
	if(target?.visible_on_network)
		return target
	return null

/datum/exonet_protocol/proc/find_address(target_address)
	var/datum/exonet_protocol/target = find_exonet_datum(target_address)
	if(target)
		return target.address

/datum/exonet_protocol/proc/get_atom_from_address(target_address)
	var/datum/exonet_protocol/target = find_exonet_datum(target_address)
	if(target)
		return target.holder

// returns true if the target recieved the message successfully
/datum/exonet_protocol/proc/send_message(target_address, data_type, content)
	//var/obj/machinery/exonet_node/node = get_exonet_node()
	//if(!node) // Telecomms went boom, ion storm, etc.
	//	return
	var/datum/exonet_protocol/target = find_exonet_datum(target_address)
	if(target)
		//node.write_log(src.address, target_address, data_type, content)
		return target.receive_message(src, data_type, content)
	return FALSE

/datum/exonet_protocol/proc/receive_message(datum/exonet_protocol/origin_datum, data_type, content)
	return on_message_recieved?.Invoke(origin_datum, data_type, content)

/proc/hexadecimal_to_EPv2(hex)
	if(!hex)
		return null
	var/addr_1 = copytext(hex, 1, 5)
	var/addr_2 = copytext(hex, 5, 9)
	var/addr_3 = copytext(hex, 9 ,13)
	var/addr_4 = copytext(hex, 13, 17)
	var/new_address = "[addr_1]:[addr_2]:[addr_3]:[addr_4]"
	return new_address
