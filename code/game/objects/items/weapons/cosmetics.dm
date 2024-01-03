/obj/item/lipstick
	gender = PLURAL
	name = "red lipstick"
	desc = "A generic brand of lipstick."
	icon = 'icons/obj/cosmetics.dmi'
	icon_state = "lipstick"
	item_state = "lipstick"
	build_from_parts = TRUE
	contained_sprite = TRUE
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	update_icon_on_init = TRUE
	var/lipstick_color = "#DC253A"
	var/open = 0
	drop_sound = 'sound/items/drop/screwdriver.ogg'
	pickup_sound = 'sound/items/pickup/screwdriver.ogg'

/obj/item/lipstick/update_icon()
	cut_overlays()
	if(open)
		worn_overlay = "open_overlay"
		worn_overlay_color = lipstick_color
		icon_state = "[initial(icon_state)]_open"
		var/image/stick_overlay = image('icons/obj/cosmetics.dmi', null, "[initial(icon_state)]_open_overlay")
		stick_overlay.color = lipstick_color
		add_overlay(stick_overlay)
	else
		icon_state = initial(icon_state)
		worn_overlay = initial(worn_overlay)

/obj/item/lipstick/purple
	name = "purple lipstick"
	lipstick_color = "#9471C9"

/obj/item/lipstick/jade
	name = "jade lipstick"
	lipstick_color = "#3EB776"

/obj/item/lipstick/black
	name = "black lipstick"
	lipstick_color = "#56352F"

/obj/item/lipstick/amberred
	name = "amberred lipstick"
	lipstick_color = "#BA2E2A"

/obj/item/lipstick/cherry
	name = "cherry lipstick"
	lipstick_color = "#BD1E35"

/obj/item/lipstick/orange
	name = "orange lipstick"
	lipstick_color = "#F75F51"

/obj/item/lipstick/gold
	name = "gold lipstick"
	lipstick_color = "#DA8118"

/obj/item/lipstick/deepred
	name = "deepred lipstick"
	lipstick_color = "#850A1C"

/obj/item/lipstick/pink
	name = "pink lipstick"
	lipstick_color = "#E84272"

/obj/item/lipstick/rosepink
	name = "rosepink lipstick"
	lipstick_color = "#E2A4B1"

/obj/item/lipstick/nude
	name = "nude lipstick"
	lipstick_color = "#E7A097"

/obj/item/lipstick/wine
	name = "wine lipstick"
	lipstick_color = "#D25674"

/obj/item/lipstick/peach
	name = "peach lipstick"
	lipstick_color = "#D05049"

/obj/item/lipstick/forestgreen
	name = "forestgreen lipstick"
	lipstick_color = "#82B33B"

/obj/item/lipstick/skyblue
	name = "skyblue lipstick"
	lipstick_color = "#60C2C5"

/obj/item/lipstick/teal
	name = "teal lipstick"
	lipstick_color = "#0A857C"

/obj/item/lipstick/custom
	name = "lipstick"

/obj/item/lipstick/random
	name = "lipstick"

/obj/item/lipstick/random/Initialize()
	var/list/lipstick_subtypes = subtypesof(/obj/item/lipstick) - /obj/item/lipstick/random
	var/obj/item/lipstick/chosen_lipstick = pick(lipstick_subtypes)
	name = initial(chosen_lipstick.name)
	lipstick_color = initial(chosen_lipstick.lipstick_color)
	return ..()


/obj/item/lipstick/attack_self(mob/user as mob)
	to_chat(user, "<span class='notice'>You twist \the [src] [open ? "closed" : "open"].</span>")
	open = !open
	update_icon()

/obj/item/lipstick/attack(mob/M as mob, mob/user as mob)
	if(!open)	return

	if(!istype(M, /mob))	return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.lipstick_color)	//if they already have lipstick on
			to_chat(user, "<span class='notice'>You need to wipe off the old lipstick first!</span>")
			return
		if(H == user)
			user.visible_message("<span class='notice'>[user] does their lips with \the [src].</span>", \
									"<span class='notice'>You take a moment to apply \the [src]. Perfect!</span>")
			H.lipstick_color = lipstick_color
			H.update_body()
		else
			user.visible_message("<span class='warning'>[user] begins to do [H]'s lips with \the [src].</span>", \
									"<span class='notice'>You begin to apply \the [src].</span>")
			if(do_after(user, 4 SECONDS, H, do_flags = DO_DEFAULT & ~DO_SHOW_PROGRESS & ~DO_BOTH_CAN_TURN))
				user.visible_message("<span class='notice'>[user] does [H]'s lips with \the [src].</span>", \
										"<span class='notice'>You apply \the [src].</span>")
				H.lipstick_color = lipstick_color
				H.update_body()
	else
		to_chat(user, "<span class='notice'>Where are the lips on that?</span>")

