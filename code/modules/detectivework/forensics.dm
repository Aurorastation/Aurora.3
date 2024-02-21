/obj/item/forensics
	icon = 'icons/obj/forensics.dmi'
	w_class = ITEMSIZE_TINY

/**
 * The maximum percentage of unknown points in a fingerprint string (represented as asterisks)
 * before the fingerprint is considered incomplete enough (and thus not recognisable)
 *
 * A fingerprint is 32 characters long and every unknown point of it is "*"
 */
#define MAX_UNKNOWN_POINTS_FOR_KNOWN_FINGERPRINT_PERCENTAGE 98

/**
 * Returns `TRUE` if the fingerprint is complete (above `FINGERPRINT_COMPLETE`), `FALSE` otherwise
 *
 * * print - The fingerprint (a string)
 */
/proc/is_complete_print(var/print)
	var/unknown_points_percentage = stringpercent(print)
	if(unknown_points_percentage <= MAX_UNKNOWN_POINTS_FOR_KNOWN_FINGERPRINT_PERCENTAGE)
		return TRUE
	else
		return FALSE

#undef MAX_UNKNOWN_POINTS_FOR_KNOWN_FINGERPRINT_PERCENTAGE

/atom/var/list/suit_fibers

/atom/proc/add_fibers(mob/living/carbon/human/M)
	if(M.gloves && istype(M.gloves,/obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/G = M.gloves
		if(G.transfer_blood && G.bloody_hands_mob?.resolve()) //bloodied gloves transfer blood to touched objects
			if(add_blood(G.bloody_hands_mob.resolve())) //only reduces the bloodiness of our gloves if the item wasn't already bloody
				G.transfer_blood--
	else if(M.bloody_hands && M.bloody_hands_mob?.resolve())
		if(add_blood(M.bloody_hands_mob.resolve()))
			M.bloody_hands--

	if(!suit_fibers) suit_fibers = list()
	var/fibertext
	var/item_multiplier = istype(src,/obj/item)?1.2:1
	var/suit_coverage = 0
	if(M.wear_suit)
		fibertext = "Material from \a [initial(M.wear_suit.name)]."
		if(prob(10*item_multiplier) && !(fibertext in suit_fibers))
			suit_fibers += fibertext
		suit_coverage = M.wear_suit.body_parts_covered

	if(M.w_uniform && (M.w_uniform.body_parts_covered & ~suit_coverage))
		fibertext = "Fibers from \a [initial(M.w_uniform.name)]."
		if(prob(15*item_multiplier) && !(fibertext in suit_fibers))
			suit_fibers += fibertext

	if(M.gloves && (M.gloves.body_parts_covered & ~suit_coverage))
		fibertext = "Material from a pair of [initial(M.gloves.name)]."
		if(prob(20*item_multiplier) && !(fibertext in suit_fibers))
			suit_fibers += fibertext
