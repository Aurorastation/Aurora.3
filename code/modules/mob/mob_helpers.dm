// fun if you want to typecast humans/monkeys/etc without writing long path-filled lines.

/proc/issmall(A)
	if(A && istype(A, /mob/living))
		var/mob/living/L = A
		return L.mob_size <= MOB_SMALL
	return 0

/mob/living/proc/isSynthetic()
	return 0

/mob/living/carbon/human/isSynthetic()
	// If they are 100% robotic, they count as synthetic.
	for(var/obj/item/organ/external/E in organs)
		if(!(E.status & ORGAN_ROBOT))
			return 0
	return 1

/mob/living/carbon/human/proc/isFBP()
	return species && (species.appearance_flags & HAS_FBP)

/proc/isMMI(A)
	if(isbrain(A))
		var/mob/living/carbon/brain/B = A
		return istype(B.container, /obj/item/device/mmi)

/mob/living/bot/isSynthetic()
	return 1

/mob/living/silicon/isSynthetic()
	return 1

/mob/proc/isMonkey()
	return 0

/mob/living/carbon/human/isMonkey()
	return istype(species, /datum/species/monkey)


/proc/ishuman_species(A)
	if(istype(A, /mob/living/carbon/human) && (A:get_species() == "Human"))
		return 1
	return 0

/proc/isunathi(A)
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		switch(H.get_species())
			if ("Unathi")
				return 1
			if("Aut'akh Unathi")
				return 1
			if ("Unathi Zombie")
				return 1
	return 0

/proc/isautakh(A)
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H.get_species() == "Aut'akh Unathi")
			return 1
	return 0

/proc/istajara(A)
	if(istype(A, /mob/living/carbon/human))
		switch(A:get_species())
			if ("Tajara")
				return 1
			if("Zhan-Khazan Tajara")
				return 1
			if("M'sai Tajara")
				return 1
			if ("Tajara Zombie")
				return 1
	return 0

/proc/isskrell(A)
	if(istype(A, /mob/living/carbon/human))
		switch(A:get_species())
			if ("Skrell")
				return 1
			if ("Skrell Zombie")
				return 1
	return 0

/proc/isvaurca(A)
	if(istype(A, /mob/living/carbon/human))
		switch(A:get_species())
			if("Vaurca Worker")
				return 1
			if("Vaurca Warrior")
				return 1
			if("Vaurca Breeder")
				return 1
			if("Vaurca Warform")
				return 1
			if("V'krexi")
				return 1
	return 0

/proc/isipc(A)
	. = 0
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		. = H.species && (H.species.flags & IS_MECHANICAL)

/proc/isvox(A)
	if(istype(A, /mob/living/carbon/human))
		switch(A:get_species())
			if ("Vox")
				return 1
			if ("Vox Armalis")
				return 1
	return 0

