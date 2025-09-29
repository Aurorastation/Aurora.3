/// Track datums, used in jukeboxes
/datum/track
	/// Readable name, used in the jukebox menu
	var/song_name = "Generic"
	/// Filepath of the song
	var/song_path
	/// How long is the song in deciseconds. Default is an arbitrary low value, should be overwritten.
	var/song_length = 10 SECONDS
	/// What cartridge (if any) this song came from.
	var/source

// Default track supplied for testing and also because it's a banger
/datum/track/default
	song_name = "Tintin on the Moon"
	song_path = 'sound/music/ingame/ss13/title3.ogg'
	song_length = 3 MINUTES + 52 SECONDS

/obj/item/music_cartridge
	name = "music cartridge"
	desc = "A music cartridge."
	icon = 'icons/obj/item/music_cartridges.dmi'
	icon_state = "generic"
	w_class = WEIGHT_CLASS_SMALL
	var/list/datum/track/tracks
	/// Whether or not this cartridge can be removed from the datum/jukebox it belongs to.
	var/hardcoded = FALSE

/obj/item/music_cartridge/ss13
	name = "Spacer Classics Vol. 1"
	desc = "An old music cartridge with a cheap-looking label."
	tracks = list(
		new/datum/track("Scratch", 'sound/music/ingame/ss13/title1.ogg', 2 MINUTES + 30 SECONDS, /obj/item/music_cartridge/ss13),
		new/datum/track("D`Bert", 'sound/music/ingame/ss13/title2.ogg', 1 MINUTES + 58 SECONDS, /obj/item/music_cartridge/ss13),
		new/datum/track("Uplift", 'sound/music/ingame/ss13/title3.ogg', 3 MINUTES + 52 SECONDS, /obj/item/music_cartridge/ss13),
		new/datum/track("Uplift II", 'sound/music/ingame/ss13/title3mk2.ogg', 3 MINUTES + 59 SECONDS, /obj/item/music_cartridge/ss13),
		new/datum/track("Suspenseful", 'sound/music/ingame/ss13/traitor.ogg', 5 MINUTES + 30 SECONDS, /obj/item/music_cartridge/ss13),
		new/datum/track("Beyond", 'sound/music/ingame/ss13/ambispace.ogg', 3 MINUTES + 15 SECONDS, /obj/item/music_cartridge/ss13),
		new/datum/track("D`Fort", 'sound/music/ingame/ss13/song_game.ogg', 3 MINUTES + 50 SECONDS, /obj/item/music_cartridge/ss13),
		new/datum/track("Endless Space", 'sound/music/ingame/ss13/space.ogg', 3 MINUTES + 33 SECONDS, /obj/item/music_cartridge/ss13),
		new/datum/track("Thunderdome", 'sound/music/ingame/ss13/THUNDERDOME.ogg', 3 MINUTES + 22 SECONDS, /obj/item/music_cartridge/ss13)
	)
// Hardcoded variant
/obj/item/music_cartridge/ss13/demo
	hardcoded = TRUE

