/mob/living/bot/medbot
	name = "Medbot"
	desc = "A little medical robot. He looks somewhat underwhelmed."
	icon_state = "medibot0"
	req_one_access = list(access_medical, access_robotics)

	var/skin = null //Set to "tox", "ointment" or "o2" for the other two firstaid kits.
	botcard_access = list(access_medical, access_morgue, access_surgery, access_pharmacy, access_virology, access_genetics)

	//AI vars
	var/frustration = 0
	var/list/path = list()
	var/mob/living/carbon/human/patient = null
	var/mob/ignored = list() // Used by emag
	var/last_newpatient_speak = 0
	var/message = null
	var/speech = 0

	//Healing vars
	var/obj/item/reagent_containers/glass/reagent_glass = null //Can be set to draw from this for reagents.
	var/currently_healing = 0
	var/injection_amount = 10 //How much reagent do we inject at a time?
	var/heal_threshold = 10 //Start healing when they have this much damage in a category
	var/use_beaker = 0 //Use reagents in beaker instead of default treatment agents.
	var/treatment_brute = /singleton/reagent/tricordrazine
	var/treatment_oxy = /singleton/reagent/tricordrazine
	var/treatment_fire = /singleton/reagent/tricordrazine
	var/treatment_tox = /singleton/reagent/tricordrazine
	var/treatment_emag = /singleton/reagent/toxin
	var/declare_treatment = 0 //When attempting to treat a patient, should it notify everyone wearing medhuds?


/mob/living/bot/medbot/Destroy()
	QDEL_NULL(reagent_glass)
	return ..()

/mob/living/bot/medbot/think()
	..()
	if(!on)
		return

	if(speech && prob(1))
		say(message)

	if(patient)
		if(Adjacent(patient))
			if(!currently_healing)
				INVOKE_ASYNC(src, PROC_REF(UnarmedAttack), patient)
		else
			if(path.len && (get_dist(patient, path[path.len]) > 2)) // We have a path, but it's off
				path = list()
			if(!path.len && (get_dist(src, patient) > 1))
				spawn(0)
					path = AStar(loc, get_turf(patient), /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 30, id = botcard)
					if(!path)
						path = list()
			if(path.len)
				step_to(src, path[1])
				path -= path[1]
				++frustration
			if(get_dist(src, patient) > 7 || frustration > 8)
				patient = null
	else
		for(var/mob/living/carbon/human/H in view(7, src)) // Time to find a patient!
			if(valid_healing_target(H))
				patient = H
				frustration = 0
				if(last_newpatient_speak + 300 < world.time)
					var/message = pick("Hey, [H.name]! Hold on, I'm coming.", "Wait [H.name]! I want to help!", "[H.name], you appear to be injured!")
					say(message)
					custom_emote(VISIBLE_MESSAGE, "points at [H.name].")
					last_newpatient_speak = world.time
				break

/mob/living/bot/medbot/UnarmedAttack(var/mob/living/carbon/human/H, var/proximity)
	. = ..()
	if(!.)
		return

	if(!on)
		return

	if(!istype(H))
		return

	if(H.stat == DEAD)
		if(pAI)
			to_chat(pAI.pai, SPAN_WARNING("\The [H] is dead, you cannot help them now."))
			return
		var/death_message = pick("No! NO!", "Live, damnit! LIVE!", "I... I've never lost a patient before. Not today, I mean.")
		say(death_message)
		patient = null
		return

	var/t = valid_healing_target(H)
	if(!t)
		var/message = pick("All patched up!", "An apple a day keeps me away.", "Feel better soon!")
		say(message)
		patient = null
		return

	icon_state = "medibots"
	visible_message("<span class='warning'>[src] is trying to inject [H]!</span>")
	if(declare_treatment)
		var/area/location = get_area(src)
		broadcast_medical_hud_message("[src] is treating <b>[H]</b> in <b>[location]</b>", src)
	currently_healing = 1
	update_icon()
	if(do_mob(src, H, 30))
		if(t == 1)
			reagent_glass.reagents.trans_to_mob(H, injection_amount, CHEM_BLOOD)
		else
			H.reagents.add_reagent(t, injection_amount)
		visible_message("<span class='warning'>[src] injects [H] with the syringe!</span>")
	currently_healing = 0
	update_icon()

/mob/living/bot/medbot/update_icon()
	cut_overlays()
	if(skin)
		add_overlay("medskin_[skin]")
	if(currently_healing)
		icon_state = "medibots"
	else
		icon_state = "medibot[on]"

