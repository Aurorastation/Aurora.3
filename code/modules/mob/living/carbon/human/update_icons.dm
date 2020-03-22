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

>	Whenever we do something that should cause an overlay to update (which doesn't use standard procs)
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
#define UNDERWEAR_LAYER   4
#define SHOES_LAYER_ALT   5
#define UNIFORM_LAYER     6
#define ID_LAYER          7
#define SHOES_LAYER       8
#define GLOVES_LAYER      9
#define BELT_LAYER       10
#define TAIL_SOUTH_LAYER 11
#define SUIT_LAYER       12
#define ID_LAYER_ALT     13
#define TAIL_NORTH_LAYER 14
#define GLASSES_LAYER    15
#define BELT_LAYER_ALT   16
#define SUIT_STORE_LAYER 17
#define BACK_LAYER       18
#define HAIR_LAYER       19
#define EARS_LAYER       20
#define FACEMASK_LAYER   21
#define HEAD_LAYER       22
#define COLLAR_LAYER     23
#define HANDCUFF_LAYER   24
#define LEGCUFF_LAYER    25
#define L_HAND_LAYER     26
#define R_HAND_LAYER     27
#define FIRE_LAYER       28		//If you're on fire
#define TOTAL_LAYERS     28
//////////////////////////////////

#define UNDERSCORE_OR_NULL(target) "[target ? "[target]_" : ""]"
#define GET_BODY_TYPE (cached_bodytype || (cached_bodytype = species.get_bodytype()))
#define GET_TAIL_LAYER (dir == NORTH ? TAIL_NORTH_LAYER : TAIL_SOUTH_LAYER)

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
			animate(src, transform = M, time = ANIM_LYING_TIME)
		else
			var/matrix/M = matrix()
			M.Scale(size_multiplier)
			M.Translate(0, 16*(size_multiplier-1))
			animate(src, transform = M, time = ANIM_LYING_TIME)

	compile_overlays()
	lying_prev = lying

//DAMAGE OVERLAYS
//constructs damage icon for each organ from mask * damage field and saves it in our overlays_raw list (as a list of icons).
/mob/living/carbon/human/UpdateDamageIcon(var/update_icons=1)
	// first check whether something actually changed about damage appearance
	var/damage_appearance = ""

	for(var/obj/item/organ/external/O in organs)
		if(isnull(O) || O.is_stump())
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
		if(isnull(O) || O.is_stump())
			continue

		O.update_icon()
		if(O.damage_state == "00") continue
		var/cache_index = "[O.damage_state]/[O.icon_name]/[species.blood_color]/[GET_BODY_TYPE]"
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

	var/icon_key = "[species.race_key][g][s_tone][r_skin][g_skin][b_skin][lip_style || "nolips"][!!husk][!!fat][!!hulk][!!skeleton]"
	var/obj/item/organ/internal/eyes/eyes = get_eyes()
	if(eyes)
		icon_key += "[rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3])]"
	else
		icon_key += "#000000"

	for(var/organ_tag in species.has_limbs)
		var/obj/item/organ/external/part = organs_by_name[organ_tag]
		if (!part)
			continue

		icon_key += SSicon_cache.get_organ_shortcode(part)

	var/icon/base_icon = SSicon_cache.human_icon_cache[icon_key]
	if (!base_icon)	// Icon ain't in the cache, so generate it.
		//BEGIN CACHED ICON GENERATION.
		var/obj/item/organ/external/chest = get_organ(BP_CHEST)
		base_icon = chest.get_icon()

		for(var/obj/item/organ/external/part in organs)
			if(isnull(part) || part.is_stump())
				continue
			var/icon/temp = part.get_icon(skeleton)//The color comes from this function
			//That part makes left and right legs drawn topmost and lowermost when human looks WEST or EAST
			//And no change in rendering for other parts (they icon_position is 0, so goes to 'else' part)
			if(part.icon_position&(LEFT|RIGHT))
				var/icon/temp2 = new('icons/mob/human.dmi',"blank")
				temp2.Insert(new /icon(temp ,dir = NORTH), dir = NORTH)
				temp2.Insert(new /icon(temp, dir = SOUTH), dir = SOUTH)
				if(!(part.icon_position & LEFT))
					temp2.Insert(new /icon(temp, dir = EAST), dir = EAST)
				if(!(part.icon_position & RIGHT))
					temp2.Insert(new /icon(temp, dir = WEST), dir = WEST)
				base_icon.Blend(temp2, ICON_OVERLAY)
				if(part.icon_position & LEFT)
					temp2.Insert(new /icon(temp, dir = EAST), dir = EAST)
				if(part.icon_position & RIGHT)
					temp2.Insert(new /icon(temp, dir = WEST), dir = WEST)
				base_icon.Blend(temp2, ICON_UNDERLAY)
			else
				base_icon.Blend(temp, ICON_OVERLAY)

		if(!(species.flags & NO_SCAN))
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

	//tail
	update_tail_showing(0)

	if(update_icons)
		update_icons()

/mob/living/carbon/human/proc/update_underwear(update_icons = TRUE)
	overlays_raw[UNDERWEAR_LAYER] = list()

	if(species.appearance_flags & HAS_UNDERWEAR)
		for(var/category in all_underwear)
			if(hide_underwear[category])
				continue
			if(category == "Underwear, top" && hide_underwear["Undershirt"] == FALSE && !istype(all_underwear["Undershirt"], /datum/category_item/underwear/undershirt/none))
				continue //This piece of "code" is here to prevent tops from showing up over undershirts.
			var/datum/category_item/underwear/UWI = all_underwear[category]
			overlays_raw[UNDERWEAR_LAYER] += UWI.generate_image(all_underwear_metadata[category])

	if(update_icons)
		update_icons()

// This proc generates & returns an icon representing a human's hair, using a cached icon from SSicon_cache if possible.
// If `hair_is_visible` is FALSE, only facial hair will be drawn.
/mob/living/carbon/human/proc/generate_hair_icon(hair_is_visible = TRUE)
	var/cache_key = "[f_style ? "[f_style][r_facial][g_facial][b_facial]" : "nofacial"]_[(h_style && hair_is_visible) ? "[h_style][r_hair][g_hair][b_hair]" : "nohair"]"

	var/icon/face_standing = SSicon_cache.human_hair_cache[cache_key]
	if (!face_standing)	// Not cached, generate it from scratch.
		face_standing = new /icon('icons/mob/human_face/hair.dmi',"bald")
		// Beard.
		if(f_style)
			var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[f_style]
			if(facial_hair_style && facial_hair_style.species_allowed && (GET_BODY_TYPE in facial_hair_style.species_allowed))
				var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = facial_hair_style.icon_state)
				if(facial_hair_style.do_colouration)
					facial_s.Blend(rgb(r_facial, g_facial, b_facial), facial_hair_style.icon_blend_mode)

				face_standing.Blend(facial_s, ICON_OVERLAY)

		// Hair.
		if(hair_is_visible)
			var/datum/sprite_accessory/hair_style = hair_styles_list[h_style]
			if(hair_style && (GET_BODY_TYPE in hair_style.species_allowed))
				var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = hair_style.icon_state)
				if(hair_style.do_colouration)
					hair_s.Blend(rgb(r_hair, g_hair, b_hair), hair_style.icon_blend_mode)

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

	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD)
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
				var/col = species.get_light_color(src) || "#FFFFFF"
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
			if(LASER_EYES)
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

	if(transforming)
		return

	update_mutations(FALSE)
	update_body(FALSE)
	update_hair(FALSE)
	update_inv_w_uniform(FALSE)
	update_inv_wear_id(FALSE)
	update_inv_gloves(FALSE)
	update_inv_glasses(FALSE)
	update_inv_ears(FALSE)
	update_inv_shoes(FALSE)
	update_inv_s_store(FALSE)
	update_inv_wear_mask(FALSE)
	update_inv_head(FALSE)
	update_inv_belt(FALSE)
	update_inv_back(FALSE)
	update_inv_wear_suit(FALSE)
	update_inv_r_hand(FALSE)
	update_inv_l_hand(FALSE)
	update_inv_handcuffed(FALSE)
	update_inv_legcuffed(FALSE)
	update_inv_pockets(FALSE)
	update_fire(FALSE)
	update_surgery(FALSE)
	update_underwear(FALSE)
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
		else if(w_uniform.sprite_sheets && w_uniform.sprite_sheets[GET_BODY_TYPE])
			under_icon = w_uniform.sprite_sheets[GET_BODY_TYPE]
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
			if(LAZYLEN(under.accessories))
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

	overlays_raw[ID_LAYER] = null
	overlays_raw[ID_LAYER_ALT] = null
	if(wear_id)
		var/image/result_layer
		wear_id.screen_loc = ui_id	//TODO
		if(w_uniform)
			if(!w_uniform:displays_id)
				return
		if(wear_id.contained_sprite)
			wear_id.auto_adapt_species(src)
			if(!(wear_id.overlay_state)) //legacy check
				wear_id.overlay_state = wear_id.item_state
			result_layer = image(wear_id.icon_override || wear_id.icon, "[wear_id.overlay_state][WORN_ID]")
		else
			result_layer = image("icon" = 'icons/mob/card.dmi', "icon_state" = "[wear_id.overlay_state]")

		//Layering under/over suit
		var/id_layer = ID_LAYER
		if(istype(wear_id, /obj/item/storage/wallet))
			var/obj/item/storage/wallet/wallet = wear_id
			if(wallet.wear_over_suit == 1)
				id_layer = ID_LAYER_ALT
		else if(istype(wear_id, /obj/item/card/id))
			var/obj/item/card/id/id_card = wear_id
			if(id_card.wear_over_suit == 1)
				id_layer = ID_LAYER_ALT
		else if(istype(wear_id, /obj/item/device/pda))
			var/obj/item/device/pda/pda_device = wear_id
			if(pda_device.wear_over_suit == 1)
				id_layer = ID_LAYER_ALT

		if (wear_id.color)
			result_layer.color = wear_id.color

		if(istype(wear_id, /obj/item/storage/wallet/lanyard)) //lanyard checking; tacky as bejesus, but...
			var/obj/item/storage/wallet/lanyard/lanyard = wear_id
			var/image/plastic_film = image("icon" = 'icons/mob/lanyard_overlays.dmi', "icon_state" = "plasticfilm")
			var/image/lanyard_card
			if(lanyard.front_id)
				lanyard_card = image("icon" = 'icons/mob/lanyard_overlays.dmi', "icon_state" = "lanyard-[lanyard.front_id_overlay_state]")
				result_layer = list(result_layer, lanyard_card, plastic_film)
			else
				result_layer =  list(result_layer, plastic_film)
		overlays_raw[id_layer] = result_layer

	BITSET(hud_updateflag, ID_HUD)
	BITSET(hud_updateflag, WANTED_HUD)

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_gloves(var/update_icons=1)
	if (QDELING(src))
		return


	if(check_draw_gloves())
		var/t_state = gloves.item_state || gloves.icon_state

		var/image/result_layer
		if(gloves.contained_sprite)
			gloves.auto_adapt_species(src)
			var/state = "[UNDERSCORE_OR_NULL(gloves.icon_species_tag)][gloves.item_state][WORN_GLOVES]"

			result_layer = image(gloves.icon_override || gloves.icon, state)

		else if(gloves.icon_override)
			result_layer = image(gloves.icon_override, t_state)
		else if(gloves.sprite_sheets && gloves.sprite_sheets[GET_BODY_TYPE])
			result_layer = image(gloves.sprite_sheets[GET_BODY_TYPE], t_state)
		else
			result_layer = image('icons/mob/hands.dmi', t_state)

		if (gloves.color)
			result_layer.color = gloves.color

		if(gloves.blood_DNA)
			var/image/bloodsies = image(species.blood_mask, "bloodyhands")
			bloodsies.color = gloves.blood_color
			result_layer = list(result_layer, bloodsies)

		gloves.screen_loc = ui_gloves
		overlays_raw[GLOVES_LAYER] = result_layer
	else if(blood_DNA)
		var/image/bloodsies	= image(species.blood_mask, "bloodyhands")
		bloodsies.color = hand_blood_color
		overlays_raw[GLOVES_LAYER] = bloodsies
	else
		overlays_raw[GLOVES_LAYER] = null

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_glasses(var/update_icons=1)
	if (QDELING(src))
		return

	var/image/glasses_overlay = null
	if(check_draw_glasses())
		if(glasses.contained_sprite)
			glasses.auto_adapt_species(src)
			var/state = "[UNDERSCORE_OR_NULL(glasses.icon_species_tag)][glasses.item_state][WORN_EYES]"

			glasses_overlay = image(glasses.icon_override || glasses.icon, state)

		else if(glasses.icon_override)
			glasses_overlay = image(glasses.icon_override, glasses.icon_state)
		else if(glasses.sprite_sheets && glasses.sprite_sheets[GET_BODY_TYPE])
			glasses_overlay = image(glasses.sprite_sheets[GET_BODY_TYPE], glasses.icon_state)
		else
			glasses_overlay = image('icons/mob/eyes.dmi', glasses.icon_state)

		if(glasses.color)
			glasses_overlay.color = glasses.color

	overlays_raw[GLASSES_LAYER] = glasses_overlay

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_ears(var/update_icons=1)
	if (QDELING(src))
		return

	overlays_raw[EARS_LAYER] = null

	if (check_draw_ears())
		var/result_layer
		if(l_ear)
			var/t_type = l_ear.icon_state

			if(l_ear.contained_sprite)
				l_ear.auto_adapt_species(src)
				t_type = "[UNDERSCORE_OR_NULL(l_ear.icon_species_tag)][l_ear.item_state][WORN_LEAR]"
				result_layer = image(l_ear.icon_override || l_ear.icon, t_type)
			else if(l_ear.icon_override)
				result_layer = image(l_ear.icon_override, "[t_type]_l")
			else if(l_ear.sprite_sheets && l_ear.sprite_sheets[GET_BODY_TYPE])
				result_layer = image(l_ear.sprite_sheets[GET_BODY_TYPE], "[t_type]_l")
			else
				result_layer = image('icons/mob/ears.dmi', "[t_type]")

		if(r_ear)
			var/image/I
			var/t_type = r_ear.icon_state
			if(r_ear.contained_sprite)
				r_ear.auto_adapt_species(src)
				t_type = "[UNDERSCORE_OR_NULL(r_ear.icon_species_tag)][r_ear.item_state][WORN_REAR]"
				I = image(r_ear.icon_override || r_ear.icon, t_type)

			else if(r_ear.icon_override)
				I = image(r_ear.icon_override, "[t_type]_r")
			else if(r_ear.sprite_sheets && r_ear.sprite_sheets[GET_BODY_TYPE])
				I = image(r_ear.sprite_sheets[GET_BODY_TYPE], "[t_type]_r")
			else
				I = image('icons/mob/ears.dmi', "[t_type]")

			if (result_layer)
				result_layer = list(result_layer, I)
				I.color = r_ear.color
			else
				result_layer = I

		overlays_raw[EARS_LAYER] = result_layer

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_shoes(var/update_icons=1)
	if (QDELING(src))
		return

	overlays_raw[SHOES_LAYER] = null
	overlays_raw[SHOES_LAYER_ALT] = null
	if(check_draw_shoes())
		var/image/standing
		if(shoes.contained_sprite)
			shoes.auto_adapt_species(src)
			var/state = "[UNDERSCORE_OR_NULL(shoes.icon_species_tag)][shoes.item_state][WORN_SHOES]"

			standing = image(shoes.icon_override || shoes.icon, state)

		else if(shoes.icon_override)
			standing = image(shoes.icon_override, "[shoes.icon_state]")
		else if(shoes.sprite_sheets && shoes.sprite_sheets[GET_BODY_TYPE])
			standing = image("icon" = shoes.sprite_sheets[GET_BODY_TYPE], "icon_state" = "[shoes.icon_state]")
		else
			standing = image("icon" = 'icons/mob/feet.dmi', "icon_state" = "[shoes.icon_state]")

		//Shoe layer stuff from Polaris v1.0333a
		var/shoe_layer = SHOES_LAYER
		if(istype(shoes, /obj/item/clothing/shoes))
			var/obj/item/clothing/shoes/ushoes = shoes
			if(ushoes.shoes_under_pants == 1)
				shoe_layer = SHOES_LAYER_ALT

		standing.color = shoes.color

		var/list/ovr

		if(shoes.blood_DNA)
			var/image/bloodsies = image("icon" = species.blood_mask, "icon_state" = "shoeblood")
			bloodsies.color = shoes.blood_color
			ovr = list(standing, bloodsies)

		overlays_raw[shoe_layer] = ovr || standing
	else
		if(feet_blood_DNA)
			var/image/bloodsies = image("icon" = species.blood_mask, "icon_state" = "shoeblood")
			bloodsies.color = feet_blood_color
			overlays_raw[SHOES_LAYER] = bloodsies
		else
			overlays_raw[SHOES_LAYER] = null
			overlays_raw[SHOES_LAYER_ALT] = null

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_s_store(var/update_icons=1)
	if (QDELING(src))
		return

	if(s_store)
		if(s_store.contained_sprite)
			s_store.auto_adapt_species(src)
			var/state="[UNDERSCORE_OR_NULL(s_store.icon_species_tag)][s_store.item_state][WORN_SSTORE]"
			overlays_raw[SUIT_STORE_LAYER] = image(s_store.icon_override || s_store.icon, state)
			s_store.screen_loc = ui_sstore1
		else
			//s_store.auto_adapt_species(src)
			overlays_raw[SUIT_STORE_LAYER] = image('icons/mob/belt_mirror.dmi', s_store.item_state || s_store.icon_state)
			s_store.screen_loc = ui_sstore1		//TODO
	else
		overlays_raw[SUIT_STORE_LAYER] = null
	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_head(update_icons = TRUE, recurse = TRUE)
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
			var/state = "[UNDERSCORE_OR_NULL(head.icon_species_tag)][head.item_state][WORN_HEAD]"

			standing = image(head.icon_override || head.icon, state)
		else if(head.icon_override)
			t_icon = head.icon_override
		else if(head.sprite_sheets && head.sprite_sheets[GET_BODY_TYPE])
			t_icon = head.sprite_sheets[GET_BODY_TYPE]

		else if(head.item_icons && (slot_head_str in head.item_icons))
			t_icon = head.item_icons[slot_head_str]
		else
			t_icon = INV_HEAD_DEF_ICON

		if (!standing)
			//Create the image
			standing = image(t_icon, head.icon_state)

		standing.color = head.color

		var/list/ovr

		if(head.blood_DNA)
			var/image/bloodsies = image("icon" = species.blood_mask, "icon_state" = "helmetblood")
			bloodsies.color = head.blood_color
			ovr = list(standing, bloodsies)

		if(istype(head,/obj/item/clothing/head))
			var/obj/item/clothing/head/hat = head
			var/cache_key = "[hat.light_overlay]_[GET_BODY_TYPE]"
			if(hat.on && SSicon_cache.light_overlay_cache["[cache_key]"])
				if (!ovr)
					ovr = list(standing)
				ovr += SSicon_cache.light_overlay_cache["[cache_key]"]

		overlays_raw[HEAD_LAYER] = ovr || standing

	if (recurse)
		update_hair(FALSE)
		update_inv_wear_mask(FALSE, FALSE)

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
		var/t_icon = belt.icon || belt.icon_state
		var/image/standing

		if(belt.contained_sprite)
			belt.auto_adapt_species(src)
			t_state = "[UNDERSCORE_OR_NULL(belt.icon_species_tag)][belt.item_state][WORN_BELT]"

			if(belt.icon_override)
				t_icon = belt.icon_override

		else if(belt.icon_override)
			t_icon = belt.icon_override
		else if(belt.sprite_sheets && belt.sprite_sheets[GET_BODY_TYPE])
			t_icon = belt.sprite_sheets[GET_BODY_TYPE]
		else
			t_icon = 'icons/mob/belt.dmi'

		standing = image(t_icon, t_state)
		var/list/ovr

		if(belt.contents.len && istype(belt, /obj/item/storage/belt))
			ovr = list(standing)
			for(var/obj/item/i in belt.contents)
				var/c_state
				var/c_icon
				if(i.contained_sprite)
					c_state = "[UNDERSCORE_OR_NULL(i.icon_species_tag)][i.item_state][WORN_BELT]"
					c_icon = belt.icon_override || belt.icon
				else
					c_icon = 'icons/mob/belt.dmi'
					c_state = i.item_state || i.icon_state
				ovr += image(c_icon, c_state)

		var/beltlayer = BELT_LAYER
		if(istype(belt, /obj/item/storage/belt))
			var/obj/item/storage/belt/ubelt = belt
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
			var/state = "[UNDERSCORE_OR_NULL(wear_suit.icon_species_tag)][wear_suit.item_state][WORN_SUIT]"

			standing = image(wear_suit.icon_override || wear_suit.icon, state)

		else if(wear_suit.icon_override)
			standing = image(wear_suit.icon_override, wear_suit.icon_state)
		else if(wear_suit.sprite_sheets && wear_suit.sprite_sheets[GET_BODY_TYPE])
			standing = image(wear_suit.sprite_sheets[GET_BODY_TYPE], wear_suit.icon_state)
		else
			standing = image('icons/mob/suit.dmi', wear_suit.icon_state)

		if (wear_suit.color)
			standing.color = wear_suit.color

		var/list/ovr

		if(wear_suit.blood_DNA)
			var/obj/item/clothing/suit/S = wear_suit
			var/image/bloodsies = image(species.blood_mask, "[S.blood_overlay_type]blood")
			bloodsies.color = wear_suit.blood_color
			ovr = list(standing, bloodsies)

		// Accessories - copied from uniform, BOILERPLATE because fuck this system.
		var/obj/item/clothing/suit/suit = wear_suit
		if(istype(suit) && LAZYLEN(suit.accessories))
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
	update_inv_w_uniform(0)

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_pockets(var/update_icons=1)
	if (QDELING(src))
		return

	if(l_store)
		l_store.screen_loc = ui_storage1	//TODO
	if(r_store)
		r_store.screen_loc = ui_storage2	//TODO

	if(update_icons)
		update_icons()


