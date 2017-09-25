// Human caches have been moved to SSicon_cache.

	///////////////////////
	//UPDATE_ICONS SYSTEM//
	///////////////////////
/*
Calling this a system is perhaps a bit trumped up. It is essentially update_clothing dismantled into its
core parts. The key difference is that when we generate overlays we do not generate either lying or standing
versions. Instead, we generate one set of "raw" (non-overlay-list friendly) overlays which are further processed
by SSoverlays when update_icons() runs. A single entry may be an /icon, an /image, or a /list of the former two.

	var/overlays_raw[26]

This system involves a bit more list churn than the old (bay) system, but should involve significantly less appearance
churn, plus has the benefit of reducing the number of overlays-with-overlays (compound overlays).
We also can put raw /icon instances directly in the list this way and SSoverlays will automatically convert them into
a more client-friendly format.

In the old system, we updated all our overlays every life() call, even if we were standing still inside a crate!
or dead!. 25ish overlays, all generated from scratch every second for every xeno/human/monkey and then applied.
More often than not update_clothing was being called a few times in addition to that! CPU was not the only issue,
all those icons had to be sent to every client. So really the cost was extremely cumulative. To the point where
update_clothing would frequently appear in the top 10 most CPU intensive procs during profiling.

Like the bay system, our list is indexed. This means we can update specific overlays!
So we only regenerate icons when we need them to be updated!
Also like bay, we use transforms to handle lying states instead of a separate set of icons.

There are several things that need to be remembered:

>	Whenever we do something that should cause an overlay to update (which doesn't use standard procs
	( i.e. you do something like l_hand = /obj/item/something new(src) )
	You will need to call the relevant update_inv_* proc:
		update_inv_head()
		update_inv_wear_suit()
		update_inv_gloves()
		update_inv_shoes()
		update_inv_w_uniform()
		update_inv_glasses()
		update_inv_l_hand()
		update_inv_r_hand()
		update_inv_belt()
		update_inv_wear_id()
		update_inv_ears()
		update_inv_s_store()
		update_inv_pockets()
		update_inv_back()
		update_inv_handcuffed()
		update_inv_wear_mask()

	All of these are named after the variable they update from. They are defined at the mob/ level like
	update_clothing was, so you won't cause undefined proc runtimes with usr.update_inv_wear_id() if the usr is a
	slime etc. Instead, it'll just return without doing any work. So no harm in calling it for slimes and such.


>	There are also these special cases:
		update_mutations()	//handles updating your appearance for certain mutations.  e.g TK head-glows
		UpdateDamageIcon()	//handles damage overlays for brute/burn damage //(will rename this when I geta round to it)
		update_body()	//Handles updating your mob's icon to reflect their gender/race/complexion etc
		update_hair()	//Handles updating your hair overlay (used to be update_face, but mouth and
																			...eyes were merged into update_body)
		update_targeted() // Updates the target overlay when someone points a gun at you

>	All of these procs update overlays_raw, and then call update_icons() by default.
	If you wish to update several overlays at once, you can set the argument to 0 to disable the update and call
	it manually:
		e.g.
		update_inv_head(0)
		update_inv_l_hand(0)
		update_inv_r_hand()		//<---calls update_icons()

	or equivalently:
		update_inv_head(0)
		update_inv_l_hand(0)
		update_inv_r_hand(0)
		update_icons()

>	If you need to update all overlays you can use regenerate_icons(). it works exactly like update_clothing used to.

>	I reimplemented an old unused variable which was in the code called (coincidentally) var/update_icon
	It can be used as another method of triggering regenerate_icons(). It's basically a flag that when set to non-zero
	will call regenerate_icons() at the next life() call and then reset itself to 0.
	The idea behind it is icons are regenerated only once, even if multiple events requested it.
*/

// Human Overlays Indexes //
#define MUTATIONS_LAYER   1
#define DAMAGE_LAYER      2
#define SURGERY_LAYER     3
#define UNIFORM_LAYER     4
#define ID_LAYER          5
#define SHOES_LAYER       6
#define GLOVES_LAYER      7
#define BELT_LAYER        8
#define SUIT_LAYER        9
#define TAIL_LAYER       10
#define GLASSES_LAYER    11
#define BELT_LAYER_ALT   12
#define SUIT_STORE_LAYER 13
#define BACK_LAYER       14
#define HAIR_LAYER       15
#define L_EAR_LAYER      16
#define R_EAR_LAYER      17
#define FACEMASK_LAYER   18
#define HEAD_LAYER       19
#define COLLAR_LAYER     20
#define HANDCUFF_LAYER   21
#define LEGCUFF_LAYER    22
#define L_HAND_LAYER     23
#define R_HAND_LAYER     24
#define FIRE_LAYER       25		//If you're on fire
#define TARGETED_LAYER   26		//Layer for the target overlay from weapon targeting system
#define TOTAL_LAYERS     26
//////////////////////////////////

/mob/living/carbon/human
	var/list/overlays_raw[TOTAL_LAYERS] // Our set of "raw" overlays that can be modified, but cannot be directly applied to the mob without preprocessing.
	var/previous_damage_appearance // store what the body last looked like, so we only have to update it if something changed

// Updates overlays from overlays_raw.
/mob/living/carbon/human/update_icons()
	if (QDELING(src))
		return	// No point.

	update_hud()		//TODO: remove the need for this
	cut_overlays()

	if(cloaked)
		icon = 'icons/mob/human.dmi'
		icon_state = "body_cloaked"
		add_overlay(list(overlays_raw[L_HAND_LAYER], overlays_raw[R_HAND_LAYER]))

	else if (icon_update)
		if (icon != stand_icon)
			icon = stand_icon

		var/list/ovr = list()
		// We manually add each element instead of just using Copy() so that lists are appended instead of inserted.
		for (var/item in overlays_raw)
			if (item)
				ovr += item

		if(species.has_floating_eyes)
			ovr += species.get_eyes(src)

		add_overlay(ovr)

	if (lying_prev != lying || size_multiplier != 1)
		if(lying && !species.prone_icon) //Only rotate them if we're not drawing a specific icon for being prone.
			var/matrix/M = matrix()
			M.Turn(90)
			M.Scale(size_multiplier)
			M.Translate(1,-6)
			src.transform = M
		else
			var/matrix/M = matrix()
			M.Scale(size_multiplier)
			M.Translate(0, 16*(size_multiplier-1))
			src.transform = M

	compile_overlays()
	lying_prev = lying