/obj/item/music_cartridge/audioconsole
	name = "SCC Welcome Package"
	desc = "A music cartridge with some company-selected songs. Nothing special, everyone got one of these in their welcome boxes..."
	tracks = list(
		new/datum/track("Butterflies", 'sound/music/ingame/scc/Butterflies.ogg', 3 MINUTES + 37 SECONDS, /obj/item/music_cartridge/audioconsole),
		new/datum/track("That Ain't Chopin", 'sound/music/ingame/scc/ThatAintChopin.ogg', 3 MINUTES + 29 SECONDS, /obj/item/music_cartridge/audioconsole),
		new/datum/track("Don't Rush", 'sound/music/ingame/scc/DontRush.ogg', 3 MINUTES + 56 SECONDS, /obj/item/music_cartridge/audioconsole),
		new/datum/track("Phoron Will Make Us Rich", 'sound/music/ingame/scc/PhoronWillMakeUsRich.ogg', 2 MINUTES + 14 SECONDS, /obj/item/music_cartridge/audioconsole),
		new/datum/track("Amsterdam", 'sound/music/ingame/scc/Amsterdam.ogg', 3 MINUTES + 42 SECONDS, /obj/item/music_cartridge/audioconsole),
		new/datum/track("When", 'sound/music/ingame/scc/When.ogg', 2 MINUTES + 41 SECONDS, /obj/item/music_cartridge/audioconsole),
		new/datum/track("Number 0", 'sound/music/ingame/scc/Number0.ogg', 2 MINUTES + 37 SECONDS, /obj/item/music_cartridge/audioconsole),
		new/datum/track("The Pianist", 'sound/music/ingame/scc/ThePianist.ogg', 4 MINUTES + 25 SECONDS, /obj/item/music_cartridge/audioconsole),
		new/datum/track("Lips", 'sound/music/ingame/scc/Lips.ogg', 3 MINUTES + 20 SECONDS, /obj/item/music_cartridge/audioconsole),
		new/datum/track("Childhood", 'sound/music/ingame/scc/Childhood.ogg', 2 MINUTES + 13 SECONDS, /obj/item/music_cartridge/audioconsole)
	)
// Hardcoded variant
/obj/item/music_cartridge/audioconsole/demo
	hardcoded = TRUE

/obj/item/music_cartridge/konyang_retrowave
	name = "Konyang Vibes 2463"
	desc = "A music cartridge with a Konyang flag on the hololabel."
	icon_state = "konyang"
	tracks = list(
		new/datum/track("Konyang Vibes #1", 'sound/music/ingame/konyang/konyang-1.ogg', 2 MINUTES + 59 SECONDS, /obj/item/music_cartridge/konyang_retrowave),
		new/datum/track("Konyang Vibes #2", 'sound/music/ingame/konyang/konyang-2.ogg', 2 MINUTES + 58 SECONDS, /obj/item/music_cartridge/konyang_retrowave),
		new/datum/track("Konyang Vibes #3", 'sound/music/ingame/konyang/konyang-3.ogg', 2 MINUTES + 43 SECONDS, /obj/item/music_cartridge/konyang_retrowave),
		new/datum/track("Konyang Vibes #4", 'sound/music/ingame/konyang/konyang-4.ogg', 3 MINUTES + 8 SECONDS, /obj/item/music_cartridge/konyang_retrowave)
	)
// Hardcoded variant
/obj/item/music_cartridge/konyang_retrowave/demo
	hardcoded = TRUE

/obj/item/music_cartridge/venus_funkydisco
	name = "Top of the Charts 66 (Venusian Hits)"
	desc = "A glitzy, pink music cartridge with more Venusian hits."
	icon_state = "venus"
	tracks = list(
		new/datum/track("dance させる", 'sound/music/ingame/venus/dance.ogg', 3 MINUTES + 19 SECONDS, /obj/item/music_cartridge/venus_funkydisco),
		new/datum/track("love sensation", 'sound/music/ingame/venus/love_sensation.ogg', 3 MINUTES + 31 SECONDS, /obj/item/music_cartridge/venus_funkydisco),
		new/datum/track("All Night", 'sound/music/ingame/venus/all_night.ogg', 3 MINUTES + 11 SECONDS, /obj/item/music_cartridge/venus_funkydisco),
		new/datum/track("#billyocean", 'sound/music/ingame/venus/billy_ocean.ogg', 4 MINUTES + 19 SECONDS, /obj/item/music_cartridge/venus_funkydisco),
		new/datum/track("Artificially Sweetened", 'sound/music/ingame/venus/artificially_sweetened.ogg', 4 MINUTES + 18 SECONDS, /obj/item/music_cartridge/venus_funkydisco),
		new/datum/track("Real Love", 'sound/music/ingame/venus/real_love.ogg', 3 MINUTES + 52 SECONDS, /obj/item/music_cartridge/venus_funkydisco),
		new/datum/track("F U N K Y G I R L <3", 'sound/music/ingame/venus/funky_girl.ogg', 2 MINUTES + 2 SECONDS, /obj/item/music_cartridge/venus_funkydisco),
		new/datum/track("Break The System", 'sound/music/ingame/venus/break_the_system.ogg', 1 MINUTES + 23 SECONDS, /obj/item/music_cartridge/venus_funkydisco)
	)

