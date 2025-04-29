// These defines are bitflags because it should be technically possible to have a power supply do multiple things at once if you wish.
// Just be wary of balancing issues.

/// The default functioning of a power reactor. Externally powered only. Allows recharging from APCs. Has a multiplier for faster recharging from power stations.
#define POWER_SUPPLY_ELECTRIC 1
/// Recharges by walking/running. Far slower at charging from external sources.
#define POWER_SUPPLY_KINETIC 2
/// Recharges through consuming nutrients/food. Slower at recharging from external sources.
#define POWER_SUPPLY_ORGANIC 4
/// Recharges from external lighting. Slower at recharging from external sources.
#define POWER_SUPPLY_SOLAR 8

/obj/item/organ/internal/machine/reactor
	name = "electrical power supply unit"
	desc = "An electrical power supply system for a synthetic. It feeds from external sources."
	organ_tag = BP_REACTOR
	parent_organ = BP_CHEST
	possible_modifications = list(
		"Electric",
		"Kinetic",
		"Biological",
		"Solar"
	)
	organ_presets = list(
		ORGAN_PREF_ELECTRICPOWER = /singleton/synthetic_organ_preset/reactor/electric,
		ORGAN_PREF_KINETICPOWER = /singleton/synthetic_organ_preset/reactor/kinetic,
		ORGAN_PREF_BIOPOWER = /singleton/synthetic_organ_preset/reactor/biological,
		ORGAN_PREF_SOLARPOWER = /singleton/synthetic_organ_preset/reactor/solar,
	)
	default_preset = ORGAN_PREF_ELECTRICPOWER

	/// What kind of power supply this is. Bitfield.
	var/power_supply_type = POWER_SUPPLY_ELECTRIC
	/// Base power generation for active power supplies.
	var/base_power_generation = 0
