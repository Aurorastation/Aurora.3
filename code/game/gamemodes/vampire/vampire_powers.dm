// Contains all /mob/procs that relate to vampire.

// Makes vampire's victim not get paralyzed, and remember the suckings
/mob/living/carbon/human/proc/vampire_alertness()
	set category = "Vampire"
	set name = "Victim Alertness"
	set desc = "Toggle whether you wish for your victims to get paralyzed and forget your deeds."

	var/datum/vampire/vampire = vampire_power(0, 0)
	vampire.stealth = !vampire.stealth
	if(vampire.stealth)
		to_chat(src, SPAN_NOTICE("Your victims will now forget your interactions and become paralyzed. After feeding on them, you can tell them what they should believe happened to them."))
	else
		to_chat(src, SPAN_NOTICE("Your victims will now remember your interactions."))

// Drains the target's blood.
/mob/living/carbon/human/proc/vampire_drain_blood()
	set category = "Vampire"
	set name = "Drain Blood"
	set desc = "Drain the blood of a humanoid creature."

	var/datum/vampire/vampire = vampire_power(0, 0)
	if(!vampire)
		return

	if(vampire.status & VAMP_DRAINING)
		vampire.status &= ~VAMP_DRAINING
		to_chat(src, SPAN_NOTICE("You will retract your fangs once the next blood draining cycle completes."))
		return

	if(vampire.blood_usable > VAMPIRE_MAX_USABLE_BLOOD)
		to_chat(src, SPAN_WARNING("You are fully loaded on usable blood, you cannot store any more!"))
		return

	var/obj/item/grab/G = get_active_hand()
	if(!istype(G))
		to_chat(src, SPAN_WARNING("You must be grabbing a victim in your active hand to drain their blood."))
		return
	if(G.state == GRAB_PASSIVE || G.state == GRAB_UPGRADING)
		to_chat(src, SPAN_WARNING("You must have a better grip of the victim to drain their blood."))
		return

	var/mob/living/carbon/human/T = G.affecting
	if(!istype(T) || T.species.flags & NO_BLOOD)
		//Added this to prevent vampires draining diona and IPCs
		//Diona have 'blood' but its really green sap and shouldn't help vampires
		//IPCs leak oil
		to_chat(src, SPAN_WARNING("[T] is not a creature you can drain useful blood from."))
		return
	if(T.head && (T.head.item_flags & AIRTIGHT))
		to_chat(src, SPAN_WARNING("[T]'s headgear is blocking the way to the neck."))
		return
	var/obj/item/blocked = check_mouth_coverage()
	if(blocked)
		to_chat(src, SPAN_WARNING("\The [blocked] is in the way of your fangs!"))
		return

	var/datum/vampire/draining_vamp = null
	if(T.mind)
		draining_vamp = T.mind.antag_datums[MODE_VAMPIRE]

	var/target_aware = !!T.client

	var/blood = 0
	var/blood_total = 0
	var/blood_usable = 0

	vampire.status |= VAMP_DRAINING

	visible_message(SPAN_DANGER("[src] bites \the [T]'s neck!"), SPAN_DANGER("You bite \the [T]'s neck and begin to drain their blood."), SPAN_NOTICE("You hear a soft puncture and a wet sucking noise."))
	var/remembrance
	if(vampire.stealth)
		remembrance = "forgot"
	else
		remembrance = "remembered"
	admin_attack_log(src, T, "drained blood from [key_name(T)], who [remembrance] the encounter.", "had their blood drained by [key_name(src)] and [remembrance] the encounter.", "is draining blood from")

	if(vampire.stealth)
		to_chat(T, SPAN_WARNING("You are unable to resist or even move. Your mind blanks completely as you're being fed upon."))
		T.paralysis = 3400
	else
		to_chat(T, SPAN_WARNING("You are unable to resist or even move. Your mind is acutely aware of what's occuring."))
	T.Stun(25)

	playsound(src.loc, 'sound/effects/drain_blood_new.ogg', 50, 1)

	while(do_mob(src, T, 50) && vampire.status & VAMP_DRAINING && vampire.blood_usable < VAMPIRE_MAX_USABLE_BLOOD)
		if(!vampire)
			to_chat(src, SPAN_DANGER("Your fangs have disappeared!"))
			return

		blood_total = vampire.blood_total
		blood_usable = vampire.blood_usable

		if (!REAGENT_VOLUME(T.vessel, /singleton/reagent/blood))
			to_chat(src, SPAN_DANGER("[T] has no more blood left to give."))
			break

		if(T.stunned < 25)
			T.Stun(25)

		var/frenzy_lower_chance = 0

		// Alive and not of empty mind.
		if (check_drain_target_state(T))
			blood = min(15, REAGENT_VOLUME(T.vessel, /singleton/reagent/blood))
			vampire.blood_total += blood
			vampire.blood_usable += blood

			frenzy_lower_chance = 40

			if(draining_vamp)
				vampire.blood_vamp += blood
				// Each point of vampire blood will increase your chance to frenzy.
				vampire.frenzy += blood

				// And drain the vampire as well.
				draining_vamp.blood_usable -= min(blood, draining_vamp.blood_usable)
				vampire_check_frenzy()

				frenzy_lower_chance = 0
		// SSD/protohuman or dead.
		else
			blood = min(5, REAGENT_VOLUME(T.vessel, /singleton/reagent/blood))
			vampire.blood_usable += blood

			frenzy_lower_chance = 40

		if(prob(frenzy_lower_chance) && vampire.frenzy > 0)
			vampire.frenzy--

		if(blood_total != vampire.blood_total)
			var/update_msg = "You have accumulated [vampire.blood_total] unit\s of blood"
			if(blood_usable != vampire.blood_usable)
				update_msg += " and have [vampire.blood_usable] left to use"
			update_msg += "."

			to_chat(src, SPAN_NOTICE(update_msg))
		check_vampire_upgrade()
		T.vessel.remove_reagent(/singleton/reagent/blood, 5)

	vampire.status &= ~VAMP_DRAINING

	var/endsuckmsg = "You extract your fangs from \the [T]'s neck and stop draining them of blood."
	if(vampire.stealth)
		endsuckmsg += " They will only remember about this encounter by what you tell them now. If you don't tell them anything, then they will forget the previous few minutes entirely, provided they survived."
	visible_message(SPAN_DANGER("[src] stops biting \the [T]'s neck!"), SPAN_NOTICE(endsuckmsg))
	if(target_aware)
		T.paralysis = 0
		T.stunned = 0
		if(T.stat != DEAD)
			if(vampire.stealth)
				to_chat(T.find_mob_consciousness(), SPAN_WARNING("You remember nothing about being fed upon. Instead, you remember whatever \the [src] told you after it was over. If \the [src] said nothing, then you have forgotten the entire interaction and the few minutes leading up to it."))
			else
				to_chat(T.find_mob_consciousness(), SPAN_WARNING("You remember everything about being fed upon. How you react to [src]'s actions is up to you."))

