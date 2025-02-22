//These datums are used to populate the asset cache, the proc "register()" does this.
//Place any asset datums you create in asset_list_items.dm

//all of our asset datums, used for referring to these later
GLOBAL_LIST_EMPTY(asset_datums)

//get an assetdatum or make a new one
//does NOT ensure it's filled, if you want that use get_asset_datum()
/proc/load_asset_datum(type)
	return GLOB.asset_datums[type] || new type()

/proc/get_asset_datum(type)
	var/datum/asset/loaded_asset = GLOB.asset_datums[type] || new type()
	return loaded_asset.ensure_ready()

/proc/simple_asset_ensure_is_sent(client, type)
	var/datum/asset/simple/asset = get_asset_datum(type)

	asset.send(client)

/datum/asset
	var/_abstract = /datum/asset
	var/cached_serialized_url_mappings
	var/cached_serialized_url_mappings_transport_type

	/// Whether or not this asset should be loaded in the "early assets" SS
	var/early = FALSE

	/// Whether or not this asset can be cached across rounds of the same commit under the `CACHE_ASSETS` config.
	/// This is not a *guarantee* the asset will be cached. Not all asset subtypes respect this field, and the
	/// config can, of course, be disabled.
	var/cross_round_cachable = FALSE

/datum/asset/New()
	GLOB.asset_datums[type] = src
	register()

/// Stub that allows us to react to something trying to get us
/// Not useful here, more handy for sprite sheets
/datum/asset/proc/ensure_ready()
	return src

/// Stub to hook into if your asset is having its generation queued by SSasset_loading
/datum/asset/proc/queued_generation()
	CRASH("[type] inserted into SSasset_loading despite not implementing /proc/queued_generation")

/datum/asset/proc/get_url_mappings()
	return list()

/// Returns a cached tgui message of URL mappings
/datum/asset/proc/get_serialized_url_mappings()
	if (isnull(cached_serialized_url_mappings) || cached_serialized_url_mappings_transport_type != SSassets.transport.type)
		cached_serialized_url_mappings = TGUI_CREATE_MESSAGE("asset/mappings", get_url_mappings())
		cached_serialized_url_mappings_transport_type = SSassets.transport.type

	return cached_serialized_url_mappings

/datum/asset/proc/register()
	return

/datum/asset/proc/send(client)
	return

/// Returns whether or not the asset should attempt to read from cache
/datum/asset/proc/should_refresh()
	return !cross_round_cachable || !GLOB.config.cache_assets

//If you don't need anything complicated.
/datum/asset/simple
	_abstract = /datum/asset/simple
	/// list of assets for this datum in the form of:
	/// asset_filename = asset_file. At runtime the asset_file will be
	/// converted into a asset_cache datum.
	var/list/assets = list()
	/// Set to true to have this asset also be sent via the legacy browse_rsc
	/// system when cdn transports are enabled?
	var/legacy = FALSE
	/// TRUE for keeping local asset names when browse_rsc backend is used
	var/keep_local_name = FALSE

/datum/asset/simple/register()
	for(var/asset_name in assets)
		var/datum/asset_cache_item/ACI = SSassets.transport.register_asset(asset_name, assets[asset_name])
		if (!ACI)
			log_asset("ERROR: Invalid asset: [type]:[asset_name]:[ACI]")
			continue
		if (legacy)
			ACI.legacy = legacy
		if (keep_local_name)
			ACI.keep_local_name = keep_local_name
		assets[asset_name] = ACI

/datum/asset/simple/send(client)
	. = SSassets.transport.send_assets(client, assets)

/datum/asset/simple/get_url_mappings()
	. = list()
	for (var/asset_name in assets)
		.[asset_name] = SSassets.transport.get_asset_url(asset_name, assets[asset_name])

/datum/asset/group
	_abstract = /datum/asset/group
	var/list/children

/datum/asset/group/register()
	for(var/type in children)
		get_asset_datum(type)

/datum/asset/group/send(client/C)
	for(var/type in children)
		var/datum/asset/A = get_asset_datum(type)
		A.send(C) || .

/datum/asset/group/get_url_mappings()
	. = list()
	for(var/type in children)
		var/datum/asset/A = get_asset_datum(type)
		. += A.get_url_mappings()

