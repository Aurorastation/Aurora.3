// This is one of the first subsystems initialized by the MC.
// Stuff that should be loaded before everything else that isn't significant enough to get its own SS goes here.

/datum/controller/subsystem/misc_early
	name = "Early Miscellaneous Init"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_NO_FIRE | SS_NO_DISPLAY

/datum/controller/subsystem/misc_early/Initialize(timeofday)
	// Setup the global HUD.
	global_hud = new
	global_huds = list(
		global_hud.druggy,
		global_hud.blurry,
		global_hud.vimpaired,
		global_hud.darkMask,
		global_hud.nvg,
		global_hud.thermal,
		global_hud.meson,
		global_hud.science,
		global_hud.holomap
	)

	// Create autolathe recipes, as above.
	populate_lathe_recipes()

	// Create robolimbs for chargen.
	populate_robolimb_list()

	// Set up antags.
	// Spawn locations are set after map init!
	populate_antag_type_list()

	// Get BOREALIS to warn staff about a lazy admin forgetting visibility to 0
	// before anyone has a chance to change it!
	if (discord_bot)
		discord_bot.alert_server_visibility()

	global_initialize_webhooks()

	// Setup ore.
	for(var/oretype in subtypesof(/ore))
		var/ore/OD = new oretype()
		ore_data[OD.name] = OD

	// Setup cargo spawn lists.
	global.cargo_master.setup_cargo_stock()

	..()