// Check that our target is alive, logged in, and any other special cases
/mob/living/carbon/human/proc/check_drain_target_state(var/mob/living/carbon/human/T)
	if(T.stat < DEAD)
		if(T.client || (T.bg && T.bg.client))
			return TRUE

// Small area of effect stun.
/mob/living/carbon/human/proc/vampire_glare()
	set category = "Vampire"
	set name = "Glare"
	set desc = "Your eyes flash a bright light, stunning any who are watching."

	if(!vampire_power(0, 1))
		return
	if(!has_eyes())
		to_chat(src, SPAN_WARNING("You don't have eyes!"))
		return
	if(istype(glasses, /obj/item/clothing/glasses/sunglasses/blindfold))
		to_chat(src, SPAN_WARNING("You're blindfolded!"))
		return

	visible_message(SPAN_DANGER("[src.name]'s eyes emit a blinding flash!"))
	var/list/victims = list()
	for(var/mob/living/L in viewers(2) - src)
		if(ishuman(L))
			if(!vampire_can_affect_target(L, 0, affect_ipc = TRUE))
				continue

			L.Weaken(8)
			L.stuttering = 20
			L.confused = 10
			to_chat(L, SPAN_DANGER("You are blinded by [src]'s glare!"))
			L.flash_eyes(FLASH_PROTECTION_MAJOR)
			victims += L
		else if(isrobot(L))
			L.Weaken(rand(3, 6))
			victims += L

	admin_attacker_log_many_victims(src, victims, "used glare to stun", "was stunned by [key_name(src)] using glare", "used glare to stun")

	verbs -= /mob/living/carbon/human/proc/vampire_glare
	ADD_VERB_IN_IF(src, 800, /mob/living/carbon/human/proc/vampire_glare, CALLBACK(src, .proc/finish_vamp_timeout))

// Targeted stun ability, moderate duration.
/mob/living/carbon/human/proc/vampire_hypnotise()
	set category = "Vampire"
	set name = "Hypnotise (10)"
	set desc = "Through blood magic, you dominate the victim's mind and force them into a hypnotic transe."

	var/datum/vampire/vampire = vampire_power(10, 1)
	if(!vampire)
		return
	if(!has_eyes())
		to_chat(src, SPAN_WARNING("You don't have eyes!"))
		return

	var/list/victims = list()
	for(var/mob/living/carbon/human/H in view(3))
		if(H == src)
			continue
		victims += H
	if(!length(victims))
		to_chat(src, SPAN_WARNING("No suitable targets."))
		return

	var/mob/living/carbon/human/T = input(src, "Select Victim") as null|mob in victims
	if(!vampire_can_affect_target(T))
		return

	to_chat(src, SPAN_NOTICE("You begin peering into [T.name]'s mind, looking for a way to render them useless."))

	if(do_mob(src, T, 50))
		to_chat(src, SPAN_DANGER("You dominate [T.name]'s mind and render them temporarily powerless to resist."))
		to_chat(T, SPAN_DANGER("You are captivated by [src.name]'s gaze, and find yourself unable to move or even speak."))
		T.Weaken(25)
		T.Stun(25)
		T.silent += 30

		vampire.use_blood(10)
		admin_attack_log(src, T, "used hypnotise to stun [key_name(T)]", "was stunned by [key_name(src)] using hypnotise", "used hypnotise on")

		verbs -= /mob/living/carbon/human/proc/vampire_hypnotise
		ADD_VERB_IN_IF(src, 1200, /mob/living/carbon/human/proc/vampire_hypnotise, CALLBACK(src, .proc/finish_vamp_timeout))
	else
		to_chat(src, SPAN_WARNING("You broke your gaze."))

