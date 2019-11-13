// === MEMETIC ANOMALY ===
// =======================
//Taken from ancient baystation code- LL

/**
This life form is a form of parasite that can gain a certain level of control
over its host. Its player will share vision and hearing with the host, and it'll
be able to influence the host through various commands.
**/

// The maximum amount of points a meme can gather.
var/global/const/MAXIMUM_MEME_POINTS = 750
var/mob/living/parasite/host_brain
var/controlling


// === PARASITE ===
// ================

// a list of all the parasites in the mob
/mob/living/carbon/var/list/parasites = list()

/mob/living/parasite
	var/mob/living/carbon/host // the host that this parasite occupies

/mob/living/parasite/Login()
	..()
	// make the client see through the host instead
	client.eye = host
	client.perspective = EYE_PERSPECTIVE

/mob/living/parasite/proc/enter_host(mob/living/carbon/host)
	// by default, parasites can't share a body with other life forms
	if(host.parasites.len > 0)
		return 0

	src.host = host
	src.forceMove(host)
	host.parasites.Add(src)

	if(client) client.eye = host

	return 1

/mob/living/parasite/proc/exit_host()
	src.host.parasites.Remove(src)
	src.host = null
	src.loc = null

	return 1


// === MEME ===
// ============


// Memes use points for many actions
/mob/living/parasite/meme/var/meme_points = 100
/mob/living/parasite/meme/var/dormant = 0

// Memes have a list of indoctrinated hosts
/mob/living/parasite/meme/var/list/indoctrinated = list()

/mob/living/parasite/meme/Life()
	..()

	if(client)
		if(blinded) client.eye = null
		else		client.eye = host

	if(!host) return

	// recover meme points slowly
	var/gain = 3
	if(dormant) gain = 9 // dormant recovers points faster

	meme_points = min(meme_points + gain, MAXIMUM_MEME_POINTS)

	// if there are sleep toxins in the host's body, that's bad
	if(host.reagents.has_reagent("stoxin"))
		to_chat(src, "<span class='danger'>Something in your host's blood makes you lose consciousness, you fade away...</span>")
		src.death()
		return
	// a host without brain is no good
	if(!host.mind)
		to_chat(src, "<span class='danger'>Your host has no mind, you fade away...</span>")
		src.death()
		return
	if(host.stat == 2)
		to_chat(src, "<span class='danger'>Your host has died, you fade away...</span>")
		src.death()
		return

	if(host.blinded && host.stat != 1) src.blinded = 1
	else 			 				   src.blinded = 0

/mob/living/parasite/meme/death()
	// make sure the mob is on the actual map before gibbing
	if(host)
		src.forceMove(host.loc)
	src.stat = 2
	..()
	qdel(src)

// When a meme speaks, it speaks through its host
/mob/living/parasite/meme/say(message as text)
	if(dormant)
		to_chat(src, "<span class='notice'>You are dormant! </span>")
		return
	if(!host)
		to_chat(usr, "<span class='notice'>You can't speak without a host! </span>")
		return

	return host.say(message)

// Same as speak, just with whisper
/mob/living/parasite/meme/whisper(message as text)
	if(dormant)
		to_chat(src, "<span class='notice'>You are dormant! </span>")
		return
	if(!host)
		to_chat(usr, "<span class='notice'>You can't speak without a host! </span>")
		return

	return host.whisper(message)

// Make the host do things
/mob/living/parasite/meme/me_verb(message as text)
	set name = "Me"

	if(dormant)
		to_chat(src, "<span class='notice'>You are dormant! </span>")
		return

	if(!host)
		to_chat(usr, "<span class='notice'>You can't speak without a host! </span>")
		return

	return host.me_verb(message)

// A meme understands everything their host understands
/mob/living/parasite/meme/say_understands(mob/other)
	if(!host) return 0

	return host.say_understands(other)

// Try to use amount points, return 1 if successful
/mob/living/parasite/meme/proc/use_points(amount)
	if(dormant)
		to_chat(src, "<span class='notice'>You are dormant! </span>")
		return
	if(src.meme_points < amount)
		to_chat(src, "<span class='notice'>You don't have enough meme points(need [amount]).</span>")
		return 0

	src.meme_points -= round(amount)
	return 1

