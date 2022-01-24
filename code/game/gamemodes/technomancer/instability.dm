#define TECHNOMANCER_INSTABILITY_DECAY				0.97	// Multipler for how much instability is lost per Life() tick.
// Numbers closer to 1.0 make instability decay slower.  Instability will never decay if it's at 1.0.
// When set to 0.98, it has a half life of roughly 35 Life() ticks, or 1.1 minutes.
// For 0.97, it has a half life of about 23 ticks, or 46 seconds.
// For 0.96, it is 17 ticks, or 34 seconds.
// 0.95 is 14 ticks.
#define TECHNOMANCER_INSTABILITY_MIN_DECAY			0.1 	// Minimum removed every Life() tick, always.
#define TECHNOMANCER_INSTABILITY_PRECISION			0.1 	// Instability is rounded to this.
#define TECHNOMANCER_INSTABILITY_MIN_GLOW			10		// When above this number, the entity starts glowing, affecting others.


/mob/living
	var/instability = 0
	var/last_instability = 0 // Used to calculate instability delta.
	var/last_instability_event = null // most recent world.time that something bad happened due to instability.

// Proc: adjust_instability()
// Parameters: 0
// Description: Does nothing, because inheritence.
/mob/living/proc/adjust_instability(var/amount)
	instability = between(0, round(instability + amount, TECHNOMANCER_INSTABILITY_PRECISION), 200)

// Proc: adjust_instability()
// Parameters: 1 (amount - how much instability to give)
// Description: Adds or subtracks instability to the mob, then updates the hud.
/mob/living/carbon/human/adjust_instability(var/amount)
	..()
	instability_update_hud()

// Proc: instability_update_hud()
// Parameters: 0
// Description: Sets the HUD icon to the correct state.
/mob/living/carbon/human/proc/instability_update_hud()
	if(client && hud_used)
		switch(instability)
			if(0 to 10)
				instability_display.icon_state = "instability-1"
			if(10 to 30)
				instability_display.icon_state = "instability0"
			if(30 to 50)
				instability_display.icon_state = "instability1"
			if(50 to 100)
				instability_display.icon_state = "instability2"
			if(100 to 200)
				instability_display.icon_state = "instability3"

// Proc: Life()
// Parameters: 0
// Description: Makes instability tick along with Life().
/mob/living/Life()
	. = ..()
	handle_instability()

// Proc: handle_instability()
// Parameters: 0
// Description: Makes instability decay.  instability_effects() handles the bad effects for having instability.  It will also hold back
// from causing bad effects more than one every ten seconds, to prevent sudden death from angry RNG.
/mob/living/proc/handle_instability()
	instability = between(0, round(instability, TECHNOMANCER_INSTABILITY_PRECISION), 200)
	last_instability = instability

	//This should cushon against really bad luck.
	if(instability && last_instability_event < (world.time - 5 SECONDS) && prob(50))
		instability_effects()

	var/instability_decayed = abs( round(instability * TECHNOMANCER_INSTABILITY_DECAY, TECHNOMANCER_INSTABILITY_PRECISION) - instability )
	instability_decayed = max(instability_decayed, TECHNOMANCER_INSTABILITY_MIN_DECAY)

	adjust_instability(-instability_decayed)
	radiate_instability(instability_decayed)

/mob/living/carbon/human/handle_instability()
	..()
	instability_update_hud()

/*
[16:18:08] <PsiOmegaDelta> Sparks
[16:18:10] <PsiOmegaDelta> Wormholes
[16:18:16] <PsiOmegaDelta> Random spells firing off on their own
[16:18:22] <PsiOmegaDelta> The possibilities are endless
[16:19:00] <PsiOmegaDelta> Random objects phasing into reality, only to disappear again
[16:19:05] <PsiOmegaDelta> Things briefly duplicating
[16:20:56] <PsiOmegaDelta> Glass cracking, eventually breaking
*/
// Proc: instability_effects()
// Parameters: 0
// Description: Does a variety of bad effects to the entity holding onto the instability, with more severe effects occuring if they have
// a lot of instability.
/mob/living/proc/instability_effects()
	last_instability_event = world.time
	spawn(1)
		var/image/instability_flash = image('icons/obj/spells.dmi',"instability")
		overlays |= instability_flash
		sleep(4)
		overlays.Remove(instability_flash)
		qdel(instability_flash)

