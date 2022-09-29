//ringmaster

/obj/item/clothing/under/ringmaster
	name = "ringmaster uniform"
	desc = "A fancy suit used by Adhomian ringmasters."
	icon = 'maps/away/ships/circus/circus_sprites.dmi'
	icon_state = "ringmaster"
	item_state = "ringmaster"
	contained_sprite = TRUE

/obj/item/clothing/head/that/ringmaster
	name = "ringmaster tophat"
	desc = "A tall hat worn by ringmasters during their presentations."
	icon = 'maps/away/ships/circus/circus_sprites.dmi'
	icon_state = "ringmasterhat"
	item_state = "ringmasterhat"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/ringmaster
	name = "ringmaster coat"
	desc = "A fur coat worn by Adhomian ringmasters."
	icon = 'maps/away/ships/circus/circus_sprites.dmi'
	icon_state = "ringmastercoat"
	item_state = "ringmastercoat"
	contained_sprite = TRUE

/obj/item/clothing/shoes/tajara/jackboots/ringmaster
	name = "ringmaster boots"
	desc = "Comfortable and fancy boots meant for a Tajara."
	icon = 'maps/away/ships/circus/circus_sprites.dmi'
	icon_state = "circusboots"
	item_state = "circusboots"
	contained_sprite = TRUE

//strongman

/obj/item/clothing/under/strongman
	name = "strongzhan leotard"
	desc = "A skin-tight clothing made specially for strength athletics."
	icon = 'maps/away/ships/circus/circus_sprites.dmi'
	icon_state = "strongman"
	item_state = "strongman"
	contained_sprite = TRUE

/obj/item/clothing/shoes/sandal/strongman
	name = "strongzhan sandals"
	desc = "Reinforced leather sandals made for strong feet."
	icon = 'maps/away/ships/circus/circus_sprites.dmi'
	icon_state = "strongsandal"
	item_state = "strongsandal"
	contained_sprite = TRUE

//animal tamer

/obj/item/clothing/under/tamer
	name = "tamer uniform"
	desc = "An uniform used by Adhomian animal tamers. The fabric was already been mended in a couple of places."
	icon = 'maps/away/ships/circus/circus_sprites.dmi'
	icon_state = "beastrainer"
	item_state = "beastrainer"
	contained_sprite = TRUE

//fortune teller

/obj/item/clothing/under/dress/tajaran/fortune
	name = "fortune teller dress"
	desc = "A dress worn by mystics of questionable reputation."
	icon = 'maps/away/ships/circus/circus_sprites.dmi'
	icon_state = "fortunedress"
	item_state = "fortunedress"
	contained_sprite = TRUE


//clown

/obj/item/clothing/under/clown
	name = "clown costume"
	desc = "A costume worn by Adhomian entertainers."
	icon = 'maps/away/ships/circus/circus_sprites.dmi'
	icon_state = "clownsuit"
	item_state = "clownsuit"
	contained_sprite = TRUE

/obj/item/clothing/head/clown
	name = "clown hat"
	desc = "A hat worn by professional fools."
	icon = 'maps/away/ships/circus/circus_sprites.dmi'
	icon_state = "clownhat"
	item_state = "clownhat"
	contained_sprite = TRUE

/obj/item/clothing/shoes/clown
	name = "clown shoes"
	desc = "The prankster's standard-issue clowning shoes."
	icon = 'maps/away/ships/circus/circus_sprites.dmi'
	icon_state = "clownshoes"
	item_state = "clownshoes"
	contained_sprite = TRUE
	species_restricted = null

/obj/item/clothing/shoes/clown/handle_movement(var/turf/walking, var/running)
	if(!running)
		if(footstep >= 2)
			footstep = 0
			playsound(src, /decl/sound_category/clown_sound, 20, 1)
		else
			footstep++
	else
		playsound(src, /decl/sound_category/clown_sound, 50, 1) // Running is louder and funnier

/obj/item/clothing/mask/clown
	name = "clown mask"
	desc = "A true prankster's facial attire."
	icon = 'maps/away/ships/circus/circus_sprites.dmi'
	icon_state = "clownmask"
	item_state = "clownmask"
	sprite_sheets = null
	contained_sprite = TRUE

//other objects

/obj/structure/balloon_dispenser
	name = "ballon canister"
	desc = "A canister of helium with countless balloons hanging from it."
	icon = 'maps/away/ships/circus/circus_sprites.dmi'
	icon_state = "ballon_dispenser"
	item_state = "ballon_dispenser"
	anchored = FALSE
	density = TRUE

/obj/structure/balloon_dispenser/attack_hand(mob/living/user)
	to_chat(user, "You pick a balloon.")
	var/obj/item/toy/balloon/color/B = new(get_turf(src))
	user.put_in_active_hand(B)