/mob/living/bot/medbot/attack_hand(var/mob/user)
	if (!has_ui_access(user))
		to_chat(user, "<span class='warning'>The unit's interface refuses to unlock!</span>")
		return

	var/dat = ""
	dat += "Status: <A href='?src=\ref[src];power=1'>[on ? "On" : "Off"]</A><BR>"
	dat += "Maintenance panel is [open ? "opened" : "closed"]<BR>"
	dat += "Beaker: "
	if (reagent_glass)
		dat += "<A href='?src=\ref[src];eject=1'>Loaded \[[reagent_glass.reagents.total_volume]/[reagent_glass.reagents.maximum_volume]\]</a>"
	else
		dat += "None Loaded"
	dat += "<br>Behaviour controls are [locked ? "locked" : "unlocked"]<hr>"
	if(!locked || issilicon(user))
		dat += "<TT>Healing Threshold: "
		dat += "<a href='?src=\ref[src];adj_threshold=-10'>--</a> "
		dat += "<a href='?src=\ref[src];adj_threshold=-5'>-</a> "
		dat += "[heal_threshold] "
		dat += "<a href='?src=\ref[src];adj_threshold=5'>+</a> "
		dat += "<a href='?src=\ref[src];adj_threshold=10'>++</a>"
		dat += "</TT><br>"

		dat += "<TT>Injection Level: "
		dat += "<a href='?src=\ref[src];adj_inject=-5'>-</a> "
		dat += "[injection_amount] "
		dat += "<a href='?src=\ref[src];adj_inject=5'>+</a> "
		dat += "</TT><br>"

		dat += "Reagent Source: "
		dat += "<a href='?src=\ref[src];use_beaker=1'>[use_beaker ? "Loaded Beaker (When available)" : "Internal Synthesizer"]</a><br>"

		dat += "Treatment report is [declare_treatment ? "on" : "off"]. <a href='?src=\ref[src];declaretreatment=[1]'>Toggle</a><br>"
		dat += "The speaker switch is [speech ? "on" : "off"]. <a href='?src=\ref[src];speaker=[1]'>Toggle</a><br>"
		dat += "Message is [message ? message : "unset"]. <a href='?src=\ref[src];msg=[1]'>Set</a><br>"

	var/datum/browser/bot_win = new(user, "automed", "Automatic Medibot v1.2 Controls")
	bot_win.set_content(dat)
	bot_win.open()

/mob/living/bot/medbot/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/reagent_containers/glass))
		if(locked)
			to_chat(user, "<span class='notice'>You cannot insert a beaker because the panel is locked.</span>")
			return
		if(!isnull(reagent_glass))
			to_chat(user, "<span class='notice'>There is already a beaker loaded.</span>")
			return

		user.drop_from_inventory(O,src)
		reagent_glass = O
		to_chat(user, "<span class='notice'>You insert [O].</span>")
		return 1
	else
		..()

/mob/living/bot/medbot/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)

	if (!has_ui_access(usr))
		to_chat(usr, "<span class='warning'>Insufficient permissions.</span>")
		return

	if (href_list["power"])
		if (on)
			turn_off()
		else
			turn_on()

	else if(href_list["adj_threshold"] && (!locked || issilicon(usr)))
		var/adjust_num = text2num(href_list["adj_threshold"])
		heal_threshold += adjust_num
		if(heal_threshold < 5)
			heal_threshold = 5
		if(heal_threshold > 75)
			heal_threshold = 75

	else if(href_list["adj_inject"] && (!locked || issilicon(usr)))
		var/adjust_num = text2num(href_list["adj_inject"])
		injection_amount += adjust_num
		if(injection_amount < 5)
			injection_amount = 5
		if(injection_amount > 15)
			injection_amount = 15

	else if(href_list["use_beaker"] && (!locked || issilicon(usr)))
		use_beaker = !use_beaker

	else if (href_list["eject"] && (!isnull(reagent_glass)))
		if(!locked)
			reagent_glass.forceMove(get_turf(src))
			reagent_glass = null
		else
			to_chat(usr, "<span class='notice'>You cannot eject the beaker because the panel is locked.</span>")

	else if (href_list["declaretreatment"] && (!locked || issilicon(usr)))
		declare_treatment = !declare_treatment

	else if (href_list["msg"] && (!locked || issilicon(usr)))
		var/I = sanitize(input(usr,"What will this medbot say?", "Set Message") as text|null)
		if(!I)
			return
		message = I
		speech = 1

	else if (href_list["speaker"] && (!locked || issilicon(usr)))
		speech = !speech

	attack_hand(usr)
	return

/mob/living/bot/medbot/emag_act(var/remaining_uses, var/mob/user)
	. = ..()
	if(!emagged)
		if(user)
			to_chat(user, "<span class='warning'>You short out [src]'s reagent synthesis circuits.</span>")
		visible_message("<span class='warning'>[src] buzzes oddly!</span>")
		flick("medibot_spark", src)
		patient = null
		currently_healing = 0
		emagged = 1
		on = 1
		update_icon()
		. = 1
	ignored |= user