// Targeted teleportation, must be to a low-light tile.
/mob/living/carbon/human/proc/vampire_veilstep(var/turf/T in turfs)
	set category = "Vampire"
	set name = "Veil Step (20)"
	set desc = "For a moment, move through the Veil and emerge at a shadow of your choice."

	if(!T || T.density || T.contains_dense_objects())
		to_chat(src, SPAN_WARNING("You cannot do that."))
		return

	var/datum/vampire/vampire = vampire_power(20, 1)
	if(!vampire)
		return
	if(!istype(loc, /turf))
		to_chat(src, SPAN_WARNING("You cannot teleport out of your current location."))
		return
	if(T.z != src.z || get_dist(T, get_turf(src)) > world.view)
		to_chat(src, SPAN_WARNING("Your powers are not capable of taking you that far."))
		return
	if(T.get_lumcount() > 0.1)
		// Too bright, cannot jump into.
		to_chat(src, SPAN_WARNING("The destination is too bright."))
		return

	vampire_phase_out(get_turf(loc))

	forceMove(T)

	vampire_phase_in(T)

	for(var/obj/item/grab/G in contents)
		if (G.affecting && (vampire.status & VAMP_FULLPOWER))
			G.affecting.vampire_phase_out(get_turf(G.affecting.loc))
			G.affecting.forceMove(locate(T.x + rand(-1,1), T.y + rand(-1,1), T.z))
			G.affecting.vampire_phase_in(get_turf(G.affecting.loc))
		else
			qdel(G)

	log_and_message_admins("activated veil step.")

	vampire.use_blood(20)
	verbs -= /mob/living/carbon/human/proc/vampire_veilstep
	ADD_VERB_IN_IF(src, 300, /mob/living/carbon/human/proc/vampire_veilstep, CALLBACK(src, .proc/finish_vamp_timeout))

// Summons bats.
/mob/living/carbon/human/proc/vampire_bats()
	set category = "Vampire"
	set name = "Summon Bats (60)"
	set desc = "You tear open the Veil for just a moment, in order to summon a pair of bats to assist you in combat."

	var/datum/vampire/vampire = vampire_power(60, 0)
	if(!vampire)
		return

	var/list/locs = list()

	for(var/direction in alldirs)
		var/turf/T = get_step(get_turf(src), direction)
		if(T || !T.density || !T.contains_dense_objects())
			locs += T
		if(length(locs) >= 2)
			break

	var/list/spawned = list()
	if(length(locs))
		for(var/turf/to_spawn in locs)
			spawned += new /mob/living/simple_animal/hostile/scarybat(to_spawn, src)
		if(length(spawned) < 2)
			spawned += new /mob/living/simple_animal/hostile/scarybat(get_turf(src), src)
	else
		spawned += new /mob/living/simple_animal/hostile/scarybat(get_turf(src), src)
		spawned += new /mob/living/simple_animal/hostile/scarybat(get_turf(src), src)

	if(!length(spawned))
		return

	for(var/thing in spawned)
		var/mob/living/simple_animal/hostile/scarybat/bat = thing
		LAZYADD(bat.friends, src)
		for(var/thrall in vampire.thralls)
			LAZYADD(bat.friends, thrall)

	log_and_message_admins("summoned bats.")

	vampire.use_blood(60)
	verbs -= /mob/living/carbon/human/proc/vampire_bats
	ADD_VERB_IN_IF(src, 1200, /mob/living/carbon/human/proc/vampire_bats, CALLBACK(src, .proc/finish_vamp_timeout))

// Chiropteran Screech
/mob/living/carbon/human/proc/vampire_screech()
	set category = "Vampire"
	set name = "Chiropteran Screech (90)"
	set desc = "Emit a powerful screech which shatters glass within a seven-tile radius, and stuns hearers in a four-tile radius."

	var/datum/vampire/vampire = vampire_power(90, 0)
	if(!vampire)
		return

	visible_message(SPAN_DANGER("[src] lets out an ear piercing shriek!"), SPAN_DANGER("You let out an ear-shattering shriek!"), SPAN_DANGER("You hear a painfully loud shriek!"))

	var/list/victims = list()
	for(var/mob/living/carbon/human/T in hearers(4, src) - src)
		if(T.protected_from_sound())
			continue
		if(!vampire_can_affect_target(T, 0))
			continue
		to_chat(T, SPAN_DANGER("<font size='3'><b>You hear an ear piercing shriek and feel your senses go dull!</b></font>"))
		if (T.get_hearing_sensitivity())
			if (T.is_listening())
				T.Weaken(10)
				T.Stun(10)
				T.earpain(4)
			else
				T.Weaken(7)
				T.Stun(7)
				T.earpain(3)
		else
			T.Weaken(5)
			T.Stun(5)
		T.stuttering = 20
		T.adjustEarDamage(10, 20, TRUE)

		victims += T

	for(var/obj/structure/window/W in view(7))
		W.shatter()

	for(var/obj/machinery/door/window/WD in view(7))
		if(get_dist(src, WD) > 5) //Windoors are strong, may only take damage instead of break if far away.
			WD.take_damage(rand(12, 16) * 10)
		else
			WD.shatter()

	for(var/obj/machinery/light/L in view(7))
		L.broken()

	playsound(src.loc, 'sound/effects/creepyshriek.ogg', 100, 1)
	vampire.use_blood(90)

	if(length(victims))
		admin_attacker_log_many_victims(src, victims, "used chriopteran screech to stun", "was stunned by [key_name(src)] using chriopteran screech", "used chiropteran screech to stun")
	else
		log_and_message_admins("used chiropteran screech.")

	verbs -= /mob/living/carbon/human/proc/vampire_screech
	ADD_VERB_IN_IF(src, 3600, /mob/living/carbon/human/proc/vampire_screech, CALLBACK(src, .proc/finish_vamp_timeout))

