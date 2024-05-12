// Hey! Listen! Update \config\away_site_blacklist.txt with your new ruins!

/datum/map_template/ruin/away_site
	var/list/generate_mining_by_z
	prefix = "maps/away/"

	/// If set, away site spawning includes partial exoplanet generation,
	/// where noop (?) turfs are replaced as if generated on a exoplanet.
	/// Other turfs are untouched.
	var/datum/exoplanet_theme/exoplanet_theme = null

/datum/map_template/ruin/away_site/New(var/list/paths = null, rename = null)

	//Apply the subfolder that all ruins are in, as the prefix will get overwritten
	prefix = "maps/away/[prefix]"

	..()
