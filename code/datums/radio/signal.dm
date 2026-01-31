/datum/signal
	/// The object (usually a radio, but also PDAs, etc.) which created the signal.
	var/obj/source

	/// How the signal is being transmitted, can be considered like 'range.' See 'code/__DEFINES/radio.dm' for details.
	var/transmission_method = TRANSMISSION_WIRE


	var/list/data = list()

	/// Whether or not any random receiver can pick this signal up, or if it requires an encryption key. If encrypted with no key, the message is rejected and ignored on initial receipt (can_receive).
	var/encryption

	/// The frequency being broadcast on.
	var/frequency = 0

/datum/signal/proc/copy_from(datum/signal/model)
	source = model.source
	transmission_method = model.transmission_method
	data = model.data
	encryption = model.encryption
	frequency = model.frequency

/datum/signal/proc/debug_print()
	if (source)
		. = "signal = {source = '[source]' ([source.x],[source.y],[source.z])\n"
	else
		. = "signal = {source = '[source]' ()\n"
	for (var/i in data)
		. += "data\[\"[i]\"\] = \"[data[i]]\"\n"
		if(islist(data[i]))
			var/list/L = data[i]
			for(var/t in L)
				. += "data\[\"[i]\"\] list has: [t]"

/datum/signal/Destroy()
	..()
	return QDEL_HINT_IWILLGC
