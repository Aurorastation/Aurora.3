/*

We need to mix blending into limb object code, this will slow shit down a lot.

*/

var/SYNTHETIC_COVERING_WORKING=1
var/SYNTHETIC_COVERING_DAMAGED=0

datum/synthetic_limb_cover
	var/coverage //
	var/colour=null//
	var/obj/item/organ/external/limb_datum // the limb in question
	var/obj/item/robot_parts/limb_item // also the limb in question (if dismembered)
	var/main_icon = 'icons/mob/human_races/robotic.dmi'
	var/damage_icon = 'icons/mob/human_races/robotic.dmi'
	var/icon_key_type="BAD"
	var/hair_species=null
	var/eyes_state = "blank_eyes"
	var/tail = null


datum/synthetic_limb_cover/New(	var/obj/item/organ/external/datum_target=null,var/input_colour=null)
	limb_datum=datum_target
	coverage=SYNTHETIC_COVERING_WORKING // start working
	colour= (input_colour) ? input_colour : rgb(128,128,128)


datum/synthetic_limb_cover/proc/get_icon() // default mechanical limbs return robo versions
	var/icon/temp = new /icon((coverage ? main_icon : damage_icon), "[limb_datum.icon_name][limb_datum.get_gender_string()]") // only add a gender if it's necessary
	var/icon/result = icon(temp)
	if (coverage)
		result.Blend(colour, ICON_ADD)
	return result


datum/synthetic_limb_cover/proc/repair()
	coverage = SYNTHETIC_COVERING_WORKING
	update_icon()


datum/synthetic_limb_cover/proc/damage()
	coverage = SYNTHETIC_COVERING_DAMAGED
	update_icon()


datum/synthetic_limb_cover/proc/set_colour(input_colour)
	colour=input_colour


datum/synthetic_limb_cover/proc/update_icon()
	if (limb_datum)
		if (limb_datum.owner)
			limb_datum.owner.update_body()


datum/synthetic_limb_cover/proc/get_icon_key() // this is going to wreck the icon cache but to do custom colour per limb this is necessary
	return "SYNTH:[icon_key_type]:[colour]:[coverage]"


datum/synthetic_limb_cover/paint
	main_icon = 'icons/mob/human_races/r_machine.dmi'
	icon_key_type = "Paint"
	hair_species = "Machine"


datum/synthetic_limb_cover/skin
	main_icon = 'icons/mob/human_races/r_human_grey.dmi'
	icon_key_type = "Skin"
	hair_species = "Human"
	eyes_state="eyes_s"


datum/synthetic_limb_cover/fur
	main_icon = 'icons/mob/human_races/r_tajaran.dmi'
	icon_key_type = "Fur"
	hair_species = "Tajaran"
	eyes_state="eyes_s"
	tail = "tajtail"


datum/synthetic_limb_cover/scales
	main_icon = 'icons/mob/human_races/r_lizard.dmi'
	icon_key_type = "Scales"
	hair_species = "Unathi"
	eyes_state="eyes_s"
	tail = "sogtail"


var/list/limb_covering_references
/proc/get_limb_covering_references()
	if (isnull(limb_covering_references))
		limb_covering_references = list()
		for(var/skin_type in typesof(/datum/synthetic_limb_cover)-/datum/synthetic_limb_cover)
			var/datum/synthetic_limb_cover/temp_cover = new skin_type()
			limb_covering_references[skin_type]=temp_cover
	return limb_covering_references


var/list/limb_covering_names
/proc/get_limb_covering_names()
	if (isnull(limb_covering_names))
		limb_covering_names=list("None")
		var/list/refs=get_limb_covering_references()
		for(var/skin_type in refs)
			var/datum/synthetic_limb_cover/temp=refs[skin_type]
			limb_covering_names.Add(temp.icon_key_type)
	return limb_covering_names


var/list/limb_covering_list
/proc/get_limb_covering_list()
	if(isnull(limb_covering_list))
		limb_covering_list=list("None"=null)
		var/list/refs=get_limb_covering_references()
		for(var/skin_type in refs)
			var/datum/synthetic_limb_cover/temp=refs[skin_type]
			limb_covering_list[temp.icon_key_type]=skin_type
	return limb_covering_list


/obj/item/weapon/synth_skin_spray
	name = "robot paint gun"
	desc = "A compact hand-held spray gun for painting synthetics."
	icon = 'icons/obj/synthskin.dmi'
	icon_state = "spray_can_icon"
	force = 5.0
	throwforce = 7.0
	w_class = 2.0
	slot_flags = SLOT_BELT
	origin_tech = "materials=1;engineering=1"
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")
	var/icon/spray_can_icon = null
	var/obj/item/weapon/synth_skin_cartridge/cartridge = null
	var/construction_time = 20
	var/list/construction_cost = list("metal"=400,"glass"=100)
	New()
		update_icon()


