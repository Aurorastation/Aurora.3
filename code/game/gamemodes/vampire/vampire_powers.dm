

/datum/vampire
	var/list/datum/mind/vampires = list()
	var/list/datum/mind/enthralled = list() //those controlled by a vampire
	var/list/thralls = list() //vammpires controlling somebody
	var/bloodtotal = 0 // CHANGE TO ZERO WHEN PLAYTESTING HAPPENS
	var/bloodusable = 0 // CHANGE TO ZERO WHEN PLAYTESTING HAPPENS
	var/mob/living/owner = null
	var/gender = FEMALE
	var/iscloaking = 0 // handles the vampire cloak toggle
	var/list/powers = list() // list of available powers and passives, see defines in setup.dm
	var/mob/living/carbon/human/draining // who the vampire is draining of blood
	var/nullified = 0 //Nullrod makes them useless for a short while.

/datum/vampire/New(gend = FEMALE)
	..()
	gender = gend




/mob/proc/make_vampire()
	if(!mind)				return
	if(!mind.vampire)
		mind.vampire = new /datum/vampire(gender)
		mind.vampire.owner = src
	verbs += /client/vampire/proc/vampire_rejuvinate
	verbs += /client/vampire/proc/vampire_hypnotise
	verbs += /client/vampire/proc/vampire_glare
	//testing purposes REMOVE BEFORE PUSH TO MASTER
	/*for(var/handler in typesof(/client/proc))
		if(findtext("[handler]","vampire_"))
			verbs += handler*/
	for(var/i = 1; i <= 3; i++) // CHANGE TO 3 RATHER THAN 12 AFTER TESTING IS DONE
		if(!(i in mind.vampire.powers))
			mind.vampire.powers.Add(i)


	for(var/n in mind.vampire.powers)
		switch(n)
			if(VAMP_SHAPE)
				verbs += /client/vampire/proc/vampire_shapeshift
			if(VAMP_VISION)
				continue
			if(VAMP_DISEASE)
				verbs += /client/vampire/proc/vampire_disease
			if(VAMP_CLOAK)
				verbs += /client/vampire/proc/vampire_cloak
			if(VAMP_BATS)
				verbs += /client/vampire/proc/vampire_bats
			if(VAMP_SCREAM)
				verbs += /client/vampire/proc/vampire_screech
			if(VAMP_JAUNT)
				verbs += /client/vampire/proc/vampire_jaunt
			if(VAMP_BLINK)
				verbs += /client/vampire/proc/vampire_shadowstep
			if(VAMP_SLAVE)
				verbs += /client/vampire/proc/vampire_enthrall
			if(VAMP_FULL)
				continue

/mob/proc/remove_vampire_powers()
	for(var/handler in typesof(/client/vampire/proc))
		if(findtext("[handler]","vampire_"))
			verbs -= handler

/mob/proc/handle_bloodsucking(mob/living/carbon/human/H)
	src.mind.vampire.draining = H
	var/blood = 0
	var/bloodtotal = 0 //used to see if we increased our blood total
	var/bloodusable = 0 //used to see if we increased our blood usable

	src.visible_message("\red <b>[src.name] bites [H.name]'s neck!<b>", "\red <b>You bite [H.name]'s neck and begin to drain their blood.", "\blue You hear a soft puncture and a wet sucking noise")
	if(!iscarbon(src))
		H.LAssailant = null
	else
		H.LAssailant = src
	while(do_mob(src, H, 50))
		if(!mind.vampire)
			src << "\red Your fangs have disappeared!"
			return 0
		bloodtotal = src.mind.vampire.bloodtotal
		bloodusable = src.mind.vampire.bloodusable
		if(!H.vessel.get_reagent_amount("blood"))
			src << "\red They've got no blood left to give."
			break
		if(H.stat < 2) //alive
			blood = min(10, H.vessel.get_reagent_amount("blood"))// if they have less than 10 blood, give them the remnant else they get 10 blood
			src.mind.vampire.bloodtotal += blood
			src.mind.vampire.bloodusable += blood
//			H.adjustCloneLoss(10) // beep boop 10 damage //probably not necessary actually honestly okay
		else
			blood = min(5, H.vessel.get_reagent_amount("blood"))// The dead only give 5 bloods
			src.mind.vampire.bloodtotal += blood
		if(bloodtotal != src.mind.vampire.bloodtotal)
			src << "\blue <b>You have accumulated [src.mind.vampire.bloodtotal] [src.mind.vampire.bloodtotal > 1 ? "units" : "unit"] of blood[src.mind.vampire.bloodusable != bloodusable ?", and have [src.mind.vampire.bloodusable] left to use" : "."]"
		check_vampire_upgrade(mind)
		H.vessel.remove_reagent("blood",25)

	src.mind.vampire.draining = null
	src << "\blue You stop draining [H.name] of blood."
	return 1

