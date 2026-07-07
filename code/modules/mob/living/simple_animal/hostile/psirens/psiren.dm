/// Psiren "Lasher"
/mob/living/simple_animal/hostile/psiren
	name = "Psiren"
	desc = "A strange, squid-like xenofauna. Its eye is full of malevolence."
	icon = 'icons/mob/npc/psirens.dmi'
	icon_state = "psiren_lasher"
	icon_living = "psiren_lasher"
	icon_dead = "psiren_lasher_dead"
	blood_type = COLOR_AMBER
	blood_overlay_icon = 'icons/mob/npc/blood_overlay.dmi'
	health = 65
	maxhealth = 65
	melee_damage_lower = 10
	melee_damage_upper = 10
	armor_penetration = 40
	attack_flags = DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE|DAMAGE_FLAG_PSIONIC
	destroy_surroundings = FALSE
	break_stuff_probability = 0
	attacktext = "lashes"
	attack_sound = 'sound/effects/creatures/vannatusk_attack.ogg'
	organ_names = list("head", "eye", "beak", "tentacles")
	faction = "psiren"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	speed = 4
	tameable = FALSE
	flying = TRUE
	pass_flags = PASSTABLE|PASSRAILING
	emote_hear = list("emits a rhythmic ping")
	emote_sounds = list(
		'sound/effects/creatures/vannatusk_sound.ogg',
		'sound/effects/creatures/vannatusk_sound_2.ogg',
	)
	speak_chance = 5
	attack_emote = "menaces"
	psi_pingable = TRUE
	meat_amount = 1
	meat_type = /obj/item/reagent_containers/food/snacks/squidmeat/psiren_tentacle_meat
	butchering_products = list(/obj/item/reagent_containers/food/snacks/fish/psiren_body_meat = 1)

	attack_vis_effect = ATTACK_EFFECT_DISARM
	smart_melee = TRUE
	smart_ranged = FALSE

	var/list/cursed_messages = list("DRINK DEEPLY OF THE FINAL NIGHT.",
		"YOUR LOVED ONES WILL NEVER KNOW OF YOUR JOY AGAIN.",
		"LEAVE THIS PLACE THROUGH THE NEAREST AIRLOCK.",
		"DEATH IS BUT THE FIRST DANCE IN ETERNITY.",
		"YOU DESERVE ALL OF YOUR SUFFERING.",
		"THE STARS HAVE FORGOTTEN YOUR NAME.",
		"YOUR BONES REMEMBER CRIMES YOU NEVER COMMITTED.",
		"EVERY GOD YOU HAVE EVER PRAYED TO IS DEAD.",
		"THE UNIVERSE REGRETS YOUR CREATION.",
		"YOU HAVE ALREADY FAILED.",
		"YOU WILL NEVER WAKE UP FROM THIS.",
		"YOUR SCREAMS ARRIVE BEFORE YOU MAKE THEM.",
		"YOU WERE WARNED.",
		"THE RIVERS RUN COLD WITH MEMORY.",
		"THE LEMURIAN SEA HUNGERS.",
		"THE LEMURIAN SEA HAS BECOME YOUR TOMB.",
		"THERE IS A DRUMBEAT BELOW REALITY.",
		"THE SUNSET LASTS FOREVER HERE.",
		"YOU CANNOT HIDE INSIDE YOUR OWN HEAD.",
		"I KNOW WHAT YOU DREAM ABOUT.",
		"I AM WEARING YOUR VOICE.",
		"YOU INVITED ME IN",
		"THE SCC SENT YOU HERE AS A FEAST FOR GIBBERING MOUTHS. YOUR LEADERS SENT YOU HERE TO DIE.",
		"YOUR MEMORY FURNISHES A REPAST FOR THE MATRIARCH.",
		"THE NIGHT SHEDS A TEAR TO TELL YOU OF FEAR, OF SORROW, OF PAIN.",
		"THE SCC HAS ALREADY VOIDED YOUR CONTRACT, THEY KNEW YOU WOULD DIE HERE.",
		"I SAW YOU WHEN YOU THOUGHT YOU WERE ALONE.",
		"THE BLOOD WILL NEVER WASH FROM YOUR HANDS.",
		"YOU ARE GUILTY OF YOUR FOREFATHERS SINS.",
		"YOUR MISSION FAILED BEFORE IT BEGAN, THE PHORON YOU SEEK WAS NEVER REAL. YOUR NATION WILL DROWN FOR ITS WANT. IT'S ALL YOUR FAULT.")

