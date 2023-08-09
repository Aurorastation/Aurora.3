
/datum/gear
	var/display_name       //Name/index. Must be unique.
	var/description        //Description of this gear. If left blank will default to the description of the pathed item.
	var/path               //Path to item.
	var/cost = 1           //Number of points used. Items in general cost 1 point, storage/armor/gloves/special use costs 2 points.
	var/slot               //Slot to equip to.
	var/list/allowed_roles //Roles that can spawn with this item.
	var/list/whitelisted   //Species that can spawn with this item.
	var/faction            //Is this item whitelisted for a faction?
	var/list/culture_restriction //Is this item restricted to certain cultures? The contents are paths.
	var/list/origin_restriction //Is this item restricted to certain origins? The contents are paths.
	var/list/gear_tweaks = list() //List of datums which will alter the item after it has been spawned.
	var/flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
	var/augment = FALSE
	var/list/tags = list() //Tags of this gear. Some tags are added automatically. See `tag.dm`.

/datum/gear/New()
	..()
	if(!description)
		var/obj/O = path
		description = initial(O.desc)
	if(flags & GEAR_HAS_COLOR_SELECTION)
		gear_tweaks += list(gear_tweak_free_color_choice)
	if(flags & GEAR_HAS_ALPHA_SELECTION)
		gear_tweaks += list(gear_tweak_alpha_choice)
	if(flags & GEAR_HAS_ACCENT_COLOR_SELECTION)
		gear_tweaks += list(gear_tweak_accent_color)
	if(flags & GEAR_HAS_NAME_SELECTION)
		gear_tweaks += list(gear_tweak_free_name)
	if(flags & GEAR_HAS_DESC_SELECTION)
		gear_tweaks += list(gear_tweak_free_desc)
	if(flags & GEAR_HAS_COLOR_ROTATION_SELECTION)
		gear_tweaks += list(gear_tweak_color_rotation)
	if(!islist(tags))
		tags = list(tags)
	fill_automatic_tags_on_item(src)
	grab_manual_tags_from_item(src)

/datum/gear_data
	var/path
	var/location
	var/faction_requirement

/datum/gear_data/New(var/path, var/location, var/faction)
	src.path = path
	src.location = location
	src.faction_requirement = faction

/datum/gear/proc/cant_spawn_item_reason(var/location, var/metadata, var/mob/living/carbon/human/human, var/datum/job/job, var/datum/preferences/prefs)
	var/datum/gear_data/gd = new(path, location, faction)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		if(metadata["[gt]"])
			gt.tweak_gear_data(metadata["[gt]"], gd, human)
		else
			gt.tweak_gear_data(gt.get_default(), gd, human)

	var/obj/spawning_item = gd.path
	if(length(allowed_roles) && !(job.title in allowed_roles))
		return "You cannot spawn with the [initial(spawning_item.name)] with your current job!"
	if(!check_species_whitelist(human))
		return "You cannot spawn with the [initial(spawning_item.name)] with your current species!"
	if(gd.faction_requirement && (human.employer_faction != "Stellar Corporate Conglomerate" && gd.faction_requirement != human.employer_faction))
		return "You cannot spawn with the [initial(spawning_item.name)] with your current faction!"
	var/our_culture = text2path(prefs.culture)
	if(culture_restriction && !(our_culture in culture_restriction))
		return "You cannot spawn with the [initial(spawning_item.name)] with your current culture!"
	var/our_origin = text2path(prefs.origin)
	if(origin_restriction && !(our_origin in origin_restriction))
		return "You cannot spawn with the [initial(spawning_item.name)] with your current origin!"
	return null

/datum/gear/proc/spawn_item(var/location, var/metadata, var/mob/living/carbon/human/H)
	var/datum/gear_data/gd = new(path, location, faction)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		if(metadata["[gt]"])
			gt.tweak_gear_data(metadata["[gt]"], gd, H)
		else
			gt.tweak_gear_data(gt.get_default(), gd, H)
	if(ispath(gd.path, /obj/item/organ/external))
		var/obj/item/organ/external/external_aug = gd.path
		var/obj/item/organ/external/replaced_limb = H.get_organ(initial(external_aug.limb_name))
		replaced_limb.droplimb(TRUE, DROPLIMB_EDGE, FALSE)
		qdel(replaced_limb)
	var/item = new gd.path(gd.location)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		if(metadata["[gt]"])
			gt.tweak_item(item, metadata["[gt]"], H)
		else
			gt.tweak_item(item, gt.get_default(), H)
	return item

/datum/gear/proc/spawn_random(var/location)
	var/datum/gear_data/gd = new(path, location)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		gt.tweak_gear_data(gt.get_random(), gd)
	var/item = new gd.path(gd.location)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		gt.tweak_item(item, gt.get_random())
	return item

/datum/gear/proc/check_species_whitelist(mob/living/carbon/human/H)
	if(whitelisted && (!(H.species.name in whitelisted)))
		return FALSE
	return TRUE

// arg should be a faction name string
/datum/gear/proc/check_faction(var/faction_)
	if((faction && faction_ && faction_ != "None" && faction_ != "Stellar Corporate Conglomerate") && (faction != faction_))
		return FALSE
	return TRUE

// arg should be a role name string
/datum/gear/proc/check_role(var/role)
	if(role && allowed_roles && !(role in allowed_roles))
		return FALSE
	return TRUE

// arg should be a culture path
/datum/gear/proc/check_culture(var/culture)
	if(culture && culture_restriction && !(culture in culture_restriction))
		return FALSE
	return TRUE

// arg should be a origin path
/datum/gear/proc/check_origin(var/origin)
	if(origin && origin_restriction && !(origin in origin_restriction))
		return FALSE
	return TRUE

// returns the list of any possible item paths of this gear
// either a list with just the path var, or the paths list from gear tweaks
/datum/gear/proc/get_paths()
	var/datum/gear_tweak/path/tweak = locate(/datum/gear_tweak/path) in gear_tweaks
	if(tweak && istype(tweak))
		return tweak.valid_paths
	else if(path)
		return list(path)
	else
		return null
