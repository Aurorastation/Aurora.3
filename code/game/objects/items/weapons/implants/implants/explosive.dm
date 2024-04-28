#define MALFUNCTION_TEMPORARY 1
#define MALFUNCTION_PERMANENT 2

//BS12 Explosive
/obj/item/implant/explosive
	name = "explosive implant"
	desc = "A military grade micro bio-explosive. Highly dangerous."
	icon_state = "implant_explosive"
	implant_icon = "explosive"
	implant_color = "#e46b5d"
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 2, TECH_ILLEGAL = 3)
	default_action_type = /datum/action/item_action/hands_free/activate/implant/explosive
	action_button_name = "Activate Explosive Implant"
	hidden = TRUE
	var/elevel = "Localized Limb"
	var/explodes_on_death = FALSE
	var/phrase
	var/code = 13
	var/frequency = 1443
	var/datum/radio_frequency/radio_connection
	var/list/possible_explosions = list("Localized Limb", "Destroy Body")
	var/warning_message = "Tampering detected. Tampering detected."

/obj/item/implant/explosive/New()
	..()
	become_hearing_sensitive(ROUNDSTART_TRAIT)

/obj/item/implant/explosive/Initialize()
	. = ..()
	setFrequency(frequency)

/obj/item/implant/explosive/Destroy()
	lose_hearing_sensitivity(ROUNDSTART_TRAIT)

	if(frequency)
		SSradio.remove_object_all(src)
	frequency = null
	radio_connection = null

	. = ..()

/obj/item/implant/explosive/get_data()
	. = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Kumar Arms ZX-01 \"Obscuration\" Class Implant<BR>