/mob/living/simple_animal/hostile/psiren/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	// If the victim has any psi-protection, we give them a completely normal examine proc.
	if (stat == DEAD || user.is_psi_blocked(src, FALSE))
		return ..()

	// Otherwise HIJACK IT.
	return list(FONT_HUGE(SPAN_CULT(pick(cursed_messages))))

/datum/moodlet/psiren_psi_damage
	// Descriptor and Initial logic is bespoke for this moodlet.
	moodlet_descriptor = "residual psionic pressure."
	initial_descriptor = null
	duration = 15.0 MINUTES
	var/list/cursed_messages = list("DRINK DEEPLY OF THE FINAL NIGHT.",
		"YOUR LOVED ONES WILL NEVER KNOW OF YOUR JOY AGAIN.",
		"LEAVE THIS PLACE THROUGH THE NEAREST AIRLOCK.",
		"DEATH IS BUT THE FIRST DANCE IN ETERNITY.",
		"YOU DESERVE ALL OF YOUR SUFFERING.",
		"THE STARS HAVE FORGOTTEN YOUR NAME.",
		"YOUR BONES REMEMBER CRIMES YOU NEVER COMMITTED.",
		"EVERY GOD YOU HAVE EVER PRAYED TO IS DEAD.",
		"THE UNIVERSE REGRETS YOUR CREATION.",
		"YOU HAVE ALREADY FAILED.",
		"YOU WILL NEVER WAKE UP FROM THIS.",
		"YOUR SCREAMS ARRIVE BEFORE YOU MAKE THEM.",
		"YOU WERE WARNED.",
		"THE RIVERS RUN COLD WITH MEMORY.",
		"THE LEMURIAN SEA HUNGERS.",
		"THE LEMURIAN SEA HAS BECOME YOUR TOMB.",
		"THERE IS A DRUMBEAT BELOW REALITY.",
		"THE SUNSET LASTS FOREVER HERE.",
		"YOU CANNOT HIDE INSIDE YOUR OWN HEAD.",
		"I KNOW WHAT YOU DREAM ABOUT.",
		"I AM WEARING YOUR VOICE.",
		"YOU INVITED ME IN",
		"THE SCC SENT YOU HERE AS A FEAST FOR GIBBERING MOUTHS. YOUR LEADERS SENT YOU HERE TO DIE.",
		"YOUR MEMORY FURNISHES A REPAST FOR THE MATRIARCH.",
		"THE NIGHT SHEDS A TEAR TO TELL YOU OF FEAR, OF SORROW, OF PAIN.",
		"THE SCC HAS ALREADY VOIDED YOUR CONTRACT, THEY KNEW YOU WOULD DIE HERE.",
		"I SAW YOU WHEN YOU THOUGHT YOU WERE ALONE.",
		"THE BLOOD WILL NEVER WASH FROM YOUR HANDS.",
		"YOU ARE GUILTY OF YOUR FOREFATHERS SINS.",
		"YOUR MISSION FAILED BEFORE IT BEGAN, THE PHORON YOU SEEK WAS NEVER REAL. YOUR NATION WILL DROWN FOR ITS WANT. IT'S ALL YOUR FAULT.")

