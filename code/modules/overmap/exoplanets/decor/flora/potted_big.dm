/obj/structure/flora/pottedplant
	name = "potted plant"
	desc = "A potted plant."
	icon = 'icons/obj/pottedplants_big.dmi'
	icon_state = "plant-26"
	anchored = FALSE
	density = FALSE
	var/dead = FALSE
	var/obj/item/stored_item

/obj/structure/flora/pottedplant/Destroy()
	QDEL_NULL(stored_item)
	return ..()

/obj/structure/flora/pottedplant/proc/death()
	if(!dead)
		icon_state = "plant-dead"
		name = "dead [name]"
		desc = "A dead potted plant."
		dead = TRUE

//No complex interactions, just make them fragile
/obj/structure/flora/pottedplant/ex_act(var/severity = 2.0)
	death()
	return ..()

/obj/structure/flora/pottedplant/fire_act(exposed_temperature, exposed_volume)
	death()
	return ..()

/obj/structure/flora/pottedplant/attackby(obj/item/attacking_item, mob/user)
	if(!ishuman(user))
		return
	if(istype(attacking_item, /obj/item/holder))
		return //no hiding mobs in there
	user.visible_message("[user] begins digging around inside of \the [src].", "You begin digging around in \the [src], trying to hide \the [attacking_item].")
	playsound(loc, 'sound/effects/plantshake.ogg', 50, 1)
	if(do_after(user, 20, src))
		if(!stored_item)
			if(attacking_item.w_class <= WEIGHT_CLASS_NORMAL)
				user.drop_from_inventory(attacking_item, src)
				stored_item = attacking_item
				to_chat(user,SPAN_NOTICE("You hide \the [attacking_item] in [src]."))
				return
			else
				to_chat(user,SPAN_NOTICE("\The [attacking_item] can't be hidden in [src], it's too big."))
				return
		else
			to_chat(user,SPAN_NOTICE("There is something hidden in [src]."))
			return
	return ..()

/obj/structure/flora/pottedplant/attack_hand(mob/user)
	user.visible_message("[user] begins digging around inside of \the [src].", "You begin digging around in \the [src], searching it.")
	playsound(loc, 'sound/effects/plantshake.ogg', 50, 1)
	if(do_after(user, 40, src))
		if(!stored_item)
			to_chat(user,SPAN_NOTICE("There is nothing hidden in [src]."))
		else
			if(istype(stored_item, /obj/item/device/paicard))
				stored_item.forceMove(src.loc)
				to_chat(user,SPAN_NOTICE("You reveal \the [stored_item] from [src]."))
			else
				user.put_in_hands(stored_item)
				to_chat(user,SPAN_NOTICE("You take \the [stored_item] from [src]."))
			stored_item = null

/obj/structure/flora/pottedplant/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	if (prob(hitting_projectile.damage*2))
		death()

// ------------------------------------ dead/empty

/obj/structure/flora/pottedplant/dead
	name = "dead potted plant"
	desc = "A dead potted plant."
	icon_state = "plant-dead"
	dead = TRUE

/obj/structure/flora/pottedplant/dead2
	name = "dead potted plant"
	desc = "A dead potted plant."
	icon_state = "plant-dead-2"
	dead = TRUE

/obj/structure/flora/pottedplant/empty
	name = "empty plant pot"
	desc = "An empty plant pot."
	icon_state = "plant-empty"
	dead = TRUE

// ------------------------------------ actual plants

/obj/structure/flora/pottedplant/applebush
	name = "decorative potted plant"
	desc = "This is a decorative shrub. It's been trimmed into the shape of an apple."
	icon_state = "applebush"

/obj/structure/flora/pottedplant/fern
	name = "potted fern"
	desc = "This is an ordinary looking fern. It has some big leaves."
	icon_state = "plant-01"

/obj/structure/flora/pottedplant/tree
	name = "potted tree"
	desc = "This is a small tree. It has hard bark and lots of tiny leaves."
	icon_state = "plant-02"

/obj/structure/flora/pottedplant/overgrown
	name = "overgrown potted plants"
	desc = "This is an assortment of colourful plants. Some parts are overgrown."
	icon_state = "plant-03"