/mob/living/carbon/human/update_inv_wear_mask(update_icons = TRUE, recurse = TRUE)
	if (QDELING(src))
		return

	overlays_raw[FACEMASK_LAYER] = null
	if(check_draw_mask())
		wear_mask.screen_loc = ui_mask	//TODO
		var/image/standing

		if(wear_mask.contained_sprite)
			wear_mask.auto_adapt_species(src)
			var/state = "[UNDERSCORE_OR_NULL(wear_mask.icon_species_tag)][wear_mask.item_state][WORN_MASK]"

			standing = image(wear_mask.icon_override || wear_mask.icon, state)

		else if(wear_mask.icon_override)
			standing = image(wear_mask.icon_override, wear_mask.icon_state)
		else if(wear_mask.sprite_sheets && wear_mask.sprite_sheets[GET_BODY_TYPE])
			standing = image(wear_mask.sprite_sheets[GET_BODY_TYPE], wear_mask.icon_state)
		else
			standing = image('icons/mob/mask.dmi', wear_mask.icon_state)

		if (wear_mask.color)
			standing.color = wear_mask.color

		var/list/ovr

		if( !istype(wear_mask, /obj/item/clothing/mask/smokable/cigarette) && wear_mask.blood_DNA )
			var/image/bloodsies = image(species.blood_mask, "maskblood")
			bloodsies.color = wear_mask.blood_color
			ovr = list(standing, bloodsies)

		overlays_raw[FACEMASK_LAYER] = ovr || standing

	if (recurse)
		update_inv_head(FALSE, FALSE)
		update_hair(FALSE)

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
			overlay_state = "[UNDERSCORE_OR_NULL(back.icon_species_tag)][back.item_state][WORN_BACK]"

			overlay_icon = back.icon_override || back.icon
		else if(back.icon_override)
			overlay_icon = back.icon_override
		else if(istype(back, /obj/item/rig))
			//If this is a rig and a mob_icon is set, it will take species into account in the rig update_icon() proc.
			var/obj/item/rig/rig = back
			overlay_icon = rig.mob_icon
		else if(back.sprite_sheets && back.sprite_sheets[GET_BODY_TYPE])
			overlay_icon = back.sprite_sheets[GET_BODY_TYPE]
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
				overlay_icon = back.icon
				overlay_state = "[back.icon_state]_w"
			else
				overlay_state = back.icon_state

		var/image/standing = image(overlay_icon, overlay_state)
		if (back.color)
			standing.color = back.color

		overlays_raw[BACK_LAYER] = standing

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
			standing = image(handcuffed.icon_override, "handcuff1")
		else if(handcuffed.sprite_sheets && handcuffed.sprite_sheets[GET_BODY_TYPE])
			standing = image(handcuffed.sprite_sheets[GET_BODY_TYPE], "handcuff1")
		else
			standing = image('icons/mob/mob.dmi', "handcuff1")
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
			standing = image(legcuffed.icon_override, "legcuff1")
		else if(legcuffed.sprite_sheets && legcuffed.sprite_sheets[GET_BODY_TYPE])
			standing = image(legcuffed.sprite_sheets[GET_BODY_TYPE], "legcuff1")
		else
			standing = image('icons/mob/mob.dmi', "legcuff1")
		overlays_raw[LEGCUFF_LAYER] = standing

		if(m_intent != "walk")
			m_intent = "walk"
			if(hud_used && hud_used.move_intent)
				hud_used.move_intent.icon_state = "walking"

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
			t_state = "[UNDERSCORE_OR_NULL(r_hand.icon_species_tag)][r_hand.item_state][WORN_RHAND]"

			overlays_raw[R_HAND_LAYER] = image(r_hand.icon_override || r_hand.icon, t_state)
		else
			if(r_hand.item_state_slots && r_hand.item_state_slots[slot_r_hand_str])
				t_state = r_hand.item_state_slots[slot_r_hand_str]
			else
				t_state = r_hand.item_state || r_hand.icon_state

			//determine icon to use
			var/icon/t_icon
			if(r_hand.item_icons && (slot_r_hand_str in r_hand.item_icons))
				t_icon = r_hand.item_icons[slot_r_hand_str]
			else if(r_hand.icon_override)
				t_state += "_r"
				t_icon = r_hand.icon_override
			else
				t_icon = INV_R_HAND_DEF_ICON

			overlays_raw[R_HAND_LAYER] = image(t_icon, t_state)

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
			t_state = "[UNDERSCORE_OR_NULL(l_hand.icon_species_tag)][l_hand.item_state][WORN_LHAND]"

			overlays_raw[L_HAND_LAYER] = image(l_hand.icon_override || l_hand.icon, t_state)
		else
			if(l_hand.item_state_slots && l_hand.item_state_slots[slot_l_hand_str])
				t_state = l_hand.item_state_slots[slot_l_hand_str]
			else
				t_state = l_hand.item_state || l_hand.icon_state

			//determine icon to use
			var/icon/t_icon
			if(l_hand.item_icons && (slot_l_hand_str in l_hand.item_icons))
				t_icon = l_hand.item_icons[slot_l_hand_str]
			else if(l_hand.icon_override)
				t_state += "_l"
				t_icon = l_hand.icon_override
			else
				t_icon = INV_L_HAND_DEF_ICON

			overlays_raw[L_HAND_LAYER] = image(t_icon, t_state)

	if(update_icons)
		update_icons()