proc/create_tinted_icon(icon_name, icon_state_name, target_colour)
	var/icon/result = new /icon(icon_name,icon_state_name)
	result.Blend(target_colour, ICON_ADD)  // if we have charges left, show the colour, otherwise grey
	return result


/obj/item/weapon/synth_skin_spray/proc/paint_icon()
	return create_tinted_icon(icon,"installed_paint_skin",cartridge.paint_colour)

/obj/item/weapon/synth_skin_spray/proc/hair_icon()
	return create_tinted_icon(icon,"installed_paint_hair",cartridge.hair_colour)

/obj/item/weapon/synth_skin_spray/proc/cartridge_icon()
	return new/icon(icon,"[cartridge.installed_icon]")

/obj/item/weapon/synth_skin_spray/proc/charges_icon()
	return new/icon(icon,"charges_[cartridge.current_charges]")


/obj/item/weapon/synth_skin_spray/update_icon()
	underlays.Cut()
	overlays.Cut()
	if (cartridge)
		underlays += cartridge_icon()
		underlays += paint_icon()
		underlays += hair_icon()
		overlays  += charges_icon()


/obj/item/weapon/synth_skin_spray/attack(mob/M, mob/user)
	switch (user.a_intent)
		if ("hurt")
			..(M,user)
			playsound(loc, "swing_hit", 50, 1, -1)
		if("help")
			return try_to_paint(M,user)


/obj/item/weapon/synth_skin_spray/proc/allowed_to_paint(mob/living/carbon/human/human_target, mob/user, target)
	if (!cartridge)
		user << "<span class='notice'>You cannot paint anything with an empty spray gun.</span>"
		if (human_target!=user)
			human_target << "<span class='notice'>[user] waves the spray gun vaguely toward you but the gun is empty.</span>"
		return
	if (!cartridge.current_charges)
		user << "<span class='notice'>You click the [src] but your [cartridge] is empty.</span>"
		if (human_target!=user)
			human_target << "<span class='notice'>[user] clicks the [src] at you but their [cartridge] is empty.</span>"
		return
	if(!istype(human_target,/mob/living/carbon/human))
		user << "<span class='notice'>You can't figure out a way you could apply paint to [human_target].</span>"
		if (human_target!=user)
			human_target << "<span class='notice'>[user] stares at you and appears to decide that they're unable to paint you.</span>"
		return
	var/obj/item/organ/external/datum_target=human_target.get_organ(target)
	if(!datum_target || (!datum_target.can_take_covering()))
		user << "<span class='notice'>You cannot paint [human_target]'s [target] because it's too badly damaged.</span>"
		if (human_target!=user)
			human_target << "<span class='notice'>[user] goes to paint your [target] but it's too badly damaged.</span>"
		return
	if (!(datum_target.status && ORGAN_ROBOT))
		if (human_target!=user)
			user << "<span class='notice'>You go to paint [human_target]'s [target] but realize that it isn't robotic..</span>"
			human_target << "<span class='notice'>[user] looks like they are about to try to paint your [target] before realizing that it isn't robotic.</span>"
		else
			user << "<span class='notice'>Your [target] isn't robotic, so you decide not to try to paint it.</span>"
		return
	return TRUE


/obj/item/weapon/synth_skin_spray/proc/try_to_paint(mob/living/carbon/human/human_target, mob/user)
	var/target=user.zone_sel.selecting
	if (target in list("mouth","eyes")) // we don't paint these individually
		target="head"
	if (allowed_to_paint(human_target,user,target))
		if (do_after_to_target(user,human_target,20))
			paint_organ(human_target, user, human_target.get_organ(target))


/obj/item/weapon/synth_skin_spray/proc/paint_organ(mob/M, mob/user, obj/item/organ/external/datum_target)
	if (datum_target.covering) // if we've already got a covering, remove it
		del(datum_target.covering)
	datum_target.covering = new cartridge.covering_path(datum_target,cartridge.paint_colour)
	var/mob/living/carbon/human/human_target = M
	if (istype(datum_target,/obj/item/organ/external/head))
		var/list/hair_colour_as_list = htmlcolour_to_values(cartridge.hair_colour)
		human_target.r_hair = hair_colour_as_list[1] // byond starts at 1! WHYYYYYYY?!!!! -jf
		human_target.g_hair = hair_colour_as_list[2]
		human_target.b_hair = hair_colour_as_list[3]
		human_target.r_facial = hair_colour_as_list[1]
		human_target.g_facial = hair_colour_as_list[2]
		human_target.b_facial = hair_colour_as_list[3]
		human_target.update_hair()
	if (istype(datum_target,/obj/item/organ/external/groin)) // this is a bit reductive, but whatever
		var/gender_string = input(user,"What sex do you want this shell to appear as?") in list("Male","Female")
		human_target.gender = (gender_string=="Male") ? MALE : FEMALE
		human_target.update_tail_showing(FALSE)
	human_target.update_body(TRUE)
	cartridge.current_charges--
	user.visible_message("<span class='notice'>[user] has covered [M]'s [datum_target.name] with [cartridge.covering_description].</span>")
	update_icon()


