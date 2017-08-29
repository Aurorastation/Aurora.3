//-------------------------------
/*
	Interfaces

	These are the datums that an object needs to connect via the wireless controller. You will need a /wifi/receiver to 
	allow other devices to connect to your device and send it instructions. You will need a /wifi/sender to send signals
	to other devices with wifi receivers. You can have multiple devices (senders and receivers) if you program your 
	device to handle them.

	Each wifi interface has one "id". This identifies which devices can connect to each other. Multiple senders can 
	connect to multiple receivers as long as they have the same id.

	Variants are found in devices.dm	

	To add a receiver to an object:
		Add the following variables to the object:
			var/_wifi_id		<< variable that can be configured on the map, this is passed to the receiver later
			var/datum/wifi/receiver/subtype/wifi_receiver		<< the receiver (and subtype itself)

		Add or modify the objects initialize() proc to include:
			if(_wifi_id)		<< only creates a wifi receiver if an id is set
				wifi_receiver = new(_wifi_id, src)		<< this needs to be in initialize() as New() is usually too 
														   early, and the receiver will try to connect to the controller 
														   before it is setup.

		Add or modify the objects Destroy() proc to include:
			QDEL_NULL(wifi_receiver)

	Senders are setup the same way, except with a  var/datum/wifi/sender/subtype/wifi_sender  variable instead of (or in 
	addition to) a /wifi/receiver variable.
	You will however need to call the /wifi/senders code to pass commands onto any connected receivers.
	Example:
		obj/machinery/button/attack_hand()
			wifi_sender.activate()
*/
//-------------------------------

/datum/listener
	var/datum/target
	var/channel

/datum/listener/New(listening_channel, datum/target)
	channel = listening_channel
	if (istype(target))
		src.target = target

	SSlistener.register(src)

/datum/listener/Destroy()
	SSlistener.unregister(src)
	parent = null
	return ..()

//-------------------------------
// Wifi
//-------------------------------
/datum/wifi
	var/obj/parent
	var/id

/datum/wifi/New(new_id, obj/O)
	id = new_id
	if(istype(O))
		parent = O

/datum/wifi/Destroy(wifi/device)
	parent = null
	return ..()

//-------------------------------
// Receiver
//-------------------------------
/datum/wifi/receiver
	var/datum/listener

/datum/wifi/receiver/New()
	..()
	listener = new(id, parent)

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