<b>Life:</b> Activates upon codephrase.<BR>
<b>Important Notes:</b> <span class='danger'>Explodes</span><BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a compact, electrically detonated explosive that detonates upon receiving a specially encoded signal or upon host death.<BR>
<b>Special Features:</b> Explodes. Explosion severity can be altered.<BR>
<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}
	if(!malfunction)
		. += {"
	<HR><B>Explosion yield mode:</B></HR>
	<A href='byond://?src=\ref[src];mode=1'>[elevel ? elevel : "NONE SET"]</A><BR>
	<B>Activation phrase:</B><BR>
	<A href='byond://?src=\ref[src];phrase=1'>[phrase ? phrase : "NONE SET"]</A><BR>
	<B>Frequency:</B><BR>
	<A href='byond://?src=\ref[src];freq=-10'>-</A>
	<A href='byond://?src=\ref[src];freq=-2'>-</A>
	[format_frequency(src.frequency)]
	<A href='byond://?src=\ref[src];freq=2'>+</A>
	<A href='byond://?src=\ref[src];freq=10'>+</A><BR>
	<B>Code:</B><BR>
	<A href='byond://?src=\ref[src];code=-5'>-</A>
	<A href='byond://?src=\ref[src];code=-1'>-</A>
	<A href='byond://?src=\ref[src];code=set'>[src.code]</A>
	<A href='byond://?src=\ref[src];code=1'>+</A>
	<A href='byond://?src=\ref[src];code=5'>+</A><BR>
	<B>Tampering warning message:</B><BR>
	This will be broadcasted on radio if the implant is exposed during surgery.<BR>
	<A href='byond://?src=\ref[src];msg=1'>[warning_message ? warning_message : "NONE SET"]</A>
	"}

/obj/item/implant/explosive/Topic(href, href_list)
	..()
	if(href_list["freq"])
		var/new_frequency = frequency + text2num(href_list["freq"])
		new_frequency = sanitize_frequency(new_frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
		setFrequency(new_frequency)
		interact(usr)
	if(href_list["code"])
		var/adj = text2num(href_list["code"])
		if(!adj)
			code = tgui_input_number(usr, "Set radio activation code.", "Radio Activation")
		else
			code += adj
		code = clamp(code,1,100)
		interact(usr)
	if(href_list["mode"])
		var/mod = tgui_input_list(usr, "Set explosion mode.", "Explosion Mode", possible_explosions)
		if(mod)
			elevel = mod
		interact(usr)
	if(href_list["msg"])
		var/msg = tgui_input_text(usr, "Set tampering message, or leave blank for no broadcasting.", "Anti-Tampering", warning_message)
		if(msg)
			warning_message = msg
		interact(usr)
	if(href_list["phrase"])
		var/talk = tgui_input_text(usr, "Set activation phrase", "Audio Activation", phrase)
		if(talk)
			phrase = sanitizePhrase(talk)
		interact(usr)

/obj/item/implant/explosive/receive_signal(datum/signal/signal)
	if(signal && signal.encryption == code)
		activate()

/obj/item/implant/explosive/proc/setFrequency(new_frequency)
	if(!frequency)
		return
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, RADIO_CHAT)

/obj/item/implant/explosive/hear_talk(mob/M, msg)
	hear(msg)

/obj/item/implant/explosive/hear(var/msg)
	if(!phrase)
		return
	if(findtext(sanitizePhrase(msg),phrase))
		activate()
		qdel(src)

/obj/item/implant/explosive/exposed()
	if(warning_message)
		GLOB.global_announcer.autosay(warning_message, "Anti-Tampering System")

/obj/item/implant/explosive/proc/sanitizePhrase(phrase)
	var/list/replacechars = list("'" = "", "\"" = "", ">" = "", "<" = "", "(" = "", ")" = "")
	return replace_characters(phrase, replacechars)

/obj/item/implant/explosive/activate()
	if(malfunction)
		return

	if(!imp_in)
		small_countdown()
		return

	message_admins("Explosive implant triggered in [imp_in] ([imp_in.key]). (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[imp_in.x];Y=[imp_in.y];Z=[imp_in.z]'>JMP</a>) ")
	log_game("Explosive implant triggered in [imp_in] ([imp_in.key]).")
	if(!elevel)
		elevel = "Localized Limb"
	switch(elevel)
		if("Localized Limb")
			if(part)
				small_countdown()
				return
		if("Destroy Body")
			explosion(get_turf(imp_in), -1, 0, 2, 6)
			if(ismob(imp_in))
				imp_in.gib()
		if("Full Explosion")
			explosion_spread(get_turf(imp_in), rand(8,13))
			if(ismob(imp_in))
				imp_in.gib()

	var/turf/F = get_turf(imp_in)
	if(F)
		F.hotspot_expose(3500,125)
	qdel(src)

/obj/item/implant/explosive/proc/small_countdown()
	if(!imp_in)
		audible_message(SPAN_WARNING("[src] beeps ominously!"))
	if(ishuman(imp_in))
		var/message = "Something beeps inside of [imp_in][part ? "'s [part.name]" : ""]..." //for some reason SPAN_X and span() both hate having this in-line
		imp_in.audible_message(SPAN_WARNING(message))
	else if(ismob(imp_in))
		imp_in.audible_message(SPAN_WARNING("Something beeps inside of [imp_in]..."))
	playsound(loc, 'sound/items/countdown.ogg', 75, 1, -3)
	addtimer(CALLBACK(src, PROC_REF(small_boom)), 25)

/obj/item/implant/explosive/proc/small_boom()
	if(!imp_in)
		explosion(get_turf(src), -1, 0, 2, 4)
	if(ishuman(imp_in) && part)
		//No tearing off these parts since it's pretty much killing. Mangle them.
		if(part.vital && !istype(part, /obj/item/organ/external/head)) //Head explodes
			part.createwound(BRUISE, 70)
			part.add_pain(50)
			imp_in.visible_message(SPAN_WARNING("\The [imp_in]'s [part.name] bursts open with a horrible ripping noise!"),
									SPAN_DANGER("Your [part.name] bursts open with a horrible ripping noise!"),
									SPAN_WARNING("You hear a horrible ripping noise."))
		else
			part.droplimb(0,DROPLIMB_BLUNT)
		playsound(get_turf(imp_in), BP_IS_ROBOTIC(part) ? 'sound/effects/meteorimpact.ogg' : 'sound/effects/splat.ogg', 70)
	else if(ismob(imp_in))
		var/mob/M = imp_in
		M.gib()	//Simple mobs just get got
	qdel(src)

/obj/item/implant/explosive/proc/explosion_spread(turf/epicenter, power, adminlog = 1, z_transfer = UP|DOWN)
	var/datum/explosiondata/data = new
	data.epicenter = epicenter
	data.rec_pow = power
	data.spreading = TRUE
	data.adminlog = adminlog
	data.z_transfer = z_transfer
	SSexplosives.queue(data)

/obj/item/implant/explosive/implanted(mob/source, mob/user)
	var/memo = "\The [src] in [source] can be activated by saying something containing the phrase ''[phrase]'', <B>say [phrase]</B> to attempt to activate. It can also be triggered with a radio signal on frequency <b>[format_frequency(src.frequency)]</b> with code <b>[code]</b>."
	if(user.mind)
		user.mind.store_memory(memo, 0, 0)
	to_chat(usr, memo)
	return TRUE

/obj/item/implant/explosive/emp_act(severity)
	. = ..()

	if(malfunction)
		return
	malfunction = MALFUNCTION_TEMPORARY
	switch (severity)
		if(2.0)	//Weak EMP will make implant tear limbs off.
			if(prob(50))
				small_countdown()
		if(1.0)	//strong EMP will melt implant either making it go off, or disarming it
			if(prob(70))
				if(prob(50))
					small_countdown()
				else
					if(prob(50))
						activate()	//50% chance of bye bye
					else
						meltdown()	//50% chance of implant disarming
	addtimer(CALLBACK(src, PROC_REF(self_correct)), 20)

/obj/item/implant/explosive/proc/self_correct()
	malfunction--

/obj/item/implant/explosive/isLegal()
	return FALSE

/obj/item/implant/explosive/full
	possible_explosions = list("Localized Limb", "Destroy Body", "Full Explosion")

/obj/item/implant/explosive/deadman
	name = "deadman explosive"
	desc = "A military grade micro bio-explosive that detonates upon death."
	icon_state = "implant_evil"

/obj/item/implant/explosive/deadman/get_data()
	. = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Kumar Arms ZX-01a \"Obscuration\" Class Implant<BR>
<b>Life:</b> Activates upon death.<BR>
<b>Important Notes:</b> Explodes<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a compact, electrically detonated explosive that detonates upon receiving a specially encoded signal or upon host death.<BR>
<b>Special Features:</b> Explodes<BR>
<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}