/mob/proc/is_diona()
	//returns which type of diona we are, or zero
	if (istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/T = src
		if (istype(T.species, /datum/species/diona) || istype(src, /mob/living/carbon/human/diona))
			return DIONA_WORKER

	if (istype(src, /mob/living/carbon/alien/diona))
		return DIONA_NYMPH
	return 0

/proc/isskeleton(A)
	if(istype(A, /mob/living/carbon/human) && (A:get_species() == "Skeleton"))
		return 1
	return 0

/proc/isundead(A)
	if(istype(A, /mob/living/carbon/human))
		switch(A:get_species())
			if ("Skeleton")
				return 1
			if ("Zombie")
				return 1
			if ("Tajara Zombie")
				return 1
			if ("Unathi Zombie")
				return 1
			if ("Skrell Zombie")
				return 1
			if ("Apparition")
				return 1
	return 0

/proc/islesserform(A)
	if(istype(A, /mob/living/carbon/human))
		switch(A:get_species())
			if ("Monkey")
				return 1
			if ("Farwa")
				return 1
			if ("Neaera")
				return 1
			if ("Stok")
				return 1
			if ("V'krexi")
				return 1
	return 0

proc/isdeaf(A)
	if(istype(A, /mob))
		var/mob/M = A
		return (M.sdisabilities & DEAF) || M.ear_deaf
	return 0

proc/iscuffed(A)
	if(istype(A, /mob/living/carbon))
		var/mob/living/carbon/C = A
		if(C.handcuffed)
			return 1
	return 0

proc/hassensorlevel(A, var/level)
	var/mob/living/carbon/human/H = A
	if(istype(H) && istype(H.w_uniform, /obj/item/clothing/under))
		var/obj/item/clothing/under/U = H.w_uniform
		return U.sensor_mode >= level
	return 0

proc/getsensorlevel(A)
	var/mob/living/carbon/human/H = A
	if(istype(H) && istype(H.w_uniform, /obj/item/clothing/under))
		var/obj/item/clothing/under/U = H.w_uniform
		return U.sensor_mode
	return SUIT_SENSOR_OFF

/proc/is_admin(var/mob/user)
	return check_rights(R_ADMIN, 0, user) != 0

/proc/hsl2rgb(h, s, l)
	return //TODO: Implement

/mob/living/proc/is_wizard(exclude_apprentice = FALSE)
	if(exclude_apprentice)
		return mind && mind.assigned_role == "Space Wizard"
	else
		return mind && (mind.assigned_role == "Space Wizard" || mind.assigned_role == "Apprentice")

/mob/proc/is_berserk()
	return FALSE

/mob/proc/is_pacified()
	return FALSE

/*
	Miss Chance
*/

//TODO: Integrate defence zones and targeting body parts with the actual organ system, move these into organ definitions.

//The base miss chance for the different defence zones
var/list/global/base_miss_chance = list(
	BP_HEAD = 70,
	BP_CHEST = 10,
	BP_GROIN = 20,
	BP_L_LEG = 20,
	BP_R_LEG = 20,
	BP_L_ARM = 30,
	BP_R_ARM = 30,
	BP_L_HAND = 50,
	BP_R_HAND = 50,
	BP_L_FOOT = 50,
	BP_R_FOOT = 50
)

//Used to weight organs when an organ is hit randomly (i.e. not a directed, aimed attack).
//Also used to weight the protection value that armour provides for covering that body part when calculating protection from full-body effects.
var/list/global/organ_rel_size = list(
	BP_HEAD = 25,
	BP_CHEST = 70,
	BP_GROIN = 30,
	BP_L_LEG = 25,
	BP_R_LEG = 25,
	BP_L_ARM = 25,
	BP_R_ARM = 25,
	BP_L_HAND = 10,
	BP_R_HAND = 10,
	BP_L_FOOT = 10,
	BP_R_FOOT = 10
)

/proc/check_zone(zone)
	if(!zone)	return BP_CHEST
	switch(zone)
		if(BP_EYES)
			zone = BP_HEAD
		if(BP_MOUTH)
			zone = BP_HEAD
	return zone

// Returns zone with a certain probability. If the probability fails, or no zone is specified, then a random body part is chosen.
// Do not use this if someone is intentionally trying to hit a specific body part.
// Use get_zone_with_miss_chance() for that.
/proc/ran_zone(zone, probability)
	if (zone)
		zone = check_zone(zone)
		if (prob(probability))
			return zone

	var/ran_zone = zone
	while (ran_zone == zone)
		ran_zone = pick (
			organ_rel_size[BP_HEAD]; BP_HEAD,
			organ_rel_size[BP_CHEST]; BP_CHEST,
			organ_rel_size[BP_GROIN]; BP_GROIN,
			organ_rel_size[BP_L_ARM]; BP_L_ARM,
			organ_rel_size[BP_R_ARM]; BP_R_ARM,
			organ_rel_size[BP_L_LEG]; BP_L_LEG,
			organ_rel_size[BP_R_LEG]; BP_R_LEG,
			organ_rel_size[BP_L_HAND]; BP_L_HAND,
			organ_rel_size[BP_R_HAND]; BP_R_HAND,
			organ_rel_size[BP_L_FOOT]; BP_L_FOOT,
			organ_rel_size[BP_R_FOOT]; BP_R_FOOT
		)

	return ran_zone

// Emulates targetting a specific body part, and miss chances
// May return null if missed
// miss_chance_mod may be negative.
/proc/get_zone_with_miss_chance(zone, var/mob/target, var/miss_chance_mod = 0, var/ranged_attack=0)
	zone = check_zone(zone)

	if(!ranged_attack)
		// you cannot miss if your target is prone or restrained
		if(target.buckled || target.lying)
			return zone
		// if your target is being grabbed aggressively by someone you cannot miss either
		for(var/obj/item/grab/G in target.grabbed_by)
			if(G.state >= GRAB_AGGRESSIVE)
				return zone

	var/miss_chance = 10
	if (zone in base_miss_chance)
		miss_chance = base_miss_chance[zone]
	miss_chance = max(miss_chance + miss_chance_mod, 0)
	if(prob(miss_chance))
		if(prob(70))
			return null
		return pick(base_miss_chance)
	return zone


/proc/stars(n, pr)
	if (pr == null)
		pr = 25
	if (pr <= 0)
		return null
	else
		if (pr >= 100)
			return n
	var/te = n
	var/t = ""
	n = length(n)
	var/p = null
	p = 1
	var/intag = 0
	while(p <= n)
		var/char = copytext(te, p, p + 1)
		if (char == "<") //let's try to not break tags
			intag = !intag
		if (intag || char == " " || prob(pr))
			t = text("[][]", t, char)
		else
			t = text("[]*", t)
		if (char == ">")
			intag = !intag
		p++
	return t

proc/slur(phrase, strength = 100)
	phrase = html_decode(phrase)
	var/leng=length(phrase)
	var/counter=length(phrase)
	var/newphrase=""
	var/newletter=""
	while(counter>=1)
		newletter=copytext(phrase,(leng-counter)+1,(leng-counter)+2)
		if(prob(strength))
			if(rand(1,3)==3)
				if(lowertext(newletter)=="o")	newletter="u"
				if(lowertext(newletter)=="s")	newletter="ch"
				if(lowertext(newletter)=="a")	newletter="ah"
				if(lowertext(newletter)=="c")	newletter="k"
			switch(rand(1,15))
				if(1,3,5,8)	newletter="[lowertext(newletter)]"
				if(2,4,6,15)	newletter="[uppertext(newletter)]"
				if(7)	newletter+="'"
		newphrase+="[newletter]";counter-=1
	return newphrase

proc/Gibberish(t, p)//t is the inputted message, and any value higher than 70 for p will cause letters to be replaced instead of added
	/* Turn text into complete gibberish! */
	var/returntext = ""
	for(var/i = 1, i <= length(t), i++)

		var/letter = copytext(t, i, i+1)
		if(prob(50))
			if(p >= 70)
				letter = ""

			for(var/j = 1, j <= rand(0, 2), j++)
				letter += pick("#","@","*","&","%","$","/", "<", ">", ";","*","*","*","*","*","*","*")

		returntext += letter

	return returntext


/proc/ninjaspeak(n)
/*
The difference with stutter is that this proc can stutter more than 1 letter
The issue here is that anything that does not have a space is treated as one word (in many instances). For instance, "LOOKING," is a word, including the comma.
It's fairly easy to fix if dealing with single letters but not so much with compounds of letters./N
*/
	var/te = html_decode(n)
	var/t = ""
	n = length(n)
	var/p = 1
	while(p <= n)
		var/n_letter
		var/n_mod = rand(1,4)
		if(p+n_mod>n+1)
			n_letter = copytext(te, p, n+1)
		else
			n_letter = copytext(te, p, p+n_mod)
		if (prob(50))
			if (prob(30))
				n_letter = text("[n_letter]-[n_letter]-[n_letter]")
			else
				n_letter = text("[n_letter]-[n_letter]")
		else
			n_letter = text("[n_letter]")
		t = text("[t][n_letter]")
		p=p+n_mod
	return sanitize(t)


#define TICKS_PER_RECOIL_ANIM 2
#define PIXELS_PER_STRENGTH_VAL 16

/proc/shake_camera(mob/M, duration, strength = 1)
	set waitfor = 0
	if(!M || !M.client || M.shakecamera || M.stat || isEye(M) || isAI(M))
		return

	M.shakecamera = TRUE
	strength = abs(strength)*PIXELS_PER_STRENGTH_VAL
	var/steps = min(1, Floor(duration/TICKS_PER_RECOIL_ANIM))-1
	animate(M.client, pixel_x = rand(-(strength), strength), pixel_y = rand(-(strength), strength), time = TICKS_PER_RECOIL_ANIM)
	sleep(TICKS_PER_RECOIL_ANIM)
	if(steps)
		for(var/i = 1 to steps)
			animate(M.client, pixel_x = rand(-(strength), strength), pixel_y = rand(-(strength), strength), time = TICKS_PER_RECOIL_ANIM)
			sleep(TICKS_PER_RECOIL_ANIM)
	M?.shakecamera = FALSE
	animate(M.client, pixel_x = 0, pixel_y = 0, time = TICKS_PER_RECOIL_ANIM)

/proc/findname(msg)
	for(var/mob/M in mob_list)
		if (M.real_name == text("[msg]"))
			return 1
	return 0


/mob/proc/abiotic(var/full_body = 0)
	if(full_body && ((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )) || (src.back || src.wear_mask)))
		return 1

	if((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )))
		return 1

	return 0

