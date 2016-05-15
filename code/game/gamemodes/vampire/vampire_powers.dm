// Contains all /mob/procs that relate to vampire.

// Drains the target's blood.
/mob/living/carbon/human/proc/vampire_drain_blood()
	set category = "Vampire"
	set name = "Drain Blood"
	set desc = "Drain the blood of a humanoid creature."

	var/datum/vampire/vampire = vampire_power(0, 0)
	if (!vampire)
		return

	var/obj/item/weapon/grab/G = get_active_hand()
	if (!istype(G))
		src << "<span class='warning'>You must be grabbing a victim in your active hand to drain their blood.</span>"
		return

	if (G.state == GRAB_PASSIVE || G.state == GRAB_UPGRADING)
		src << "<span class='warning'>You must have the victim pinned to the ground to drain their blood.</span>"
		return

	var/mob/living/carbon/human/T = G.affecting
	if (!istype(T))
		src << "<span class='warning'>[T] is not a creature you can drain useful blood from.</span>"
		return

	if (vampire.status & VAMP_DRAINING)
		src << "<span class='warning'>Your fangs are already sunk into a victim's neck!</span>"
		return

	var/datum/vampire/draining_vamp = null
	if (T.mind && T.mind.vampire)
		draining_vamp = T.mind.vampire

	var/blood = 0
	var/blood_total = 0
	var/blood_usable = 0

	vampire.status |= VAMP_DRAINING

	visible_message("\red <b>[src.name] bites [T.name]'s neck!<b>", "\red <b>You bite [T.name]'s neck and begin to drain their blood.", "\blue You hear a soft puncture and a wet sucking noise")
	admin_attack_log(src, T, "drained blood from [key_name(T)]", "was drained blood from by [key_name(src)]", "is draining blood from")

	T << "<span class='warning'>You are unable to resist or even move. Your mind blanks as you're being fed upon.</span>"

	T.Stun(10)

	while (do_mob(src, T, 50))
		if (!mind.vampire)
			src << "\red Your fangs have disappeared!"
			return

		blood_total = vampire.blood_total
		blood_usable = vampire.blood_usable

		if (!T.vessel.get_reagent_amount("blood"))
			src << "\red [T] has no more blood left to give."
			break

		if (!T.stunned)
			T.Stun(10)

		var/frenzy_lower_chance = 0

		// Alive and not of empty mind.
		if (T.stat < 2 && T.client)
			blood = min(10, T.vessel.get_reagent_amount("blood"))
			vampire.blood_total += blood
			vampire.blood_usable += blood

			frenzy_lower_chance = 40

			if (draining_vamp)
				vampire.blood_vamp += blood
				// Each point of vampire blood will increase your chance to frenzy.
				vampire.frenzy += blood

				// And drain the vampire as well.
				draining_vamp.blood_usable -= min(blood, draining_vamp.blood_usable)
				vampire_check_frenzy()

				frenzy_lower_chance = 0
		// SSD/protohuman or dead.
		else
			blood = min(5, T.vessel.get_reagent_amount("blood"))
			vampire.blood_usable += blood

			frenzy_lower_chance = 20

		if (prob(frenzy_lower_chance))
			vampire.frenzy--

		if (blood_total != vampire.blood_total)
			var/update_msg = "\blue <b>You have accumulated [vampire.blood_total] [vampire.blood_total > 1 ? "units" : "unit"] of blood.</b>"
			if (blood_usable != vampire.blood_usable)
				update_msg += "<b> And have [vampire.blood_usable] left to use.</b>"

			src << update_msg
		check_vampire_upgrade()
		T.vessel.remove_reagent("blood", 25)

	vampire.status &= ~VAMP_DRAINING
	src << "\blue You extract your fangs from [T.name]'s neck and stop draining them of blood. They will remember nothing of this occurance. Provided they survived."

	if (T.stat != 2)
		T << "<span class='warning'>You remember nothing about being fed upon. Instead, you simply remember having a pleasant encounter with [src.name].</span>"