/mob/proc/check_vampire_upgrade(datum/mind/v)
	if(!v) return
	if(!v.vampire) return
	var/datum/vampire/vamp = v.vampire
	var/list/old_powers = vamp.powers.Copy()

	// This used to be a switch statement.
	// Don't use switch statements for shit like this, since blood can be any random-ass value.
	// if(100) requires the blood to be at EXACTLY 100 units to trigger.
	// if(blud >= 100) activates when blood is at or over 100 units.
	// TODO: Make this modular.

	// TIER 1
	if(vamp.bloodtotal >= 100)
		if(!(VAMP_VISION in vamp.powers))
			vamp.powers.Add(VAMP_VISION)
		if(!(VAMP_SHAPE in vamp.powers))
			vamp.powers.Add(VAMP_SHAPE)

	// TIER 2
	if(vamp.bloodtotal >= 150)
		if(!(VAMP_CLOAK in vamp.powers))
			vamp.powers.Add(VAMP_CLOAK)


	// TIER 3
	if(vamp.bloodtotal >= 200)
		if(!(VAMP_BATS in vamp.powers))
			vamp.powers.Add(VAMP_BATS)
		if(!(VAMP_SCREAM in vamp.powers))
			vamp.powers.Add(VAMP_SCREAM)
			src << "\blue Your rejuvination abilities have improved and will now heal you over time when used."
		if(!(VAMP_DISEASE in vamp.powers))
			vamp.powers.Add(VAMP_DISEASE)

	// TIER 3.5 (/vg/)
	if(vamp.bloodtotal >= 250)
		if(!(VAMP_BLINK in vamp.powers))
			vamp.powers.Add(VAMP_BLINK)

	// TIER 4
	if(vamp.bloodtotal >= 300)
		if(!(VAMP_JAUNT in vamp.powers))
			vamp.powers.Add(VAMP_JAUNT)
		if(!(VAMP_SLAVE in vamp.powers))
			vamp.powers.Add(VAMP_SLAVE)

	// TIER 5
	if(vamp.bloodtotal >= 500)
		if(!(VAMP_FULL in vamp.powers))
			vamp.powers.Add(VAMP_FULL)

	announce_new_power(old_powers, vamp.powers)

/mob/proc/announce_new_power(list/old_powers, list/new_powers)
	for(var/n in new_powers)
		if(!(n in old_powers))
			switch(n)
				if(VAMP_SHAPE)
					src << "\blue You have gained the shapeshifting ability, at the cost of stored blood you can change your form permanently."
					verbs += /client/vampire/proc/vampire_shapeshift
				if(VAMP_VISION)
					src << "\blue Your vampiric vision has improved."
					//no verb
				if(VAMP_DISEASE)
					src << "\blue You have gained the Diseased Touch ability which causes those you touch to die shortly after unless treated medically."
					verbs += /client/vampire/proc/vampire_disease
				if(VAMP_CLOAK)
					src << "\blue You have gained the Cloak of Darkness ability which when toggled makes you near invisible in the shroud of darkness."
					verbs += /client/vampire/proc/vampire_cloak
				if(VAMP_BATS)
					src << "\blue You have gained the Summon Bats ability."
					verbs += /client/vampire/proc/vampire_bats // work in progress
				if(VAMP_SCREAM)
					src << "\blue You have gained the Chiropteran Screech ability which stuns anything with ears in a large radius and shatters glass in the process."
					verbs += /client/vampire/proc/vampire_screech
				if(VAMP_JAUNT)
					src << "\blue You have gained the Mist Form ability which allows you to take on the form of mist for a short period and pass over any obstacle in your path."
					verbs += /client/vampire/proc/vampire_jaunt
				if(VAMP_SLAVE)
					src << "\blue You have gained the Enthrall ability which at a heavy blood cost allows you to enslave a human that is not loyal to any other for a random period of time."
					verbs += /client/vampire/proc/vampire_enthrall
				if(VAMP_BLINK)
					src << "\blue You have gained the ability to shadowstep, which makes you disappear into nearby shadows at the cost of blood."
					verbs += /client/vampire/proc/vampire_shadowstep
				if(VAMP_FULL)
					src << "\blue You have reached your full potential and are no longer weak to the effects of anything holy and your vision has been improved greatly."
					//no verb

					//This should hold all the vampire related powers


