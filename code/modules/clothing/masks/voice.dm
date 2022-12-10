/obj/item/voice_changer
	name = "voice changer"
	desc = "A voice scrambling module. If you can see this, report it as a bug on the tracker."
	var/voice //If set and item is present in mask/suit, this name will be used for the wearer's speech.
	var/active
	var/current_accent = ACCENT_CETI

/obj/item/clothing/mask/gas/voice
	var/obj/item/voice_changer/changer
	origin_tech = list(TECH_ILLEGAL = 4)
	desc_antag = "This mask can be used to change the owner's voice."

/obj/item/clothing/mask/gas/voice/verb/Toggle_Voice_Changer()
	set category = "Object"
	set src in usr

	changer.active = !changer.active
	to_chat(usr, SPAN_NOTICE("You [changer.active ? "enable" : "disable"] the voice-changing module in \the [src]."))

/obj/item/clothing/mask/gas/voice/verb/Set_Voice(name as text)
	set category = "Object"
	set src in usr

	var/voice = sanitize(name, MAX_NAME_LEN)
	if(!voice || !length(voice)) return
	changer.voice = voice
	to_chat(usr, SPAN_NOTICE("You are now mimicking <B>[changer.voice]</B>."))

/obj/item/clothing/mask/gas/voice/verb/Toggle_Accent()
	set category = "Object"
	set src in usr

	var/choice = input(usr, "Please choose an accent to mimick.") as null|anything in SSrecords.accents
	if(choice)
		to_chat(usr, SPAN_NOTICE("You are now mimicking the [choice] accent."))
		changer.current_accent = choice

/obj/item/clothing/mask/gas/voice/Initialize()
	. = ..()
	changer = new(src)

/obj/item/clothing/mask/breath/vaurca/filter/voice
	var/obj/item/voice_changer/changer
	origin_tech = list(TECH_ILLEGAL = 4)
	desc_antag = "A Lii'draic filter port that allows to change voices."

/obj/item/clothing/mask/breath/vaurca/filter/voice/verb/Toggle_Voice_Changer()
	set category = "Object"
	set src in usr

	changer.active = !changer.active
	to_chat(usr, SPAN_NOTICE("You [changer.active ? "enable" : "disable"] the voice-changing module in \the [src]."))

/obj/item/clothing/mask/breath/vaurca/filter/voice/verb/Set_Voice(name as text)
	set category = "Object"
	set src in usr

	var/voice = sanitize(name, MAX_NAME_LEN)
	if(!voice || !length(voice)) return
	changer.voice = voice
	to_chat(usr, SPAN_NOTICE("You are now mimicking <B>[changer.voice]</B>."))

/obj/item/clothing/mask/breath/vaurca/filter/voice/verb/Toggle_Accent()
	set category = "Object"
	set src in usr

	var/choice = input(usr, "Please choose an accent to mimick.") as null|anything in SSrecords.accents
	if(choice)
		to_chat(usr, SPAN_NOTICE("You are now mimicking the [choice] accent."))
		changer.current_accent = choice

/obj/item/clothing/mask/breath/vaurca/filter/voice/Initialize()
	. = ..()
	changer = new(src)