/mob/living/carbon
	gender = MALE
	accent = ACCENT_CETI
	blocks_emissive = EMISSIVE_BLOCK_UNIQUE
	/// Contains icon generation and language information, set during New().
	var/datum/species/species
	/// When this is set, the mob isn't affected by shock or pain.
	var/analgesic = 0
	/// life should decrease this by 1 every tick (??? -batra)
	/// total amount of wounds on mob, used to spread out healing and the like over all wounds (??? -batra)
	var/number_wounds = 0
	/// Whether or not the mob is handcuffed.
	var/obj/item/handcuffed = null
	/// Same as handcuffs but for legs. Bear traps use this.
	var/obj/item/legcuffed = null
	/// Surgery info
	var/datum/surgery_status/op_stage = new/datum/surgery_status
	/// Active emote/pose
	var/pose = null
	var/list/chem_effects = list()
	var/list/chem_doses = list()
	/// For keeping count of misc values (amount of damage, number of ticks, etc).
	var/list/chem_tracking = list()
	var/intoxication = 0//Units of alcohol in their system
	var/datum/reagents/metabolism/bloodstr = null
	var/datum/reagents/metabolism/touching = null
	var/datum/reagents/metabolism/breathing = null

	/// These two help govern taste. The first is the last time a taste message was shown to the player.
	/// The second is the message in question.
	var/last_taste_time = 0
	var/last_taste_text = ""

	var/last_smell_time = 0
	var/last_smell_text = ""

	/// Should only be useful for carbons as the only thing using it has a carbon arg.
	var/coughedtime = null

	var/willfully_sleeping = FALSE
	/// Used by Diona.
	var/consume_nutrition_from_air = FALSE

	/// If they have their hand out to offer someone up from the ground.
	var/help_up_offer = 0

	/// Map organ names to organs.
	var/list/organs_by_name = list()
	/// So internal organs have less ickiness too.
	var/list/internal_organs_by_name = list()

	var/list/stasis_sources = list()
	var/stasis_value
	/// For special cases where something permanently removes a mob's ability to feel pain.
	var/pain_immune = FALSE

