/**
 * # IPIntel datum
 *
 * Holds the result of an IPIntel lookup for a given IP address.
 * Created by [/datum/controller/subsystem/ipintel/proc/get_ip_intel] and delivered to its `on_complete` callback.
 */
/datum/ipintel
	/// The IP address that was looked up
	var/ip
	/// The raw intel score returned by the API (0.0–1.0), or -1 on error
	var/intel = 0
	/// Whether this result came from cache (memory or database) rather than a live API call
	var/cache = FALSE
	/// How many minutes ago the cached entry was written
	var/cacheminutesago = 0
	/// SQL timestamp of when the cache entry was written
	var/cachedate = ""
	/// world.realtime equivalent of the cache write time, used for in-memory cache expiry
	var/cacherealtime = 0

/datum/ipintel/New()
	cachedate = SQLtime()
	cacherealtime = world.realtime

/**
 * Returns TRUE if this cached result is still within its configured validity window.
 *
 * Good results (below [/datum/configuration/var/ipintel_rating_bad]) are kept for
 * [/datum/configuration/var/ipintel_save_good] hours; bad results are kept for
 * [/datum/configuration/var/ipintel_save_bad] hours. Returns FALSE for error results (intel < 0).
 */
/datum/ipintel/proc/is_valid()
	. = FALSE
	if (intel < 0)
		return
	if (intel <= GLOB.config.ipintel_rating_bad)
		if (world.realtime < cacherealtime+(GLOB.config.ipintel_save_good*60*60*10))
			return TRUE
	else
		if (world.realtime < cacherealtime+(GLOB.config.ipintel_save_bad*60*60*10))
			return TRUE