// Enables the vampire to be untouchable and walk through walls and other solid things.
/mob/living/carbon/human/proc/vampire_veilwalk()
	set category = "Vampire"
	set name = "Toggle Veil Walking (80)"
	set desc = "You enter the veil, leaving only an incorporeal manifestation of you visible to the others."

	var/datum/vampire/vampire = vampire_power(0, 0, 1)
	if(!vampire)
		return

	if(isAdminLevel(src.z))
		return

	if(pulledby)
		if(pulledby.pulling == src)
			pulledby.pulling = null
		pulledby = null
	for(var/thing in grabbed_by)
		qdel(thing)

	if(vampire.holder)
		vampire.holder.deactivate()
	else
		vampire = vampire_power(80, 0, 1)
		if(!vampire)
			return

		var/obj/effect/dummy/veil_walk/holder = new /obj/effect/dummy/veil_walk(get_turf(loc))
		holder.activate(src)

		log_and_message_admins("activated veil walk.")

		vampire.use_blood(80)

// Veilwalk's dummy holder
/obj/effect/dummy/veil_walk
	name = "red shade"
	desc = "A red, shimmering presence."
	icon = 'icons/mob/mob.dmi'
	icon_state = "blank"
	density = FALSE

	var/last_valid_turf = null
	var/ghost_last_move = 0
	var/ghost_move_delay = 2 // 2 deciseconds
	var/mob/owner_mob = null
	var/datum/vampire/owner_vampire = null
	var/warning_level = 0

/obj/effect/dummy/veil_walk/Destroy()
	eject_all()

	STOP_PROCESSING(SSprocessing, src)

	return ..()

/obj/effect/dummy/veil_walk/proc/eject_all()
	for(var/atom/movable/A in src)
		A.forceMove(last_valid_turf)
		if(ismob(A))
			var/mob/M = A
			M.reset_view(null)

/obj/effect/dummy/veil_walk/relaymove(var/mob/user, direction)
	if(user != owner_mob)
		return
	if(ghost_last_move + ghost_move_delay > world.time)
		return
	ghost_last_move = world.time

	var/turf/new_loc = get_step(src, direction)
	if(new_loc.flags & NOJAUNT || istype(new_loc.loc, /area/chapel))
		to_chat(usr, SPAN_WARNING("Some strange aura is blocking the way!"))
		return

	forceMove(new_loc)
	var/turf/T = get_turf(loc)
	if(!T.contains_dense_objects())
		last_valid_turf = T
	set_dir(direction)

/obj/effect/dummy/veil_walk/process()
	if(owner_mob.stat)
		if(owner_mob.stat == UNCONSCIOUS)
			to_chat(owner_mob, SPAN_WARNING("You cannot maintain this form while unconcious."))
			addtimer(CALLBACK(src, .proc/kick_unconcious), 10, TIMER_UNIQUE)
		else
			deactivate()
			return

	get_user_appearance()

	if(owner_vampire.blood_usable >= 5)
		owner_vampire.use_blood(5)

		switch(warning_level)
			if(0)
				if (owner_vampire.blood_usable <= 5 * 20)
					to_chat(owner_mob, SPAN_NOTICE("Your pool of blood is diminishing. You cannot stay in the veil for too long."))
					warning_level = 1
			if(1)
				if (owner_vampire.blood_usable <= 5 * 10)
					to_chat(owner_mob, SPAN_WARNING("You will be ejected from the veil soon, as your pool of blood is running dry."))
					warning_level = 2
			if(2)
				if (owner_vampire.blood_usable <= 5 * 5)
					to_chat(owner_mob, SPAN_DANGER("You cannot sustain this form for any longer!"))
					warning_level = 3
	else
		deactivate()

/obj/effect/dummy/veil_walk/proc/activate(var/mob/owner)
	if(!owner)
		qdel(src)
		return

	owner_mob = owner
	owner_vampire = owner.vampire_power()
	if(!owner_vampire)
		qdel(src)
		return

	owner_vampire.holder = src
	owner.vampire_phase_out(get_turf(owner.loc))
	get_user_appearance()

	last_valid_turf = get_turf(owner.loc)
	owner.forceMove(src)

	var/datum/vampire/vampire = owner_mob.mind.antag_datums[MODE_VAMPIRE]
	if(vampire.status & VAMP_FULLPOWER)
		for(var/obj/item/grab/G in list(owner.l_hand, owner.r_hand))
			G.affecting.vampire_phase_out(get_turf(G))
			G.affecting.forceMove(src)

	START_PROCESSING(SSprocessing, src)

