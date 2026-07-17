/// Psiren "Lasher"
/mob/living/simple_animal/hostile/psiren
	name = "psiren lasher"
	desc = "A strange, squid-like xenofauna. Its eye is full of malevolence."
	icon = 'icons/mob/npc/psirens.dmi'
	icon_state = "psiren_lasher"
	icon_living = "psiren_lasher"
	icon_dead = "psiren_lasher_dead"
	blood_type = COLOR_AMBER
	blood_overlay_icon = 'icons/mob/npc/blood_overlay.dmi'
	health = 65
	maxhealth = 65
	melee_damage_lower = 8
	melee_damage_upper = 8
	armor_penetration = 40
	attack_flags = DAMAGE_FLAG_EDGE|DAMAGE_FLAG_PSIONIC
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
	butchering_products = list(/obj/item/reagent_containers/food/snacks/squidmeat/psiren_body_meat = 1)

	attack_vis_effect = ATTACK_EFFECT_DISARM
	smart_melee = TRUE
	smart_ranged = FALSE

	/// Messages used by the psiren for its psychic damage effects.
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

	/// How much damage the psiren's attacks deal directly to the victim's morale on a successful hit.
	var/psi_damage = -0.1

	/// How much extra psychic damage is dealt per point of psi-sensitivity.
	var/psi_sensitivity_multiplier = -0.05

	/// The chance per successful hit of triggering an ADPI message on the target.
	var/adpi_chance = 5

/**
 * Psirens have a unique ability to telepathically retaliate against anyone who tries to examine them.
 * It only works if the psiren is alive, and the target isn't mindshielded.
 */
/mob/living/simple_animal/hostile/psiren/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	// If the victim has any psi-protection, we give them a completely normal examine proc.
	if (stat == DEAD || user.is_psi_blocked(src, FALSE))
		return ..()

	// Otherwise HIJACK IT.
	return list(FONT_HUGE(SPAN_CULT(pick(cursed_messages))))

/// Protection from the ranged attacks of other psirens.
/mob/living/simple_animal/hostile/psiren/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	var/mob/shooter = astype(hitting_projectile?.firer, /mob)
	if (!shooter || shooter.faction != "psiren")
		return ..()

	return BULLET_ACT_BLOCK

/// Psiren melee attacks deal psychic damage, just like their ranged attacks.
/mob/living/simple_animal/hostile/psiren/on_attack_mob(mob/hit_mob, obj/item/organ/external/limb)
	. = ..()
	try_deal_psychic_damage(hit_mob, src, psi_damage, psi_sensitivity_multiplier, adpi_chance)

/// Psiren "Darter", a simple ranged attacker with weak damage, high penetration, and weak psychic damage.
/mob/living/simple_animal/hostile/psiren/ranged
	name = "psiren darter"
	icon_state = "psiren_darter"
	icon_living = "psiren_darter"
	icon_dead = "psiren_darter_dead"
	ranged = TRUE
	projectilesound = 'sound/weapons/wave.ogg'
	projectiletype = /obj/projectile/bullet/pistol/psiren

/// Smoke effect used for the Omen.
/datum/effect/effect/system/smoke_spread/psiren
	smoke_type = /obj/effect/smoke/psiren
	smoke_duration = 20 SECONDS

/// "Ink Cloud" colored smoke effect.
/obj/effect/smoke/psiren
	color = "#21093a"
	time_to_live = 20 SECONDS