/mob/proc/vampire_power(required_blood=0, max_stat=0)

	if(!src.mind)		return 0
	if(!ishuman(src))
		src << "<span class='warning'>You are in too weak of a form to do this!</span>"
		return 0

	var/datum/vampire/vampire = src.mind.vampire

	if(!vampire)
		//msg_scopes("[src] has vampire verbs but isn't a vampire.")
		world.log << "[src] has vampire verbs but isn't a vampire."
		return 0

	var/fullpower = (VAMP_FULL in vampire.powers)

	if(src.stat > max_stat)
		src << "<span class='warning'>You are incapacitated.</span>"
		return 0

	if(vampire.nullified)
		if(!fullpower)
			src << "<span class='warning'>Something is blocking your powers!</span>"
			return 0
	if(vampire.bloodusable < required_blood)
		src << "<span class='warning'>You require at least [required_blood] units of usable blood to do that!</span>"
		return 0
	//chapel check
	if(istype(loc.loc, /area/chapel))
		if(!fullpower)
			src << "<span class='warning'>Your powers are useless on this holy ground.</span>"
			return 0
	return 1

/mob/proc/vampire_affected(datum/mind/M)
	//Other vampires aren't affected
	if(mind && mind.vampire) return 0
	//Chaplains are resistant to vampire powers
	if(mind && mind.assigned_role == "Chaplain")
		return 0
	if(get_species() == "Machine")
		return 0
	//Vampires who have reached their full potential can affect nearly everything
	if(M && M.vampire && (VAMP_FULL in M.vampire.powers))
		return 1 // This doesn't really need to be here because of well the line below it.
	return 1

/mob/proc/vampire_can_reach(mob/M as mob, active_range = 1)
	if(M.loc == src.loc) return 1 //target and source are in the same thing
	if(!isturf(src.loc) || !isturf(M.loc)) return 0 //One is inside, the other is outside something.
	if(Adjacent(M))//if(AStar(src.loc, M.loc, /turf/proc/AdjacentTurfs, /turf/proc/Distance, active_range)) //If a path exists, good!
		return 1
	return 0

/mob/proc/vampire_active(required_blood=0, max_stat=0, active_range=1)
	var/pass = vampire_power(required_blood, max_stat)
	if(!pass)								return
	var/datum/vampire/vampire = mind.vampire
	if(!vampire) return
	var/list/victims = list()
	for(var/mob/living/carbon/C in view(active_range))
		if(C==src) continue
		victims += C
	var/mob/living/carbon/T = input(src, "Victim?") as null|anything in victims

	if(!T) return
	if(!(T in view(active_range))) return
	if(!vampire_can_reach(T, active_range)) return
	if(!vampire_power(required_blood, max_stat)) return
	return T

/client/vampire/proc/vampire_rejuvinate()
	set category = "Abilities"
	set name = "Rejuvinate "
	set desc= "Flush your system with spare blood to remove any incapacitating effects"
	var/datum/mind/M = usr.mind
	if(!M) return
	if(M.current.vampire_power(0, 1))
		M.current.weakened = 0
		M.current.stunned = 0
		M.current.paralysis = 0
		//M.vampire.bloodusable -= 10
		M.current << "\blue You flush your system with clean blood and remove any incapacitating effects."
		spawn(1)
			if(M.vampire.bloodtotal >= 200)
				for(var/i = 0; i < 5; i++)
					M.current.adjustBruteLoss(-2)
					M.current.adjustOxyLoss(-5)
					M.current.adjustToxLoss(-2)
					M.current.adjustFireLoss(-2)
					sleep(35)
		M.current.verbs -= /client/vampire/proc/vampire_rejuvinate
		spawn(200)
			M.current.verbs += /client/vampire/proc/vampire_rejuvinate

/client/vampire/proc/vampire_hypnotise()
	set category = "Abilities"
	set name = "Hypnotise" // (20)
	set desc= "A piercing stare that incapacitates your victim for a good length of time."
	var/datum/mind/M = usr.mind
	if(!M) return

	var/mob/living/carbon/C = M.current.vampire_active(0, 0, 1) //(20, 0, 1)

	if(!C) return
	if(C==usr)
		M.current << "\red You can't do that to yourself"
		return

	if(!M.current.has_eyes())
		M.current << "\red You don't have eyes"
		return

	var/vampgender
	if(M.current.gender == "male")
		vampgender = "he"
	else
		vampgender = "she"

	M.current.visible_message("<span class='warning'>[M]'s eyes flash briefly as [vampgender] stares into [C.name]'s eyes</span>")
