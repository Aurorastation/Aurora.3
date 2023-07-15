/decl/psionic_power
	/// Ability name.
	var/name
	/// Description of what the ability does.
	var/desc
	/// Spell object to spawn.
	var/obj/item/spell/spell_to_spawn
	/// Ability flags define who can pick an ability - ship characters, adminspawn characters, antags.
	var/ability_flags
	/// Minimum required rank to use an ability.
	var/minimum_rank = PSI_RANK_SENSITIVE
	/// Point shop cost.
	var/point_cost = 1