// spritesheet implementation
#define SPR_SIZE 1
#define SPR_IDX 2
#define SPRSZ_COUNT 1
#define SPRSZ_ICON 2
#define SPRSZ_STRIPPED 3

/datum/asset/spritesheet
	_abstract = /datum/asset/spritesheet
	var/name
	/// List of arguments to pass into queuedInsert
	/// Exists so we can queue icon insertion, mostly for stuff like preferences
	var/list/to_generate = list()
	var/list/sizes = list()		// "32x32" -> list(10, icon/normal, icon/stripped)
	var/list/sprites = list()	// "foo_bar" -> list("32x32", 5)
	var/list/cached_spritesheets_needed
	var/generating_cache = FALSE
	var/verify = FALSE
	var/fully_generated = FALSE
	/// If this asset should be fully loaded on new
	/// Defaults to false so we can process this stuff nicely
	var/load_immediately = TRUE

/datum/asset/spritesheet/register()
	if(!name)
		CRASH("spritesheet [type] cannot register without a name")

	if (!should_refresh() && read_from_cache())
		fully_generated = TRUE
		return

	// If it's cached, may as well load it now, while the loading is cheap
	if(GLOB.config.cache_assets && cross_round_cachable)
		load_immediately = TRUE

	create_spritesheets()
	if(should_load_immediately())
		realize_spritesheets(yield = FALSE)
	else
		SSasset_loading.queue_asset(src)

	for(var/size_id in sizes)
		var/size = sizes[size_id]
		SSassets.transport.register_asset("[name]_[size_id].png", size[SPRSZ_STRIPPED])

/datum/asset/spritesheet/send(client/client)
	if (!name)
		return

	if (!should_refresh())
		return send_from_cache(client)

	var/all = list("spritesheet_[name].css")
	for(var/size_id in sizes)
		all += "[name]_[size_id].png"
	. = SSassets.transport.send_assets(client, all)

/datum/asset/spritesheet/proc/realize_spritesheets(yield)
	if(fully_generated)
		return
	while(length(to_generate))
		var/list/stored_args = to_generate[to_generate.len]
		to_generate.len--
		queuedInsert(arglist(stored_args))
		if(yield && TICK_CHECK)
			return

	ensure_stripped()
	for(var/size_id in sizes)
		var/size = sizes[size_id]
		SSassets.transport.register_asset("[name]_[size_id].png", size[SPRSZ_STRIPPED])
	var/res_name = "spritesheet_[name].css"
	var/fname = "data/spritesheets/[res_name]"
	fdel(fname)
	text2file(generate_css(), fname)
	SSassets.transport.register_asset(res_name, fcopy_rsc(fname))
	fdel(fname)

	if (GLOB.config.cache_assets && cross_round_cachable)
		write_to_cache()
	fully_generated = TRUE
	// If we were ever in there, remove ourselves
	SSasset_loading.dequeue_asset(src)

/datum/asset/spritesheet/queued_generation()
	realize_spritesheets(yield = TRUE)

/// Returns the URL to put in the background:url of the CSS asset
/datum/asset/spritesheet/proc/get_background_url(asset)
	if (generating_cache)
		return "%[asset]%"
	else
		return SSassets.transport.get_asset_url(asset)

/datum/asset/spritesheet/proc/create_spritesheets()
	return

/datum/asset/spritesheet/proc/send_from_cache(client/client)
	if (isnull(cached_spritesheets_needed))
		stack_trace("cached_spritesheets_needed was null when sending assets from [type] from cache")
		cached_spritesheets_needed = list()

	return SSassets.transport.send_assets(client, cached_spritesheets_needed + "spritesheet_[name].css")

/datum/asset/spritesheet/proc/write_to_cache()
	for (var/size_id in sizes)
		fcopy(SSassets.cache["[name]_[size_id].png"].resource, "[ASSET_CROSS_ROUND_CACHE_DIRECTORY]/spritesheet.[name]_[size_id].png")

	generating_cache = TRUE
	var/mock_css = generate_css()
	generating_cache = FALSE

	rustg_file_write(mock_css, "[ASSET_CROSS_ROUND_CACHE_DIRECTORY]/spritesheet.[name].css")

