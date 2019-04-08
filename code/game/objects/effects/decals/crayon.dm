/obj/effect/decal/cleanable/crayon
	name = "rune"
	desc = "A rune drawn in crayon."
	icon = 'icons/obj/rune.dmi'
	layer = 2.1
	anchored = 1

/obj/effect/decal/cleanable/crayon/Initialize(mapload, main = "#FFFFFF", shade = "#000000", var/type = "rune")
	. = ..()

	name = type
	desc = "A [type] drawn in crayon."

	switch(type)
		if("rune")
			type = "rune[rand(1,6)]"
		if("graffiti")
			type = pick("amyjon","face","matt","revolution","engie","guy","end","dwarf","uboa")

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

	add_overlay(list(mainOverlay, shadeOverlay))

	add_hiddenprint(usr)