//converts intent-strings into numbers and back
var/list/intents = list(I_HELP,I_DISARM,I_GRAB,I_HURT)
/proc/intent_numeric(argument)
	if(istext(argument))
		switch(argument)
			if(I_HELP)		return 0
			if(I_DISARM)	return 1
			if(I_GRAB)		return 2
			else			return 3
	else
		switch(argument)
			if(0)			return I_HELP
			if(1)			return I_DISARM
			if(2)			return I_GRAB
			else			return I_HURT

//change a mob's act-intent. Input the intent as a string such as "help" or use "right"/"left
/mob/verb/a_intent_change(input as text)
	set name = "a-intent"
	set hidden = 1

	if(ishuman(src) || isbrain(src) || isslime(src))
		switch(input)
			if(I_HELP,I_DISARM,I_GRAB,I_HURT)
				a_intent = input
			if("right")
				a_intent = intent_numeric((intent_numeric(a_intent)+1) % 4)
			if("left")
				a_intent = intent_numeric((intent_numeric(a_intent)+3) % 4)
		if(hud_used && hud_used.action_intent)
			hud_used.action_intent.icon_state = "intent_[a_intent]"

	else if(isrobot(src))
		switch(input)
			if(I_HELP)
				a_intent = I_HELP
			if(I_HURT)
				a_intent = I_HURT
			if("right","left")
				a_intent = intent_numeric(intent_numeric(a_intent) - 3)
		if(hud_used && hud_used.action_intent)
			if(a_intent == I_HURT)
				hud_used.action_intent.icon_state = I_HURT
			else
				hud_used.action_intent.icon_state = I_HELP