// Let the meme choose one of his indoctrinated mobs as target
/mob/living/parasite/meme/proc/select_indoctrinated(var/title, var/message)
	var/list/candidates

	// Can only affect other mobs thant he host if not blinded
	if(blinded)
		candidates = list()
		to_chat(src, "<span class='notice'>You are blinded, so you can not affect mobs other than your host.</span>")
	else
		candidates = indoctrinated.Copy()

	candidates.Add(src.host)

	var/mob/target = null
	if(candidates.len == 1)
		target = candidates[1]
	else
		var/selected

		var/list/text_candidates = list()
		var/list/map_text_to_mob = list()

		for(var/mob/living/carbon/human/M in candidates)
			text_candidates += M.real_name
			map_text_to_mob[M.real_name] = M

		selected = input(message,title) as null|anything in text_candidates
		if(!selected) return null

		target = map_text_to_mob[selected]

	return target


// A meme can make people hear things with the thought ability
/mob/living/parasite/meme/verb/Thought(mob/M as mob in oview())
	set category = "Meme"
	set name	 = "Thought(150)"
	set desc     = "Implants a thought into the target."

	if(!use_points(150)) return

	var/message = sanitize(input("Message:", "Thought") as text|null)
	if(message)
		log_say("MemeThought: [key_name(src)]->[M.key] : [message]",ckey=key_name(src))
		to_chat(M, "[message]")
		to_chat(src, "You said: \"[message]\" to [M]")
	return
/*
	var/list/candidates = indoctrinated.Copy()
	if(!(src.host in candidates))
		candidates.Add(src.host)

	var/mob/target = select_indoctrinated("Thought", "Select a target which will hear your thought.")

	if(!target) return

	var/speaker = input("Select the voice in which you would like to make yourself heard.", "Voice") as text
	//if(!speaker) return

	var/message = input("What would you like to say?", "Message") as text
	if(!message) return

	// Use the points at the end rather than the beginning, because the user might cancel
	if(!use_points(150)) return

	message = say_quote(message)
	var/rendered = "<span class='game say'><span class='name'>[speaker]</span> <span class='message'>[message]</span></span>"
	target.show_message(rendered)

	to_chat(usr, "<i>You make [target] hear:</i> [rendered]")
*/
// Mutes the host
/mob/living/parasite/meme/verb/Mute()
	set category = "Meme"
	set name	 = "Mute(250)"
	set desc     = "Prevents your host from talking for a while."

	if(!src.host) return
	/*if(!host.silent)
		to_chat(usr, "\red Your host already can't speak..")
		return*/
	if(!use_points(250)) return

	spawn
		// backup the host incase we switch hosts after using the verb
		//var/mob/host = src.host
		to_chat(host, "<span class='danger'>Your tongue feels numb.. You lose your ability to speak.</span>")
		to_chat(usr, "<span class='notice'>Your host can't speak anymore.</span>")

		host.silent += 60

		sleep(1200)
		to_chat(host, "<span class='danger'>Your tongue has feeling again.</span>")
		to_chat(usr, "<span class='notice'>[host] can speak again.</span>")

// Makes the host unable to emote
/mob/living/parasite/meme/verb/Paralyze()
	set category = "Meme"
	set name	 = "Paralyze(250)"
	set desc     = "Prevents your host from using emote for a while."

	if(!src.host) return
	/*if(!host.Weaken())
		to_chat(usr, "\red Your host already can't use body language..")
		return*/
	if(!use_points(250)) return

	spawn
		// backup the host incase we switch hosts after using the verb
		var/mob/host = src.host

		to_chat(host, "<span class='danger'>Your body feels numb. You lose your ability to use body language.</span>")
		to_chat(usr, "<span class='notice'>Your host can't use body language anymore.</span>")

		host.Weaken(60)

		sleep(1200)
		to_chat(host, "<span class='warning'>Your body has feeling again.</span>")
		to_chat(usr, "<span class='notice'>[host] can use body language again.</span>")



