//wip wip wup
/obj/structure/mirror
	name = "mirror"
	desc = "A SalonPro Nano-Mirror(TM) brand mirror! The leading technology in hair salon products, utilizing nano-machinery to style your hair just right."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	density = 0
	anchored = 1
	var/shattered = 0
	var/list/ui_users = list()

/obj/structure/mirror/attack_hand(mob/user as mob)

	if(shattered)	return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/userloc = H.loc

		var/list/hair_styles = H.valid_hairstyles_for_this_mob()
		var/list/facial_styles = H.valid_facialhairstyles_for_this_mob()

		if (facial_styles.len > 1) //handle facial hair (if necessary)
			var/new_style = input(user, "Select a facial hair style", "Grooming")  as null|anything in facial_styles
			if(userloc != H.loc) return	//no tele-grooming
			if(new_style)
				H.f_style = new_style

		//handle normal hair
		if (hair_styles.len)
			var/new_style = input(user, "Select a hair style", "Grooming")  as null|anything in hair_styles
			if(userloc != H.loc) return	//no tele-grooming
			if(new_style)
				H.h_style = new_style

		//machines can change their eye colours in the mirror
		if (istype(H.species,/datum/species/machine))
			var/new_eyes = input(user, "Choose your new eye colour.", "Robotic Eyes", rgb(H.r_eyes,H.g_eyes,H.b_eyes)) as color|null
			if(new_eyes)
				var/list/new_eyes_as_values = htmlcolour_to_values(new_eyes)
				H.r_eyes=new_eyes_as_values[1]
				H.g_eyes=new_eyes_as_values[2]
				H.b_eyes=new_eyes_as_values[3]
				H.update_hair() // need to do a full rebuild here
				H.update_body()
				return
		H.update_hair()


/obj/structure/mirror/proc/shatter()
	if(shattered)	return
	shattered = 1
	icon_state = "mirror_broke"
	playsound(src, "shatter", 70, 1)
	desc = "Oh no, seven years of bad luck!"


/obj/structure/mirror/bullet_act(var/obj/item/projectile/Proj)
	if(!(Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		return

	if(prob(Proj.damage * 2))
		if(!shattered)
			shatter()
		else
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
	..()

/obj/structure/mirror/attackby(obj/item/I as obj, mob/user as mob)
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return

	if(prob(I.force * 2))
		visible_message("<span class='warning'>[user] smashes [src] with [I]!</span>")
		shatter()
	else
		visible_message("<span class='warning'>[user] hits [src] with [I]!</span>")
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 70, 1)

/obj/structure/mirror/attack_generic(var/mob/user, var/damage)

	user.do_attack_animation(src)
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return 0

	if(damage)
		user.visible_message("<span class='danger'>[user] smashes [src]!")
		shatter()
	else
		user.visible_message("<span class='danger'>[user] hits [src] and bounces off!</span>")
	return 1

// The following mirror is ~special~.
/obj/structure/mirror/raider
	name = "cracked mirror"
	desc = "Something seems strange about this old, dirty mirror. Your reflection doesn't look like you remember it."
	icon_state = "mirror_broke"
	shattered = 1

/obj/structure/mirror/raider/attack_hand(var/mob/living/carbon/human/user)
	if(istype(get_area(src),/area/syndicate_mothership))
		if(istype(user) && user.mind && user.mind.special_role == "Raider" && user.species.name != "Vox" && is_alien_whitelisted(user, "Vox"))
			var/choice = input("Do you wish to become a true Vox of the Shoal? This is not reversible.") as null|anything in list("No","Yes")
			if(choice && choice == "Yes")
				var/mob/living/carbon/human/vox/vox = new(get_turf(src),"Vox")
				vox.gender = user.gender
				raiders.equip(vox)
				if(user.mind)
					user.mind.transfer_to(vox)
				spawn(1)
					var/newname = sanitizeSafe(input(vox,"Enter a name, or leave blank for the default name.", "Name change","") as text, MAX_NAME_LEN)
					if(!newname || newname == "")
						var/datum/language/L = all_languages[vox.species.default_language]
						newname = L.get_random_name()
					vox.real_name = newname
					vox.name = vox.real_name
					raiders.update_access(vox)
				qdel(user)
	..()