//DAMAGE OVERLAYS
//constructs damage icon for each organ from mask * damage field and saves it in our overlays_raw list (as a list of icons).
/mob/living/carbon/human/UpdateDamageIcon(var/update_icons=1)
	// first check whether something actually changed about damage appearance
	var/damage_appearance = ""

	for(var/obj/item/organ/external/O in organs)
		if(O.is_stump())
			continue
		//if(O.status & ORGAN_DESTROYED) damage_appearance += "d" //what is this?
		//else
		//	damage_appearance += O.damage_state
		damage_appearance += O.damage_state

	if(damage_appearance == previous_damage_appearance)
		// nothing to do here
		return

	previous_damage_appearance = damage_appearance

	// The overlays we're going to add to the mob.
	var/list/ovr

	// blend the individual damage states with our icons
	for(var/obj/item/organ/external/O in organs)
		if(O.is_stump())
			continue

		O.update_icon()
		if(O.damage_state == "00") continue
		var/cache_index = "[O.damage_state]/[O.icon_name]/[species.blood_color]/[species.get_bodytype()]"
		var/list/damage_icon_parts = SSicon_cache.damage_icon_parts
		var/icon/DI = damage_icon_parts[cache_index]
		if(!DI)
			DI = new /icon(species.damage_overlays, O.damage_state)			// the damage icon for whole human
			DI.Blend(new /icon(species.damage_mask, O.icon_name), ICON_MULTIPLY)	// mask with this organ's pixels
			DI.Blend(species.blood_color, ICON_MULTIPLY)
			damage_icon_parts[cache_index] = DI

		LAZYADD(ovr, DI)

	overlays_raw[DAMAGE_LAYER] = ovr

	if(update_icons)
		update_icons()

//BASE MOB SPRITE
/mob/living/carbon/human/proc/update_body(var/update_icons=1)
	if (QDELING(src))
		return

	var/husk_color_mod = rgb(96,88,80)
	var/hulk_color_mod = rgb(48,224,40)

	var/husk = (HUSK in mutations)
	var/fat = (FAT in mutations)
	var/hulk = (HULK in mutations)
	var/skeleton = (SKELETON in mutations)
	var/g = (gender == FEMALE ? "f" : "m")

	pixel_x = species.icon_x_offset
	pixel_y = species.icon_y_offset

	//CACHING: Generate an index key from visible bodyparts.
	//0 = destroyed, 1 = normal, 2 = robotic, 3 = necrotic.

	//Create a new, blank icon for our mob to use.
	if(stand_icon)
		qdel(stand_icon)
	stand_icon = new(species.icon_template ? species.icon_template : 'icons/mob/human.dmi',"blank")

	var/icon_key = "[species.race_key][g][s_tone][r_skin][g_skin][b_skin][lip_style || "nolips"]"
	var/obj/item/organ/eyes/eyes = internal_organs_by_name["eyes"]
	if(eyes)
		icon_key += "[rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3])]"
	else
		icon_key += "#000000"

	for(var/organ_tag in species.has_limbs)
		var/obj/item/organ/external/part = organs_by_name[organ_tag]
		if(!part || part.is_stump())
			icon_key += "0"
		else if(part.status & ORGAN_ROBOT)
			icon_key += "2[part.model ? "-[part.model]": ""]"
		else if(part.status & ORGAN_DEAD)
			icon_key += "3"
		else
			icon_key += "1"
		if(part)
			icon_key += "[part.species.race_key]"
			icon_key += "[part.dna.GetUIState(DNA_UI_GENDER)]"
			icon_key += "[part.dna.GetUIValue(DNA_UI_SKIN_TONE)]"
			if(part.skin_color)
				icon_key += "[part.skin_color]"
			if(part.body_hair && part.hair_color)
				icon_key += "[part.hair_color]"
			else
				icon_key += "#000000"

			for(var/M in part.markings)
				icon_key += "[M][part.markings[M]["color"]]"

	icon_key = "[icon_key][!!husk][!!fat][!!hulk][!!skeleton]"
	var/icon/base_icon = SSicon_cache.human_icon_cache[icon_key]
	if (!base_icon)	// Icon ain't in the cache, so generate it.
		//BEGIN CACHED ICON GENERATION.
		var/obj/item/organ/external/chest = get_organ("chest")
		base_icon = chest.get_icon()

		for(var/obj/item/organ/external/part in organs)
			var/icon/temp = part.get_icon(skeleton)//The color comes from this function
			//That part makes left and right legs drawn topmost and lowermost when human looks WEST or EAST
			//And no change in rendering for other parts (they icon_position is 0, so goes to 'else' part)
			if(part.icon_position&(LEFT|RIGHT))
				var/icon/temp2 = new('icons/mob/human.dmi',"blank")
				temp2.Insert(new/icon(temp,dir=NORTH),dir=NORTH)
				temp2.Insert(new/icon(temp,dir=SOUTH),dir=SOUTH)
				if(!(part.icon_position & LEFT))
					temp2.Insert(new/icon(temp,dir=EAST),dir=EAST)
				if(!(part.icon_position & RIGHT))
					temp2.Insert(new/icon(temp,dir=WEST),dir=WEST)
				base_icon.Blend(temp2, ICON_OVERLAY)
				if(part.icon_position & LEFT)
					temp2.Insert(new/icon(temp,dir=EAST),dir=EAST)
				if(part.icon_position & RIGHT)
					temp2.Insert(new/icon(temp,dir=WEST),dir=WEST)
				base_icon.Blend(temp2, ICON_UNDERLAY)
			else
				base_icon.Blend(temp, ICON_OVERLAY)

		if(!skeleton)
			if(husk)
				base_icon.ColorTone(husk_color_mod)
			else if(hulk)
				var/list/tone = ReadRGB(hulk_color_mod)
				base_icon.MapColors(rgb(tone[1],0,0),rgb(0,tone[2],0),rgb(0,0,tone[3]))

		//Handle husk overlay.
		if(husk && ("overlay_husk" in icon_states(species.icobase)))
			var/icon/mask = new(base_icon)
			var/icon/husk_over = new(species.icobase,"overlay_husk")
			mask.MapColors(0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,0)
			husk_over.Blend(mask, ICON_ADD)
			base_icon.Blend(husk_over, ICON_OVERLAY)

		SSicon_cache.human_icon_cache[icon_key] = base_icon

	//END CACHED ICON GENERATION.
	stand_icon.Blend(base_icon,ICON_OVERLAY)

	//Underwear
	if(underwear && species.appearance_flags & HAS_UNDERWEAR)
		var/uwear = "[underwear]"
		var/icon/undies = SSicon_cache.human_underwear_cache[uwear]
		if (!undies)
			undies = new('icons/mob/human.dmi', underwear)
			SSicon_cache.human_underwear_cache[uwear] = undies
		stand_icon.Blend(undies, ICON_OVERLAY)

	if(undershirt && species.appearance_flags & HAS_UNDERWEAR)
		var/ushirt = "[undershirt]"
		var/icon/shirt = SSicon_cache.human_undershirt_cache[ushirt]
		if (!shirt)
			shirt = new('icons/mob/human.dmi', undershirt)
			SSicon_cache.human_undershirt_cache[ushirt] = shirt
		stand_icon.Blend(shirt, ICON_OVERLAY)

	if(socks && species.appearance_flags & HAS_SOCKS)
		var/sockskey = "[socks]"
		var/icon/socksicon = SSicon_cache.human_socks_cache[sockskey]
		if (!socksicon)
			socksicon = new('icons/mob/human.dmi', socks)
			SSicon_cache.human_socks_cache[sockskey] = socksicon
		stand_icon.Blend(socksicon, ICON_OVERLAY)

	if(update_icons)
		update_icons()

	//tail
	update_tail_showing(0)