//	M.current.remove_vampire_blood(20) Moved to remove if it works only.
	if(M.current.vampire_power(0, 0)) //if(M.current.vampire_power(20, 0))
		M.current.verbs -= /client/vampire/proc/vampire_hypnotise
		spawn(1200)
			M.current.verbs += /client/vampire/proc/vampire_hypnotise
		if(do_mob(M.current, C, 50))
			if(C.mind && C.mind.vampire)
				M.current << "\red Your piercing gaze fails to knock out [C.name]."
				C << "\blue [M.current]'s feeble gaze is ineffective."
				return
			else
				M.current << "\red Your piercing gaze knocks out [C.name]."
				C << "\red You find yourself unable to move and barely able to speak"
				C.Weaken(20)
				C.Stun(20)
				C.stuttering = 20
//				M.current.remove_vampire_blood(20)
		else
			M.current << "\red You broke your gaze."
			return

/client/vampire/proc/vampire_disease()
	set category = "Abilities"
	set name = "Diseased Touch (200)"
	set desc = "Touches your victim with infected blood giving them the Shutdown Syndrome which quickly shutsdown their major organs resulting in a quick painful death."
	var/datum/mind/M = usr.mind
	if(!M) return

	var/mob/living/carbon/C = M.current.vampire_active(200, 0, 1)
	if(!C) return
	if(C==usr)
		M.current << "\red You can't do that to yourself"
		return
	if(C.get_species() == "Machine")
		M.current << "\red You can't to that to a machine"
		return
	if(!M.current.vampire_can_reach(C, 1))
		M.current << "\red <b>You cannot touch [C.name] from where you are standing!"
		return
	M.current << "\red You stealthily infect [C.name] with your diseased touch."
	/*var/t_him = "it"
	if (src.gender == MALE)
		t_him = "him"
	else if (src.gender == FEMALE)
		t_him = "her"
	M.current.visible_message("\blue [M] shakes [src] trying to wake [t_him] up!" )
	playsound(get_turf(src), 'sound/weapons/thudswoosh.ogg', 50, 1, -1)*/
	C.help_shake_act(M.current) // i use da colon
	if(!C.vampire_affected(M))
		M.current << "\red They seem to be unaffected."
		return
	var/datum/disease2/disease/shutdown = new /datum/disease2/disease
	var/datum/disease2/effectholder/holder = new /datum/disease2/effectholder
	var/datum/disease2/effect/organs/vampire/O = new /datum/disease2/effect/organs/vampire
	holder.effect += O
	holder.chance = 10
	shutdown.infectionchance = 100
	shutdown.antigen |= text2num(pick(ALL_ANTIGENS))
	shutdown.antigen |= text2num(pick(ALL_ANTIGENS))
	shutdown.spreadtype = "None"
	shutdown.uniqueID = rand(0,10000)
	shutdown.effects += holder
	shutdown.speed = 1
	shutdown.stage = 2
	shutdown.clicks = 185
	msg_admin_attack("[key_name_admin(usr)] gave [key_name_admin(C)] the shutdown disease - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[C.x];Y=[C.y];Z=[C.z]'>JMP</a>")
	usr.attack_log += text("\[[time_stamp()]\] <font color='red'>Gave [C.name] ([C.ckey]) the shutdown disease</font>")
	C.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been given the shutdown disease by [usr.name] ([usr.ckey])</font>")
	infect_virus2(C,shutdown,0)
	M.current.remove_vampire_blood(200)
	M.current.verbs -= /client/vampire/proc/vampire_disease
	spawn(1800) M.current.verbs += /client/vampire/proc/vampire_disease

/client/vampire/proc/vampire_glare()
	set category = "Abilities"
	set name = "Glare"
	set desc= "A scary glare that incapacitates people for a short while around you."
	var/datum/mind/M = usr.mind
	if(!M) return

	if(!M.current.has_eyes())
		M.current << "\red You don't have eyes"
		return

	if(M.current.vampire_power(0, 1))
		M.current.visible_message("\red <b>[M.current]'s eyes emit a blinding flash!")
		//M.vampire.bloodusable -= 10
		M.current.verbs -= /client/vampire/proc/vampire_glare
		spawn(800)
			M.current.verbs += /client/vampire/proc/vampire_glare
		if(istype(M.current:glasses, /obj/item/clothing/glasses/sunglasses/blindfold))
			M.current << "<span class='warning'>You're blindfolded!</span>"
			return
		for(var/mob/living/carbon/C in view(1))
			if(C == M.current) continue //Don't stunn yourself
			if(!C.vampire_affected(M) && !C.get_species() == "Machine") //Or machines
				continue
			if(!M.current.vampire_can_reach(C, 1)) continue
//			C.Stun(8)
			C.Weaken(8)
			C.stuttering = 20
			C << "\red You are blinded by [M.current]'s glare"