proc/is_blind(A)
	if(istype(A, /mob/living/carbon))
		var/mob/living/carbon/C = A
		if(C.sdisabilities & BLIND || C.blinded)
			return 1
	return 0

/proc/broadcast_security_hud_message(var/message, var/broadcast_source)
	broadcast_hud_message(message, broadcast_source, sec_hud_users, /obj/item/clothing/glasses/hud/security)

/proc/broadcast_medical_hud_message(var/message, var/broadcast_source)
	broadcast_hud_message(message, broadcast_source, med_hud_users, /obj/item/clothing/glasses/hud/health)

/proc/broadcast_hud_message(var/message, var/broadcast_source, var/list/targets, var/icon)
	var/turf/sourceturf = get_turf(broadcast_source)
	for(var/mob/M in targets)
		var/turf/targetturf = get_turf(M)
		if(targetturf && (targetturf.z == sourceturf.z))
			M.show_message("<span class='info'>\icon[icon] [message]</span>", 1)

/proc/mobs_in_area(var/area/A)
	var/list/mobs = new
	for(var/mob/living/M in mob_list)
		if(get_area(M) == A)
			mobs += M
	return mobs

//Direct dead say used both by emote and say
//It is somewhat messy. I don't know what to do.
//I know you can't see the change, but I rewrote the name code. It is significantly less messy now
/proc/say_dead_direct(var/message, var/mob/subject = null)
	var/name
	var/keyname
	if(subject && subject.client)
		var/client/C = subject.client
		keyname = (C.holder && C.holder.fakekey) ? C.holder.fakekey : C.key
		if(C.mob) //Most of the time this is the dead/observer mob; we can totally use him if there is no better name
			var/mindname
			var/realname = C.mob.real_name
			if(C.mob.mind)
				mindname = C.mob.mind.name
				if(C.mob.mind.original && C.mob.mind.original.real_name)
					realname = C.mob.mind.original.real_name
			if(mindname && mindname != realname)
				name = "[realname] died as [mindname]"
			else
				name = realname

	for(var/mob/M in player_list)
		if(M.client && ((!istype(M, /mob/abstract/new_player) && M.stat == DEAD) || (M.client.holder && check_rights(R_DEV|R_MOD|R_ADMIN, 0, M))) && (M.client.prefs.toggles & CHAT_DEAD))
			var/follow
			var/lname
			if(subject)
				if(subject != M)
					follow = "[ghost_follow_link(subject, M)] "
				if(M.stat != DEAD && M.client.holder)
					follow = "([admin_jump_link(subject, M.client.holder)]) "
				var/mob/abstract/observer/DM
				if(istype(subject, /mob/abstract/observer))
					DM = subject
				if(M.client.holder) 							// What admins see
					lname = "[keyname][(DM && DM.anonsay) ? "*" : (DM ? "" : "^")] ([name])"
				else
					if(DM && DM.anonsay)						// If the person is actually observer they have the option to be anonymous
						lname = "Ghost of [name]"
					else if(DM)									// Non-anons
						lname = "[keyname] ([name])"
					else										// Everyone else (dead people who didn't ghost yet, etc.)
						lname = name
				lname = "<span class='name'>[lname]</span> "
			to_chat(M, "[follow] <span class='deadsay'>" + create_text_tag("dead", "DEAD:", M.client) + " [lname][message]</span>")