/datum/asset/spritesheet/get_url_mappings()
	if (!name)
		return

	if (!should_refresh())
		return get_cached_url_mappings()

	. = list("spritesheet_[name].css" = SSassets.transport.get_asset_url("spritesheet_[name].css"))
	for(var/size_id in sizes)
		.["[name]_[size_id].png"] = SSassets.transport.get_asset_url("[name]_[size_id].png")

/datum/asset/spritesheet/proc/get_cached_url_mappings()
	var/list/mappings = list()
	mappings["spritesheet_[name].css"] = SSassets.transport.get_asset_url("spritesheet_[name].css")

	for (var/asset_name in cached_spritesheets_needed)
		mappings[asset_name] = SSassets.transport.get_asset_url(asset_name)

	return mappings

/datum/asset/spritesheet/proc/read_from_cache()
	var/replaced_css = file2text("[ASSET_CROSS_ROUND_CACHE_DIRECTORY]/spritesheet.[name].css")

	var/regex/find_background_urls = regex(@"background:url\('%(.+?)%'\)", "g")
	while (find_background_urls.Find(replaced_css))
		var/asset_id = find_background_urls.group[1]
		var/asset_cache_item = SSassets.transport.register_asset(asset_id, "[ASSET_CROSS_ROUND_CACHE_DIRECTORY]/spritesheet.[asset_id]")
		var/asset_url = SSassets.transport.get_asset_url(asset_cache_item = asset_cache_item)
		replaced_css = replacetext(replaced_css, find_background_urls.match, "background:url('[asset_url]')")
		LAZYADD(cached_spritesheets_needed, asset_id)

	var/replaced_css_filename = "data/spritesheets/spritesheet_[name].css"
	rustg_file_write(replaced_css, replaced_css_filename)
	SSassets.transport.register_asset("spritesheet_[name].css", replaced_css_filename)

	fdel(replaced_css_filename)

	return TRUE

// LEMON NOTE
// A GOON CODER SAYS BAD ICON ERRORS CAN BE THROWN BY THE "ICON CACHE"
// APPARENTLY IT MAKES ICONS IMMUTABLE
// LOOK INTO USING THE MUTABLE APPEARANCE PATTERN HERE
/datum/asset/spritesheet/proc/queuedInsert(sprite_name, icon/I, icon_state="", dir=SOUTH, frame=1, moving=FALSE)
	I = icon(I, icon_state=icon_state, dir=dir, frame=frame, moving=moving)
	if (!I || !length(icon_states(I)))  // that direction or state doesn't exist
		return
	//any sprite modifications we want to do (aka, coloring a greyscaled asset)
	I = ModifyInserted(I)
	var/size_id = "[I.Width()]x[I.Height()]"
	var/size = sizes[size_id]

	if (sprites[sprite_name])
		CRASH("duplicate sprite \"[sprite_name]\" in sheet [name] ([type])")

	if (size)
		var/position = size[SPRSZ_COUNT]++
		var/icon/sheet = size[SPRSZ_ICON]
		var/icon/sheet_copy = icon(sheet)
		size[SPRSZ_STRIPPED] = null
		sheet_copy.Insert(I, icon_state=sprite_name)
		size[SPRSZ_ICON] = sheet_copy

		sprites[sprite_name] = list(size_id, position)
	else
		sizes[size_id] = size = list(1, I, null)
		sprites[sprite_name] = list(size_id, 0)

/**
 * A simple proc handing the Icon for you to modify before it gets turned into an asset.
 *
 * Arguments:
 * * I: icon being turned into an asset
 */
/datum/asset/spritesheet/proc/ModifyInserted(icon/pre_asset)
	return pre_asset

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
		out += ".[name][size_id]{display:inline-block;width:[tiny.Width()]px;height:[tiny.Height()]px;background:url('[get_background_url("[name]_[size_id].png")]') no-repeat;}"

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

/datum/asset/spritesheet/proc/should_load_immediately()
#ifdef DO_NOT_DEFER_ASSETS
	return TRUE
#else
	return load_immediately
#endif

/datum/asset/spritesheet/proc/Insert(sprite_name, icon/I, icon_state="", dir=SOUTH, frame=1, moving=FALSE, icon/forced=FALSE)
	if(should_load_immediately())
		queuedInsert(sprite_name, I, icon_state, dir, frame, moving)
	else
		to_generate += list(args.Copy())

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

