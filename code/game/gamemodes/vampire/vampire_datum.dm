// Vampire and thrall datums. Contains the necessary information about a vampire.
// Must be attached to a /datum/mind.
/datum/vampire
	var/list/thralls = list()					// A list of thralls that obey the vamire.
	var/blood_total = 0							// How much total blood do we have?
	var/blood_usable = 0						// How much usable blood do we have?
	var/blood_vamp = 0							// How much vampire blood do we have?
	var/frenzy = 0								// A vampire's frenzy meter.
	var/last_frenzy_message = 0					// Keeps track of when the last frenzy alert was sent.
	var/status = 0								// Bitfield including different statuses.
	var/list/datum/power/vampire/purchased_powers = list()			// List of power datums available for use.
	var/obj/effect/dummy/veil_walk/holder = null					// The veil_walk dummy.
	var/mob/living/carbon/human/master = null	// The vampire/thrall's master.

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

	if (announce)
		vampire.current << "<span class='notice'><b>You have unlocked a new power:</b> [power.name].</span>"
		vampire.current << "<span class='notice'>[power.desc]</span>"

		if (power.helptext)
			vampire.current << "<font color='green'>[power.helptext]</font>"
