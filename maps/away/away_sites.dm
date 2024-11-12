// Hey! Listen! Update \config\away_site_blacklist.txt with your new ruins!

ABSTRACT_TYPE(/datum/map_template/ruin/away_site)
	prefix = "maps/away/"

	/// If null, ignored, and exoplanet generation is not used.
	/// If set, this var is not used for exoplanet generation, but may be used still,
	/// like to get the correct turf color after destroying a rock wall.
	/// Instantiated on init.
	var/datum/exoplanet_theme/exoplanet_theme_base = null

	/// If null, ignored, and exoplanet generation is not used.
	/// If set, away site spawning includes partial exoplanet generation.
	/// Should be assoc map of `/turf/unsimulated/marker/...` path to `/datum/exoplanet_theme/...` path,
	/// where exoplanet generation with the map value is applied only on marker turfs of the applicable map key.
	var/list/exoplanet_themes = null

	/// Light level of exoplanet turfs if they're generated on this away site. See code\modules\overmap\exoplanets\decor\_turfs.dm:36
	var/lightlevel = 0
	/// Light color of exoplanet turfs if they're generated on this away site. See code\modules\overmap\exoplanets\decor\_turfs.dm:36
	var/lightcolor = COLOR_WHITE
	/// The atmosphere that exoplanet turfs should spawn with.
	var/datum/gas_mixture/exoplanet_atmosphere

/datum/map_template/ruin/away_site/New(var/list/paths = null, rename = null)

	//Apply the subfolder that all ruins are in, as the prefix will get overwritten
	prefix = "maps/away/[prefix]"

	// Instantiate the theme
	if(exoplanet_theme_base)
		exoplanet_theme_base = new exoplanet_theme_base()

	..()

/datum/map_template/ruin/away_site/post_exoplanet_generation(bounds)
	// do away site exoplanet generation, if needed
	if(length(exoplanet_themes))
		for(var/z_index in bounds[MAP_MINZ] to bounds[MAP_MAXZ])
			for(var/marker_turf_type in exoplanet_themes)
				var/datum/exoplanet_theme/exoplanet_theme_type = exoplanet_themes[marker_turf_type]
				var/datum/exoplanet_theme/exoplanet_theme = new exoplanet_theme_type()
				exoplanet_theme.generate_map(z_index, bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MAXX], bounds[MAP_MAXY], marker_turf_type)
