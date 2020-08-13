<template>
	<div>
		<h3>Smartgun Control System</h3>
		<template v-if="screen">
			<vui-button :params="{ lock: 1 }">Unlock Console</vui-button>
		</template>
		<template v-else>
			<vui-button :params="{ lock: 1 }">Lock Console</vui-button>
			<h3>Detected Firearms</h3>
			<table>
				<tr>
					<th>User</th>
					<th></th>
					<th></th>
					<th></th>
					<th>Area</th>
					<th></th>
					<th></th>
					<th></th>
					<th>Firearm</th>
					<th></th>
					<th></th>
					<th></th>
				</tr>
				<tr v-for="gun in smartguns" :key="gun.ref">
					<td>{{ gun.registered_info }}</td>
					<td></td>
					<td></td>
					<td></td>
					<td>{{ gun.area }}</td>
					<td></td>
					<td></td>
					<td></td>
					<td>{{ gun.gun_name }}</td>
					<td></td>
					<td></td>
					<td></td>
					<vui-button :params="{ togglepin: gun.ref }">{{ gun.lock_status ? "Unlock" : "Lock" }}</vui-button>   
					<vui-button :params="{ toggledisable: gun.ref }">{{ gun.disable_status ? "Enable" : "Disable" }}</vui-button>
				</tr>
			</table>
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