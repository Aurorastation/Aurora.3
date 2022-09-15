/datum/map_template/ruin/away_site/blueriver
	name = "Bluespace River"
	id = "awaysite_blue"
	spawn_cost = 1
	spawn_weight = 1
	description = "An arctic planet and an alien underground surface."
	suffix = list("blueriver/blueriver-1.dmm", "blueriver/blueriver-2.dmm")
	generate_mining_by_z = 2
	sectors = list(SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_SRANDMARR, SECTOR_GAKAL)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/decl/submap_archetype/blueriver
	map = "bluespace river"
	descriptor = "An arctic planet and an alien underground surface."

/obj/effect/overmap/visitable/sector/arcticplanet
	name = "arctic planetoid"
	desc = "Sensor array detects an arctic planet with a small vessel on the planet's surface. Scans further indicate strange energy emissions from below the planet's surface."
	in_space = FALSE
	icon_state = "globe"
	initial_generic_waypoints = list(
		"nav_blueriv_1",
		"nav_blueriv_2",
		"nav_blueriv_3",
		"nav_blueriv_antag"
	)

/obj/effect/overmap/visitable/sector/arcticplanet/New(nloc, max_x, max_y)
	name = "[generate_planet_name()], \a [name]"
	..()


//Ported from bay who ported it from vg and let's just say it was extremely buggy and strange. I chopped it up into a shell of its former self.
/mob/living/simple_animal/hostile/hive_alien/defender
	name = "hive defender"
	desc = "A terrifying monster resembling a massive, bloated tick in shape. Hundreds of blades are hidden underneath its rough shell."
	icon = 'maps/away/generic/blueriver/blueriver.dmi'
	icon_state = "hive_executioner_move"
	icon_living = "hive_executioner_move"
	icon_dead = "hive_executioner_dead"
	move_to_delay = 5
	speed = -1
	health = 150
	maxHealth = 150
	melee_damage_lower = 15
	melee_damage_upper = 30
	armor_penetration = 15

	harm_intent_damage = 8
	var/attack_mode = FALSE

	var/transformation_delay_min = 4
	var/transformation_delay_max = 8

/mob/living/simple_animal/hostile/hive_alien/defender/proc/mode_movement() //Slightly broken, but it's alien and unpredictable so w/e
	set waitfor = 0
	icon_state = "hive_executioner_move"
	flick("hive_executioner_movemode", src)
	sleep(rand(transformation_delay_min, transformation_delay_max))
	anchored = FALSE
	speed = -1
	move_to_delay = 8
	. = FALSE

/mob/living/simple_animal/hostile/hive_alien/defender/proc/mode_attack()
	set waitfor = 0
	icon_state = "hive_executioner_attack"
	flick("hive_executioner_attackmode", src)
	sleep(rand(transformation_delay_min, transformation_delay_max))
	anchored = TRUE
	speed = 0
	attack_mode = TRUE
	walk(src, 0)

/mob/living/simple_animal/hostile/hive_alien/defender/wounded
	name = "wounded hive defender"
	health = 80

/obj/effect/shuttle_landmark/nav_blueriv/nav1
	name = "Arctic Planet Landing Point #1"
	landmark_tag = "nav_blueriv_1"
	base_area = /area/bluespaceriver/ground

/obj/effect/shuttle_landmark/nav_blueriv/nav2
	name = "Arctic Planet Landing Point #2"
	landmark_tag = "nav_blueriv_2"
	base_area = /area/bluespaceriver/ground

/obj/effect/shuttle_landmark/nav_blueriv/nav3
	name = "Arctic Planet Landing Point #3"
	landmark_tag = "nav_blueriv_3"
	base_area = /area/bluespaceriver/ground

/obj/effect/shuttle_landmark/nav_blueriv/nav4
	name = "Arctic Planet Navpoint #4"
	landmark_tag = "nav_blueriv_antag"
	base_area = /area/bluespaceriver/ground

/turf/simulated/floor/away/blueriver/alienfloor
	name = "glowing floor"
	desc = "The floor glows without any apparent reason."
	icon = 'maps/away/generic/blueriver/riverturfs.dmi'
	icon_state = "floor"
	temperature = 233

/turf/simulated/floor/away/blueriver/alienfloor/Initialize()
	.=..()

	set_light(0.7, 1, 5, l_color = "#0066ff")

/turf/unsimulated/wall/away/blueriver/livingwall
	name = "alien wall"
	desc = "You feel a sense of dread from just looking at this wall. Its surface seems to be constantly moving, as if it were breathing."
	icon = 'maps/away/generic/blueriver/riverturfs.dmi'
	icon_state = "evilwall_1"
	opacity = 1
	density = TRUE
	temperature = 233

/turf/unsimulated/wall/away/blueriver/livingwall/Initialize()
	.=..()

	if(prob(80))
		icon_state = "evilwall_[rand(1,8)]"

/turf/unsimulated/wall/supermatter/no_spread
	name = "weird liquid"
	desc = "The viscous liquid glows and moves as if it were alive."
	icon = 'maps/away/generic/blueriver/blueriver.dmi'
	icon_state = "bluespacecrystal1"
	opacity = 0
	dynamic_lighting = 0

/turf/unsimulated/wall/supermatter/no_spread/Initialize()
	.=..()
	icon_state = "bluespacecrystal[rand(1,3)]"
	set_light(0.7, 1, 5, l_color = "#0066ff")
	return PROCESS_KILL

/obj/structure/deity
	name = "crystal altar"
	icon = 'icons/obj/cult.dmi'
	icon_state = "tomealtar"
	density = TRUE
	anchored = TRUE

/obj/structure/deity/attackby(obj/item/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	user.visible_message(
		"<span class='danger'>[user] hits \the [src] with \the [W]!</span>",
		"<span class='danger'>You hit \the [src] with \the [W]!</span>",
		"<span class='danger'>You hear something breaking!</span>"
		)