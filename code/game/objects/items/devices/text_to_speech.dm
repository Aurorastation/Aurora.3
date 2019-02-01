/obj/item/device/text_to_speech
	name = "TTS device"
	desc = "A device that speaks an inputted message. Given to crew which can not speak properly or at all."
	icon_state = "tts"
	w_class = ITEMSIZE_SMALL
	var/named

/obj/item/device/text_to_speech/attack_self(mob/user as mob)
	if(user.incapacitated(INCAPACITATION_ALL)) //Are you in a state to actual use the device?
		to_chat(user, "You cannot activate the device in your state.")
		return

	if(!named)
		to_chat(user, "You input your name into the device.")
		name = "[initial(name)] ([user.real_name])"
		desc = "[initial(desc)] This one is assigned to [user.real_name]."
		named = 1
		/* //Another way of naming the device. Gives more freedom, but could lead to issues.
		device_name = copytext(sanitize(input(user, "What would you like to name your device? You must input a name before the device can be used.", "Name your device", "") as null|text),1,MAX_NAME_LEN)
		name = "[initial(name)] - [device_name]"
		named = 1
		*/

	var/message = sanitize(input(user,"Choose a message to relay to those around you.") as text|null)
	if(message)
		var/obj/item/device/text_to_speech/O = src
		audible_message("\icon[O] \The [O.name] states, \"[message]\"")