
/obj/item/portable_map_reader
	name = "portable map reader"
	desc = "Displays a map of the local space, as well as any marked points of interest."
	icon = 'icons/obj/device.dmi'
	icon_state = "depthscanner"

	/// The zlevel that this reader is spawned on.
	/// It only shows that zlevel (and any zlevels that zlevel is connected to).
	/// It will not show other zlevels, if the user were to transport it elsewhere on a shuttle.
	var/starting_z_level = null

	/// If zero/null, show the z-level of the user, otherwise show `z_override` z-level.
	var/z_override = 0

/obj/item/portable_map_reader/Initialize()
	. = ..()
	starting_z_level = src.z

/obj/item/portable_map_reader/attack_self(mob/user)
	interact(user)

/obj/item/portable_map_reader/interact(mob/user)
	ui_interact(user)

/obj/item/portable_map_reader/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Map", "Map", 600, 400)
		ui.open()

/obj/item/portable_map_reader/ui_data(mob/user)
	var/list/data = list()

	var/list/zlevels_affected = GetConnectedZlevels(starting_z_level)

	var/z_level = z_override ? z_override : user.z
	if(z_level in zlevels_affected)
		data["map_image"] = SSholomap.minimaps_area_colored_base64[z_level]

	data["user_x"] = user.x
	data["user_y"] = user.y
	data["user_z"] = user.z
	data["station_levels"] = zlevels_affected
	data["z_override"] = z_override

	data["pois"] = list()
	for(var/obj/effect/landmark/minimap_poi/poi as anything in SSholomap.pois)
		data["pois"] += list(list(
			"name" = poi.name,
			"desc" = poi.desc,
			"x" = poi.x,
			"y" = poi.y,
			"z" = poi.z,
		))

	return data

/obj/item/portable_map_reader/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(action == "z_override")
		z_override = text2num(params["z_override"])