/client/vampire/proc/vampire_shapeshift() //Hi.  I'm stupid and there are missing procs all around.  Namely the randomname proc.  I can't find it and can't code a new one because I am bad.  Sorry!
	set category = "Abilities"
	set name = "Shapeshift (50)"
	set desc = "This does nothing.  It's broken.  Sorry!"//orig text: Changes your name and appearance at the cost of 50 blood and has a cooldown of 3 minutes.
/*	var/datum/mind/M = usr.mind
	if(!M) return
	if(M.current.vampire_power(50, 0))
		M.current.visible_message("<span class='warning'>[M.current.name] transforms!</span>")
		M.current.client.prefs.real_name = M.current.generate_name() //random_name(M.current.gender)
		M.current.client.prefs.randomize_appearance_for(M.current)
		M.current.regenerate_icons()
		M.current.remove_vampire_blood(50)
		M.current.verbs -= /client/vampire/proc/vampire_shapeshift
		spawn(1800) M.current.verbs += /client/vampire/proc/vampire_shapeshift
*/
/client/vampire/proc/vampire_screech()
	set category = "Abilities"
	set name = "Chiropteran  Screech (90)"
	set desc = "An extremely loud shriek that stuns nearby humans in a four-tile radius, as well as shattering the windows."
	var/datum/mind/M = usr.mind
	if(!M) return
	if(M.current.vampire_power(90, 0))
		M.current.visible_message("\red [M.current.name] lets out an ear piercing shriek!", "\red You let out a loud shriek.", "\red You hear a loud painful shriek!")
		for(var/mob/living/carbon/C in hearers(4, M.current))
			if(C == M.current) continue
			if(ishuman(C) && (C:l_ear || C:r_ear) && istype((C:l_ear || C:r_ear), /obj/item/clothing/ears/earmuffs)) continue
			if(!C.vampire_affected(M))
				if(!C.get_species() == "Machine")
					continue
			C << "<span class='warning'><font size='3'><b>You hear a ear piercing shriek and your senses dull!</font></b></span>"
			C.Weaken(5)
			C.ear_deaf = 20
			C.stuttering = 20
			C.Stun(5)
//			C.Jitter(150)
		for(var/obj/structure/window/W in view(7))
			W.shatter()
		playsound(M.current.loc, 'sound/effects/creepyshriek.ogg', 100, 1)
		M.current.remove_vampire_blood(90)
		M.current.verbs -= /client/vampire/proc/vampire_screech
		spawn(3600) M.current.verbs += /client/vampire/proc/vampire_screech

/client/vampire/proc/vampire_enthrall()
	set category = "Abilities"
	set name = "Enthrall (150)"
	set desc = "You use a large portion of your power to sway those loyal to none to be loyal to you only."
	var/datum/mind/M = usr.mind
	if(!M) return
	var/mob/living/carbon/C = M.current.vampire_active(150, 0, 1)
	if(!C) return
	if(C==usr)
		M.current << "\red You can't do that to yourself"
		return
	if(C.get_species() == "Machine")
		M.current << "\red You can only enthrall humans"
		return
	M.current.visible_message("\red [M.current.name] bites [C.name]'s neck!", "\red You bite [C.name]'s neck and begin the flow of power.")
	C << "<span class='warning'>You feel the tendrils of evil invade your mind.</span>"
	if(!ishuman(C))
		M.current << "\red You can only enthrall humans"
		return

	if(do_mob(M.current, C, 50))
		if(M.current.can_enthrall(C)) // recheck
			if(M.current.vampire_power(150, 0))
				M.current.handle_enthrall(C)
				M.current.remove_vampire_blood(150)
				M.current.verbs -= /client/vampire/proc/vampire_enthrall
				spawn(1800) M.current.verbs += /client/vampire/proc/vampire_enthrall
		return
	else
		M.current << "\red You or your target either moved or you dont have enough usable blood."
		return

/client/vampire/proc/vampire_cloak()
	set category = "Abilities"
	set name = "Cloak of Darkness (toggle)"
	set desc = "Toggles whether you are currently cloaking yourself in darkness."
	var/datum/mind/M = usr.mind
	if(!M) return
	if(M.current.vampire_power(0, 0))
		M.vampire.iscloaking = !M.vampire.iscloaking
		M.current << "\blue You will now be [M.vampire.iscloaking ? "hidden" : "seen"] in darkness."

/mob/proc/handle_vampire_cloak()
	if(!mind || !mind.vampire || !ishuman(src))
		alpha = 255
		return
	var/turf/simulated/T = get_turf(src)

	if(!istype(T))
		return 0

	if(!mind.vampire.iscloaking)
		alpha = 255
		return 0
//	if(T.lighting_lumcount <= 2)
//		alpha = round((255 * 0.15))
//		return 1
	else
		alpha = round((255 * 0.80))