// Small area of effect stun.
/mob/living/carbon/human/proc/vampire_glare()
	set category = "Vampire"
	set name = "Glare"
	set desc = "Your eyes flash a bright light, stunning any who are watching."

	if (!vampire_power(0, 1))
		return

	if (!has_eyes())
		src << "<span class='warning'>You don't have eyes!</span>"
		return

	if (istype(glasses, /obj/item/clothing/glasses/sunglasses/blindfold))
		src << "<span class='warning'>You're blindfolded!</span>"
		return

	visible_message("\red <b>[src.name]'s eyes emit a blinding flash!</b>")
	var/list/victims = list()
	for (var/mob/living/carbon/human/H in view(2))
		if (H == src)
			continue

		if (!vampire_can_affect_target(H))
			continue

		H.Weaken(8)
		H.stuttering = 20
		H << "\red You are blinded by [src]'s glare!"
		flick("flash", H.flash)
		victims += H

	admin_attacker_log_many_victims(src, victims, "used glare to stun", "was stunned by [key_name(src)] using glare", "used glare to stun")

	verbs -= /mob/living/carbon/human/proc/vampire_glare
	spawn(800)
		verbs += /mob/living/carbon/human/proc/vampire_glare

// Targeted stun ability, moderate duration.
/mob/living/carbon/human/proc/vampire_hypnotise()
	set category = "Vampire"
	set name = "Hypnotise (10)"
	set desc = "Through blood magic, you dominate the victim's mind and force them into a hypnotic transe."

	var/datum/vampire/vampire = vampire_power(10, 1)
	if (!vampire)
		return

	if (!has_eyes())
		src << "<span class='warning'>You don't have eyes!</span>"
		return

	var/list/victims = list()
	for (var/mob/living/carbon/human/H in view(3))
		if (H == src)
			continue
		victims += H

	if (!victims.len)
		src << "<span class='warning'>No suitable targets.</span>"
		return

	var/mob/living/carbon/human/T = input(src, "Select Victim") as null|mob in victims

	if (!vampire_can_affect_target(T))
		return

	src << "<span class='notice'>You begin peering into [T.name]'s mind, looking for a way to render them useless.</span>"

	if (do_mob(src, T, 50))
		src << "\red You dominate [T.name]'s mind and render them temporarily powerless to resist."
		T << "\red You are captivated by [src.name]'s gaze, and find yourself unable to move or even speak."
		T.Weaken(20)
		T.Stun(20)
		T.stuttering = 20

		vampire.blood_usable -= 10
		admin_attack_log(src, T, "used hypnotise to stun [key_name(T)]", "was stunned by [key_name(src)] using hypnotise", "used hypnotise on")

		verbs -= /mob/living/carbon/human/proc/vampire_hypnotise
		spawn(1200)
			verbs += /mob/living/carbon/human/proc/vampire_hypnotise
	else
		src << "\red You broke your gaze."

// Targeted teleportation, must be to a low-light tile.
/mob/living/carbon/human/proc/vampire_veilstep(var/turf/T in world)
	set category = "Vampire"
	set name = "Veil Step (20)"
	set desc = "For a moment, move through the Veil and emerge at a shadow of your choice."

	if (!T || T.density || T.contains_dense_objects())
		src << "<span class='warning'>You cannot do that.</span>"
		return

	var/datum/vampire/vampire = vampire_power(20, 1)
	if (!vampire)
		return

	if (!istype(loc, /turf))
		src << "<span class='warning'>You cannot teleport out of your current location.</span>"
		return

	if (T.z != src.z || get_dist(T, get_turf(src)) > world.view)
		src << "<span class='warning'>Your powers are not capable of taking you that far.</span>"
		return

	var/atom/movable/lighting_overlay/light = T.lighting_overlay
	if (!light)
		return

	if (max(light.lum_r, light.lum_g, light.lum_b) > 1)
		// Too bright, cannot jump into.
		src << "<span class='warning'>The destination is too bright.</span>"
		return

	vampire_phase_out(get_turf(loc))

	forceMove(T)

	vampire_phase_in(T)

	for (var/obj/item/weapon/grab/G in contents)
		if (G.affecting && (vampire.status & VAMP_FULLPOWER))
			G.affecting.vampire_phase_out(get_turf(G.affecting.loc))
			G.affecting.forceMove(locate(T.x + rand(-1,1), T.y + rand(-1,1), T.z))
			G.affecting.vampire_phase_in(get_turf(G.affecting.loc))
		else
			qdel(G)

	log_and_message_admins("activated veil step.")

	vampire.blood_usable -= 20
	verbs -= /mob/living/carbon/human/proc/vampire_veilstep
	spawn(300)
		verbs += /mob/living/carbon/human/proc/vampire_veilstep

