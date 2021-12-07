<template>
  <div tabindex="-1">
    <p class="csserror">
      Javascript loaded, stylesheets has failed to load.
      <a href="javascript:void(0)"
      ><vui-button :params="{ vueuiforceresource: 1 }"
      >Click here to load.</vui-button
      ></a
      >
    </p>
    <component v-if="componentName" :is="componentName" /><component
      v-if="templateString"
      :is="{ template: templateString }"
    />
  </div>
</template>

<script>
export default {
  computed: {
    componentName() {
      if (this.$root.$data.active.charAt(0) != "?") {
        return "view-" + this.$root.$data.active
      }
      return null
    },
    templateString() {
      if (this.$root.$data.active.charAt(0) == "?") {
        return "<div>" + this.$root.$data.active.substr(1) + "</div>"
      }
      return null
    },
  },
}
</script>