/proc/safe_blink(atom/movable/AM, var/range = 3)
	if(AM.anchored || !AM.loc)
		return
	var/list/targets = list()

	for(var/turf/simulated/T in range(AM, range))
		if(T.density || istype(T, /turf/simulated/mineral)) //Don't blink to vacuum or a wall
			continue
		for(var/atom/movable/stuff in T.contents)
			if(stuff.density)
				continue
		targets.Add(T)

	if(!targets.len)
		return
	var/turf/simulated/destination = null

	destination = pick(targets)

	if(destination)
		if(ismob(AM))
			var/mob/living/L = AM
			if(L.buckled_to)
				L.buckled_to.unbuckle()
		spark(AM, 5, 2)
		AM.forceMove(destination)
		AM.visible_message("<span class='notice'>\The [AM] vanishes!</span>")
		to_chat(AM, "<span class='notice'>You suddenly appear somewhere else!</span>")
	return

/mob/living/silicon/instability_effects()
	if(instability)
		var/rng = 0
		..()
		switch(instability)
			if(1 to 10) //Harmless
				return
			if(11 to 30) //Minor
				rng = rand(0,1)
				switch(rng)
					if(0)
						spark(src, 5, 0)
						visible_message("<span class='warning'>Electrical sparks manifest from nowhere around \the [src]!</span>")
					if(1)
						return

			if(31 to 50) //Moderate
				rng = rand(0,4)
				switch(rng)
					if(0)
						electrocute_act(instability * 0.3, "unstable energies", 0.75)
					if(1)
						adjustFireLoss(instability * 0.15) //7.5 burn @ 50 instability
						to_chat(src, "<span class='danger'>Your chassis alerts you to overheating from an unknown external force!</span>")
					if(2)
						adjustBruteLoss(instability * 0.15) //7.5 brute @ 50 instability
						to_chat(src, "<span class='danger'>Your chassis makes the sound of metal groaning!</span>")
					if(3)
						safe_blink(src, range = 6)
						to_chat(src, "<span class='warning'>You're teleported against your will!</span>")
					if(4)
						emp_act(3)

			if(51 to 100) //Severe
				rng = rand(0,3)
				switch(rng)
					if(0)
						electrocute_act(instability * 0.5, "extremely unstable energies", 0.75)
					if(1)
						emp_act(2)
					if(2)
						adjustFireLoss(instability * 0.3) //30 burn @ 100 instability
						to_chat(src, "<span class='danger'>Your chassis alerts you to extreme overheating from an unknown external force!</span>")
					if(3)
						adjustBruteLoss(instability * 0.3) //30 brute @ 100 instability
						to_chat(src, "<span class='danger'>Your chassis makes the sound of metal groaning and tearing!</span>")

			if(101 to 200) //Lethal
				rng = rand(0,4)
				switch(rng)
					if(0)
						electrocute_act(instability, "extremely unstable energies", 0.75)
					if(1)
						emp_act(1)
					if(2)
						adjustFireLoss(instability * 0.4) //40 burn @ 100 instability
						to_chat(src, "<span class='danger'>Your chassis alerts you to extreme overheating from an unknown external force!</span>")
					if(3)
						adjustBruteLoss(instability * 0.4) //40 brute @ 100 instability
						to_chat(src, "<span class='danger'>Your chassis makes the sound of metal groaning and tearing!</span>")

