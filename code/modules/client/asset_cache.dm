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

	if(!verify) // Can't access the asset cache browser, rip.
		client.cache += asset_name
		return 1

	client.sending |= asset_name
	var/job = ++client.last_asset_job

	client << browse("<script>window.location.href=\"?asset_cache_confirm_arrival=[job]\"</script>", "window=asset_cache_browser")

	var/t = 0
	var/timeout_time = (ASSET_CACHE_SEND_TIMEOUT * client.sending.len) + ASSET_CACHE_SEND_TIMEOUT
	while(client && !client.completed_asset_jobs.Find(job) && t < timeout_time) // Reception is handled in Topic()
		sleep(1) // Lock up the caller until this is received.
		t++

	if(t >= timeout_time)
		log_admin(SPAN_DANGER("Timeout time [timeout_time] exceeded for asset: [asset_name] for client [client]. Please notify a developer."))

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

	if(!verify) // Can't access the asset cache browser, rip.
		client.cache += unreceived
		return 1

	client.sending |= unreceived
	var/job = ++client.last_asset_job

	client << browse("<script>window.location.href=\"?asset_cache_confirm_arrival=[job]\"</script>", "window=asset_cache_browser")

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

//Generated names do not include file extention.
//Used mainly for code that deals with assets in a generic way
//The same asset will always lead to the same asset name
/proc/generate_asset_name(file)
	return "asset.[md5(fcopy_rsc(file))]"

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

/datum/asset
	var/_abstract = /datum/asset

/datum/asset/New()
	asset_datums[type] = src
	register()

/datum/asset/proc/register()
	return

/datum/asset/proc/send(client)
	return

//If you don't need anything complicated.
/datum/asset/simple
	_abstract = /datum/asset/simple
	var/list/assets = list()
	var/verify = FALSE

/datum/asset/simple/register()
	for(var/asset_name in assets)
		register_asset(asset_name, assets[asset_name])

/datum/asset/simple/send(client)
	send_asset_list(client,assets,verify)

/datum/asset/group
	_abstract = /datum/asset/group
	var/list/children

/datum/asset/group/register()
	for(var/type in children)
		get_asset_datum(type)

/datum/asset/group/send(client/C)
	for(var/type in children)
		var/datum/asset/A = get_asset_datum(type)
		A.send(C)

/datum/asset/group/goonchat
	children = list(
		/datum/asset/simple/jquery,
		/datum/asset/simple/goonchat,
		/datum/asset/simple/fontawesome,
		/datum/asset/spritesheet/goonchat
	)

// spritesheet implementation
#define SPR_SIZE 1
#define SPR_IDX 2
#define SPRSZ_COUNT 1
#define SPRSZ_ICON 2
#define SPRSZ_STRIPPED 3

/datum/asset/spritesheet
	_abstract = /datum/asset/spritesheet
	var/name
	var/list/sizes = list()		// "32x32" -> list(10, icon/normal, icon/stripped)
	var/list/sprites = list()	// "foo_bar" -> list("32x32", 5)
	var/verify = FALSE

/datum/asset/spritesheet/register()
	if(!name)
		CRASH("spritesheet [type] cannot register without a name")
	ensure_stripped()

	var/res_name = "spritesheet_[name].css"
	var/fname = "data/spritesheets/[res_name]"
	dll_call(RUST_G, "file_write", generate_css(), fname)
	register_asset(res_name, file(fname))

	for(var/size_id in sizes)
		var/size = sizes[size_id]
		register_asset("[name]_[size_id].png", size[SPRSZ_STRIPPED])

/datum/asset/spritesheet/send(client/C)
	if(!name)
		return
	var/all = list("spritesheet_[name].css")
	for(var/size_id in sizes)
		all += "[name]_[size_id].png"
	send_asset_list(C, all, verify)

