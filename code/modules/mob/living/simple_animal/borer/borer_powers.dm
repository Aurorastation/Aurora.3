/mob/living/simple_animal/borer/verb/release_host()
	set category = "Abilities"
	set name = "Exit Host"
	set desc = "Slither out of your host."

	if(!host)
		to_chat(src, SPAN_NOTICE("You are not inside a host body."))
		return
	if(stat)
		to_chat(src, SPAN_NOTICE("You cannot leave your host in your current state."))
		return

	var/exit_time = 10 SECONDS
	if(!start_ability(host, exit_time))
		to_chat(src, SPAN_WARNING("You're busy doing something else, complete that task first."))
		return

	to_chat(src, SPAN_NOTICE("You begin disconnecting from [host]'s synapses and prodding at their internal ear canal."))
	if(!host.stat)
		to_chat(host, SPAN_WARNING("An odd, uncomfortable pressure begins to build inside your skull, behind your ear..."))

	addtimer(CALLBACK(src, PROC_REF(exit_host)), exit_time)

/mob/living/simple_animal/borer/proc/exit_host()
	if(!host || !src)
		return

	if(stat)
		to_chat(src, SPAN_NOTICE("You cannot release your host in your current state."))
		return

	to_chat(src, SPAN_NOTICE("You wiggle out of [host]'s ear and plop to the ground."))
	if(host.mind)
		if(!host.stat)
			to_chat(host, SPAN_DANGER("Something slimy wiggles out of your ear and plops to the ground!"))
		to_chat(host, SPAN_DANGER("As though waking from a dream, you shake off the insidious mind control of the brain worm. Your thoughts are your own again."))

	detach()
	leave_host()

/mob/living/simple_animal/borer/proc/is_held_by(var/mob/living/carbon/M)
	if (istype(usr.loc, /obj/item/holder))
		var/obj/item/holder/H = usr.loc
		if (istype(H.loc, /mob/living/carbon/human))
			var/mob/living/carbon/human/held_by = H.loc
			return held_by == M

	return FALSE

/mob/living/simple_animal/borer/verb/infest()
	set category = "Abilities"
	set name = "Infest"
	set desc = "Infest a suitable humanoid host."

	if(host)
		to_chat(src, SPAN_NOTICE("You are already within a host."))
		return
	if(stat)
		to_chat(src, SPAN_NOTICE("You cannot infest a target in your current state."))
		return

	var/list/choices = list()
	for(var/mob/living/carbon/C in view(2, src))
		if(src.Adjacent(C))
			choices += C

	if (istype(usr.loc, /obj/item/holder))
		var/obj/item/holder/H = usr.loc
		if (istype(H.loc, /mob/living/carbon/human))
			var/mob/living/carbon/human/held_by = H.loc
			choices += held_by

	if(!length(choices))
		to_chat(src, SPAN_NOTICE("There are no viable hosts within range."))
		return

	var/mob/living/carbon/M = tgui_input_list(src,"Who do you wish to infest?", "Infest", choices)
	if(M)
		do_infest(M)

