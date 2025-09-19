/area/exoplanet
	name = "\improper Planetary surface"
	ambience = list('sound/effects/wind/wind_2_1.ogg','sound/effects/wind/wind_2_2.ogg','sound/effects/wind/wind_3_1.ogg','sound/effects/wind/wind_4_1.ogg','sound/effects/wind/wind_4_2.ogg','sound/effects/wind/wind_5_1.ogg')
	always_unpowered = 1
	area_flags = AREA_FLAG_INDESTRUCTIBLE_TURFS|AREA_FLAG_IS_BACKGROUND
	is_outside = OUTSIDE_YES

/area/exoplanet/adhomai
	name = "Adhomian Wilderness"
	ambience = list('sound/effects/wind/tundra0.ogg', 'sound/effects/wind/tundra1.ogg', 'sound/effects/wind/tundra2.ogg', 'sound/effects/wind/spooky0.ogg', 'sound/effects/wind/spooky1.ogg')
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	area_blurb = "The freezing wind blows through the unforgiving Adhomian wilderness."

/area/exoplanet/barren
	name = "\improper Planetary surface"
	ambience = list('sound/effects/wind/wind_2_1.ogg','sound/effects/wind/wind_2_2.ogg','sound/effects/wind/wind_3_1.ogg','sound/effects/wind/wind_4_1.ogg','sound/effects/wind/wind_4_2.ogg','sound/effects/wind/wind_5_1.ogg')
	base_turf = /turf/simulated/floor/exoplanet/barren

/area/exoplanet/barren/asteroid
	name = "\improper Asteroid Surface"
	base_turf = /turf/simulated/floor/exoplanet/asteroid/ash

/area/exoplanet/barren/raskara
	name = "Raskara Surface"
	ambience = AMBIENCE_OTHERWORLDLY
	base_turf = /turf/simulated/floor/exoplanet/barren/raskara
	area_blurb = "The dark surface of the moon is quiet. The ambience is eerie."

/area/exoplanet/barren/burzsia
	name = "Burzsia Surface"

/area/exoplanet/barren/pid
	name = "Pid Surface"
	area_blurb = "The surface of this moon is lifeless and rocky - almost. A faint yellow light suffuses the ground, the dim glow of spores in bloom."

/area/exoplanet/crystal
	name = "\improper Planetary surface"
	ambience = AMBIENCE_SPACE
	base_turf = /turf/simulated/floor/exoplanet/crystal

/area/exoplanet/moghes //ambience and area_blurb are set on init
	name = "Moghes Wilderness"
	base_turf = /turf/simulated/floor/exoplanet/grass/moghes/dirt

/area/exoplanet/ouerea
	name = "Ouerea Wilderness"
	ambience = AMBIENCE_JUNGLE
	base_turf = /turf/simulated/floor/exoplanet/barren
	area_blurb = "Strange grasses beneath your feet, and a warm breeze in the air. The shapes of strange flying reptiles dart between the trees, their bright and clear calls drifting on the wind."

/area/exoplanet/desert
	ambience = list('sound/effects/wind/desert0.ogg','sound/effects/wind/desert1.ogg','sound/effects/wind/desert2.ogg','sound/effects/wind/desert3.ogg','sound/effects/wind/desert4.ogg','sound/effects/wind/desert5.ogg')
	base_turf = /turf/simulated/floor/exoplanet/desert

/area/exoplanet/grass
	base_turf = /turf/simulated/floor/exoplanet/grass
	ambience = list('sound/effects/wind/wind_2_1.ogg','sound/effects/wind/wind_2_2.ogg','sound/effects/wind/wind_3_1.ogg','sound/effects/wind/wind_4_1.ogg','sound/ambience/eeriejungle2.ogg','sound/ambience/eeriejungle1.ogg')

/area/exoplanet/grass/play_ambience(var/mob/living/L)
	..()
	if(L && L.client && (L.client.prefs.sfx_toggles & ASFX_AMBIENCE) && !L.ear_deaf)
		L.playsound_local(get_turf(L),sound('sound/ambience/jungle.ogg', repeat = 1, wait = 0, volume = 25, channel = CHANNEL_AMBIENCE))

/area/exoplanet/grass/grove
	base_turf = /turf/simulated/floor/exoplanet/grass/grove

/area/exoplanet/grass/konyang
	name = "Konyang Wilderness"
	base_turf = /turf/simulated/floor/exoplanet/konyang

/area/exoplanet/grass/xanu
	name = "Xanu Prime Wilderness"
	base_turf = /turf/simulated/floor/exoplanet/grass/stalk

/area/exoplanet/lava
	name = "\improper Planetary surface"
	ambience = AMBIENCE_LAVA
	base_turf = /turf/simulated/floor/exoplanet/basalt

/area/exoplanet/snow
	ambience = list('sound/effects/wind/tundra0.ogg','sound/effects/wind/tundra1.ogg','sound/effects/wind/tundra2.ogg','sound/effects/wind/spooky0.ogg','sound/effects/wind/spooky1.ogg')
	base_turf = /turf/simulated/floor/exoplanet/snow
