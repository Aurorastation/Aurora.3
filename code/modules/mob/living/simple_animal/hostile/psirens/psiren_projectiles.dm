/**
 * Special bullet type used for Psiren Darters
 * Very low damage, but very high penetration. Resisted (or strengthened) by psi-sensitivity.
 */
/obj/projectile/bullet/pistol/psiren
	name = "kinesis bolt"
	damage = 4
	armor_penetration = 40
	sharp = 1
	embed = FALSE
	damage_flags = DAMAGE_FLAG_BULLET | DAMAGE_FLAG_PSIONIC
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE | PASSRAILING
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

/**
 * Variant psiren bullet type for Omens.
 * Almost no physical damage at all, but very high psychic damage.
 */
/obj/projectile/bullet/pistol/psiren/omen
	damage = 1
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
		return

	try_deal_psychic_damage(target, firer, psi_damage, psi_sensitivity_multiplier, adpi_chance)

/obj/effect/projectile/muzzle/laser/psiren
	icon_state = "muzzle_scc" // I just like the pattern here
	light_color = COLOR_VIOLET

/obj/effect/projectile/tracer/laser/psiren
	icon_state = "beam_scc"
	light_color = COLOR_VIOLET

/obj/effect/projectile/impact/laser/psiren
	icon_state = "impact_scc" // I also just like the pattern here
	light_color = COLOR_VIOLET