// Summons bats.
/mob/living/carbon/human/proc/vampire_bats()
	set category = "Vampire"
	set name = "Summon Bats (60)"
	set desc = "You tear open the Veil for just a moment, in order to summon a pair of bats to assist you in combat."

	var/datum/vampire/vampire = vampire_power(60, 0)
	if (!vampire)
		return

	var/list/locs = list()

	for (var/direction in alldirs)
		if (locs.len == 2)
			break

		var/turf/T = get_step(src, direction)
		if (AStar(src.loc, T, /turf/proc/AdjacentTurfs, /turf/proc/Distance, 1))
			locs += T

	var/list/spawned = list()
	if (locs.len)
		for (var/turf/to_spawn in locs)
			spawned += new /mob/living/simple_animal/hostile/scarybat(to_spawn, src)

		if (spawned.len != 2)
			spawned += new /mob/living/simple_animal/hostile/scarybat(src.loc, src)
	else
		spawned += new /mob/living/simple_animal/hostile/scarybat(src.loc, src)
		spawned += new /mob/living/simple_animal/hostile/scarybat(src.loc, src)

	if (!spawned.len)
		return

	for (var/mob/living/simple_animal/hostile/scarybat/bat in spawned)
		bat.friends += src

		if (vampire.thralls.len)
			bat.friends += vampire.thralls

	log_and_message_admins("summoned bats.")

	vampire.blood_usable -= 60
	verbs -= /mob/living/carbon/human/proc/vampire_bats
	spawn (1200)
		verbs += /mob/living/carbon/human/proc/vampire_bats

// Chiropteran Screech
/mob/living/carbon/human/proc/vampire_screech()
	set category = "Vampire"
	set name = "Chiropteran Screech (90)"
	set desc = "Emit a powerful screech which shatters glass within a seven-tile radius, and stuns hearers in a four-tile radius."

	var/datum/vampire/vampire = vampire_power(90, 0)
	if (!vampire)
		return

	visible_message("<span class='danger'>[src.name] lets out an ear piercin shriek!</span>", "<span class='danger'>You let out an ear-shattering shriek!</span>", "<span class='danger'>You hear a painfully loud shriek!</span>")

	var/list/victims = list()

	for (var/mob/living/carbon/human/T in hearers(4, src))
		if (T == src)
			continue

		if (istype(T) && (T:l_ear || T:r_ear) && istype((T:l_ear || T:r_ear), /obj/item/clothing/ears/earmuffs))
			continue

		if (!vampire_can_affect_target(T))
			continue

		T << "<span class='danger'><font size='3'><b>You hear an ear piercing shriek and feel your senses go dull!</b></font></span>"
		T.Weaken(5)
		T.ear_deaf = 20
		T.stuttering = 20
		T.Stun(5)

		victims += T

	for (var/obj/structure/window/W in view(7))
		W.shatter()

	for (var/obj/machinery/light/L in view(7))
		L.broken()

	playsound(src.loc, 'sound/effects/creepyshriek.ogg', 100, 1)
	vampire.blood_usable -= 90

	if (victims.len)
		admin_attacker_log_many_victims(src, victims, "used chriopteran screech to stun", "was stunned by [key_name(src)] using chriopteran screech", "used chiropteran screech to stun")
	else
		log_and_message_admins("used chiropteran screech.")

	verbs -= /mob/living/carbon/human/proc/vampire_screech
	spawn(3600)
		verbs += /mob/living/carbon/human/proc/vampire_screech

// Enables the vampire to be untouchable and walk through walls and other solid things.
/mob/living/carbon/human/proc/vampire_veilwalk()
	set category = "Vampire"
	set name = "Toggle Veil Walking (80)"
	set desc = "You enter the veil, leaving only an incorporeal manifestation of you visible to the others."

	var/datum/vampire/vampire = vampire_power(80, 0, 1)
	if (!vampire)
		return

	if (vampire.holder)
		vampire.holder.deactivate()
	else
		var/obj/effect/dummy/veil_walk/holder = new /obj/effect/dummy/veil_walk(get_turf(loc))
		holder.activate(src)

		log_and_message_admins("activated veil walk.")

		vampire.blood_usable -= 80