/obj/structure/flora/pottedplant/bamboo
	name = "potted bamboo"
	desc = "These are bamboo shoots. The tops looks like they've been cut short."
	icon_state = "plant-04"

/obj/structure/flora/pottedplant/largebush
	name = "large potted bush"
	desc = "This is a large bush. The leaves stick upwards in an odd fashion."
	icon_state = "plant-05"

/obj/structure/flora/pottedplant/thinbush
	name = "thin potted bush"
	desc = "This is a thin bush. It appears to be flowering."
	icon_state = "plant-06"

/obj/structure/flora/pottedplant/mysterious
	name = "reedy potted bulbs"
	desc = "A reedy plant mostly used for decoration in Skrell homes, admired for its luxuriant stalks. Touching the bulbs causes them to shrink."
	icon_state = "plant-07"

/obj/structure/flora/pottedplant/smalltree
	name = "small potted tree"
	desc = "This is a small tree. It is rather pleasant."
	icon_state = "plant-08"

/obj/structure/flora/pottedplant/unusual
	name = "unusual potted plant"
	desc = "A fleshy cave dwelling plant with huge nodules for flowers. Its bulbous ends emit a soft blue light."
	icon_state = "plant-09"

/obj/structure/flora/pottedplant/unusual/Initialize()
	. = ..()
	set_light(l_range = 2, l_power = 2, l_color = "#007fff")

/obj/structure/flora/pottedplant/cherrytree
	name = "potted cherry blossom tree"
	desc = "A beautiful kwanzan cherry blossom tree. A notably ornamental tree, appreciated for its lack of fruit.."
	icon_state = "plant-10"

/obj/structure/flora/pottedplant/smallcactus
	name = "small potted cactus"
	desc = "A scrubby cactus adapted to the Moghes deserts."
	icon_state = "plant-11"

/obj/structure/flora/pottedplant/tall
	name = "tall potted plant"
	desc = "A hardy succulent adapted to the Moghes deserts. Tiny pores line its surface."
	icon_state = "plant-12"

/obj/structure/flora/pottedplant/sticky
	name = "sticky potted plant"
	desc = "This is an odd plant. Its sticky leaves trap insects."
	icon_state = "plant-13"

/obj/structure/flora/pottedplant/smelly
	name = "smelly potted plant"
	desc = "That's a huge flower. Previously, the petals would be used in dyes for unathi garb. Now it's more of a decorative plant. It reeks of rotten eggs."
	icon_state = "plant-14"

/obj/structure/flora/pottedplant/bouquet
	name = "small potted bouquet"
	desc = "A pitiful pot of assorted small flora. Some look familiar."
	icon_state = "plant-15"

/obj/structure/flora/pottedplant/aquatic
	name = "aquatic potted plant"
	desc = "An aquatic plant originating in Qerrbalak. This one has been gene-engineered to also live on land."
	icon_state = "plant-16"

/obj/structure/flora/pottedplant/shoot
	name = "small potted shoot"
	desc = "This is a small shoot. It still needs time to grow."
	icon_state = "plant-17"

/obj/structure/flora/pottedplant/orchid
	name = "sweet potted orchid"
	desc = "An orchid plant, as beautiful as it is delicate. Sweet smelling flowers are supported by spindly stems."
	icon_state = "plant-18"

/obj/structure/flora/pottedplant/crystal
	name = "crystalline potted plant"
	desc = "A ropey, aquatic plant. Odd crystal formations grow on the end."
	icon_state = "plant-19"

/obj/structure/flora/pottedplant/subterranean
	name = "subterranean potted plant-fungus"
	desc = "A bioluminescent subterranean half-plant half-fungus hybrid, its bulbous ends glow faintly. Said to come from Sedantis I."
	icon_state = "plant-20"

/obj/structure/flora/pottedplant/subterranean/Initialize()
	. = ..()
	set_light(l_range = 1, l_power = 0.5, l_color = "#ff6633")

/obj/structure/flora/pottedplant/minitree
	name = "potted tree"
	desc = "This is a miniature tree. It has tiny leaves, delicate and soft to touch."
	icon_state = "plant-21"

