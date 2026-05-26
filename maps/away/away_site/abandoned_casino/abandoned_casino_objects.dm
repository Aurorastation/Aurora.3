/obj/machinery/computer/terminal/loreconsole/abandoned_casino/hangar_note
	entries = list(
		new/datum/lore_console_entry(
			"\[RE: Receiving dock malfunction\]", {"
	<hr>
	Automated systems no longer works reliably, as the recent incident pointed out.
	<br><br>
	Until further notice excercise extreme causion whenever the shipment arrives. For now you'll have to manually cycle air in and out
	through the air alarm console. Make SURE to not cause a decompression once the shipment undocks.
	Management doesn't want to hear such re-occurrances.
	<br><br>
	This is now a two person job, one remains inside the operator room to open the gates, other will be outside to drain the air.
	"})
	)

/obj/effect/landmark/corpse/abandoned_casino/agent
	name = "Agent"
	corpseuniform = /obj/item/clothing/under/suit_jacket/charcoal
	corpsegloves = /obj/item/clothing/gloves/black_leather
	corpsebelt = /obj/item/storage/belt/utility/full
	corpseshoes = /obj/item/clothing/shoes/laceup
	corpseid = TRUE
	corpseidjob = "Casino Bodyguard"
	corpseidaccess = ACCESS_ABANDONED_CASINO_STAFF
	corpseidicon = "dark"

/obj/effect/landmark/corpse/abandoned_casino/agent/do_extra_customization(mob/living/carbon/human/M)
	M.dir = pick(GLOB.cardinals)
	M.adjustBruteLoss(rand(200, 300))

/obj/item/paper/fluff/abandoned_casino/agents_note
	name = "instructions"
	info = {"
	<hr>
	<br><small>You will find the drill in the barricaded room, by the kitchen maintenance.
	<br><br>
	You have an hour to make it count, once you retrieve the target get out of the scene and stay low until the client reaches you.
	"}

/obj/item/paper/fluff/abandoned_casino/agents_note/Initialize()
	. = ..()
	src.add_blood()

/obj/item/paper/fluff/abandoned_casino/techs_note
	name = "reminder"
	info = {"
	<hr>
	<br><small>As it was ought to happen eventually, we're out of efficient trajectory for solar arrays.
	The amount we have at hand can scarcely power the entire station.
	<br><br>
	Lucky for you, your good old pal prepared new spots for more arrays outside. Make yourself useful, move your lazy bum and suit up.
	Incase you're reading this while light's out, portable gen behind you will get us going for a good while.
	"}

//========================used bullet casings=======================
/obj/item/ammo_casing/rifle/used/Initialize()
	. = ..()
	expend()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)


/obj/item/ammo_casing/pistol/used/Initialize()
	. = ..()
	expend()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)

/obj/item/ammo_casing/pistol/magnum/used/Initialize()
	. = ..()
	expend()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)