/datum/asset/spritesheet/proc/css_filename()
	return SSassets.transport.get_asset_url("spritesheet_[name].css")

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
			SSassets.transport.register_asset(asset_name, asset)

/datum/asset/simple/icon_states/multiple_icons
	_abstract = /datum/asset/simple/icon_states/multiple_icons
	var/list/icons

/datum/asset/simple/icon_states/multiple_icons/register()
	for(var/i in icons)
		..(i)

//DEFINITIONS FOR ASSET DATUMS START HERE.

/datum/asset/simple/faction_icons
	legacy = TRUE
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
	cross_round_cachable = TRUE

/datum/asset/simple/namespaced/fontawesome
	legacy = TRUE
	assets = list(
		"fa-regular-400.ttf" = 'html/font-awesome/webfonts/fa-regular-400.ttf',
		"fa-solid-900.ttf" = 'html/font-awesome/webfonts/fa-solid-900.ttf',
		"fa-v4compatibility.ttf" = 'html/font-awesome/webfonts/fa-v4compatibility.ttf',
		"v4shim.css" = 'html/font-awesome/css/v4-shims.min.css',
	)
	parents = list("font-awesome.css" = 'html/font-awesome/css/all.min.css')
	cross_round_cachable = TRUE

/datum/asset/simple/namespaced/tgfont
	assets = list(
		"tgfont.eot" = file("tgui/packages/tgfont/static/tgfont.eot"),
		"tgfont.woff2" = file("tgui/packages/tgfont/static/tgfont.woff2"),
	)
	parents = list(
		"tgfont.css" = file("tgui/packages/tgfont/static/tgfont.css"),
	)

/datum/asset/simple/misc
	legacy = TRUE
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
	legacy = TRUE
	keep_local_name = TRUE
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
		"pvpolicelogo.png" = 'html/images/pvpolicelogo.png',
		"pvpolicelogo_small.png" = 'html/images/pvpolicelogo_small.png',
		//scan images that appear on sensors
		"no_data.png" = 'html/images/scans/no_data.png',
		"horizon.png" = 'html/images/scans/horizon.png',
		"intrepid.png" = 'html/images/scans/intrepid.png',
		"spark.png" = 'html/images/scans/spark.png',
		"canary.png" = 'html/images/scans/canary.png',
		"corvette.png" = 'html/images/scans/corvette.png',
		"elyran_corvette.png" = 'html/images/scans/elyran_corvette.png',
		"dominian_corvette.png" = 'html/images/scans/dominian_corvette.png',
		"tcfl_cetus.png" = 'html/images/scans/tcfl_cetus.png',
		"unathi_corvette.png" = 'html/images/scans/unathi_corvette.png',
		"unathi_freighter1.png" = 'html/images/scans/unathi_freighter1.png',
		"unathi_freighter2.png" = 'html/images/scans/unathi_freighter2.png',
		"unathi_guild_station.png" = 'html/images/scans/unathi_guild_station.png',
		"unathi_diona_freighter.png" = 'html/images/scans/unathi_diona_freighter.png',
		"hegemony_corvette.png" = 'html/images/scans/hegemony_corvette.png',
		"ranger.png" = 'html/images/scans/ranger.png',
		"oe_platform.png" = 'html/images/scans/oe_platform.png',
		"hospital.png" = 'html/images/scans/hospital.png',
		"skrell_freighter.png" = 'html/images/scans/skrell_freighter.png',
		"diona.png" = 'html/images/scans/diona.png',
		"hailstorm.png" = 'html/images/scans/hailstorm.png',
		"headmaster.png" = 'html/images/scans/headmaster.png',
		"pss.png" = 'html/images/scans/pss.png',
		"nka_freighter.png" = 'html/images/scans/nka_freighter.png',
		"pra_freighter.png" = 'html/images/scans/pra_freighter.png',
		"tramp_freighter.png" = 'html/images/scans/tramp_freighter.png',
		"line_cruiser.png" = 'html/images/scans/line_cruiser.png',
		//planet scan images
		"exoplanet_empty.png" = 'html/images/scans/exoplanets/exoplanet_empty.png',
		"barren.png" = 'html/images/scans/exoplanets/barren.png',
		"lava.png" = 'html/images/scans/exoplanets/lava.png',
		"grove.png" = 'html/images/scans/exoplanets/grove.png',
		"desert.png" = 'html/images/scans/exoplanets/desert.png',
		"snow.png" = 'html/images/scans/exoplanets/snow.png',
		"adhomai.png" = 'html/images/scans/exoplanets/adhomai.png',
		"raskara.png" = 'html/images/scans/exoplanets/raskara.png',
		"comet.png" = 'html/images/scans/exoplanets/comet.png',
		"asteroid.png" = 'html/images/scans/exoplanets/asteroid.png',
		"konyang.png" = 'html/images/scans/exoplanets/konyang.png',
		"konyang_point_verdant.png" = 'html/images/scans/exoplanets/konyang_point_verdant.png',
		"biesel.png" = 'html/images/scans/exoplanets/biesel.png',
		"moghes.png" = 'html/images/scans/exoplanets/moghes.png',
		"chanterel.png" = 'html/images/scans/exoplanets/chanterel.png',
		//end scan images
		"bluebird.woff" = 'html/fonts/OFL/Bluebird.woff',
		"grandhotel.woff" = 'html/fonts/OFL/GrandHotel.woff',
		"lashema.woff" = 'html/fonts/OFL/Lashema.woff',
		"sourcecodepro.woff" = 'html/fonts/OFL/SourceCodePro.woff',
		"sovjetbox.woff" = 'html/fonts/OFL/SovjetBox.woff',
		"torsha.woff" = 'html/fonts/OFL/Torsha.woff',
		"web3of9ascii.woff" = 'html/fonts/OFL/Web3Of9ASCII.woff',
		"zeshit.woff" = 'html/fonts/OFL/Zeshit.woff',
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
		"kaushanscript.woff" = 'html/fonts/OFL/KaushanScript.woff',
		"typewriter.woff" = 'html/fonts/OFL/typewriter.woff'
	)
	cross_round_cachable = TRUE