/mob/living/simple_animal/borer/proc/do_infest(var/mob/living/carbon/M)
	if(host)
		to_chat(src, SPAN_NOTICE("You are already within a host."))
		return
	if(stat)
		to_chat(src, SPAN_NOTICE("You cannot infest a target in your current state."))
		return
	if(!M || !src)
		return
	if(!Adjacent(M) && !is_held_by(M))
		return
	if(M.has_brain_worms())
		to_chat(src, SPAN_WARNING("You cannot infest someone who is already infested!"))
		return

	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M

		var/obj/item/organ/external/E = H.organs_by_name[BP_HEAD]
		if(!E || E.is_stump())
			to_chat(src, SPAN_WARNING("\The [H] does not have a head!"))
			return
		var/obj/item/organ/internal/I = H.species.has_organ[BP_BRAIN]
		if(!I)
			to_chat(src, SPAN_WARNING("\The [H] doesn't have a brain!"))
			return
		if(istype(I, /obj/item/organ/internal/borer))
			to_chat(src, SPAN_WARNING("You cannot infest someone who is already infested!"))
			return
		if(H.isSynthetic())
			to_chat(src, SPAN_NOTICE("You can't affect synthetics."))
			return
		if(H.check_head_airtight_coverage())
			to_chat(src, SPAN_WARNING("You cannot get through that host's protective gear."))
			return

	to_chat(M, SPAN_WARNING("Something slimy begins probing at the opening of your ear canal..."))
	to_chat(src, SPAN_WARNING("You slither up [M] and begin probing at their ear canal..."))

	if(!do_after(src,30) && !is_held_by(M))
		to_chat(src, SPAN_WARNING("As [M] moves away, you are dislodged and fall to the ground."))
		return
	if(!M || !src)
		return
	if(src.stat)
		to_chat(src, SPAN_NOTICE("You cannot infest a target in your current state."))
		return

	if((M in view(1, src)) || is_held_by(M))
		to_chat(src, SPAN_NOTICE("You wiggle into [M]'s ear."))
		if(!M.stat)
			to_chat(M, SPAN_DANGER("Something disgusting and slimy wiggles into your ear!"))

		src.host = M
		src.host.status_flags |= PASSEMOTES
		src.forceMove(M)

		if(client && host.healths)
			client.screen += host.healths

		//Update their traitor status.
		if(host.mind)
			GLOB.borers.add_antagonist_mind(host.mind, 1, GLOB.borers.faction_role_text, GLOB.borers.faction_welcome)

		if(istype(M,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/I = H.internal_organs_by_name[BP_BRAIN]
			if(!I) // No brain organ, so the borer moves in and replaces it permanently.
				replace_brain()
			else
				// If they're in normally, implant removal can get them out.
				var/obj/item/organ/external/head = H.get_organ(BP_HEAD)
				head.implants += src

		return
	else
		to_chat(src, SPAN_WARNING("They are no longer in range!"))
		return

/mob/living/simple_animal/borer/verb/devour_brain()
	set category = "Abilities"
	set name = "Devour Brain"
	set desc = "Replace the brain of your host by devouring it, forming a husk."

	if(!host)
		to_chat(src, SPAN_NOTICE("You are not inside a host body."))
		return
	if(stat)
		to_chat(src, SPAN_NOTICE("You cannot do that in your current state."))
		return
	if(host.stat != DEAD)
		to_chat(src, SPAN_WARNING("Your host is still alive."))
		return

	to_chat(src, SPAN_DANGER("It only takes a few moments to render the dead brain down into a nutrient-rich slurry..."))
	replace_brain()

// BRAIN WORM ZOMBIES AAAAH.
/mob/living/simple_animal/borer/proc/replace_brain()
	var/mob/living/carbon/human/H = host

	if(!istype(host))
		to_chat(src, SPAN_WARNING("This host does not have a suitable brain."))
		return

	to_chat(src, SPAN_WARNING("You settle into the empty brainpan and begin to expand, fusing inextricably with the dead flesh of [H]."))

	H.add_language(LANGUAGE_BORER)
	H.add_language(LANGUAGE_BORER_HIVEMIND)

	if(host.stat == DEAD)
		add_verb(H, /mob/living/carbon/human/proc/jumpstart)

	add_verb(H, /mob/living/carbon/human/proc/psychic_whisper)
	add_verb(H, /mob/living/carbon/human/proc/tackle)
	add_verb(H, /mob/living/carbon/proc/spawn_larvae)

	if(H.client)
		H.ghostize(FALSE)

	if(src.mind)
		src.mind.special_role = "Borer Husk"
		src.mind.transfer_to(host)
		if(host.client)
			host.client.init_verbs()

	var/obj/item/organ/internal/borer/B = new(H)
	var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
	H.internal_organs_by_name[BP_BRAIN] = B
	affecting.internal_organs |= B

	affecting.implants -= src

	var/s2h_id = src.computer_id
	var/s2h_ip= src.lastKnownIP
	src.computer_id = null
	src.lastKnownIP = null

	if(!H.computer_id)
		H.computer_id = s2h_id

	if(!H.lastKnownIP)
		H.lastKnownIP = s2h_ip

	// Since the host is dead, we want to kick it back into action immediately, then redo it to ensure they're good to go
	H.revive()
	addtimer(CALLBACK(H, PROC_REF(revive)), 30)

/mob/living/simple_animal/borer/verb/secrete_chemicals()
	set category = "Abilities"
	set name = "Secrete Chemicals (20)"
	set desc = "Push 5u of chemicals into your host's bloodstream."

	if(!host)
		to_chat(src, SPAN_NOTICE("You are not inside a host body."))
		return
	if(stat)
		to_chat(src, SPAN_NOTICE("You cannot secrete chemicals in your current state."))
		return
	if(chemicals < 20)
		to_chat(src, SPAN_WARNING("You don't have enough chemicals!"))
		return

	var/list/choices = list("Inaprovaline" = /singleton/reagent/inaprovaline, "Bicaridine" = /singleton/reagent/bicaridine, "Kelotane" = /singleton/reagent/kelotane, "Dylovene" = /singleton/reagent/dylovene, "Hyperzine" = /singleton/reagent/hyperzine, "Peridaxon" = /singleton/reagent/peridaxon, "Mortaphenyl" = /singleton/reagent/mortaphenyl, "Neurapan" = /singleton/reagent/mental/neurapan)
	var/chem = tgui_input_list(src, "Select a chemical to secrete.", "Chemicals", choices)

	if(!chem || chemicals < 20 || !host || controlling || !src || stat) //Sanity check.
		return

	to_chat(src, SPAN_NOTICE("You squirt a measure of [chem] from your reservoirs into [host]'s bloodstream."))
	to_chat(host, SPAN_WARNING("You feel cold fluid enter your bloodstream."))
	host.reagents.add_reagent(choices[chem], 5)
	chemicals -= 20

/mob/living/simple_animal/borer/verb/dominate_victim()
	set category = "Abilities"
	set name = "Paralyze Victim"
	set desc = "Freeze the limbs of a potential host with supernatural fear."

	if(world.time - used_dominate < 150)
		to_chat(src, SPAN_NOTICE("You cannot use that ability again so soon."))
		return
	if(host)
		to_chat(src, SPAN_NOTICE("You cannot do that from within a host body."))
		return
	if(src.stat)
		to_chat(src, SPAN_NOTICE("You cannot do that in your current state."))
		return

	var/list/choices = list()
	for(var/mob/living/carbon/C in view(3,src))
		if(C.stat != 2)
			choices += C

	var/mob/living/carbon/M = tgui_input_list(src, "Who do you wish to dominate?", "Paralyze Victim", choices)
	if(M)
		do_paralyze(M)

/mob/living/simple_animal/borer/proc/do_paralyze(var/mob/living/carbon/M)
	if(world.time - used_dominate < 150)
		to_chat(src, SPAN_NOTICE("You cannot use that ability again so soon."))
		return
	if(!M || !src)
		return
	if(M.isSynthetic())
		to_chat(src, SPAN_WARNING("You can't affect synthetics."))
		return
	if(M.has_brain_worms())
		to_chat(src, SPAN_WARNING("You cannot infest someone who is already infested!"))
		return

	for (var/obj/item/implant/mindshield/I in M)
		if (I.implanted)
			to_chat(src, SPAN_WARNING("\The [host]'s mind is shielded against your powers."))
			return

	to_chat(src, SPAN_WARNING("You focus your psionic lance on [M] and freeze their limbs with a wave of terrible dread."))
	to_chat(M, SPAN_WARNING("You feel a creeping, horrible sense of dread come over you, freezing your limbs and setting your heart racing."))
	M.Weaken(10)

	used_dominate = world.time

/mob/living/simple_animal/borer/verb/bond_brain()
	set category = "Abilities"
	set name = "Assume Control"
	set desc = "Fully connect to the brain of your host."

	if(!host)
		to_chat(src, SPAN_NOTICE("You are not inside a host body."))
		return
	if(src.stat)
		to_chat(src, SPAN_NOTICE("You cannot do that in your current state."))
		return

	for (var/obj/item/implant/mindshield/I in host)
		if (I.implanted)
			to_chat(src, SPAN_WARNING("\The [host]'s mind is shielded against your powers."))
			return

	var/takeover_time = 10 SECONDS + (host.getBrainLoss() * 5)
	if(!start_ability(host, takeover_time))
		to_chat(src, SPAN_WARNING("You're busy doing something else, complete that task first."))
		return

	to_chat(src, SPAN_WARNING("You begin delicately adjusting your connection to the host brain..."))
	to_chat(host, SPAN_WARNING("You feel a tingling sensation at the back of your head."))

	addtimer(CALLBACK(src, PROC_REF(host_takeover)), takeover_time)

/mob/living/simple_animal/borer/proc/host_takeover()
	if(!host || !src || controlling)
		return

	to_chat(src, SPAN_DANGER("You plunge your probosci deep into the cortex of the host brain, interfacing directly with their nervous system."))
	to_chat(host, SPAN_DANGER("You feel a strange shifting sensation behind your eyes as an alien consciousness displaces yours."))
	host.add_language(LANGUAGE_BORER)
	host.add_language(LANGUAGE_BORER_HIVEMIND)

	// host -> brain
	var/h2b_id = host.computer_id
	var/h2b_ip= host.lastKnownIP
	host.computer_id = null
	host.lastKnownIP = null

	qdel(host_brain)
	host_brain = new(src)

	host_brain.ckey = host.ckey
	host_brain.name = host.real_name
	host_brain.real_name = "[host_brain.name] (captive host)"

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

	controlling = TRUE

	add_verb(host, /mob/living/carbon/proc/release_control)
	add_verb(host, /mob/living/carbon/proc/punish_host)
	add_verb(host, /mob/living/carbon/proc/spawn_larvae)

/mob/living/carbon/human/proc/jumpstart()
	set category = "Abilities"
	set name = "Revive Host"
	set desc = "Muster all psionic energies to pulse through a dead host, restoring them to a prime state."

	if(stat != DEAD)
		to_chat(usr, SPAN_WARNING("Your host is already alive."))
		return

	remove_verb(src, /mob/living/carbon/human/proc/jumpstart)
	visible_message(SPAN_WARNING("With a hideous, rattling moan, [src] shudders back to life!"))

	rejuvenate()
	fixblood()
	update_canmove()

//Brain slug proc for voluntary removal of control.
/mob/living/carbon/proc/release_control()
	set category = "Abilities"
	set name = "Release Control"
	set desc = "Release control of your host's body."

	var/mob/living/simple_animal/borer/B = has_brain_worms()

	if(B?.host_brain)
		to_chat(src, SPAN_WARNING("You withdraw your probosci, releasing control of [B.host_brain]."))

		B.detach()

		remove_verb(src, /mob/living/carbon/proc/release_control)
		remove_verb(src, /mob/living/carbon/proc/punish_host)
		remove_verb(src,  /mob/living/carbon/proc/spawn_larvae)

	else
		to_chat(src, SPAN_DANGER("Something has gone terribly wrong, as your host's brain does not seem to contain you. Make a GitHub report and ahelp to get out."))

//Brain slug proc for tormenting the host.
/mob/living/carbon/proc/punish_host()
	set category = "Abilities"
	set name = "Torment host"
	set desc = "Punish your host with agony."

	var/mob/living/simple_animal/borer/B = has_brain_worms()

	if(!B)
		return

	if(B.host_brain.ckey)
		to_chat(src, SPAN_WARNING("You send a punishing spike of psionic agony lancing into your host's brain."))

		if(!can_feel_pain())
			to_chat(B.host_brain, SPAN_WARNING("You feel a strange sensation as a foreign influence prods your mind."))
			to_chat(src, SPAN_WARNING("It doesn't seem to be as effective as you hoped."))
		else
			to_chat(B.host_brain, SPAN_DANGER("<FONT size=3>Horrific, burning agony lances through you, ripping a soundless scream from your trapped mind!</FONT>"))

/mob/living/carbon/proc/spawn_larvae()
	set category = "Abilities"
	set name = "Reproduce (100)"
	set desc = "Spawn several young."

	var/mob/living/simple_animal/borer/B = has_brain_worms()

	if(!B)
		return

	if(B.chemicals >= 100)
		to_chat(src, SPAN_WARNING("Your host twitches and quivers as you rapidly excrete a larva from your sluglike body."))
		visible_message(SPAN_WARNING("[src] heaves violently, expelling a rush of vomit and a wriggling, sluglike creature!"))
		B.chemicals -= 100
		B.has_reproduced = TRUE

		new /obj/effect/decal/cleanable/vomit(get_turf(src))
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		new /mob/living/simple_animal/borer(get_turf(src))

	else
		to_chat(src, SPAN_NOTICE("You do not have enough chemicals stored to reproduce."))
		return

/mob/living/simple_animal/borer/verb/awaken_psionics()
	set category = "Abilities"
	set name = "Awaken Host Psionics (150)"
	set desc = "Probe into your host and unlock their psionic potential. Note, it will give them a seizure as their brain realizes its potential."

	if(!host)
		to_chat(src, SPAN_WARNING("You are not inside a host body."))
		return
	if(stat)
		to_chat(src, SPAN_WARNING("You cannot do that in your current state."))
		return
	if(chemicals < 150)
		to_chat(src, SPAN_WARNING("You don't have enough chemicals!"))
		return
	if(host.species.psi_deaf)
		to_chat(src, SPAN_WARNING("\The [host] lacks a zona bovinae to psionically enlighten! How disturbing..."))
	if(host.psi)
		to_chat(src, SPAN_WARNING("Your host is already psionically active!"))
		return

	for (var/obj/item/implant/mindshield/I in host)
		if (I.implanted)
			to_chat(src, SPAN_WARNING("\The [host]'s mind is shielded against your powers."))
			return

	var/jumpstart_time = 15 SECONDS
	if(!start_ability(host, jumpstart_time))
		to_chat(src, SPAN_WARNING("You're busy doing something else, complete that task first."))
		return

	chemicals -= 150
	to_chat(src, SPAN_NOTICE("You probe your tendrils deep within your host's zona bovinae, seeking to unleash their potential."))
	to_chat(host, SPAN_DANGER("You feel some tendrils probe at the back of your head..."))
	to_chat(host, FONT_LARGE(SPAN_WARNING("You feel something terrible coming on...")))

	addtimer(CALLBACK(src, PROC_REF(jumpstart_psi)), jumpstart_time)

/mob/living/simple_animal/borer/proc/jumpstart_psi()
	if(!host)
		return

	to_chat(src, SPAN_NOTICE("You succeed in interfacing with the host's zona bovinae, this will be a painful process for them."))
	host.psi = new(host)
	host.add_language(LANGUAGE_TCB) // if we don't have TCB, give them TCB | this allows monkey borers to RP
	host.awaken_psi_basic("something in your head")
	addtimer(CALLBACK(src, PROC_REF(set_starting_psi_points)), 4.7 SECONDS)

/mob/living/simple_animal/borer/proc/set_starting_psi_points()
	host.psi.psi_points = 3// You don't get a lot at the start.
	host.psi.last_psionic_rank = host.psi.psionic_rank

/mob/living/simple_animal/borer/verb/advance_psionics()
	set category = "Abilities"
	set name = "Advance Psionics (75)"
	set desc = "Advance your host's psionic capability by one step."

	if(!host)
		to_chat(src, SPAN_NOTICE("You are not inside a host body."))
		return
	if(!host.psi)
		to_chat(src, SPAN_WARNING("Your host has not been psionically awakened!"))
		return
	if(stat)
		to_chat(src, SPAN_NOTICE("You cannot do that in your current state."))
		return
	if(chemicals < 75)
		to_chat(src, SPAN_WARNING("You don't have enough chemicals!"))
		return

	for (var/obj/item/implant/mindshield/I in host)
		if (I.implanted)
			to_chat(src, SPAN_WARNING("\The [host]'s mind is shielded against your powers."))
			return

	var/upgrade_time = 10 SECONDS
	if(!start_ability(host, upgrade_time))
		to_chat(src, SPAN_WARNING("You're busy doing something else, complete that task first."))
		return

	chemicals -= 75
	to_chat(src, SPAN_NOTICE("You probe your tendrils deep within your host's zona bovinae, seeking to upgrade their abilities."))
	to_chat(host, SPAN_WARNING("You feel a burning, tingling sensation at the back of your head..."))

	addtimer(CALLBACK(src, PROC_REF(upgrade_rank)), upgrade_time)

/mob/living/simple_animal/borer/proc/upgrade_rank()
	if(!host)
		return

	host.psi.psi_points++
	to_chat(src, SPAN_NOTICE("You successfully manage to expand your living host's control over their Zona Bovinae. They know have an extra psionic point to spend."))
	to_chat(host, SPAN_GOOD("A breeze of fresh air washes over your mind, you feel powerful!"))
	to_chat(host, SPAN_NOTICE("Your control over the Nlom has expanded. You now have an extra psionic point to spend in the Point Shop."))

/mob/living/simple_animal/borer/verb/host_health_scan()
	set category = "Abilities"
	set name = "Inspect Host Health"
	set desc = "Survey your host for injuries, allowing you to better treat them."

	if(!host)
		to_chat(src, SPAN_WARNING("You have no host to scan."))
		return
	if(stat)
		to_chat(src, SPAN_WARNING("You cannot do that in your current state."))
		return

	health_scan_mob(host, src, TRUE, TRUE)
