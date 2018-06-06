<template>
    <div>
         <code>{{ active }}</code> TEST UI IS LOADED
         <button v-on:click="state.c++"></button>
    </div>
</template>

<script>
export default {
    name: 'ui-test',
    data () {return this.$root.$data}
}
</script>

<style lang="scss" scoped>

</style>