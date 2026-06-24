#define PARALLAX_NONE "parallax_none"

SUBSYSTEM_DEF(parallax)
	name = "Parallax"
	init_order = INIT_ORDER_PARALLAX
	flags = SS_NO_FIRE
	var/planet_x_offset = 128
	var/planet_y_offset = 128
	/// A round-global random parallax layer copied into player HUDs.
	var/atom/movable/screen/parallax_layer/random/random_layer
	/// Weighted list with the parallax layers we can spawn.
	var/random_parallax_weights = list(
		/atom/movable/screen/parallax_layer/random/space_gas = 35,
		/atom/movable/screen/parallax_layer/random/asteroids = 35,
		PARALLAX_NONE = 30,
	)

/datum/controller/subsystem/parallax/Initialize()
	set_random_parallax_layer(pick_weight(random_parallax_weights))
	planet_y_offset = rand(100, 160)
	planet_x_offset = rand(100, 160)
	return SS_INIT_SUCCESS

/// Generate a random layer for parallax.
/datum/controller/subsystem/parallax/proc/set_random_parallax_layer(picked_parallax)
	QDEL_NULL(random_layer)
	if(picked_parallax == PARALLAX_NONE)
		return

	random_layer = new picked_parallax(null, null, null, TRUE)
	RegisterSignal(random_layer, COMSIG_QDELETING, PROC_REF(clear_references))
	random_layer.get_random_look()

/// Change the random parallax layer after it has already been set.
/datum/controller/subsystem/parallax/proc/swap_out_random_parallax_layer(atom/movable/screen/parallax_layer/new_type, update_player_huds = TRUE)
	set_random_parallax_layer(new_type)

	if(!update_player_huds)
		return

	for(var/client/client as anything in GLOB.clients)
		client?.parallax_rock?.set_layer_settings(0, FALSE, TRUE)
		client.mob?.hud_used?.update_parallax_pref()

/datum/controller/subsystem/parallax/proc/clear_references()
	SIGNAL_HANDLER
	random_layer = null

/// Return the most dominant color, if the random layer has one.
/datum/controller/subsystem/parallax/proc/get_parallax_color()
	var/atom/movable/screen/parallax_layer/random/space_gas/gas = random_layer
	if(!istype(gas))
		return

	return gas.parallax_color

#undef PARALLAX_NONE