// Veilwalk's dummy holder
/obj/effect/dummy/veil_walk
	name = "a red ghost"
	desc = "A red, shimmering presence."
	icon = 'icons/mob/mob.dmi'
	icon_state = "blank"
	density = 0

	var/last_valid_turf = null
	var/can_move = 1
	var/processing = 0
	var/mob/owner_mob = null
	var/datum/vampire/owner_vampire = null
	var/warning_level = 0

/obj/effect/dummy/veil_walk/Destroy()
	eject_all()

	if (processing)
		processing_objects -= src
		processing = 0

	return ..()

/obj/effect/dummy/veil_walk/proc/eject_all()
	for (var/atom/movable/A in src)
		A.forceMove(loc)
		if (ismob(A))
			var/mob/M = A
			M.reset_view(null)

/obj/effect/dummy/veil_walk/relaymove(var/mob/user, direction)
	if (!can_move)
		return

	var/turf/new_loc = get_step(src, direction)
	if (new_loc.flags & NOJAUNT || istype(new_loc.loc, /area/chapel))
		usr << "<span class='warning'>Some strange aura is blocking the way!</span>"
		return

	forceMove(new_loc)
	var/turf/T = get_turf(loc)
	if (!T.contains_dense_objects())
		last_valid_turf = T

	can_move = 0
	spawn(2)
		can_move = 1

/obj/effect/dummy/veil_walk/process()
	if (owner_vampire.blood_usable >= 5)
		owner_vampire.blood_usable -= 5

		switch (warning_level)
			if (0)
				if (owner_vampire.blood_usable <= 5 * 20)
					owner_mob << "<span class='notice'>Your pool of blood is diminishing. You cannot stay in the veil for too long.</span>"
					warning_level = 1
			if (1)
				if (owner_vampire.blood_usable <= 5 * 10)
					owner_mob << "<span class='warning'>You will be ejected from the veil soon, as your pool of blood is running dry.</span>"
					warning_level = 2
			if (2)
				if (owner_vampire.blood_usable <= 5 * 5)
					owner_mob << "<span class='danger'>You cannot sustain this form for any longer!</span>"
					warning_level = 3
	else
		deactivate()

/obj/effect/dummy/veil_walk/proc/activate(var/mob/owner)
	if (!owner)
		qdel(src)
		return

	owner_mob = owner
	owner_vampire = owner.vampire_power()
	if (!owner_vampire)
		qdel(src)
		return

	owner_vampire.holder = src

	owner.vampire_phase_out(get_turf(owner.loc))

	icon_state = "veil_ghost"

	last_valid_turf = get_turf(owner.loc)
	owner.loc = src

	desc += " Its features look faintly alike [owner.name]'s."

	processing = 1
	processing_objects += src

/obj/effect/dummy/veil_walk/proc/deactivate()
	if (processing)
		processing_objects -= src
		processing = 0

	can_move = 0

	icon_state = "blank"

	owner_mob.vampire_phase_in(get_turf(loc))

	eject_all()

	owner_mob = null

	owner_vampire.holder = null
	owner_vampire = null

	qdel(src)

/obj/effect/dummy/veil_walk/ex_act(vars)
	return

/obj/effect/dummy/veil_walk/bullet_act(vars)
	return

