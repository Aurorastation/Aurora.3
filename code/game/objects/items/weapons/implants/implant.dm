#define MALFUNCTION_TEMPORARY 1
#define MALFUNCTION_PERMANENT 2


/obj/item/implant
	name = "implant"
	icon = 'icons/obj/device.dmi'
	icon_state = "implant"
	w_class = 1
	var/implanted = null
	var/mob/imp_in = null
	var/obj/item/organ/external/part = null
	var/implant_color = "b"
	var/allow_reagents = 0
	var/malfunction = 0

/obj/item/implant/Initialize()
	. = ..()
	implants += src

/obj/item/implant/proc/trigger(emote, source as mob)
	return

/obj/item/implant/proc/activate()
	return

	// What does the implant do upon injection?
	// return 0 if the implant fails (ex. Revhead and loyalty implant.)
	// return 1 if the implant succeeds (ex. Nonrevhead and loyalty implant.)
/obj/item/implant/proc/implanted(var/mob/source, mob/user)
	return 1

/obj/item/implant/proc/get_data()
	return "No information available"

/obj/item/implant/proc/hear(message, source as mob)
	return

/obj/item/implant/proc/islegal()
	return 0

/obj/item/implant/proc/meltdown()	//breaks it down, making implant unrecongizible
	to_chat(imp_in, "<span class='warning'>You feel something melting inside [part ? "your [part.name]" : "you"]!</span>")
	if (part)
		part.take_damage(burn = 15, used_weapon = "Electronics meltdown")
	else
		var/mob/living/M = imp_in
		M.apply_damage(15,BURN)
	name = "melted implant"
	desc = "Charred circuit in melted plastic case. Wonder what that used to be..."
	icon_state = "implant_melted"
	malfunction = MALFUNCTION_PERMANENT

/obj/item/implant/Destroy()
	if(part)
		part.implants.Remove(src)
	STOP_PROCESSING(SSprocessing, src)
	implants -= src
	return ..()

/obj/item/implant/proc/removed()
	imp_in = null
	if(part)
		part.implants -= src
		part = null
	implanted = 0

/obj/item/implant/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/implanter))
		var/obj/item/implanter/implanter = I
		if(implanter.imp)
			to_chat(user, SPAN_NOTICE("\The [implanter] already has an implant loaded."))
			return // It's full.
		user.drop_from_inventory(src)
		forceMove(implanter)
		implanter.imp = src
		implanter.update()
	else
		..()

/obj/item/implant/tracking
	name = "tracking implant"
	desc = "Track with this."
	var/id = 1.0


/obj/item/implant/tracking/get_data()
	. = {"<b>Implant Specifications:</b><BR>
<b>Name:</b> Tracking Beacon<BR>
<b>Life:</b> 10 minutes after death of host<BR>
<b>Important Notes:</b> None<BR>
<HR>
<b>Implant Details:</b> <BR>
<b>Function:</b> Continuously transmits low power signal. Useful for tracking.<BR>
<b>Special Features:</b><BR>
<i>Neuro-Safe</i>- Specialized shell absorbs excess voltages self-destructing the chip if
a malfunction occurs thereby securing safety of subject. The implant will melt and
disintegrate into bio-safe elements.<BR>
<b>Integrity:</b> Gradient creates slight risk of being overcharged and frying the
circuitry. As a result neurotoxins can cause massive damage.<HR>
Implant Specifics:<BR>"}

/obj/item/implant/tracking/emp_act(severity)
	if (malfunction)	//no, dawg, you can't malfunction while you are malfunctioning
		return
	malfunction = MALFUNCTION_TEMPORARY

	var/delay = 20
	switch(severity)
		if(1)
			if(prob(60))
				meltdown()
		if(2)
			delay = rand(5*60*10,15*60*10)	//from 5 to 15 minutes of free time

	spawn(delay)
		malfunction--


/obj/item/implant/dexplosive
	name = "explosive"
	desc = "And boom goes the weasel."
	icon_state = "implant_evil"

/obj/item/implant/dexplosive/get_data()
	. = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Robust Corp RX-78 Employee Management Implant<BR>
<b>Life:</b> Activates upon death.<BR>
<b>Important Notes:</b> Explodes<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a compact, electrically detonated explosive that detonates upon receiving a specially encoded signal or upon host death.<BR>
<b>Special Features:</b> Explodes<BR>
<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}