//Announces that a ghost has joined/left, mainly for use with wizards
/proc/announce_ghost_joinleave(O, var/joined_ghosts = 1, var/message = "")
	var/client/C
	//Accept any type, sort what we want here
	if(istype(O, /mob))
		var/mob/M = O
		if(M.client)
			C = M.client
	else if(istype(O, /client))
		C = O
	else if(istype(O, /datum/mind))
		var/datum/mind/M = O
		if(M.current && M.current.client)
			C = M.current.client
		else if(M.original && M.original.client)
			C = M.original.client

	if(C)
		var/name
		if(C.mob)
			var/mob/M = C.mob
			if(M.mind && M.mind.name)
				name = M.mind.name
			if(M.real_name && M.real_name != name)
				if(name)
					name += " ([M.real_name])"
				else
					name = M.real_name
		if(!name)
			name = (C.holder && C.holder.fakekey) ? C.holder.fakekey : C.key
		if(joined_ghosts)
			say_dead_direct("The ghost of <span class='name'>[name]</span> now [pick("skulks","lurks","prowls","creeps","stalks")] among the dead. [message]")
		else
			say_dead_direct("<span class='name'>[name]</span> no longer [pick("skulks","lurks","prowls","creeps","stalks")] in the realm of the dead. [message]")

/mob/proc/switch_to_camera(var/obj/machinery/camera/C)
	if (!C.can_use() || stat || (get_dist(C, src) > 1 || machine != src || blinded || !canmove))
		return 0
	check_eye(src)
	return 1

/mob/living/silicon/ai/switch_to_camera(var/obj/machinery/camera/C)
	if(!C.can_use() || !is_in_chassis())
		return 0

	eyeobj.setLoc(C)
	return 1

// Returns true if the mob has a client which has been active in the last given X minutes.
/mob/proc/is_client_active(var/active = 1)
	return client && client.inactivity < active MINUTES

/mob/proc/can_eat()
	return 1

/mob/proc/can_force_feed()
	return 1

#define SAFE_PERP -50
/mob/living/proc/assess_perp(var/obj/access_obj, var/check_access, var/auth_weapons, var/check_records, var/check_arrest)
	if(stat == DEAD)
		return SAFE_PERP

	return 0

/mob/living/carbon/assess_perp(var/obj/access_obj, var/check_access, var/auth_weapons, var/check_records, var/check_arrest)
	if(handcuffed)
		return SAFE_PERP

	return ..()

/mob/living/carbon/human/assess_perp(var/obj/access_obj, var/check_access, var/auth_weapons, var/check_records, var/check_arrest)
	var/threatcount = ..()
	if(. == SAFE_PERP)
		return SAFE_PERP

	//Agent cards lower threatlevel.
	var/obj/item/card/id/id = GetIdCard()
	if(id && istype(id, /obj/item/card/id/syndicate))
		threatcount -= 2
	// A proper	CentCom id is hard currency.
	else if(id && istype(id, /obj/item/card/id/centcom))
		return SAFE_PERP

	if(check_access && !access_obj.allowed(src))
		threatcount += 4

	if(auth_weapons && !access_obj.allowed(src))
		if(istype(l_hand, /obj/item/gun) || istype(l_hand, /obj/item/melee))
			threatcount += 4

		if(istype(r_hand, /obj/item/gun) || istype(r_hand, /obj/item/melee))
			threatcount += 4

		if(istype(belt, /obj/item/gun) || istype(belt, /obj/item/melee))
			threatcount += 2

		if(species.name != "Human")
			threatcount += 2

	if(check_records || check_arrest)
		var/perpname = name
		if(id)
			perpname = id.registered_name

		var/datum/record/general/R = SSrecords.find_record("name", perpname)
		if(check_records && !R)
			threatcount += 4

		if(check_arrest && R && R.security && (R.security.criminal == "*Arrest*"))
			threatcount += 4

	return threatcount

/mob/living/simple_animal/hostile/assess_perp(var/obj/access_obj, var/check_access, var/auth_weapons, var/check_records, var/check_arrest)
	var/threatcount = ..()
	if(threatcount == SAFE_PERP)
		return SAFE_PERP

	if(istype(src, /mob/living/simple_animal/hostile/retaliate/goat) || istype(src, /mob/living/simple_animal/hostile/commanded))
		return threatcount

	return threatcount + 4


/mob/living/proc/bucklecheck(var/mob/living/user)
	if (buckled && istype(buckled, /obj/structure))
		if (istype(user,/mob/living/silicon/robot))
			return 2
		else
			to_chat(user, "You must unbuckle the subject first")
			return 0
	return 1

/mob/living/carbon/human/proc/delayed_vomit()
	if(!check_has_mouth())
		return
	if(stat == DEAD)
		return
	if(!lastpuke)
		lastpuke = 1
		to_chat(src, "<span class='warning'>You feel nauseous...</span>")
		spawn(150)	//15 seconds until second warning
			to_chat(src, "<span class='warning'>You feel like you are about to throw up!</span>")
			spawn(100)	//and you have 10 more for mad dash to the bucket
				empty_stomach()
				spawn(350)	//wait 35 seconds before next volley
					lastpuke = 0

