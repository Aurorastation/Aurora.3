// Vampire and thrall datums. Contains the necessary information about a vampire.
// Must be attached to a /datum/mind.
/datum/vampire
	var/list/thralls = list()					// A list of thralls that obey the vamire.
	var/blood_total = 0							// How much total blood do we have?
	var/blood_usable = 0						// How much usable blood do we have?
	var/blood_vamp = 0							// How much vampire blood do we have?
	var/is_draining = 0							// Is the vampire currently sucking on a victim?
	var/is_healing = 0							// Is the vampire currently healing?
	var/using_presence = 0						// Is the vampire using presence?
	var/full_power = 0							// Is the vampire at full power?
	var/list/datum/power/vampire/purchased_powers = list()			// List of power datums available for use.
	var/holder = null							// The veil_walk dummy.
	var/is_thrall = 0							// Are we dealing with a thrall or a master vampire?
	var/frenzy = 0
	var/mob/living/carbon/human/master = null	// The vampire/thrall's master.

/datum/vampire/thrall
	is_thrall = 1

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