/obj/item/implant/dexplosive/trigger(emote, source as mob)
	if(emote == "deathgasp")
		src.activate("death")

/obj/item/implant/dexplosive/activate(var/cause)
	if((!cause) || (!src.imp_in))	return 0
	explosion(src, -1, 0, 2, 3, 0)//This might be a bit much, dono will have to see.
	if(src.imp_in)
		src.imp_in.gib()

/obj/item/implant/dexplosive/islegal()
	return 0

//BS12 Explosive
/obj/item/implant/explosive
	name = "explosive implant"
	desc = "A military grade micro bio-explosive. Highly dangerous."
	var/elevel = "Localized Limb"
	var/phrase
	var/setup_done = FALSE //Have we set this yet?
	icon_state = "implant_evil"

/obj/item/implant/explosive/Initialize()
	. = ..()
	phrase = "You are [pick(adjectives)]"

/obj/item/implant/explosive/get_data()
	. = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Robust Corp RX-78 Intimidation Class Implant<BR>
<b>Life:</b> Activates upon codephrase.<BR>
<b>Important Notes:</b> Explodes<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a compact, electrically detonated explosive that detonates upon receiving a specially encoded signal or upon host death.<BR>
<b>Special Features:</b> Explodes. Explosion severity can be altered.<BR>
<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}

/obj/item/implant/explosive/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/implanter))
		var/obj/item/implanter/implanter = I
		if(implanter.imp)
			to_chat(user, SPAN_NOTICE("\The [implanter] already has an implant loaded."))
			return // It's full.
		if(!setup_done)
			var/choice = alert("\The [src]'s default settings have not been changed. Continue?", "Ready for Implantation?", "Yes", "Cancel")
			if(choice == "Cancel")
				return
		to_chat(user, "<B>You load \the [src] into \the [I]. The current setting is \"[elevel]\" and the current phrase is \"[phrase]\".</B>")
		user.drop_from_inventory(src)
		forceMove(implanter)
		implanter.imp = src
		implanter.update()
	else
		..()

/obj/item/implant/explosive/hear_talk(mob/M, msg)
	hear(msg)

/obj/item/implant/explosive/hear(var/msg)
	var/list/replacechars = list("'" = "","\"" = "",">" = "","<" = "","(" = "",")" = "")
	msg = replace_characters(msg, replacechars)
	if(findtext(msg,phrase))
		activate()

/obj/item/implant/explosive/activate()
	if(malfunction == MALFUNCTION_PERMANENT)
		return

	if(!imp_in)
		small_countdown()
		return

	message_admins("Explosive implant triggered in [imp_in] ([imp_in.key]). (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[imp_in.x];Y=[imp_in.y];Z=[imp_in.z]'>JMP</a>) ")
	log_game("Explosive implant triggered in [imp_in] ([imp_in.key]).")
	if(ishuman(imp_in))
		var/mob/living/carbon/human/T = imp_in
		if(elevel == "Localized Limb" && part)
			small_countdown()
			return	//to avoid hotspot_expose. 
		if(elevel == "Destroy Body")
			explosion(get_turf(T), -1, 0, 1, 6)
			T.gib()
		if(elevel == "Full Explosion")
			explosion_spread(get_turf(T), rand(8,13))
			T.gib()
	else if(ismob(imp_in))
		var/mob/M = imp_in
		M.gib()
		
	var/turf/F = get_turf(imp_in)	
	if(F)
		F.hotspot_expose(3500,125)
	qdel(src)