/datum/asset/spritesheet/proc/ensure_stripped(sizes_to_strip = sizes)
	for(var/size_id in sizes_to_strip)
		var/size = sizes[size_id]
		if (size[SPRSZ_STRIPPED])
			continue

		var/fname = "data/spritesheets/[name]_[size_id].png"
		fcopy(size[SPRSZ_ICON], fname)
		var/error = dll_call(RUST_G, "dmi_strip_metadata", fname)
		if(length(error))
			crash_with("Failed to strip [name]_[size_id].png: [error]")
		size[SPRSZ_STRIPPED] = icon(fname)

/datum/asset/spritesheet/proc/generate_css()
	var/list/out = list()

	for (var/size_id in sizes)
		var/size = sizes[size_id]
		var/icon/tiny = size[SPRSZ_ICON]
		out += ".[name][size_id]{display:inline-block;width:[tiny.Width()]px;height:[tiny.Height()]px;background:url('[name]_[size_id].png') no-repeat;}"

	for (var/sprite_id in sprites)
		var/sprite = sprites[sprite_id]
		var/size_id = sprite[SPR_SIZE]
		var/idx = sprite[SPR_IDX]
		var/size = sizes[size_id]

		var/icon/tiny = size[SPRSZ_ICON]
		var/icon/big = size[SPRSZ_STRIPPED]
		var/per_line = big.Width() / tiny.Width()
		var/x = (idx % per_line) * tiny.Width()
		var/y = round(idx / per_line) * tiny.Height()

		out += ".[name][size_id].[sprite_id]{background-position:-[x]px -[y]px;}"

	return out.Join("\n")

/datum/asset/spritesheet/proc/Insert(sprite_name, icon/I, icon_state="", dir=SOUTH, frame=1, moving=FALSE, icon/forced=FALSE)
	if (sprites[sprite_name])
		return

	if(!forced)
		I = icon(I, icon_state=icon_state, dir=dir, frame=frame, moving=moving)
	else
		I = forced
	if (!I || !length(icon_states(I)))  // that direction or state doesn't exist
		return
	var/size_id = "[I.Width()]x[I.Height()]"
	var/size = sizes[size_id]

	if (size)
		var/position = size[SPRSZ_COUNT]++
		var/icon/sheet = size[SPRSZ_ICON]
		size[SPRSZ_STRIPPED] = null
		sheet.Insert(I, icon_state=sprite_name)
		sprites[sprite_name] = list(size_id, position)
	else
		sizes[size_id] = size = list(1, I, null)
		sprites[sprite_name] = list(size_id, 0)

/datum/asset/spritesheet/proc/InsertAll(prefix, icon/I, list/directions)
	if (length(prefix))
		prefix = "[prefix]-"

	if (!directions)
		directions = list(SOUTH)

	for (var/icon_state_name in icon_states(I))
		for (var/direction in directions)
			var/prefix2 = (directions.len > 1) ? "[dir2text(direction)]-" : ""
			Insert("[prefix][prefix2][icon_state_name]", I, icon_state=icon_state_name, dir=direction)

/datum/asset/spritesheet/proc/css_tag()
	return {"<link rel="stylesheet" href="spritesheet_[name].css" />"}

/datum/asset/spritesheet/proc/icon_tag(sprite_name, var/html=TRUE)
	var/sprite = sprites[sprite_name]
	if (!sprite)
		return null
	var/size_id = sprite[SPR_SIZE]
	if(html)
		return {"<span class="[name][size_id] [sprite_name]"></span>"}
	return "[name][size_id] [sprite_name]"

#undef SPR_SIZE
#undef SPR_IDX
#undef SPRSZ_COUNT
#undef SPRSZ_ICON
#undef SPRSZ_STRIPPED


/datum/asset/spritesheet/simple
	_abstract = /datum/asset/spritesheet/simple
	var/list/assets

/datum/asset/spritesheet/simple/register()
	for (var/key in assets)
		Insert(key, assets[key])
	..()

