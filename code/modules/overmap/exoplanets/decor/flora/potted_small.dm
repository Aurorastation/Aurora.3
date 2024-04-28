/obj/item/flora/pottedplant_small
	name = "potted plant"
	desc = "A potted plant."
	icon = 'icons/obj/pottedplants_small.dmi'
	icon_state = "plant-01"
	anchored = FALSE
	density = FALSE
	var/dead = FALSE

/obj/item/flora/pottedplant_small/proc/death()
	if(!dead)
		icon_state = "plant-dead"
		name = "dead [name]"
		desc = "A dead potted plant."
		dead = TRUE

//No complex interactions, just make them fragile
/obj/item/flora/pottedplant_small/ex_act(var/severity = 2.0)
	death()
	return ..()

/obj/item/flora/pottedplant_small/fire_act()
	death()
	return ..()

/obj/item/flora/pottedplant_small/bullet_act(var/obj/item/projectile/Proj)
	if (prob(Proj.damage*2))
		death()
		return 1
	return ..()

// ------------------------------------ dead/empty

/obj/item/flora/pottedplant_small/dead
	name = "dead potted plant"
	desc = "A dead potted plant."
	icon_state = "plant-dead"
	dead = TRUE

/obj/item/flora/pottedplant_small/empty
	name = "empty plant pot"
	desc = "An empty plant pot."
	icon_state = "plant-empty"
	dead = TRUE

// ------------------------------------ actual plants

/obj/item/flora/pottedplant_small/sapling
	name = "potted sapling"
	desc = "Tree sampling, living in a tiny pot. It will grow into a big tree some day."
	icon_state = "plant-01"

/obj/item/flora/pottedplant_small/fern
	name = "small potted fern"
	desc = "This is an ordinary looking fern. It has one big leaf."
	icon_state = "plant-02"

/obj/item/flora/pottedplant_small/tree
	name = "miniature potted tree"
	desc = "This is a tiny tree. It has hard bark and some tiny leaves."
	icon_state = "plant-03"

/obj/item/flora/pottedplant_small/bamboo
	name = "potted bamboo"
	desc = "This is a tiny bamboo shoot. The top looks like it's been cut short."
	icon_state = "plant-04"

/obj/item/flora/pottedplant_small/smallbush
	name = "small potted bush"
	desc = "This is a small bush. The two big leaves stick upwards in an odd fashion."
	icon_state = "plant-05"

/obj/item/flora/pottedplant_small/thinbush
	name = "thin potted bush"
	desc = "This is a thin bush. It appears to be flowering."
	icon_state = "plant-06"

/obj/item/flora/pottedplant_small/mysterious
	name = "reedy potted bulb"
	desc = "A reedy plant mostly used for decoration in Skrell homes, admired for its luxuriant stalks. Touching its one bulb causes it to shrink."
	icon_state = "plant-07"

/obj/item/flora/pottedplant_small/unusual
	name = "unusual potted plant"
	desc = "A fleshy cave dwelling plant with one small flower nodule. Its bulbous end emits a soft blue light."
	icon_state = "plant-08"

/obj/item/flora/pottedplant_small/unusual/Initialize()
	. = ..()
	set_light(l_range = 2, l_power = 2, l_color = "#007fff")

/obj/item/flora/pottedplant_small/smallcactus
	name = "miniature potted cactus"
	desc = "A scrubby cactus adapted to the Moghes deserts."
	icon_state = "plant-09"

/obj/item/flora/pottedplant_small/tall
	name = "small potted plant"
	desc = "A hardy succulent adapted to the Moghes deserts. Tiny pores line its surface."
	icon_state = "plant-10"

/obj/item/flora/pottedplant_small/smelly
	name = "smelly potted plant"
	desc = "That's a big flower. It reeks of rotten eggs."
	icon_state = "plant-11"

/obj/item/flora/pottedplant_small/bouquet
	name = "tiny potted bouquet"
	desc = "A pitiful pot of just three tiny flowers."
	icon_state = "plant-12"

/obj/item/flora/pottedplant_small/shoot
	name = "small potted shoot"
	desc = "This is a tiny shoot. It still needs time to grow."
	icon_state = "plant-13"

/obj/item/flora/pottedplant_small/orchid
	name = "sweet potted orchid"
	desc = "An orchid plant, as beautiful as it is delicate. Sweet smelling flower is supported by spindly stems."
	icon_state = "plant-14"

/obj/item/flora/pottedplant_small/crystal
	name = "crystalline potted plant"
	desc = "A ropey, aquatic plant. Odd crystal formations grow on the end."
	icon_state = "plant-15"

/obj/item/flora/pottedplant_small/subterranean
	name = "subterranean potted plant-fungus"
	desc = "A bioluminescent subterranean half-plant half-fungus hybrid, its bulbous ends glow faintly. Said to come from Sedantis I."
	icon_state = "plant-16"

/obj/item/flora/pottedplant_small/subterranean/Initialize()
	. = ..()
	set_light(l_range = 1, l_power = 0.5, l_color = "#ff6633")

/obj/item/flora/pottedplant_small/stoutbush
	name = "stout potted bush"
	desc = "This is a miniature stout bush. Its leaves point up and outwards."
	icon_state = "plant-17"

/obj/item/flora/pottedplant_small/drooping
	name = "drooping potted plant"
	desc = "This is a tiny plant. It has just one drooping leaf, making it look like it's wilted."
	icon_state = "plant-18"

/obj/item/flora/pottedplant_small/tropical
	name = "tropical potted plant"
	desc = "This is some kind of tropical plant. It is very young, and hasn't begun to flower yet."
	icon_state = "plant-19"

/obj/item/flora/pottedplant_small/flower
	name = "potted flower"
	desc = "A small potted flower. It appears to be healthy and growing strong."
	icon_state = "plant-20"

/obj/item/flora/pottedplant_small/bulrush
	name = "small potted grass"
	desc = "A bulrush, wetland grass-like plant. This one is tiny, and does not have any flowers."
	icon_state = "plant-21"

/obj/item/flora/pottedplant_small/rose
	name = "thorny potted rose"
	desc = "A flowering rose. It has sharp thorns on its stems."
	icon_state = "plant-22"

/obj/item/flora/pottedplant_small/whitetulip
	name = "potted tulip"
	desc = "A potted plant, with one large white flower bud."
	icon_state = "plant-23"

/obj/item/flora/pottedplant_small/woodyshrub
	name = "woody potted shrub"
	desc = "A woody shrub."
	icon_state = "plant-24"

/obj/item/flora/pottedplant_small/woodyshrubdying
	name = "dying woody potted shrub"
	desc = "A woody shrub. Seems to be in need of watering."
	icon_state = "plant-25"

/obj/item/flora/pottedplant_small/woodyshrubbloom
	name = "blooming woody potted shrub"
	desc = "A woody shrub. This one seems to be in bloom."
	icon_state = "plant-26"

/obj/item/flora/pottedplant_small/bluefern
	name = "blueish potted fern"
	desc = "A miniature fern, with one big dark blue leaf."
	icon_state = "plant-27"
