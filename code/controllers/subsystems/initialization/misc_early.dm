// This is one of the first subsystems initialized by the MC.
// Stuff that should be loaded before everything else that isn't significant enough to get its own SS goes here.

SUBSYSTEM_DEF(misc_early)
	name = "Early Miscellaneous Init"
	init_order = INIT_ORDER_MISC_FIRST
	flags = SS_NO_FIRE | SS_NO_DISPLAY

/datum/controller/subsystem/misc_early/Initialize(timeofday)
	// Setup the global HUD.
	GLOB.global_huds = list(
		GLOB.global_hud.druggy,
		GLOB.global_hud.blurry,
		GLOB.global_hud.vimpaired,
		GLOB.global_hud.darkMask,
		GLOB.global_hud.nvg,
		GLOB.global_hud.thermal,
		GLOB.global_hud.meson,
		GLOB.global_hud.science,
	)

	// Populate global list of tips by category
	populate_tip_list()

	// Create robolimbs for chargen.
	populate_robolimb_list()

	// Set up antags.
	// Spawn locations are set after map init!
	populate_antag_type_list()

	// Get BOREALIS to warn staff about a lazy admin forgetting visibility to 0
	// before anyone has a chance to change it!
	if (SSdiscord)
		SSdiscord.alert_server_visibility()

	// Setup ore.
	for(var/oretype in subtypesof(/ore))
		var/ore/OD = new oretype()
		GLOB.ore_data[OD.name] = OD

	// Setup cargo spawn lists.
	setup_cargo_spawn_lists()

	GLOB.click_catchers = create_click_catcher()

	return SS_INIT_SUCCESS