// This proc generates & returns an icon representing a human's hair, using a cached icon from SSicon_cache if possible.
// If `hair_is_visible` is FALSE, only facial hair will be drawn.
/mob/living/carbon/human/proc/generate_hair_icon(hair_is_visible = TRUE)
	var/cache_key = "[f_style ? "[f_style][r_facial][g_facial][b_facial]" : "nofacial"]_[(h_style && hair_is_visible) ? "[h_style][r_hair][g_hair][b_hair]" : "nohair"]"

	var/icon/face_standing = SSicon_cache.human_hair_cache[cache_key]
	if (!face_standing)	// Not cached, generate it from scratch.
		face_standing = new /icon('icons/mob/human_face.dmi',"bald_s")
		// Beard.
		if(f_style)
			var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[f_style]
			if(facial_hair_style && facial_hair_style.species_allowed && (src.species.get_bodytype() in facial_hair_style.species_allowed))
				var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
				if(facial_hair_style.do_colouration)
					facial_s.Blend(rgb(r_facial, g_facial, b_facial), ICON_ADD)

				face_standing.Blend(facial_s, ICON_OVERLAY)

		// Hair.
		if(hair_is_visible)
			var/datum/sprite_accessory/hair_style = hair_styles_list[h_style]
			if(hair_style && (src.species.get_bodytype() in hair_style.species_allowed))
				var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
				if(hair_style.do_colouration)
					hair_s.Blend(rgb(r_hair, g_hair, b_hair), ICON_ADD)

				face_standing.Blend(hair_s, ICON_OVERLAY)

		// Add it to the cache.
		SSicon_cache.human_hair_cache[cache_key] = face_standing

	return face_standing

//HAIR OVERLAY
/mob/living/carbon/human/proc/update_hair(var/update_icons=1)
	if (QDELING(src))
		return

	//Reset our hair
	overlays_raw[HAIR_LAYER] = null

	var/obj/item/organ/external/head/head_organ = get_organ("head")
	if(!head_organ || head_organ.is_stump() )
		if(update_icons)   update_icons()
		return

	//masks and helmets can obscure our hair.
	if( (head && (head.flags_inv & BLOCKHAIR)) || (wear_mask && (wear_mask.flags_inv & BLOCKHAIR)))
		if(update_icons)   update_icons()
		return

	var/has_visible_hair = h_style && !(head && (head.flags_inv & BLOCKHEADHAIR))

	var/icon/hair_icon = generate_hair_icon(has_visible_hair)
	
	// Handle light emission.
	if (species.light_range)
		if (has_visible_hair)
			var/datum/sprite_accessory/hair_style = hair_styles_list[h_style]
			if (hair_style)
				var/col = species.get_light_color(h_style) || "#FFFFFF"
				set_light(species.light_range, species.light_power, col, uv = 0, angle = LIGHT_WIDE)
		else
			set_light(0)

	overlays_raw[HAIR_LAYER] = hair_icon

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_mutations(var/update_icons=1)
	if (QDELING(src))
		return
		
	var/fat
	if(FAT in mutations)
		fat = "fat"

	var/image/standing	= image("icon" = 'icons/effects/genetics.dmi')
	var/add_image = 0
	var/g = "m"
	if(gender == FEMALE)	g = "f"
	// DNA2 - Drawing underlays.
	for(var/datum/dna/gene/gene in dna_genes)
		if(!gene.block)
			continue
		if(gene.is_active(src))
			var/underlay=gene.OnDrawUnderlays(src,g,fat)
			if(underlay)
				standing.underlays += underlay
				add_image = 1
	for(var/mut in mutations)
		switch(mut)
			/*
			if(HULK)
				if(fat)
					standing.underlays	+= "hulk_[fat]_s"
				else
					standing.underlays	+= "hulk_[g]_s"
				add_image = 1
			if(COLD_RESISTANCE)
				standing.underlays	+= "fire[fat]_s"
				add_image = 1
			if(TK)
				standing.underlays	+= "telekinesishead[fat]_s"
				add_image = 1
			*/
			if(LASER)
				standing.overlays += "lasereyes_s"
				add_image = 1
	if(add_image)
		overlays_raw[MUTATIONS_LAYER] = standing
	else
		overlays_raw[MUTATIONS_LAYER] = null
	if(update_icons)
		update_icons()

/* --------------------------------------- */
//For legacy support.
/mob/living/carbon/human/regenerate_icons()
	if (QDELING(src))
		return
		
	..()
	if(transforming)		return

	update_mutations(0)
	update_body(0)
	update_hair(0)
	update_inv_w_uniform(0)
	update_inv_wear_id(0)
	update_inv_gloves(0)
	update_inv_glasses(0)
	update_inv_ears(0)
	update_inv_shoes(0)
	update_inv_s_store(0)
	update_inv_wear_mask(0)
	update_inv_head(0)
	update_inv_belt(0)
	update_inv_back(0)
	update_inv_wear_suit(0)
	update_inv_r_hand(0)
	update_inv_l_hand(0)
	update_inv_handcuffed(0)
	update_inv_legcuffed(0)
	update_inv_pockets(0)
	update_fire(0)
	update_surgery(0)
	UpdateDamageIcon()
	update_icons()
	//Hud Stuff
	update_hud()

/* --------------------------------------- */
//vvvvvv UPDATE_INV PROCS vvvvvv

