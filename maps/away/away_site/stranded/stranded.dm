/datum/map_template/ruin/away_site/stranded
	name = "grove planet with escape pods"
	description = "Automated emergency distress signals are being emitted from this grove planet. They appear to be coming from two escape pods currently landed there. Scans also indicate irregular bluespace activity within the exosphere."
	suffixes = list("away_site/stranded/stranded.dmm")
	sectors = list(SECTOR_BADLANDS)
	spawn_weight = 1
	spawn_cost = 2
	id = "stranded"

/singleton/submap_archetype/stranded
	map = "grove planet with escape pods"
	descriptor = "Automated emergency distress signals are being emitted from this grove planet. They appear to be coming from two escape pods currently landed there. Scans also indicate irregular bluespace activity within the exosphere."

/obj/effect/overmap/visitable/sector/stranded
	name = "grove planet with escape pods"
	desc = "Automated emergency distress signals are being emitted from this grove planet. They appear to be coming from two escape pods currently landed there. Scans also indicate irregular bluespace activity within the exosphere."

/area/stranded
	name="survivor planet"
	icon_state = "outpost_mine_main"
	requires_power = FALSE
	flags = HIDE_FROM_HOLOMAP

/area/stranded/forest
	name="forest"
	icon_state = "outpost_mine_main"
	requires_power = FALSE
	flags = HIDE_FROM_HOLOMAP

/area/stranded/forest/play_ambience(var/mob/living/L)
	..()
	if(L && L.client && (L.client.prefs.sfx_toggles & ASFX_AMBIENCE) && !L.ear_deaf)
		sound_to(L, sound('sound/ambience/spooky_jungle.ogg', repeat = 1, wait = 0, volume = 15, channel = 1))

/area/stranded/forest/Exited(var/mob/living/L, atom/newarea)
	if(!istype(newarea, /area/stranded/forest))
		sound_to(L, sound(null, channel = 1))
	..()

/area/stranded/forest/Entered(var/mob/abstract/observer/O) //This stops people from having to hear the ambience in case they die and observe.
	sound_to(O, sound(null, channel = 1))
	..()

area/stranded/hut
	name="survivor hut"
	icon_state = "dark"
	requires_power = FALSE
	flags = HIDE_FROM_HOLOMAP

area/stranded/cabin
	name="strange cabin"
	icon_state = "dark"
	requires_power = FALSE
	flags = HIDE_FROM_HOLOMAP
	music = list('sound/ambience/ghostly/ghostly1.ogg')

area/stranded/cave
	name="cave"
	icon_state = "mining"
	flags = HIDE_FROM_HOLOMAP
	requires_power = FALSE