// Heals the vampire at the cost of blood.
/mob/living/carbon/human/proc/vampire_bloodheal()
	set category = "Vampire"
	set name = "Blood Heal"
	set desc = "At the cost of blood and time, heal any injuries you have sustained."

	var/datum/vampire/vampire = vampire_power(15, 0)
	if (!vampire)
		return

	// Kick out of the already running loop.
	if (vampire.status & VAMP_HEALING)
		vampire.status &= ~VAMP_HEALING
		return

	vampire.status |= VAMP_HEALING
	src << "<span class='notice'>You begin the process of blood healing. Do not move, and ensure that you are not interrupted.</span>"

	log_and_message_admins("activated blood heal.")

	while (do_after(src, 20, 5, 0))
		if (!(vampire.status & VAMP_HEALING))
			src << "<span class='warning'>Your concentration is broken! You are no longer regenerating!</span>"
			break

		var/tox_loss = getToxLoss()
		var/oxy_loss = getOxyLoss()
		var/ext_loss = getBruteLoss() + getFireLoss()
		var/clone_loss = getCloneLoss()

		var/blood_used = 0
		var/to_heal = 0

		if (tox_loss)
			to_heal = min(10, tox_loss)
			adjustToxLoss(0 - to_heal)
			blood_used += round(to_heal * 1.2)
		if (oxy_loss)
			to_heal = min(10, oxy_loss)
			adjustOxyLoss(0 - to_heal)
			blood_used += round(to_heal * 1.2)
		if (ext_loss)
			to_heal = min(20, ext_loss)
			heal_overall_damage(min(10, getBruteLoss()), min(10, getFireLoss()))
			blood_used += round(to_heal * 1.2)
		if (clone_loss)
			to_heal = min(10, clone_loss)
			adjustCloneLoss(0 - to_heal)
			blood_used += round(to_heal * 1.2)

		var/list/organs = get_damaged_organs()
		if (organs.len)
			// Heal an absurd amount, basically regenerate one organ.
			heal_organ_damage(50, 50)
			blood_used += 12

		var/list/emotes_lookers = list("[src.name]'s skin appears to liquefy for a moment, sealing up their wounds.",
									"[src.name]'s veins turn black as their damaged flesh regenerates before your eyes!",
									"[src.name]'s skin begins to split open. It turns to ash and falls away, revealing the wound to be fully healed.",
									"Whispering arcane things, [src.name]'s damaged flesh appears to regenerate.",
									"Thick globs of blood cover a wound on [src.name]'s body, eventually melding to be one with \his flesh.",
									"[src.name]'s body crackles, skin and bone shifting back into place.")
		var/list/emotes_self = list("Your skin appears to liquefy for a moment, sealing up your wounds.",
									"Your veins turn black as their damaged flesh regenerates before your eyes!",
									"Your skin begins to split open. It turns to ash and falls away, revealing the wound to be fully healed.",
									"Whispering arcane things, your damaged flesh appears to regenerate.",
									"Thick globs of blood cover a wound on your body, eventually melding to be one with your flesh.",
									"Your body crackles, skin and bone shifting back into place.")

		if (prob(20))
			visible_message("<span class='danger'>[pick(emotes_lookers)]</span>", "<span class='notice'>[pick(emotes_self)]</span>")

		if (vampire.blood_usable <= blood_used)
			vampire.blood_usable = 0
			vampire.status &= ~VAMP_HEALING
			src << "<span class='warning'>You ran out of blood, and are unable to continue!</span>"
			break

	// We broke out of the loop naturally. Gotta catch that.
	if (vampire.status & VAMP_HEALING)
		vampire.status &= ~VAMP_HEALING
		src << "<span class='warning'>Your concentration is broken! You are no longer regenerating!</span>"

	return

// Dominate a victim, imbed a thought into their mind.
/mob/living/carbon/human/proc/vampire_dominate()
	set category = "Vampire"
	set name = "Dominate (25)"
	set desc = "Dominate the mind of a victim, make them obey your will."

	var/datum/vampire/vampire = vampire_power(25, 0)
	if (!vampire)
		return

	var/list/victims = list()
	for (var/mob/living/carbon/human/H in view(7))
		if (H == src)
			continue
		victims += H

	if (!victims.len)
		src << "<span class='warning'>No suitable targets.</span>"
		return

	var/mob/living/carbon/human/T = input(src, "Select Victim") as null|mob in victims

	if (!vampire_can_affect_target(T))
		return

	if (!(vampire.status & VAMP_FULLPOWER))
		src << "<span class='notice'>You begin peering into [T.name]'s mind, looking for a way to gain control.</span>"

		if (!do_mob(src, T, 50))
			src << "<span class='warning'>Your concentration is broken!</span>"
			return

		src << "<span class='notice'>You succeed in dominating [T.name]'s mind. They are yours to command.</span>"
	else
		src << "<span class='notice'>You instantly dominate [T.name]'s mind, forcing them to obey your command.</span>"

	var/command = input(src, "Command your victim.", "Your command.")

	if (!command)
		src << "\red Cancelled."
		return

	admin_attack_log(src, T, "used dominate on [key_name(T)]", "was dominated by [key_name(src)]", "used dominate and issued the command of '[command]' to")

	T << "<span class='warning'>You feel a strong presence enter your mind. For a moment, you hear nothing but what it says, and are compelled to follow its direction:</span><br><span class='notice'><b>[command]</b></span>"
	src << "<span class='notice'>You command [T.name], and they will obey.</span>"
	emote("me", 1, "whispers.")

	vampire.blood_usable -= 25
	verbs -= /mob/living/carbon/human/proc/vampire_dominate
	spawn(1800)
		verbs += /mob/living/carbon/human/proc/vampire_dominate

