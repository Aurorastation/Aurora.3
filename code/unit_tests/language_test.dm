/datum/unit_test/language_test
	name = "Language Test - Repeated Keys"
	groups = list("generic", "language")

/datum/unit_test/language_test/start_test()
	var/list/used_keys = list()

	for(var/language_path in subtypesof(/datum/language))
		var/datum/language/L = new language_path
		if(L.key in used_keys)
			TEST_FAIL("[L.name]'s key, [L.key], is used multiple times!")
			continue
		used_keys += L.key

	if(!reported)
		TEST_PASS("All languages have unique keys.")

	return TRUE

/datum/unit_test/lore_radio_language
	name = "Language Test - Lore Radio Lines"
	groups = list("generic", "language")

/datum/unit_test/lore_radio_language/start_test()
	var/datum/lore_radio_broadcast/tagged = parse_lore_radio_broadcast("\[LANGUAGE=Siik'maas\] \[RANDOMNOTE\]A song lyric\[RANDOMNOTE\]")
	TEST_ASSERT(tagged.language == GLOB.all_languages[LANGUAGE_SIIK_MAAS], "Lore radio line did not resolve its language tag.")
	var/regex/song_line = regex("^\[♩♪♫\] A song lyric \[♩♪♫\]$")
	TEST_ASSERT(song_line.Find(tagged.message), "Lore radio line did not replace RANDOMNOTE markers while preserving the lyrics.")
	var/regex/scrambled_song_line = regex("^\[♩♪♫\] .+ \[♩♪♫\]$")
	TEST_ASSERT(scrambled_song_line.Find(tagged.language.scramble(tagged.message, list())), "Lore radio language scrambling modified the musical note markers.")

	var/datum/lore_radio_broadcast/untagged = parse_lore_radio_broadcast("A Common broadcast line.")
	TEST_ASSERT(!untagged.language, "Untagged lore radio line unexpectedly received a language.")
	TEST_ASSERT(untagged.message == "A Common broadcast line.", "Untagged lore radio line was modified.")

	if(!reported)
		TEST_PASS("Lore radio language tags parsed correctly.")

	return TRUE
