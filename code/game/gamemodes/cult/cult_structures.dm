/obj/structure/cult
	density = 1
	anchored = 1
	icon = 'icons/obj/cult.dmi'

/obj/structure/cult/cultify()
	return

/obj/structure/cult/talisman
	name = "Altar"
	desc = "A bloodstained altar dedicated to Nar-Sie"
	icon_state = "talismanaltar"


/obj/structure/cult/forge
	name = "Daemon forge"
	desc = "A forge used in crafting the unholy weapons used by the armies of Nar-Sie"
	icon_state = "forge"

/*
	Cult pylons can be used as arcane defensive turrets.

	First of all they must be empowered with a sacrifice. Any small organic creature that can be picked up is valid
	Hit the pylon with the creature - while still alive - to present it as a sacrifice, and then end its life to complete the process.

	Once empowered, pylons will fire rapid, weak magical beams at non cult mobs.

	As crystals, pylons are immune to energy weaponry. More than immune, they will absorb lasers and become
	supercharged for some time, boosting their damage. Pylons can only be harmed by ballistics and physical weapons
	Building reinforced windows around them is highly recommended.

	Pylons are fairly fragile and will quickly break under direct hits.
	A damaged pylon will self repair, if it contains a soul.


	Pylons are largely intended as a stalling, early warning, fire support and area denial system. They are unlikely to actually
	kill anyone alone but they can keep pesky civilians away for long enough to learn runes and prepare rituals.

	If you can get ahold of a laser rifle to supercharge them, they can even give security some pause

	Recommended tools for combatting pylons:
		Heavy melee (fireaxe, baseball bat, etc)
		Sniper rifles
		Exosuits
		Explosives
		Ablative armour
		Smoke grenades
		Close the damn firelocks so they can't see you
*/

/obj/structure/cult/pylon
	name = "pylon"
	desc = "A floating crystal that hums with an unearthly energy."
	description_antag = "Sacrificing an organic mob sich as a monkey or a mouse to the pylon will empower it, causing it to deal halloss damage and hallucination to non-cultists within range of the pylon.<br>Hit the pylon with the creature or drag and drop it onto the pylon to offer it. Once the sacrifice is accepted, kill it to complete the process. This will gib its body and make a very visible mess. This will also cause the pylon to be anchored to the ground and immovable."

	icon_state = "pylonbase"
	var/isbroken = 0
	light_range = 5
	light_color = "#3e0000"
	var/pylonmode = 0
	//Pylon has three states:
	//0 = Idle, the pylon is an inert crystal
	//1 = Awaiting sacrifice. The pylon is actively tracking a creature to be sacrificed to it
	//2 = Pain field. The pylon has been empowered by a sacrifice and will now deal halloss to nearby non-cultist human-types.

	var/damagetaken = 0
	var/mob/living/sacrifice //Holds a reference to a mob that is a pending sacrifice
	var/datum/weakref/sacrificer //A reference to the last mob that attempted to sacrifice something. So we can message them
	//Sacrifier is also used in target handling. the pylon will not bite the hand that feeds it. Noncultist colleagues are fair game though

	var/datum/language/cultcommon/lang
	// A reference to the cult language datum. Used to scramble speech when speaking to noncultists.

	anchored = FALSE

	var/list/pain_messages = list(
		"You feel the crushing weight of placeholder text upon your shoulders."
	)

/obj/structure/cult/pylon/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	lang = null	// Do not delete this.
	return ..()

/obj/structure/cult/pylon/Initialize()
	. = ..()
	lang = global.all_languages[LANGUAGE_CULT]
	update_icon()
	START_PROCESSING(SSprocessing, src)

/obj/structure/cult/pylon/examine(var/mob/user)
	. = ..()
	switch (damagetaken)
		if (1 to 8)
			user << "It has faint hairline fractures."
		if (8 to 20)
			user << "It has several cracks across its surface."
		if (20 to 30)
			user << "It is chipped and deeply cracked, it may shatter with much more pressure."
		if (30 to INFINITY)
			user << "It is almost cleaved in two, the pylon looks like it will fall to shards under its own weight."