/obj/proc/get_equip_slot()
	//This function is called by an object which is somewhere on a humanoid mob
	//It will return the number of the equipment slot its in

	if (!istype(loc, /mob/living/carbon/human))//This function is for finding where we are on a human. not valid otherwise
		return null

	var/mob/living/carbon/human/H = loc


	//Now we check various slots on the mob, the order of these is optimised based on how likely we are to be in that slot
	if (H.l_hand == src)
		return slot_l_hand
	else if (H.r_hand == src)
		return slot_r_hand
	else if (H.l_store == src)
		return slot_l_store
	else if (H.r_store == src)
		return slot_r_store
	else if (H.head == src)
		return slot_head
	else if (H.wear_suit == src)
		return slot_wear_suit
	else if (H.s_store == src)
		return slot_s_store
	else if (H.wear_mask == src)
		return slot_wear_mask
	else if (H.wear_id == src)
		return slot_wear_id
	else if (H.w_uniform == src)
		return slot_w_uniform
	else if (H.gloves == src)
		return slot_gloves
	else if (H.belt == src)
		return slot_belt
	else if (H.back == src)
		return slot_back
	else if (H.r_ear == src)
		return slot_r_ear
	else if (H.l_ear == src)
		return slot_l_ear
	else if (H.shoes == src)
		return slot_shoes
	else
		return null//We failed to find the slot

	/* Variables to check
		l_hand
		r_hand
		head
		l_store //Left and right pockets
		r_store
		s_store //Suit storage?

		wear_mask,
		wear_id
		w_uniform //the uniform
		wear_suit
		gloves
		belt
		back
		r_ear
		l_ear

		shoes

	*/

/obj/proc/report_onmob_location(var/justmoved, var/slot = null, var/mob/reportto)
	var/mob/living/carbon/human/H//The person who the item is on
	var/newlocation
	var/preposition= ""
	var/action = ""
	var/action3 = ""
	if (!reportto)
		return 0

	if (istype(loc, /mob/living/carbon/human))//This function is for finding where we are on a human. not valid otherwise
		H = loc

	else
		H = get_holding_mob()


	if (slot != null)

		if (slot_l_hand == slot)
			if (justmoved)
				action += "now "
			preposition = "in"
			action += "being held"
			action3 = "holds"
			newlocation = "left hand"
		else if (slot_r_hand == slot)
			if (justmoved)
				action += "now "
			preposition = "in"
			action += "being held"
			action3 = "holds"
			newlocation = "right hand"
		else if (slot_l_store == slot)
			if (justmoved)
				preposition = "into"
				action = "placed"
				action3 = "places"
			else
				preposition = "inside"
			newlocation = "left pocket"
		else if (slot_r_store == slot)
			if (justmoved)
				preposition = "into"
				action = "placed"
				action3 = "places"
			else
				preposition = "inside"
			newlocation = "right pocket"
		else if (slot_s_store == slot)
			if (justmoved)
				preposition = "into"
				action = "placed"
				action3 = "places"
			else
				preposition = "inside"
			newlocation = "suit storage"
		else
			if (justmoved)
				action += "now "
			action += "being worn"

			if (slot_head == slot)
				preposition = "as"
				action3 = "wears"
				newlocation = "hat"
			else if (slot_wear_suit == slot)
				preposition = "over"
				action3 = "wears"
				newlocation = "uniform"
			else if (slot_wear_mask == slot)
				preposition = "on"
				action3 = "wears"
				newlocation = "face"
			else if (slot_wear_id == slot)
				preposition = "as"
				action3 = "wears"
				newlocation = "ID"
			else if (slot_w_uniform == slot)
				preposition = "on"
				action3 = "wears"
				newlocation = "body"
			else if (slot_gloves == slot)
				preposition = "on"
				action3 = "wears"
				newlocation = "hands"
			else if (slot_belt == slot)
				preposition = "around"
				action3 = "wears"
				newlocation = "waist"
			else if (slot_back == slot)
				preposition = "on"
				action3 = "wears"
				newlocation = "back"
			else if (slot_r_ear == slot)
				preposition = "on"
				action3 = "wears"
				newlocation = "right shoulder"//Ill use ear slots for wearing mobs on the shoulder in future
			else if (slot_l_ear == slot)
				preposition = "on"
				action3 = "wears"
				newlocation = "left shoulder"
			else if (slot_shoes == slot)
				preposition = "on"
				action3 = "wears"
				newlocation = "feet"
	else if (istype(loc,/obj/item/device/pda))
		var/obj/item/device/pda/S = loc
		newlocation = S.name
		if (justmoved)
			preposition = "into"
			action = "slotted"
			action3 = "slots"
		else
			action = "installed"
			preposition = "in"
	else if (istype(loc,/obj/item/storage))
		var/obj/item/storage/S = loc
		newlocation = S.name
		if (justmoved)
			preposition = "into"
			action = "placed"
			action3 = "places"
		else
			action = "tucked"
			preposition = "inside"

	if (justmoved)
		reportto.contained_visible_message(H,  "<span class='notice'>[H] [action3] [reportto] [preposition] their [newlocation]</span>", "<span class='notice'>You are [action] [preposition] [H]'s [newlocation]</span>", "", 1)
	else
		to_chat(reportto, "<span class='notice'>You are [action] [preposition] [H]'s [newlocation]</span>")

