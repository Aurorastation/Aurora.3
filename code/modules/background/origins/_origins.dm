/decl/origin_item
    var/name = "generic origin item"
    var/desc = "You shouldn't be seeing this."
    var/important_information //Big red text. Should only be used if not following it would incur a bwoink.
    var/origin_traits

/decl/origin_item/culture
    name = "generic culture"
    desc = "You shouldn't be seeing this."
    var/list/decl/origin_item/origin/possible_origins = list()

/decl/origin_item/origin
    name = "generic origin"
    desc = "You shouldn't be seeing this."
    var/list/datum/accent/possible_accents = list()
    var/list/datum/citizenship/possible_citizenships = list()
    var/list/datum/religion/possible_religions = list()
    var/list/origin_traits = list()

/decl/origin_item/proc/on_apply(var/mob/living/carbon/human/H)
    return