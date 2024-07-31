// Hey! Listen! Update \config\away_site_blacklist.txt with your new ruins!

/datum/map_template/ruin/away_site
	abstract_type = /datum/map_template/ruin/away_site
	prefix = "maps/away/"

	/// If null, ignored, and exoplanet generation is not used.
	/// If set, this var is not used for exoplanet generation, but may be used still,
	/// like to get the correct turf color after destroying a rock wall.
	/// Instantiated on init.
	var/datum/exoplanet_theme/exoplanet_theme_base = null

	/// Analogous to the base exoplanet theme above.
	// var/area/exoplanet_base_area = null

	/// If null, ignored, and exoplanet generation is not used.
	/// If set, away site spawning includes partial exoplanet generation.
	/// Should be assoc map of `/turf/unsimulated/marker/...` path to `/datum/exoplanet_theme/...` path,
	/// where exoplanet generation with the map value is applied only on marker turfs of the applicable map key.
	var/list/exoplanet_themes = null

	///
	var/datum/gas_mixture/exoplanet_atmosphere = null

/datum/map_template/ruin/away_site/New(var/list/paths = null, rename = null)

	//Apply the subfolder that all ruins are in, as the prefix will get overwritten
	prefix = "maps/away/[prefix]"

	// Instantiate the theme and area if set
	if(exoplanet_theme_base)
		exoplanet_theme_base = new exoplanet_theme_base()
		// exoplanet_base_area = new exoplanet_base_area()

	..()
