/datum/map/event/rooftop
	name = "Rooftop"
	full_name = "Mendell City Rooftop"
	path = "event/rooftop"
	lobby_icon_image_paths = list(
								list('icons/misc/titlescreens/tajara/taj1.png', 'icons/misc/titlescreens/tajara/taj2.png', 'icons/misc/titlescreens/tajara/taj3.png', 'icons/misc/titlescreens/tajara/taj4.png', 'icons/misc/titlescreens/tajara/Ghostsofwar.png', 'icons/misc/titlescreens/tajara/crack.png', 'icons/misc/titlescreens/tajara/blind_eye.png', 'icons/misc/titlescreens/tajara/RoyalGrenadier.png', 'icons/misc/titlescreens/tajara/For_the_King.png'),
								list('icons/misc/titlescreens/synths/baseline.png', 'icons/misc/titlescreens/synths/bishop.png', 'icons/misc/titlescreens/synths/g2.png', 'icons/misc/titlescreens/synths/shell.png', 'icons/misc/titlescreens/synths/zenghu.png', 'icons/misc/titlescreens/synths/hazelchibi.png'),
								list('icons/misc/titlescreens/vaurca/cthur.png', 'icons/misc/titlescreens/vaurca/klax.png', 'icons/misc/titlescreens/vaurca/liidra.png', 'icons/misc/titlescreens/vaurca/zora.png'),
								list('icons/misc/titlescreens/space/odin.png', 'icons/misc/titlescreens/space/starmap.png', 'icons/misc/titlescreens/space/undocking.png', 'icons/misc/titlescreens/space/voyage.png')
								)
	allowed_jobs = list(/datum/job/visitor)

	admin_levels = list()
	contact_levels = list(1)
	player_levels = list(1)
	accessible_z_levels = list(1)

	station_name = "The Montparnasse"
	station_short = "Montparnasse"
	dock_name = "conglomerate spaceport"
	boss_name = "Idris Incorporated"
	boss_short = "Idris"
	company_name = "Idris Incorporated"
	company_short = "Idris"

	use_overmap = FALSE

	map_shuttles = list(
		/datum/shuttle/autodock/ferry/city
	)

/obj/item/paper/fluff/rooftop/vr_prep
	name = "VR Introduction Slip"
	info = "Welcome to your very own VR preparation room! You can customize your virtual reality avatar here. Once ready, head out to the Game Selection Hall, where you can head out on your customized adventure! Have fun!"

/obj/item/paper/fluff/rooftop/medal_of_valor
	name = "medal of valor intro sheet"
	info = "This stage is for the MEDAL OF VALOR 2 alpha gameplay demo! Please enter your respective team's chair for balance reasons. Do not use the enemy team's base ingame! Remember, sharing is caring!"

/obj/item/paper/fluff/rooftop/medal_of_valor_nopush
	name = "Medal of Valor 2 Introduction Slip"
	info = "Welcome to MEDAL OF VALOR 2 gameplay demo. You've entered your teams respective base. Proceed to the fighting! Do not push into the enemy's base under any circumstances! Remember, have fun!"