/obj/item/implant/explosive/proc/small_countdown()
	if(!imp_in)
		visible_message(SPAN_WARNING("Something begins beeping..."))
	if(ishuman(imp_in))
		var/message = "Something beeps inside of [imp_in][part ? "'s [part.name]" : ""]..." //for some reason SPAN_X and span() both hate having this in-line
		imp_in.visible_message(SPAN_WARNING(message))
	else if(ismob(imp_in))
		imp_in.visible_message(SPAN_WARNING("Something beeps inside of [imp_in]..."))
	playsound(loc, 'sound/items/countdown.ogg', 75, 1, -3)
	addtimer(CALLBACK(src, .proc/small_boom), 25)

/obj/item/implant/explosive/proc/small_boom()
	if(!imp_in)
		explosion(get_turf(src), -1, 0, 2, 4)
	if(ishuman(imp_in) && part)
		//No tearing off these parts since it's pretty much killing. Mangle them. 
		if(part.vital && !istype(part, /obj/item/organ/external/head)) //Head explodes
			part.createwound(BRUISE, 70)
			part.add_pain(50)
			imp_in.visible_message(SPAN_WARNING("[imp_in]'s [part.name] bursts open with a horrible ripping noise!"),
									SPAN_DANGER("Your [part.name] bursts open with a horrible ripping noise!"),
									SPAN_WARNING("You hear a horrible ripping noise."))
		else
			part.droplimb(0,DROPLIMB_BLUNT)
		playsound(get_turf(imp_in), BP_IS_ROBOTIC(part) ? 'sound/effects/meteorimpact.ogg' : 'sound/effects/splat.ogg')
	else if(ismob(imp_in))
		var/mob/M = imp_in
		M.gib()	//Simple mobs just get got
	qdel(src)

/proc/explosion_spread(turf/epicenter, power, adminlog = 1, z_transfer = UP|DOWN)
	var/datum/explosiondata/data = new
	data.epicenter = epicenter
	data.rec_pow = power
	data.spreading = TRUE
	data.adminlog = adminlog
	data.z_transfer = z_transfer
	SSexplosives.queue(data)

/obj/item/implant/explosive/implanted(mob/source, mob/user)
	if(user.mind)
		user.mind.store_memory("\The [src] in [source] can be activated by saying something containing the phrase ''[phrase]'', <B>say [phrase]</B> to attempt to activate.", 0, 0)
	to_chat(usr, "\The [src] in [source] can be activated by saying something containing the phrase ''[phrase]'', <B>say [phrase]</B> to attempt to activate.")
	return TRUE

/obj/item/implant/explosive/attack_self(mob/user)
	elevel = alert("What sort of explosion would you prefer?", "Implant Intent", "Localized Limb", "Destroy Body", "Full Explosion")
	phrase = input("Choose activation phrase:") as text
	var/list/replacechars = list("'" = "","\"" = "",">" = "","<" = "","(" = "",")" = "")
	phrase = replace_characters(phrase, replacechars)
	user.mind.store_memory("\The [src] can be activated by saying something containing the phrase ''[phrase]'', <B>say [phrase]</B> to attempt to activate.", 0, 0)
	to_chat(user, "\The [src] can be activated by saying something containing the phrase ''[phrase]'', <B>say [phrase]</B> to attempt to activate.")
	setup_done = TRUE

/obj/item/implant/explosive/emp_act(severity)
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
	addtimer(CALLBACK(src, .proc/self_correct), 20)

/obj/item/implant/explosive/proc/self_correct()
	malfunction--

/obj/item/implant/explosive/islegal()
	return FALSE

/obj/item/implant/explosive/New()
	..()
	listening_objects += src

/obj/item/implant/explosive/Destroy()
	listening_objects -= src
	return ..()


/obj/item/implant/chem
	name = "chemical implant"
	desc = "Injects things."
	allow_reagents = 1

/obj/item/implant/chem/get_data()
	. = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Robust Corp MJ-420 Prisoner Management Implant<BR>
