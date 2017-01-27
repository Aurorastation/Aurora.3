/obj/item/slime_extract
	name = "slime extract"
	desc = "Goo extracted from a slime. Legends claim these to have \"magical powers\"."
	icon = 'icons/mob/slimes.dmi'
	icon_state = "grey slime extract"
	force = 1.0
	w_class = 1.0
	throwforce = 0
	throw_speed = 3
	throw_range = 6
	origin_tech = list(TECH_BIO = 4)
	var/Uses = 1 // uses before it goes inert
	var/enhanced = 0 //has it been enhanced before?
	flags = OPENCONTAINER

	attackby(obj/item/O as obj, mob/user as mob)
		if(istype(O, /obj/item/weapon/slimesteroid2))
			if(enhanced == 1)
				user << "<span class='warning'> This extract has already been enhanced!</span>"
				return ..()
			if(Uses == 0)
				user << "<span class='warning'> You can't enhance a used extract!</span>"
				return ..()
			user <<"You apply the enhancer. It now has triple the amount of uses."
			Uses = 3
			enhanced = 1
			qdel(O)

/obj/item/slime_extract/New()
	..()
	create_reagents(100)
	reagents.add_reagent("slimejelly", 30)

/obj/item/slime_extract/grey
	name = "grey slime extract"
	icon_state = "grey slime extract"

/obj/item/slime_extract/gold
	name = "gold slime extract"
	icon_state = "gold slime extract"

/obj/item/slime_extract/silver
	name = "silver slime extract"
	icon_state = "silver slime extract"

/obj/item/slime_extract/metal
	name = "metal slime extract"
	icon_state = "metal slime extract"

/obj/item/slime_extract/purple
	name = "purple slime extract"
	icon_state = "purple slime extract"

/obj/item/slime_extract/darkpurple
	name = "dark purple slime extract"
	icon_state = "dark purple slime extract"

/obj/item/slime_extract/orange
	name = "orange slime extract"
	icon_state = "orange slime extract"

/obj/item/slime_extract/yellow
	name = "yellow slime extract"
	icon_state = "yellow slime extract"

/obj/item/slime_extract/red
	name = "red slime extract"
	icon_state = "red slime extract"

/obj/item/slime_extract/blue
	name = "blue slime extract"
	icon_state = "blue slime extract"

/obj/item/slime_extract/darkblue
	name = "dark blue slime extract"
	icon_state = "dark blue slime extract"

/obj/item/slime_extract/pink
	name = "pink slime extract"
	icon_state = "pink slime extract"

/obj/item/slime_extract/green
	name = "green slime extract"
	icon_state = "green slime extract"

/obj/item/slime_extract/lightpink
	name = "light pink slime extract"
	icon_state = "light pink slime extract"

/obj/item/slime_extract/black
	name = "black slime extract"
	icon_state = "black slime extract"

/obj/item/slime_extract/oil
	name = "oil slime extract"
	icon_state = "oil slime extract"

/obj/item/slime_extract/adamantine
	name = "adamantine slime extract"
	icon_state = "adamantine slime extract"

/obj/item/slime_extract/bluespace
	name = "bluespace slime extract"
	icon_state = "bluespace slime extract"

/obj/item/slime_extract/pyrite
	name = "pyrite slime extract"
	icon_state = "pyrite slime extract"

/obj/item/slime_extract/cerulean
	name = "cerulean slime extract"
	icon_state = "cerulean slime extract"

/obj/item/slime_extract/sepia
	name = "sepia slime extract"
	icon_state = "sepia slime extract"

/obj/item/slime_extract/rainbow
	name = "rainbow slime extract"
	icon_state = "rainbow slime extract"

////Pet Slime Creation///

/obj/item/weapon/slimepotion
	name = "docility potion"
	desc = "A potent chemical mix that will nullify a slime's powers, causing it to become docile and tame."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle19"

	attack(mob/living/carbon/slime/M as mob, mob/user as mob)
		if(!istype(M, /mob/living/carbon/slime))//If target is not a slime.
			user << "<span class='warning'> The potion only works on baby slimes!</span>"
			return ..()
		if(M.is_adult) //Can't tame adults
			user << "<span class='warning'> Only baby slimes can be tamed!</span>"
			return..()
		if(M.stat)
			user << "<span class='warning'> The slime is dead!</span>"
			return..()
		if(M.mind)
			user << "<span class='warning'> The slime resists!</span>"
			return ..()
		var/mob/living/simple_animal/slime/pet = new /mob/living/simple_animal/slime(M.loc)
		pet.icon_state = "[M.colour] baby slime"
		pet.icon_living = "[M.colour] baby slime"
		pet.icon_dead = "[M.colour] baby slime dead"
		pet.colour = "[M.colour]"
		user <<"You feed the slime the potion, removing it's powers and calming it."
		qdel(M)
		var/newname = sanitize(input(user, "Would you like to give the slime a name?", "Name your new pet", "pet slime") as null|text, MAX_NAME_LEN)

		if (!newname)
			newname = "pet slime"
		pet.name = newname
		pet.real_name = newname
		qdel(src)