/datum/asset/simple/changelog
	legacy = TRUE
	assets = list(
		"changelog.css" = 'html/changelog.css',
		"changelog.js" = 'html/changelog.js'
	)

/datum/asset/spritesheet/vending
	name = "vending"

/datum/asset/spritesheet/vending/create_spritesheets()
	var/vending_products = list()
	for(var/obj/machinery/vending/vendor as anything in typesof(/obj/machinery/vending))
		vendor = new vendor()
		for(var/each in list(vendor.products, vendor.contraband, vendor.premium))
			vending_products |= each
		qdel(vendor)

	for(var/path in vending_products)
		var/atom/item = path
		if(!ispath(item, /atom))
			continue

		var/icon_file = initial(item.icon)
		var/icon_state = initial(item.icon_state)

		#ifdef UNIT_TEST
		var/icon_states_list = icon_states(icon_file)
		if(!(icon_state in icon_states_list))
			var/icon_states_string
			for(var/s in icon_states_list)
				if(!icon_states_string)
					icon_states_string = "[json_encode(s)]([REF(s)])"
				else
					icon_states_string += ", [json_encode(s)]([REF(s)])"

			stack_trace("[item] has an invalid icon state, icon=[icon_file], icon_state=[json_encode(icon_state)]([REF(icon_state)]), icon_states=[icon_states_string]")
			continue
		#endif

		var/icon/I = icon(icon_file, icon_state, SOUTH)
		var/c = initial(item.color)
		if(!isnull(c) && c != "#FFFFFF")
			I.Blend(c, ICON_MULTIPLY)

		var/imgid = ckey("[item]")
		item = new item()

		if(ispath(item, /obj/item/seeds))
			// thanks seeds for being overlays defined at runtime
			var/obj/item/seeds/S = item
			if(!S.seed && S.seed_type && !isnull(SSplants.seeds) && SSplants.seeds[S.seed_type])
				S.seed = SSplants.seeds[S.seed_type]
			I = S.update_appearance(TRUE)
			Insert(imgid, I, forced=I)
		else
			item.update_icon()
			if(item.atom_flags & ATOM_AWAITING_OVERLAY_UPDATE)
				item.UpdateOverlays()
			if(item.overlays.len)
				I = getFlatIcon(item) // forgive me for my performance sins
				Insert(imgid, I, forced=I)
			else
				Insert(imgid, I)

		qdel(item)

