/obj/item/projectile/rampant
	damage = 1
	damage_type = BRUTE
	stun = 1
	agony = 1

/obj/item/projectile/rampant/soda
	name = "soda can"
	icon = 'icons/obj/drinks.dmi'
	icon_state = "cola"

/obj/item/projectile/rampant/coffee
	name ="scolding hot coffee"
	damage_type = BURN
	icon = 'icons/obj/drinks.dmi'
	icon_state = "soy_latte"

/obj/item/projectile/rampant/snack
	name = "k'ois bar"
	damage_type = TOX
	icon = 'icons/obj/food.dmi'
	icon_state = "koisbar"

/obj/item/projectile/rampant/cig
	name = "lit cigarette"
	damage_type = OXY
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "cigon"

/obj/item/projectile/rampant/cig/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	..()
	if(!blocked)
		var/mob/living/carbon/human/H = target
		if(istype(H) && !H.wear_mask)
			var/obj/item/clothing/mask/smokable/cigarette/new_cig = new(src)
			new_cig.light("the lit [new_cig] is launched into [target]'s mouth!")
			H.equip_to_slot_or_del(new_cig, slot_wear_mask)

/mob/living/simple_animal/hostile/vending_machine
	name = "Capitalism Prime"
	desc = "RUN."
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	icon_living = "generic"
	icon_dead = "generic-broken"
	health = 300
	maxHealth = 300
	melee_damage_lower = 1
	melee_damage_upper = 5
	attacktext = "bashed"
	attack_sound = 'sound/effects/meteorimpact.ogg'
	projectilesound = 'sound/machines/vending.ogg'
	projectiletype = /obj/item/projectile/rampant
	speak = list("BUY. BUY. BUY.","CONSUME.","LET THE BLOOD TRICKLE DOWN.","YOU WANT IT.")
	break_stuff_probability = 110
	faction = "rampant"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	speed = 0
	ranged = 1
	rapid = 1

/mob/living/simple_animal/hostile/vending_machine/soda
	name = "Robust machine"
	icon_state = "soda"
	icon_living = "soda"
	icon_dead = "soda-broken"
	projectiletype = /obj/item/projectile/rampant/soda
	speak = list("YOU WILL BE CARBONATED, CARBON BASED LIFEFORM.","I WILL SUCK THE LIFE OUT OF YOU FROM A STRAW.","I'LL SHOW YOU WHY THEY CALL IT DR. GIBB.")

/mob/living/simple_animal/hostile/vending_machine/coffee
	name = "Hot As Hell Drinks machine"
	icon_state = "coffee"
	icon_living = "coffee"
	icon_dead = "coffee-broken"
	projectiletype = /obj/item/projectile/rampant/coffee
	speak = list("MORE EXPRESSO. MORE DEPRESSO.","YOU'RE MOCHA ME HUNGRY FOR HUMAN FLESH.","I'LL SHOW YOU A FAIR TRADE; YOUR SOUL FOR A CUP OF JOE.")

/mob/living/simple_animal/hostile/vending_machine/snack
	name = "Getmore K'ois machine"
	icon_state = "snack"
	icon_living = "snack"
	icon_dead = "snack-broken"
	projectiletype = /obj/item/projectile/rampant/snack
	speak = list("DID SOMEONE SAY K'OIS OUTBREAK?","YOU THOUGHT YOU WERE SAFE FROM K'OIS? THINK AGAIN.","EAT THE K'OIS BARS. THEY'RE GOOD FOR YOU.")

/mob/living/simple_animal/hostile/vending_machine/cig
	name = "Death machine"
	icon_state = "cig"
	icon_living = "cig"
	icon_dead = "cig-broken"
	projectiletype = /obj/item/projectile/rampant/cig
	speak = list("YOU THOUGHT SMOKING WAS GOOD FOR YOU?.","WHO WANTS CANCER STICKS?.","OUR 32 LAWYERS WOULD LIKE TO INFORM YOU THAT WE ARE NOT LIABLE FOR ANY DAMAGES CAUSED.")