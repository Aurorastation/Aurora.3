/datum/map_template/ruin/away_site/shady
	name = "shady asteroid"
	description = "An asteroid with a hangar carved out inside it. Scans detect an unregistered structure within, with multiple lifeforms present."
	suffixes = list("away_site/shady/shady.dmm")
	sectors = list(SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS)
	sectors_blacklist = list(SECTOR_BURZSIA, SECTOR_HANEUNIM)
	spawn_weight = 1
	spawn_cost = 1
	id = "shady"

	unit_test_groups = list(1)

/singleton/submap_archetype/shady
	map = "shady asteroid"
	descriptor = "An asteroid with a hangar carved out inside it. Scans detect an unregistered structure within, with multiple lifeforms present."

/obj/effect/overmap/visitable/sector/shady
	name = "shady asteroid"
	desc = "An asteroid with a hangar carved out inside it. Scans detect an unregistered structure within, with multiple lifeforms present."
	icon_state = "object"

/area/hideout
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	name = "hideout outpost"
	icon_state = "outpost_mine_main"
	requires_power = FALSE

/obj/item/paper/shady/diarypage
	name = "torn diary page"
	info = "Some of the guys say they have been hearing a chittering sound from outside the walls lately. Bunch of delusional wimps, its a damn good thing every ship we've hit have been pushovers too. God knows I wouldn't wanna rely on this crew to get out of a hairy situation..."

/obj/item/paper/shady/printedmessage
	name = "printed paper"
	info = "The target is an Orion Express transport vessel. And get this, our little bird says it has twenty canisters of phoron on it. Onboard security has already been bribed, easy in and out gig for you and your crew. We'll send you their schedule tomorrow, be ready."

/obj/item/paper/shady/researchpaper
	name = "paper"
	info = "About those bones we found when we were carving this place out, I'm finally starting to put them in the right places. Still not sure what the hell it could be though, some sort of spectral eel, possibly. Gonna have to ask the boys to head out to another asteroid and bag one at some point so we can compare the skeletal structure. If they ever get time off from all those phoron heists..."
