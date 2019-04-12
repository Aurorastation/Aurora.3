/turf/simulated/floor/plating/cobblestone
	name = "cobblestone"
	icon = 'icons/adhomai/turfs.dmi'
	icon_state = "cobble_horizontal"

/turf/simulated/floor/plating/cobblestone/dark
	name = "cobblestone"
	icon = 'icons/adhomai/turfs.dmi'
	icon_state = "cobble_horizontal_dark"

/turf/simulated/floor/plating/cobblestone/vertical
	name = "cobblestone"
	icon = 'icons/adhomai/turfs.dmi'
	icon_state = "cobble_vertical"

/turf/simulated/floor/plating/cobblestone/vertical/dark
	name = "cobblestone"
	icon = 'icons/adhomai/turfs.dmi'
	icon_state = "cobble_vertical_dark"

/turf/simulated/floor/plating/road
	name = "road"
	icon = 'icons/adhomai/turfs.dmi'
	icon_state = "road_1"

/obj/effect/floor_decal/borderfloor
	name = "curb"
	icon = 'icons/adhomai/effects.dmi'
	icon_state = "borderfloor"

/obj/effect/floor_decal/borderfloor/corner
	icon = 'icons/adhomai/effects.dmi'
	icon_state = "borderfloorcorner"

/obj/structure/barricade/fence
	name = "wooden fence"
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "1"
	health = 100
	maxhealth = 100

/obj/structure/barricade/fence/New()
	icon_state = "[rand(1,3)]"

/obj/structure/barricade/chainlink
	name = "chainlink fence"
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "chainfence"
	health = 300
	maxhealth = 300

/obj/structure/sign/greencross/adhomai
	name = "clinic"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "greencross"
	icon = 'icons/adhomai/structures.dmi'

/obj/structure/sign/examroom/adhomai
	name = "\improper EXAM"
	desc = "A guidance sign which reads 'EXAM ROOM'."
	icon_state = "examroom"
	icon = 'icons/adhomai/structures.dmi'

/obj/structure/adhomai/loudspeaker
	name = "\improper loudspeaker"
	desc = "A speaker. Quite loud. Almost too clever, isn't it."
	icon = 'icons/adhomai/radios.dmi'
	icon_state = "loudspeaker"