/mob/living/bot/medbot/explode()
	on = 0
	visible_message("<span class='danger'>[src] blows apart!</span>")
	var/turf/Tsec = get_turf(src)

	new /obj/item/storage/firstaid(Tsec)
	new /obj/item/device/assembly/prox_sensor(Tsec)
	new /obj/item/device/healthanalyzer(Tsec)
	if (prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)

	if(reagent_glass)
		reagent_glass.forceMove(Tsec)
		reagent_glass = null

	spark(src, 3, alldirs)

	qdel(src)
	return

/mob/living/bot/medbot/turn_off()
	patient = null
	frustration = 0
	currently_healing = 0
	..()

/mob/living/bot/medbot/proc/valid_healing_target(var/mob/living/carbon/human/H)
	if(H.stat == DEAD) // He's dead, Jim
		return null

	if(isipc(H))
		return null

	if(H in ignored)
		return null

	if(emagged)
		return treatment_emag

	// If they're injured, we're using a beaker, and they don't have on of the chems in the beaker
	if(reagent_glass && use_beaker && ((H.getBruteLoss() >= heal_threshold) || (H.getToxLoss() >= heal_threshold) || (H.getToxLoss() >= heal_threshold) || (H.getOxyLoss() >= (heal_threshold + 15))))
		for(var/_R in reagent_glass.reagents.reagent_volumes)
			var/singleton/reagent/R = GET_SINGLETON(_R)
			if(!H.reagents.has_reagent(R))
				return TRUE
			continue

	if((H.getBruteLoss() >= heal_threshold) && (!H.reagents.has_reagent(treatment_brute)))
		return treatment_brute //If they're already medicated don't bother!

	if((H.getOxyLoss() >= (15 + heal_threshold)) && (!H.reagents.has_reagent(treatment_oxy)))
		return treatment_oxy

	if((H.getFireLoss() >= heal_threshold) && (!H.reagents.has_reagent(treatment_fire)))
		return treatment_fire

	if((H.getToxLoss() >= heal_threshold) && (!H.reagents.has_reagent(treatment_tox)))
		return treatment_tox

/* Construction */

/obj/item/storage/firstaid/attackby(var/obj/item/robot_parts/S, mob/user as mob)
	if ((!istype(S, /obj/item/robot_parts/l_arm)) && (!istype(S, /obj/item/robot_parts/r_arm)))
		..()
		return

	if(contents.len >= 1)
		to_chat(user, "<span class='notice'>You need to empty [src] out first.</span>")
		return

	var/obj/item/firstaid_arm_assembly/A = new /obj/item/firstaid_arm_assembly
	if(istype(src, /obj/item/storage/firstaid/fire))
		A.skin = "ointment"
	else if(istype(src, /obj/item/storage/firstaid/toxin))
		A.skin = "tox"
	else if(istype(src, /obj/item/storage/firstaid/o2))
		A.skin = "o2"

	if(A.skin)
		A.add_overlay("kit_skin_[A.skin]")

	qdel(S)
	user.put_in_hands(A)
	to_chat(user, "<span class='notice'>You add the robot arm to the first aid kit.</span>")
	qdel(src)

/obj/item/firstaid_arm_assembly
	name = "first aid/robot arm assembly"
	desc = "A first aid kit with a robot arm permanently grafted to it."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "firstaid_arm"
	var/build_step = 0
	var/created_name = "Medibot" //To preserve the name if it's a unique medbot I guess
	var/skin = null //Same as medbot, set to tox or ointment for the respective kits.
	w_class = ITEMSIZE_NORMAL

/obj/item/firstaid_arm_assembly/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(W.ispen())
		var/t = sanitizeSafe(input(user, "Enter new robot name", name, created_name), MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, user) && loc != user)
			return
		created_name = t
	else
		switch(build_step)
			if(0)
				if(istype(W, /obj/item/device/healthanalyzer))
					user.drop_from_inventory(W,get_turf(src))
					qdel(W)
					build_step++
					to_chat(user, "<span class='notice'>You add the health sensor to [src].</span>")
					name = "First aid/robot arm/health analyzer assembly"
					add_overlay("na_scanner")
					return 1

			if(1)
				if(isprox(W))
					user.drop_from_inventory(W,get_turf(src))
					qdel(W)
					to_chat(user, "<span class='notice'>You complete the Medibot! Beep boop.</span>")
					var/turf/T = get_turf(src)
					var/mob/living/bot/medbot/S = new /mob/living/bot/medbot(T)
					S.skin = skin
					S.name = created_name
					S.update_icon()
					qdel(src)
					return 1