/obj/item/music_cartridge/xanu_rock
	name = "Indulgence EP (X-Rock)" //feel free to reflavour as a more varied x-rock mixtape, instead of a single EP, if other x-rock tracks are added
	desc = "A music cartridge with a Xanan flag on the hololabel. Some fancy, rainbow text over it reads, 'INDULGENCE'."
	icon_state = "xanu"
	tracks = list(
		new/datum/track("Rise", 'sound/music/ingame/xanu/xanu_rock_1.ogg', 3 MINUTES + 3 SECONDS, /obj/item/music_cartridge/xanu_rock),
		new/datum/track("Indulgence", 'sound/music/ingame/xanu/xanu_rock_2.ogg', 3 MINUTES + 7 SECONDS, /obj/item/music_cartridge/xanu_rock),
		new/datum/track("Shimmer", 'sound/music/ingame/xanu/xanu_rock_3.ogg', 4 MINUTES + 30 SECONDS, /obj/item/music_cartridge/xanu_rock)
	)

/obj/item/music_cartridge/adhomai_swing
	name = "Electro-Swing of Adhomai"
	desc = "A red music cartridge holding the most widely-known Adhomian electro-swing songs."
	icon_state = "adhomai"
	tracks = list(
		new/datum/track("Boolean Sisters", 'sound/music/ingame/adhomai/boolean_sisters.ogg', 3 MINUTES + 17 SECONDS, /obj/item/music_cartridge/adhomai_swing),
		new/datum/track("Electro Swing", 'sound/music/ingame/adhomai/electro_swing.ogg', 3 MINUTES + 18 SECONDS, /obj/item/music_cartridge/adhomai_swing),
		new/datum/track("Le Swing", 'sound/music/ingame/adhomai/le_swing.ogg', 2 MINUTES + 11 SECONDS, /obj/item/music_cartridge/adhomai_swing),
		new/datum/track("Posin", 'sound/music/ingame/adhomai/posin.ogg', 2 MINUTES + 50 SECONDS, /obj/item/music_cartridge/adhomai_swing)
	)
// Hardcoded variant
/obj/item/music_cartridge/adhomai_swing/demo
	hardcoded = TRUE

/obj/item/music_cartridge/europa_various
	name = "Europa: Best of the 50s"
	desc = "A music cartridge storing the best tracks to listen to on a submarine dive."
	tracks = list(
		new/datum/track("Where The Rays Leap", 'sound/music/ingame/europa/where_the_dusks_rays_leap.ogg', 3 MINUTES + 41 SECONDS, /obj/item/music_cartridge/europa_various),
		new/datum/track("Casting Faint Shadows", 'sound/music/ingame/europa/casting_faint_shadows.ogg', 8 MINUTES + 56 SECONDS, /obj/item/music_cartridge/europa_various),
		new/datum/track("Weedance", 'sound/music/ingame/europa/weedance.ogg', 7 MINUTES + 35 SECONDS, /obj/item/music_cartridge/europa_various),
		new/datum/track("Instrumental Park", 'sound/music/ingame/europa/instrumental_park.ogg', 5 MINUTES + 39 SECONDS, /obj/item/music_cartridge/europa_various),
		new/datum/track("Way Between The Shadows", 'sound/music/ingame/europa/way_between_the_shadows.ogg', 8 MINUTES + 21 SECONDS, /obj/item/music_cartridge/europa_various),
		new/datum/track("Deep Beneath the Solemn Waves a Vast Underwater Landscape, Brimming With Bizarre, Eerily Gleaming Cyclopean Structures of, What Must Surely Be, Non-Human Origin, Stretched Out Across the Ocean Floor", 'sound/music/ingame/europa/deep_beneath-.ogg', 7 MINUTES + 18 SECONDS, /obj/item/music_cartridge/europa_various)
	)