/mob/living/carbon/human/update_inv_w_uniform(var/update_icons=1)
	if (QDELING(src))
		return
		
	overlays_raw[UNIFORM_LAYER] = null
	if(check_draw_underclothing())
		w_uniform.screen_loc = ui_iclothing

		//determine the icon to use
		var/icon/under_icon
		var/under_state = ""

		if(w_uniform.contained_sprite)//Do all the containedsprite stuff in one place
			w_uniform.auto_adapt_species(src)
			if(w_uniform.icon_override)
				under_icon = w_uniform.icon_override
			else
				under_icon = w_uniform.icon

			if (w_uniform.icon_species_tag)
				under_state += "[w_uniform.icon_species_tag]_"
			under_state += w_uniform.item_state + WORN_UNDER

		else if(w_uniform.icon_override)
			under_icon = w_uniform.icon_override
		else if(w_uniform.sprite_sheets && w_uniform.sprite_sheets[species.get_bodytype()])
			under_icon = w_uniform.sprite_sheets[species.get_bodytype()]
		else if(w_uniform.item_icons && w_uniform.item_icons[slot_w_uniform_str])
			under_icon = w_uniform.item_icons[slot_w_uniform_str]
		else
			under_icon = INV_W_UNIFORM_DEF_ICON

		//determine state to use
		if (!under_state)
			if(w_uniform.item_state_slots && w_uniform.item_state_slots[slot_w_uniform_str])
				under_state = w_uniform.item_state_slots[slot_w_uniform_str] + "_s"
			else if(w_uniform.item_state)
				under_state = w_uniform.item_state + "_s"
			else
				under_state = w_uniform.icon_state + "_s"

		var/image/standing = image(icon = under_icon, icon_state = under_state)
		standing.color = w_uniform.color
		var/list/ovr

		//apply blood overlay
		if(w_uniform.blood_DNA)
			var/image/bloodsies	= image(icon = species.blood_mask, icon_state = "uniformblood")
			bloodsies.color		= w_uniform.blood_color
			ovr = list(standing, bloodsies)

		//accessories
		if (istype(w_uniform, /obj/item/clothing/under))//Prevent runtime errors with unusual objects
			var/obj/item/clothing/under/under = w_uniform
			if(under.accessories.len)
				if (!ovr)
					ovr = list(standing)

				for(var/obj/item/clothing/accessory/A in under.accessories)
					ovr += A.get_mob_overlay()

		overlays_raw[UNIFORM_LAYER] = ovr || standing

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_wear_id(var/update_icons=1)
	if (QDELING(src))
		return
		
	overlays_raw[ID_LAYER]	= null
	if(wear_id)

		wear_id.screen_loc = ui_id	//TODO
		if(w_uniform && w_uniform:displays_id)
			if(wear_id.contained_sprite)
				wear_id.auto_adapt_species(src)
				var/icon/IDIcon
				if(wear_id.icon_override)
					IDIcon = wear_id.icon_override
				else
					IDIcon = wear_id.icon

				overlays_raw[ID_LAYER] = image("icon" = IDIcon, "icon_state" = "[wear_id.item_state][WORN_ID]")
			else
				overlays_raw[ID_LAYER] = image("icon" = 'icons/mob/mob.dmi', "icon_state" = "id")

	BITSET(hud_updateflag, ID_HUD)
	BITSET(hud_updateflag, WANTED_HUD)

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_gloves(var/update_icons=1)
	if (QDELING(src))
		return
		
	overlays_raw[GLOVES_LAYER] = null
	if(check_draw_gloves())

		var/t_state = gloves.item_state
		if(!t_state)	t_state = gloves.icon_state

		var/image/standing
		if(gloves.contained_sprite)
			gloves.auto_adapt_species(src)
			var/state = ""
			if (gloves.icon_species_tag)
				state += "[gloves.icon_species_tag]_"
			state += "[gloves.item_state][WORN_GLOVES]"

			if(gloves.icon_override)
				standing = image("icon" = gloves.icon_override, "icon_state" = state)
			else
				standing = image("icon" = gloves.icon, "icon_state" = state)
		else if(gloves.icon_override)
			standing = image("icon" = gloves.icon_override, "icon_state" = "[t_state]")
		else if(gloves.sprite_sheets && gloves.sprite_sheets[species.get_bodytype()])
			standing = image("icon" = gloves.sprite_sheets[species.get_bodytype()], "icon_state" = "[t_state]")
		else
			standing = image("icon" = 'icons/mob/hands.dmi', "icon_state" = "[t_state]")

		standing.color = gloves.color

		var/list/ovr

		if(gloves.blood_DNA)
			var/image/bloodsies = image("icon" = species.blood_mask, "icon_state" = "bloodyhands")
			bloodsies.color = gloves.blood_color
			ovr = list(standing, bloodsies)

		gloves.screen_loc = ui_gloves
		overlays_raw[GLOVES_LAYER] = ovr || standing
	else
		if(blood_DNA)
			var/image/bloodsies	= image("icon" = species.blood_mask, "icon_state" = "bloodyhands")
			bloodsies.color = hand_blood_color
			overlays_raw[GLOVES_LAYER] = bloodsies

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_glasses(var/update_icons=1)
	if (QDELING(src))
		return
		
	overlays_raw[GLASSES_LAYER] = null
	if(check_draw_glasses())
		if(glasses.contained_sprite)
			glasses.auto_adapt_species(src)
			var/state = ""
			if (glasses.icon_species_tag)
				state += "[glasses.icon_species_tag]_"
			state += "[glasses.item_state][WORN_EYES]"

			if(glasses.icon_override)
				overlays_raw[GLASSES_LAYER] = image("icon" = glasses.icon_override, "icon_state" = state)
			else
				overlays_raw[GLASSES_LAYER] = image("icon" = glasses.icon, "icon_state" = state)

		else if(glasses.icon_override)
			overlays_raw[GLASSES_LAYER] = image("icon" = glasses.icon_override, "icon_state" = "[glasses.icon_state]")
		else if(glasses.sprite_sheets && glasses.sprite_sheets[species.get_bodytype()])
			overlays_raw[GLASSES_LAYER] = image("icon" = glasses.sprite_sheets[species.get_bodytype()], "icon_state" = "[glasses.icon_state]")
		else
			overlays_raw[GLASSES_LAYER] = image("icon" = 'icons/mob/eyes.dmi', "icon_state" = "[glasses.icon_state]")

	if(update_icons)   update_icons()