/mob/proc/can_enthrall(mob/living/carbon/C)
	var/enthrall_safe = 0
	var/datum/vampire/vampire = src.mind.vampire
	for(var/obj/item/weapon/implant/loyalty/L in C)
		if(L && L.implanted)
			enthrall_safe = 1
			break
//	for(var/obj/item/weapon/implant/traitor/T in C)
//		if(T && T.implanted)
//			enthrall_safe = 1
//			break
	if(!C)
		world.log << "something bad happened on enthralling a mob src is [src] [src.key] \ref[src]"
		return 0
	if(!C.mind)
		src << "\red [C.name]'s mind is not there for you to enthrall."
		return 0
	if(enthrall_safe || ( C.mind in vampire.vampires )||( C.mind.vampire )||( C.mind in vampire.enthralled ))
		C.visible_message("\red [C] seems to resist the takeover!", "\blue You feel a familiar sensation in your skull that quickly dissipates.")
		return 0
	if(!C.vampire_affected(mind))
		C.visible_message("\red [C] seems to resist the takeover!", "\blue Your faith of [ticker.Bible_deity_name] has kept your mind clear of all evil")
		return 0
	if(!ishuman(C))
		src << "\red You can only enthrall humans!"
		return 0
	return 1

/mob/proc/handle_enthrall(mob/living/carbon/human/H as mob)
	if(!istype(H))
		//msg_scopes("handle_enthrall fucked up with no H < [src]")
		src << "<b>\red SOMETHING WENT WRONG, YELL AT POMF OR NEXIS</b>"
		return 0
	var/ref = "\ref[src.mind]"
	if(!(src.mind.vampire.thralls))
		src.mind.vampire.thralls[ref] = list(H.mind)
	else
		src.mind.vampire.thralls[ref] += H.mind
	//msg_scopes("[H.name] Changed in handle_enthrall") //purely here to see live changes incase of unexpected things
	src.mind.vampire.enthralled.Add(H.mind)
	src.mind.vampire.enthralled[H.mind] = src.mind
	H.mind.special_role = "VampThrall"
	H << "<b>\red You have been Enthralled by [name]. Follow their every command.</b>"
	src << "\red You have successfully Enthralled [H.name]. <i>If they refuse to do as you say just adminhelp.</i>"
	var/client/vampire/c = src
	c.update_vampire_icons_added(H.mind)
	c.update_vampire_icons_added(src.mind)
	msg_admin_attack("[key_name_admin(src)] has mind-slaved [key_name_admin(H)] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[H.x];Y=[H.y];Z=[H.z]'>JMP</a>.")

/client/vampire/proc/vampire_bats()
	set category = "Abilities"
	set name = "Summon Bats (60)"
	set desc = "You summon a pair of space bats who attack nearby targets until they or their target is dead."
	var/datum/mind/M = usr.mind
	if(!M) return
	if(M.current.vampire_power(60, 0))
		var/list/turf/locs = new
		var/number = 0
		for(var/direction in alldirs) //looking for bat spawns
			if(locs.len == 2) //we found 2 locations and thats all we need
				break
			var/turf/T = get_step(M.current,direction) //getting a loc in that direction
			if(AStar(M.current.loc, T, /turf/proc/AdjacentTurfs, /turf/proc/Distance, 1)) // if a path exists, so no dense objects in the way its valid salid
				locs += T
		if(locs.len)
			for(var/turf/tospawn in locs)
				number++
				new /mob/living/simple_animal/hostile/scarybat(tospawn, M.current)
			if(number != 2) //if we only found one location, spawn one on top of our tile so we dont get stacked bats
				new /mob/living/simple_animal/hostile/scarybat(M.current.loc, M.current)
		else // we had no good locations so make two on top of us
			new /mob/living/simple_animal/hostile/scarybat(M.current.loc, M.current)
			new /mob/living/simple_animal/hostile/scarybat(M.current.loc, M.current)
		M.current.remove_vampire_blood(60)
		M.current.verbs -= /client/vampire/proc/vampire_bats
		spawn(1200) M.current.verbs += /client/vampire/proc/vampire_bats

