// Vampire and thrall datums. Contains the necessary information about a vampire.
// Must be attached to a /datum/mind.
/datum/vampire
	var/list/thralls = list()					// A list of thralls that obey the vampire.
	var/blood_total = 0							// How much total blood do we have?
	var/blood_usable = 0						// How much usable blood do we have?
	var/blood_vamp = 0							// How much vampire blood do we have?
	var/frenzy = 0								// A vampire's frenzy meter.
	var/last_frenzy_message = 0					// Keeps track of when the last frenzy alert was sent.
	var/status = 0								// Bitfield including different statuses.
	var/stealth = TRUE							// Do you want your victims to know of your sucking?

	var/obj/screen/blood_hud
	var/obj/screen/frenzy_hud
	var/obj/screen/blood_suck_hud

	var/list/datum/power/vampire/purchased_powers = list()			// List of power datums available for use.
	var/obj/effect/dummy/veil_walk/holder = null					// The veil_walk dummy.
	var/mob/living/carbon/human/master = null	// The vampire/thrall's master.

	var/image/master_image
	var/image/thrall_image

/datum/vampire/thrall
	status = VAMP_ISTHRALL

/datum/vampire/proc/add_power(var/datum/mind/vampire, var/datum/power/vampire/power, var/announce = 0)
	if (!vampire || !power)
		return
	if (power in purchased_powers)
		return

	purchased_powers += power

	if (power.isVerb && power.verbpath)
		vampire.current.verbs += power.verbpath
	if(announce)
		to_chat(vampire.current, SPAN_NOTICE("------------------"))
		to_chat(vampire.current, SPAN_NOTICE("<b>You have unlocked a new power:</b> [power.name]."))
		to_chat(vampire.current, SPAN_NOTICE(" - [power.desc]"))
		if (power.helptext)
			to_chat(vampire.current, SPAN_GOOD(" - [power.helptext]"))
		to_chat(vampire.current, SPAN_NOTICE("------------------"))

// Proc to safely remove blood, without resulting in negative amounts of blood.
/datum/vampire/proc/use_blood(var/blood_to_use)
	if (!blood_to_use || blood_to_use <= 0)
		return

	blood_usable = max(0, blood_usable - blood_to_use)

/datum/vampire/proc/assign_master(var/mob/M, var/mob/set_master, var/datum/vampire/V)
	master = set_master
	V.thralls += M
	thrall_image = image('icons/mob/hud.dmi', M, "hudthrall")
	set_master.client.images += thrall_image
	master_image = image('icons/mob/hud.dmi', set_master, "hudvampire")
	M.client.images += master_image

/datum/vampire/proc/lose_master(var/mob/M)
	QDEL_NULL(thrall_image)
	QDEL_NULL(master_image)
	if(master)
		var/datum/vampire/master_vampire = master.mind.antag_datums[MODE_VAMPIRE]
		master_vampire.thralls -= M
	master = null