/mob/living/carbon/human/proc/update_tail_showing(var/update_icons=1)

	if (QDELING(src))
		return

	overlays_raw[TAIL_NORTH_LAYER] = null
	overlays_raw[TAIL_SOUTH_LAYER] = null

	var/tail_layer = GET_TAIL_LAYER

	if(species.tail && !(wear_suit && wear_suit.flags_inv & HIDETAIL))
		var/icon/tail_s = get_tail_icon()
		overlays_raw[tail_layer] = image(tail_s, icon_state = "[species.tail]_s")
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

	var/tail_layer = GET_TAIL_LAYER

	var/image/tail_overlay = overlays_raw[tail_layer]

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

	var/tail_layer = GET_TAIL_LAYER

	var/image/tail_overlay = overlays_raw[tail_layer]
	if(tail_overlay && tail_overlay.icon_state == t_state)
		return //let the existing animation finish

	tail_overlay = set_tail_state(t_state)
	if(tail_overlay)
		addtimer(CALLBACK(src, .proc/end_animate_tail_once, tail_overlay), 20, TIMER_CLIENT_TIME)

/mob/living/carbon/human/proc/end_animate_tail_once(image/tail_overlay)
	//check that the animation hasn't changed in the meantime
	var/tail_layer = GET_TAIL_LAYER
	if(overlays_raw[tail_layer] == tail_overlay && tail_overlay.icon_state == "[species.tail]_once")
		animate_tail_stop()

