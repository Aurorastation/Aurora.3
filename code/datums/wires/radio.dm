/datum/wires/radio
	holder_type = /obj/item/device/radio
	wire_count = 3

var/const/WIRE_SIGNAL = 1
var/const/WIRE_RECEIVE = 2
var/const/WIRE_TRANSMIT = 4

/datum/wires/radio/CanUse(var/mob/living/L)
	var/obj/item/device/radio/R = holder
	if(R.b_stat)
		return 1
	return 0

/datum/wires/radio/UpdatePulsed(var/index)
	var/obj/item/device/radio/R = holder
	switch(index)
		if(WIRE_SIGNAL)
			R.set_listening(!R.get_listening() && !IsIndexCut(WIRE_RECEIVE))
			R.set_broadcasting(R.get_listening() && !IsIndexCut(WIRE_TRANSMIT))

		if(WIRE_RECEIVE)
			R.set_listening(!R.get_listening() && !IsIndexCut(WIRE_SIGNAL))

		if(WIRE_TRANSMIT)
			R.set_broadcasting(!R.get_broadcasting() && !IsIndexCut(WIRE_SIGNAL))
	SSnanoui.update_uis(holder)

/datum/wires/radio/UpdateCut(var/index, var/mended)
	var/obj/item/device/radio/R = holder
	switch(index)
		if(WIRE_SIGNAL)
			R.set_listening(mended && !IsIndexCut(WIRE_RECEIVE))
			R.set_broadcasting(mended && !IsIndexCut(WIRE_TRANSMIT))

		if(WIRE_RECEIVE)
			R.set_listening(mended && !IsIndexCut(WIRE_SIGNAL))

		if(WIRE_TRANSMIT)
			R.set_broadcasting(mended && !IsIndexCut(WIRE_SIGNAL))
	SSnanoui.update_uis(holder)