/mob/living/carbon/human/instability_effects()
	if(instability)
		var/rng = 0
		..()
		switch(instability)
			if(1 to 10) //Harmless
				return
			if(10 to 30) //Minor
				rng = rand(0,1)
				switch(rng)
					if(0)
						spark(src, 5, 0)
						visible_message("<span class='warning'>Electrical sparks manifest from nowhere around \the [src]!</span>")
					if(1)
						return

			if(30 to 50) //Moderate
				rng = rand(0,8)
				switch(rng)
					if(0)
						apply_damage(instability * 0.3, PAIN)
					if(1)
						return
					if(2)
						if(can_feel_pain())
							apply_damage(instability * 0.3, PAIN)
							to_chat(src, "<span class='danger'>You feel a sharp pain!</span>")
					if(3)
						apply_effect(instability * 0.3, EYE_BLUR)
						to_chat(src, "<span class='danger'>Your eyes start to get cloudy!</span>")
					if(4)
						electrocute_act(instability * 0.3, "unstable energies")
					if(5)
						adjustFireLoss(instability * 0.15) //7.5 burn @ 50 instability
						to_chat(src, "<span class='danger'>You feel your skin burn!</span>")
					if(6)
						adjustBruteLoss(instability * 0.15) //7.5 brute @ 50 instability
						to_chat(src, "<span class='danger'>You feel a sharp pain as an unseen force harms your body!</span>")
					if(7)
						adjustToxLoss(instability * 0.15) //7.5 tox @ 50 instability
					if(8)
						safe_blink(src, range = 6)
						to_chat(src, "<span class='warning'>You're teleported against your will!</span>")

			if(50 to 100) //Severe
				rng = rand(0,8)
				switch(rng)
					if(0)
						apply_damage(instability * 0.2, IRRADIATE)
					if(1)
						return
					if(2)
						if(can_feel_pain())
							apply_damage(instability * 0.7, PAIN)
							to_chat(src, "<span class='danger'>You feel an extremely angonizing pain from all over your body!</span>")
					if(3)
						apply_effect(instability * 0.5, EYE_BLUR)
						to_chat(src, "<span class='danger'>Your eyes start to get cloudy!</span>")
					if(4)
						electrocute_act(instability * 0.5, "extremely unstable energies")
					if(5)
						fire_act()
						to_chat(src, "<span class='danger'>You spontaneously combust!</span>")
					if(6)
						adjustCloneLoss(instability * 0.05) //5 cloneloss @ 100 instability
						to_chat(src, "<span class='danger'>You feel your body slowly degenerate.</span>")

			if(100 to 200) //Lethal
				rng = rand(0,7)
				switch(rng)
					if(0)
						apply_effect(instability, IRRADIATE)
					if(1)
						visible_message("<span class='warning'>\The [src] suddenly collapses!</span>",
						"<span class='danger'>You suddenly feel very light-headed, and faint!</span>")
						Paralyse(instability * 0.1)
					if(2)
						if(can_feel_pain())
							apply_damage(instability, PAIN)
							to_chat(src, "<span class='danger'>You feel an extremely angonizing pain from all over your body!</span>")
					if(3)
						apply_effect(instability, EYE_BLUR)
						to_chat(src, "<span class='danger'>Your eyes start to get cloudy!</span>")
					if(4)
						electrocute_act(instability, "extremely unstable energies")
					if(5)
						fire_act()
						to_chat(src, "<span class='danger'>You spontaneously combust!</span>")
					if(6)
						adjustCloneLoss(instability * 0.10) //5 cloneloss @ 100 instability
						to_chat(src, "<span class='danger'>You feel your body slowly degenerate.</span>")

/mob/living/proc/radiate_instability(amount)
	var/distance = round(sqrt(instability / 2))
	if(instability < TECHNOMANCER_INSTABILITY_MIN_GLOW)
		distance = 0
	if(distance)
		for(var/mob/living/L in range(src, distance) )
			if(L == src) // This instability is radiating away from them, so don't include them.
				continue
			var/radius = max(get_dist(L, src), 1)
			// People next to the source take all of the radiated amount.  Further distance decreases the amount absorbed.
			var/outgoing_instability = (amount) * ( 1 / (radius**2) )

			L.receive_radiated_instability(outgoing_instability)

// This should only be used for EXTERNAL sources of instability, such as from someone or something glowing.
/mob/living/proc/receive_radiated_instability(amount)
	// Energy armor like from the AMI RIG can protect from this.
	var/armor_ratio = get_blocked_ratio(BP_CHEST, BURN, damage = 40)
	amount = amount * armor_ratio
	if(amount && prob(10))
		if(isSynthetic())
			to_chat(src, "<span class='cult'><font size='4'>Warning: Anomalous field detected.</font></span>")
		else
			to_chat(src, "<span class='cult'><font size='4'>The purple glow makes you feel strange...</font></span>")
	adjust_instability(amount)