// Enthralls a person, giving the vampire a mortal slave.
/mob/living/carbon/human/proc/vampire_enthrall()
	set category = "Vampire"
	set name = "Enthrall (150)"
	set desc = "Bind a mortal soul with a bloodbond to obey your every command."

	var/datum/vampire/vampire = vampire_power(150, 0)
	if (!vampire)
		return

	var/obj/item/weapon/grab/G = get_active_hand()
	if (!istype(G))
		src << "<span class='warning'>You must be grabbing a victim in your active hand to enthrall them.</span>"
		return

	if (G.state == GRAB_PASSIVE || G.state == GRAB_UPGRADING)
		src << "<span class='warning'>You must have the victim pinned to the ground to enthrall them.</span>"
		return

	var/mob/living/carbon/human/T = G.affecting
	if (!istype(T))
		src << "<span class='warning'>[T] is not a creature you can enthrall.</span>"
		return

	if (!T.client || !T.mind)
		src << "<span class='warning'>[T]'s mind is empty and useless. They cannot be forced into a blood bond.</span>"
		return

	if (vampire.status & VAMP_DRAINING)
		src << "<span class='warning'>Your fangs are already sunk into a victim's neck!</span>"
		return

	visible_message("<span class='danger'>[src.name] tears the flesh on their wrist, and holds it up to [T.name]. In a gruesome display, [T.name] starts lapping up the blood that's oozing from the fresh wound.</span>", "<span class='warning'>You inflict a wound upon yourself, and force them to drink your blood, thus starting the conversion process.</span>")
	T << "<span class='warning'>You feel an irresistable desire to drink the blood pooling out of [src.name]'s wound. Against your better judgement, you give in and start doing so.</span>"

	if (!do_mob(src, T, 50))
		visible_message("<span class='danger'>[src.name] yanks away their hand from [T.name]'s mouth as they're interrupted, the wound quickly sealing itself!</span>", "<span class='danger'>You are interrupted!</span>")
		return

	T << "<span class='danger'>Your mind blanks as you finish feeding from [src.name]'s wrist.</span>"
	vampire_thrall.add_antagonist(T.mind, 1, 1, 0, 1, 1)

	T.mind.vampire.master = src
	vampire.thralls += T
	T << "<span class='notice'>You have been forced into a blood bond by [T.mind.vampire.master], and are thus their thrall. While a thrall may feel a myriad of emotions towards their master, ranging from fear, to hate, to love; the supernatural bond between them still forces the thrall to obey their master, and to listen to the master's commands.<br><br>You must obey your master's orders, you must protect them, you cannot harm them.</span>"

	admin_attack_log(src, T, "enthralled [key_name(T)]", "was enthralled by [key_name(src)]", "successfully enthralled")

	vampire.blood_usable -= 150
	verbs -= /mob/living/carbon/human/proc/vampire_enthrall
	spawn(2800)
		verbs += /mob/living/carbon/human/proc/vampire_enthrall

// Gives a lethal disease to the target.
/mob/living/carbon/human/proc/vampire_diseasedtouch()
	set category = "Vampire"
	set name = "Diseased Touch (200)"
	set desc = "Infects the victim with corruption from the Veil, causing their organs to fail."

	var/datum/vampire/vampire = vampire_power(200, 0)
	if (!vampire)
		return

	var/list/victims = list()
	for (var/mob/living/carbon/human/H in view(1))
		if (H == src)
			continue
		victims += H

	if (!victims.len)
		src << "<span class='warning'>No suitable targets.</span>"
		return

	var/mob/living/carbon/human/T = input(src, "Select Victim") as null|mob in victims

	if (!vampire_can_affect_target(T))
		return

	src << "<span class='notice'>You infect [T.name] with a deadly disease. They will soon fade away.</span>"

	T.help_shake_act(src)

	var/datum/disease2/disease/lethal = new
	lethal.makerandom(3)
	lethal.infectionchance = 1
	lethal.stage = lethal.max_stage
	lethal.spreadtype = "None"

	infect_mob(T, lethal)

	admin_attack_log(src, T, "used diseased touch on [key_name(T)]", "was given a lethal disease by [key_name(src)]", "used diseased touch (<a href='?src=\ref[lethal];info=1'>virus info</a>) on")

	vampire.blood_usable -= 200
	verbs -= /mob/living/carbon/human/proc/vampire_diseasedtouch
	spawn(1800)
		verbs += /mob/living/carbon/human/proc/vampire_diseasedtouch