/datum/asset/spritesheet/chem_master
	name = "chemmaster"
	cross_round_cachable = FALSE
	var/list/bottle_sprites = list("bottle-1", "bottle-2", "bottle-3", "bottle-4")
	var/max_pill_sprite = 20

/datum/asset/spritesheet/chem_master/register()
	for (var/i = 1 to max_pill_sprite)
		Insert("pill[i]", 'icons/obj/chemical.dmi', "pill[i]")

	for (var/sprite in bottle_sprites)
		Insert(sprite, icon('icons/obj/item/reagent_containers/glass.dmi', sprite))
	return ..()

/datum/asset/spritesheet/accents
	name = "accents"
	cross_round_cachable = TRUE

/// Namespace'ed assets (for static css and html files)
/// When sent over a cdn transport, all assets in the same asset datum will exist in the same folder, as their plain names.
/// Used to ensure css files can reference files by url() without having to generate the css at runtime, both the css file and the files it depends on must exist in the same namespace asset datum. (Also works for html)
/// For example `blah.css` with asset `blah.png` will get loaded as `namespaces/a3d..14f/f12..d3c.css` and `namespaces/a3d..14f/blah.png`. allowing the css file to load `blah.png` by a relative url rather then compute the generated url with get_url_mappings().
/// The namespace folder's name will change if any of the assets change. (excluding parent assets)
/datum/asset/simple/namespaced
	_abstract = /datum/asset/simple/namespaced
	/// parents - list of the parent asset or assets (in name = file assoicated format) for this namespace.
	/// parent assets must be referenced by their generated url, but if an update changes a parent asset, it won't change the namespace's identity.
	var/list/parents = list()

/datum/asset/simple/namespaced/register()
	if (legacy)
		assets |= parents
	var/list/hashlist = list()
	var/list/sorted_assets = sort_list(assets)

	for (var/asset_name in sorted_assets)
		var/datum/asset_cache_item/ACI = new(asset_name, sorted_assets[asset_name])
		if (!ACI?.hash)
			log_asset("ERROR: Invalid asset: [type]:[asset_name]:[ACI]")
			continue
		hashlist += ACI.hash
		sorted_assets[asset_name] = ACI
	var/namespace = md5(hashlist.Join())

	for (var/asset_name in parents)
		var/datum/asset_cache_item/ACI = new(asset_name, parents[asset_name])
		if (!ACI?.hash)
			log_asset("ERROR: Invalid asset: [type]:[asset_name]:[ACI]")
			continue
		ACI.namespace_parent = TRUE
		sorted_assets[asset_name] = ACI

	for (var/asset_name in sorted_assets)
		var/datum/asset_cache_item/ACI = sorted_assets[asset_name]
		if (!ACI?.hash)
			log_asset("ERROR: Invalid asset: [type]:[asset_name]:[ACI]")
			continue
		ACI.namespace = namespace

	assets = sorted_assets
	..()

/// Get a html string that will load a html asset.
/// Needed because byond doesn't allow you to browse() to a url.
/datum/asset/simple/namespaced/proc/get_htmlloader(filename)
	return url2htmlloader(SSassets.transport.get_asset_url(filename, assets[filename]))

/// Generate a filename for this asset
/// The same asset will always lead to the same asset name
/// (Generated names do not include file extention.)
/proc/generate_asset_name(file)
	return "asset.[md5(fcopy_rsc(file))]"


/datum/asset/changelog_item
	_abstract = /datum/asset/changelog_item
	var/item_filename

/datum/asset/changelog_item/New(date)
	item_filename = SANITIZE_FILENAME("[date].yml")
	SSassets.transport.register_asset(item_filename, file("html/changelogs/archive/" + item_filename))

/datum/asset/changelog_item/send(client)
	if (!item_filename)
		return
	. = SSassets.transport.send_assets(client, item_filename)

/datum/asset/changelog_item/get_url_mappings()
	if (!item_filename)
		return
	. = list("[item_filename]" = SSassets.transport.get_asset_url(item_filename))