<b>Life:</b> Deactivates upon death but remains within the body.<BR>
<b>Important Notes: Due to the system functioning off of nutrients in the implanted subject's body, the subject<BR>
will suffer from an increased appetite.</B><BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a small capsule that can contain various chemicals. Upon receiving a specially encoded signal<BR>
the implant releases the chemicals directly into the blood stream.<BR>
<b>Special Features:</b>
<i>Micro-Capsule</i>- Can be loaded with any sort of chemical agent via the common syringe and can hold 50 units.<BR>
Can only be loaded while still in its original case.<BR>
<b>Integrity:</b> Implant will last so long as the subject is alive. However, if the subject suffers from malnutrition,<BR>
the implant may become unstable and either pre-maturely inject the subject or simply break."}


/obj/item/implant/chem/New()
	..()
	var/datum/reagents/R = new/datum/reagents(50)
	reagents = R
	R.my_atom = src


/obj/item/implant/chem/trigger(emote, source as mob)
	if(emote == "deathgasp")
		src.activate(src.reagents.total_volume)
	return


/obj/item/implant/chem/activate(var/cause)
	if((!cause) || (!src.imp_in))	return 0
	var/mob/living/carbon/R = src.imp_in
	src.reagents.trans_to_mob(R, cause, CHEM_BLOOD)
	to_chat(R, "You hear a faint *beep*.")
	if(!src.reagents.total_volume)
		to_chat(R, "You hear a faint click from your chest.")
		spawn(0)
			qdel(src)

/obj/item/implant/chem/emp_act(severity)
	if (malfunction)
		return
	malfunction = MALFUNCTION_TEMPORARY

	switch(severity)
		if(1)
			if(prob(60))
				activate(20)
		if(2)
			if(prob(30))
				activate(5)

	spawn(20)
		malfunction--

/obj/item/implant/mindshield
	name = "mind shield implant"
	desc = "A controversial and debatably unethical neurostimulator and autohypnosis device. When implanted against the amygdala, it ensures the host maintains a consistent personality, preventing outside interference through brainwashing or hypnotic suggestion."

/obj/item/implant/mindshield/get_data()
	. = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> [current_map.company_name] Employee Management Implant<BR>
<b>Life:</b> Ten years.<BR>
<b>Important Notes:</b> Personnel injected with this device tend to be much more resistant to brain washing and other external influences.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a small pod of nanobots that manipulate the host's mental functions.<BR>
<b>Special Features:</b> Will prevent and cure most forms of brainwashing.<BR>
<b>Integrity:</b> Implant will last so long as the nanobots are inside the bloodstream."}

/obj/item/implant/mindshield/emp_act(severity)
	if (malfunction)
		return
	malfunction = MALFUNCTION_TEMPORARY

	activate("emp")
	if(severity == 1)
		if(prob(50))
			meltdown()
		else if (prob(50))
			malfunction = MALFUNCTION_PERMANENT
		return
	spawn(20)
		malfunction--

/obj/item/implant/mindshield/ipc
	name = "software protection chip"
	desc = "A dedicated processor core designed to identify and terminate malignant software, ensuring a synthetics protection from outside hacking."

/obj/item/implant/mindshield/ipc/implanted(mob/M)
	if (!isipc(M))
		return

	..()

/obj/item/implant/mindshield/sol
	name = "loyalty implant"
	desc = "Makes you loyal to the Sol Alliance, or to a certain individual."

/obj/item/implant/mindshield/sol/implanted(mob/M)
	if(!istype(M, /mob/living/carbon/human))	return 0
	var/mob/living/carbon/human/H = M
	var/datum/antagonist/antag_data = get_antag_data(H.mind.special_role)
	if(antag_data && (antag_data.flags & ANTAG_IMPLANT_IMMUNE))
		H.visible_message("[H] seems to resist the implant!", "You feel the tendrils of the Sol Alliance try to invade your mind!")
		return 0
	else
		clear_antag_roles(H.mind, 1)
		to_chat(H, "<span class='notice'>You feel a surge of loyalty towards Admiral Michael Frost.</span>")
	return 1

/obj/item/implant/adrenalin
	name = "adrenalin"
	desc = "Removes all stuns and knockdowns."
	var/uses

