/**
 * # Compromised PDA Event
 *
 * An event that sends a message to all PDA users that can receive it and are on the station
 * level, using one PDA as the sender (aka the compromised PDA)
 */
/datum/event/compromised_pda
	severity = EVENT_LEVEL_MUNDANE
	no_fake = TRUE

	///The message to send to the victims, from the compromised PDA
	var/compromised_message_to_send = "Free 500 credits gift card: gaming.nt/redeem/giftcard/500"

	///A list of potential victims, one will be picked as the sender, everyone else (if able) will receive the message
	var/list/datum/computer_file/program/chat_client/potential_victims = list()

/datum/event/compromised_pda/setup()
	for(var/datum/computer_file/program/chat_client/potential_victim_chat_client in GLOB.ntnet_global.chat_clients)
		//No admin or antags
		if(potential_victim_chat_client.netadmin_mode || potential_victim_chat_client.syndi_auth)
			continue

		//Need to have an user and a signal
		if(!istype(potential_victim_chat_client.my_user) || !potential_victim_chat_client.get_signal(NTNET_COMMUNICATION))
			continue

		//Only PDAs are affected
		if(!istype(potential_victim_chat_client.computer, /obj/item/modular_computer/handheld/pda))
			continue

		//Only affect people on the station
		var/turf/pda_turf = get_turf(potential_victim_chat_client.computer)
		if(!is_station_level(pda_turf.z))
			continue

		//If the program isn't running, skip it
		if(potential_victim_chat_client.service_state <= PROGRAM_STATE_KILLED)
			continue

		potential_victims += potential_victim_chat_client

	//Need at least a sender and a receiver
	if(length(potential_victims) < 2)
		qdel(src)
		return

/datum/event/compromised_pda/start()
	. = ..()

	var/mob/compromised_chat_client_mob

	//Pick a random chat client as the source, only if the program is running and we have a mob associated with the computer
	var/datum/computer_file/program/chat_client/compromised_chat_client
	for(var/i in 1 to length(potential_victims))
		var/datum/computer_file/program/chat_client/potential_compromised_chat_client = pick(potential_victims)

		if(potential_compromised_chat_client.service_state > PROGRAM_STATE_KILLED && ismob(potential_compromised_chat_client.computer.registered_id.mob_id.resolve()))
			compromised_chat_client = potential_compromised_chat_client
			compromised_chat_client_mob = potential_compromised_chat_client.computer.registered_id.mob_id.resolve()
			break

	//If somehow we didn't find anyone, bail out
	if(!istype(compromised_chat_client))
		qdel(src)
		return

	//Remove the compromised chat client from the list of potential victims
	potential_victims -= compromised_chat_client

	for(var/datum/computer_file/program/chat_client/potential_victim_chat_client in potential_victims)
		//If the program isn't running or there's no connection, skip it
		if((potential_victim_chat_client.service_state <= PROGRAM_STATE_KILLED) || !potential_victim_chat_client.get_signal(NTNET_COMMUNICATION))
			continue

		var/datum/ntnet_conversation/conversation_with_victim

		//If there's already a conversation with the victim, use that one, otherwise create a new one
		if(compromised_chat_client.my_user.dm_channels[potential_victim_chat_client.my_user])
			conversation_with_victim = compromised_chat_client.my_user.dm_channels[potential_victim_chat_client.my_user]
		else
			conversation_with_victim = GLOB.ntnet_global.begin_direct(compromised_chat_client, potential_victim_chat_client.my_user)

		//Send the message to the victim
		conversation_with_victim.cl_send(compromised_chat_client, compromised_message_to_send, compromised_chat_client_mob)