/obj/item/weapon/synth_skin_spray/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/synth_skin_cartridge))
		if (!cartridge)
			user.drop_item()
			W.loc = src
			cartridge=W
			user << "<span class='notice'>You insert \the [W] into [src].</span>"
			update_icon()
		else
			user << "<span class='notice'>You will have to remove the other cartridge first."


/obj/item/weapon/synth_skin_spray/attack_hand(mob/user)
	var/obj/item/inactive_item = user.get_inactive_hand()
	if (src==inactive_item) // if we are clicking on this with our off hand
		if(src.cartridge)
			src.cartridge.add_fingerprint(user)
			user.put_in_active_hand(src.cartridge)
			user << "<span class='notice'>You remove \the [src.cartridge] from the [src]."
			src.cartridge.update_icon()
			src.cartridge = null
			update_icon()
			return
	return ..()


/obj/item/weapon/synth_skin_cartridge
	name = "ERROR"
	desc = "You should not be reading this."
	icon = 'icons/obj/synthskin.dmi'
	icon_state = "bottle_paint"
	var/installed_icon = "installed_paint"
	var/max_charges = 9
	var/current_charges = 9
	var/construction_time = 20
	var/paint_colour = null
	var/hair_colour = null
	var/covering_description = "paint"
	var/list/construction_cost = list("metal"=200,"glass"=50)
	var/covering_path = "/datum/synthetic_limb_cover/paint"
	origin_tech = "materials=1;engineering=1"
	New()
		paint_colour = rgb(128,128,128) // starts on red
		hair_colour = rgb(128,128,128) // starts black
		update_icon()


/obj/item/weapon/synth_skin_cartridge/proc/get_charges_string()
	return " It looks like there are [current_charges] charges left."


/obj/item/weapon/synth_skin_cartridge/examine()
	set src in usr
	usr << src.desc + get_charges_string()


/obj/item/weapon/synth_skin_cartridge/attack_self(mob/user)
	pick_colours(user)


/obj/item/weapon/synth_skin_cartridge/proc/pick_colours(mob/user)
	var/new_paint = input(user, "Choose the primary colour you want to paint.", "Synthetic Painting", paint_colour) as color|null
	if(new_paint)
		paint_colour = new_paint
	var/new_hair = input(user, "Choose the hair colour you want to paint.", "Synthetic Painting", hair_colour) as color|null
	if(new_hair)
		hair_colour = new_hair
	update_icon()


/obj/item/weapon/synth_skin_cartridge/proc/paint_icon()
	return create_tinted_icon(icon,"bottle_paint_skin",paint_colour)


/obj/item/weapon/synth_skin_cartridge/proc/hair_icon()
	return create_tinted_icon(icon,"bottle_paint_hair",hair_colour)


/obj/item/weapon/synth_skin_cartridge/update_icon()
	overlays.Cut()
	if (current_charges > 0)
		overlays += paint_icon()
		overlays += hair_icon()


/obj/item/weapon/synth_skin_cartridge/paint
	name = "synthetic paint cartridge"
	desc = "A small cartridge for robotic paint."


/obj/item/weapon/synth_skin_cartridge/skin
	name = "synthetic skin cartridge"
	desc = "A small cartridge filled with pressurized synthetic skin. It's covered in thin grease."
	icon_state = "bottle_skin"
	installed_icon = "installed_skin"
	covering_path = "/datum/synthetic_limb_cover/skin"
	origin_tech = "materials=1;engineering=1;biotech=2"
	covering_description = "synthetic skin"


/obj/item/weapon/synth_skin_cartridge/fur
	name = "synthetic fur cartridge"
	desc = "A small cartridge filled with pressurized synthetic fur. Dozens of fine hairs are stuck to it with static."
	icon_state = "bottle_fur"
	installed_icon = "installed_fur"
	covering_path = "/datum/synthetic_limb_cover/fur"
	origin_tech = "materials=1;engineering=1;biotech=3"
	covering_description = "synthetic fur"


/obj/item/weapon/synth_skin_cartridge/scales
	name = "synthetic scales cartridge"
	desc = "A small cartridge filled with pressurized synthetic scales. It makes a dry crunching noise when you shake it."
	icon_state = "bottle_scales"
	installed_icon = "installed_scales"
	covering_path = "/datum/synthetic_limb_cover/scales"
	origin_tech = "materials=1;engineering=1;biotech=3"
	covering_description = "synthetic scales"