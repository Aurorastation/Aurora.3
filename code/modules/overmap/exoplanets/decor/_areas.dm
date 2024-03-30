/area/exoplanet
	name = "\improper Planetary surface"
	ambience = list('sound/effects/wind/wind_2_1.ogg','sound/effects/wind/wind_2_2.ogg','sound/effects/wind/wind_3_1.ogg','sound/effects/wind/wind_4_1.ogg','sound/effects/wind/wind_4_2.ogg','sound/effects/wind/wind_5_1.ogg')
	always_unpowered = 1
	area_flags = AREA_FLAG_INDESTRUCTIBLE_TURFS
	is_outside = OUTSIDE_YES

/area/exoplanet/adhomai
	name = "Adhomian Wilderness"
	ambience = list('sound/effects/wind/tundra0.ogg', 'sound/effects/wind/tundra1.ogg', 'sound/effects/wind/tundra2.ogg', 'sound/effects/wind/spooky0.ogg', 'sound/effects/wind/spooky1.ogg')
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai

/area/exoplanet/barren
	name = "\improper Planetary surface"
	ambience = list('sound/effects/wind/wind_2_1.ogg','sound/effects/wind/wind_2_2.ogg','sound/effects/wind/wind_3_1.ogg','sound/effects/wind/wind_4_1.ogg','sound/effects/wind/wind_4_2.ogg','sound/effects/wind/wind_5_1.ogg')
	base_turf = /turf/simulated/floor/exoplanet/barren

/area/exoplanet/barren/asteroid
	name = "\improper Asteroid Surface"
	base_turf = /turf/unsimulated/floor/asteroid/ash

/area/exoplanet/barren/raskara
	name = "Raskara Surface"
	ambience = AMBIENCE_OTHERWORLDLY
	base_turf = /turf/simulated/floor/exoplanet/barren/raskara

/area/exoplanet/barren/burzsia
	name = "Burzsia Surface"

/area/exoplanet/crystal
	name = "\improper Planetary surface"
	ambience = AMBIENCE_SPACE
	base_turf = /turf/simulated/floor/exoplanet/crystal

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

/area/exoplanet/lava
	name = "\improper Planetary surface"
	ambience = AMBIENCE_LAVA
	base_turf = /turf/unsimulated/floor/asteroid/basalt

/area/exoplanet/snow
	ambience = list('sound/effects/wind/tundra0.ogg','sound/effects/wind/tundra1.ogg','sound/effects/wind/tundra2.ogg','sound/effects/wind/spooky0.ogg','sound/effects/wind/spooky1.ogg')
	base_turf = /turf/simulated/floor/exoplanet/snow
