<template>
	<div>
		<div v-if="!power">
			<div class="itemLabel">
				<h2>NO POWER</h2>
			</div>
		</div>
		<div v-else>
			<div v-if="!linked">
				<div class="itemLabel">
					<h2>NO CONNECTION ESTABLISHED</h2>
				</div>
			</div>
			<div v-else>
				<div v-if="!is_targeting">
					<div class="itemLabel">
						<h2>No target designated.</h2>
					</div>
				</div>
				<select v-model="$root.$data.state.new_ship_weapon">
         			<option v-for="i in ship_weapons" :key="i" :value="i">{{ i }}</option>
   		    	</select>
			</div>
		</div>
	</div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
	}
}
</script>