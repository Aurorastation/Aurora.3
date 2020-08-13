<template>
  <div>
  	<h3>Smartgun Control System</h3>
  	<template v-if="screen">
  		<vui-button :params="{ lock: 1 }">Unlock Console</vui-button>
  	</template>
  	<template v-else>
  		<h3>Detected Firearms</h3>
  		<vui-group>
  			<vui-group-item  v-for="gun in smartguns" :key="gun.ref" :label="gun.registered_user">
  				<vui-button :params="{ togglepin: gun.ref }">{{ gun.lock_status ? "Unlock" : "Lock" }}</vui-button>
				<vui-button :params="{ toggledisable: gun.ref }">{{ gun.disable_status ? "Enable" : "Disable" }}</vui-button>
				<p>gun.area</p>
  			</vui-group-item>
  		</vui-group>
  		<vui-button :params="{ lock: 1 }">Lock Console</vui-button>
  	</template>
  </div>
</template>

<script>
	export default {
	  data() {
		return this.$root.$data.state
	  }
	}
</script>