/client/vampire/proc/vampire_jaunt()
	//AHOY COPY PASTE INCOMING
	set category = "Abilities"
	set name = "Mist Form (30)"
	set desc = "You take on the form of mist for a short period of time."
	var/jaunt_duration = 50 //in deciseconds
	var/datum/mind/M = usr.mind
	if(!M) return

	if(M.current.vampire_power(30, 0))
		if(M.current.buckled) M.current.buckled.unbuckle_mob()
		spawn(0)
			var/originalloc = get_turf(M.current.loc)
			var/obj/effect/dummy/spell_jaunt/holder = new /obj/effect/dummy/spell_jaunt( originalloc )
			var/atom/movable/overlay/animation = new /atom/movable/overlay( originalloc )
			animation.name = "water"
			animation.density = 0
			animation.anchored = 1
			animation.icon = 'icons/mob/mob.dmi'
			animation.icon_state = "liquify"
			animation.layer = 5
			animation.master = holder
			M.current.ExtinguishMob()
			M.current.weakened = 0
			M.current.stunned = 0
			if(M.current.buckled)
				M.current.buckled.unbuckle_mob()
			flick("liquify",animation)
			M.current.loc = holder
			M.current.client.eye = holder
			var/datum/effect/effect/system/steam_spread/steam = new /datum/effect/effect/system/steam_spread()
			steam.set_up(10, 0, originalloc)
			steam.start()
			sleep(jaunt_duration)
			var/mobloc = get_turf(M.current.loc)
/*			if(get_area(mobloc) == /area/security/armoury/gamma)
				M << "A strange energy repels you!"
				mobloc = originalloc*/
			animation.loc = mobloc
			steam.location = mobloc
			steam.start()
			M.current.canmove = 0
			sleep(20)
			flick("reappear",animation)
			sleep(5)
			if(!M.current.Move(mobloc))
				for(var/direction in list(1,2,4,8,5,6,9,10))
					var/turf/T = get_step(mobloc, direction)
					if(T)
						if(M.current.Move(T))
							break
			M.current.canmove = 1
			M.current.client.eye = M.current
			qdel(animation)
			qdel(holder)
		M.current.remove_vampire_blood(30)
		M.current.verbs -= /client/vampire/proc/vampire_jaunt
		spawn(600) M.current.verbs += /client/vampire/proc/vampire_jaunt

// Blink for vamps
// Less smoke spam.
/client/vampire/proc/vampire_shadowstep()
	set category = "Abilities"
	set name = "Shadowstep (30)"
	set desc = "Vanish into the shadows."
	var/datum/mind/M = usr.mind
	if(!M) return

	// Teleport radii
	var/inner_tele_radius = 0
	var/outer_tele_radius = 6

	// Maximum lighting_lumcount.
//	var/max_lum = 1

	if(M.current.vampire_power(30, 0))
		if(M.current.buckled) M.current.buckled.unbuckle_mob()
		spawn(0)
			var/list/turfs = new/list()
			for(var/turf/T in range(usr,outer_tele_radius))
				if(T in range(usr,inner_tele_radius)) continue
				if(istype(T,/turf/space)) continue
				if(T.density) continue
				if(T.x>world.maxx-outer_tele_radius || T.x<outer_tele_radius)	continue	//putting them at the edge is dumb
				if(T.y>world.maxy-outer_tele_radius || T.y<outer_tele_radius)	continue

				// LIGHTING CHECK
			//	if(T.lighting_lumcount > max_lum) continue
			//	turfs += T
				//M.current.remove_vampire_blood(30) This isn't the right place for this either.

			if(!turfs.len)
				usr << "\red You cannot find darkness to step to."
				return

			var/turf/picked = pick(turfs)

			if(!picked || !isturf(picked))
				return
			M.current.ExtinguishMob()
			if(M.current.buckled)
				M.current.buckled.unbuckle_mob()
			var/atom/movable/overlay/animation = new /atom/movable/overlay( get_turf(usr) )
			animation.name = usr.name
			animation.density = 0
			animation.anchored = 1
			animation.icon = usr.icon
			animation.alpha = 127
			animation.layer = 5
			//animation.master = src
			usr.loc = picked
			M.current.remove_vampire_blood(30)
			spawn(10)
				qdel(animation)
//		M.current.remove_vampire_blood(30)
		M.current.verbs -= /client/vampire/proc/vampire_shadowstep
		spawn(20)
			M.current.verbs += /client/vampire/proc/vampire_shadowstep

/mob/proc/remove_vampire_blood(amount = 0)
	var/bloodold
	if(!mind || !mind.vampire)
		return
	bloodold = mind.vampire.bloodusable
	mind.vampire.bloodusable = max(0, (mind.vampire.bloodusable - amount))
	if(bloodold != mind.vampire.bloodusable)
		src << "\blue <b>You have [mind.vampire.bloodusable] left to use.</b>"

