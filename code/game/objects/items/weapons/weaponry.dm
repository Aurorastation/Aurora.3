
/obj/item/weapon/nullrod
	name = "null rod"
	desc = "A rod of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon_state = "nullrod"
	item_state = "nullrod"
	slot_flags = SLOT_BELT
	force = 15
	throw_speed = 1
	throw_range = 4
	throwforce = 10
	w_class = 2

/obj/item/weapon/nullrod/nullstaff
	name = "null staff"
	desc = "A staff of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon_state = "nullstaff"
	item_state = "nullstaff"
	slot_flags = SLOT_BACK
	w_class = 4

/obj/item/weapon/nullrod/nullorb
	name = "null sphere"
	desc = "An orb of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon_state = "nullorb"
	item_state = "nullorb"

/obj/item/weapon/nullrod/nullathame
	name = "null athame"
	desc = "An athame of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon_state = "nullathame"
	item_state = "nullathame"

/obj/item/weapon/nullrod/itembox
	name = "null item box"
	desc = "A box to safe keep your religious items. What item did you bring to work today?"
	icon = 'icons/obj/storage.dmi'
	icon_state = "box"
	item_state = "box"

/obj/item/weapon/nullrod/itembox/attack_self(mob/user as mob)
	if(..()) return

	var/selection = input("Pick a null item type.") in list("Rod","Staff", /*"Orb",*/ "Athame")
	switch(selection)
		if ("Rod")
			new /obj/item/weapon/nullrod(user.loc)
			user << "<span class='notice'>A simple obsidian rod, a classic. Rods like these are seen in the hands of religious folks all across the galaxy.</span>"
		if ("Staff")
			new /obj/item/weapon/nullrod/nullstaff(user.loc)
			user << "<span class='notice'>A simple staff, a popular choice amongst shamans and wise men. You doubt this will fit in your bag, but you can put it on your back.</span>"
		if ("Orb")
			new /obj/item/weapon/nullrod/nullorb(user.loc)
		if ("Athame")
			new /obj/item/weapon/nullrod/nullathame(user.loc)
			user << "<span class='notice'>An athame, a ritualistic dagger. It's blade is curved and ornate, yet it is rather blunt.</span>"
	user << "<span class='notice'>You take your [selection] from the box, and throw the empty box away.</span>"
	qdel(src)
	return