/obj/effect/dummy/veil_walk/proc/deactivate()
	STOP_PROCESSING(SSprocessing, src)

	ghost_last_move = world.time + 500

	owner_mob.vampire_phase_in(get_turf(loc))

	eject_all()

	owner_mob = null

	owner_vampire.holder = null
	owner_vampire = null

	qdel(src)

/obj/effect/dummy/veil_walk/proc/kick_unconcious()
	if(owner_mob?.stat)
		to_chat(owner_mob, SPAN_DANGER("You are ejected from the Veil."))
		deactivate()
		return

/obj/effect/dummy/veil_walk/proc/get_user_appearance()
	appearance = owner_mob
	color = rgb(225, 125, 125)
	alpha = 100
	name = initial(name)
	desc = "[initial(desc)] + Its features look faintly alike [owner_mob.name]'s."

/obj/effect/dummy/veil_walk/ex_act(vars)
	return

/obj/effect/dummy/veil_walk/bullet_act(vars)
	return

// Heals the vampire at the cost of blood.
/mob/living/carbon/human/proc/vampire_bloodheal()
	set category = "Vampire"
	set name = "Blood Heal"
	set desc = "At the cost of blood and time, heal any injuries you have sustained."

	var/datum/vampire/vampire = vampire_power(0, 0)
	if(!vampire)
		return

	// Kick out of the already running loop.
	if(vampire.status & VAMP_HEALING)
		vampire.status &= ~VAMP_HEALING
		return
	else if(vampire.blood_usable < 15)
		to_chat(src, SPAN_WARNING("You do not have enough usable blood. 15 needed."))
		return

	vampire.status |= VAMP_HEALING
	to_chat(src, SPAN_NOTICE("You begin the process of blood healing. Do not move, and ensure that you are not interrupted."))

	log_and_message_admins("activated blood heal.")

	while(do_after(src, 20, 0))
		if(!(vampire.status & VAMP_HEALING))
			to_chat(src, SPAN_WARNING("Your concentration is broken! You are no longer regenerating!"))
			break

		var/tox_loss = getToxLoss()
		var/oxy_loss = getOxyLoss()
		var/ext_loss = getBruteLoss() + getFireLoss()
		var/clone_loss = getCloneLoss()

		var/blood_used = 0
		var/to_heal = 0

		if(tox_loss)
			to_heal = min(10, tox_loss)
			adjustToxLoss(0 - to_heal)
			blood_used += round(to_heal * 0.25)
		if(oxy_loss)
			to_heal = min(10, oxy_loss)
			adjustOxyLoss(0 - to_heal)
			blood_used += round(to_heal * 0.25)
		if(ext_loss)
			to_heal = min(20, ext_loss)
			heal_overall_damage(min(10, getBruteLoss()), min(10, getFireLoss()))
			blood_used += round(to_heal * 0.25)
		if(clone_loss)
			to_heal = min(10, clone_loss)
			adjustCloneLoss(0 - to_heal)
			blood_used += round(to_heal * 0.25)

		adjustHalLoss(-20)

		var/list/damaged_organs = get_damaged_organs(TRUE, TRUE, FALSE)
		if(length(damaged_organs))
			// Heal an absurd amount, basically regenerate one organ.
			heal_organ_damage(50, 50, FALSE)
			blood_used += 3

		var/missing_blood = species.blood_volume - REAGENT_VOLUME(vessel, /singleton/reagent/blood)
		if(missing_blood)
			to_heal = min(20, missing_blood)
			vessel.add_reagent(/singleton/reagent/blood, to_heal)
			blood_used += round(to_heal * 0.1) // gonna need to regen a shitton of blood, since human mobs have around 560 normally

		for(var/A in organs)
			var/healed = FALSE
			var/obj/item/organ/external/E = A
			if(BP_IS_ROBOTIC(E))
				continue
			if(E.status & ORGAN_ARTERY_CUT)
				E.status &= ~ORGAN_ARTERY_CUT
				blood_used += 2
			if((E.tendon_status() & TENDON_CUT) && E.tendon.can_recover())
				E.tendon.rejuvenate()
				blood_used += 2
			if(E.status & ORGAN_BROKEN)
				E.status &= ~ORGAN_BROKEN
				E.stage = 0
				blood_used += 3
				healed = TRUE
			if(E.germ_level > 0)
				if(E.is_infected())
					E.germ_level = max(0, E.germ_level - 50)
					blood_used += 1
				else
					E.germ_level = 0
					blood_used += 0.25
			for(var/datum/wound/W in E.wounds)
				if(W.germ_level > 0)
					W.germ_level = max(0, W.germ_level - 50)
					blood_used += 0.5
				if(!W.disinfected)
					W.disinfect()
					blood_used += 1


			if(healed)
				break

		var/list/emotes_lookers = list("[src]'s skin appears to liquefy for a moment, sealing up their wounds.",
									"[src]'s veins turn black as their damaged flesh regenerates before your eyes!",
									"[src]'s skin begins to split open. It turns to ash and falls away, revealing the wound to be fully healed.",
									"Whispering arcane things, [src]'s damaged flesh appears to regenerate.",
									"Thick globs of blood cover a wound on [src]'s body, eventually melding to be one with [get_pronoun("his")] flesh.",
									"[src]'s body crackles, skin and bone shifting back into place.")
		var/list/emotes_self = list("Your skin appears to liquefy for a moment, sealing up your wounds.",
									"Your veins turn black as their damaged flesh regenerates before your eyes!",
									"Your skin begins to split open. It turns to ash and falls away, revealing the wound to be fully healed.",
									"Whispering arcane things, your damaged flesh appears to regenerate.",
									"Thick globs of blood cover a wound on your body, eventually melding to be one with your flesh.",
									"Your body crackles, skin and bone shifting back into place.")

		if(prob(20))
			visible_message(SPAN_DANGER("[pick(emotes_lookers)]"), SPAN_NOTICE("[pick(emotes_self)]"))

		if(vampire.blood_usable <= blood_used)
			vampire.blood_usable = 0
			vampire.status &= ~VAMP_HEALING
			to_chat(src, SPAN_WARNING("You ran out of blood, and are unable to continue!"))
			break
		else if(!blood_used)
			vampire.status &= ~VAMP_HEALING
			to_chat(src, SPAN_NOTICE("Your body has finished healing. You are ready to continue."))
			break
		else
			vampire.blood_usable -= blood_used

	// We broke out of the loop naturally. Gotta catch that.
	if(vampire.status & VAMP_HEALING)
		vampire.status &= ~VAMP_HEALING
		to_chat(src, SPAN_WARNING("Your concentration is broken! You are no longer regenerating!"))

	return

