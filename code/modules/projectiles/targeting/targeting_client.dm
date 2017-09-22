//These are called by the on-screen buttons, adjusting what the victim can and cannot do.
/client/proc/add_gun_icons()
	if(!mob) return 1 // This can runtime if someone manages to throw a gun out of their hand before the proc is called.
	screen |= mob.item_use_icon
	screen |= mob.gun_move_icon
	screen |= mob.radio_use_icon

/client/proc/remove_gun_icons()
	if(!mob) return 1 // Runtime prevention on N00k agents spawning with SMG
	screen -= mob.item_use_icon
	screen -= mob.gun_move_icon
	screen -= mob.radio_use_icon