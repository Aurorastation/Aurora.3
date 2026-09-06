/obj/item/reagent_containers/food/snacks/fish
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 3)
	bitesize = 6
	var/fish_type = "fish"

/obj/item/reagent_containers/food/snacks/fish/attackby(obj/item/attacking_item, mob/user)
	if(is_sharp(attacking_item) && (locate(/obj/structure/table) in loc))
		var/transfer_amt = FLOOR(reagents.total_volume/3, 1)
		for(var/i = 1 to 3)
			var/obj/item/reagent_containers/food/snacks/sashimi/sashimi = new(get_turf(src), fish_type)
			reagents.trans_to(sashimi, transfer_amt)
		qdel(src)

/obj/item/reagent_containers/food/snacks/fish/carpmeat
	name = "carp fillet"
	desc = "A fillet of space carp meat."
	reagents_to_add = list(/singleton/reagent/toxin/carpotoxin = 3, /singleton/reagent/nutriment/protein/seafood = 3)
	fish_type = "space carp"

/obj/item/reagent_containers/food/snacks/fish/fishfillet
	name = "fish fillet"
	desc = "A fillet of fish."

/obj/item/reagent_containers/food/snacks/fish/roe
	name = "roe sack"
	desc = "A fleshy organ filled with fish eggs."
	icon_state = "roesack"
	fish_type = "fish"
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 3)

/obj/item/reagent_containers/food/snacks/fish/mollusc
	name = "slimy meat"
	desc = "Some slimy meat from clams or molluscs."
	fish_type = "mollusc"
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood/mollusc = 3)

/obj/item/reagent_containers/food/snacks/fish/mollusc/clam
	fish_type = "clam"

/obj/item/reagent_containers/food/snacks/fish/mollusc/barnacle
	fish_type = "barnacle"

/obj/item/reagent_containers/food/snacks/fish/cosmozoan
	name = "slimy fillet"
	desc = "A piece of slimy meat that could only come from a space jellyfish, a cosmozoan."
	icon_state = "cozmofillet"
	fish_type = "cosmozoan"
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood/cosmozoan = 3)

/obj/item/reagent_containers/food/snacks/fish/raw_shrimp
	name = "raw shrimp"
	desc = "They're so small! Shrimpy, even."
	icon_state = "shrimp_raw"
	fish_type = "shrimp"

// Molluscs!
/obj/item/trash/mollusc_shell
	name = "mollusc shell"
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
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
	w_class = WEIGHT_CLASS_TINY
	desc = "A small slimy mollusc. Fresh!"
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "mollusc"
	var/meat_type = /obj/item/reagent_containers/food/snacks/fish/mollusc
	var/shell_type = /obj/item/trash/mollusc_shell

/obj/item/mollusc/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "You will need a sharp or edged implement to pry it open. You can also try opening it in your hand if you're strong enough."

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
	playsound(loc, SFX_PICKAXE, 40, TRUE)
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

/obj/item/mollusc/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.sharp || attacking_item.edge)
		user.visible_message("<b>[user]</b> cracks open \the [src] with \the [attacking_item].", SPAN_NOTICE("You crack open \the [src] with \the [attacking_item]."))
		crack_shell(user)
		return
	return ..()

// fish?
/obj/item/reagent_containers/food/snacks/dwellermeat
	name = "worm fillet"
	desc = "A fillet of electrifying cavern meat."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"
	bitesize = 6
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 6, /singleton/reagent/hyperzine = 15, /singleton/reagent/acid/polyacid = 6)

/obj/item/reagent_containers/food/snacks/psiren_tentacle_meat
	name = "Psiren tentacle"
	desc = "A long, smooth tentacle. It's an off putting blue colour. WAIT, DID IT JUST MOVE??? No... That was a trick of the light... Probably."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "psiren_tentacle_meat"
	reagents_to_add = list(/singleton/reagent/drugs/mindbreaker = 2, /singleton/reagent/nutriment/protein/seafood = 3)
	reagent_data = list(/singleton/reagent/nutriment/protein/seafood = list("fizzy chicken" = 5))
	filling_color = "#206a88"

/obj/item/reagent_containers/food/snacks/psiren_tentacle_meat/attackby(obj/item/attacking_item, mob/user)
	if(has_edge(attacking_item)) //this checks if the item you click the meat with is a knife/has an edge
		user.visible_message(SPAN_NOTICE("[user] slices [src]!"))
		var/psiren_cutlet = new /obj/item/reagent_containers/food/snacks/raw_psiren_cutlet(loc)
		reagents.trans_to_obj(psiren_cutlet, reagents.total_volume / 2)
		var/psiren_leather = new /obj/item/reagent_containers/food/snacks/psiren_leather(loc)
		reagents.trans_to_obj(psiren_leather, reagents.total_volume / 2)
		qdel_self()

/obj/item/reagent_containers/food/snacks/psiren_body_meat
	name = "psiren meat"
	desc = "A slab of amber-colored meat with a bit of blueish skin attached. The slightest motion makes it look like something is shifting inside."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "psiren_body_meat"
	reagents_to_add = list(/singleton/reagent/drugs/mindbreaker = 2, /singleton/reagent/nutriment/protein/seafood = 4)
	reagent_data = list(/singleton/reagent/nutriment/protein/seafood = list("fizzy chicken" = 5))
	filling_color = "#f5c235"

/obj/item/reagent_containers/food/snacks/psiren_body_meat/attackby(obj/item/attacking_item, mob/user)
	if(has_edge(attacking_item)) //this checks if the item you click the meat with is a knife/has an edge
		user.visible_message(SPAN_NOTICE("[user] slices [src]!"))
		for(var/i = 1 to 3)
			var/obj/item/reagent_containers/food/snacks/raw_psiren_cutlet/psiren_cutlet = new (loc)
			reagents.trans_to_obj(psiren_cutlet, reagents.total_volume / 4)
		var/psiren_leather = new /obj/item/reagent_containers/food/snacks/psiren_leather(loc)
		reagents.trans_to_obj(psiren_leather, reagents.total_volume / 4)
		qdel_self()

/obj/item/reagent_containers/food/snacks/raw_psiren_cutlet
	name = "raw psiren cutlet"
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	desc = "Small slices of Psiren meat. Not so tough now, are you, squid?"
	icon_state = "psiren_cutlet"
	filling_color = "#f5c235"

/obj/item/reagent_containers/food/snacks/psiren_leather
	name = "psiren leather"
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	desc = "The blueish skin of a Psiren. It's very glossy and kind of pretty when it's not attached to a vicious monster trying to kill you."
	icon_state = "psiren_leather"
	filling_color = "#247892"
	bitesize = 0.2 //it's rubbery
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 1)
	reagent_data = list(/singleton/reagent/nutriment/protein/seafood = list("chewy, bitter fish leather" = 8))