/mob/living/carbon/human/update_inv_ears(var/update_icons=1)
	if (QDELING(src))
		return
		
	overlays_raw[L_EAR_LAYER] = null
	overlays_raw[R_EAR_LAYER] = null

	if (!check_draw_ears())
		if(update_icons)   update_icons()
		return

	else
		if(l_ear)

			var/t_type = l_ear.icon_state

			if(l_ear.contained_sprite)
				l_ear.auto_adapt_species(src)
				t_type = ""
				if (l_ear.icon_species_tag)
					t_type += "[l_ear.icon_species_tag]_"
				t_type += "[l_ear.item_state][WORN_LEAR]"
				if(l_ear.icon_override)
					overlays_raw[L_EAR_LAYER] = image("icon" = l_ear.icon_override, "icon_state" = t_type)
				else
					overlays_raw[L_EAR_LAYER] = image("icon" = l_ear.icon, "icon_state" = t_type)
			else if(l_ear.icon_override)
				t_type = "[t_type]_l"
				overlays_raw[L_EAR_LAYER] = image("icon" = l_ear.icon_override, "icon_state" = "[t_type]")
			else if(l_ear.sprite_sheets && l_ear.sprite_sheets[species.get_bodytype()])
				t_type = "[t_type]_l"
				overlays_raw[L_EAR_LAYER] = image("icon" = l_ear.sprite_sheets[species.get_bodytype()], "icon_state" = "[t_type]")
			else
				overlays_raw[L_EAR_LAYER] = image("icon" = 'icons/mob/ears.dmi', "icon_state" = "[t_type]")

		if(r_ear)
			var/t_type = r_ear.icon_state
			if(r_ear.contained_sprite)
				r_ear.auto_adapt_species(src)
				t_type = ""
				if (r_ear.icon_species_tag)
					t_type += "[r_ear.icon_species_tag]_"
				t_type += "[r_ear.item_state][WORN_REAR]"
				if(r_ear.icon_override)
					overlays_raw[R_EAR_LAYER] = image("icon" = r_ear.icon_override, "icon_state" = t_type)
				else
					overlays_raw[R_EAR_LAYER] = image("icon" = r_ear.icon, "icon_state" = t_type)

			else if(r_ear.icon_override)
				t_type = "[t_type]_r"
				overlays_raw[R_EAR_LAYER] = image("icon" = r_ear.icon_override, "icon_state" = "[t_type]")
			else if(r_ear.sprite_sheets && r_ear.sprite_sheets[species.get_bodytype()])
				t_type = "[t_type]_r"
				overlays_raw[R_EAR_LAYER] = image("icon" = r_ear.sprite_sheets[species.get_bodytype()], "icon_state" = "[t_type]")
			else
				overlays_raw[R_EAR_LAYER] = image("icon" = 'icons/mob/ears.dmi', "icon_state" = "[t_type]")

	if(update_icons)   update_icons()

/mob/living/carbon/human/update_inv_shoes(var/update_icons=1)
	if (QDELING(src))
		return
		
	overlays_raw[SHOES_LAYER] = null
	if(check_draw_shoes())
		var/image/standing
		if(shoes.contained_sprite)
			shoes.auto_adapt_species(src)
			var/state = ""
			if (shoes.icon_species_tag)
				state += "[shoes.icon_species_tag]_"
			state += "[shoes.item_state][WORN_SHOES]"

			if(shoes.icon_override)
				standing = image("icon" = shoes.icon_override, "icon_state" = state)
			else
				standing = image("icon" = shoes.icon, "icon_state" = state)

		else if(shoes.icon_override)
			standing = image("icon" = shoes.icon_override, "icon_state" = "[shoes.icon_state]")
		else if(shoes.sprite_sheets && shoes.sprite_sheets[species.get_bodytype()])
			standing = image("icon" = shoes.sprite_sheets[species.get_bodytype()], "icon_state" = "[shoes.icon_state]")
		else
			standing = image("icon" = 'icons/mob/feet.dmi', "icon_state" = "[shoes.icon_state]")

		standing.color = shoes.color

		var/list/ovr

		if(shoes.blood_DNA)
			var/image/bloodsies = image("icon" = species.blood_mask, "icon_state" = "shoeblood")
			bloodsies.color = shoes.blood_color
			ovr = list(standing, bloodsies)

		overlays_raw[SHOES_LAYER] = ovr || standing
	else
		if(feet_blood_DNA)
			var/image/bloodsies = image("icon" = species.blood_mask, "icon_state" = "shoeblood")
			bloodsies.color = feet_blood_color
			overlays_raw[SHOES_LAYER] = bloodsies

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_s_store(var/update_icons=1)
	if (QDELING(src))
		return
		
	if(s_store)
		//s_store.auto_adapt_species(src)
		var/t_state = s_store.item_state
		if(!t_state)	t_state = s_store.icon_state
		overlays_raw[SUIT_STORE_LAYER] = image("icon" = 'icons/mob/belt_mirror.dmi', "icon_state" = "[t_state]")
		s_store.screen_loc = ui_sstore1		//TODO
	else
		overlays_raw[SUIT_STORE_LAYER] = null
	if(update_icons)   update_icons()