/obj/structure/cult/pylon/process()
	switch (pylonmode)
		if (1)
			handle_sacrifice()
		if (2)
			// Deal halloss
			for (var/mob/living/carbon/human/H in view(5, src))
				if (iscultist(H))
					continue
				
				H.hallucination += 10
				H.apply_damage(5, HALLOSS)
				if (prob(50))
					to_chat(H, "<span class='danger'>[pick(pain_messages)]</span>")

//If user is a cultist, speaks message to them with a prefix
//If user is not cultist, then speaks cult-y gibberish
/obj/structure/cult/pylon/proc/speak_to(var/mob/user, var/message)
	if (iscult(user) || (/datum/language/cultcommon in user.languages))
		user << "A voice speaks into your mind, [span("cult","\"<I>[message]</I>\"")]"
	else
		user << "A voice speaks into your mind, [span("cult","\"<I>[lang.scramble(message)]</I>\"")]"

//Todo: Replace the messages here with better ones. Should display a proper message to cultists
//And nonsensical arcane gibberish to non cultists
/obj/structure/cult/pylon/proc/present_sacrifice(var/mob/living/user, var/mob/living/victim)
	if (!user || !victim)
		return 0

	if (isbroken)
		user << "The pylon lies silent."
		return 0

	if (pylonmode != 0)
		return 0

	if (!(victim.mob_size) || victim.mob_size > 6)
		//toolarge sacrifice, display a message and return
		speak_to(user, "This creature is too large, we only require a lesser sacrifice. A small morsel of life...")
		return

	if (victim.stat == DEAD)
		speak_to(user, "You are too late, the spark of life is already gone from this one. It is naught but an empty husk...")
		return

	var/types = victim.find_type()
	if ((!(types & TYPE_ORGANIC)) || ((types & TYPE_WIERD)))
		//Invalid sacrifice. Display a message and return
		speak_to(user, "This soulless automaton cannot satisfy our hunger. We yearn for life essence, it must have a soul.")
		return

	sacrifice = victim
	sacrificer = WEAKREF(user)
	//Sacrifice accepted, display message here
	speak_to(user, "Your sacrifice has been deemed worthy, and accepted. End its life now, and liberate its soul, to seal our contract...")
	sacrifice << span("danger", "You feel an invisible force grip your soul, as you're drawn inexorably towards the pylon. Every part of you screams to flee from here!")

	if (istype(sacrifice.loc,/obj/item/weapon/holder))
		var/obj/item/weapon/holder/H = sacrifice.loc
		H.release_to_floor()
	else
		sacrifice.forceMove(get_turf(sacrifice))
	pylonmode = 1
	update_icon()

//Runs every proc while there's a pending sacrifice. This checks whether the sacrifice was killed or escaped
/obj/structure/cult/pylon/proc/handle_sacrifice()
	. = 0 //Return value has 3 states.
	//0 = waiting, the sacrifice is still alive
	//1 = Finished, the sacrifice was killed, finalize the process and become a turret
	//-1 = Escape: The sacrifice left the vicinity of the pylon, return to inert mode.

	if (QDELETED(sacrifice) || get_dist(src, get_turf(sacrifice)) > 5)
		// Sacrifice is deleted or more than 5 tiles away, probably escaped.
		sacrifice = null	// Clear a ref in-case the referenced object is awaiting GC

		//If the sacrifice was deleted somehow, we cant know exactly what happened. We'll assume it escaped
		. = -1

	else if (sacrifice.stat == DEAD)
		. = 1

	switch(.)
		if (1)
			finalize_sacrifice()
		if (-1)
			var/mob/M = sacrificer.resolve()
			if (M)
				speak_to(M, "Fool! Your offering has escaped. Bring it back, or find us another...")
			sacrifice = null
			pylonmode = 0
			update_icon()
			if (sacrifice)
				walk_to(sacrifice,0)
		else
			if (isturf(sacrifice.loc) && !(sacrifice.is_ventcrawling) && !(sacrifice.buckled))
				//Suck the creature towards the pylon if possible
				walk_towards(sacrifice,src, 10)
			else
				walk_to(sacrifice,0) //If we're not in a valid situation, cancel walking to prevent bugginess