// Enthralls a person, giving the vampire a mortal slave.
/mob/living/carbon/human/proc/vampire_enthrall()
	set category = "Vampire"
	set name = "Enthrall (150)"
	set desc = "Bind a mortal soul with a bloodbond to obey your every command."

	var/datum/vampire/vampire = vampire_power(150, 0)
	if(!vampire)
		return

	var/obj/item/grab/G = get_active_hand()
	if(!istype(G))
		to_chat(src, SPAN_WARNING("You must be grabbing a victim in your active hand to enthrall them."))
		return
	if(G.state == GRAB_PASSIVE || G.state == GRAB_UPGRADING)
		to_chat(src, SPAN_WARNING("You must have a better grip of the victim to enthrall them."))
		return

	var/mob/living/carbon/human/T = G.affecting
	if(isipc(T))
		to_chat(src, SPAN_WARNING("[T] is not a creature you can enthrall."))
		return
	if(!istype(T))
		to_chat(src, SPAN_WARNING("[T] is not a creature you can enthrall."))
		return
	if(!vampire_can_affect_target(T, 1, 1))
		return
	if(!T.client || !T.mind)
		to_chat(src, SPAN_WARNING("[T]'s mind is empty and useless. They cannot be forced into a blood bond."))
		return
	if(vampire.status & VAMP_DRAINING)
		to_chat(src, SPAN_WARNING("Your fangs are already sunk into a victim's neck!"))
		return

	visible_message(SPAN_DANGER("[src] tears the flesh on their wrist, and holds it up to [T]. In a gruesome display, [T] starts lapping up the blood that's oozing from the fresh wound."), SPAN_WARNING("You inflict a wound upon yourself, and force them to drink your blood, thus starting the conversion process."))
	to_chat(T, SPAN_WARNING("You feel an irresistable desire to drink the blood pooling out of [src]'s wound. Against your better judgement, you give in and start doing so."))

	if(!do_mob(src, T, 50))
		visible_message(SPAN_DANGER("[src] yanks away their hand from [T]'s mouth as they're interrupted, the wound quickly sealing itself!"), SPAN_DANGER("You are interrupted!"))
		return

	to_chat(T, SPAN_DANGER("Your mind blanks as you finish feeding from [src]'s wrist."))
	thralls.add_antagonist(T.mind, 1, 1, 0, 1, 1)

	var/datum/vampire/T_vampire = T.mind.antag_datums[MODE_VAMPIRE]
	T_vampire.assign_master(T, src, vampire)
	to_chat(T, SPAN_NOTICE("You have been forced into a blood bond by [T_vampire.master], and are thus their thrall. While a thrall may feel a myriad of emotions towards their master, ranging from fear, to hate, to love; the supernatural bond between them still forces the thrall to obey their master, and to listen to the master's commands.<br><br>You must obey your master's orders, you must protect them, you cannot harm them."))
	to_chat(src, SPAN_NOTICE("You have completed the thralling process. They are now your slave and will obey your commands."))
	admin_attack_log(src, T, "enthralled [key_name(T)]", "was enthralled by [key_name(src)]", "successfully enthralled")

	vampire.use_blood(150)
	verbs -= /mob/living/carbon/human/proc/vampire_enthrall
	ADD_VERB_IN_IF(src, 2800, /mob/living/carbon/human/proc/vampire_enthrall, CALLBACK(src, .proc/finish_vamp_timeout))

