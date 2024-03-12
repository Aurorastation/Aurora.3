
// ------------------------------- reinforced base

/turf/simulated/floor/reinforced
	name = "reinforced floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "reinforced"
	initial_flooring = /singleton/flooring/reinforced
	footstep_sound = /singleton/sound_category/plating_footstep
	tile_outline = "reinforced"
	tile_decal_state = "reinforced_light"

// ------------------------------- reinforced atmos variants

/turf/simulated/floor/reinforced/cooled
	name = "cooled reinforced floor"
	temperature = 278

/turf/simulated/floor/reinforced/airless
	initial_gas = null
	temperature = TCMB
	roof_type = null

/turf/simulated/floor/reinforced/airmix
	initial_gas = list("oxygen" = MOLES_O2ATMOS, "nitrogen" = MOLES_N2ATMOS)

/turf/simulated/floor/reinforced/nitrogen
	initial_gas = list("nitrogen" = ATMOSTANK_NITROGEN)

/turf/simulated/floor/reinforced/reactor
	name = "reinforced reactor floor"
	initial_gas = list("nitrogen" = MOLES_CELLSTANDARD) // One atmosphere of nitrogen.

/turf/simulated/floor/reinforced/oxygen
	initial_gas = list("oxygen" = ATMOSTANK_OXYGEN)

/turf/simulated/floor/reinforced/phoron
	initial_gas = list("phoron" = ATMOSTANK_PHORON)

/turf/simulated/floor/reinforced/phoron/scarce
	initial_gas = list("phoron" = ATMOSTANK_PHORON_SCARCE)

/turf/simulated/floor/reinforced/carbon_dioxide
	initial_gas = list("carbon_dioxide" = ATMOSTANK_CO2)

/turf/simulated/floor/reinforced/n20
	initial_gas = list("sleeping_agent" = ATMOSTANK_NITROUSOXIDE)

/turf/simulated/floor/reinforced/hydrogen
	initial_gas = list("hydrogen" = ATMOSTANK_HYDROGEN)

// ------------------------------- reinforced large

/turf/simulated/floor/reinforced/large
	name = "reinforced floor"
	icon_state = "reinforced_large"
	initial_flooring = /singleton/flooring/reinforced
	tile_outline = "reinforced_large"
	tile_decal_state = "reinforced_large_light"

// ------------------------------- reinforced atmos variants

/turf/simulated/floor/reinforced/large/airless
	initial_gas = null
	temperature = TCMB
	roof_type = null

// -------------------------------
