// fun if you want to typecast humans/monkeys/etc without writing long path-filled lines.
/proc/ishuman(A)
	if(istype(A, /mob/living/carbon/human))
		return 1
	return 0

/proc/ishuman_species(A)
	if(istype(A, /mob/living/carbon/human) && (A:get_species() == "Human"))
		return 1
	return 0

/proc/isunathi(A)
	if(istype(A, /mob/living/carbon/human) && (A:get_species() == "Unathi"))
		return 1
	return 0

/proc/istajara(A)
	if(istype(A, /mob/living/carbon/human) && (A:get_species() == "Tajara"))
		return 1
	return 0

/proc/isskrell(A)
	if(istype(A, /mob/living/carbon/human) && (A:get_species() == "Skrell"))
		return 1
	return 0

/proc/isvaurca(A)
	if(istype(A, /mob/living/carbon/human) && (A:get_species() == "Vaurca"))
		return 1
	return 0

/proc/isipc(A)
	if(istype(A, /mob/living/carbon/human) && (A:get_species() == "Machine"))
		return 1
	return 0

/proc/isvox(A)
	if(istype(A, /mob/living/carbon/human) && (A:get_species() == "Vox"))
		return 1
	return 0

/proc/isalien(A)
	if(istype(A, /mob/living/carbon/alien))
		return 1
	return 0