// Makes the vampire appear 'friendlier' to others.
/mob/living/carbon/human/proc/vampire_presence()
	set category = "Vampire"
	set name = "Presence (10)"
	set desc = "Influences those weak of mind to look at you in a friendlier light."

	var/datum/vampire/vampire = vampire_power(0, 0)
	if(!vampire)
		return

	if(vampire.status & VAMP_PRESENCE)
		vampire.status &= ~VAMP_PRESENCE
		to_chat(src, SPAN_WARNING("You are no longer influencing those weak of mind."))
		return
	else if(vampire.blood_usable < 15)
		to_chat(src, SPAN_WARNING("You do not have enough usable blood. 15 needed."))
		return

	to_chat(src, SPAN_NOTICE("You begin passively influencing the weak minded."))
	vampire.status |= VAMP_PRESENCE

	var/list/mob/living/carbon/human/affected = list()
	var/list/emotes = list("[src] looks trusthworthy.",
							"You feel as if [src] is a relatively friendly individual.",
							"You feel yourself paying more attention to what [src] is saying.",
							"[src] has your best interests at heart, you can feel it.",
							"A quiet voice tells you that [src] should be considered a friend.")

	vampire.use_blood(10)

	log_and_message_admins("activated presence.")

	while(vampire.status & VAMP_PRESENCE)
		// Run every 20 seconds
		sleep(200)

		if(stat)
			to_chat(src, SPAN_WARNING("You cannot influence people around you while [stat == UNCONSCIOUS ? "unconcious" : "dead"]."))
			vampire.status &= ~VAMP_PRESENCE
			break

		for(var/mob/living/carbon/human/T in view(5))
			if(T == src)
				continue
			if(!vampire_can_affect_target(T, 0, 1, affect_ipc = FALSE)) //Will only affect IPCs at full power.
				continue
			if(!T.client)
				continue

			var/probability = 50
			if(!(T in affected))
				affected += T
				probability = 80

			if(prob(probability))
				to_chat(T, SPAN_GOOD("<i>[pick(emotes)]</i>"))

		vampire.use_blood(5)

		if(vampire.blood_usable < 5)
			vampire.status &= ~VAMP_PRESENCE
			to_chat(src, SPAN_WARNING("You are no longer influencing those weak of mind."))
			break

/mob/living/carbon/human/proc/vampire_touch_of_life()
	set category = "Vampire"
	set name = "Touch of Life (50)"
	set desc = "You lay your hands on the target, transferring healing chemicals to them."

	var/datum/vampire/vampire = vampire_power(50, 0)
	if(!vampire)
		return

	var/obj/item/grab/G = get_active_hand()
	if(!istype(G))
		to_chat(src, SPAN_WARNING("You must be grabbing a victim in your active hand to touch them."))
		return

	var/mob/living/carbon/human/T = G.affecting
	if(T.species.flags & NO_BLOOD)
		to_chat(src, SPAN_WARNING("[T] has no blood and can not be affected by your powers!"))
		return

	visible_message("<b>[src]</b> gently touches [T].")
	to_chat(T, SPAN_NOTICE("You feel pure bliss as [src] touches you."))
	vampire.use_blood(50)

	T.reagents.add_reagent(/singleton/reagent/rezadone, 3)
	T.reagents.add_reagent(/singleton/reagent/oxycomorphine, 0.15) //enough to get back onto their feet

