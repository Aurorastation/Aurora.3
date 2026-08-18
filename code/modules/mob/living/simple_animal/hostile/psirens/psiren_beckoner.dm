/**
 * A larger and older variant of an Omen. The Beckoner is a tanky medium support enemy.
 * They share their attack and defense pattern with the Omen.
 * But also gain a periodic psychic damage aura.
 */
/mob/living/simple_animal/hostile/psiren/omen/beckoner
	name = "psiren beckoner"
	icon = 'icons/mob/npc/psiren_beckoner.dmi'
	icon_state = "psiren_beckoner"
	icon_living = "psiren_beckoner"
	icon_dead = "psiren_beckoner_dead"
	health = 300
	maxhealth = 300
	ranged = TRUE
	projectilesound = 'sound/weapons/wave.ogg'
	projectiletype = /obj/projectile/bullet/pistol/psiren/omen
	psi_damage = -5.0
	psi_sensitivity_multiplier = -2.5
	adpi_chance = 20
	cursed_messages = list(
		"Please help me, I'm trapped outside the airlocks!",
		"You feel drawn toward the nearest airlock.",
		"Fresh air... no, vacuum... feels right somehow.",
		"The void feels strangely comforting.",
		"Please come save me, I'm in a lifepod just outside!",
		"The ship feels unbearably cramped.",
		"You need fresh air, go for a walk outside.",
		"You don't need a space suit.",
		"Did someone just knock on the hull?",
		"I left something outside. I should go get it.",
		"Come outside.",
		"The nearest airlock suddenly seems very important.",
		"Someone is calling for help outside!")

	/// Next scheduled time to fire a "beckon" pulse.
	var/next_aura_pulse

	/// Minimum time between beckoning pulses.
	var/min_pulse_time = 3 MINUTES

	/// Maximum time between beckoning pulses.
	var/max_pulse_time = 9 MINUTES

	/// Maximum radial distance at which the Omen can hit a target with a psi damage pulse.
	var/pulse_range_meters = 50 // Meters

	/// Base psi-damage dealt per pulse. This falls off with radial distance.
	var/aura_psi_damage = -2.5

/mob/living/simple_animal/hostile/psiren/omen/beckoner/Initialize()
	. = ..()
	next_aura_pulse = REALTIMEOFDAY + rand(min_pulse_time, max_pulse_time)
	hunting_pulse()

/mob/living/simple_animal/hostile/psiren/omen/beckoner/Life(seconds_per_tick, times_fired)
	. = ..()
	if (stat == DEAD || next_aura_pulse > REALTIMEOFDAY)
		return

	next_aura_pulse = REALTIMEOFDAY + rand(min_pulse_time, max_pulse_time)
	hunting_pulse()

/mob/living/simple_animal/hostile/psiren/omen/beckoner/proc/hunting_pulse()
	// TODO: Really should port tg's handling of per-z-level mob lists.
	for (var/mob/player as anything in GLOB.player_list)
		if (!player || z != player.z || player.stat == DEAD)
			continue

		var/dx = player.x - x
		var/dy = player.y - y
		var/r = sqrt((dx * dx) + (dy * dy))
		if (r > pulse_range_meters)
			continue

		try_deal_psychic_damage(player,
			src,
			r <= 1 ? aura_psi_damage : aura_psi_damage / r,
			r <= 1 ? psi_sensitivity_multiplier : psi_sensitivity_multiplier / r,
			100,
			/datum/moodlet/psiren_psi_damage/beckoner,
			pick(cursed_messages))
