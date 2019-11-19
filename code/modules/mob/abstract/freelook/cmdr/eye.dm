/* COMMANDER EYE

Mob that the Syndicate Commander controls from their uplink console.
Only has access to cameras that have been added to NETWORK_SYNDICATE. */

/mob/abstract/eye/syndicate
    name = "Syndicate Eye"

/mob/abstract/eye/syndicate/Initialize()
    ..()
    visualnet = syndnet