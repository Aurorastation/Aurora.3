/datum/map_template/ruin/away_site/grand_romanovich
	name = "Grand Romanovich Casino"
	description = "An adhomian style casino in Tau Ceti's space."
	suffix = "away_site/romanovich/grand_romanovich.dmm"
	sectors = list(SECTOR_ROMANOVICH)
	spawn_weight = 1
	ship_cost = 2
	id = "grand_romanovich"

/singleton/submap_archetype/grand_romanovich
	map = "Grand Romanovich Casino"
	descriptor = "An adhomian style casino in Tau Ceti's space."

/obj/effect/overmap/visitable/sector/grand_romanovich
	name = "Grand Romanovich Casino"
	desc = "An adhomian style casino in Tau Ceti's space."

	comms_support = TRUE
	comms_name = "casino"
	use_common = TRUE

/area/grand_romanovich
	flags = HIDE_FROM_HOLOMAP
	name = "Grand Romanovich Casino"
	icon_state = "away"
	requires_power = FALSE
	base_turf = /turf/space
	no_light_control = TRUE

/area/grand_romanovich/outdoors
	name = "Grand Romanovich Casino - Outdoors"
	icon_state = "away1"
	ambience = AMBIENCE_WINDY

//items
/obj/structure/casino/roulette
	name = "roulette"
	desc = "Spin the roulette to try your luck."
	icon = 'icons/obj/casino.dmi'
	icon_state = "roulette_r"
	density = TRUE
	anchored = TRUE
	var/busy= FALSE

/obj/structure/casino/roulette/attack_hand(mob/user as mob)
	if (busy)
		to_chat(user, SPAN_NOTICE("You cannot spin now! \The [src] is already spinning."))
		return
	visible_message(SPAN_NOTICE("\The [user] spins the roulette and throws inside little ball."))
	busy = TRUE
	var/n = rand(0,36)
	var/color = "green"
	add_fingerprint(user)
	if ((n>0 && n<11) || (n>18 && n<29))
		if (n%2)
			color="red"
	else
		color="black"
	if ( (n>10 && n<19) || (n>28) )
		if (n%2)
			color="black"
	else
		color="red"
	addtimer(CALLBACK(src, .proc/give_result, n, color), 5 SECONDS)


/obj/structure/casino/roulette/proc/give_result(var/n, var/color)
	visible_message(SPAN_NOTICE("\The [src] stops spinning, the ball landing on [n], [color]."))
	busy= FALSE

/obj/structure/casino/roulette_chart
	name = "roulette chart"
	desc = "Roulette chart. Place your bets!"
	icon = 'icons/obj/casino.dmi'
	icon_state = "roulette_l"
	density = 1
	anchored = 1

/obj/structure/casino/attackby(obj/item/W as obj, mob/user as mob, var/click_parameters)
	if (!W) return

	if(user.unEquip(W, 0, src.loc))
		user.make_item_drop_sound(W)
		return 1

/obj/item/coin/casino
	name = "grand romanovich casino chip"
	icon = 'icons/obj/casino.dmi'
	icon_state = "casino_coin"

/obj/item/coin/casino/attack_self(mob/user as mob)
	return

/obj/item/storage/bag/money/casino/Initialize()
	..()
	new /obj/item/coin/casino(src)
	new /obj/item/coin/casino(src)
	new /obj/item/coin/casino(src)
	new /obj/item/coin/casino(src)