/datum/moodlet/psiren_psi_damage/get_moodlet_descriptor()
	// This SHOULD exist but I'm doing my due diligence in checking.
	var/mob/grandparent = astype(astype(morale_component?.resolve(), MORALE_COMPONENT)?.parent, /mob)
	if (!grandparent)
		return // No message, nobody to send a message to.

	// Having any psi-protection will let you see the underlying moodlet.
	if (grandparent.is_psi_blocked(null, FALSE))
		return ..()

	var/spooky_message = pick(cursed_messages)
	if (prob(10))
		grandparent.play_screen_text(spooky_message, /atom/movable/screen/text/screen_text/adpi_message, COLOR_PURPLE)

	return FONT_HUGE(SPAN_CULT(spooky_message))

/datum/moodlet/psiren_psi_damage/send_initial_description(datum/owner)
	astype(astype(morale_component?.resolve(), MORALE_COMPONENT)?.parent, /mob)?.play_screen_text(pick(cursed_messages), /atom/movable/screen/text/screen_text/adpi_message, COLOR_PURPLE)
	return

/**
 * Special bullet type used for Psiren Darters
 * Very low damage, but very high penetration. Resisted (or strengthened) by psi-sensitivity.
 */
/obj/projectile/bullet/pistol/psiren
	name = "kinesis bolt"
	damage = 8
	armor_penetration = 40
	sharp = 1
	embed = FALSE
	damage_flags = DAMAGE_FLAG_BULLET | DAMAGE_FLAG_PSIONIC
	muzzle_type = /obj/effect/projectile/muzzle/laser/psiren
	tracer_type = /obj/effect/projectile/tracer/laser/psiren
	impact_type = /obj/effect/projectile/impact/laser/psiren
	icon_state = "purple_laser"

	/// How much damage this attack deals directly to the victim's morale on a successful hit.
	var/psi_damage = -0.1

	/// How much extra psychic damage is dealt per point of psi-sensitivity.
	var/psi_sensitivity_multiplier = -0.05

	/// The chance per successful hit of triggering an ADPI message on the target.
	var/adpi_chance = 0

/obj/projectile/bullet/pistol/psiren/omen
	damage = 3
	armor_penetration = 60
	psi_damage = -5.0
	psi_sensitivity_multiplier = -2.5
	adpi_chance = 5

/**
 * Psiren ranged attacks deal a unique form of "psychic damage" which is governed by the full suite of rules regarding Psionic Sensitivity.
 * This is in addition to their physical "Telekinetic" damage component. Being immune to the psychic damage does not make one immune to the physical damage.
 * One can be immune to the psychic damage for a very large variety of reasons, not all of them static.
 *
 * "Psychic damage" attacks a character's Morale statistic rather than physical health, which inflicts gradually stacking penalties to Skill Tests.
 */
/obj/projectile/bullet/pistol/psiren/on_hit(atom/target, blocked, def_zone)
	. = ..()
	if (. != BULLET_ACT_HIT || !firer)
		return .

	var/mob/living/victim = target
	// Immunity from telepathy will fully negate the psychic damage (but not physical damage) component.
	// This is getting checked before the morale_comp because I want to give Active Psi Protection a chance to give the player feedback that a psychic effect occurred.
	if (!istype(victim) || victim.stat == DEAD || victim.is_psi_blocked(firer, FALSE))
		return .

	// A morale component is also required for psychic damage.
	var/datum/component/morale/morale_comp = victim.GetComponent(MORALE_COMPONENT)
	if (!morale_comp)
		return .

	var/victim_psi_sensitivity = victim.check_psi_sensitivity()
	var/datum/moodlet/psi_damage_moodlet = morale_comp.load_moodlet(/datum/moodlet/psiren_psi_damage, FALSE)
	psi_damage_moodlet.set_moodlet(psi_damage_moodlet.get_morale_modifier() + psi_damage + min(0, (victim_psi_sensitivity * psi_sensitivity_multiplier)))
	psi_damage_moodlet.refresh_moodlet()

	if (!prob(adpi_chance) || !SShallucinations)
		return .
	// At this point in time all checks that would be satisfied by the ADPI subsystem have already been handled,
	// now we just need to fetch a message and send one.
	var/adpi_message = SShallucinations.pick_adpi_message(victim, TRUE)
	if (!adpi_message)
		return .

	SShallucinations.deliver_adpi_message(victim, adpi_message)

