/datum/map_template/ruin/away_site/blueriver
	name = "Bluespace River"
	id = "blueriver"
	spawn_cost = 1
	spawn_weight = 1
	description = "An arctic planet and an alien underground surface."
	suffixes = list("away_site/blueriver/blueriver-1.dmm","away_site/blueriver/blueriver-2.dmm")
	generate_mining_by_z = 2
	sectors = list(SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_SRANDMARR, SECTOR_GAKAL)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/singleton/submap_archetype/blueriver
	map = "bluespace river"
	descriptor = "An arctic planet and an alien underground surface."

/obj/effect/overmap/visitable/sector/blueriver
	name = "arctic planetoid"
	desc = "Sensor array detects an arctic planet with a small vessel on the planet's surface. Scans further indicate strange energy emissions from below the planet's surface."
	in_space = FALSE
	icon_state = "globe"
	initial_generic_waypoints = list(
		"nav_blueriv_1",
		"nav_blueriv_2",
		"nav_blueriv_3",
		"nav_blueriv_4"
	)

/obj/effect/overmap/visitable/sector/blueriver/New(nloc, max_x, max_y)
	name = "[generate_planet_name()], \a [name]"
	..()


//Ported from bay who ported it from vg and let's just say it was extremely buggy and strange. I chopped it up into a shell of its former self. It has cool movements, but the sprite is very oudated so it is unused at the moment.
/mob/living/simple_animal/hostile/hive_alien/defender
	name = "hive defender"
	desc = "A terrifying monster resembling a massive, bloated tick in shape. Hundreds of blades are hidden underneath its rough shell."
	icon = 'maps/away/away_site/blueriver/blueriver.dmi'
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
	landmark_tag = "nav_blueriv_4"
	base_area = /area/bluespaceriver/ground

/turf/simulated/floor/away/blueriver/alienfloor
	name = "glowing floor"
	desc = "The floor glows without any apparent reason."
	icon = 'maps/away/away_site/blueriver/riverturfs.dmi'
	icon_state = "floor"
	temperature = 250

/turf/simulated/floor/away/blueriver/alienfloor/Initialize()
	.=..()

	set_light(0.7, 1, 5, l_color = "#0066ff")

/turf/unsimulated/wall/away/blueriver/livingwall
	name = "strange wall"
	desc = "A strange wall. Its surface seems to be constantly moving, as if it were breathing."
	icon = 'maps/away/away_site/blueriver/riverturfs.dmi'
	icon_state = "evilwall_1"
	opacity = 1
	density = TRUE
	temperature = 250

/turf/unsimulated/wall/away/blueriver/livingwall/Initialize()
	.=..()

	if(prob(80))
		icon_state = "evilwall_[rand(1,8)]"

/turf/unsimulated/wall/supermatter/no_spread
	name = "weird liquid"
	desc = "The viscous liquid glows and moves as if it were alive."
	icon = 'maps/away/away_site/blueriver/blueriver.dmi'
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

/obj/item/paper/blueriver/expedition_log_1
	name = "expedition log #1"
	info = "Well, it only took three weeks... but we finally found something worth investigating! An energy signature, just on or under the planet's surface. It's bizarre, similar to a bluespace signature, but... not. I'll need to get down there to really get a reading on it, but this could be the kind of discovery that makes a career. We've identified a landing site, so our pilot is setting the ship down there in the next couple of hours. it'll take some more time after that to set up a base camp and such."

/obj/item/paper/blueriver/expedition_log_2
	name = "expedition log #2"
	info = "We've landed, and aside from the permafrost, there's not a lot to mention on this rock. The readings are strongest in the middle of an open field near the ship, but there's nothing there, meaning we really only have one choice. Digging down. One of the others thinks theres a good chance that it's underground, so we might as well see if they're onto something. We don't have any other decent plans, and we need this find. Fortunate we brought the larger scale excavation equipment."

/obj/item/paper/blueriver/expedition_log_3
	name = "expedition log #3"
	info = "Well, it didn't take the three days I was betting on, so i'm out twenty bucks, but we managed to punch through into a cave of some sort with the drilling equipment. We're lowering a ladder down now and sending one of the guards down to check that there's no greimorians in there or anything. Once they report back, we'll move the whole basecamp down there. Coincidentally they just did as I finished this paragraph, so I'll continue this shortly! We've moved down into the cave now, and what we've found is astounding! It looks a LOT like a lake or river of blue goo, but... not? I took some scans, but couldn't pick anything up aside from radiation spikes from the pool. I also lowered a swab into the fluid to take a sample, but when I touched the swab to the surface of the... Fluid? the Swab just... ceased to exist. Yes, that's the best way I can describe it. It just stopped existing in my hand. We figure it's best we DON'T touch the blue stuff for now. one of our help has started moving supplies down into the cave to build a bridge of sorts though across the pool. We spotted some sort of structure on the far side, and the bridge is the only way to get to it, so now we wait. I don't want to think of what might happen if a person touches this blue river, so we're taking it nice and slow."

/obj/item/paper/blueriver/expedition_log_4
	name = "expedition log #4"
	info = "We've finished the bridge and began our initial investigation into the site. Thus far, we're finding structures clearly made by a sapient species, one that from all indications was relatively advanced, but no signs of what actually happened to them. There's clear signs of habitation, but no signs of what caused abandonment. Due to this I'm beginning to suspect that what we've encountered is an area rich in bluespace phenomena like the Romanovich Cloud in Tau Ceti. I've seen some interesting research papers come out of there regarding xenoarchaeological finds. That aside, we're setting up camp in the ruins tonight so that we can continue studying as long as possible before our scheduled departure for refueling, but I feel confident we'll have enough to secure funds for the forseeable future at least! This might just give us the edge against NanoTrasen."

/obj/item/paper/blueriver/expedition_log_5
	name = "expedition log #5"
	info = "One of the researchers and a guard disappeared last night. We've started looking for them, figuring maybe they got trapped somewhere in the ruins, maybe a booby trap or something that was still functioning, but we haven't seen any sign of them. Their equipment, both of their equipment, is still in the ship, and there's no signs of anything grabbing them in the night, they're just... Gone. The implication here is not lost on me and my colleagues seem to be reaching the same conclusion. We all need to set this aside for now though. Tomorrow morning we have to head back into space to go resupply and submit what we've found so far, but when we come back we'll have more than enough manpower to really dig into this place."