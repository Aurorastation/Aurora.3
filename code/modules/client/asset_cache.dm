/*
Asset cache quick users guide:

Make a datum at the bottom of this file with your assets for your thing.
The simple subsystem will most like be of use for most cases.
Then call get_asset_datum() with the type of the datum you created and store the return
Then call .send(client) on that stored return value.

You can set verify to TRUE if you want send() to sleep until the client has the assets.
*/


// Amount of time(ds) MAX to send per asset, if this get exceeded we cancel the sleeping.
// This is doubled for the first asset, then added per asset after
#define ASSET_CACHE_SEND_TIMEOUT 7

//When sending mutiple assets, how many before we give the client a quaint little sending resources message
#define ASSET_CACHE_TELL_CLIENT_AMOUNT 8

/client
	var/list/cache = list() // List of all assets sent to this client by the asset cache.
	var/list/completed_asset_jobs = list() // List of all completed jobs, awaiting acknowledgement.
	var/list/sending = list()
	var/last_asset_job = 0 // Last job done.

//This proc sends the asset to the client, but only if it needs it.
//This proc blocks(sleeps) unless verify is set to false
/proc/send_asset(client/client, asset_name, verify = TRUE)
	if(!istype(client))
		if(ismob(client))
			var/mob/M = client
			if(M.client)
				client = M.client

			else
				return 0

		else
			return 0

	if(client.cache.Find(asset_name) || client.sending.Find(asset_name))
		return 0

	client << browse_rsc(SSassets.cache[asset_name], asset_name)
	if(!verify || !winexists(client, "asset_cache_browser")) // Can't access the asset cache browser, rip.
		if (client)
			client.cache += asset_name
		return 1
	if (!client)
		return 0

	client.sending |= asset_name
	var/job = ++client.last_asset_job

	client << browse({"
	<script>
		window.location.href="?asset_cache_confirm_arrival=[job]"
	</script>
	"}, "window=asset_cache_browser")

	var/t = 0
	var/timeout_time = (ASSET_CACHE_SEND_TIMEOUT * client.sending.len) + ASSET_CACHE_SEND_TIMEOUT
	while(client && !client.completed_asset_jobs.Find(job) && t < timeout_time) // Reception is handled in Topic()
		sleep(1) // Lock up the caller until this is received.
		t++

	if(client)
		client.sending -= asset_name
		client.cache |= asset_name
		client.completed_asset_jobs -= job

	return 1

//This proc blocks(sleeps) unless verify is set to false
/proc/send_asset_list(client/client, list/asset_list, verify = TRUE)
	if(!istype(client))
		if(ismob(client))
			var/mob/M = client
			if(M.client)
				client = M.client

			else
				return 0

		else
			return 0

	var/list/unreceived = asset_list - (client.cache + client.sending)
	if(!unreceived || !unreceived.len)
		return 0
	if (unreceived.len >= ASSET_CACHE_TELL_CLIENT_AMOUNT)
		to_chat(client, "Sending Resources...")
	for(var/asset in unreceived)
		if (asset in SSassets.cache)
			client << browse_rsc(SSassets.cache[asset], asset)

	if(!verify || !winexists(client, "asset_cache_browser")) // Can't access the asset cache browser, rip.
		if (client)
			client.cache += unreceived
		return 1
	if (!client)
		return 0
	client.sending |= unreceived
	var/job = ++client.last_asset_job

	client << browse({"
	<script>
		window.location.href="?asset_cache_confirm_arrival=[job]"
	</script>
	"}, "window=asset_cache_browser")

	var/t = 0
	var/timeout_time = ASSET_CACHE_SEND_TIMEOUT * client.sending.len
	while(client && !client.completed_asset_jobs.Find(job) && t < timeout_time) // Reception is handled in Topic()
		sleep(1) // Lock up the caller until this is received.
		t++

	if(client)
		client.sending -= unreceived
		client.cache |= unreceived
		client.completed_asset_jobs -= job

	return 1

//This proc "registers" an asset, it adds it to the cache for further use, you cannot touch it from this point on or you'll fuck things up.
//if it's an icon or something be careful, you'll have to copy it before further use.
/proc/register_asset(asset_name, asset)
	SSassets.cache[asset_name] = asset

//These datums are used to populate the asset cache, the proc "register()" does this.

//all of our asset datums, used for referring to these later
var/list/asset_datums = list()

//get a assetdatum or make a new one
/proc/get_asset_datum(var/type)
	if (!(type in asset_datums))
		return new type()
	return asset_datums[type]

/proc/simple_asset_ensure_is_sent(client, type)
	var/datum/asset/simple/asset = get_asset_datum(type)

	asset.send(client)

/datum/asset/New()
	asset_datums[type] = src

/datum/asset/proc/register()
	return

/datum/asset/proc/send(client)
	return

//If you don't need anything complicated.
/datum/asset/simple
	var/assets = list()
	var/verify = FALSE

/datum/asset/simple/register()
	for(var/asset_name in assets)
		register_asset(asset_name, assets[asset_name])

/datum/asset/simple/send(client)
	send_asset_list(client,assets,verify)

/datum/asset/simple/misc
	assets = list(
		"search.js" = 'html/search.js',
		"panels.css" = 'html/panels.css',
		"loading.gif" = 'html/images/loading.gif',
		"bootstrap.min.css" = 'html/bootstrap/css/bootstrap.min.css',
		"bootstrap.min.js" = 'html/bootstrap/js/bootstrap.min.js',
		"jquery-2.0.0.min.js" = 'html/jquery/jquery-2.0.0.min.js',
		"ie-truth.min.js" = 'html/iestats/ie-truth.min.js',
		"conninfo.min.js" = 'html/iestats/conninfo.min.js',
		"copyright_infrigement.png" = 'html/copyright_infrigement.png'
	)

/datum/asset/simple/paper
	assets = list(
		"talisman.png" = 'html/images/talisman.png',
		"barcode0.png" = 'html/images/barcode0.png',
		"barcode1.png" = 'html/images/barcode1.png',
		"barcode2.png" = 'html/images/barcode2.png',
		"barcode3.png" = 'html/images/barcode3.png',
		"ntlogo.png" = 'html/images/ntlogo.png',
		"ntlogo_small.png" = 'html/images/ntlogo_small.png',
		"zhlogo.png" = 'html/images/zhlogo.png',
		"idrislogo.png" = 'html/images/idrislogo.png',
		"eridanilogo.png" = 'html/images/eridanilogo.png',
		"zavodlogo.png" = 'html/images/zavodlogo.png',
		"hplogo.png" = 'html/images/hplogo.png',
		"belogo.png" = 'html/images/belogo.png'
	)

/datum/asset/simple/changelog
	assets = list(
		"changelog.css" = 'html/changelog.css',
		"changelog.js" = 'html/changelog.js'
	)

/datum/asset/simple/vueui
	assets = list(
		"vueui.js" = 'vueui/dist/app.js',
		"vueui.css" = 'vueui/dist/app.css'
	)

/datum/asset/chem_master
	var/list/bottle_sprites = list("bottle-1", "bottle-2", "bottle-3", "bottle-4")
	var/max_pill_sprite = 20
	var/list/assets = list()

/datum/asset/chem_master/register()
	for (var/i = 1 to max_pill_sprite)
		var/name = "pill[i].png"
		register_asset(name, icon('icons/obj/chemical.dmi', "pill[i]"))
		assets += name

	for (var/sprite in bottle_sprites)
		var/name = "[sprite].png"
		register_asset(name, icon('icons/obj/chemical.dmi', sprite))
		assets += name

/datum/asset/chem_master/send(client)
	send_asset_list(client, assets)

/datum/asset/simple/faction_icons
	assets = list(
		"faction_EPMC.png" = 'icons/misc/factions/ECFlogo.png',
		"faction_Zeng.png" = 'icons/misc/factions/ZhenHulogo.png',
		"faction_Zavod.png" = 'icons/misc/factions/Zavodlogo.png',
		"faction_NT.png" = 'icons/misc/factions/NanoTrasenlogo.png',
		"faction_Idris.png" = 'icons/misc/factions/Idrislogo.png',
		"faction_Hepht.png" = 'icons/misc/factions/Hephaestuslogo.png',
		"faction_unaffiliated.png" = 'icons/misc/factions/Unaffiliatedlogo.png'
	)
