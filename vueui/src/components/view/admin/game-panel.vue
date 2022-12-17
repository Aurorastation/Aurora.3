<template>
	<div @input="populate_list(search_paged)">
		<vui-input-search :input="s.objs" v-model="search_results" autofocus :threshold="threshold" />
		<div>
			<select name="object_list" id="object_list" multiple size="20" v-model.lazy="s.sel_objs">
			</select>
		</div>
	</div>
</template>

<script>
export default {
  data() {
    return {
      search_results: [],
      s: this.$root.$data.state,
	  threshold: 0.3
    }
  },
  computed: {
	search_paged() {
		let paged_results = this.search_results.slice(0, 100);
		if(this.search_results.length < this.s.objs.length) {
			paged_results = paged_results.map(x => this.s.objs[x]);
		}
		return paged_results;
	}
  },
  methods: {
	populate_list(from_list) {
		let new_opts = '';
		let i;
		for (i in from_list)
		{
			new_opts += '<option value="' + from_list[i] + '">'
				+ from_list[i] + '</option>';
		}
		document.getElementById("object_list").innerHTML = new_opts;
	}
  }
}
</script>