/obj/item/implant/adrenalin/get_data()
	. = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Cybersun Industries Adrenalin Implant<BR>
<b>Life:</b> Five days.<BR>
<b>Important Notes:</b> <font color='red'>Illegal</font><BR>
<HR>
<b>Implant Details:</b> Subjects injected with implant can activate a massive injection of adrenalin.<BR>
<b>Function:</b> Contains nanobots to stimulate body to mass-produce Adrenalin.<BR>
<b>Special Features:</b> Will prevent and cure most forms of brainwashing.<BR>
<b>Integrity:</b> Implant can only be used three times before the nanobots are depleted."}


/obj/item/implant/adrenalin/trigger(emote, mob/source as mob)
	if (src.uses < 1)
		return 0
	if (emote == "pale")
		src.uses--
		to_chat(source, "<span class='notice'>You feel a sudden surge of energy!</span>")
		source.SetStunned(0)
		source.SetWeakened(0)
		source.SetParalysis(0)


/obj/item/implant/adrenalin/implanted(mob/source)
	source.mind.store_memory("A implant can be activated by using the pale emote, <B>say *pale</B> to attempt to activate.", 0, 0)
	to_chat(source, "The implanted freedom implant can be activated by using the pale emote, <B>say *pale</B> to attempt to activate.")
	return 1


/obj/item/implant/death_alarm
	name = "death alarm implant"
	desc = "An alarm which monitors host vital signs and transmits a radio message upon death."
	var/mobname = "Will Robinson"

/obj/item/implant/death_alarm/get_data()
	. = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> [current_map.company_name] \"Profit Margin\" Class Employee Lifesign Sensor<BR>
<b>Life:</b> Activates upon death.<BR>
<b>Important Notes:</b> Alerts crew to crewmember death.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a compact radio signaler that triggers when the host's lifesigns cease.<BR>
<b>Special Features:</b> Alerts crew to crewmember death.<BR>
<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}

/obj/item/implant/death_alarm/process()
	if (!implanted)
		return
	var/mob/M = imp_in

	if(QDELETED(M)) // If the mob got gibbed
		M = null
		activate()
	else if(M.stat == 2)
		activate("death")

/obj/item/implant/death_alarm/activate(var/cause)
	var/mob/M = imp_in
	var/area/t = get_area(M)
	switch (cause)
		if("death")
			var/obj/item/device/radio/headset/a = new /obj/item/device/radio/headset(null)
			if(istype(t, /area/syndicate_station) || istype(t, /area/syndicate_mothership) || istype(t, /area/shuttle/syndicate_elite) )
				//give the syndies a bit of stealth
				a.autosay("[mobname] has died in Space!", "[mobname]'s Death Alarm")
			else
				a.autosay("[mobname] has died in [t.name]!", "[mobname]'s Death Alarm")
			qdel(a)
			STOP_PROCESSING(SSprocessing, src)
		if ("emp")
			var/obj/item/device/radio/headset/a = new /obj/item/device/radio/headset(null)
			var/name = prob(50) ? t.name : pick(teleportlocs)
			a.autosay("[mobname] has died in [name]!", "[mobname]'s Death Alarm")
			qdel(a)
		else
			var/obj/item/device/radio/headset/a = new /obj/item/device/radio/headset(null)
			a.autosay("[mobname] has died-zzzzt in-in-in...", "[mobname]'s Death Alarm")
			qdel(a)
			STOP_PROCESSING(SSprocessing, src)

/obj/item/implant/death_alarm/emp_act(severity)			//for some reason alarms stop going off in case they are emp'd, even without this
	if (malfunction)		//so I'm just going to add a meltdown chance here
		return
	malfunction = MALFUNCTION_TEMPORARY

	activate("emp")	//let's shout that this dude is dead
	if(severity == 1)
		if(prob(40))	//small chance of obvious meltdown
			meltdown()
		else if (prob(60))	//but more likely it will just quietly die
			malfunction = MALFUNCTION_PERMANENT
		STOP_PROCESSING(SSprocessing, src)

	spawn(20)
		malfunction--