/mob/living/carbon/human/proc/animate_tail_start()
	set_tail_state("[species.tail]_slow[rand(0,9)]")

/mob/living/carbon/human/proc/animate_tail_fast()
	set_tail_state("[species.tail]_loop[rand(0,9)]")

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

	var/list/collar_mapping	= SSicon_cache.collar_states
	if (!collar_mapping)
		SSicon_cache.setup_collar_mappings()

	if(wear_suit && collar_mapping[wear_suit.icon_state])
		overlays_raw[COLLAR_LAYER] = image('icons/mob/collar.dmi', wear_suit.icon_state)
	else
		overlays_raw[COLLAR_LAYER] = null

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_fire(var/update_icons=1)
	if (QDELING(src))
		return

	overlays_raw[FIRE_LAYER] = on_fire ? image(species.onfire_overlay, "Standing", layer = FIRE_LAYER) : null

	if(update_icons)
		update_icons()

/mob/living/carbon/human/proc/update_surgery(var/update_icons=1)
	overlays_raw[SURGERY_LAYER] = null

	var/image/total = new
	for(var/obj/item/organ/external/E in organs)
		if(E.status & ORGAN_ROBOT || E.is_stump())
			continue
		if(!E.open)
			continue

		var/surgery_icon = E.owner.species.get_surgery_overlay_icon(src)
		if(!surgery_icon)
			continue

		var/list/surgery_states = icon_states(surgery_icon)
		var/base_state = "[E.icon_name][E.open]"
		var/overlay_state = "[base_state]-flesh"
		var/list/overlays_to_add

		if(overlay_state in surgery_states)
			var/image/flesh = image(icon = surgery_icon, icon_state = overlay_state, layer = -SURGERY_LAYER)
			flesh.color = E.owner.species.flesh_color
			LAZYADD(overlays_to_add, flesh)
		overlay_state = "[base_state]-blood"
		if(overlay_state in surgery_states)
			var/image/blood = image(icon = surgery_icon, icon_state = overlay_state, layer = -SURGERY_LAYER)
			blood.color = E.owner.species.blood_color
			LAZYADD(overlays_to_add, blood)
		overlay_state = "[base_state]-bones"
		if(overlay_state in surgery_states)
			LAZYADD(overlays_to_add, image(icon = surgery_icon, icon_state = overlay_state, layer = -SURGERY_LAYER))
		total.overlays |= overlays_to_add

	overlays_raw[SURGERY_LAYER] = total

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
#undef BELT_LAYER
#undef SUIT_LAYER
#undef TAIL_NORTH_LAYER
#undef TAIL_SOUTH_LAYER
#undef GLASSES_LAYER
#undef BELT_LAYER_ALT
#undef SUIT_STORE_LAYER
#undef BACK_LAYER
#undef HAIR_LAYER
#undef EARS_LAYER
#undef FACEMASK_LAYER
#undef HEAD_LAYER
#undef COLLAR_LAYER
#undef HANDCUFF_LAYER
#undef LEGCUFF_LAYER
#undef L_HAND_LAYER
#undef R_HAND_LAYER
#undef FIRE_LAYER
#undef TOTAL_LAYERS

#undef UNDERSCORE_OR_NULL
#undef GET_BODY_TYPE
#undef GET_TAIL_LAYER