/mob/living/carbon/human/update_inv_head(var/update_icons=1)
	if (QDELING(src))
		return
		
	overlays_raw[HEAD_LAYER] = null
	if(head)
		head.screen_loc = ui_head		//TODO
		var/image/standing = null
		//Determine the icon to use
		var/t_icon = INV_HEAD_DEF_ICON
		if(head.contained_sprite)
			head.auto_adapt_species(src)
			var/state = ""
			if (head.icon_species_tag)
				state += "[head.icon_species_tag]_"
			state += "[head.item_state][WORN_HEAD]"


			if(head.icon_override)
				standing = image("icon" = head.icon_override, "icon_state" = state)
			else
				standing = image("icon" = head.icon, "icon_state" = state)
		else if(head.icon_override)
			t_icon = head.icon_override
		else if(head.sprite_sheets && head.sprite_sheets[species.get_bodytype()])
			t_icon = head.sprite_sheets[species.get_bodytype()]

		else if(head.item_icons && (slot_head_str in head.item_icons))
			t_icon = head.item_icons[slot_head_str]
		else
			t_icon = INV_HEAD_DEF_ICON

		if (!standing)
			//Determine the state to use
			var/t_state = head.icon_state

			//Create the image
			standing = image(icon = t_icon, icon_state = t_state)

		standing.color = head.color

		var/list/ovr

		if(head.blood_DNA)
			var/image/bloodsies = image("icon" = species.blood_mask, "icon_state" = "helmetblood")
			bloodsies.color = head.blood_color
			ovr = list(standing, bloodsies)

		if(istype(head,/obj/item/clothing/head))
			var/obj/item/clothing/head/hat = head
			var/cache_key = "[hat.light_overlay]_[species.get_bodytype()]"
			if(hat.on && SSicon_cache.light_overlay_cache["[cache_key]"])
				if (!ovr)
					ovr = list(standing)
				ovr += SSicon_cache.light_overlay_cache["[cache_key]"]

		overlays_raw[HEAD_LAYER] = ovr || standing

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_belt(var/update_icons=1)
	if (QDELING(src))
		return
		
	overlays_raw[BELT_LAYER] = null
	overlays_raw[BELT_LAYER_ALT] = null

	if(belt)
		belt.screen_loc = ui_belt	//TODO
		var/t_state = belt.item_state
		var/t_icon = belt.icon
		if(!t_state)	t_state = belt.icon_state
		var/image/standing	= image("icon_state" = "[t_state]")

		if(belt.contained_sprite)
			belt.auto_adapt_species(src)
			t_state = ""
			if (belt.icon_species_tag)
				t_state += "[belt.icon_species_tag]_"
			t_state += "[belt.item_state][WORN_BELT]"

			if(belt.icon_override)
				t_icon = belt.icon_override

		else if(belt.icon_override)
			t_icon = belt.icon_override
		else if(belt.sprite_sheets && belt.sprite_sheets[species.get_bodytype()])
			t_icon = belt.sprite_sheets[species.get_bodytype()]
		else
			t_icon = 'icons/mob/belt.dmi'

		standing = image("icon" = t_icon, "icon_state" = t_state)
		var/list/ovr

		if(belt.contents.len && istype(belt, /obj/item/weapon/storage/belt))
			ovr = list(standing)
			for(var/obj/item/i in belt.contents)
				var/c_state
				var/c_icon
				if(i.contained_sprite)
					c_state = ""
					if (i.icon_species_tag)
						c_state += "[i.icon_species_tag]_"
					c_state += "[i.item_state][WORN_BELT]"

					c_icon = belt.icon
					if(belt.icon_override)
						c_icon = belt.icon_override

				else
					c_icon = 'icons/mob/belt.dmi'
					c_state = i.item_state
					if(!c_state) c_state = i.icon_state
				ovr += image("icon" = c_icon, "icon_state" = c_state)

		var/beltlayer = BELT_LAYER
		if(istype(belt, /obj/item/weapon/storage/belt))
			var/obj/item/weapon/storage/belt/ubelt = belt
			if(ubelt.show_above_suit)
				beltlayer = BELT_LAYER_ALT

		overlays_raw[beltlayer] = ovr || standing

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_wear_suit(var/update_icons=1)
	if (QDELING(src))
		return
		
	if (istype(wear_suit, /obj/item))
		wear_suit.screen_loc = ui_oclothing

		var/image/standing

		if(wear_suit.contained_sprite)
			wear_suit.auto_adapt_species(src)
			var/state = ""
			if (wear_suit.icon_species_tag)
				state += "[wear_suit.icon_species_tag]_"
			state += "[wear_suit.item_state][WORN_SUIT]"

			if(wear_suit.icon_override)
				standing = image("icon" = wear_suit.icon_override, "icon_state" = state)
			else
				standing = image("icon" = wear_suit.icon, "icon_state" = state)

		else if(wear_suit.icon_override)
			standing = image("icon" = wear_suit.icon_override, "icon_state" = "[wear_suit.icon_state]")
		else if(wear_suit.sprite_sheets && wear_suit.sprite_sheets[species.get_bodytype()])
			standing = image("icon" = wear_suit.sprite_sheets[species.get_bodytype()], "icon_state" = "[wear_suit.icon_state]")
		else
			standing = image("icon" = 'icons/mob/suit.dmi', "icon_state" = "[wear_suit.icon_state]")

		standing.color = wear_suit.color
		var/list/ovr

		if(wear_suit.blood_DNA)
			var/obj/item/clothing/suit/S = wear_suit
			var/image/bloodsies = image("icon" = species.blood_mask, "icon_state" = "[S.blood_overlay_type]blood")
			bloodsies.color = wear_suit.blood_color
			ovr = list(standing, bloodsies)

		// Accessories - copied from uniform, BOILERPLATE because fuck this system.
		var/obj/item/clothing/suit/suit = wear_suit
		if(istype(suit) && suit.accessories.len)
			if (!ovr)
				ovr = list(standing)
			for(var/obj/item/clothing/accessory/A in suit.accessories)
				ovr += A.get_mob_overlay()

		overlays_raw[SUIT_LAYER] = ovr || standing
		update_tail_showing(0)

	else
		overlays_raw[SUIT_LAYER] = null
		update_tail_showing(0)
		update_inv_shoes(0)

	update_collar(0)

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_pockets(var/update_icons=1)
	if (QDELING(src))
		return
		
	if(l_store)			l_store.screen_loc = ui_storage1	//TODO
	if(r_store)			r_store.screen_loc = ui_storage2	//TODO
	if(update_icons)	update_icons()


/mob/living/carbon/human/update_inv_wear_mask(var/update_icons=1)
	if (QDELING(src))
		return
		
	overlays_raw[FACEMASK_LAYER] = null
	if(check_draw_mask())
		wear_mask.screen_loc = ui_mask	//TODO
		var/image/standing

		if(wear_mask.contained_sprite)
			wear_mask.auto_adapt_species(src)
			var/state = ""
			if (wear_mask.icon_species_tag)
				state += "[wear_mask.icon_species_tag]_"
			state += "[wear_mask.item_state][WORN_MASK]"

			if(wear_mask.icon_override)
				standing = image("icon" = wear_mask.icon_override, "icon_state" = state)
			else
				standing = image("icon" = wear_mask.icon, "icon_state" = state)
		else if(wear_mask.icon_override)
			standing = image("icon" = wear_mask.icon_override, "icon_state" = "[wear_mask.icon_state]")
		else if(wear_mask.sprite_sheets && wear_mask.sprite_sheets[species.get_bodytype()])
			standing = image("icon" = wear_mask.sprite_sheets[species.get_bodytype()], "icon_state" = "[wear_mask.icon_state]")
		else
			standing = image("icon" = 'icons/mob/mask.dmi', "icon_state" = "[wear_mask.icon_state]")

		standing.color = wear_mask.color
		var/list/ovr

		if( !istype(wear_mask, /obj/item/clothing/mask/smokable/cigarette) && wear_mask.blood_DNA )
			var/image/bloodsies = image("icon" = species.blood_mask, "icon_state" = "maskblood")
			bloodsies.color = wear_mask.blood_color
			ovr = list(standing, bloodsies)

		overlays_raw[FACEMASK_LAYER] = ovr || standing

	if(update_icons)
		update_icons()


/mob/living/carbon/human/update_inv_back(var/update_icons=1)
	if (QDELING(src))
		return
		

	overlays_raw[BACK_LAYER] = null
	if(back)

		back.screen_loc = ui_back	//TODO

		//determine the icon to use
		var/icon/overlay_icon
		var/overlay_state = ""

		if(back.contained_sprite)
			back.auto_adapt_species(src)
			if (back.icon_species_tag)
				overlay_state += "[back.icon_species_tag]_"
			overlay_state += "[back.item_state][WORN_BACK]"

			if(back.icon_override)
				overlay_icon = back.icon_override
			else
				overlay_icon = back.icon
		else if(back.icon_override)
			overlay_icon = back.icon_override
		else if(istype(back, /obj/item/weapon/rig))
			//If this is a rig and a mob_icon is set, it will take species into account in the rig update_icon() proc.
			var/obj/item/weapon/rig/rig = back
			overlay_icon = rig.mob_icon
		else if(back.sprite_sheets && back.sprite_sheets[species.get_bodytype()])
			overlay_icon = back.sprite_sheets[species.get_bodytype()]
		else if(back.item_icons && (slot_back_str in back.item_icons))
			overlay_icon = back.item_icons[slot_back_str]
		else
			overlay_icon = INV_BACK_DEF_ICON

		//determine state to use
		if (!overlay_state)
			if(back.item_state_slots && back.item_state_slots[slot_back_str])
				overlay_state = back.item_state_slots[slot_back_str]
			else if(back.item_state)
				overlay_state = back.item_state
			else if(back.contained_sprite)
				overlay_icon = image("icon" = back.icon, "icon_state" = "[back.icon_state]_w")
			else
				overlay_state = back.icon_state

		//apply color
		var/image/standing = image(icon = overlay_icon, icon_state = overlay_state)
		standing.color = back.color

		//create the image
		overlays_raw[BACK_LAYER] = image(icon = overlay_icon, icon_state = overlay_state)

	if(update_icons)
		update_icons()