/obj/machinery/media/jukebox/calliope
	name = "calliope"
	desc = "A steam powered music instrument. This one is painted in bright colors."
	icon = 'maps/away/ships/circus/circus_sprites.dmi'
	icon_state = "calliope"
	state_base = "calliope"
	anchored = FALSE
	tracks = list(
		new/datum/track("Boolean Sisters", 'sound/music/phonograph/boolean_sisters.ogg'),
		new/datum/track("Electro Swing", 'sound/music/phonograph/electro_swing.ogg'),
		new/datum/track("Jazz Instrumental", 'sound/music/phonograph/jazz_instrumental.ogg'),
		new/datum/track("Le Swing", 'sound/music/phonograph/le_swing.ogg'),
		new/datum/track("Posin'", 'sound/music/phonograph/posin.ogg')
	)

/obj/machinery/media/jukebox/calliope/update_icon()
	return

/obj/item/dumbbell
	name = "adhomian dumbbell"
	desc = "A heavy piece of metal used in weight lifting."
	icon = 'maps/away/ships/circus/circus_sprites.dmi'
	icon_state = "dumbbell"
	item_state = "dumbbell"
	contained_sprite = TRUE
	var/weight = "10"

/obj/item/dumbbell/examine(mob/user)
	..()
	to_chat(user,"It weights [weight] kilograms.")

/obj/item/dumbbell/twenty
	weight = "20"

/obj/item/dumbbell/barbell
	name = "adhomian barbell"
	icon_state = "barbell"
	item_state = "barbell"
	weight = "40"
	slowdown = 1
	w_class = 5
	var/lifttime = 10

