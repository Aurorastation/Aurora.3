
/// Base reinforced floor.
/turf/simulated/floor/reinforced
	name = "reinforced floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "reinforced"
	initial_flooring = /singleton/flooring/reinforced
	footstep_sound = /singleton/sound_category/plating_footstep
	tile_outline = "reinforced"
	tile_decal_state = "reinforced_light"

/// Reinforced floor variants for different atmos conditions.
/turf/simulated/floor/reinforced/cooled
	name = "cooled reinforced floor"
	temperature = 278

/turf/simulated/floor/reinforced/airless
	initial_gas = null
	temperature = TCMB
	roof_type = null

/// One atmosphere of nitrogen.
/turf/simulated/floor/reinforced/reactor
	name = "reinforced reactor floor"
	initial_gas = list("nitrogen" = MOLES_CELLSTANDARD)

/**
 * These turfs are used for generic atmospherics tanks located on offsites, if any.
 * The Horizon uses its own unique children turfs, so that gas supply can be changed ONLY on the Horizon via defines, rather than needing to keep editing the map.
 * In the future, this can likely be supplanted and/or fully-replaced by persistence system mechanics.
 */

/// Air mix
/turf/simulated/floor/reinforced/airmix
	initial_gas = list("oxygen" = MOLES_O2ATMOS, "nitrogen" = MOLES_N2ATMOS)
// Identical duplicate for consistency's sake. Stop people asking 'wElL wHy ArE aIrTaNk TuRfS oN tHe HoRiZoN nOt HoRiZoN-sPeCiFiC???'
/turf/simulated/floor/reinforced/airmix/horizon

/// Nitrogen
/turf/simulated/floor/reinforced/nitrogen
	initial_gas = list("nitrogen" = ATMOSTANK_NITROGEN)
/turf/simulated/floor/reinforced/nitrogen/horizon
	initial_gas = list("nitrogen" = ATMOSTANK_NITROGEN_HORIZON)

/// Nitrogen
/turf/simulated/floor/reinforced/oxygen
	initial_gas = list("oxygen" = ATMOSTANK_OXYGEN)
/turf/simulated/floor/reinforced/oxygen/horizon
	initial_gas = list("oxygen" = ATMOSTANK_OXYGEN_HORIZON)

/// Nitrogen
/turf/simulated/floor/reinforced/phoron
	initial_gas = list("phoron" = ATMOSTANK_PHORON)
/turf/simulated/floor/reinforced/phoron/scarce
	initial_gas = list("phoron" = ATMOSTANK_PHORON_SCARCE)
/turf/simulated/floor/reinforced/phoron/horizon
	initial_gas = list("phoron" = ATMOSTANK_PHORON_HORIZON)

/// Nitrogen
/turf/simulated/floor/reinforced/carbon_dioxide
	initial_gas = list("carbon_dioxide" = ATMOSTANK_CO2)
/turf/simulated/floor/reinforced/carbon_dioxide/horizon
	initial_gas = list("carbon_dioxide" = ATMOSTANK_CO2_HORIZON)

/// Nitrous Oxide
/turf/simulated/floor/reinforced/n20
	initial_gas = list("sleeping_agent" = ATMOSTANK_NITROUSOXIDE)
/turf/simulated/floor/reinforced/n20/horizon
	initial_gas = list("sleeping_agent" = ATMOSTANK_NITROUSOXIDE_HORIZON)

/// Hydrogen
/turf/simulated/floor/reinforced/hydrogen
	initial_gas = list("hydrogen" = ATMOSTANK_HYDROGEN)
/turf/simulated/floor/reinforced/hydrogen/horizon
	initial_gas = list("hydrogen" = ATMOSTANK_HYDROGEN_HORIZON)

/// Large reinforced floor
/turf/simulated/floor/reinforced/large
	name = "reinforced floor"
	icon_state = "reinforced_large"
	initial_flooring = /singleton/flooring/reinforced
	tile_outline = "reinforced_large"
	tile_decal_state = "reinforced_large_light"

/// Large reinforced floor variants for different atmos conditions.
/turf/simulated/floor/reinforced/large/airless
	initial_gas = null
	temperature = TCMB
	roof_type = null