/mob/living/carbon/human/update_hud()	//TODO: do away with this if possible
	if(client)
		client.screen |= contents
		if(hud_used)
			hud_used.hidden_inventory_update() 	//Updates the screenloc of the items on the 'other' inventory bar


/mob/living/carbon/human/update_inv_handcuffed(var/update_icons=1)
	if (QDELING(src))
		return
		
	if(handcuffed)
		drop_r_hand()
		drop_l_hand()
		stop_pulling()	//TODO: should be handled elsewhere

		var/image/standing
		if(handcuffed.icon_override)
			standing = image("icon" = handcuffed.icon_override, "icon_state" = "handcuff1")
		else if(handcuffed.sprite_sheets && handcuffed.sprite_sheets[species.get_bodytype()])
			standing = image("icon" = handcuffed.sprite_sheets[species.get_bodytype()], "icon_state" = "handcuff1")
		else
			standing = image("icon" = 'icons/mob/mob.dmi', "icon_state" = "handcuff1")
		overlays_raw[HANDCUFF_LAYER] = standing

	else
		overlays_raw[HANDCUFF_LAYER] = null

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_legcuffed(var/update_icons=1)
	if (QDELING(src))
		return
		
	if(legcuffed)

		var/image/standing
		if(legcuffed.icon_override)
			standing = image("icon" = legcuffed.icon_override, "icon_state" = "legcuff1")
		else if(legcuffed.sprite_sheets && legcuffed.sprite_sheets[species.get_bodytype()])
			standing = image("icon" = legcuffed.sprite_sheets[species.get_bodytype()], "icon_state" = "legcuff1")
		else
			standing = image("icon" = 'icons/mob/mob.dmi', "icon_state" = "legcuff1")
		overlays_raw[LEGCUFF_LAYER] = standing

		if(src.m_intent != "walk")
			src.m_intent = "walk"
			if(src.hud_used && src.hud_used.move_intent)
				src.hud_used.move_intent.icon_state = "walking"

	else
		overlays_raw[LEGCUFF_LAYER] = null

	if(update_icons)
		update_icons()


/mob/living/carbon/human/update_inv_r_hand(var/update_icons=1)
	if (QDELING(src))
		return
		
	overlays_raw[R_HAND_LAYER] = null
	if(r_hand)
		r_hand.screen_loc = ui_rhand	//TODO

		//determine icon state to use
		var/t_state
		if(r_hand.contained_sprite)
			r_hand.auto_adapt_species(src)
			if (r_hand.icon_species_tag && r_hand.icon_species_in_hand)
				t_state += "[r_hand.icon_species_tag]_"
			t_state += "[r_hand.item_state][WORN_RHAND]"

			if(r_hand.icon_override)
				overlays_raw[R_HAND_LAYER] = image(icon = r_hand.icon_override, icon_state = t_state)
			else
				overlays_raw[R_HAND_LAYER] = image(icon = r_hand.icon, icon_state = t_state)

		else
			if(r_hand.item_state_slots && r_hand.item_state_slots[slot_r_hand_str])
				t_state = r_hand.item_state_slots[slot_r_hand_str]
			else if(r_hand.item_state)
				t_state = r_hand.item_state
			else
				t_state = r_hand.icon_state

			//determine icon to use
			var/icon/t_icon
			if(r_hand.item_icons && (slot_r_hand_str in r_hand.item_icons))
				t_icon = r_hand.item_icons[slot_r_hand_str]
			else if(r_hand.icon_override)
				t_state += "_r"
				t_icon = r_hand.icon_override
			else
				t_icon = INV_R_HAND_DEF_ICON

			overlays_raw[R_HAND_LAYER] = image(icon = t_icon, icon_state = t_state)


	if(update_icons) 
		update_icons()


/mob/living/carbon/human/update_inv_l_hand(var/update_icons=1)
	if (QDELING(src))
		return
		
	overlays_raw[L_HAND_LAYER] = null
	if(l_hand)
		l_hand.screen_loc = ui_lhand	//TODO

		//determine icon state to use
		var/t_state
		if(l_hand.contained_sprite)
			l_hand.auto_adapt_species(src)
			if (l_hand.icon_species_tag && l_hand.icon_species_in_hand)
				t_state += "[l_hand.icon_species_tag]_"
			t_state += "[l_hand.item_state][WORN_LHAND]"

			if(l_hand.icon_override)
				overlays_raw[L_HAND_LAYER] = image(icon = l_hand.icon_override, icon_state = t_state)
			else
				overlays_raw[L_HAND_LAYER] = image(icon = l_hand.icon, icon_state = t_state)

		else
			if(l_hand.item_state_slots && l_hand.item_state_slots[slot_l_hand_str])
				t_state = l_hand.item_state_slots[slot_l_hand_str]
			else if(l_hand.item_state)
				t_state = l_hand.item_state
			else
				t_state = l_hand.icon_state

			//determine icon to use
			var/icon/t_icon
			if(l_hand.item_icons && (slot_l_hand_str in l_hand.item_icons))
				t_icon = l_hand.item_icons[slot_l_hand_str]
			else if(l_hand.icon_override)
				t_state += "_l"
				t_icon = l_hand.icon_override
			else
				t_icon = INV_L_HAND_DEF_ICON

			overlays_raw[L_HAND_LAYER] = image(icon = t_icon, icon_state = t_state)


	if(update_icons) update_icons()

/mob/living/carbon/human/proc/update_tail_showing(var/update_icons=1)
	if (QDELING(src))
		return
		
	overlays_raw[TAIL_LAYER] = null

	if(species.tail && !(wear_suit && wear_suit.flags_inv & HIDETAIL))
		var/icon/tail_s = get_tail_icon()
		overlays_raw[TAIL_LAYER] = image(tail_s, icon_state = "[species.tail]_s")
		animate_tail_reset(0)

	if(update_icons)
		update_icons()

/mob/living/carbon/human/proc/get_tail_icon()
	if (QDELING(src))
		return
		
	var/icon_key = "[species.race_key][r_skin][g_skin][b_skin][r_hair][g_hair][b_hair]"
	var/icon/tail_icon = SSicon_cache.tail_icon_cache[icon_key]
	if(!tail_icon)
		//generate a new one
		tail_icon = new/icon(icon = (species.tail_animation? species.tail_animation : 'icons/effects/species.dmi'))
		tail_icon.Blend(rgb(r_skin, g_skin, b_skin), ICON_ADD)
		// The following will not work with animated tails.
		if(species.tail_hair)
			var/icon/hair_icon = icon('icons/effects/species.dmi', "[species.tail]_[species.tail_hair]")
			hair_icon.Blend(rgb(r_hair, g_hair, b_hair), ICON_ADD)
			tail_icon.Blend(hair_icon, ICON_OVERLAY)
		SSicon_cache.tail_icon_cache[icon_key] = tail_icon

	return tail_icon