//Generates assets based on iconstates of a single icon
/datum/asset/simple/icon_states
	_abstract = /datum/asset/simple/icon_states
	var/icon
	var/list/directions = list(SOUTH)
	var/frame = 1
	var/movement_states = FALSE
	var/prefix = "default" //asset_name = "[prefix].[icon_state_name].png"
	var/generic_icon_names = FALSE //generate icon filenames using generate_asset_name() instead the above format
	verify = FALSE
/datum/asset/simple/icon_states/register(_icon = icon)
	for(var/icon_state_name in icon_states(_icon))
		for(var/direction in directions)
			var/asset = icon(_icon, icon_state_name, direction, frame, movement_states)
			if (!asset)
				continue
			asset = fcopy_rsc(asset) //dedupe
			var/prefix2 = (directions.len > 1) ? "[dir2text(direction)]." : ""
			var/asset_name = sanitize_filename("[prefix].[prefix2][icon_state_name].png")
			if (generic_icon_names)
				asset_name = "[generate_asset_name(asset)].png"
			register_asset(asset_name, asset)

/datum/asset/simple/icon_states/multiple_icons
	_abstract = /datum/asset/simple/icon_states/multiple_icons
	var/list/icons

/datum/asset/simple/icon_states/multiple_icons/register()
	for(var/i in icons)
		..(i)

//DEFINITIONS FOR ASSET DATUMS START HERE.

/datum/asset/simple/faction_icons
	assets = list(
		"faction_EPMC.png" = 'html/images/factions/ECFlogo.png',
		"faction_Zeng.png" = 'html/images/factions/zenghulogo.png',
		"faction_Zavod.png" = 'html/images/factions/zavodlogo.png',
		"faction_NT.png" = 'html/images/factions/nanotrasenlogo.png',
		"faction_Idris.png" = 'html/images/factions/idrislogo.png',
		"faction_Hepht.png" = 'html/images/factions/hephlogo.png',
		"faction_INDEP.png" = 'html/images/factions/unaffiliatedlogo.png',
		"faction_PMCG.png" = 'html/images/factions/pmcglogo.png',
		"faction_Orion.png" = 'html/images/factions/orionlogo.png',
		"faction_SCC.png" = 'html/images/factions/scclogo.png'
	)

/datum/asset/simple/jquery
	verify = FALSE
	assets = list(
		"jquery.min.js"            = 'code/modules/goonchat/browserassets/js/jquery.min.js',
	)

/datum/asset/simple/goonchat
	verify = TRUE
	assets = list(
		"json2.min.js"             = 'code/modules/goonchat/browserassets/js/json2.min.js',
		"browserOutput.js"         = 'code/modules/goonchat/browserassets/js/browserOutput.js',
		"browserOutput.css"	       = 'code/modules/goonchat/browserassets/css/browserOutput.css',
		"browserOutput_white.css"  = 'code/modules/goonchat/browserassets/css/browserOutput_white.css'
	)

/datum/asset/simple/fontawesome
	verify = FALSE
	assets = list(
		"fa-regular-400.eot"  = 'html/font-awesome/webfonts/fa-regular-400.eot',
		"fa-regular-400.woff" = 'html/font-awesome/webfonts/fa-regular-400.woff',
		"fa-solid-900.eot"    = 'html/font-awesome/webfonts/fa-solid-900.eot',
		"fa-solid-900.woff"   = 'html/font-awesome/webfonts/fa-solid-900.woff',
		"font-awesome.css"    = 'html/font-awesome/css/all.min.css',
		"v4shim.css"          = 'html/font-awesome/css/v4-shims.min.css'
	)

/datum/asset/simple/misc
	assets = list(
		"search.js" = 'html/search.js',
		"panels.css" = 'html/panels.css',
		"loading.gif" = 'html/images/loading.gif',
		"ie-truth.min.js" = 'html/iestats/ie-truth.min.js',
		"conninfo.min.js" = 'html/iestats/conninfo.min.js',
		"copyright_infrigement.png" = 'html/images/copyright_infrigement.png',
		"88x31.png" = 'html/images/88x31.png'
	)

