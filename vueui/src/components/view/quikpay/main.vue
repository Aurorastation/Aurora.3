<template>
    <div>
        <div v-for="(price, name) in items" :key="name">
            {{ name }}: {{ price }} <vui-button :params="{ remove: name }">Delete</vui-button> <vui-input-numeric v-model="selection [name]" width="3em"/>
        </div>
        <div>
            <input v-model="tmp_name">
            <vui-button @click="tmp_price--" :disabled="tmp_price - 1 >= 0">-</vui-button>
            {{ tmp_price }}
            <vui-button @click="tmp_price++">+</vui-button>
            <vui-button :params="{ add: {name: tmp_name, price: tmp_price }}">Add</vui-button>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return this.$root.$data.state;
    }
};
</script>