//you can wipe off lipstick with paper! see code/modules/paperwork/paper.dm, paper/attack()


/obj/item/haircomb //sparklysheep's comb
	name = "plastic comb"
	desc = "A pristine comb made from flexible plastic."
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	icon = 'icons/obj/cosmetics.dmi'
	icon_state = "comb"
	item_state = "comb"

/obj/item/haircomb/random/Initialize()
	. = ..()
	color = get_random_colour(lower = 150)

/obj/item/haircomb/attack_self(mob/user)
	user.visible_message("<span class='notice'>[user] uses [src] to comb their hair with incredible style and sophistication. What a [user.gender == FEMALE ? "lady" : "guy"].</span>")

/obj/item/razor
	name = "electric razor"
	desc = "The latest and greatest power razor born from the science of shaving."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "razor"
	w_class = ITEMSIZE_SMALL

/obj/item/razor/proc/shave(mob/living/carbon/human/H, location)
	if(location == BP_HEAD)
		H.h_style = H.species.default_h_style
	else
		H.f_style = H.species.default_f_style

	H.update_hair()
	playsound(H, 'sound/items/welder_pry.ogg', 20, 1)


/obj/item/razor/attack(mob/M, mob/user, var/target_zone)
	if(!ishuman(M))
		return ..()

	var/mob/living/carbon/human/H = M
	var/obj/item/organ/external/E = H.get_organ(target_zone)

	if(!E || E.is_stump())
		to_chat(user, "<span class='danger'>They are missing that limb!</span>")
		return FALSE

	if(!ishuman_species(H) && !istajara(H))	//you can only shave humans and tajara for obvious reasons
		return FALSE


	if(target_zone == BP_HEAD)
		if(H.head && (H.head.body_parts_covered & HEAD))
			to_chat(user, "<span class='warning'>\The [H.head] is in the way!</span>")
			return FALSE

		if(H.h_style == "Bald" || H.h_style == "Balding Hair" || H.h_style == "Skinhead" || H.h_style == "Tajaran Ears")
			to_chat(user, "<span class='warning'>There is not enough hair left to shave!</span>")
			return FALSE

		if(H == user) //shaving yourself
			user.visible_message("\The [user] starts to shave [user.get_pronoun("his")] head with \the [src].", \
									"<span class='notice'>You start to shave your head with \the [src].</span>")
			if(do_mob(user, user, 20))
				user.visible_message("\The [user] shaves [user.get_pronoun("his")] head with \the [src].", \
										"<span class='notice'>You finish shaving with \the [src].</span>")
				shave(H, target_zone)

			return TRUE

		else
			user.visible_message("<span class='warning'>\The [user] tries to shave \the [H]'s head with \the [src]!</span>", \
									"<span class='notice'>You start shaving [H]'s head.</span>")
			if(do_mob(user, H, 20))
				user.visible_message("<span class='warning'>\The [user] shaves \the [H]'s head bald with \the [src]!</span>", \
										"<span class='notice'>You shave \the [H]'s head bald.</span>")
				shave(H, target_zone)

				return TRUE

	else if(target_zone == BP_MOUTH)

		if(H.head && (H.head.body_parts_covered & FACE))
			to_chat(user, "<span class='warning'>\The [H.head] is in the way!</span>")
			return FALSE

		if(H.wear_mask && (H.wear_mask.body_parts_covered & FACE))
			to_chat(user, "<span class='warning'>\The [H.wear_mask] is in the way!</span>")
			return FALSE

		if(H.f_style == "Shaved")
			to_chat(user, "<span class='warning'>There is not enough facial hair left to shave!</span>")
			return	FALSE

		if(H == user) //shaving yourself
			user.visible_message("<span class='warning'>\The [user] starts to shave [user.get_pronoun("his")] facial hair with \the [src].</span>", \
									"<span class='notice'>You take a moment to shave your facial hair with \the [src].</span>")
			if(do_mob(user, user, 20))
				user.visible_message("<span class='warning'>\The [user] shaves [user.get_pronoun("his")] facial hair clean with \the [src].</span>", \
										"<span class='notice'>You finish shaving with \the [src].</span>")
				shave(H, target_zone)

			return TRUE

		else
			user.visible_message("<span class='warning'>\The [user] tries to shave \the [H]'s facial hair with \the [src].</span>", \
									"<span class='notice'>You start shaving [H]'s facial hair.</span>")
			if(do_mob(user, H, 20))
				user.visible_message("<span class='warning'>\The [user] shaves off \the [H]'s facial hair with \the [src].</span>", \
										"<span class='notice'>You shave [H]'s facial hair clean off.</span>")
				shave(H, target_zone)

				return TRUE


	else
		to_chat(user, "<span class='warning'>You need to target the mouth or head to shave \the [H]!</span>")
		return