// Makes the vampire appear 'friendlier' to others.
/mob/living/carbon/human/proc/vampire_presence()
	set category = "Vampire"
	set name = "Presence (10)"
	set desc = "Influences those weak of mind to look at you in a friendlier light."

	var/datum/vampire/vampire = vampire_power(15, 0)
	if (!vampire)
		return

	if (vampire.status & VAMP_PRESENCE)
		vampire.status &= ~VAMP_PRESENCE
		src << "<span class='warning'>You are no longer influencing those weak of mind.</span>"
		return

	src << "<span class='notice'>You begin passively influencing the weak minded.</span>"
	vampire.status |= VAMP_PRESENCE

	var/list/mob/living/carbon/human/affected = list()
	var/list/emotes = list("[src.name] looks trusthworthy.",
							"You feel as if [src.name] is a relatively friendly individual.",
							"You feel yourself paying more attention to what [src.name] is saying.",
							"[src.name] has your best interests at heart, you can feel it.",
							"A quiet voice tells you that [src.name] should be considered a friend.")

	vampire.blood_usable -= 10

	log_and_message_admins("activated presence.")

	while (vampire.status & VAMP_PRESENCE)
		// Run every 20 seconds
		sleep(200)

		for (var/mob/living/carbon/human/T in view(5))
			if (T == src)
				continue

			if (!vampire_can_affect_target(T))
				continue

			if (!T.client)
				continue

			var/probability = 50
			if (!(T in affected))
				affected += T
				probability = 80

			if (prob(probability))
				T << "<font color='green'><i>[pick(emotes)]</i></font>"

		vampire.blood_usable -= 5

		if (vampire.blood_usable < 5)
			vampire.status &= ~VAMP_PRESENCE
			src << "<span class='warning'>You are no longer influencing those weak of mind.</span>"
			break