/mob/living/carbon/human/proc/set_tail_state(var/t_state)
	if (!species.tail)
		return

	var/image/tail_overlay = overlays_raw[TAIL_LAYER]

	if(tail_overlay && species.tail_animation)
		if (tail_overlay.icon_state != t_state)
			tail_overlay.icon_state = t_state
			update_icons()
		return tail_overlay
	return null

//Not really once, since BYOND can't do that.
//Update this if the ability to flick() images or make looping animation start at the first frame is ever added.
/mob/living/carbon/human/proc/animate_tail_once()
	var/t_state = "[species.tail]_once"

	var/image/tail_overlay = overlays_raw[TAIL_LAYER]
	if(tail_overlay && tail_overlay.icon_state == t_state)
		return //let the existing animation finish

	tail_overlay = set_tail_state(t_state)
	if(tail_overlay)
		addtimer(CALLBACK(src, .proc/end_animate_tail_once, tail_overlay), 20)

/mob/living/carbon/human/proc/end_animate_tail_once(image/tail_overlay)
	//check that the animation hasn't changed in the meantime
	if(overlays_raw[TAIL_LAYER] == tail_overlay && tail_overlay.icon_state == "[species.tail]_once")
		animate_tail_stop()

/mob/living/carbon/human/proc/animate_tail_start()
	set_tail_state("[species.tail]_slow[rand(0,9)]")


/mob/living/carbon/human/proc/animate_tail_fast()
	set_tail_state("[species.tail]_loop[rand(0,9)]")

	//if(update_icons)

/mob/living/carbon/human/proc/animate_tail_reset()
	if(stat != DEAD && !lying)
		set_tail_state("[species.tail]_idle[rand(0,9)]")
	else
		set_tail_state("[species.tail]_static")



/mob/living/carbon/human/proc/animate_tail_stop(var/update_icons=1)
	set_tail_state("[species.tail]_static")



//Adds a collar overlay above the helmet layer if the suit has one
//	Suit needs an identically named sprite in icons/mob/collar.dmi
/mob/living/carbon/human/proc/update_collar(var/update_icons=1)
	if (QDELING(src))
		return

	var/icon/C = new('icons/mob/collar.dmi')
	var/image/standing = null

	if(wear_suit)
		if(wear_suit.icon_state in C.IconStates())
			standing = image("icon" = C, "icon_state" = "[wear_suit.icon_state]")

	overlays_raw[COLLAR_LAYER] = standing

	if(update_icons)   update_icons()


/mob/living/carbon/human/update_fire(var/update_icons=1)
	if (QDELING(src))
		return

	overlays_raw[FIRE_LAYER] = null
	if(on_fire)
		overlays_raw[FIRE_LAYER] = image("icon"='icons/mob/OnFire.dmi', "icon_state"="Standing", "layer"=FIRE_LAYER)

	if(update_icons)
		update_icons()

/mob/living/carbon/human/proc/update_surgery(var/update_icons=1)
	overlays_raw[SURGERY_LAYER] = null
	var/list/ovr
	for(var/obj/item/organ/external/E in organs)
		if(E.open)
			var/image/I = image("icon"='icons/mob/surgery.dmi', "icon_state"="[E.name][round(E.open)]", "layer"=-SURGERY_LAYER)
			LAZYADD(ovr, I)
	overlays_raw[SURGERY_LAYER] = ovr

	if(update_icons)
		update_icons()

//Drawcheck functions
//These functions check if an item should be drawn, or if its covered up by something else
/mob/living/carbon/human/proc/check_draw_gloves()
	if (!gloves)
		return 0
	else if (gloves.flags_inv & ALWAYSDRAW)
		return 1
	else if (wear_suit && (wear_suit.flags_inv & HIDEGLOVES))
		return 0
	else
		return 1

/mob/living/carbon/human/proc/check_draw_ears()
	if (!l_ear && !r_ear)
		return 0
	else if ((l_ear && (l_ear.flags_inv & ALWAYSDRAW)) || (r_ear && (r_ear.flags_inv & ALWAYSDRAW)))
		return 1
	else if( (head && (head.flags_inv & (HIDEEARS))) || (wear_mask && (wear_mask.flags_inv & (HIDEEARS))))
		return 0
	else
		return 1

/mob/living/carbon/human/proc/check_draw_glasses()
	if (!glasses)
		return 0
	else if (glasses.flags_inv & ALWAYSDRAW)
		return 1
	else if( (head && (head.flags_inv & (HIDEEYES))) || (wear_mask && (wear_mask.flags_inv & (HIDEEYES))))
		return 0
	else
		return 1


/mob/living/carbon/human/proc/check_draw_mask()
	if (!wear_mask)
		return 0
	else if (wear_mask.flags_inv & ALWAYSDRAW)
		return 1
	else if( head && (head.flags_inv & HIDEEYES))
		return 0
	else
		return 1

/mob/living/carbon/human/proc/check_draw_shoes()
	if (!shoes)
		return 0
	else if (shoes.flags_inv & ALWAYSDRAW)
		return 1
	else if(wear_suit && (wear_suit.flags_inv & HIDESHOES))
		return 0
	else
		return 1


/mob/living/carbon/human/proc/check_draw_underclothing()
	if (!w_uniform)
		return 0
	else if (w_uniform.flags_inv & ALWAYSDRAW)
		return 1
	else if(wear_suit && (wear_suit.flags_inv & HIDEJUMPSUIT))
		return 0
	else
		return 1




//Human Overlays Indexes/////////
#undef MUTATIONS_LAYER
#undef DAMAGE_LAYER
#undef SURGERY_LAYER
#undef UNIFORM_LAYER
#undef ID_LAYER
#undef SHOES_LAYER
#undef GLOVES_LAYER
#undef EARS_LAYER
#undef SUIT_LAYER
#undef TAIL_LAYER
#undef GLASSES_LAYER
#undef FACEMASK_LAYER
#undef BELT_LAYER
#undef SUIT_STORE_LAYER
#undef BACK_LAYER
#undef HAIR_LAYER
#undef HEAD_LAYER
#undef COLLAR_LAYER
#undef HANDCUFF_LAYER
#undef LEGCUFF_LAYER
#undef L_HAND_LAYER
#undef R_HAND_LAYER
#undef TARGETED_LAYER
#undef FIRE_LAYER
#undef TOTAL_LAYERS