/obj/item/implant/death_alarm/implanted(mob/source as mob)
	mobname = source.real_name
	START_PROCESSING(SSprocessing, src)
	return 1

/obj/item/implant/compressed
	name = "compressed matter implant"
	desc = "Based on compressed matter technology, can store a single item."
	icon_state = "implant_evil"
	var/activation_emote = "sigh"
	var/obj/item/scanned = null

/obj/item/implant/compressed/get_data()
	. = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> [current_map.company_name] \"Profit Margin\" Class Employee Lifesign Sensor<BR>
<b>Life:</b> Activates upon death.<BR>
<b>Important Notes:</b> Alerts crew to crewmember death.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a compact radio signaler that triggers when the host's lifesigns cease.<BR>
<b>Special Features:</b> Alerts crew to crewmember death.<BR>
<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}

/obj/item/implant/compressed/trigger(emote, mob/source as mob)
	if (src.scanned == null)
		return 0

	if (emote == src.activation_emote)
		to_chat(source, "The air glows as \the [src.scanned.name] uncompresses.")
		activate()

/obj/item/implant/compressed/activate()
	var/turf/t = get_turf(src)
	if (imp_in)
		imp_in.put_in_hands(scanned)
	else
		scanned.forceMove(t)
	qdel(src)

/obj/item/implant/compressed/implanted(mob/source as mob)
	src.activation_emote = input("Choose activation emote:") in list("blink", "blink_r", "eyebrow", "chuckle", "twitch_s", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	if (source.mind)
		source.mind.store_memory("Compressed matter implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.", 0, 0)
	to_chat(source, "The implanted compressed matter implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.")
	return 1

/obj/item/implant/compressed/islegal()
	return 0

/obj/item/implant/aggression
	name = "aggression implant"
	desc = "An implant that microdoses its user with chemicals that induce anger."

/obj/item/implant/aggression/get_data()
	. = {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> Aggression Implant<BR>
	<b>Life:</b> N/A.<BR>
	<b>Important Notes:</b> Users injected with this device get increasingly angry to a breaking point. Users tend to expire before the implant does.<BR>
	<HR>
	<b>Implant Details:</b><BR>
	<b>Function:</b> Contains a small pod of nanobots that manipulate the host's mental functions.<BR>
	<b>Integrity:</b> Implant will last so long as the nanobots are inside the bloodstream."}

/obj/item/implant/aggression/implanted(mob/M)
	if(!istype(M, /mob/living/carbon/human))
		return FALSE

	var/mob/living/carbon/human/H = M

	for(var/obj/item/implant/mindshield/I in H)
		if(I.implanted)
			to_chat(H, span("danger", "Rage surges through your body, but the nanobots from your mind shield implant stop it soon after it starts!"))
			return TRUE

	var/datum/antagonist/antag_data = get_antag_data(H.mind.special_role)
	if(antag_data?.flags & ANTAG_IMPLANT_IMMUNE)
		H.visible_message("[H] seems to resist the implant!", "You feel rage overtake your body, but you manage to fend it off by sheer will!")
		log_and_message_admins("[key_name(H)] was implanted by an aggression implant, but was not effected.", H)
	else if(antag_data?.id == MODE_LOYALIST)
		clear_antag_roles(H.mind, 1)
		to_chat(H, span("danger", "You feel a surge of rage override your loyalty!"))
		log_and_message_admins("[key_name(H)] was implanted by an aggression implant, clearing their loyalist status!", H)
	else
		to_chat(H, span("danger", "You feel a surge of rage course through your body and very soul!"))
		log_and_message_admins("[key_name(H)] was implanted by an aggression implant!", H)
	return TRUE

/obj/item/implant/aggression/emp_act(severity)
	if(malfunction)
		return
	malfunction = MALFUNCTION_TEMPORARY

	activate("emp")
	if(severity == 1)
		if(prob(50))
			meltdown()
		else if(prob(50))
			malfunction = MALFUNCTION_PERMANENT
		return
	spawn(20)
		malfunction--