/atom/proc/get_holding_mob()
	//This function will return the mob which is holding this holder, or null if it's not held
	//It recurses up the hierarchy out of containers until it reaches a mob, or aturf, or hits the limit
	var/x = 0//As a safety, we'll crawl up a maximum of five layers
	var/atom/a = src
	while (x < 5)
		x++
		if (isnull(a))
			return null

		a = a.loc
		if (istype(a, /turf))
			return null//We must be on a table or a floor, or maybe in a wall. Either way we're not held.

		if (istype(a, /mob))
			return a
		//If none of the above are true, we must be inside a box or backpack or something. Keep recursing up.

	return null//If we get here, the holder must be buried many layers deep in nested containers. Shouldn't happen


//This proc retrieves the relevant time of death from
/mob/proc/get_death_time(var/which)
	var/datum/preferences/P
	if (client)
		P = client.prefs
	else if (ckey)
		// To avoid runtimes during adminghost.
		if (copytext(ckey, 1, 2) == "@")
			P = preferences_datums[copytext(ckey, 2)]
		else
			P = preferences_datums[ckey]
	else
		return null

	if (!P)
		return null

	return P.time_of_death[which]

/mob/proc/set_death_time(var/which, var/value)
	var/datum/preferences/P
	if (client)
		P = client.prefs
	else if (ckey)
		// To avoid runtimes during adminghost.
		if (copytext(ckey, 1, 2) == "@")
			P = preferences_datums[copytext(ckey, 2)]
		else
			P = preferences_datums[ckey]
	else
		return 0

	if (!P)
		return 0

	P.time_of_death[which] = value
	return 1

/**
 * Resets death timers for a mob. Should only be called during new player creation.
 */
/mob/proc/reset_death_timers()
	var/datum/preferences/P
	if (client)
		P = client.prefs
	else if (ckey)
		// To avoid runtimes during adminghost.
		if (copytext(ckey, 1, 2) == "@")
			P = preferences_datums[copytext(ckey, 2)]
		else
			P = preferences_datums[ckey]
	else
		return

	if (!P)
		return

	P.time_of_death.Cut()

//Below here is stuff related to devouring, but which is generally helpful and thus placed here
//See Devour.dm for more info in how these are used

// Returns a bitfield representing the mob's type as relevant to the devour system.
/mob/proc/find_type()
	return 0

/mob/living/carbon/human/find_type()
	. = ..()
	. |= isSynthetic() ? TYPE_SYNTHETIC : TYPE_ORGANIC
	if (!islesserform(src))
		. |= TYPE_HUMANOID

/mob/living/carbon/slime/find_type()
	. = ..()
	. |= TYPE_WEIRD

/mob/living/bot/find_type()
	. = ..()
	. |= TYPE_SYNTHETIC

/mob/living/silicon/find_type()
	. = ..()
	. |= TYPE_SYNTHETIC

// Yeah, I'm just going to cheat and do istype(src) checks here.
// It's not worth adding a proc for every single one of these types.
/mob/living/simple_animal/find_type()
	. = ..()
	if (is_type_in_typecache(src, SSmob.mtl_synthetic))
		. |= TYPE_SYNTHETIC

	if (is_type_in_typecache(src, SSmob.mtl_weird))
		. |= TYPE_WEIRD

	if (is_type_in_typecache(src, SSmob.mtl_incorporeal))
		. |= TYPE_INCORPOREAL

	// If it's not TYPE_SYNTHETIC, TYPE_WEIRD or TYPE_INCORPOREAL, we can assume it's TYPE_ORGANIC.
	if (!(. & (TYPE_SYNTHETIC|TYPE_WEIRD|TYPE_INCORPOREAL)))
		. |= TYPE_ORGANIC

	if (is_type_in_typecache(src, SSmob.mtl_humanoid))
		. |= TYPE_HUMANOID


/mob/living/proc/get_vessel(create = FALSE)
	if (!create)
		return

	//we make a new vessel for whatever creature we're devouring. this allows blood to come from creatures that can't normally bleed
	//We create an MD5 hash of the mob's reference to use as its DNA string.
	//This creates unique DNA for each creature in a consistently repeatable process
	var/datum/reagents/vessel = new/datum/reagents(600)
	vessel.add_reagent("blood",560)
	for(var/datum/reagent/blood/B in vessel.reagent_list)
		if(B.id == "blood")
			B.data = list(
				"donor" = WEAKREF(src),
				"viruses" = null,
				"species" = name,
				"blood_DNA" = md5("\ref[src]"),
				"blood_colour" = "#a10808",
				"blood_type" = null,
				"resistances" = null,
				"trace_chem" = null,
				"virus2" = null,
				"antibodies" = list()
			)

			B.color = B.data["blood_colour"]

	return vessel