/datum/asset/simple/paper
	assets = list(
		"talisman.png" = 'html/images/talisman.png',
		"barcode0.png" = 'html/images/barcode0.png',
		"barcode1.png" = 'html/images/barcode1.png',
		"barcode2.png" = 'html/images/barcode2.png',
		"barcode3.png" = 'html/images/barcode3.png',
		"scclogo.png" = 'html/images/factions/scclogo.png',
		"scclogo_small.png" = 'html/images/factions/scclogo_small.png',
		"nanotrasenlogo.png" = 'html/images/factions/nanotrasenlogo.png',
		"nanotrasenlogo_small.png" = 'html/images/factions/nanotrasenlogo_small.png',
		"zhlogo.png" = 'html/images/factions/zenghulogo.png',
		"zhlogo_small.png" = 'html/images/factions/zenghulogo_small.png',
		"idrislogo.png" = 'html/images/factions/idrislogo.png',
		"idrislogo_small.png" = 'html/images/factions/idrislogo_small.png',
		"eridanilogo.png" = 'html/images/factions/ECFlogo.png',
		"eridanilogo_small.png" = 'html/images/factions/ECFlogo_small.png',
		"pmcglogo.png" = 'html/images/factions/pmcglogo.png',
		"pmcglogo_small.png" = 'html/images/factions/pmcglogo_small.png',
		"zavodlogo.png" = 'html/images/factions/zavodlogo.png',
		"zavodlogo_small.png" = 'html/images/factions/zavodlogo_small.png',
		"orionlogo.png" = 'html/images/factions/orionlogo.png',
		"orionlogo_small.png" = 'html/images/factions/orionlogo_small.png',
		"hplogolarge.png" = 'html/images/hplogolarge.png',
		"hplogo.png" = 'html/images/factions/hephlogo.png',
		"hplogo_small.png" = 'html/images/factions/hephlogo_small.png',
		"beflag.png" = 'html/images/beflag.png',
		"beflag_small.png" = 'html/images/beflag_small.png',
		"elyraflag.png" = 'html/images/elyraflag.png',
		"elyraflag_small.png" = 'html/images/elyraflag_small.png',
		"solflag.png" = 'html/images/solflag.png',
		"solflag_small.png" = 'html/images/solflag_small.png',
		"cocflag.png" = 'html/images/cocflag.png',
		"cocflag_small.png" = 'html/images/cocflag_small.png',
		"domflag.png" = 'html/images/domflag.png',
		"domflag_small.png" = 'html/images/domflag_small.png',
		"nralakkflag.png" = 'html/images/nralakkflag.png',
		"nralakkflag_small.png" = 'html/images/nralakkflag_small.png',
		"praflag.png" = 'html/images/praflag.png',
		"praflag_small.png" = 'html/images/praflag_small.png',
		"dpraflag.png" = 'html/images/dpraflag.png',
		"dpraflag_small.png" = 'html/images/dpraflag_small.png',
		"nkaflag.png" = 'html/images/nkaflag.png',
		"nkaflag_small.png" = 'html/images/nkaflag_small.png',
		"izweskiflag.png" = 'html/images/izweskiflag.png',
		"izweskiflag_small.png" = 'html/images/izweskiflag_small.png',
		"goldenlogo.png" = 'html/images/factions/goldenlogo.png',
		"goldenlogo_small.png" = 'html/images/factions/goldenlogo_small.png',
		"bluebird.woff" = 'html/fonts/OFL/Bluebird.woff',
		"grandhotel.woff" = 'html/fonts/OFL/GrandHotel.woff',
		"lashema.woff" = 'html/fonts/OFL/Lashema.woff',
		"sourcecodepro.woff" = 'html/fonts/OFL/SourceCodePro.woff',
		"sovjetbox.woff" = 'html/fonts/OFL/SovjetBox.woff',
		"torsha.woff" = 'html/fonts/OFL/Torsha.woff',
		"web3of9ascii.woff" = 'html/fonts/OFL/Web3Of9ASCII.woff',
		"zeshit.woff" = 'html/fonts/OFL/zeshit.woff',
		"bilboinc.woff" = 'html/fonts/OFL/BilboINC.woff',
		"fproject.woff" = 'html/fonts/OFL/FProject.woff',
		"gelasio.woff" = 'html/fonts/OFL/Gelasio.woff',
		"mo5v56.woff" = 'html/fonts/OFL/Mo5V56.woff',
		"runasans.woff" = 'html/fonts/OFL/RunaSans.woff',
		"classica.woff" = 'html/fonts/OFL/Classica.woff',
		"stormning.woff" = 'html/fonts/OFL/Stormning.woff',
		"copt-b.woff" = 'html/fonts/OFL/Copt-B.woff',
		"ducados.woff" = 'html/fonts/OFL/Ducados.woff',
		"kawkabmono.woff" = 'html/fonts/OFL/KawkabMono.woff',
		"kaushanscript.woff" = 'html/fonts/OFL/KaushanScript.woff'
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

/datum/asset/spritesheet/goonchat
	name = "chat"

/datum/asset/spritesheet/goonchat/register()
	var/icon/I = icon('icons/accent_tags.dmi')
	for(var/path in subtypesof(/datum/accent))
		var/datum/accent/A = new path
		if(A.tag_icon)
			Insert(A.tag_icon, I, A.tag_icon)
	..()

/datum/asset/spritesheet/vending
	name = "vending"

/datum/asset/spritesheet/vending/register()
	var/list/vending_products = list()
	for(var/v_type in typesof(/obj/machinery/vending))
		var/obj/machinery/vending/V = new v_type
		for(var/list/p in list(V.products, V.contraband, V.premium))
			for(var/k in p)
				vending_products += k
	for(var/path in vending_products)
		var/obj/O = new path
		var/icon_file = O.icon
		var/icon_state = O.icon_state
		var/icon/I
		var/icon_states_list = icon_states(icon_file)
		if(icon_state in icon_states_list)
			I = icon(icon_file, icon_state, SOUTH)
			var/c = O.color
			if(!isnull(c) && c != "#FFFFFF")
				I.Blend(c, ICON_MULTIPLY)
		else
			var/icon_states_string
			for(var/s in icon_states_list)
				if(!icon_states_string)
					icon_states_string = "[json_encode(s)](\ref[s])"
				else
					icon_states_string += ", [json_encode(s)](\ref[s])"
			error("[O] has an invalid icon state, icon=[icon_file], icon_state=[json_encode(icon_state)](\ref[icon_state]), icon_states=[icon_states_string]")
			I = icon('icons/turf/floors.dmi', "", SOUTH)

		var/imgid = ckey("[path]")

		if(istype(O, /obj/item/seeds))
			// thanks seeds for being overlays defined at runtime
			var/obj/item/seeds/S = O
			if(!S.seed && S.seed_type && !isnull(SSplants.seeds) && SSplants.seeds[S.seed_type])
				S.seed = SSplants.seeds[S.seed_type]
			I = S.update_appearance(TRUE)
			Insert(imgid, I, forced=I)
		else
			O.update_icon()
			if(O.overlay_queued)
				O.compile_overlays()
			if(O.overlays.len)
				I = getFlatIcon(O) // forgive me for my performance sins
				Insert(imgid, I, forced=I)
			else
				Insert(imgid, I)
	return ..()

/datum/asset/spritesheet/chem_master
	name = "chemmaster"
	var/list/bottle_sprites = list("bottle-1", "bottle-2", "bottle-3", "bottle-4", "bottle-5", "bottle-6")
	var/max_pill_sprite = 20

/datum/asset/spritesheet/chem_master/register()
	for (var/i = 1 to max_pill_sprite)
		Insert("pill[i]", 'icons/obj/chemical.dmi', "pill[i]")

	for (var/sprite in bottle_sprites)
		Insert(sprite, icon('icons/obj/chemical.dmi', sprite))
	return ..()