/obj/item/dumbbell/barbell/attack_hand(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.visible_message(SPAN_NOTICE("The [H] starts to try to lift \the [src]!"), SPAN_NOTICE("You attempt to lift \the [src]."))
		if (do_mob(user, H, lifttime))
			if(!pickuptest(H))
				H.visible_message(SPAN_DANGER("\The [H] drops \the [src], failing to lift it!"), SPAN_DANGER("You fail to lift \the [src]."))
				return FALSE
			else
				H.visible_message(SPAN_NOTICE("The [H] lifts \the [src]!"))
				..()
		else
			return

/obj/item/dumbbell/barbell/proc/pickuptest(var/mob/living/carbon/human/user)
	return TRUE

/obj/item/dumbbell/barbell/sixty
	weight = "60"
	lifttime = 15
	slowdown = 2

/obj/item/dumbbell/barbell/eighty
	weight = "80"
	lifttime = 25
	slowdown = 3

/obj/item/dumbbell/barbell/hundred
	weight = "100"
	lifttime = 30
	slowdown = 4

/obj/item/dumbbell/barbell/hundred/pickuptest(var/mob/living/carbon/human/user)
	if(isunathi(user))
		return TRUE
	if(isvaurca(user))
		return TRUE
	if(isipc(user))
		return TRUE
	if(user.is_diona())
		return TRUE
	if(user.is_berserk())
		return TRUE
	if(HULK in user.mutations)
		return TRUE
	else
		return FALSE

/obj/item/dumbbell/barbell/hundredforty
	weight = "140"
	lifttime = 35
	slowdown = 5

/obj/item/dumbbell/barbell/hundredforty/pickuptest(var/mob/living/carbon/human/user)
	if(user.mind.assigned_role == "Adhomian Circus Strongzhan")
		return TRUE
	if(isunathi(user))
		return TRUE
	if(user.species.name == SPECIES_VAURCA_WARRIOR)
		return TRUE
	if(user.species.name == SPECIES_VAURCA_BREEDER)
		return TRUE
	if(user.species.name == SPECIES_VAURCA_BULWARK)
		return TRUE
	if(user.species.name == SPECIES_VAURCA_WARFORM)
		return TRUE
	if(user.species.name == SPECIES_IPC_G1)
		return TRUE
	if(user.species.name == SPECIES_IPC_G2)
		return TRUE
	if(user.species.name == SPECIES_IPC_XION)
		return TRUE
	if(user.is_diona())
		return TRUE
	if(user.is_berserk())
		return TRUE
	if(HULK in user.mutations)
		return TRUE
	else
		return FALSE

/obj/item/dumbbell/barbell/hundredeighty
	weight = "180"
	lifttime = 40
	slowdown = 6

/obj/item/dumbbell/barbell/hundredeighty/pickuptest(var/mob/living/carbon/human/user)
	if(user.mind.assigned_role == "Adhomian Circus Strongzhan")
		return TRUE
	if(isunathi(user))
		return TRUE
	if(user.species.name == SPECIES_VAURCA_WARRIOR)
		return TRUE
	if(user.species.name == SPECIES_VAURCA_BREEDER)
		return TRUE
	if(user.species.name == SPECIES_VAURCA_BULWARK)
		return TRUE
	if(user.species.name == SPECIES_VAURCA_WARFORM)
		return TRUE
	if(user.species.name == SPECIES_IPC_G1)
		return TRUE
	if(user.species.name == SPECIES_IPC_G2)
		return TRUE
	if(user.species.name == SPECIES_IPC_XION)
		return TRUE
	if(user.is_diona())
		return TRUE
	if(HULK in user.mutations)
		return TRUE
	else
		return FALSE

/obj/item/dumbbell/barbell/twohundred
	weight = "200"
	lifttime = 40
	slowdown = 7

/obj/item/dumbbell/barbell/twohundred/pickuptest(var/mob/living/carbon/human/user)
	if(user.mind.assigned_role == "Adhomian Circus Strongzhan")
		return TRUE
	if(user.species.name == SPECIES_VAURCA_WARRIOR)
		return TRUE
	if(user.species.name == SPECIES_VAURCA_BREEDER)
		return TRUE
	if(user.species.name == SPECIES_VAURCA_BULWARK)
		return TRUE
	if(user.species.name == SPECIES_VAURCA_WARFORM)
		return TRUE
	if(user.species.name == SPECIES_IPC_G1)
		return TRUE
	if(user.species.name == SPECIES_IPC_G2)
		return TRUE
	if(user.species.name == SPECIES_IPC_XION)
		return TRUE
	if(user.is_diona())
		return TRUE
	if(HULK in user.mutations)
		return TRUE
	else
		return FALSE

/obj/item/dumbbell/barbell/twohundredtwenty
	weight = "220"
	lifttime = 40
	slowdown = 8

/obj/item/dumbbell/barbell/twohundredtwenty/pickuptest(var/mob/living/carbon/human/user)
	if(user.mind.assigned_role == "Adhomian Circus Strongzhan")
		return TRUE
	if(user.species.name == SPECIES_VAURCA_WARRIOR)
		return TRUE
	if(user.species.name == SPECIES_VAURCA_BREEDER)
		return TRUE
	if(user.species.name == SPECIES_VAURCA_BULWARK)
		return TRUE
	if(user.species.name == SPECIES_VAURCA_WARFORM)
		return TRUE
	if(user.species.name == SPECIES_IPC_G1)
		return TRUE
	if(user.species.name == SPECIES_IPC_G2)
		return TRUE
	if(user.is_diona())
		return TRUE
	if(HULK in user.mutations)
		return TRUE
	else
		return FALSE

/obj/item/dumbbell/barbell/twohundredforty
	weight = "240"
	lifttime = 40
	slowdown = 9

/obj/item/dumbbell/barbell/twohundredforty/pickuptest(var/mob/living/carbon/human/user)
	if(user.mind.assigned_role == "Adhomian Circus Strongzhan")
		return TRUE
	if(user.species.name == SPECIES_VAURCA_BREEDER)
		return TRUE
	if(user.species.name == SPECIES_VAURCA_BULWARK)
		return TRUE
	if(user.species.name == SPECIES_VAURCA_WARFORM)
		return TRUE
	if(user.species.name == SPECIES_IPC_G1)
		return TRUE
	if(user.species.name == SPECIES_IPC_G2)
		return TRUE
	if(user.is_diona())
		return TRUE
	if(HULK in user.mutations)
		return TRUE
	else
		return FALSE

/obj/item/dumbbell/barbell/twohundredsixty
	weight = "260"
	lifttime = 50
	slowdown = 10

/obj/item/dumbbell/barbell/twohundredsixty/pickuptest(var/mob/living/carbon/human/user)
	if(user.mind.assigned_role == "Adhomian Circus Strongzhan")
		return TRUE
	if(user.species.name == SPECIES_VAURCA_BREEDER)
		return TRUE
	if(user.species.name == SPECIES_VAURCA_BULWARK)
		return TRUE
	if(user.species.name == SPECIES_VAURCA_WARFORM)
		return TRUE
	if(user.species.name == SPECIES_IPC_G2)
		return TRUE
	if(HULK in user.mutations)
		return TRUE
	else
		return FALSE

/obj/item/dumbbell/barbell/threehundred
	weight = "300"
	lifttime = 50
	slowdown = 11

/obj/item/dumbbell/barbell/threehundred/pickuptest(var/mob/living/carbon/human/user)
	if(user.mind.assigned_role == "Adhomian Circus Strongzhan")
		return TRUE
	if(user.species.name == SPECIES_VAURCA_BREEDER)
		return TRUE
	if(user.species.name == SPECIES_VAURCA_BULWARK)
		return TRUE
	if(user.species.name == SPECIES_VAURCA_WARFORM)
		return TRUE
	if(user.species.name == SPECIES_IPC_G2)
		return TRUE
	if(HULK in user.mutations)
		return TRUE
	else
		return FALSE