/mob/living/carbon/human/get_vessel(create = FALSE)
	. = vessel

/mob/living/carbon/alien/diona/get_vessel(create = FALSE)
	. = vessel

#define POSESSIVE_PRONOUN	0
#define POSESSIVE_ADJECTIVE	1
#define REFLEXIVE			2
#define SUBJECTIVE_PERSONAL	3
#define OBJECTIVE_PERSONAL	4
/mob/proc/get_pronoun(var/type)
	switch (type)
		if (POSESSIVE_PRONOUN)
			switch(gender)
				if (MALE)
					return "his"
				if (FEMALE)
					return "hers"
				else
					return "theirs"
		if (POSESSIVE_ADJECTIVE)
			switch(gender)
				if (MALE)
					return "his"
				if (FEMALE)
					return "her"
				else
					return "their"
		if (REFLEXIVE)
			switch(gender)
				if (MALE)
					return "himself"
				if (FEMALE)
					return "herself"
				else
					return "themselves"
		if (SUBJECTIVE_PERSONAL)
			switch(gender)
				if (MALE)
					return "he"
				if (FEMALE)
					return "she"
				else
					return "they"
		if (OBJECTIVE_PERSONAL)
			switch(gender)
				if (MALE)
					return "him"
				if (FEMALE)
					return "her"
				else
					return "them"

		else
			return "its"//Something went wrong

#undef SAFE_PERP

/mob/proc/get_multitool(var/obj/P)
	if(P.ismultitool())
		return P

/mob/abstract/observer/get_multitool()
	return can_admin_interact() && ..(ghost_multitool)

/mob/living/carbon/human/get_multitool()
	return ..(get_active_hand())

/mob/living/silicon/robot/get_multitool()
	return ..(get_active_hand())

/mob/living/silicon/ai/get_multitool()
	return ..(ai_multi)

/mob/proc/get_hydration_mul(var/minscale = 0, var/maxscale = 1)

	if(status_flags & GODMODE) //Godmode
		return maxscale

	if(max_hydration <= 0) //Has no hydration
		return maxscale

	var/hydration_mul = hydration/max_hydration

	if(hydration_mul >= CREW_HYDRATION_OVERHYDRATED)
		return minscale + ( (maxscale - minscale) * 0.66)

	if(hydration_mul <= CREW_HYDRATION_DEHYDRATED)
		return minscale

	if(hydration_mul <= CREW_HYDRATION_VERYTHIRSTY)
		return minscale + ( (maxscale - minscale) * 0.33)

	if(hydration_mul <= CREW_HYDRATION_THIRSTY)
		return minscale + ( (maxscale - minscale) * 0.66)

	return minscale + ( (maxscale - minscale) * 1)

/mob/proc/get_nutrition_mul(var/minscale = 0, var/maxscale = 1)

	if(status_flags & GODMODE) //Godmode
		return maxscale

	if(max_nutrition <= 0) //Has no nutrition
		return maxscale

	var/nutrition_mul = nutrition/max_nutrition

	if(nutrition_mul >= CREW_NUTRITION_OVEREATEN)
		return minscale + ( (maxscale - minscale) * 0.66)

	if(nutrition_mul <= CREW_NUTRITION_STARVING)
		return minscale

	if(nutrition_mul <= CREW_NUTRITION_VERYHUNGRY)
		return minscale + ( (maxscale - minscale) * 0.33)

	if(nutrition_mul <= CREW_NUTRITION_HUNGRY)
		return minscale + ( (maxscale - minscale) * 0.66)

	return minscale + ( (maxscale - minscale) * 1)


/mob/proc/adjustNutritionLoss(var/amount)

	if(max_nutrition <= 0)
		return FALSE
	nutrition = max(0,min(max_nutrition,nutrition - amount))

	return TRUE

/mob/proc/adjustHydrationLoss(var/amount)

	if(max_hydration <= 0)
		return FALSE
	hydration = max(0,min(max_hydration,hydration - amount))

	return TRUE

/mob/proc/get_accumulated_vision_handlers()
	var/result[2]
	var/asight = 0
	var/ainvis = 0
	for(var/atom/vision_handler in additional_vision_handlers)
		//Grab their flags
		asight |= vision_handler.additional_sight_flags()
		ainvis = max(ainvis, vision_handler.additional_see_invisible())
	result[1] = asight
	result[2] = ainvis

	return result

/mob/proc/remove_blood_simple(var/blood)
	return