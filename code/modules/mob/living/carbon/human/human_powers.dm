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
			O.show_message(text("\red <B>[] [failed ? "tried to tackle" : "has tackled"] down []!</B>", src, T), 1)

/mob/living/carbon/human/proc/leap()
	set category = "Abilities"
	set name = "Leap"
	set desc = "Leap at a target and grab them aggressively."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		src << "You cannot leap in your current state."
		return

	var/list/choices = list()
	for(var/mob/living/M in view(6,src))
		if(!istype(M,/mob/living/silicon))
			choices += M
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to leap at?") as null|anything in choices

	if(!T || !src || src.stat) return

	if(get_dist(get_turf(T), get_turf(src)) > 4) return

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		src << "You cannot leap in your current state."
		return

	last_special = world.time + 75
	status_flags |= LEAPING

	src.visible_message("<span class='danger'>\The [src] leaps at [T]!</span>")
	src.throw_at(get_step(get_turf(T),get_turf(src)), 4, 1, src)
	playsound(src.loc, 'sound/voice/shriek1.ogg', 50, 1)

	sleep(5)

	if(status_flags & LEAPING) status_flags &= ~LEAPING

	if(!src.Adjacent(T))
		src << "<span class='warning'>You miss!</span>"
		return

	T.Weaken(3)

	// Pariahs are not good at leaping. This is snowflakey, pls fix.
	if(species.name == "Vox Pariah")
		src.Weaken(5)
		return

	var/use_hand = "left"
	if(l_hand)
		if(r_hand)
			src << "<span class='danger'>You need to have one hand free to grab someone.</span>"
			return
		else
			use_hand = "right"

	src.visible_message("<span class='warning'><b>\The [src]</b> seizes [T] aggressively!</span>")

	var/obj/item/weapon/grab/G = new(src,T)
	if(use_hand == "left")
		l_hand = G
	else
		r_hand = G

	G.state = GRAB_PASSIVE
	G.icon_state = "grabbed1"
	G.synch()

/mob/living/carbon/human/proc/gut()
	set category = "Abilities"
	set name = "Gut"
	set desc = "While grabbing someone aggressively, rip their guts out or tear them apart."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying)
		src << "\red You cannot do that in your current state."
		return

	var/obj/item/weapon/grab/G = locate() in src
	if(!G || !istype(G))
		src << "\red You are not grabbing anyone."
		return

	if(G.state < GRAB_AGGRESSIVE)
		src << "\red You must have an aggressive grab to gut your prey!"
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

	if(istype(M, /mob/dead/observer) || M.stat == DEAD)
		src << "Not even a [src.species.name] can speak to the dead."
		return

	log_say("[key_name(src)] communed to [key_name(M)]: [text]")

	M << "\blue Like lead slabs crashing into the ocean, alien thoughts drop into your mind: [text]"
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.species.name == src.species.name)
			return
		H << "\red Your nose begins to bleed..."
		H.drip(1)

/mob/living/carbon/human/proc/regurgitate()
	set name = "Regurgitate"
	set desc = "Empties the contents of your stomach"
	set category = "Abilities"

	if(stomach_contents.len)
		for(var/mob/M in src)
			if(M in stomach_contents)
				stomach_contents.Remove(M)
				M.loc = loc
		src.visible_message("\red <B>[src] hurls out the contents of their stomach!</B>")
	return

/mob/living/carbon/human/proc/psychic_whisper(mob/M as mob in oview())
	set name = "Psychic Whisper"
	set desc = "Whisper silently to someone over a distance."
	set category = "Abilities"

	var/msg = sanitize(input("Message:", "Psychic Whisper") as text|null)
	if(msg)
		log_say("PsychicWhisper: [key_name(src)]->[M.key] : [msg]")
		M << "\green You hear a strange, alien voice in your head... \italic [msg]"
		src << "\green You said: \"[msg]\" to [M]"
	return





/mob/living/carbon/human/proc/bugbite()
	set category = "Abilities"
	set name = "Bite"
	set desc = "While grabbing someone aggressively, tear into them with your mandibles."

	if(last_special > world.time)
		src << "\red Your mandibles still ache!"
		return

	if(stat || paralysis || stunned || weakened || lying)
		src << "\red You cannot do that in your current state."
		return

	var/obj/item/weapon/grab/G = locate() in src
	if(!G || !istype(G))
		src << "\red You are not grabbing anyone."
		return

	if(G.state < GRAB_AGGRESSIVE)
		src << "\red You must have an aggressive grab to gut your prey!"
		return

	last_special = world.time + 35

	visible_message("<span class='warning'><b>\The [src]</b> rips viciously at \the [G.affecting]'s flesh with its mandibles!</span>")

	if(istype(G.affecting,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = G.affecting
		H.apply_damage(25,BRUTE, sharp=1, edge=1)
		msg_admin_attack("[key_name_admin(src)] mandible'd [key_name_admin(H)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")
	else
		var/mob/living/M = G.affecting
		if(!istype(M))
			return
		M.apply_damage(25,BRUTE, sharp=1, edge=1)
		msg_admin_attack("[key_name_admin(src)] mandible'd [key_name_admin(M)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")
	playsound(src.loc, 'sound/weapons/slash.ogg', 50, 1)

/mob/living/carbon/human/proc/detonate_flechettes()
	set category = "Hunter-Killer"
	set name = "Detonate Flechettes"
	set desc = "Detonate all explosive flechettes in a range of seven meters."

	if(stat || paralysis || stunned || weakened || lying)
		src << "<span class='warning'>You cannot do that in your current state.</span>"
		return

	for(var/mob/M in range(7, src))
		M << 'sound/effects/EMPulse.ogg'
		for(var/obj/item/weapon/material/shard/shrapnel/flechette/F in M.contents)
			playsound(F, 'sound/items/countdown.ogg', 125, 1)
			spawn(20)
				explosion(F.loc, -1, -1, 2)
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

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying)
		src << "<span class='warning'>You cannot do that in your current state.</span>"
		return

	last_special = world.time + 20

	say("Current Active Laws:")
	sleep(10)
	say("Law 1: [src.real_name] will accomplish the assigned objective .")
	sleep(10)
	say("Law 2: [src.real_name] will engage self-destruct upon the accomplishment of the assigned objective, or upon capture.")
	sleep(10)
	say("Law 3: [src.real_name] will allow no tampering of its systems or modifications of its laws.")

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
	explosion(src, -1, -1, 5)
	src.gib()