// Cause great agony with the host, used for conditioning the host
/mob/living/parasite/meme/verb/Agony()
	set category = "Meme"
	set name	 = "Agony(200)"
	set desc     = "Causes significant pain in your host."

	if(!src.host) return
	if(!use_points(200)) return

	spawn
		// backup the host incase we switch hosts after using the verb
		var/mob/host = src.host

		host.paralysis = max(host.paralysis, 2)

		host.flash_weak_pain()
		to_chat(host, "<span class='danger'><font size=5>You feel excrutiating pain all over your body! It is so bad you can't think or articulate yourself properly.</font></span>")

		to_chat(usr, "<span class='notice'>You send a jolt of agonizing pain through [host], they should be unable to concentrate on anything else for half a minute.</span>")

		host.emote("scream")

		for(var/i=0, i<10, i++)
			host.stuttering = 2
			sleep(50)
			if(prob(80)) host.flash_weak_pain()
			if(prob(10)) host.paralysis = max(host.paralysis, 2)
			if(prob(15)) host.emote("twitch")
			else if(prob(15)) host.emote("scream")
			else if(prob(10)) host.emote("collapse")

			if(i == 10)
				to_chat(host, "<span class='danger'>THE PAIN! AGHH, THE PAIN! MAKE IT STOP! ANYTHING TO MAKE IT STOP!</span>")

		to_chat(host, "<span class='warning'>The pain subsides.</span>")

// Cause great joy with the host, used for conditioning the host
/mob/living/parasite/meme/verb/Joy()
	set category = "Meme"
	set name	 = "Joy(200)"
	set desc     = "Causes significant joy in your host."

	if(!src.host) return
	if(!use_points(200)) return

	spawn
		var/mob/host = src.host
		host.druggy = max(host.druggy, 50)
		host.slurring = max(host.slurring, 10)

		to_chat(usr, "<span class='notice'>You stimulate [host.name]'s brain, injecting waves of endorphines and dopamine into the tissue. They should now forget all their worries, particularly relating to you, for around a minute.</span>")

		to_chat(host, "<span class='notice'><font size=5>You are feeling wonderful! Your head is numb and drowsy, and you can't help forgetting all the worries in the world.</font></span>")

		while(host.druggy > 0)
			sleep(10)

		to_chat(host, "<span class='warning'>You are feeling clear-headed again.</span>")

// Cause the target to hallucinate.
/mob/living/parasite/meme/verb/Hallucinate(mob/living/carbon/human/target as mob in oview())
	set category = "Meme"
	set name	 = "Hallucinate(300)"
	set desc     = "Makes your host hallucinate, has a short delay."

	if(!istype(target, /mob/living/carbon/human) || !target.mind)
		to_chat(src, "<span class='warning'>You can't remotely ruin this ones mind.</span>")
		return
	if(!(target in view(host)))
		to_chat(src, "<span class='warning'>You need to make eye-contact with the target.</span>")
		return
	if(!(target in indoctrinated))
		to_chat(src, "<span class='warning'>You need to attune the target first.</span>")
		return
	if(!target) return
	if(!use_points(300)) return

	spawn(rand(300,600))
		if(target)	target.hallucination += 400

	to_chat(usr, "<span class='notice'>You make [target] hallucinate.</span>")

// Jump to a closeby target through a whisper
/mob/living/parasite/meme/verb/SubtleJump(mob/living/carbon/human/target as mob in oview())
	set category = "Meme"
	set name	 = "Subtle Jump(350)"
	set desc     = "Move to a closeby human through a whisper."

	if(!istype(target, /mob/living/carbon/human) || !target.mind)
		to_chat(src, "<span class='warning'>You can't jump to this creature.</span>")
		return

	if(target.isSynthetic())
		to_chat(src, "<span class='warning'>You can't affect synthetics.</span>")
		return

	if(!(target in view(1, host)+src))
		to_chat(src, "<span class='warning'>The target is not close enough.</span>")
		return

	// Find out whether we can speak
	if (host.silent || (host.disabilities & 64))
		to_chat(src, "<span class='warning'>Your host can't speak.</span>")
		return

	if(!use_points(350)) return

	for(var/mob/M in view(1, host))
		M.show_message("<B>[host]</B> whispers something incoherent.",2) // 2 stands for hearable message

	// Find out whether the target can hear
	if(target.disabilities & 32 || target.ear_deaf)
		to_chat(src, "<span class='warning'>Your target doesn't seem to hear you.</span>")
		return

	if(target.parasites.len > 0)
		to_chat(src, "<span class='warning'>Your target already is possessed by something.</span>")
		return

	src.exit_host()
	src.enter_host(target)

	to_chat(usr, "<span class='notice'>You successfully jumped to [target].</span>")
	log_admin("[src.key] has jumped to [target]",ckey=key_name(src))
	message_admins("[src.key] has jumped to [target]")

