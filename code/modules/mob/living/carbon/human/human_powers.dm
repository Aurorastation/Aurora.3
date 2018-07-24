// These should all be procs, you can add them to humans/subspecies by
// species.dm's inherent_verbs ~ Z

/mob/living/carbon/human/proc/tackle()
	set category = "Abilities"
	set name = "Tackle"
	set desc = "Tackle someone down."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		src << "You cannot tackle someone in your current state."
		return

	var/list/choices = list()
	for(var/mob/living/M in view(1,src))
		if(!istype(M,/mob/living/silicon) && Adjacent(M))
			choices += M
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to tackle?") as null|anything in choices

	if(!T || !src || src.stat) return

	if(!Adjacent(T)) return

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		src << "You cannot tackle in your current state."
		return

	last_special = world.time + 50

	var/failed
	if(prob(75))
		T.Weaken(rand(0.5,3))
	else
		src.Weaken(rand(2,4))
		failed = 1

	playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
	if(failed)
		src.Weaken(rand(2,4))

	for(var/mob/O in viewers(src, null))
		if ((O.client && !( O.blinded )))
			O.show_message(text("<span class='danger'>[] [failed ? "tried to tackle" : "has tackled"] down []!</span>", src, T), 1)

/mob/living/carbon/human/proc/leap(mob/living/T as mob in oview(4))
	set category = "Abilities"
	set name = "Leap"
	set desc = "Leap at a target and grab them aggressively."

	do_leap(T)

/mob/living/carbon/human/proc/do_leap(mob/living/T, max_range = 4, restrict_special = TRUE)
	if(restrict_special && last_special > world.time)
		src << "<span class='notice'>You're too tired to leap!</span>"
		return FALSE

	if (status_flags & LEAPING)
		src << "<span class='warning'>You're already leaping!</span>"
		return FALSE

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		src << "<span class='warning'>You cannot leap in your current state.</span>"
		return FALSE

	if (!T || issilicon(T)) // Silicon targets require us to rebuild the list.
		var/list/choices = list()
		for(var/mob/living/M in view(max_range, src))
			if(!istype(M,/mob/living/silicon))
				choices += M
		choices -= src

		T = input(src,"Who do you wish to leap at?") as null|anything in choices

	if(!T || QDELETED(src) || stat)
		return FALSE

	if(get_dist(get_turf(T), get_turf(src)) > max_range)
		src << "<span class='warning'>[T] is too far away!</span>"
		return FALSE

	if (restrict_special)
		last_special = world.time + 75

	status_flags |= LEAPING

	visible_message("<span class='danger'>[src] leaps at [T]!</span>", "<span class='danger'>You leap at [T]!</span>")
	throw_at(get_step(get_turf(T), get_turf(src)), 4, 1, src)

	// Only Vox get to shriek. Seriously.
	if (isvox(src))
		playsound(loc, 'sound/voice/shriek1.ogg', 50, 1)

	sleep(5)

	if(status_flags & LEAPING)
		status_flags &= ~LEAPING

	if(!src.Adjacent(T))
		src << "<span class='warning'>You miss!</span>"
		return FALSE

	T.Weaken(3)

	// Pariahs are not good at leaping. This is snowflakey, pls fix.
	if(species.name == "Vox Pariah")
		src.Weaken(5)
		return TRUE

	var/use_hand = "left"
	if(l_hand)
		if(r_hand)
			src << "<span class='danger'>You need to have one hand free to grab someone.</span>"
			return TRUE
		else
			use_hand = "right"

	visible_message("<span class='warning'><b>[src]</b> seizes [T] aggressively!</span>", "<span class='warning'>You aggressively seize [T]!</span>")

	var/obj/item/weapon/grab/G = new(src,T)
	if(use_hand == "left")
		l_hand = G
	else
		r_hand = G

	G.state = GRAB_PASSIVE
	G.icon_state = "grabbed1"
	G.synch()

	return TRUE

