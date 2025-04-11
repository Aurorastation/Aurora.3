/obj/effect/decal/cleanable/drawing
	name = "drawing"
	desc = "It's a drawing."
	anchored = 1

/obj/effect/decal/cleanable/drawing/crayon
	name = "rune"
	desc = "It's been drawn in crayon."
	icon = 'icons/obj/rune.dmi'

/obj/effect/decal/cleanable/drawing/draftingchalk
	name = "chalk marking"
	desc = "It's been drawn in chalk."
	icon = 'icons/obj/smooth/chalkline-smooth.dmi'
	icon_state = "preview"
	color = "#FFFFFF"
	smoothing_flags = SMOOTH_TRUE

/obj/effect/decal/cleanable/drawing/Initialize(mapload, main = "#FFFFFF", shade = "#000000", var/type = "rune", medium = "chalk")
	. = ..()

	if (mapload && medium == "chalk")
		QUEUE_SMOOTH
	else if (medium = "chalk")
		smooth_icon()
		for (var/obj/effect/decal/cleanable/drawing/C in orange(1, src))
			C.smooth_icon()

	name = type
	desc = "A [type] drawn in [medium]."

	switch(type)
		if("rune")
			type = "rune[rand(1,6)]"
		if("graffiti")
			type = pick("amyjon","face","matt","revolution","engie","guy","end","dwarf","uboa")
		if("line")
			for (var/obj/effect/decal/cleanable/drawing/C in target)
			qdel(C)

	if(type == "line")
			var/obj/effect/decal/cleanable/drawing/C = new(target)
			C.main = color
			target.add_fingerprint(user)

	if(type != "line")
		var/icon/mainOverlay = SSicon_cache.crayon_cache[type]
		if (!mainOverlay)
			mainOverlay = new/icon('icons/effects/crayondecal.dmi',"[type]",2.1)
			mainOverlay.Blend(main,ICON_ADD)
			SSicon_cache.crayon_cache[type] = mainOverlay
		var/icon/shadeOverlay = SSicon_cache.crayon_cache["[type]_s"]
		if (!shadeOverlay)
			shadeOverlay = new/icon('icons/effects/crayondecal.dmi',"[type]s",2.1)
			shadeOverlay.Blend(shade,ICON_ADD)
			SSicon_cache.crayon_cache["[type]_s"] = shadeOverlay
		AddOverlays(list(mainOverlay, shadeOverlay))

	add_hiddenprint(usr)