/obj/structure/cult/pylon/proc/finalize_sacrifice()
	sacrifice.visible_message(span("danger","\The [sacrifice]'s physical form unwinds as its soul is extracted from the remains and drawn into the pylon!"))
	if (istype(sacrifice.loc,/obj/item/weapon/holder))
		var/obj/item/weapon/holder/H = sacrifice.loc
		H.release_to_floor()
	else
		sacrifice.forceMove(get_turf(sacrifice)) //Make sure its on the floor before we gib it
	pylonmode = 2
	sacrifice.gib()

	update_icon()

/obj/structure/cult/pylon/attack_hand(mob/M as mob)
	if (M.a_intent == "help")
		M << "The pylon feels warm to the touch...."
	else
		attackpylon(M, 4, M)

/obj/structure/cult/pylon/attack_generic(var/mob/user, var/damage)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	// Artificers maintain pylons
	if(istype(user, /mob/living/simple_animal/construct))
		var/mob/living/simple_animal/construct/C = user
		if (C.can_repair)
			repair(user)
			return
	attackpylon(user, damage, user)

/obj/structure/cult/pylon/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/holder))
		var/obj/item/weapon/holder/H = W
		if (H.contained)
			present_sacrifice(user, H.contained)
		return

	attackpylon(user, W.force, W)

//Mousedrop so that constructs can drag mice out of maintenance to make turrets
/obj/structure/cult/pylon/MouseDrop_T(var/atom/movable/C, mob/user)
	if (istype(C, /mob/living))
		present_sacrifice(user, C)
		return
	return ..()

/obj/structure/cult/pylon/bullet_act(var/obj/item/projectile/Proj)
	attackpylon(user, Proj.damage, Proj)

//Explosions will usually cause instant shattering, or heavy damage
//Class 3 or lower blast is sometimes survivable. 2 or higher will always shatter
/obj/structure/cult/pylon/ex_act(var/severity)
	if (severity > 0)
		attackpylon(null, (rand(200,400)/severity), null)

/obj/structure/cult/pylon/proc/attackpylon(mob/user as mob, var/damage, var/source)
	var/ranged = 0
	if (user)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if (istype(source, /obj/item/projectile))
		ranged = 1

	if (!damage)
		return

	damagetaken += damage

	if(!isbroken)
		if (user)
			user.do_attack_animation(src)
		if(prob(damagetaken*0.75))
			shatter()
		else
			if (user && !ranged)
				user << "You hit the pylon!"
			playsound(get_turf(src), 'sound/effects/Glasshit.ogg', 75, 1)
	else
		if(prob(damagetaken))
			if (user)
				user << "You pulverize what was left of the pylon!"
			qdel(src)
		else if (user && !ranged)
			user << "You hit the pylon!"
		playsound(get_turf(src), 'sound/effects/Glasshit.ogg', 75, 1)

/obj/structure/cult/pylon/proc/shatter()
	visible_message(
		"<span class='danger'>The pylon shatters into shards of crystal!</span>",
		"You hear a tinkle of crystal shards."
	)
	playsound(get_turf(src), 'sound/effects/Glassbr3.ogg', 75, 1)
	isbroken = 1
	if (pylonmode == 2)
		//If the pylon had a soul in it then it plays a creepy evil sound as the soul is released
		var/possibles = list(
			'sound/hallucinations/far_noise.ogg',
			'sound/hallucinations/growl3.ogg',
			'sound/hallucinations/veryfar_noise.ogg',
			'sound/hallucinations/wail.ogg',
			'sound/voice/hiss5.ogg'
		)
		playsound(get_turf(src), pick(possibles), 50, 1)

	pylonmode = 0 //A broken pylon loses its soul. Even if repaired it will need a new sacrifice to re-empower it

	//Make sure we stop it from firing
	sacrificer = null

	density = 0
	update_icon()

