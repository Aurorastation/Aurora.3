/singleton/psionic_power
	/// Ability name.
	var/name
	/// Description of what the ability does.
	var/desc
	/// Spell object to spawn. Must be a path.
	var/spell_path
	/// Spell icon state.
	var/icon_state
	/// Ability flags define who can pick an ability - ship characters, adminspawn characters, antags.
	var/ability_flags
	/// Minimum required rank to use an ability.
	var/minimum_rank = PSI_RANK_SENSITIVE
	/// Point shop cost.
	var/point_cost = 1

/// Called when a power is given to a mob.
/singleton/psionic_power/proc/apply(var/mob/living/carbon/human/H)
	if(H.ability_master)
		var/obj/spellbutton/spell = new(H, spell_path, name, icon_state)
		H.ability_master.add_psionic_ability(spell, icon_state, src)
		H.psi.psionic_powers |= type
		return TRUE
	else
		log_debug("Psionic power [src.name] given to mob [H] without ability master!")
		return FALSE

/// A psionic power is made up of two elements: the psionic power singleton (which defines the ability metadata such as its name, description, and cost)
/// and the physical spell object, which defines its behaviour when used. Keep in mind that ALL psionic abilities MUST have the ASPECT_PSIONIC aspect!