// Convert a human into a vampire.
/mob/living/carbon/human/proc/vampire_embrace()
	set category = "Vampire"
	set name = "The Embrace"
	set desc = "Spread your corruption to an innocent soul, turning them into a spawn of the Veil, much akin to yourself."

	var/datum/vampire/vampire = vampire_power(0, 0)
	if (!vampire)
		return

	// Re-using blood drain code.
	var/obj/item/weapon/grab/G = get_active_hand()
	if (!istype(G))
		src << "<span class='warning'>You must be grabbing a victim in your active hand to drain their blood.</span>"
		return

	if (G.state == GRAB_PASSIVE || G.state == GRAB_UPGRADING)
		src << "<span class='warning'>You must have the victim pinned to the ground to drain their blood.</span>"
		return

	var/mob/living/carbon/human/T = G.affecting
	if (!vampire_can_affect_target(T))
		return

	if (!T.client)
		src << "<span class='warning'>[T.name] is a mindless husk. The Veil has no purpose for them.</span>"
		return

	if (T.stat == 2)
		src << "<span class='warning'>[T.name]'s body is broken and damaged beyond salvation. You have no use for them.</span>"
		return

	if (vampire.status & VAMP_DRAINING)
		src << "<span class='warning'>Your fangs are already sunk into a victim's neck!</span>"
		return

	if (T.mind.vampire)
		var/datum/vampire/draining_vamp = T.mind.vampire

		if (draining_vamp.status & VAMP_ISTHRALL)
			var/choice_text = ""
			var/denial_response = ""
			if (draining_vamp.master == src)
				choice_text = "[T.name] is your thrall. Do you wish to release them from the blood bond and give them the chance to become your equal?"
				denial_response = "You opt against giving [T] a chance to ascend, and choose to keep them as a servant."
			else
				choice_text = "You can feel the taint of another master running in the veins of [T.name]. Do you wish to release them of their blood bond, and convert them into a vampire, in spite of their master?"
				denial_response = "You choose not to continue with the Embrace, and permit [T.name] to keep serving their master."

			if (alert(src, choice_text, "Choices", "Yes", "No") == "No")
				src << "<span class='notice'>[denial_response]</span>"
				return
		else
			src << "<span class='warning'>You feel corruption running in [T.name]'s blood. Much like yourself, \he[T] is already a spawn of the Veil, and cannot be Embraced.</span>"
			return

	vampire.status |= VAMP_DRAINING

	visible_message("\red <b>[src.name] bites [T.name]'s neck!<b>", "\red <b>You bite [T.name]'s neck and begin to drain their blood, as the first step of introducing the corruption of the Veil to them.</b>", "\blue You hear a soft puncture and a wet sucking noise")

	T << "<span class='notice><br>You are currently being turned into a vampire. You will die in the course of this, but you will be revived by the end. Please do not ghost out of your body until the process is complete.</span>"

	while (do_mob(src, T, 50))
		if (!mind.vampire)
			src << "\red Your fangs have disappeared!"
			return

		if (!T.vessel.get_reagent_amount("blood"))
			src << "\red [T] is now drained of blood. You begin forcing your own blood into their body, spreading the corruption of the Veil to their body."
			break

		T.vessel.remove_reagent("blood", 50)

	T.revive()

	// You ain't goin' anywhere, bud.
	if (!T.client && T.mind)
		for (var/mob/dead/observer/ghost in player_list)
			if (ghost.mind == T.mind)
				ghost.can_reenter_corpse = 1
				ghost.reenter_corpse()

				T << "<span class='danger'>A dark force pushes you back into your body. You find yourself somehow still clinging to life.</span>"

	T.Weaken(15)
	vamp.add_antagonist(T.mind, 1, 1, 0, 0, 1)

	admin_attack_log(src, T, "successfully embraced [key_name(T)]", "was successfully embraced by [key_name(src)]", "successfully embraced and turned into a vampire")

	T << "<span class='danger'>You awaken. Moments ago, you were dead, your conciousness still forced stuck inside your body. Now you live. You feel different, a strange, dark force now present within you. You have an insatiable desire to drain the blood of mortals, and to grow in power.</span>"
	src << "<span class='warning'>You have corrupted another mortal with the taint of the Veil. Beware: they will awaken hungry and maddened; not bound to any master.</span>"

	T.mind.vampire.blood_usable = 0
	T.mind.vampire.frenzy = 250
	T.vampire_check_frenzy()

	vampire.status &= ~VAMP_DRAINING

// Grapple a victim by leaping onto them.
/mob/living/carbon/human/proc/grapple()
	set category = "Vampire"
	set name = "Grapple"
	set desc = "Lunge towards a target like an animal, and grapple them."

	if (status_flags & LEAPING)
		return

	if (stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		src << "<span class='warning'>You cannot lean in your current state.</span>"
		return

	var/list/targets = list()
	for (var/mob/living/carbon/human/H in view(4, src))
		targets += H

	targets -= src

	if (!targets.len)
		src << "<span class='warning'>No valid targets visible or in range.</span>"
		return

	var/mob/living/carbon/human/T = pick(targets)

	visible_message("<span class='danger'>[src.name] leaps at [T]!</span>")
	throw_at(get_step(get_turf(T), get_turf(src)), 4, 1, src)

	status_flags |= LEAPING

	sleep(5)

	if (status_flags & LEAPING)
		status_flags &= ~LEAPING

	if (!src.Adjacent(T))
		src << "<span class='warning'>You miss!</span>"
		return

	T.Weaken(3)

	admin_attack_log(src, T, "lept at and grappled [key_name(T)]", "was lept at and grappled by [key_name(src)]", "lept at and grappled")

	var/use_hand = "left"
	if (l_hand)
		if (r_hand)
			src << "<span class='danger'>You need to have one hand free to grab someone.</span>"
			return
		else
			use_hand = "right"

	src.visible_message("<span class='warning'><b>\The [src]</b> seizes [T] aggressively!</span>")

	var/obj/item/weapon/grab/G = new(src, T)
	if (use_hand == "left")
		l_hand = G
	else
		r_hand = G

	G.state = GRAB_AGGRESSIVE
	G.icon_state = "grabbed1"
	G.synch()

	verbs -= /mob/living/carbon/human/proc/grapple
	spawn(800)
		if (mind.vampire && (mind.vampire.status & VAMP_FRENZIED))
			verbs += /mob/living/carbon/human/proc/grapple