/obj/effect/projectile/muzzle/laser/psiren
	icon_state = "muzzle_scc" // I just like the pattern here
	light_color = COLOR_VIOLET

/obj/effect/projectile/tracer/laser/psiren
	icon_state = "beam_scc"
	light_color = COLOR_VIOLET

/obj/effect/projectile/impact/laser/psiren
	icon_state = "impact_scc" // I also just like the pattern here
	light_color = COLOR_VIOLET


/// Psiren "Darter"
/mob/living/simple_animal/hostile/psiren/ranged
	icon_state = "psiren_darter"
	icon_living = "psiren_darter"
	icon_dead = "psiren_darter_dead"
	ranged = TRUE
	projectilesound = 'sound/weapons/wave.ogg'
	projectiletype = /obj/projectile/bullet/pistol/psiren

/datum/effect/effect/system/smoke_spread/psiren
	smoke_type = /obj/effect/smoke/psiren
	smoke_duration = 20 SECONDS

/obj/effect/smoke/psiren
	color = "#21093a"
	time_to_live = 20 SECONDS

/**
 * Psiren "Omen", a support-caster type enemy that primarily inflicts direct psychic damage.
 * Relatively squishy for a medium enemy, they can react exactly once per being shot with a cloud of violet smoke.
 */
/mob/living/simple_animal/hostile/psiren/omen
	icon_state = "psiren_omen"
	icon_living = "psiren_omen"
	icon_dead = "psiren_omen_dead"
	health = 120
	maxhealth = 120
	ranged = TRUE
	projectilesound = 'sound/weapons/wave.ogg'
	projectiletype = /obj/projectile/bullet/pistol/psiren/omen
	var/has_ink = TRUE

/mob/living/simple_animal/hostile/psiren/omen/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	if (has_ink)
		var/datum/effect/effect/system/smoke_spread/psiren/S = new/datum/effect/effect/system/smoke_spread/psiren()
		S.set_up(5, 0, loc, null)
		S.start()
		has_ink = FALSE
	return ..()

/mob/living/simple_animal/hostile/psiren/matriarch
	name = "Matriarch"
	icon = 'icons/mob/npc/psiren_matriarch.dmi'
	icon_state = "psiren_matriarch"
	icon_living = "psiren_matriarch"
	icon_dead = "psiren_matriarch_dead"
	health = 9999
	maxhealth = 9999
	// Speaks via Xenoglossia.
	universal_speak = TRUE
	universal_understand = TRUE
	mob_size = MOB_LARGE
	mob_weight = MOB_WEIGHT_SUPERHEAVY
	melee_damage_lower = 35
	melee_damage_upper = 40
	melee_reach = 2
	armor_penetration = 30
	meat_amount = 5
	meat_type = /obj/item/reagent_containers/food/snacks/squidmeat/psiren_tentacle_meat
	butchering_products = list(/obj/item/reagent_containers/food/snacks/fish/psiren_body_meat = 5)

/mob/living/simple_animal/hostile/psiren/matriarch/Initialize()
	. = ..()
	add_spell(new /spell/targeted/eject_ink_cloud, "const_spell_ready")

/spell/targeted/eject_ink_cloud
	name = "Eject Ink Cloud"
	desc = "Eject a cloud of Lemurian fog."
	feedback = "CEIB"
	range = 0
	spell_flags = INCLUDEUSER
	charge_max = 30 SECONDS
	max_targets = 1

	invocation_type = SpI_EMOTE
	invocation = "ejects a cloud of Lemurian fog."

	hud_state = "cloud"

/spell/targeted/eject_ink_cloud/cast(mob/target, mob/living/user as mob)
	..()
	var/datum/effect/effect/system/smoke_spread/psiren/S = new/datum/effect/effect/system/smoke_spread/psiren()
	S.set_up(15, 0, user.loc, null)
	S.start()
	return TRUE