/obj/item/weapon/slimepotion2
	name = "advanced docility potion"
	desc = "A potent chemical mix that will nullify a slime's powers, causing it to become docile and tame. This one is meant for adult slimes"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle19"

	attack(mob/living/carbon/slime/M as mob, mob/user as mob)
		if(!istype(M, /mob/living/carbon/slime/))//If target is not a slime.
			user << "<span class='warning'> The potion only works on slimes!</span>"
			return ..()
		if(M.stat)
			user << "<span class='warning'> The slime is dead!</span>"
			return..()
		if(M.mind)
			user << "<span class='warning'> The slime resists!</span>"
			return ..()
		var/mob/living/simple_animal/adultslime/pet = new /mob/living/simple_animal/adultslime(M.loc)
		pet.icon_state = "[M.colour] adult slime"
		pet.icon_living = "[M.colour] adult slime"
		pet.icon_dead = "[M.colour] baby slime dead"
		pet.colour = "[M.colour]"
		user <<"You feed the slime the potion, removing it's powers and calming it."
		qdel(M)
		var/newname = sanitize(input(user, "Would you like to give the slime a name?", "Name your new pet", "pet slime") as null|text, MAX_NAME_LEN)

		if (!newname)
			newname = "pet slime"
		pet.name = newname
		pet.real_name = newname
		qdel(src)


/obj/item/weapon/slimesteroid
	name = "slime steroid"
	desc = "A potent chemical mix that will cause a slime to generate more extract."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"

	attack(mob/living/carbon/slime/M as mob, mob/user as mob)
		if(!istype(M, /mob/living/carbon/slime))//If target is not a slime.
			user << "<span class='warning'> The steroid only works on baby slimes!</span>"
			return ..()
		if(M.is_adult) //Can't tame adults
			user << "<span class='warning'> Only baby slimes can use the steroid!</span>"
			return..()
		if(M.stat)
			user << "<span class='warning'> The slime is dead!</span>"
			return..()
		if(M.cores == 3)
			user <<"<span class='warning'> The slime already has the maximum amount of extract!</span>"
			return..()

		user <<"You feed the slime the steroid. It now has triple the amount of extract."
		M.cores = 3
		qdel(src)

/obj/item/weapon/slimesteroid2
	name = "extract enhancer"
	desc = "A potent chemical mix that will give a slime extract three uses."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle17"

	/*afterattack(obj/target, mob/user , flag)
		if(istype(target, /obj/item/slime_extract))
			if(target.enhanced == 1)
				user << "<span class='warning'> This extract has already been enhanced!</span>"
				return ..()
			if(target.Uses == 0)
				user << "<span class='warning'> You can't enhance a used extract!</span>"
				return ..()
			user <<"You apply the enhancer. It now has triple the amount of uses."
			target.Uses = 3
			target.enahnced = 1
			qdel(src)*/