/obj/item/weapon/nullrod/attack(mob/M as mob, mob/living/user as mob) //Paste from old-code to decult with a null rod.

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(M)

	if(LAZYLEN(user.spell_list))
		user.silence_spells(300) //30 seconds
		user << "<span class='danger'>You've been silenced!</span>"
		return

	if (!user.IsAdvancedToolUser())
		user << "<span class='danger'>You don't have the dexterity to do this!</span>"
		return

	if ((CLUMSY in user.mutations) && prob(50))
		user << "<span class='danger'>The rod slips out of your hand and hits your head.</span>"
		user.take_organ_damage(10)
		user.Paralyse(20)
		return

	if (M.stat !=2 && ishuman(M) && user.a_intent != I_HURT)
		var/mob/living/K = M
		if(cult && (K.mind in cult.current_antagonists) && prob(33))
			if(do_after(user, 15))
				K.visible_message("<span class='danger'>\The [user] waves \the [src] over \the [K]'s head, [K] looks captivated by it.</span>", "<span class='warning'>[user] wave's the [src] over your head. <b>You see a foreign light, asking you to follow it. Its presence burns and blinds.</b></span>")
				var/choice = alert(K,"Do you want to give up your goal?","Become cleansed","Resist","Give in")
				switch(choice)
					if("Resist")
						K.visible_message("<span class='warning'>The gaze in [K]'s eyes remains determined.</span>", "<span class='notice'>You turn away from the light, remaining true to your dark lord. <b>Anathema!</b></span>")
						K.say("*scream")
						K.take_overall_damage(5, 15)
					if("Give in")
						K.visible_message("<span class='notice'>[K]'s eyes become clearer, the evil gone, but not without leaving scars.</span>")
						K.take_overall_damage(15, 30)
						cult.remove_antagonist(K.mind)
			else
				user.visible_message("<span class='warning'>[user]'s concentration is broken!</span>", "<span class='warning'>Your concentration is broken! You and your target need to stay uninterrupted for longer!</span>")
				return
		else if(prob(10))
			user << "<span class='danger'>The rod slips in your hand.</span>"
			..()
		else
			user << "<span class='danger'>The rod appears to do nothing.</span>"
			M.visible_message("<span class='danger'>\The [user] waves \the [src] over \the [M]'s head.</span>")
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(prob(15))
					H.cure_all_traumas(cure_type = CURE_SOLITUDE)
				else if(prob(10))
					H.cure_all_traumas(cure_type = CURE_CRYSTAL)
			return
		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Is being deconverted with the [src.name] by [user.name] ([user.ckey])</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attempt to deconvert [M.name] ([M.ckey])</font>")

		msg_admin_attack("[key_name_admin(user)] attempted to deconvert [key_name_admin(M)] with [src.name] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(M))

	else
		return ..()

/obj/item/weapon/nullrod/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if (istype(A, /turf/simulated/floor))
		user << "<span class='notice'>You hit the floor with the [src].</span>"
		call(/obj/effect/rune/proc/revealrunes)(src)

/obj/item/weapon/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	throwforce = 0
	force = 0
	var/net_type = /obj/effect/energy_net

/obj/item/weapon/energy_net/dropped()
	spawn(10)
		if(src) qdel(src)

/obj/item/weapon/energy_net/throw_impact(atom/hit_atom)
	..()

	var/mob/living/M = hit_atom

	if(!istype(M) || locate(/obj/effect/energy_net) in M.loc)
		qdel(src)
		return 0

	var/turf/T = get_turf(M)
	if(T)
		var/obj/effect/energy_net/net = new net_type(T)
		net.layer = M.layer+1
		M.captured = 1
		net.affecting = M
		T.visible_message("[M] was caught in an energy net!")
		qdel(src)

	// If we miss or hit an obstacle, we still want to delete the net.
	spawn(10)
		if(src) qdel(src)

/obj/effect/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"

	density = 1
	opacity = 0
	mouse_opacity = 1
	anchored = 1

	var/health = 25
	var/mob/living/affecting = null //Who it is currently affecting, if anyone.
	var/mob/living/master = null    //Who shot web. Will let this person know if the net was successful.
	var/countdown = -1

/obj/effect/energy_net/teleport
	countdown = 60

/obj/effect/energy_net/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/effect/energy_net/Destroy()

	if(affecting)
		var/mob/living/carbon/M = affecting
		M.anchored = initial(affecting.anchored)
		M.captured = 0
		M << "You are free of the net!"

	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/effect/energy_net/proc/healthcheck()

	if(health <=0)
		density = 0
		src.visible_message("The energy net is torn apart!")
		qdel(src)
	return

/obj/effect/energy_net/process()

	if(isnull(affecting) || affecting.loc != loc)
		qdel(src)
		return

	// Countdown begin set to -1 will stop the teleporter from firing.
	// Clientless mobs can be netted but they will not teleport or decrement the timer.
	var/mob/living/M = affecting
	if(countdown == -1 || (istype(M) && !M.client))
		return

	if(countdown > 0)
		countdown--
		return

	// TODO: consider removing or altering this; energy nets are useful on their own
	// merits and the teleportation was never properly implemented; it's halfassed.
	density = 0
	invisibility = 101 //Make the net invisible so all the animations can play out.
	health = INFINITY  //Make the net invincible so that an explosion/something else won't kill it during anims.

	playsound(affecting.loc, 'sound/effects/sparks4.ogg', 50, 1)
	anim(affecting.loc,affecting,'icons/mob/mob.dmi',,"phaseout",,affecting.dir)

	affecting.visible_message("[affecting] vanishes in a flare of light!")

	if(holdingfacility.len)
		affecting.forceMove(pick(holdingfacility))

	affecting << "You appear in a strange place!"

	playsound(affecting.loc, 'sound/effects/phasein.ogg', 25, 1)
	playsound(affecting.loc, 'sound/effects/sparks2.ogg', 50, 1)
	anim(affecting.loc,affecting,'icons/mob/mob.dmi',,"phasein",,affecting.dir)

	qdel(src)

/obj/effect/energy_net/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.get_structure_damage()
	healthcheck()
	return 0

/obj/effect/energy_net/ex_act(var/severity = 2.0)
	health = 0
	healthcheck()

/obj/effect/energy_net/attack_hand(var/mob/user)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/mob/living/carbon/human/H = user
	if(istype(H))
		if(H.species.can_shred(H))
			playsound(src.loc, 'sound/weapons/slash.ogg', 80, 1)
			health -= rand(10, 20)
		else
			health -= rand(1,3)

	else if (HULK in user.mutations)
		health = 0
	else
		health -= rand(5,8)

	H << "<span class='danger'>You claw at the energy net.</span>"

	healthcheck()
	return

/obj/effect/energy_net/attackby(obj/item/weapon/W as obj, mob/user as mob)
	health -= W.force
	healthcheck()
	..()

/obj/item/weapon/canesword
	name = "thin sword"
	desc = "A thin, sharp blade with an elegant handle."
	icon = 'icons/obj/sword.dmi'
	icon_state = "canesword"
	item_state = "canesword"
	force = 20
	throwforce = 5
	w_class = 4
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	contained_sprite = 1

/obj/item/weapon/sord
	name = "\improper SORD"
	desc = "This thing is so unspeakably shitty you are having a hard time even holding it."
	icon_state = "sord"
	item_state = "sord"
	slot_flags = SLOT_BELT
	force = 2
	throwforce = 1
	sharp = 1
	edge = 1
	w_class = 3
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/weapon/banhammer
	desc = "banhammer"
	name = "banhammer"
	icon = 'icons/obj/items.dmi'
	icon_state = "toyhammer"
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = 2.0
	throw_speed = 7
	throw_range = 15
	attack_verb = list("banned")

/obj/item/weapon/banhammer/attack(mob/M as mob, mob/user as mob)
	M << "<font color='red'><b> You have been banned FOR NO REISIN by [user]</b></font>"
	user << "<font color='red'> You have <b>BANNED</b> [M]</font>"
	playsound(loc, 'sound/effects/adminhelp.ogg', 15)
