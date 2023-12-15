/datum/map/event/christmas
	name = "Christmas Chalet"
	full_name = "Xanan Christmas Village and Chalet"
	path = "event/christmas"
	lobby_icons = list('icons/misc/titlescreens/christmas/christmas.dmi')
	lobby_transitions = FALSE
	allowed_jobs = list(/datum/job/visitor)
	force_spawnpoint = TRUE

	station_levels = list(1)
	admin_levels = list()
	contact_levels = list(1)
	player_levels = list(1)
	accessible_z_levels = list(1)

	station_name = "to be done"
	station_short = "to be done"
	dock_name = "to be done"
	dock_short = "to be done"
	boss_name = "to be done"
	boss_short = "to be done"
	company_name = "Stellar Corporate Conglomerate"
	company_short = "SCC"

	use_overmap = FALSE

	allowed_spawns = list("Living Quarters Lift")
	spawn_types = list(/datum/spawnpoint/living_quarters_lift)
	default_spawn = "Living Quarters Lift"

// Pine Trees
/obj/structure/flora/tree/pine_tree/main
	name = "Pine Tree"
	desc = "A tall snow covered pine tree."
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"

/obj/structure/flora/tree/pine_tree/main/treetwo
	name = "Pine Tree"
	desc = "A tall snow covered pine tree."
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_2"

/obj/structure/flora/tree/pine_tree/main/treethree
	name = "Pine Tree"
	desc = "A tall snow covered pine tree."
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_3"

/obj/structure/flora/tree/pine_tree/main/christmas
	name = "Christmas Tree"
	desc = "A tall, full tree covered in magical lights!"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_c"

// lightpost
/obj/structure/lightpost
	name = "lightpost"
	desc = "A homely lightpost."
	icon = 'icons/holidays/christmas/lightpost.dmi'
	icon_state = "wreath_lamp"
	anchored = TRUE
	density = TRUE
	light_power = 0.8
	light_range = 6
	light_color = LIGHT_COLOR_CHRISTMAS

// Big ass christmas tree
/obj/structure/flora/tree/pine_tree/grandchristmas
	name = "Grand Christmas Tree"
	desc = "A grand christmas tree, you can't help but feel joy!"
	icon = 'icons/holidays/christmas/grandtree.dmi'
	icon_state = "grandtree"

// Pathway for the event
/turf/simulated/floor/cobble
	name = "Cobblestone Pathway"
	desc = "A seemingly hand designed, heated cobblestone pathway."
	icon = 'icons/holidays/christmas/cobblestone.dmi'
	icon_state = "cobble"
/obj/item/reagent_containers/food/snacks/cookie/gingerbread
	name = "Gingerbread Man"
	desc = "Run run run, as fast as you can.. You can't catch me.. I'm the Gingerbread man!"
	icon = 'icons/holidays/christmas/christmascookies.dmi'
	icon_state = "gingerbread_man"
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/sugar = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("cookie" = 2))
	bitesize = 1

/obj/item/reagent_containers/food/snacks/cookie/gingerbread/cane
	name = "Gingerbread Cane"
	desc = "For when Gingy' breaks his legs."
	icon = 'icons/holidays/christmas/christmascookies.dmi'
	icon_state = "gingerbread_cane"

/obj/item/reagent_containers/food/snacks/cookie/gingerbread/snowflake
	name = "Gingerbread Snowflake"
	desc = "For when the gingerbreadmans uncle disagrees with him at Christmas dinner."
	icon = 'icons/holidays/christmas/christmascookies.dmi'
	icon_state = "gingerbread_snowflake"

/obj/item/reagent_containers/food/snacks/cookie/gingerbread/tree
	name = "Gingerbread Tree"
	desc = "You stole Gingy's tree? Really? How rude."
	icon = 'icons/holidays/christmas/christmascookies.dmi'
	icon_state = "gingerbread_tree"

/obj/item/reagent_containers/food/snacks/cookie/gingerbread/bell
	name = "Gingerbread Bell"
	desc = "A gingerbread bell that has no relation to the Gingerbread man whatsoever..why is there a crack in it?"
	icon = 'icons/holidays/christmas/christmascookies.dmi'
	icon_state = "gingerbread_bell"

/obj/item/reagent_containers/food/snacks/cookie/gingerbread/horizon
	name = "Gingerbread Starship"
	desc = "A.. wait a minute- This is the Horizon! But in Cookie form! Yummy!"
	desc_extended = "A cookie of the SCCV Horizon.. Will I get in trouble for eating it?"
	icon = 'icons/holidays/christmas/christmascookies.dmi'
	icon_state = "gingerbread_horizon"

/obj/item/reagent_containers/food/snacks/cookie/gingerbread/random
	name = "Random Gingerbread Cookie"
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/sugar = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("cookie" = 2))

// christmas cookies tray
/obj/item/reagent_containers/food/snacks/chipplate/christmas_cookies
	name = "tray of christmas gingerbread cookies"
	desc = "A tray full of traditional Christmas cookies!"
	icon = 'icons/holidays/christmas/christmascookies.dmi'
	icon_state = "cookietray_100"
	trash = /obj/item/trash/cookietray
	vendingobject = /obj/item/reagent_containers/food/snacks/cookie/gingerbread
	reagent_data = list(/singleton/reagent/nutriment = list("cookie" = 1))
	bitesize = 1
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/sugar = 3)
	reagents_to_add = list(/singleton/reagent/nutriment = 20)
	unitname = "gingerbread cookie"
	filling_color = "#FCA03D"

/obj/item/reagent_containers/food/snacks/chipplate/christmas_cookies/update_icon()
	switch(reagents.total_volume)
		if(1 to 5)
			icon_state = "cookietray_25"
		if(6 to 10)
			icon_state = "cookietray_50"
		if(11 to 15)
			icon_state = "cookietray_75"
		if(16 to INFINITY)
			icon_state = "cookietray_100"

// EGGNOGG
/obj/structure/reagent_dispensers/keg/eggnog
	name = "Chilled Barrel of Eggnog"
	desc = "A chilled barrel of eggnog."
	icon_state = "woodkeg"
	reagents_to_add = list(/singleton/reagent/alcohol/eggnog = 1000)

// Snowman Statue
/obj/structue/snowman
	name = "Jolly Snowman"
	desc = "A well crafted snowman. It lt looks very happy!"
	icon = 'icons/holidays/christmas/props.dmi'
	icon_state = "snowman_hat"
	light_color = "#FAA019"
	light_power = 0.4
	light_range = 2
	anchored = TRUE
