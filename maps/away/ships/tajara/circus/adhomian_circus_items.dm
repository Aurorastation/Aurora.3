//ringmaster

/obj/item/clothing/under/ringmaster
	name = "ringmaster uniform"
	desc = "A fancy suit used by Adhomian ringmasters."
	icon = 'maps/away/ships/tajara/circus/circus_sprites.dmi'
	icon_state = "ringmaster"
	item_state = "ringmaster"
	contained_sprite = TRUE

/obj/item/clothing/head/that/ringmaster
	name = "ringmaster tophat"
	desc = "A tall hat worn by ringmasters during their presentations."
	icon = 'maps/away/ships/tajara/circus/circus_sprites.dmi'
	icon_state = "ringmasterhat"
	item_state = "ringmasterhat"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/ringmaster
	name = "ringmaster coat"
	desc = "A fur coat worn by Adhomian ringmasters."
	icon = 'maps/away/ships/tajara/circus/circus_sprites.dmi'
	icon_state = "ringmastercoat"
	item_state = "ringmastercoat"
	contained_sprite = TRUE

/obj/item/clothing/shoes/jackboots/tajara/ringmaster
	name = "ringmaster boots"
	desc = "Comfortable and fancy boots meant for a Tajara."
	icon = 'maps/away/ships/tajara/circus/circus_sprites.dmi'
	icon_state = "circusboots"
	item_state = "circusboots"
	contained_sprite = TRUE

//strongman

/obj/item/clothing/under/strongman
	name = "strongzhan leotard"
	desc = "A skin-tight clothing made specially for strength athletics."
	icon = 'maps/away/ships/tajara/circus/circus_sprites.dmi'
	icon_state = "strongman"
	item_state = "strongman"
	contained_sprite = TRUE

/obj/item/clothing/shoes/sandal/strongman
	name = "strongzhan sandals"
	desc = "Reinforced leather sandals made for strong feet."
	icon = 'maps/away/ships/tajara/circus/circus_sprites.dmi'
	icon_state = "strongsandal"
	item_state = "strongsandal"
	contained_sprite = TRUE
	sprite_sheets = null

//animal tamer

/obj/item/clothing/under/tamer
	name = "tamer uniform"
	desc = "An uniform used by Adhomian animal tamers. The fabric has already been mended in a couple of places."
	icon = 'maps/away/ships/tajara/circus/circus_sprites.dmi'
	icon_state = "beasttrainer"
	item_state = "beasttrainer"
	contained_sprite = TRUE

//fortune teller

/obj/item/clothing/under/dress/tajaran/fortune
	name = "fortune teller dress"
	desc = "A dress worn by mystics of questionable reputation."
	icon = 'maps/away/ships/tajara/circus/circus_sprites.dmi'
	icon_state = "fortunedress"
	item_state = "fortunedress"
	contained_sprite = TRUE


//clown

/obj/item/clothing/under/clown
	name = "clown costume"
	desc = "A costume worn by Adhomian entertainers."
	icon = 'maps/away/ships/tajara/circus/circus_sprites.dmi'
	icon_state = "clownsuit"
	item_state = "clownsuit"
	contained_sprite = TRUE

/obj/item/clothing/head/clown
	name = "clown hat"
	desc = "A hat worn by professional fools."
	icon = 'maps/away/ships/tajara/circus/circus_sprites.dmi'
	icon_state = "clownhat"
	item_state = "clownhat"
	contained_sprite = TRUE

/obj/item/clothing/shoes/clown
	name = "clown shoes"
	desc = "The prankster's standard-issue clowning shoes."
	icon = 'maps/away/ships/tajara/circus/circus_sprites.dmi'
	icon_state = "clownshoes"
	item_state = "clownshoes"
	contained_sprite = TRUE
	species_restricted = null

/obj/item/clothing/shoes/clown/handle_movement(var/turf/walking, var/running)
	if(!running)
		if(footstep >= 2)
			footstep = 0
			playsound(src, SFX_FOOTSTEP_CLOWN, 20, 1)
		else
			footstep++
	else
		playsound(src, SFX_FOOTSTEP_CLOWN, 50, 1) // Running is louder and funnier

/obj/item/clothing/mask/clown
	name = "clown mask"
	desc = "A true prankster's facial attire."
	icon = 'maps/away/ships/tajara/circus/circus_sprites.dmi'
	icon_state = "clownmask"
	item_state = "clownmask"
	sprite_sheets = null
	contained_sprite = TRUE

//other objects

/obj/structure/balloon_dispenser
	name = "ballon canister"
	desc = "A canister of helium with countless balloons hanging from it."
	icon = 'maps/away/ships/tajara/circus/circus_sprites.dmi'
	icon_state = "ballon_dispenser"
	item_state = "ballon_dispenser"
	anchored = FALSE
	density = TRUE

/obj/structure/balloon_dispenser/attack_hand(mob/living/user)
	to_chat(user, "You pick a balloon.")
	var/obj/item/toy/balloon/color/B = new(get_turf(src))
	user.put_in_active_hand(B)

/obj/item/dumbbell
	parent_type = /obj/item/gym_dumbbell
	name = "adhomian dumbbell"
	desc = "A heavy piece of metal used in weight lifting."

/obj/item/dumbbell/twenty
	mass = 20

/obj/item/dumbbell/barbell
	parent_type = /obj/item/gym_dumbbell/barbell
	name = "adhomian barbell"

/obj/item/dumbbell/barbell/sixty
	mass = 60

/obj/item/dumbbell/barbell/eighty
	mass = 80

/obj/item/dumbbell/barbell/hundred
	mass = 100

/obj/item/dumbbell/barbell/hundredforty
	mass = 140

/obj/item/dumbbell/barbell/hundredeighty
	mass = 180

/obj/item/dumbbell/barbell/twohundred
	mass = 200

/obj/item/dumbbell/barbell/twohundredtwenty
	mass = 220

/obj/item/dumbbell/barbell/twohundredforty
	mass = 240

/obj/item/dumbbell/barbell/twohundredsixty
	mass = 260

/obj/item/dumbbell/barbell/threehundred
	mass = 300
