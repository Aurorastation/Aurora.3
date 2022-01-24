/obj/item/reagent_containers/food/snacks/fish
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"
	reagents_to_add = list(/decl/reagent/nutriment/protein/seafood = 3)
	bitesize = 6
	var/fish_type = "fish"

/obj/item/reagent_containers/food/snacks/fish/attackby(var/obj/item/W, var/mob/user)
	if(is_sharp(W) && (locate(/obj/structure/table) in loc))
		var/transfer_amt = Floor(reagents.total_volume/3)
		for(var/i = 1 to 3)
			var/obj/item/reagent_containers/food/snacks/sashimi/sashimi = new(get_turf(src), fish_type)
			reagents.trans_to(sashimi, transfer_amt)
		qdel(src)

/obj/item/reagent_containers/food/snacks/fish/carpmeat
	name = "carp fillet"
	desc = "A fillet of space carp meat."
	reagents_to_add = list(/decl/reagent/toxin/carpotoxin = 3, /decl/reagent/nutriment/protein/seafood = 3)
	fish_type = "space carp"

/obj/item/reagent_containers/food/snacks/fish/fishfillet
	name = "fish fillet"
	desc = "A fillet of fish."

/obj/item/reagent_containers/food/snacks/fish/roe
	name = "roe sack"
	desc = "A fleshy organ filled with fish eggs."
	icon_state = "roesack"
	fish_type = "fish"
	reagents_to_add = list(/decl/reagent/nutriment/protein/seafood = 3)

/obj/item/reagent_containers/food/snacks/fish/mollusc
	name = "slimy meat"
	desc = "Some slimy meat from clams or molluscs."
	fish_type = "mollusc"
	reagents_to_add = list(/decl/reagent/nutriment/protein/seafood/mollusc = 3)

/obj/item/reagent_containers/food/snacks/fish/mollusc/clam
	fish_type = "clam"

/obj/item/reagent_containers/food/snacks/fish/mollusc/barnacle
	fish_type = "barnacle"

/obj/item/reagent_containers/food/snacks/fish/cosmozoan
	name = "slimy fillet"
	desc = "A piece of slimy meat that could only come from a space jellyfish, a cosmozoan."
	icon_state = "cozmofillet"
	fish_type = "cosmozoan"
	reagents_to_add = list(/decl/reagent/nutriment/protein/seafood/cosmozoan = 3)

// Molluscs!
/obj/item/trash/mollusc_shell
	name = "mollusc shell"
	icon = 'icons/obj/molluscs.dmi'
	icon_state = "mollusc_shell"
	desc = "The cracked shell of an unfortunate mollusc."

/obj/item/trash/mollusc_shell/clam
	name = "clamshell"
	icon_state = "clam_shell"

/obj/item/trash/mollusc_shell/barnacle
	name = "barnacle shell"
	icon_state = "barnacle_shell"

/obj/item/mollusc
	name = "mollusc"
	w_class = ITEMSIZE_TINY
	desc = "A small slimy mollusc. Fresh!"
	desc_info = "You will need a sharp or edged implement to pry it open. You can also try opening it in your hand if you're strong enough."
	icon = 'icons/obj/molluscs.dmi'
	icon_state = "mollusc"
	var/meat_type = /obj/item/reagent_containers/food/snacks/fish/mollusc
	var/shell_type = /obj/item/trash/mollusc_shell

/obj/item/mollusc/barnacle
	name = "barnacle"
	desc = "A hull barnacle, probably freshly scraped off a spaceship."
	icon_state = "barnacle"
	meat_type = /obj/item/reagent_containers/food/snacks/fish/mollusc/barnacle
	shell_type = /obj/item/trash/mollusc_shell/barnacle

/obj/item/mollusc/clam
	name = "clam"
	desc = "A free-ranging space clam."
	icon_state = "clam"
	meat_type = /obj/item/reagent_containers/food/snacks/fish/mollusc/clam
	shell_type = /obj/item/trash/mollusc_shell/clam

/obj/item/mollusc/proc/crack_shell(var/mob/user)
	playsound(loc, /decl/sound_category/pickaxe_sound, 40, TRUE)
	if(user && loc == user)
		user.drop_from_inventory(src)
	if(meat_type)
		var/obj/item/meat = new meat_type(get_turf(src))
		if(user)
			user.put_in_hands(meat)
	if(shell_type)
		var/obj/item/shell = new shell_type(get_turf(src))
		if(user)
			user.put_in_hands(shell)
	qdel(src)

/obj/item/mollusc/attack_self(mob/user)
	if(isvaurca(user) || isipc(user) || isunathi(user))
		user.visible_message("<b>[user]</b> cracks open \the [src] with their hands.", SPAN_NOTICE("You crack open \the [src] with your hands."))
		crack_shell(user)
		return
	return ..()

/obj/item/mollusc/attackby(var/obj/item/thing, var/mob/user)
	if(thing.sharp || thing.edge)
		user.visible_message("<b>[user]</b> cracks open \the [src] with \the [thing].", SPAN_NOTICE("You crack open \the [src] with \the [thing]."))
		crack_shell(user)
		return
	return ..()

/obj/item/mollusc/clam/rasval
	name = "ras'val clam"
	desc = "An adhomian clam, native to the sea of Ras'val."
	icon_state = "ras'val_clams"
	meat_type = /obj/item/reagent_containers/food/snacks/clam
	shell_type = /obj/item/trash/mollusc_shell/clam/rasval

/obj/item/trash/mollusc_shell/clam/rasval
	name = "ras'val clam shell"
	icon_state = "ras'val_clams_shell"