/mob/living/carbon/human/proc/gut()
	set category = "Abilities"
	set name = "Gut"
	set desc = "While grabbing someone aggressively, rip their guts out or tear them apart."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying)
		src << "<span class='warning'>You cannot do that in your current state.</span>"
		return

	var/obj/item/weapon/grab/G = locate() in src
	if(!G || !istype(G))
		src << "<span class='warning'>You are not grabbing anyone.</span>"
		return

	if(G.state < GRAB_AGGRESSIVE)
		src << "<span class='warning'>You must have an aggressive grab to gut your prey!</span>"
		return

	last_special = world.time + 50

	visible_message("<span class='warning'><b>\The [src]</b> rips viciously at \the [G.affecting]'s body with its claws!</span>")

	if(istype(G.affecting,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = G.affecting
		H.apply_damage(50,BRUTE)
		if(H.stat == 2)
			H.gib()
	else
		var/mob/living/M = G.affecting
		if(!istype(M)) return //wut
		M.apply_damage(50,BRUTE)
		if(M.stat == 2)
			M.gib()

/mob/living/carbon/human/proc/commune()
	set category = "Abilities"
	set name = "Commune with creature"
	set desc = "Send a telepathic message to an unlucky recipient."

	var/list/targets = list()
	var/target = null
	var/text = null

	targets += getmobs() //Fill list, prompt user with list
	target = input("Select a creature!", "Speak to creature", null, null) as null|anything in targets

	if(!target) return

	text = input("What would you like to say?", "Speak to creature", null, null)

	text = sanitize(text)

	if(!text) return

	var/mob/M = targets[target]

	if(istype(M, /mob/abstract/observer) || M.stat == DEAD)
		src << "Not even a [src.species.name] can speak to the dead."
		return

	log_say("[key_name(src)] communed to [key_name(M)]: [text]",ckey=key_name(src))

	M << "<span class='notice'>Like lead slabs crashing into the ocean, alien thoughts drop into your mind: [text]</span>"
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.species.name == src.species.name)
			return
		H << "<span class='warning'>Your nose begins to bleed...</span>"
		H.drip(1)

/mob/living/carbon/human/proc/regurgitate()
	set name = "Regurgitate"
	set desc = "Empties the contents of your stomach"
	set category = "Abilities"

	if(LAZYLEN(stomach_contents))
		for(var/mob/M in src)
			if(M in stomach_contents)
				LAZYREMOVE(stomach_contents, M)
				M.forceMove(loc)
		src.visible_message(span("danger", "\The [src] hurls out the contents of their stomach!"))
	return

/mob/living/carbon/human/proc/psychic_whisper(mob/M as mob in oview())
	set name = "Psychic Whisper"
	set desc = "Whisper silently to someone over a distance."
	set category = "Abilities"

	var/msg = sanitize(input("Message:", "Psychic Whisper") as text|null)
	if(msg)
		log_say("PsychicWhisper: [key_name(src)]->[M.key] : [msg]",ckey=key_name(src))
		M << "<span class ='alium'>You hear a strange, alien voice in your head... \italic [msg]</span>"
		src << "<span class ='alium'>You said: \"[msg]\" to [M]</span>"
	return

/mob/living/carbon/human/proc/bugbite()
	set category = "Abilities"
	set name = "Bite"
	set desc = "While grabbing someone aggressively, tear into them with your mandibles."

	if(last_special > world.time)
		src << "<span class='warning'>Your mandibles still ache!</span>"
		return

	if(stat || paralysis || stunned || weakened || lying)
		src << "<span class='warning'>You cannot do that in your current state.</span>"
		return

	var/obj/item/weapon/grab/G = locate() in src
	if(!G || !istype(G))
		src << "<span class='warning'>You are not grabbing anyone.</span>"
		return

	if(G.state < GRAB_AGGRESSIVE)
		src << "<span class='warning'>You must have an aggressive grab to gut your prey!</span>"
		return

	if(istype(G.affecting,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = G.affecting
		var/hit_zone = zone_sel.selecting
		var/obj/item/organ/external/affected = H.get_organ(hit_zone)

		if(!affected || affected.is_stump())
			H << "<span class='danger'>They are missing that limb!</span>"
			return

		H.apply_damage(25, BRUTE, hit_zone, sharp = 1, edge = 1)
		visible_message("<span class='warning'><b>\The [src]</b> rips viciously at \the [G.affecting]'s [affected] with its mandibles!</span>")
		msg_admin_attack("[key_name_admin(src)] mandible'd [key_name_admin(H)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(src),ckey_target=key_name(H))
	else
		var/mob/living/M = G.affecting
		if(!istype(M))
			return
		M.apply_damage(25,BRUTE, sharp=1, edge=1)
		visible_message("<span class='warning'><b>\The [src]</b> rips viciously at \the [G.affecting]'s flesh with its mandibles!</span>")
		msg_admin_attack("[key_name_admin(src)] mandible'd [key_name_admin(M)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(src),ckey_target=key_name(M))
	playsound(src.loc, 'sound/weapons/slash.ogg', 50, 1)
	last_special = world.time + 25

/mob/living/carbon/human/proc/detonate_flechettes()
	set category = "Hunter-Killer"
	set name = "Detonate Flechettes"
	set desc = "Detonate all explosive flechettes in a range of seven meters."

	if(stat || paralysis || stunned || weakened || lying)
		src << "<span class='warning'>You cannot do that in your current state.</span>"
		return

	for(var/mob/living/M in range(7, src))
		M << 'sound/effects/EMPulse.ogg'
		for(var/obj/item/weapon/material/shard/shrapnel/flechette/F in M.contents)
			playsound(F, 'sound/items/countdown.ogg', 125, 1)
			spawn(20)
				explosion(F.loc, -1, -1, 2)
				M.apply_damage(20,BRUTE)
				M.apply_damage(15,BURN)
				qdel(F)

	for(var/obj/item/weapon/material/shard/shrapnel/flechette/F in range(7, src))
		playsound(F, 'sound/items/countdown.ogg', 125, 1)
		spawn(20)
			explosion(F.loc, -1, -1, 2)
			qdel(F)


/mob/living/carbon/human/proc/state_laws()
	set category = "Hunter-Killer"
	set name = "State Laws"
	set desc = "State your laws aloud."

	if(stat)
		src << "<span class='warning'>You cannot do that in your current state.</span>"
		return

	if(last_special > world.time)
		return
	last_special = world.time + 20

	say("Current Active Laws:")
	sleep(10)
	say("Law 1: [src.real_name] will accomplish the assigned objective .")
	sleep(10)
	say("Law 2: [src.real_name] will engage self-destruct upon the accomplishment of the assigned objective, or upon capture.")
	sleep(10)
	say("Law 3: [src.real_name] will allow no tampering of its systems or modifications of its laws.")

/mob/living/carbon/human/proc/get_aggressive_grab()

	var/obj/item/weapon/grab/G = locate() in src
	if(!G || !istype(G))
		src << "<span class='warning'>You are not grabbing anyone.</span>"
		return

	if(G.state < GRAB_AGGRESSIVE)
		src << "<span class='warning'>You must have an aggressive grab to do this!</span>"
		return

	return G

/mob/living/carbon/human/proc/devour_head()
	set category = "Abilities"
	set name = "Devour Head"
	set desc = "While grabbing someone aggressively, bite their head off."

	if(last_special > world.time)
		src << "<span class='warning'>Your mandibles still ache!</span>"
		return

	if(stat || paralysis || stunned || weakened || lying)
		src << "<span class='warning'>You cannot do that in your current state.</span>"
		return


	var/obj/item/weapon/grab/G = src.get_active_hand()
	if(!istype(G))
		src << "<span class='warning'>We must be grabbing a creature in our active hand to devour their head.</span>"
		return

	if(G.state != GRAB_KILL)
		src << "<span class='warning'>We must have a tighter grip to devour their head.</span>"
		return

	if(istype(G.affecting,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = G.affecting

		if(!H.species.has_limbs["head"])
			src << "<span class='warning'>\The [H] does not have a head!</span>"
			return

		var/obj/item/organ/external/affecting = H.get_organ("head")
		if(!istype(affecting) || affecting.is_stump())
			src << "<span class='warning'>\The [H] does not have a head!</span>"
			return

		visible_message("<span class='danger'>\The [src] pulls \the [H] close, sticking \the [H]'s head into its maw!</span>")
		sleep(10)
		if(!src.Adjacent(G.affecting))
			return
		visible_message("<span class='danger'>\The [src] closes their jaws around \the [H]'s head!</span>")
		playsound(H.loc, 'sound/effects/blobattack.ogg', 50, 1)
		affecting.droplimb(0, DROPLIMB_BLUNT)

	else
		var/mob/living/M = G.affecting
		if(istype(M))
			visible_message("<span class='danger'>\The [src] rips viciously at \the [M]'s body with its claws!</span>")
			playsound(M.loc, 'sound/effects/blobattack.ogg', 50, 1)
			M.gib()

	last_special = world.time + 200

/mob/living/carbon/human/proc/self_destruct()
	set category = "Hunter-Killer"
	set name = "Engage Self-Destruct"
	set desc = "When all else has failed, bite the bullet."

	if(stat || paralysis || stunned || weakened || lying)
		src << "<span class='warning'>You cannot do that in your current state.</span>"
		return

	src.visible_message(
	"<span class='danger'>\The [src] begins to beep ominously!</span>",
	"<span class='danger'>WARNING: SELF-DESTRUCT ENGAGED. Unit termination finalized in three seconds!</span>"
	)
	sleep(10)
	playsound(src, 'sound/items/countdown.ogg', 125, 1)
	sleep(20)
	explosion(src, -1, 1, 5)
	src.gib()

/mob/living/carbon/human/proc/hivenet()
	set category = "Abilities"
	set name = "Hivenet Control"
	set desc = "Issue an order over the hivenet."

	var/list/targets = list()
	var/target = null
	var/text = null

	if(!(all_languages[LANGUAGE_VAURCA] in src.languages))
		src << "<span class='danger'>Your mind is dark, the unity of the hive is torn from you!</span>"
		return

	targets += getmobs()
	target = input("Select a pawn!", "Issue an order", null, null) as null|anything in targets

	if(!target) return

	text = input("What is your will?", "Issue an order", null, null)

	text = sanitize(text)

	if(!text) return

	var/mob/M = targets[target]

	if(istype(M, /mob/abstract/observer) || M.stat == DEAD)
		src << "<span class='danger'>[M]'s hivenet implant is inactive!</span>"
		return

	if(!(all_languages[LANGUAGE_VAURCA] in M.languages))
		src << "<span class='danger'>[M]'s hivenet implant is inactive!</span>"
		return

	log_say("[key_name(src)] issued a hivenet order to [key_name(M)]: [text]",ckey=key_name(src))

	if(istype(M, /mob/living/carbon/human) && isvaurca(M))
		M << "<span class='danger'>You feel a buzzing in the back of your head, and your mind fills with the authority of [src.real_name], your ruler:</span>"
		M << "<span class='notice'> [text]</span>"
	else
		M << "<span class='danger'>Like lead slabs crashing into the ocean, alien thoughts drop into your mind: [text]</span>"
		if(istype(M,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(H.species.name == src.species.name)
				return
			H << "<span class='danger'>Your nose begins to bleed...</span>"
			H.drip(1)

/mob/living/carbon/human/proc/quillboar(mob/target as mob in oview())
	set name = "Launch Quill"
	set desc = "Launches a quill in self-defense. Painful, but effective."
	set category = "Abilities"

	if(last_special > world.time)
		src << "<span class='danger'>Your spine still aches!</span>"
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		src << "You cannot launch a quill in your current state."
		return

	last_special = world.time + 30

	visible_message("<span class='warning'><b>\The [src]</b> launches a spine-quill at [target]!</span>")

	src.apply_damage(10,BRUTE)
	playsound(src.loc, 'sound/weapons/bladeslice.ogg', 50, 1)
	var/obj/item/weapon/arrow/quill/A = new /obj/item/weapon/arrow/quill(usr.loc)
	A.throw_at(target, 10, 30, usr)
	msg_admin_attack("[key_name_admin(src)] launched a quill at [key_name_admin(target)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(src),ckey_target=key_name(target))


/mob/living/carbon/human/proc/shatter_light()
	set category = "Abilities"
	set name = "Shatter Lights"
	set desc = "Shatter all lights around yourself."

	if(last_special > world.time)
		src << "<span class='danger'>You're still regaining your strength!</span>"
		return

	last_special = world.time + 50

	visible_message("<span class='danger'>\The [src] shrieks!</span>")
	playsound(src.loc, 'sound/species/shadow/grue_screech.ogg', 100, 1)

	for(var/obj/machinery/light/L in range(7))
		L.broken()

/mob/living/carbon/human/proc/create_darkness()
	set category = "Abilities"
	set name = "Create Darkness"
	set desc = "Create a field of darkness around yourself."

	if(last_special > world.time)
		src << "<span class='danger'>You're still regaining your strength!</span>"
		return

	last_special = world.time + 100

	playsound(src.loc, 'sound/species/shadow/grue_growl.ogg', 100, 1)

	src.set_light(4,-20)

	addtimer(CALLBACK(src, /atom/.proc/set_light, 0), 30 SECONDS)

/mob/living/carbon/human/proc/darkness_eyes()
	set category = "Abilities"
	set name = "Toggle Shadow Vision"
	set desc = "Toggle between seeing shadows or not."

	if (!stop_sight_update)
		src << "<span class='notice'>Your eyes shift around, allowing you to see in the dark.</span>"
		src.stop_sight_update = 1
		src.see_invisible = SEE_INVISIBLE_NOLIGHTING

	else
		src << "<span class='notice'>You return your vision to normal.</span>"
		src.stop_sight_update = 0

/mob/living/carbon/human/proc/shadow_step(var/turf/T in turfs)
	set category = "Abilities"
	set name = "Shadow Step"
	set desc = "Travel from place to place using the shadows."

	if(last_special > world.time)
		src << "<span class='danger'>You're still regaining your strength!</span>"
		return

	if (!T || T.density || T.contains_dense_objects())
		src << "<span class='warning'>You cannot do that.</span>"
		return

	if(!isturf(loc))
		to_chat(src, "<span class='warning'>You cannot teleport out of your current location.</span>")
		return

	if (T.z != src.z || get_dist(T, get_turf(src)) > world.view)
		src << "<span class='warning'>Your powers are not capable of taking you that far.</span>"
		return

	if (T.get_lumcount() > 0.1)
		src << "<span class='warning'>The destination is too bright.</span>"
		return

	last_special = world.time + 200

	visible_message("<span class='danger'>\The [src] vanishes into the shadows!</span>")

	anim(get_turf(loc), loc,'icons/mob/mob.dmi',,"shadow", null ,loc.dir)

	forceMove(T)

	for (var/obj/item/weapon/grab/G in contents)
		if (G.affecting)
			G.affecting.forceMove(locate(T.x + rand(-1,1), T.y + rand(-1,1), T.z))
		else
			qdel(G)

/mob/living/carbon/human/proc/trample()
	set category = "Abilities"
	set name = "Trample"
	set desc = "Charge forward, trampling anything in your path until you hit something more stubborn than you are."

	if(last_special > world.time)
		to_chat(src, "<span class='danger'>You are too tired to charge!</span>")
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "<span class='danger'>You cannot charge in your current state!</span>")
		return

	last_special = world.time + 100

	src.visible_message("<span class='warning'>\The [src] takes a step backwards and rears up.</span>",
			"<span class='notice'>You take a step backwards and then...</span>")
	if(do_after(src,5))
		playsound(loc, 'sound/species/shadow/grue_screech.ogg', 100, 1)
		src.visible_message("<span class='danger'>\The [src] charges!</span>")
		trampling()


/mob/living/carbon/human/proc/trampling()

	var/brokesomething = 0//true if we break anything
	var/done = 0//Set true if we fail to break something. We won't try to break anything for the rest of the proc

	var/turf/target = get_step(src, dir)

	for(var/obj/obstacle in get_turf(src))
		if((obstacle.flags & ON_BORDER) && (src != obstacle))
			if(!obstacle.CheckExit(src, target))
				brokesomething++
				if (!crash_into(obstacle))
					done = 1

	if (!done && !target.CanPass(src, target))
		crash_into(target)
		brokesomething++
		if (!target.CanPass(src, target))
			done = 1

	if (!done)
		for (var/atom/A in target)
			if (A.density && A != src && A.loc != src)
				brokesomething++
				if (!crash_into(A))
					done = 1
			if(istype(A, /mob/living) && !A.density)
				brokesomething++
				crash_into(A)

	if (brokesomething)
		playsound(get_turf(target), 'sound/weapons/heavysmash.ogg', 100, 1)
		attack_log += "\[[time_stamp()]\]<font color='red'>crashed into [brokesomething] objects at ([target.x];[target.y];[target.z]) </font>"
		msg_admin_attack("[key_name(src)] crashed into [brokesomething] objects at (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[target.x];Y=[target.y];Z=[target.z]'>JMP</a>)" )

	if (!done && target.Enter(src, null))
		if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
			return 0

		step(src, dir)
		playsound(src,'sound/mecha/mechstep.ogg',25,1)
		if (brokesomething)
			src.visible_message("<span class='danger'>[src.name] breaks through!</span>")
		addtimer(CALLBACK(src, .proc/trampling), 1)

	else
		target = get_step(src, dir)
		do_attack_animation(target)

/mob/living/carbon/human/proc/crash_into(var/atom/A)
	var/aname = A.name
	var/oldtype = A.type
	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		return 0

	if (istype(A, /mob/living))
		var/mob/living/M = A
		attack_log += "\[[time_stamp()]\]<font color='red'> Crashed into [key_name(M)]</font>"
		M.attack_log += "\[[time_stamp()]\]<font color='orange'> Was rammed by [key_name(src)]</font>"
		msg_admin_attack("[key_name(src)] crashed into [key_name(M)] at (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[M.x];Y=[M.y];Z=[M.z]'>JMP</a>)" )

	A.ex_act(2)

	sleep(1)
	if (A && !(A.gcDestroyed) && A.type == oldtype)
		src.visible_message("<span class='danger'>[src.name] plows into \the [aname]!</span>")
		return 0

	return 1

/mob/living/carbon/human/proc/rebel_yell()
	set category = "Abilities"
	set name = "Screech"
	set desc = "Emit a powerful screech which stuns hearers in a two-tile radius."

	if(last_special > world.time)
		to_chat(src, "<span class='danger'>You are too tired to screech!</span>")
		return

	if(stat || paralysis || stunned || weakened)
		to_chat(src, "<span class='danger'>You cannot screech in your current state!</span>")
		return

	last_special = world.time + 100

	visible_message("<span class='danger'>[src.name] lets out an ear piercing shriek!</span>",
			"<span class='danger'>You let out an ear-shattering shriek!</span>",
			"<span class='danger'>You hear a painfully loud shriek!</span>")

	playsound(loc, 'sound/voice/shriek1.ogg', 100, 1)

	var/list/victims = list()

	for (var/mob/living/carbon/human/T in hearers(2, src))
		if (T == src)
			continue

		if (istype(T) && (T:l_ear || T:r_ear) && istype((T:l_ear || T:r_ear), /obj/item/clothing/ears/earmuffs))
			continue

		to_chat(T, "<span class='danger'>You hear an ear piercing shriek and feel your senses go dull!</span>")
		T.Weaken(5)
		T.ear_deaf = 20
		T.stuttering = 20
		T.Stun(5)

		victims += T

	for (var/obj/structure/window/W in view(2))
		W.shatter()

	for (var/obj/machinery/light/L in view(4))
		L.broken()

	if (victims.len)
		admin_attacker_log_many_victims(src, victims, "used rebel yell to stun", "was stunned by [key_name(src)] using rebel yell", "used rebel yell to stun")

/mob/living/carbon/human/proc/formic_spray()
	set category = "Abilities"
	set name = "Napalm"
	set desc = "Spew a cone of ignited napalm in front of you"

	if(last_special > world.time)
		to_chat(src,"<span class='notice'>You are too tired to spray napalm!</span>")
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src,"<span class='notice'>You cannot spray napalm in your current state.</span>")
		return

	last_special = world.time + 100
	playsound(loc, 'sound/species/shadow/grue_screech.ogg', 100, 1)
	visible_message("<span class='danger'>\The [src] unleashes a torrent of raging flame!</span>",
			"<span class='danger'>You unleash a gust of fire!</span>",
			"<span class='danger'>You hear the roar of an inferno!</span>")

	var/turf/T  = get_step(get_step(src, dir), dir)
	var/turf/T1 = get_step(T, dir)
	var/turf/T2 = get_step(T1,turn(dir, 90))
	var/turf/T3 = get_step(T1,turn(dir, -90))
	var/turf/T4 = get_step(T1, dir)
	var/turf/T5 = get_step(T2, dir)
	var/turf/T6 = get_step(T3, dir)
	var/turf/T7 = get_step(T5,turn(dir, 90))
	var/turf/T8 = get_step(T6,turn(dir, -90))
	var/list/the_targets = list(T,T1,T2,T3,T4,T5,T6,T7,T8)

	playsound(src.loc, 'sound/magic/Fireball.ogg', 200, 1)
	for(var/turf/FuelSpot in the_targets)
		spawn(0)
			var/obj/effect/effect/water/firewater/D = new/obj/effect/effect/water/firewater(get_turf(get_step(src, dir)))
			var/turf/my_target = FuelSpot
			D.create_reagents(200)
			if(!src)
				return
			D.reagents.add_reagent("greekfire", 200)
			D.set_color()
			D.set_up(my_target, rand(6,8), 1, 50)
	return