/proc/isxenomorph(A)
	if(istype(A, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = A
		return istype(H.species, /datum/species/xenos)
	return 0

/proc/issmall(A)
	if(A && istype(A, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = A
		if(H.species && H.species.is_small)
			return 1
	return 0

/proc/isbrain(A)
	if(A && istype(A, /mob/living/carbon/brain))
		return 1
	return 0

/proc/isslime(A)
	if(istype(A, /mob/living/carbon/slime))
		return 1
	return 0

/proc/isrobot(A)
	if(istype(A, /mob/living/silicon/robot))
		return 1
	return 0

/proc/isanimal(A)
	if(istype(A, /mob/living/simple_animal))
		return 1
	return 0

/proc/iscorgi(A)
	if(istype(A, /mob/living/simple_animal/corgi))
		return 1
	return 0

/proc/iscrab(A)
	if(istype(A, /mob/living/simple_animal/crab))
		return 1
	return 0

/proc/iscat(A)
	if(istype(A, /mob/living/simple_animal/cat))
		return 1
	return 0

/proc/ismouse(A)
	if(istype(A, /mob/living/simple_animal/mouse))
		return 1
	return 0

/proc/isbear(A)
	if(istype(A, /mob/living/simple_animal/hostile/bear))
		return 1
	return 0

/proc/iscarp(A)
	if(istype(A, /mob/living/simple_animal/hostile/carp))
		return 1
	return 0

/proc/isclown(A)
	if(istype(A, /mob/living/simple_animal/hostile/retaliate/clown))
		return 1
	return 0

/mob/proc/isSilicon()
	return 0

/mob/living/silicon/isSilicon()
	return 1

/proc/isAI(A)
	if(istype(A, /mob/living/silicon/ai))
		return 1
	return 0

/mob/proc/isMobAI()
	return 0

/mob/living/silicon/ai/isMobAI()
	return 1

/mob/proc/isSynthetic()
	return 0

/mob/living/carbon/human/isSynthetic()
	return species.flags & IS_SYNTHETIC

/mob/living/silicon/isSynthetic()
	return 1

/mob/living/carbon/human/isMonkey()
	return istype(species, /datum/species/monkey)

/mob/proc/isMonkey()
	return 0

/mob/living/carbon/human/isMonkey()
	return istype(species, /datum/species/monkey)

/mob/proc/is_diona()
	//returns which type of diona we are, or zero
	if (istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/T = src
		if (istype(T.species, /datum/species/diona) || istype(src, /mob/living/carbon/human/diona))
			return DIONA_WORKER

	if (istype(src, /mob/living/carbon/alien/diona))
		return DIONA_NYMPH
	return 0

/proc/ispAI(A)
	if(istype(A, /mob/living/silicon/pai))
		return 1
	return 0

/proc/isdrone(A)
	if(istype(A, /mob/living/silicon/robot/drone))
		return 1
	return 0

/proc/iscarbon(A)
	if(istype(A, /mob/living/carbon))
		return 1
	return 0

/proc/issilicon(A)
	if(istype(A, /mob/living/silicon))
		return 1
	return 0

/proc/isliving(A)
	if(istype(A, /mob/living))
		return 1
	return 0

proc/isobserver(A)
	if(istype(A, /mob/dead/observer))
		return 1
	return 0

proc/isorgan(A)
	if(istype(A, /obj/item/organ/external))
		return 1
	return 0

proc/isdeaf(A)
	if(istype(A, /mob))
		var/mob/M = A
		return (M.sdisabilities & DEAF) || M.ear_deaf
	return 0

proc/isnewplayer(A)
	if(istype(A, /mob/new_player))
		return 1
	return 0

proc/hasorgans(A) // Fucking really??
	return ishuman(A)

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

/*
	Miss Chance
*/

//TODO: Integrate defence zones and targeting body parts with the actual organ system, move these into organ definitions.

//The base miss chance for the different defence zones
var/list/global/base_miss_chance = list(
	"head" = 40,
	"chest" = 10,
	"groin" = 20,
	"l_leg" = 20,
	"r_leg" = 20,
	"l_arm" = 20,
	"r_arm" = 20,
	"l_hand" = 50,
	"r_hand" = 50,
	"l_foot" = 50,
	"r_foot" = 50,
)

//Used to weight organs when an organ is hit randomly (i.e. not a directed, aimed attack).
//Also used to weight the protection value that armour provides for covering that body part when calculating protection from full-body effects.
var/list/global/organ_rel_size = list(
	"head" = 25,
	"chest" = 70,
	"groin" = 30,
	"l_leg" = 25,
	"r_leg" = 25,
	"l_arm" = 25,
	"r_arm" = 25,
	"l_hand" = 10,
	"r_hand" = 10,
	"l_foot" = 10,
	"r_foot" = 10,
)

/proc/check_zone(zone)
	if(!zone)	return "chest"
	switch(zone)
		if("eyes")
			zone = "head"
		if("mouth")
			zone = "head"
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
			organ_rel_size["head"]; "head",
			organ_rel_size["chest"]; "chest",
			organ_rel_size["groin"]; "groin",
			organ_rel_size["l_arm"]; "l_arm",
			organ_rel_size["r_arm"]; "r_arm",
			organ_rel_size["l_leg"]; "l_leg",
			organ_rel_size["r_leg"]; "r_leg",
			organ_rel_size["l_hand"]; "l_hand",
			organ_rel_size["r_hand"]; "r_hand",
			organ_rel_size["l_foot"]; "l_foot",
			organ_rel_size["r_foot"]; "r_foot",
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
		for(var/obj/item/weapon/grab/G in target.grabbed_by)
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

proc/slur(phrase)
	phrase = html_decode(phrase)
	var/leng=lentext(phrase)
	var/counter=lentext(phrase)
	var/newphrase=""
	var/newletter=""
	while(counter>=1)
		newletter=copytext(phrase,(leng-counter)+1,(leng-counter)+2)
		if(rand(1,3)==3)
			if(lowertext(newletter)=="o")	newletter="u"
			if(lowertext(newletter)=="s")	newletter="ch"
			if(lowertext(newletter)=="a")	newletter="ah"
			if(lowertext(newletter)=="c")	newletter="k"
		switch(rand(1,15))
			if(1,3,5,8)	newletter="[lowertext(newletter)]"
			if(2,4,6,15)	newletter="[uppertext(newletter)]"
			if(7)	newletter+="'"
			//if(9,10)	newletter="<b>[newletter]</b>"
			//if(11,12)	newletter="<big>[newletter]</big>"
			//if(13)	newletter="<small>[newletter]</small>"
		newphrase+="[newletter]";counter-=1
	return newphrase

/proc/stutter(n)
	var/te = html_decode(n)
	var/t = ""//placed before the message. Not really sure what it's for.
	n = length(n)//length of the entire word
	var/p = null
	p = 1//1 is the start of any word
	while(p <= n)//while P, which starts at 1 is less or equal to N which is the length.
		var/n_letter = copytext(te, p, p + 1)//copies text from a certain distance. In this case, only one letter at a time.
		if (prob(80) && (ckey(n_letter) in list("b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","y","z")))
			if (prob(10))
				n_letter = text("[n_letter]-[n_letter]-[n_letter]-[n_letter]")//replaces the current letter with this instead.
			else
				if (prob(20))
					n_letter = text("[n_letter]-[n_letter]-[n_letter]")
				else
					if (prob(5))
						n_letter = null
					else
						n_letter = text("[n_letter]-[n_letter]")
		t = text("[t][n_letter]")//since the above is ran through for each letter, the text just adds up back to the original word.
		p++//for each letter p is increased to find where the next letter will be.
	return sanitize(t)


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


/proc/shake_camera(mob/M, duration, strength=1, var/taper = 0)
	if(!M || !M.client || M.shakecamera)
		return

	M.shakecamera = 1
	spawn(2)
		if(!M.client)
			return
		var/atom/oldeye=M.client.eye
		var/aiEyeFlag = 0
		if(istype(oldeye, /mob/eye/aiEye))
			aiEyeFlag = 1

		var/x
		for(x=0; x<duration, x++)
			if(aiEyeFlag)
				M.client.eye = locate(dd_range(1,oldeye.loc.x+rand(-strength,strength),world.maxx),dd_range(1,oldeye.loc.y+rand(-strength,strength),world.maxy),oldeye.loc.z)
			else
				M.client.eye = locate(dd_range(1,M.loc.x+rand(-strength,strength),world.maxx),dd_range(1,M.loc.y+rand(-strength,strength),world.maxy),M.loc.z)
			sleep(1)

		//Taper code added by nanako.
		//Will make the strength falloff after the duration.
		//This helps to reduce jarring effects of major screenshaking suddenly returning to stability
		//Recommended taper values are 0.05-0.1
		if (taper > 0)
			while (strength > 0)
				strength -= taper
				if(aiEyeFlag)
					M.client.eye = locate(dd_range(1,oldeye.loc.x+rand(-strength,strength),world.maxx),dd_range(1,oldeye.loc.y+rand(-strength,strength),world.maxy),oldeye.loc.z)
				else
					M.client.eye = locate(dd_range(1,M.loc.x+rand(-strength,strength),world.maxx),dd_range(1,M.loc.y+rand(-strength,strength),world.maxy),M.loc.z)
				sleep(1)

		M.client.eye=oldeye
		M.shakecamera = 0


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
		if((targetturf.z == sourceturf.z))
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
		if(M.client && ((!istype(M, /mob/new_player) && M.stat == DEAD) || (M.client.holder && check_rights(R_DEV|R_MOD|R_ADMIN, 0, M))) && (M.client.prefs.toggles & CHAT_DEAD))
			var/follow
			var/lname
			if(subject)
				if(subject != M)
					follow = "(<a href='byond://?src=\ref[M];track=\ref[subject]'>follow</a>) "
				if(M.stat != DEAD && M.client.holder)
					follow = "(<a href='?src=\ref[M.client.holder];adminplayerobservejump=\ref[subject]'>JMP</a>) "
				var/mob/dead/observer/DM
				if(istype(subject, /mob/dead/observer))
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
			M << "<span class='deadsay'>" + create_text_tag("dead", "DEAD:", M.client) + " [lname][follow][message]</span>"

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
	var/obj/item/weapon/card/id/id = GetIdCard(src)
	if(id && istype(id, /obj/item/weapon/card/id/syndicate))
		threatcount -= 2
	// A proper	CentCom id is hard currency.
	else if(id && istype(id, /obj/item/weapon/card/id/centcom))
		return SAFE_PERP

	if(check_access && !access_obj.allowed(src))
		threatcount += 4

	if(auth_weapons && !access_obj.allowed(src))
		if(istype(l_hand, /obj/item/weapon/gun) || istype(l_hand, /obj/item/weapon/melee))
			threatcount += 4

		if(istype(r_hand, /obj/item/weapon/gun) || istype(r_hand, /obj/item/weapon/melee))
			threatcount += 4

		if(istype(belt, /obj/item/weapon/gun) || istype(belt, /obj/item/weapon/melee))
			threatcount += 2

		if(species.name != "Human")
			threatcount += 2

	if(check_records || check_arrest)
		var/perpname = name
		if(id)
			perpname = id.registered_name

		var/datum/data/record/R = find_security_record("name", perpname)
		if(check_records && !R)
			threatcount += 4

		if(check_arrest && R && (R.fields["criminal"] == "*Arrest*"))
			threatcount += 4

	return threatcount

/mob/living/simple_animal/hostile/assess_perp(var/obj/access_obj, var/check_access, var/auth_weapons, var/check_records, var/check_arrest)
	var/threatcount = ..()
	if(. == SAFE_PERP)
		return SAFE_PERP

	if(!istype(src, /mob/living/simple_animal/hostile/retaliate/goat))
		threatcount += 4
	return threatcount


/mob/living/proc/bucklecheck(var/mob/living/user)
	if (buckled && istype(buckled, /obj/structure))
		if (istype(user,/mob/living/silicon/robot))
			return 2
		else
			user << "You must unbuckle the subject first"
			return 0
	return 1

/mob/living/carbon/proc/vomit()
	var/canVomit = 0
	var/mob/living/carbon/human/H
	if (istype(src, /mob/living/carbon/human))
		H = src
		if (H.ingested.total_volume > 0)
			canVomit = 1

	if (nutrition > 150)
		canVomit = 1

	if(canVomit)
		Stun(4)
		src.visible_message("<span class='warning'>[src] vomits!</span>","<span class='warning'>You vomit!</span>")
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)

		var/turf/location = loc
		if (istype(location, /turf/simulated))
			location.add_vomit_floor(src, 1)

		nutrition -= 40
		if (intoxication)//The pain and system shock of vomiting, sobers you up a little
			intoxication *= 0.8

		if (istype(src, /mob/living/carbon/human))
			ingested.trans_to_turf(location,30)//Vomiting empties the stomach, transferring 30u reagents to the floor where you vomited
	else
		src.visible_message("<span class='warning'>[src] retches, attempting to vomit!</span>","<span class='warning'>You gag and collapse as you feel the urge to vomit, but there's nothing in your stomach!</span>")
		Weaken(4)

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
	else if (istype(loc,/obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = loc
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
		reportto << "<span class='notice'>You are [action] [preposition] [H]'s [newlocation]</span>"

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
		P = preferences_datums[ckey]
	else return null

	return P.time_of_death[which]

/mob/proc/set_death_time(var/which, var/value)
	var/datum/preferences/P
	if (client)
		P = client.prefs
	else if (ckey)
		P = preferences_datums[ckey]
	else
		return 0

	P.time_of_death[which] = value
	return 1


//Below here is stuff related to devouring, but which is generally helpful and thus placed here
//See Devour.dm for more info in how these are used


//Flags for the eat_types variable, a bitfield of what can or can't be eaten
//Note that any given mob can be more than one type
#define TYPE_ORGANIC	1//Almost any creature under /mob/living/carbon and most simple animals
#define	TYPE_SYNTHETIC	2//Everything under /mob/living/silicon, plus IPCs, viscerators
#define TYPE_HUMANOID	4//Humans, skrell, unathi, tajara, vaurca, diona, IPC, vox
#define TYPE_WIERD		8//Slimes, constructs, demons, and other creatures of a magical or bluespace nature.


//Blacklists of mobs that can be excluded from eating by flags in the bitfield

//All of these specific human subtypes are here for a reason.
//Using /mob/living/carbon/human as a generic type would include monkey/stok/farwa/neara.
//We do not want those to count as humanoids, only player species
var/list/humanoid_mobs_specific = list( /mob/living/carbon/human,
	/mob/living/carbon/human/bst,
	/mob/living/carbon/human/skrell,
	/mob/living/carbon/human/unathi,
	/mob/living/carbon/human/diona,
	/mob/living/carbon/human/tajaran,
	/mob/living/carbon/human/vox,
	/mob/living/carbon/human/machine,
	/mob/living/carbon/human/bug
	)

var/list/humanoid_mobs_inclusive = list(
	/mob/living/simple_animal/hostile/pirate,
	/mob/living/simple_animal/hostile/russian,
	/mob/living/simple_animal/hostile/syndicate
	)

var/list/synthetic_mobs_specific = list(
	/mob/living/carbon/human/machine,
	/mob/living/simple_animal/hostile/retaliate/malf_drone,
	/mob/living/simple_animal/hostile/viscerator,
	/mob/living/simple_animal/spiderbot
	)


var/list/synthetic_mobs_inclusive = list( /mob/living/silicon,
	/mob/living/simple_animal/hostile/hivebot,
	/mob/living/bot
	)

var/list/wierd_mobs_specific = list(/mob/living/simple_animal/adultslime)

var/list/wierd_mobs_inclusive = list( /mob/living/simple_animal/construct,
	/mob/living/simple_animal/shade,
	/mob/living/simple_animal/slime,
	/mob/living/simple_animal/hostile/faithless,
	/mob/living/carbon/slime
	)


/mob/proc/find_type()
	if (istype(src, /mob/living))
		var/mob/living/L = src
		return L.find_type()
	return 0

/mob/living/find_type()
	//This function returns a bitfield indicating what type(s) the passed mob is.
	//Synthetic and wierd are exclusive from organic. We assume it's organic if it's not either of those
	//var/mob/living/test = src
	var/mobtypes = 0

	if (mob_listed(src, synthetic_mobs_specific,1))
		mobtypes |= TYPE_SYNTHETIC
	else if (mob_listed(src, synthetic_mobs_inclusive,0))
		mobtypes |= TYPE_SYNTHETIC
	else
		var/datum/species/S = src.get_species(1)
		if (S && (S.flags & IS_SYNTHETIC))
			mobtypes |= TYPE_SYNTHETIC

	if (mob_listed(src, wierd_mobs_specific,1))
		mobtypes |= TYPE_WIERD
	else if (mob_listed(src, wierd_mobs_inclusive,0))
		mobtypes |= TYPE_WIERD

	if (!(mobtypes & TYPE_WIERD) && !(mobtypes & TYPE_SYNTHETIC))
		mobtypes |= TYPE_ORGANIC


	if (mob_listed(src, humanoid_mobs_specific,1))
		mobtypes |= TYPE_HUMANOID
	else if (mob_listed(src, humanoid_mobs_inclusive,0))
		mobtypes |= TYPE_HUMANOID

	return mobtypes


//This function attempts to find the mob's blood vessel, if it has one.
//If it doesn't, and the create var is true, then it will create a new temporary one filled with blood that has fake DNA, and return that
//If no vessel and no create var, then null is returned, getting blood isnt possible.
//The fake DNA is generally useful for animals, it contains enough information to tell what kind of creature it came from
/mob/living/proc/get_vessel(var/create = 0)
	//Add any other creatures which have blood, here
	if(istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		return H.vessel
	else if (istype(src, /mob/living/carbon/alien/diona))
		var/mob/living/carbon/alien/diona/D = src
		return D.vessel
	else if (create)

		//we make a new vessel for whatever creature we're devouring. this allows blood to come from creatures that can't normally bleed
		//We create an MD5 hash of the mob's reference to use as its DNA string.
		//This creates unique DNA for each creature in a consistently repeatable process
		var/datum/reagents/vessel = new/datum/reagents(600)
		vessel.add_reagent("blood",560)
		for(var/datum/reagent/blood/B in vessel.reagent_list)
			if(B.id == "blood")
				B.data = list(	"donor"=src,"viruses"=null,"species"=src.name,"blood_DNA"=md5("\ref[src]"),"blood_colour"= "#a10808","blood_type"=null,	\
								"resistances"=null,"trace_chem"=null, "virus2" = null, "antibodies" = list())

				B.color = B.data["blood_colour"]

		return vessel

	else return null

//This function checks against a list to see if the mob is in it.
//Any specified types are checked against exactly, using ==, not istype
//Any types ending in * will be tested with isType
/proc/mob_listed(var/mob/living/test, var/list/toCheck, var/specific = 0)
	for (var/i in toCheck)
		if (specific)
			if (test.type == i)
				return 1
		else
			if (istype(test, i))
				return 1
	return 0


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


//This function provides a simple, standardised, centralised means to spray all of a mob's worn items at once. Add new spraytypes as needed
/mob/living/proc/spray_all(var/spraytype)
	var/barefoot = 0
	if(r_hand)
		spray_thing(spraytype,r_hand)
	if(l_hand)
		spray_thing(spraytype,l_hand)
	if(wear_mask)
		spray_thing(spraytype,wear_mask)
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if (H.glasses)
			spray_thing(spraytype,H.glasses)
		if(H.head)
			spray_thing(spraytype,H.head)
		if(H.wear_suit)
			spray_thing(spraytype,H.wear_suit)
		else if(H.w_uniform)
			spray_thing(spraytype,H.w_uniform)
		if(H.shoes)
			spray_thing(spraytype,H.shoes)
		else
			barefoot = 1

	if (spraytype == "clean")
		clean_blood(barefoot)
	else if (spraytype == "deepclean")
		deep_clean(barefoot)
	else if (spraytype == "reveal")
		reveal_blood(barefoot)

/proc/spray_thing(var/spraytype, var/obj/item/thing)
	if (spraytype == "clean")
		thing.clean_blood()
	else if (spraytype == "deepclean")
		thing.deep_clean()
	else if (spraytype == "reveal")
		thing.reveal_blood()

	thing.update_worn_icon()

#undef SAFE_PERP