// Jump to a distant target through a shout
/mob/living/parasite/meme/verb/ObviousJump(mob/living/carbon/human/target as mob in world)
	set category = "Meme"
	set name	 = "Obvious Jump(750)"
	set desc     = "Move to any mob in view through a shout."

	if(!istype(target, /mob/living/carbon/human) || !target.mind)
		to_chat(src, "<span class='warning'>You can't jump to this creature.</span>")
		return

	if(target.isSynthetic())
		to_chat(src, "<span class='warning'>You can't affect synthetics.</span>")
		return

	if(!(target in view(host)))
		to_chat(src, "<span class='warning'>The target is not close enough.</span>")
		return

	// Find out whether we can speak
	if (host.silent || (host.disabilities & 64))
		to_chat(src, "<span class='warning'>Your host can't speak.</span>")
		return

	if(!use_points(750)) return

	for(var/mob/M in view(host)+src)
		M.show_message("<B>[host]</B> screams something incoherent!",2) // 2 stands for hearable message

	// Find out whether the target can hear
	if(target.disabilities & 32 || target.ear_deaf)
		to_chat(src, "<span class='warning'>Your target doesn't seem to hear you.</span>")
		return

	if(target.parasites.len > 0)
		to_chat(src, "<span class='warning'>Your target already is possessed by something.</span>")
		return

	src.exit_host()
	src.enter_host(target)

	to_chat(usr, "<span class='notice'>You successfully jumped to [target].</span>")
	log_admin("[src.key] has jumped to [target]",ckey=key_name(src))
	message_admins("[src.key] has jumped to [target]")

// Jump to an attuned mob for free
/mob/living/parasite/meme/verb/AttunedJump(mob/living/carbon/human/target as mob in world)
	set category = "Meme"
	set name	 = "Attuned Jump(0)"
	set desc     = "Move to a mob in sight that you have already attuned."

	if(!istype(target, /mob/living/carbon/human) || !target.mind)
		to_chat(src, "<span class='warning'>You can't jump to this creature.</span>")
		return

	if(target.isSynthetic())
		to_chat(src, "<span class='warning'>You can't affect synthetics.</span>")
		return

	if(!(target in view(host)))
		to_chat(src, "<span class='warning'>You need to make eye-contact with the target.</span>")
		return
	if(!(target in indoctrinated))
		to_chat(src, "<span class='warning'>You need to attune the target first.</span>")
		return

	src.exit_host()
	src.enter_host(target)

	to_chat(usr, "<span class='notice'>You successfully jumped to [target].</span>")

	log_admin("[src.key] has jumped to [target]",ckey=key_name(src))
	message_admins("[src.key] has jumped to [target]")

// ATTUNE a mob, adding it to the indoctrinated list
/mob/living/parasite/meme/verb/Attune()
	set category = "Meme"
	set name	 = "Attune(400)"
	set desc     = "Change the host's brain structure, making it easier for you to manipulate him."

	if(host in src.indoctrinated)
		to_chat(usr, "<span class='notice'>You have already attuned this host.</span>")
		return

	if(!host) return

	for (var/obj/item/implant/loyalty/I in host)
		if (I.implanted)
			to_chat(src, "<span class='warning'>Your host's mind is shielded!</span>")
			return

	if(!use_points(400)) return

	src.indoctrinated.Add(host)

	to_chat(usr, "<span class='notice'>You successfully indoctrinated [host].</span>")
	to_chat(host, "<span class='danger'>Your head feels a bit roomier...</span>")

	log_admin("[src.key] has attuned [host]",ckey=key_name(src))
	message_admins("[src.key] has attuned [host]")

// Enables the mob to take a lot more damage
/mob/living/parasite/meme/verb/Analgesic()
	set category = "Meme"
	set name	 = "Analgesic(500)"
	set desc     = "Combat drug that allows the host to move normally, even under life-threatening pain."

	if(!host) return
	if(!(host in indoctrinated))
		to_chat(usr, "<span class='warning'>You need to attune the host first.</span>")
		return
	if(!use_points(500)) return

	to_chat(usr, "<span class='notice'>You inject drugs into [host].</span>")
	to_chat(host, "<span class='danger'>You feel your body strengthen and your pain subside.</span>")
	host.analgesic = 60
	while(host.analgesic > 0)
		sleep(60)
	to_chat(host, "<span class='notice'>The dizziness wears off, and you can feel pain again.</span>")


