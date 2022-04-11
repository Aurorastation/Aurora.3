var/datum/antagonist/vampire/vamp = null

/datum/antagonist/vampire
	id = MODE_VAMPIRE
	role_text = "Vampire"
	role_text_plural = "Vampires"
	bantype = "vampires"
	feedback_tag = "vampire_objective"
	restricted_jobs = list("AI", "Cyborg", "Chaplain", "Head of Security", "Captain", "Chief Engineer", "Research Director", "Chief Medical Officer", "Executive Officer", "Operations Manager")

	protected_jobs = list("Security Officer", "Security Cadet", "Warden", "Investigator")
	restricted_species = list(
		SPECIES_IPC,
		SPECIES_IPC_SHELL,
		SPECIES_IPC_G1,
		SPECIES_DIONA,
		SPECIES_DIONA_COEUS,
		SPECIES_IPC_G2,
		SPECIES_IPC_XION,
		SPECIES_IPC_ZENGHU,
		SPECIES_IPC_BISHOP
	)
	required_age = 10

	welcome_text = "You are a Vampire! Use the \"<b>Vampire Help</b>\" command to learn about the backstory and mechanics! Stay away from the Chaplain, and use the darkness to your advantage."
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	antaghud_indicator = "hudvampire"

	var/vampire_data = ""

/datum/antagonist/vampire/New()
	..()

	vamp = src

	for (var/type in vampirepower_types)
		vampirepowers += new type()

	vampire_data = {"
		<p>This guide contains important OOC information on vampire related mechanics, as well as a short lore introduction.</p>
		<h2>Backstory Synopsis</h2><br>
		<p>Vampires are individuals who, after attempting blood magic or being converted by a vampire themselves, have been corrupted by the Veil and given insidious power. As creatures of the night they have lost all need to eat or drink and are instead consumed with an unquenching thirst for blood to sustain themselves and to grow more powerful and grow ever closer to tapping the full power of The Veil.</p>
		<h2>Mechanics</h2><br>
		<ol>
				<li><b>Blood</b> - Blood comes in two forms: <b>usable</b> and <b>total</b>. The usable blood can be considered your mana pool. It gets trained as you use more powers. Total blood can be thought of as experience points. They cannot be removed, and they will move you further up the power tree. You start with 30 units of usable blood. Be careful with your initial pool: if you expend it, you will start slowly frenzying.</li>
				<li><b>Progression</b> - Vampire's progression is linear. The more total blood you train, the more powers you unlock. As the final step, you will unlock the Veil's full power, which augments the existing powers.</li>
				<li><b>Frenzy</b> - With the raw corruption of the Veil locked within your body, maintaining your sanity is a constant battle. Should you ever run out of usable blood, or become enraged through other means, you may find yourself frenzied. You are reverted to a snarling creature who only wants to consume blood until you are able to break out of it, and regain control. This is done by draining blood.</li>
				<li><b>Everything Holy</b> - As a creature of the Veil to some degree, you are vulnurable to holy influence. You will very quickly find the Chaplain resistant to your blood magic, and his artifacts harmful to your sanity.</li>
		</ol>
		<h2>Powers</h2><br>
		<p>Vampire's powers all come from blood magic. In essence, it's similar to the Cult of Nar'sie's magic, but instead of relying on runes and knowledge of the casters, it uses the blood of the vampire's victims as payment for the super natural acts.</p>
		<hr>
	"}

	for(var/thing in vampirepowers)
		var/datum/power/vampire/VP = thing
		vampire_data += "<div class='rune-block'>"
		vampire_data += "<b>[capitalize_first_letters(VP.name)]</b>: <i>[VP.desc]</i><br>"
		if(VP.helptext)
			vampire_data += "[VP.helptext]<br>"
		vampire_data += "<hr>"
		vampire_data += "</div>"

/datum/antagonist/vampire/update_antag_mob(var/datum/mind/player)
	..()
	player.current.make_vampire()

/datum/antagonist/vampire/remove_antagonist(var/datum/mind/player, var/show_message = TRUE, var/implanted)
	. = ..()
	if(.)
		var/datum/vampire/vampire = player.antag_datums[MODE_VAMPIRE]
		if(player.current.client)
			player.current.client.screen -= vampire.blood_hud
			player.current.client.screen -= vampire.frenzy_hud
		player.current.verbs -= /datum/antagonist/vampire/proc/vampire_help
		for(var/datum/power/vampire/P in vampirepowers)
			player.current.verbs -= P.verbpath
		QDEL_NULL(vampire)

/datum/antagonist/vampire/handle_latelogin(var/mob/user)
	var/datum/mind/M = user.mind
	if(!M)
		return
	var/datum/vampire/vampire = M.antag_datums[MODE_VAMPIRE]
	if(vampire.master_image)
		user.client.images += vampire.master_image
	if(vampire.status & VAMP_ISTHRALL)
		return
	vampire.blood_hud = new /obj/screen/vampire/blood()
	vampire.frenzy_hud = new /obj/screen/vampire/frenzy()
	vampire.blood_suck_hud = new /obj/screen/vampire/suck()
	user.client.screen += vampire.blood_hud
	user.client.screen += vampire.frenzy_hud
	user.client.screen += vampire.blood_suck_hud

	for(var/thrall in vampire.thralls)
		var/mob/T = thrall
		var/datum/vampire/T_vampire = T.mind.antag_datums[MODE_VAMPIRE]
		if(T_vampire.thrall_image)
			user.client.images += T_vampire.thrall_image

/datum/antagonist/vampire/proc/vampire_help()
	set category = "Vampire"
	set name = "Display Help"
	set desc = "Opens a help window with overview of available powers and other important information."

	var/datum/browser/vampire_win = new(usr, "VampirePowers", "The Veil", 600, 700)
	vampire_win.set_content(vamp.vampire_data)
	vampire_win.add_stylesheet("cult", 'html/browser/cult.css')
	vampire_win.open()