/obj/item/implant/explosive/deadman/attack_self(mob/user)
	return

/obj/item/implant/explosive/deadman/hear(var/msg)
	return

/obj/item/implant/explosive/deadman/process()
	if(malfunction)
		STOP_PROCESSING(SSprocessing, src)
		return
	if (!implanted)
		return
	var/mob/M = imp_in

	if(M.stat == DEAD)
		activate()

/obj/item/implant/explosive/deadman/activate(var/cause)
	small_countdown(src)
	STOP_PROCESSING(SSprocessing, src)

/obj/item/implant/explosive/deadman/small_boom()
	if(imp_in)
		explosion(get_turf(src), -1, 0, 1, 6)
		imp_in.gib()
		qdel(src)

/obj/item/implant/explosive/deadman/implanted(mob/source)
	START_PROCESSING(SSprocessing, src)
	return TRUE

/obj/item/implant/explosive/deadman/emp_act(severity)
	. = ..()

	if(malfunction)
		return

	malfunction = MALFUNCTION_TEMPORARY
	switch (severity)
		if(EMP_LIGHT)
			if(prob(5))
				small_countdown()
			else if (prob(10))
				meltdown()
		if(EMP_HEAVY)
			if(prob(10))
				small_countdown()
			else if (prob(30))
				meltdown()

#undef MALFUNCTION_TEMPORARY
#undef MALFUNCTION_PERMANENT

/obj/item/implantcase/explosive
	name = "implant case - 'explosive'"
	imp = /obj/item/implant/explosive

/obj/item/implantcase/explosive/deadman
	name = "glass case - 'deadman'"
	imp = /obj/item/implant/explosive/deadman

/obj/item/implanter/explosive
	name = "implanter (E)"
	imp = /obj/item/implant/explosive

/obj/item/implanter/explosive/deadman
	name = "implanter (D)"
	imp = /obj/item/implant/explosive/deadman
