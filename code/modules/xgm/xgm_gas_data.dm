var/global/datum/xgm_gas_data/gas_data

/datum/xgm_gas_data
	/// Simple list of all the gas IDs.
	var/list/gases = list()
	/// The friendly, human-readable name for the gas.
	var/list/name = list()
	/// Specific heat of the gas.  Used for calculating heat capacity.
	var/list/specific_heat = list()
	/// Molar mass of the gas.  Used for calculating specific entropy.
	var/list/molar_mass = list()
	/// Tile overlays. /obj/gas_overlay, created from references to 'icons/effects/tile_effects.dmi'
	var/list/tile_overlay = list()
	/// Optional color for tile overlay
	var/list/tile_overlay_color = list()
	/// Overlay limits.  There must be at least this many moles for the overlay to appear.
	var/list/overlay_limit = list()
	/// Flags.
	var/list/flags = list()

/singleton/xgm_gas
	var/id = ""
	var/name = "Unnamed Gas"
	var/desc
	var/specific_heat = 20	// J/(mol*K)
	var/molar_mass = 0.032	// kg/mol

	var/tile_overlay = "generic"
	var/tile_color = null
	var/overlay_limit = null

	var/flags = 0

/hook/startup/proc/generateGasData()
	gas_data = new
	for(var/p in (typesof(/singleton/xgm_gas) - /singleton/xgm_gas))
		var/singleton/xgm_gas/gas = new p //avoid initial() because of potential New() actions

		if(gas.id in gas_data.gases)
			stack_trace("ERROR: Duplicate gas id `[gas.id]` in `[p]`")

		gas_data.gases += gas.id
		gas_data.name[gas.id] = gas.name
		gas_data.specific_heat[gas.id] = gas.specific_heat
		gas_data.molar_mass[gas.id] = gas.molar_mass
		if(gas.overlay_limit)
			gas_data.overlay_limit[gas.id] = gas.overlay_limit
			gas_data.tile_overlay[gas.id] = gas.tile_overlay
			gas_data.tile_overlay_color[gas.id] = gas.tile_color
		gas_data.flags[gas.id] = gas.flags

	return 1

/obj/gas_overlay
	name = "gas"
	desc = "You shouldn't be clicking this."
	icon = 'icons/effects/tile_effects.dmi'
	icon_state = "generic"
	plane = GAME_PLANE
	layer = FIRE_LAYER
	appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	mouse_opacity = 0
	var/gas_id
	var/plane_offset = 0
	var/list/offset_overlays

/obj/gas_overlay/proc/update_alpha_animation(new_alpha)
	apply_alpha_animation(new_alpha)
	for(var/offset in offset_overlays)
		var/obj/gas_overlay/overlay = offset_overlays[offset]
		overlay.apply_alpha_animation(new_alpha)

/obj/gas_overlay/proc/apply_alpha_animation(new_alpha)
	animate(src, alpha = new_alpha)
	alpha = new_alpha
	animate(src, alpha = 0.8 * new_alpha, time = 10, easing = SINE_EASING | EASE_OUT, loop = -1)
	animate(alpha = new_alpha, time = 10, easing = SINE_EASING | EASE_IN, loop = -1)

/obj/gas_overlay/Initialize(mapload, gas, offset = 0)
	. = ..()
	gas_id = gas
	plane_offset = offset
	if(gas_data.tile_overlay[gas_id])
		icon_state = gas_data.tile_overlay[gas_id]
		color = gas_data.tile_overlay_color[gas_id]
	apply_offset_context()

/obj/gas_overlay/proc/apply_offset_context()
	SET_PLANE_W_SCALAR(src, initial(plane), plane_offset)

/obj/gas_overlay/proc/get_offset_overlay(turf/source_turf)
	var/source_offset = GET_TURF_PLANE_OFFSET(source_turf)
	if(source_offset == plane_offset)
		return src
	LAZYINITLIST(offset_overlays)
	var/offset_key = "[source_offset]"
	if(!offset_overlays[offset_key])
		var/obj/gas_overlay/offset_overlay = new src.type(null, gas_id, source_offset)
		offset_overlay.alpha = alpha
		offset_overlays[offset_key] = offset_overlay
	return offset_overlays[offset_key]

/obj/gas_overlay/heat
	name = "gas"
	desc = "You shouldn't be clicking this."
	plane = HEAT_EFFECT_PLANE
	gas_id = GAS_HEAT
	render_source = HEAT_EFFECT_PLATE_RENDER_TARGET

/obj/gas_overlay/heat/Initialize(mapload, gas, offset = 0)
	. = ..()
	icon = null
	icon_state = null

/obj/gas_overlay/heat/apply_offset_context()
	. = ..()
	render_source = OFFSET_RENDER_TARGET(HEAT_EFFECT_PLATE_RENDER_TARGET, plane_offset)

/obj/effect/gas_cold_back
	plane = GAME_PLANE
	layer = BELOW_OBJ_LAYER
	render_source = COLD_EFFECT_BACK_PLATE_RENDER_TARGET
	var/plane_offset = 0

/obj/effect/gas_cold_back/Initialize(mapload, offset = 0)
	. = ..()
	plane_offset = offset
	SET_PLANE_W_SCALAR(src, initial(plane), plane_offset)
	render_source = OFFSET_RENDER_TARGET(COLD_EFFECT_BACK_PLATE_RENDER_TARGET, plane_offset)

/obj/gas_overlay/cold
	name = "gas"
	desc = "You shouldn't be clicking this."
	gas_id = GAS_COLD
	var/obj/effect/gas_cold_back/b = null
	render_source = COLD_EFFECT_PLATE_RENDER_TARGET

/obj/gas_overlay/cold/Initialize(mapload, gas, offset = 0)
	. = ..()
	icon = null
	icon_state = null
	b = new(null, plane_offset)
	add_vis_contents(b)

/obj/gas_overlay/cold/Destroy()
	QDEL_NULL(b)
	return ..()

/obj/gas_overlay/cold/apply_offset_context()
	. = ..()
	render_source = OFFSET_RENDER_TARGET(COLD_EFFECT_PLATE_RENDER_TARGET, plane_offset)
