/area/exoplanet
	name = "\improper Planetary surface"
	ambience = list('sound/effects/wind/wind_2_1.ogg','sound/effects/wind/wind_2_2.ogg','sound/effects/wind/wind_3_1.ogg','sound/effects/wind/wind_4_1.ogg','sound/effects/wind/wind_4_2.ogg','sound/effects/wind/wind_5_1.ogg')
	always_unpowered = 1
	area_flags = AREA_FLAG_INDESTRUCTIBLE_TURFS|AREA_FLAG_IS_BACKGROUND
	is_outside = OUTSIDE_YES

/area/exoplanet/adhomai
	name = "Adhomian Wilderness"
	ambience = list('sound/effects/wind/tundra0.ogg', 'sound/effects/wind/tundra1.ogg', 'sound/effects/wind/tundra2.ogg', 'sound/effects/wind/spooky0.ogg', 'sound/effects/wind/spooky1.ogg')
	area_blurb = "The freezing wind blows through the unforgiving Adhomian wilderness."

/area/exoplanet/barren
	name = "\improper Planetary surface"
	ambience = list('sound/effects/wind/wind_2_1.ogg','sound/effects/wind/wind_2_2.ogg','sound/effects/wind/wind_3_1.ogg','sound/effects/wind/wind_4_1.ogg','sound/effects/wind/wind_4_2.ogg','sound/effects/wind/wind_5_1.ogg')

/area/exoplanet/barren/asteroid
	name = "\improper Asteroid Surface"

/area/exoplanet/barren/raskara
	name = "Raskara Surface"
	ambience = AMBIENCE_OTHERWORLDLY
	area_blurb = "The dark surface of the moon is quiet. The ambience is eerie."

/area/exoplanet/barren/burzsia
	name = "Burzsia Surface"

/area/exoplanet/barren/pid
	name = "Pid Surface"
	area_blurb = "The surface of this moon is lifeless and rocky - almost. A faint yellow light suffuses the ground, the dim glow of spores in bloom."

/area/exoplanet/crystal
	name = "\improper Planetary surface"
	ambience = AMBIENCE_SPACE

/area/exoplanet/moghes //ambience and area_blurb are set on init
	name = "Moghes Wilderness"

/area/exoplanet/ouerea
	name = "Ouerea Wilderness"
	ambience = AMBIENCE_JUNGLE
	area_blurb = "Strange grasses beneath your feet, and a warm breeze in the air. The shapes of strange flying reptiles dart between the trees, their bright and clear calls drifting on the wind."

/area/exoplanet/desert
	ambience = list('sound/effects/wind/desert0.ogg','sound/effects/wind/desert1.ogg','sound/effects/wind/desert2.ogg','sound/effects/wind/desert3.ogg','sound/effects/wind/desert4.ogg','sound/effects/wind/desert5.ogg')

/area/exoplanet/grass
	ambience = list('sound/effects/wind/wind_2_1.ogg','sound/effects/wind/wind_2_2.ogg','sound/effects/wind/wind_3_1.ogg','sound/effects/wind/wind_4_1.ogg','sound/ambience/eeriejungle2.ogg','sound/ambience/eeriejungle1.ogg')

/area/exoplanet/grass/play_ambience(var/mob/living/L)
	..()
	if(L && L.client && (L.client.prefs.sfx_toggles & ASFX_AMBIENCE) && !L.ear_deaf)
		L.playsound_local(get_turf(L),sound('sound/ambience/jungle.ogg', repeat = 1, wait = 0, volume = 25, channel = CHANNEL_AMBIENCE))

/area/exoplanet/grass/grove

/area/exoplanet/grass/konyang
	name = "Konyang Wilderness"

/area/exoplanet/grass/xanu
	name = "Xanu Prime Wilderness"

/area/exoplanet/lava
	name = "\improper Planetary surface"
	ambience = AMBIENCE_LAVA

/area/exoplanet/snow
	ambience = list('sound/effects/wind/tundra0.ogg','sound/effects/wind/tundra1.ogg','sound/effects/wind/tundra2.ogg','sound/effects/wind/spooky0.ogg','sound/effects/wind/spooky1.ogg')