/obj/effect/golemrune
	anchored = 1
	desc = "a strange rune used to create golems. It glows when spirits are nearby."
	name = "rune"
	icon = 'icons/obj/rune.dmi'
	icon_state = "golem"
	unacidable = 1
	layer = TURF_LAYER

	New()
		..()
		processing_objects.Add(src)

	process()
		var/mob/dead/observer/ghost
		for(var/mob/dead/observer/O in src.loc)
			if(!O.client)	continue
			if(O.mind && O.mind.current && O.mind.current.stat != DEAD)	continue
			ghost = O
			break
		if(ghost)
			icon_state = "golem2"
		else
			icon_state = "golem"

	attack_hand(mob/living/user as mob)
		/*var/mob/dead/observer/ghost
		for(var/mob/dead/observer/O in src.loc)
			if(!O.client)	continue
			if(O.mind && O.mind.current && O.mind.current.stat != DEAD)	continue
			ghost = O
			break
		if(!ghost)
			user << "The rune fizzles uselessly. There is no spirit nearby."
			return*/

		var/ultimate_species
		var/spawn_blurb
		var/glass = 0
		var/special_color

		for(var/obj/M in src.loc)

			if(!M)
				user << "The rune fizzles uselessly. There is insufficient material to forge a shell from."
				return

			var/materialcheck
			var/materialswitch

			if(istype(M,/obj/item/stack/material))
				var/obj/item/stack/material/S = M
				materialcheck = S.material
				materialswitch = S.material.name

			else if(istype(M,/obj/item/weapon/material))
				var/obj/item/weapon/material/S = M
				materialcheck = S.material
				materialswitch = S.material.name

			if(materialcheck)
				switch(materialswitch)

					if("plastic")
						ultimate_species = "Plastic Golem"
						spawn_blurb = "As a Plastic Golem you are more a novelty than a tool."
						qdel(M)
						break

					if("uranium")
						ultimate_species = "Uranium Golem"
						spawn_blurb = "As a Uranium Golem, you are privy to several radiation-based abilities, and can gauge the radiation levels of others by hugging them."
						qdel(M)
						break

					if("diamond")
						ultimate_species = "Diamond Golem"
						spawn_blurb = "As a Diamond Golem, you are resistant to lasers and are among the strongest golems around."
						glass = 1
						qdel(M)
						break

					if("gold")
						ultimate_species = "Gold Golem"
						spawn_blurb = "As a Gold Golem you are rather soft. However, your density makes you harder to push and your punches land harder."
						qdel(M)
						break

					if("bronze")
						ultimate_species = "Bronze Golem"
						spawn_blurb = "As a Bronze Golem you are more a novelty than a tool."
						qdel(M)
						break

					if("silver")
						ultimate_species = "Silver Golem"
						spawn_blurb = "You are a Silver Golem. You are equally resistant to all damage types, but tend to move very slowly."
						qdel(M)
						break

					if("phoron")
						ultimate_species = "Phoron Golem"
						spawn_blurb = "As a Phoron Golem you have a weakness to fire but an attraction to it all the same. Upon your death you are likely to explode."
						qdel(M)
						break

					if("sandstone")
						ultimate_species = "Sandstone Golem"
						spawn_blurb = "You are a Sandstone Golem."
						qdel(M)
						break

					if("marble")
						ultimate_species = "Marble Golem"
						spawn_blurb = "You are a Marble Golem. Beyond your stately appearance you are also fairly durable."
						qdel(M)
						break

					if("steel")
						ultimate_species = "Steel Golem"
						spawn_blurb = "You are a Steel Golem. You are equally resistant to all damage types, but tend to move very slowly."
						qdel(M)
						break

					if("plasteel")
						ultimate_species = "Plasteel Golem"
						spawn_blurb = "You are a Plasteel Golem. You are equally resistant to all damage types, but tend to move very slowly."
						qdel(M)
						break

					if("titanium")
						ultimate_species = "Titanium Golem"
						spawn_blurb = "As a Titanium Golem you are among the strongest and mightiest golems around."
						qdel(M)
						break

					if("glass")
						ultimate_species = "Glass Golem"
						spawn_blurb = "As a Glass Golem you are resistant to lasers but otherwise very fragile."
						glass = 1
						qdel(M)
						break

					if("rglass")
						ultimate_species = "Reinforced Glass Golem"
						spawn_blurb = "You are a Reinforced Glass Golem. You are very resistant to lasers, but fragile to other sources of damage."
						glass = 1
						qdel(M)
						break

					if("borosilicate glass")
						ultimate_species = "Borosilicate Glass Golem"
						spawn_blurb = "You are a Borosilicate Glass Golem. You are very resistant to lasers, but fragile to other sources of damage."
						glass = 1
						qdel(M)
						break

					if("reinforced borosilicate glass")
						ultimate_species = "Reinforced Borosilicate Glass Golem"
						spawn_blurb = "You are a Reinforced Borosilicate Glass Golem. You are very resistant to lasers, but fragile to other sources of damage."
						glass = 1
						qdel(M)
						break

					if("osmium")
						ultimate_species = "Osmium Golem"
						spawn_blurb = "As an Osmium Golem your density makes you harder to push and your hits land stronger."
						qdel(M)
						break

					if("tritium")
						ultimate_species = "Tritium Golem"
						spawn_blurb = "As a Tritium Golem you possess the ability to detect and absorb the radiation of others."
						qdel(M)
						break

					if("mhydrogen")
						ultimate_species = "Metallic Hydrogen Golem"
						spawn_blurb = "As a Metallic Hydrogen Golem you possess very basic electrokinesis."
						qdel(M)
						break

					if("platinum")
						ultimate_species = "Platinum Golem"
						spawn_blurb = "You are a Platinum Golem. You are equally resistant to all damage types, but tend to move very slowly."
						qdel(M)
						break

					if("iron")
						ultimate_species = "Iron Golem"
						spawn_blurb = "You are an Iron Golem. You are equally resistant to all damage types, but tend to move very slowly."
						qdel(M)
						break

					if("wood")
						ultimate_species = "Wood Golem"
						spawn_blurb = "You are a Wood Golem. You are very flammable but otherwise admirably durable."
						qdel(M)
						break

					if("cardboard")
						ultimate_species = "Cardboard Golem"
						spawn_blurb = "You are a Carboard Golem. You are as flimsy as you sound."
						qdel(M)
						break

					if("cloth")
						ultimate_species = "Cloth Golem"
						spawn_blurb = "You are a Cloth Golem. Your light material grants you great speed, but also great weakness."
						qdel(M)
						break

					if("leather")
						ultimate_species = "Homonculus"
						spawn_blurb = "You are a Homonculus, a golem woven of flesh. You can impart the gift of your being upon any brain you find, and can devour creatures smaller than you with great gluttony."
						qdel(M)
						break

					if("carpet")
						ultimate_species = "Shaggy Golem"
						spawn_blurb = "You are a carpet golem. Your light material grants you great speed, but also great weakness."
						qdel(M)
						break

					if("cotton")
						ultimate_species = "Cloth Golem"
						spawn_blurb = "You are a Cloth Golem. Your light material grants you great speed, but also great weakness."
						qdel(M)
						break

					if("teal")
						ultimate_species = "Cloth Golem"
						spawn_blurb = "You are a Cloth Golem. Your light material grants you great speed, but also great weakness."
						special_color = "#00EAFA"
						qdel(M)
						break

					if("black")
						ultimate_species = "Cloth Golem"
						spawn_blurb = "You are a Cloth Golem. Your light material grants you great speed, but also great weakness."
						special_color = "#505050"
						qdel(M)
						break

					if("green")
						ultimate_species = "Cloth Golem"
						spawn_blurb = "You are a Cloth Golem. Your light material grants you great speed, but also great weakness."
						special_color = "#01C608"
						qdel(M)
						break

					if("purple")
						ultimate_species = "Cloth Golem"
						spawn_blurb = "You are a Cloth Golem. Your light material grants you great speed, but also great weakness."
						special_color = "#9C56C4"
						qdel(M)
						break

					if("blue")
						ultimate_species = "Cloth Golem"
						spawn_blurb = "You are a Cloth Golem. Your light material grants you great speed, but also great weakness."
						special_color = "#6B6FE3"
						qdel(M)
						break

					if("beige")
						ultimate_species = "Cloth Golem"
						spawn_blurb = "You are a Cloth Golem. Your light material grants you great speed, but also great weakness."
						special_color = "#E8E7C8"
						qdel(M)
						break

					if("lime")
						ultimate_species = "Cloth Golem"
						spawn_blurb = "You are a Cloth Golem. Your light material grants you great speed, but also great weakness."
						special_color = "#62E36C"
						qdel(M)
						break

					if("hide")
						ultimate_species = "Homonculus"
						spawn_blurb = "You are a Homonculus, a golem woven of flesh. You can impart the gift of your being upon any brain you find, and can devour creatures smaller than you with great gluttony"
						qdel(M)
						break

					if("corgi hide")
						ultimate_species = "Homonculus"
						spawn_blurb = "You are a Homonculus, a golem woven of flesh. You can impart the gift of your being upon any brain you find, and can devour creatures smaller than you with great gluttony."
						qdel(M)
						break

					if("cat hide")
						ultimate_species = "Homonculus"
						spawn_blurb = "You are a Homonculus, a golem woven of flesh. You can impart the gift of your being upon any brain you find, and can devour creatures smaller than you with great gluttony."
						qdel(M)
						break

					if("lizard hide")
						ultimate_species = "Homonculus"
						spawn_blurb = "You are a Homonculus, a golem woven of flesh. You can impart the gift of your being upon any brain you find, and can devour creatures smaller than you with great gluttony."
						qdel(M)
						break

					if("alien hide")
						ultimate_species = "Homonculus"
						spawn_blurb = "You are a Homonculus, a golem woven of flesh. You can impart the gift of your being upon any brain you find, and can devour creatures smaller than you with great gluttony."
						qdel(M)
						break

					else
						continue

			else
				continue

			user << "The rune fizzles uselessly. There is insufficient material to forge a shell from."
			return

		if(ultimate_species)
			var/mob/living/carbon/human/G
			if(glass)
				G = new /mob/living/carbon/human/crystalgolem(src.loc)
			else
				G = new(src.loc)
			G.set_species(ultimate_species)
			if(special_color)
				G.species.flesh_color = special_color
				G.species.base_color = special_color
				G.color = special_color
			//G.key = ghost.key
			G << "[spawn_blurb] Serve [user], and assist them in completing their goals at any cost."
			qdel(src)
		else
			user << "The rune fizzles uselessly. There is insufficient material to forge a shell from."
			return

	proc/announce_to_ghosts()
		for(var/mob/dead/observer/G in player_list)
			if(G.client)
				var/area/A = get_area(src)
				if(A)
					G << "Golem rune created in [A.name]."

/mob/living/carbon/slime/has_eyes()
	return 0