/obj/structure/flora/pottedplant/stoutbush
	name = "stout potted bush"
	desc = "This is a stout bush. Its leaves point up and outwards."
	icon_state = "plant-22"

/obj/structure/flora/pottedplant/drooping
	name = "drooping potted plant"
	desc = "This is a small plant. The drooping leaves make it look like it's wilted."
	icon_state = "plant-23"

/obj/structure/flora/pottedplant/tropical
	name = "tropical potted plant"
	desc = "This is some kind of tropical plant. It hasn't begun to flower yet."
	icon_state = "plant-24"

/obj/structure/flora/pottedplant/flowerbush
	name = "potted flower bush"
	desc = "This large shrub is thriving. It has lots of tiny flowers on display, in many different colors."
	icon_state = "plant-25"

/obj/structure/flora/pottedplant/bulrush
	name = "small potted grass"
	desc = "A bulrush, wetland grass-like plant. Commonly referred to as cattail."
	icon_state = "plant-26"

/obj/structure/flora/pottedplant/rosebush
	name = "thorny potted rose bush"
	desc = "A flowering rose bush. It has sharp thorns on its stems."
	icon_state = "plant-27"

/obj/structure/flora/pottedplant/floorleaf
	name = "waxy leafy floor plant"
	desc = "This plant has remarkably waxy leaves."
	icon_state = "plant-28"

/obj/structure/flora/pottedplant/fernovergrown
	name = "overgrown potted fern"
	desc = "This leafy fern really needs a trimming."
	icon_state = "plant-29"

/obj/structure/flora/pottedplant/ferntrim
	name = "trimmed potted fern"
	desc = "This leafy fern seems to have been trimmed too much."
	icon_state = "plant-30"

/obj/structure/flora/pottedplant/whitetulip
	name = "potted tulip"
	desc = "A potted plant, with large white flower buds."
	icon_state = "plant-31"

/obj/structure/flora/pottedplant/woodyshrub
	name = "woody potted shrub"
	desc = "A woody shrub."
	icon_state = "plant-32"

/obj/structure/flora/pottedplant/woodyshrubdying
	name = "dying woody potted shrub"
	desc = "A woody shrub. Seems to be in need of watering."
	icon_state = "plant-33"

/obj/structure/flora/pottedplant/woodyshrubbloom
	name = "blooming woody potted shrub"
	desc = "A woody shrub. This one seems to be in bloom."
	icon_state = "plant-34"

/obj/structure/flora/pottedplant/bluefern
	name = "blueish potted fern"
	desc = "A fern, with big dark blue leaves."
	icon_state = "plant-35"

/obj/structure/flora/pottedplant/eye
	name = "eye bulb plant"
	desc = "A decorative plant borne from a genetic mishap in a Zeng-Hu genetics lab. \
			Scientists assure, the blinking \"eye\" is simply just a form of heat regulation, \
			and other than that, this plant is same as any other greenery."
	icon_state = "plant-36"

/obj/structure/flora/pottedplant/greeting_palm
	name = "greeting palm fern"
	desc = "Originally native to Silversun, this small plant can now be found across the spur, decorating plazas, \
		hotel lobbies, and corporate offices, that want to bring a little bit of tropical Silversun into cold, hard, concrete spaces. \
		It has a long, slightly wave-shaped bark, with fronds that hang from the top. When there is wind, \
		the leaves blow upwards and look slightly like waving hands, giving it it's name."
	icon_state = "plant-tc-01"

/obj/structure/flora/pottedplant/fortune_flower
	name = "fortune flower bush"
	desc = "A plant native to the volcanic soil of Port Antillia, \
		early settlers named it for the similarity of its flowers to the shape of fortune cookies. \
		As a result, it has become a symbol of good fortune in businesses across the spur."
	icon_state = "plant-tc-02"

/obj/structure/flora/pottedplant/river_plum
	name = "river plum"
	desc = "This freshwater plant, native to the shores of Konyang rivers, is known for its beautiful pink flora.\
		Its purple fruit, despite being striking, largely holds no notable nutritional value \
		and is said to have the unpleasant taste of bleached cotton. \
		It is sometimes used in the textile industry due to it's vibrant colors."
	icon_state = "plant-tc-03"
