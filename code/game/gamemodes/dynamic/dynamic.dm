#define INTENSITY_INVALID -1
#define INTENSITY_NONE 0
#define INTENSITY_LOW 1
#define INTENSITY_MED 2
#define INTENSITY_HIGH 3

var/datum/game_mode/dynamic/dynamic_gamemode = null

/datum/game_mode/dynamic
	name = "Dynamic"
	round_description = "Antagonists are composed based on all the votes."
	extended_round_description = "Eough"
	config_tag = "dynamic"
	votable = FALSE
	announce_antag_templates = FALSE

	required_players = 0
	required_enemies = 0

	var/intensity = INTENSITY_NONE /// The round's chosen intensity.
	var/list/voted_tags = list() /// tag-name : vote count list of all antag types that were voted for.

/datum/game_mode/dynamic/New()
	. = ..()

	dynamic_gamemode = src

/datum/game_mode/dynamic/create_antagonists()
	normalize_voted_antags()

	select_antag_tags()

	set_autoantag()

	. = ..()

/datum/game_mode/dynamic/proc/set_intensity(level_str)
	switch (level_str)
		if ("low")
			intensity = INTENSITY_LOW
		if ("medium")
			intensity = INTENSITY_MED
		if ("high")
			intensity = INTENSITY_HIGH
		else
			intensity = INTENSITY_NONE

	log_debug("DYNAMIC GM: Intensity set to [intensity]")
	feedback_set_details("dynamic-gm-intensity", num2text(intensity))

/datum/game_mode/dynamic/proc/set_votes(list/choices)
	for (var/option in choices)
		var/votes = choices[option]["votes"]
		if (votes > 0)
			voted_tags[option] = votes

	log_debug("DYNAMIC GM: Votes going for selection: [voted_tags.Join(", ")].")
	feedback_set_details("dynamic-gm-votes", voted_tags.Join(","))

//
// @brief Returns a list of all antag tags that can be voted for with the current round's intensity.
//
/datum/game_mode/dynamic/proc/get_votable_antags()
	. = list()

	for (var/tag in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[tag]
		if (antag.intensity != INTENSITY_INVALID && antag.intensity <= intensity)
			. += tag

//
// @brief Normalizes the votes for every tag in voted_tags to be in range of [100, 0].
// Removes tags which were not voted for.
//
/datum/game_mode/dynamic/proc/normalize_voted_antags()
	var/total_votes = 0
	for (var/tag in voted_tags)
		if (voted_tags[tag])
			total_votes = voted_tags[tag]
		else
			total_votes -= tag

	for (var/tag in voted_tags)
		voted_tags[tag] = (voted_tags[tag] / total_votes) * 100.0

//
// @brief Selects the final antag tags to be used for the round, based on intensity and normalized votes.
// Populates antag_tags.
//
//TODO: take readied players into account when selecting the antag tags, its certain that antags will spawn
/datum/game_mode/dynamic/proc/select_antag_tags()
	var/current_intensity = 0
	var/list/working_tags

	while (current_intensity < intensity && voted_tags.len)
		working_tags = shuffle(voted_tags)

		var/selected = pickweight(working_tags)

		// Shortcut if only 1 antag up for grabs.
		if (working_tags.len == 1)
			selected = working_tags[1]
		else if (!selected)
			continue

		var/datum/antagonist/antag = all_antag_types[selected]

		if (!antag)
			error("DYNAMIC GM: Empty tag: [selected]")
			voted_tags -= selected
			continue

		voted_tags -= selected

		if (current_intensity + antag.intensity > intensity)
			continue
		else
			current_intensity += antag.intensity
			antag_tags += selected

	log_debug("DYNAMIC GM: Final antag tag selection: [antag_tags.Join(", ")].")
	feedback_set_details("dynamic-gm-selection", antag_tags.Join(","))


//TODO: Expand that with some more logic
/datum/game_mode/dynamic/proc/set_autoantag()
	if(intensity == INTENSITY_MED ||intensity == INTENSITY_HIGH)
		round_autoantag = TRUE