// Convert a human into a vampire.
/mob/living/carbon/human/proc/vampire_embrace()
	set category = "Vampire"
	set name = "The Embrace"
	set desc = "Spread your corruption to an innocent soul, turning them into a spawn of the Veil, much akin to yourself."

	var/datum/vampire/vampire = vampire_power(0, 0)
	if(!vampire)
		return

	// Re-using blood drain code.
	var/obj/item/grab/G = get_active_hand()
	if(!istype(G))
		to_chat(src, SPAN_WARNING("You must be grabbing a victim in your active hand to drain their blood."))
		return
	if(G.state == GRAB_PASSIVE || G.state == GRAB_UPGRADING)
		to_chat(src, SPAN_WARNING("You must have a better grip of the victim to drain their blood."))
		return

	var/mob/living/carbon/human/T = G.affecting
	if(!vampire_can_affect_target(T, ignore_thrall = TRUE))
		return
	if(!T.client)
		to_chat(src, SPAN_WARNING("[T] is a mindless husk. The Veil has no purpose for them."))
		return
	if(T.stat == DEAD)
		to_chat(src, SPAN_WARNING("[T]'s body is broken and damaged beyond salvation. You have no use for them."))
		return
	if(T.species.flags & NO_BLOOD)
		to_chat(src, SPAN_WARNING("[T] has no blood and can not be affected by your powers!"))
		return
	if(vampire.status & VAMP_DRAINING)
		to_chat(src, SPAN_WARNING("Your fangs are already sunk into a victim's neck!"))
		return

	if(T.mind)
		var/datum/vampire/draining_vamp = T.mind.antag_datums[MODE_VAMPIRE]
		if(draining_vamp)
			if(draining_vamp.status & VAMP_ISTHRALL)
				var/choice_text = ""
				var/denial_response = ""
				if(draining_vamp.master == src)
					choice_text = "[T] is your thrall. Do you wish to release them from the blood bond and give them the chance to become your equal?"
					denial_response = "You opt against giving [T] a chance to ascend, and choose to keep them as a servant."
				else
					choice_text = "You can feel the taint of another master running in the veins of [T]. Do you wish to release them of their blood bond, and convert them into a vampire, in spite of their master?"
					denial_response = "You choose not to continue with the Embrace, and permit [T] to keep serving their master."

				if(alert(src, choice_text, "Choices", "Yes", "No") == "No")
					to_chat(src, SPAN_NOTICE("[denial_response]"))
					return

				thralls.remove_antagonist(T.mind, 0, 0)
				qdel(draining_vamp)
				draining_vamp = null
			else
				to_chat(src, SPAN_WARNING("You feel corruption running in [T]'s blood. Much like yourself, [T.get_pronoun("he")] is already a spawn of the Veil, and cannot be Embraced."))
				return

	vampire.status |= VAMP_DRAINING

	visible_message(SPAN_DANGER("[src] bites [T]'s neck!"), SPAN_DANGER("You bite [T]'s neck and begin to drain their blood, as the first step of introducing the corruption of the Veil to them."), SPAN_NOTICE("You hear a soft puncture and a wet sucking noise."))

	to_chat(T, SPAN_NOTICE("<br>You are currently being turned into a vampire. You will die in the course of this, but you will be revived by the end. Please do not ghost out of your body until the process is complete."))

	var/drained_all_blood = FALSE
	while(do_mob(src, T, 50))
		if(!vampire)
			to_chat(src, SPAN_WARNING("Your fangs have disappeared!"))
			return
		if (!REAGENT_VOLUME(T.vessel, /singleton/reagent/blood))
			to_chat(src, SPAN_NOTICE("[T] is now drained of blood. You begin forcing your own blood into their body, spreading the corruption of the Veil to their body."))
			drained_all_blood = TRUE
			break

		T.vessel.remove_reagent(/singleton/reagent/blood, 50)

	if(!drained_all_blood)
		vampire.status &= ~VAMP_DRAINING
		return

	T.revive()

	// You ain't goin' anywhere, bud.
	if(!T.client && T.mind)
		for(var/mob/abstract/observer/ghost in player_list)
			if(ghost.mind == T.mind)
				ghost.can_reenter_corpse = TRUE
				ghost.reenter_corpse()

				to_chat(T, SPAN_DANGER("A dark force pushes you back into your body. You find yourself somehow still clinging to life."))

	T.Weaken(15)
	vamp.add_antagonist(T.mind, 1, 1, 0, 0, 1)

	admin_attack_log(src, T, "successfully embraced [key_name(T)]", "was successfully embraced by [key_name(src)]", "successfully embraced and turned into a vampire")

	to_chat(T, SPAN_DANGER("You awaken. Moments ago, you were dead, your conciousness still forced stuck inside your body. Now you live. You feel different, a strange, dark force now present within you. You have an insatiable desire to drain the blood of mortals, and to grow in power."))
	to_chat(src, SPAN_WARNING("You have corrupted another mortal with the taint of the Veil. Beware: they will awaken hungry and maddened; not bound to any master."))

	var/datum/vampire/T_vampire = T.mind.antag_datums[MODE_VAMPIRE]
	T_vampire.blood_usable = 0
	T_vampire.frenzy = 250
	T.vampire_check_frenzy()

	vampire.status &= ~VAMP_DRAINING

// Grapple a victim by leaping onto them.
/mob/living/carbon/human/proc/grapple()
	set category = "Vampire"
	set name = "Grapple"
	set desc = "Lunge towards a target like an animal, and grapple them."

	if(status_flags & LEAPING)
		return
	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled_to)
		to_chat(src, SPAN_WARNING("You cannot lean in your current state."))
		return

	var/list/targets = list()
	for (var/mob/living/carbon/human/H in view(4, src))
		targets += H

	targets -= src

	if(!length(targets))
		to_chat(src, SPAN_WARNING("No valid targets visible or in range."))
		return

	var/mob/living/carbon/human/T = pick(targets)

	visible_message(SPAN_DANGER("[src] leaps at [T]!"))
	throw_at(get_step(get_turf(T), get_turf(src)), 4, 1, src)

	status_flags |= LEAPING

	sleep(5)

	if(status_flags & LEAPING)
		status_flags &= ~LEAPING
	if(!Adjacent(T))
		to_chat(src, SPAN_WARNING("You miss!"))
		return

	T.Weaken(3)

	admin_attack_log(src, T, "lept at and grappled [key_name(T)]", "was lept at and grappled by [key_name(src)]", "lept at and grappled")

	var/use_hand = "left"
	if(l_hand)
		if(r_hand)
			to_chat(src, SPAN_DANGER("You need to have one hand free to grab someone."))
			return
		else
			use_hand = "right"

	visible_message(SPAN_WARNING("<b>[src]</b> seizes [T] aggressively!"))

	var/obj/item/grab/G = new(src, src, T)
	if(use_hand == "left")
		l_hand = G
	else
		r_hand = G

	G.state = GRAB_AGGRESSIVE
	G.icon_state = "grabbed1"
	G.synch()

	verbs -= /mob/living/carbon/human/proc/grapple
	ADD_VERB_IN_IF(src, 800, /mob/living/carbon/human/proc/grapple, CALLBACK(src, .proc/finish_vamp_timeout, VAMP_FRENZIED))