/obj/structure/cult/pylon/proc/repair(mob/user as mob)
	if(isbroken)
		if(user)
			user << span("notice","You weave forgotten magic, summoning the shards of the crystal and knitting them anew, until it hovers flawless once more.")
		isbroken = 0
		density = 1
	else if (damagetaken > 0)
		user << span("notice","You meld the crystal lattice back into integrity, sealing over the cracks until they never were.")

	else
		user << span("notice","The crystal lights up at your touch.")

	damagetaken = 0
	update_icon()

/obj/structure/cult/pylon/update_icon()
	cut_overlays()
	if (pylonmode == 2)
		anchored = 1
		set_light(6, 3, l_color = "#3e0000")
		add_overlay("crystal_turret")
	else if (!isbroken)
		set_light(5, 2, l_color = "#3e0000")
		add_overlay("crystal_idle")
		if (pylonmode == 1)
			anchored = 1
		else
			anchored = 0
	else
		anchored = 0
		set_light(0)

//============================================
/obj/structure/cult/tome
	name = "Desk"
	desc = "A desk covered in arcane manuscripts and tomes in unknown languages. Looking at the text makes your skin crawl"
	icon_state = "tomealtar"

/obj/effect/gateway
	name = "gateway"
	desc = "You're pretty sure that abyss is staring back"
	icon = 'icons/obj/cult.dmi'
	icon_state = "hole"
	density = 1
	unacidable = 1
	anchored = 1.0
	var/spawnable = null

/obj/effect/gateway/Bumped(mob/M as mob|obj)
	spawn(0)
		return
	return

/obj/effect/gateway/Crossed(AM as mob|obj)
	spawn(0)
		return
	return

/obj/effect/gateway/active
	light_range=5
	light_color="#ff0000"
	spawnable=list(
		/mob/living/simple_animal/hostile/scarybat,
		/mob/living/simple_animal/hostile/creature,
		/mob/living/simple_animal/hostile/faithless
	)

/obj/effect/gateway/active/cult
	light_range=5
	light_color="#ff0000"
	spawnable=list(
		/mob/living/simple_animal/hostile/scarybat/cult,
		/mob/living/simple_animal/hostile/creature/cult,
		/mob/living/simple_animal/hostile/faithless/cult
	)

/obj/effect/gateway/active/cult/cultify()
	return

/obj/effect/gateway/active/New()
	addtimer(CALLBACK(src, .proc/do_spawn), rand(30, 60) SECONDS)

/obj/effect/gateway/active/proc/do_spawn()
	var/thing = pick(spawnable)
	new thing(src.loc)
	qdel(src)

/obj/effect/gateway/active/Crossed(var/atom/A)
	if(!istype(A, /mob/living))
		return

	var/mob/living/M = A

	if(M.stat != DEAD)
		if(M.transforming)
			return
		if(M.has_brain_worms())
			return //Borer stuff - RR

		if(iscult(M)) return
		if(!ishuman(M) && !isrobot(M)) return

		M.transforming = 1
		M.canmove = 0
		M.icon = null
		M.overlays.len = 0
		M.invisibility = 101

		if(istype(M, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/Robot = M
			if(Robot.mmi)
				qdel(Robot.mmi)
		else
			for(var/obj/item/W in M)
				if(istype(W, /obj/item/weapon/implant))
					qdel(W)
					continue
				W.layer = initial(W.layer)
				W.loc = M.loc
				W.dropped(M)

		var/mob/living/new_mob = new /mob/living/simple_animal/corgi(A.loc)
		new_mob.a_intent = I_HURT
		if(M.mind)
			M.mind.transfer_to(new_mob)
		else
			new_mob.key = M.key

		new_mob << "<B>Your form morphs into that of a corgi.</B>"	//Because we don't have cluwnes
