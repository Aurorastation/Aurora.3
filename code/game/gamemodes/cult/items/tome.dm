/obj/item/book/tome
	name = "arcane tome"
	icon_state = "tome"
	item_state = "tome"
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	unique = TRUE
	slot_flags = SLOT_BELT
	var/tomedat = ""

	tomedat = {"<html>
				<head>
				<style>
				h1 {font-size: 25px; margin: 15px 0px 5px;}
				h2 {font-size: 20px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>
				<h1>The scriptures of Nar-Sie, The One Who Sees, The Geometer of Blood.</h1>

				<i>The book is written in an unknown dialect, there are lots of pictures of various complex geometric shapes. You find some notes in Tau Ceti Basic that give you basic understanding of the many runes written in the book.</i><br>
				<i>Below is the summary of the runes.</i> <br>

				<h2>Rune Descriptions</h2>
				<h3>Teleport self</h3>
				Basically, when you have two runes with the same destination, invoking one will teleport you to the other one. If there are more than 2 runes, you will be teleported to a random one. You can imbue this rune into a talisman, giving you a great escape mechanism.<br>
				<h3>Teleport other</h3>
				Teleport other allows for teleportation for any movable object to another rune with the same third word. You need 3 cultists chanting the invocation for this rune to work.<br>
				<h3>Summon new tome</h3>
				Invoking this rune summons a new arcane tome.
				<h3>Convert a person</h3>
				This rune opens target's mind to the realm of Nar-Sie, which usually results in this person joining the cult. However, some people (mostly the ones who possess high authority) have strong enough will to stay true to their old ideals. <br>
				<h3>Summon Nar-Sie</h3>
				The ultimate rune. It summons the Avatar of Nar-Sie himself, tearing a huge hole in reality and consuming everything around it. Summoning it is the final goal of any cult.<br>
				<h3>Disable Technology</h3>
				Invoking this rune creates a strong electromagnetic pulse in a small radius, making it basically analogous to an EMP grenade. You can imbue this rune into a talisman, making it a decent defensive item.<br>
				<h3>Drain Blood</h3>
				This rune instantly heals you of some brute damage at the expense of a person placed on top of the rune. Whenever you invoke a drain rune, ALL drain runes on the station are activated, draining blood from anyone located on top of those runes. This includes yourself, though the blood you drain from yourself just comes back to you. This might help you identify this rune when studying words. One drain gives up to 25HP per each victim, but you can repeat it if you need more. Draining only works on living people, so you might need to recharge your "Battery" once its empty. Drinking too much blood at once might cause blood hunger.<br>
				<h3>Raise Dead</h3>
				This rune allows for the resurrection of any dead person. You will need a dead human body and a living human sacrifice. Make 2 raise dead runes. Put a living, awake human on top of one, and a dead body on the other one. When you invoke the rune, the life force of the living human will be transferred into the dead body, allowing a ghost standing on top of the dead body to enter it, instantly and fully healing it. Use other runes to ensure there is a ghost ready to be resurrected.<br>
				<h3>Hide runes</h3>
				This rune makes all nearby runes completely invisible. They are still there and will work if activated somehow, but you cannot invoke them directly if you do not see them.<br>
				<h3>Reveal runes</h3>
				This rune is made to reverse the process of hiding a rune. It reveals all hidden runes in a rather large area around it.
				<h3>Leave your body</h3>
				This rune gently rips your soul out of your body, leaving it intact. You can observe the surroundings as a ghost as well as communicate with other ghosts. Your body takes damage while you are there, so ensure your journey is not too long, or you might never come back.<br>
				<h3>Manifest a ghost</h3>
				Unlike the Raise Dead rune, this rune does not require any special preparations or vessels. Instead of using full lifeforce of a sacrifice, it will drain YOUR lifeforce. Stand on the rune and invoke it. If there's a ghost standing over the rune, it will materialise, and will live as long as you don't move off the rune or die. You can put a paper with a name on the rune to make the new body look like that person.<br>
				<h3>Imbue a talisman</h3>
				This rune allows you to imbue the magic of some runes into paper talismans. Create an imbue rune, then an appropriate rune beside it. Put an empty piece of paper on the imbue rune and invoke it. You will now have a one-use talisman with the power of the target rune. Using a talisman drains some health, so be careful with it. You can imbue a talisman with power of the following runes: summon tome, reveal, conceal, teleport, disable technology, communicate, deafen, blind and stun.<br>
				<h3>Sacrifice</h3>
				Sacrifice rune allows you to sacrifice a living thing or a body to the Geometer of Blood. Monkeys and dead humans are the most basic sacrifices, they might or might not be enough to gain His favor. A living human is what a real sacrifice should be, however, you will need 3 people chanting the invocation to sacrifice a living person.
				<h3>Create a wall</h3>
				Invoking this rune solidifies the air above it, creating an an invisible wall. To remove the wall, simply invoke the rune again.
				<h3>Summon cultist</h3>
				This rune allows you to summon a fellow cultist to your location. The target cultist must be unhandcuffed and not buckled to anything. You also need to have 3 people chanting at the rune to successfully invoke it. Invoking it takes heavy strain on the bodies of all chanting cultists.<br>
				<h3>Free a cultist</h3>
				This rune unhandcuffs and unbuckles any cultist of your choice, no matter where he is. You need to have 3 people invoking the rune for it to work. Invoking it takes heavy strain on the bodies of all chanting cultists.<br>
				<h3>Deafen</h3>
				This rune temporarily deafens all non-cultists around you.<br>
				<h3>Blind</h3>
				This rune temporarily blinds all non-cultists around you. Very robust. Use together with the deafen rune to leave your enemies completely helpless.<br>
				<h3>Blood boil</h3>
				This rune boils the blood all non-cultists in visible range. The damage is enough to instantly critically hurt any person. You need 3 cultists invoking the rune for it to work. This rune is unreliable and may cause unpredicted effect when invoked. It also drains significant amount of your health when successfully invoked.<br>
				<h3>Communicate</h3>
				Invoking this rune allows you to relay a message to all cultists on the station and nearby space objects.
				<h3>Stun</h3>
				When invoked directly as a rune, it releases some dark energy, briefly stunning everyone around. When imbued into a talisman, you can force some dark energy into a person, causing their eyes to flash, and their words to falter, keeping them quiet. However, the effect wears off rather fast.<br>
				<h3>Equip Armor</h3>
				When this rune is invoked, either from a rune or a talisman, it will equip the user with the armor of the followers of Nar-Sie. To use this rune to its fullest extent, make sure you are not wearing any form of headgear, armor, gloves or shoes, and make sure you are not holding anything in your hands.<br>
				<h3>See Invisible</h3>
				When invoked when standing on it, this rune allows the user to see the world beyond as long as he does not move.<br>
				</body>
				</html>
				"}

/obj/item/book/tome/attack(mob/living/M, mob/living/user)
	if(isobserver(M))
		var/mob/abstract/observer/D = M
		D.manifest(user)
		attack_admins(D, user)
		return

	if(!istype(M))
		return

	if(!iscultist(user))
		return ..()

	if(iscultist(M))
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	M.take_organ_damage(0, rand(5,20)) //really lucky - 5 hits for a crit
	visible_message(span("warning", "\The [user] beats \the [M] with \the [src]!"))
	to_chat(M, span("danger", "You feel searing heat inside!"))
	attack_admins(M, user)

/obj/item/book/tome/proc/attack_admins(var/mob/living/M, var/mob/living/user)
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had the [name] used on them by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used [name] on [M.name] ([M.ckey])</font>")
	msg_admin_attack("[key_name_admin(user)] used [name] on [M.name] ([M.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(M))


/obj/item/book/tome/attack_self(mob/living/user)
	if(use_check_and_message(user))
		return

	if(iscultist(user))
		if(!istype(user.loc, /turf))
			to_chat(user, span("warning", "You do not have enough space to write a proper rune."))
			return

		var/turf/T = get_turf(user)

		if(T.is_hole || T.is_space())
			to_chat(user, span("warning", "You are unable to write a rune here."))
			return

		// This counts how many runes exist in the game, for some sort of arbitrary rune limit. I trust the old devs had their reasons. - Geeves
		if(length(rune_list) >= 25 + rune_boost + cult.current_antagonists.len)
			to_chat(user, span("warning", "The cloth of reality can't take that much of a strain. Remove some runes first!"))
			return
		else
			switch(alert("What shall you do with the tome?", "Tome of Nar'sie", "Read it", "Scribe a rune", "Cancel"))
				if("Cancel")
					return
				if("Read it")
					if(use_check_and_message(user))
						return
					user << browse("[tomedat]", "window=Arcane Tome")
					return

		//only check if they want to scribe a rune, so they can still read if standing on a rune
		if(locate(/obj/effect/rune) in user.loc)
			to_chat(user, span("warning", "There is already a rune in this location."))
			return

		if(use_check_and_message(user))
			return

		var/chosen_rune
		var/network
		chosen_rune = input("Choose a rune to scribe.") in rune_types
		if(!chosen_rune)
			return
		if(chosen_rune == "None")
			to_chat(user, span("notice", "You decide against scribing a rune, perhaps you should take this time to study your notes."))
			return
		if(chosen_rune == "Teleport")
			network = input(user, "Choose a teleportation network for the rune to connect to.", "Teleportation Rune") in teleport_network

		if(use_check_and_message(user))
			return

		user.visible_message(span("warning", "\The [user] slices open a finger and begins to chant and paint symbols on the floor."), span("notice", "You slice open one of your fingers and begin drawing a rune on the floor whilst softly chanting the ritual that binds your life essence with the dark arcane energies flowing through the surrounding world."))
		user.take_overall_damage((rand(9)+1)/10) // 0.1 to 1.0 damage

		if(do_after(user, 50))
			var/area/A = get_area(user)
			if(use_check_and_message(user))
				return
			
			//prevents using multiple dialogs to layer runes.
			if(locate(/obj/effect/rune) in user.loc) //This is check is done twice. once when choosing to scribe a rune, once here
				to_chat(user, span("warning", "There is already a rune in this location."))
				return

			log_and_message_admins("created \an [chosen_rune] rune at \the [A.name] - [user.loc.x]-[user.loc.y]-[user.loc.z].") //only message if it's actually made

			var/mob/living/carbon/human/H = user
			var/rune_path = rune_types[chosen_rune]
			var/obj/effect/rune/R = new rune_path(get_turf(user))
			to_chat(user, span("notice", "You finish drawing the arcane markings of the Geometer."))
			R.blood_DNA = list()
			R.blood_DNA[H.dna.unique_enzymes] = H.dna.b_type
			if(network)
				R.network = network
			R.cult_description = chosen_rune
			if(ishuman(user))
				var/mob/living/carbon/human/scribe = user
				R.color = scribe.species.blood_color
		return
	else
		to_chat(user, span("cult", "The book seems full of illegible scribbles."))
		return

/obj/item/book/tome/examine(mob/user)
	..(user)
	if(!iscultist(user) || !isobserver(user))
		desc = "An old, dusty tome with frayed edges and a sinister looking cover."
	else
		desc = "The scriptures of Nar-Sie, The One Who Sees, The Geometer of Blood. Contains the details of every ritual his followers could think of. Most of these are useless, though."

/obj/item/book/tome/cultify()
	return