/mob/proc/clearHUD()
	//update_clothing()
	if(client) client.screen.Cut()

// Take control of the mob
/mob/living/parasite/meme/verb/Possession()
	set category = "Meme"
	set name	 = "Possession(500)"
	set desc     = "Take direct control of the host for a while."

	if(!host)
		to_chat(src, "You have discovered a severe bug - NO HOST. CONTACT DEVELOPER.")
		return

	if(src.stat)
		to_chat(src, "<span class='warning'>You cannot do that in your current state.</span>")
		return

	for (var/obj/item/implant/loyalty/I in host)
		if (I.implanted)
			to_chat(src, "<span class='warning'>Your host's mind is shielded!</span>")
			return

	if(!use_points(500)) return

	to_chat(src, "<span class='danger'>You assume direct control!</span>")

	spawn()

		if(!host || !src || controlling)
			return
		else

			to_chat(src, "<span class='warning'>You shroud your hosts brain, assuming control!</span>")
			to_chat(host, "<span class='danger'>You can feel thoughts that arent your own begin to dictate your body's actions.</span>")

			// host -> brain
			var/h2b_id = host.computer_id
			var/h2b_ip= host.lastKnownIP
			host.computer_id = null
			host.lastKnownIP = null

			qdel(host_brain)
			host_brain = new(src)

			host_brain.ckey = host.ckey

			host_brain.name = host.name

			if(!host_brain.computer_id)
				host_brain.computer_id = h2b_id

			if(!host_brain.lastKnownIP)
				host_brain.lastKnownIP = h2b_ip

			// self -> host
			var/s2h_id = src.computer_id
			var/s2h_ip= src.lastKnownIP
			src.computer_id = null
			src.lastKnownIP = null

			host.ckey = src.ckey

			if(!host.computer_id)
				host.computer_id = s2h_id

			if(!host.lastKnownIP)
				host.lastKnownIP = s2h_ip

			controlling = 1

			spawn(300)
				detatch()

			return

/mob/living/parasite/meme/proc/detatch()

	if(!host || !controlling) return

	if(istype(host,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = host
		var/obj/item/organ/external/head = H.get_organ("head")
		head.implants -= src

	controlling = 0

	if(host_brain)

		// these are here so bans and multikey warnings are not triggered on the wrong people when ckey is changed.
		// computer_id and IP are not updated magically on their own in offline mobs -walter0o

		// host -> self
		var/h2s_id = host.computer_id
		var/h2s_ip= host.lastKnownIP
		host.computer_id = null
		host.lastKnownIP = null

		src.ckey = host.ckey

		if(!src.computer_id)
			src.computer_id = h2s_id

		if(!host_brain.lastKnownIP)
			src.lastKnownIP = h2s_ip

		// brain -> host
		var/b2h_id = host_brain.computer_id
		var/b2h_ip= host_brain.lastKnownIP
		host_brain.computer_id = null
		host_brain.lastKnownIP = null

		host.ckey = host_brain.ckey

		if(!host.computer_id)
			host.computer_id = b2h_id

		if(!host.lastKnownIP)
			host.lastKnownIP = b2h_ip

	qdel(host_brain)


// Enter dormant mode, increases meme point gain
/mob/living/parasite/meme/verb/Dormant()
	set category = "Meme"
	set name	 = "Dormant(100)"
	set desc     = "Speed up point recharging, will force you to cease all actions until all points are recharged."

	if(!host) return
	if(!use_points(100)) return

	to_chat(usr, "<span class='warning'>You enter dormant mode.You won't be able to take action until all your points have recharged.</span>")

	dormant = 1

	while(meme_points < MAXIMUM_MEME_POINTS)
		sleep(10)

	dormant = 0

	to_chat(usr, "<span class='danger'>You have regained all points and exited dormant mode!</span>")

/mob/living/parasite/meme/verb/Show_Points()
	set category = "Meme"

	to_chat(usr, "<b>Meme Points: [src.meme_points]/[MAXIMUM_MEME_POINTS]</b>")

// Stat panel to show meme points, copypasted from alien
/mob/living/parasite/meme/Stat()
	..()
	statpanel("Status")
	if (client && client.holder)
		stat(null, "([x], [y], [z])")

	if (client && client.statpanel == "Status")
		stat(null, "Meme Points: [src.meme_points]")