//prepare for copypaste
/client/vampire/proc/update_vampire_icons_added(datum/mind/vampire_mind)
	var/ref = "\ref[vampire_mind]"
	if(ref in vampire_mind.vampire.thralls)
		if(vampire_mind.current)
			if(vampire_mind.current.client)
				var/I = image('icons/mob/mob.dmi', loc = vampire_mind.current, icon_state = "vampire")
				vampire_mind.current.client.images += I
	for(var/headref in vampire_mind.vampire.thralls)
		for(var/datum/mind/t_mind in vampire_mind.vampire.thralls[headref])
			var/datum/mind/head = locate(headref)
			if(head)
				if(head.current)
					if(head.current.client)
						var/I = image('icons/mob/mob.dmi', loc = t_mind.current, icon_state = "vampthrall")
						head.current.client.images += I
				if(t_mind.current)
					if(t_mind.current.client)
						var/I = image('icons/mob/mob.dmi', loc = head.current, icon_state = "vampire")
						t_mind.current.client.images += I
				if(t_mind.current)
					if(t_mind.current.client)
						var/I = image('icons/mob/mob.dmi', loc = t_mind.current, icon_state = "vampthrall")
						t_mind.current.client.images += I

/client/vampire/proc/update_vampire_icons_removed(datum/mind/vampire_mind)
	for(var/headref in vampire_mind.vampire.thralls)
		var/datum/mind/head = locate(headref)
		for(var/datum/mind/t_mind in vampire_mind.vampire.thralls[headref])
			if(t_mind.current)
				if(t_mind.current.client)
					for(var/image/I in t_mind.current.client.images)
						if((I.icon_state == "vampthrall" || I.icon_state == "vampire") && I.loc == vampire_mind.current)
							//world.log << "deleting [vampire_mind] overlay"
							qdel(I)
		if(head)
			//world.log << "found [head.name]"
			if(head.current)
				if(head.current.client)
					for(var/image/I in head.current.client.images)
						if((I.icon_state == "vampthrall" || I.icon_state == "vampire") && I.loc == vampire_mind.current)
							//world.log << "deleting [vampire_mind] overlay"
							qdel(I)
	if(vampire_mind.current)
		if(vampire_mind.current.client)
			for(var/image/I in vampire_mind.current.client.images)
				if(I.icon_state == "vampthrall" || I.icon_state == "vampire")
					qdel(I)

/client/vampire/proc/remove_vampire_mind(datum/mind/vampire_mind, datum/mind/head)
	//var/list/removal
	if(!istype(head))
		head = vampire_mind //workaround for removing a thrall's control over the enthralled
	var/ref = "\ref[head]"
	if(vampire_mind.vampire.thralls)
		vampire_mind.vampire.thralls[ref] -= vampire_mind
	vampire_mind.vampire.enthralled -= vampire_mind
	//vampire.special_role = null
	update_vampire_icons_removed(vampire_mind)
	//world << "Removed [vampire_mind.current.name] from vampire shit"
	vampire_mind.current << "\red <FONT size = 3><B>The fog clouding your mind clears. You remember nothing from the moment you were enthralled until now.</B></FONT>"

/mob/living/carbon/human/proc/check_sun()

	var/ax = x
	var/ay = y

	for(var/i = 1 to 20)
		ax += sun.dx
		ay += sun.dy

		var/turf/T = locate( round(ax,0.5),round(ay,0.5),z)

		if(T.x == 1 || T.x==world.maxx || T.y==1 || T.y==world.maxy)
			break

		if(T.density)
			return
	if(prob(35))
		switch(health)
			if(80 to 100)
				src << "\red Your skin flakes away..."
			if(60 to 80)
				src << "<span class='warning'>Your skin sizzles!</span>"
	//		if((-INFINITY) to 60)
	//			if(!on_fire)
	//				src << "<b>\red Your skin catches fire!</b>"
	//			else
	//				src << "<b>\red You continue to burn!</b>"
	//			fire_stacks += 5
	//			IgniteMob()
	//	emote("scream")
	//else
	//	switch(health)
	//		if((-INFINITY) to 60)
	//			fire_stacks++
	//			IgniteMob()
	adjustFireLoss(30) //Original value was 3.  Barely did anything.  Vamps should vaporize in starlight.

/mob/living/carbon/human/proc/handle_vampire()
/*	if(hud_used)
		if(!hud_used.vampire_blood_display)
			hud_used.vampire_hud()
			hud_used.human_hud('icons/mob/screen1_Vampire.dmi')
		hud_used.vampire_blood_display.maptext_width = 64
		hud_used.vampire_blood_display.maptext_height = 26
		hud_used.vampire_blood_display.maptext = "<div align='left' valign='top' style='position:relative; top:0px; left:6px'> U:<font color='#33FF33' size='1'>[mind.vampire.bloodusable]</font><br> T:<font color='#FFFF00' size='1'>[mind.vampire.bloodtotal]</font></div>"
		*/
	handle_vampire_cloak()
	if(istype(loc, /turf/space))
		check_sun()
	mind.vampire.nullified = max(0, mind.vampire.nullified - 1)
