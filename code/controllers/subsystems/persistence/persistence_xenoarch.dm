/singleton/persistent_type/generic/xenoarch_artifacts
	title = "Xenoarchaeology Artifacts"
	description = "Persists xenoarchaeology artifacts left on anomaly scanner pads or inside anomaly containers on pads across rounds."
	/// Associative list of pad_id -> /obj/structure/machinery/artifact_scanpad mapped on the station.
	var/list/pad_register = list()
	/// Whether initialization completed successfully. Prevents a failed load from overwriting saved artifacts.
	var/artifacts_initialized = FALSE

/singleton/persistent_type/generic/xenoarch_artifacts/proc/serialize_effect(datum/artifact_effect/E)
	if(!E)
		return null
	return list(
		"type" = "[E.type]",
		"effect" = E.effect,
		"effectrange" = E.effectrange,
		"trigger" = E.trigger,
		"activated" = E.activated,
		"chargelevel" = E.chargelevel,
		"chargelevelmax" = E.chargelevelmax,
		"artifact_id" = E.artifact_id,
		"effect_type" = E.effect_type
	)

/singleton/persistent_type/generic/xenoarch_artifacts/proc/deserialize_effect(list/data, atom/holder)
	if(!islist(data))
		return null
	var/effect_path = text2path(data["type"])
	if(!ispath(effect_path, /datum/artifact_effect))
		return null
	var/datum/artifact_effect/E = new effect_path(holder)
	E.effect = data["effect"]
	E.effectrange = data["effectrange"]
	E.trigger = data["trigger"]
	E.activated = data["activated"] ? 1 : 0
	E.chargelevel = data["chargelevel"]
	E.chargelevelmax = data["chargelevelmax"]
	E.artifact_id = data["artifact_id"]
	E.effect_type = data["effect_type"]
	return E

/singleton/persistent_type/generic/xenoarch_artifacts/proc/serialize_artifact(obj/structure/machinery/artifact/A, in_container = FALSE)
	if(!istype(A))
		return null
	return list(
		"name" = A.name,
		"desc" = A.desc,
		"icon_num" = A.icon_num,
		"in_container" = !!in_container,
		"my_effect" = serialize_effect(A.my_effect),
		"secondary_effect" = serialize_effect(A.secondary_effect)
	)

/singleton/persistent_type/generic/xenoarch_artifacts/proc/spawn_artifact_from_data(turf/T, list/data)
	if(!T || !islist(data))
		return null
	var/obj/structure/machinery/artifact/A = new /obj/structure/machinery/artifact(T)
	A.persisted_loaded = TRUE
	QDEL_NULL(A.my_effect)
	QDEL_NULL(A.secondary_effect)
	A.name = data["name"] || initial(A.name)
	A.desc = data["desc"] || initial(A.desc)
	A.icon_num = text2num("[data["icon_num"]]") || 0
	A.my_effect = deserialize_effect(data["my_effect"], A)
	A.secondary_effect = deserialize_effect(data["secondary_effect"], A)
	var/active = A.my_effect?.activated ? 1 : 0
	A.icon_state = "ano[A.icon_num][active]"

	if(data["in_container"])
		var/obj/structure/anomaly_container/container = locate() in T
		if(container && !container.contained)
			container.contain(A)
	return A

/** Loads saved artifacts and spawns them on their respective anomaly scanner pads or inside containers on those pads. */
/singleton/persistent_type/generic/xenoarch_artifacts/initialization_hook()
	pad_register = list()
	artifacts_initialized = FALSE
	if(!SSpersistence.map_supports_persistence)
		return

	var/datum/persistent_generic/saved_generic = SSpersistence.genericLoad(/singleton/persistent_type/generic/xenoarch_artifacts, skip_caching = TRUE)
	var/list/saved_pads = saved_generic?.content?["pads"]
	for(var/obj/structure/machinery/artifact_scanpad/pad in world)
		CHECK_TICK
		var/turf/pad_turf = get_turf(pad)
		if(!pad_turf || !is_station_level(pad_turf.z))
			continue

		var/pad_id = "[pad_turf.x]-[pad_turf.y]-[pad_turf.z]"
		pad_register[pad_id] = pad
		var/list/artifact_data = saved_pads?[pad_id]
		if(islist(artifact_data))
			spawn_artifact_from_data(pad_turf, artifact_data)

	artifacts_initialized = TRUE

/** Saves any artifacts currently on anomaly scanner pads or inside anomaly containers on those pads. */
/singleton/persistent_type/generic/xenoarch_artifacts/finalization_hook()
	if(!artifacts_initialized)
		return

	var/list/all_pads = list()
	for(var/pad_id in pad_register)
		CHECK_TICK
		var/obj/structure/machinery/artifact_scanpad/pad = pad_register[pad_id]
		if(QDELETED(pad))
			continue
		var/turf/pad_turf = get_turf(pad)
		if(!pad_turf)
			continue

		var/obj/structure/anomaly_container/container = locate() in pad_turf
		if(container && istype(container.contained))
			all_pads[pad_id] = serialize_artifact(container.contained, in_container = TRUE)
		else
			var/obj/structure/machinery/artifact/A = locate() in pad_turf
			if(A)
				all_pads[pad_id] = serialize_artifact(A, in_container = FALSE)

	SSpersistence.genericSave(/singleton/persistent_type/generic/xenoarch_artifacts, list("pads" = all_pads))
