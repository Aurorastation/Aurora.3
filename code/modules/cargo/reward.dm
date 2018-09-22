/datum/bounty_reward/
	var/name = "Reward"
	var/id
	var/reward_description = "loot" //The description of the reward
	var/crate_access = list() //Required access to open the crate, if any.
	var/obj/structure/closet/crate/spawn_crate //The crate to spawn in.
	var/list/item_rewards_flat = list() //Always give these rewards
	var/list/item_rewards_weight = list() //Pick from a list of these rewards based on weights.
	var/reward_count = 0 //Number of items to pick from item rewards weight

/datum/bounty_reward/proc/spawnReward(var/spawn_loc,var/high_priority)

	var/reward_mod = high_priority ? 2 : 1

	if(spawn_crate)
		var/obj/structure/closet/crate/spawned_crate = new spawn_crate(spawn_loc)
		spawn_loc = spawned_crate
		spawn_crate.req_access = crate_access
		spawn_crate.req_one_access = list()

	if(item_rewards_flat.len)
		for(var/spawned_item in item_rewards_flat)
			new spawned_item(spawn_loc)

	if(reward_count && item_rewards_weight.len)
		for(var/i=1,i <= reward_count*reward_mod,i++)
			var/chosen_item = pickweight(item_rewards_weight)
			new chosen_item(spawn_loc)

/datum/controller/subsystem/cargo/proc/setupRewards()
	for(var/d in typesof(/datum/bounty_reward) - /datum/bounty_reward)
		var/datum/bounty_reward/reward = new d
		rewards_list[reward.id] = reward

/datum/controller/subsystem/cargo/proc/spawnReward(var/reward_id)
	var/datum/bounty_reward/selected_reward = rewards_list[reward_id]
	if(!selected_reward)
		//ERROR MESSAGE HERE
		return

	var/area/area_shuttle = shuttle.get_location_area()
	if(!area_shuttle)
		//ERROR MESSAGE HERE
		return

	var/list/clear_turfs = list()

	for(var/turf/T in area_shuttle)
		if(T.density)
			continue
		var/contcount
		for(var/atom/A in T.contents)
			if(!A.simulated)
				continue
			contcount++
		if(contcount)
			continue
		clear_turfs += T

	if(clear_turfs.len)
		selected_reward.spawnReward(pick(clear_turfs))
	else
		//ERROR MESSAGE HERE
		return

/datum/controller/subsystem/cargo/proc/getRewardDescription(var/reward_id)

	var/datum/bounty_reward/selected_reward = rewards_list[reward_id]

	if(!selected_reward)
		return "ERROR: NO SELECTED REWARD FOUND."

	return replacetext(selected_reward.reward_description, "%COUNT", selected_reward.reward_count)
