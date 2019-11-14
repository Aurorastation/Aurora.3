/datum/design/item/mecha
	build_type = MECHFAB
	category = "Exosuit Equipment"
	time = 10
	materials = list(DEFAULT_WALL_MATERIAL = 10000)

/datum/design/item/mecha/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a '[item_name]' exosuit module."

/datum/design/item/mecha/tracking
	name = "Exosuit tracking beacon"
	id = "exotrack"
	build_type = MECHFAB
	time = 5
	materials = list(DEFAULT_WALL_MATERIAL = 500)
	build_path = /obj/item/mecha_parts/mecha_tracking

/datum/design/item/mecha/tracking/control
	name = "Exosuit control beacon"
	id = "exocontrol"
	time = 30
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/mecha_parts/mecha_tracking/control