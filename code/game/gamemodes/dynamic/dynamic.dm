#define INTENSITY_NONE 0
#define INTENSITY_LOW 1
#define INTENSITY_MED 2
#define INTENSITY_HIGH 3

/datum/game_mode/dynamic
	name = "Dynamic"
	round_description = "Antagonists are composed based on all the votes."
	extended_round_description = "Eough"
	config_tag = "dynamic"
	votable = FALSE
	end_on_antag_death = FALSE

	required_players = 0
	required_enemies = 0

	var/intensity = INTENSITY_NONE /// The round's chosen intensity.
	var/list/voted_tags = list() /// tag-name : vote count list of all antag types that were voted for.

/datum/game_mode/dynamic/create_antagonists()
	normalize_voted_antags()

	select_antag_tags()

	. = ..()

	// TODO: PIN: How to deal with required players and enemies?

///
/// @brief Normalizes the votes for every tag in voted_tags to be in range of [100, 0].
/// Removes tags which were not voted for.
///
/datum/game_mode/dynamic/proc/normalize_voted_antags()
	var/total_votes = 0
	for (var/tag in voted_tags)
		if (voted_tags[tag])
			total_votes = voted_tags[tag]
		else
			total_votes -= tag

	for (var/tag in voted_tags)
		voted_tags[tag] = (voted_tags[tag] / total_votes) * 100.0

///
/// @brief Selects the final antag tags to be used for the round, based on intensity and normalized votes.
/// Populates antag_tags.
///
/datum/game_mode/dynamic/proc/select_antag_tags()
	var/current_intensity = 0
	var/list/working_tags

	while (current_intensity < intensity && voted_tags.len)
		working_tags = shuffle(voted_tags)

		var/selected = pickweight(working_tags)
		var/datum/antagonist/antag = all_antag_types[tag]

		voted_tags -= selected

		if (current_intensity + antag.intensity > intensity)
			continue
		else
			current_intensity += antag.intensity
			antag_tags += tag
