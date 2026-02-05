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

	/// Light level of exoplanet turfs if they're generated on this away site.
	/// Only outside turfs get light, based on the `is_outside` var on areas.
	/// If list, picks one from the list.
	/// If zero, ignored, no light.
	var/exoplanet_lightlevel = 0
	/// Light color of exoplanet turfs if they're generated on this away site.
	/// If list, picks one from the list.
	/// Used only if lightlevel is set to non-zero value.
	var/exoplanet_lightcolor = COLOR_WHITE

	/// The atmosphere that exoplanet turfs should spawn with.
	/// If null, ignored, and turfs keep their default or mapped in atmosphere.
	/// If set, this atmosphere is used.
	/// Should be set to a `/datum/gas_mixture` path.
	var/datum/gas_mixture/exoplanet_atmosphere

	/// If set, one of these atmospheres is picked and put in the `exoplanet_atmosphere` var.
	/// Should be set to a list of `/datum/gas_mixture` paths.
	var/list/datum/gas_mixture/exoplanet_atmospheres

/datum/map_template/ruin/away_site/New(var/list/paths = null, rename = null)

	//Apply the subfolder that all ruins are in, as the prefix will get overwritten
	prefix = "maps/away/[prefix]"

	// Randomisation
	if(islist(exoplanet_lightlevel))
		exoplanet_lightlevel = pick(exoplanet_lightlevel)
	if(islist(exoplanet_lightcolor))
		exoplanet_lightcolor = pick(exoplanet_lightcolor)
	if(islist(exoplanet_atmospheres) && !isemptylist(exoplanet_atmospheres))
		exoplanet_atmosphere = pick(exoplanet_atmospheres)

	// Instantiate the theme and atmos, if set
	if(exoplanet_theme_base)
		exoplanet_theme_base = new exoplanet_theme_base()
	if(exoplanet_atmosphere)
		exoplanet_atmosphere = new exoplanet_atmosphere()

	..()

/datum/map_template/ruin/away_site/post_exoplanet_generation(bounds)
	// do away site exoplanet generation, if needed
	if(length(exoplanet_themes))
		for(var/z_index in bounds[MAP_MINZ] to bounds[MAP_MAXZ])
			for(var/marker_turf_type in exoplanet_themes)
				var/datum/exoplanet_theme/exoplanet_theme_type = exoplanet_themes[marker_turf_type]
				var/datum/exoplanet_theme/exoplanet_theme = new exoplanet_theme_type()
				exoplanet_theme.generate_map(z_index, bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MAXX], bounds[MAP_MAXY], marker_turf_type)
