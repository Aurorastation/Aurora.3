<template>
  <div>
    <vui-button v-show="!creating" @click="creating = true">New</vui-button>
    <template v-if="creating">
      <input type="text" v-model="newname" >
      <vui-button @click="newFile()">Create</vui-button>
    </template>
    <h2>Available files:</h2>
    <table>
      <tr>
        <th>File name</th>
        <th>File type</th>
        <th>File size (GQ)</th>
        <th>Operations</th>
      </tr>
      <tr v-for="f in s.files" :key="f.name">
        <td>{{ f.name }}</td>
        <td>{{ f.type }}</td>
        <td>{{ f.size }}GQ</td>
        <td>
          <vui-button :params="{execute_file: f.name}">Execute</vui-button>
          <vui-button :params="{edit_file: f.name}">Edit</vui-button>
        </td>
      </tr>
    </table>
  </div>
</template>

<script>
export default {
  data() {
    return {
      s: this.$root.$data.state,
      creating: false,
      newname: "",
    }
  },
  methods: {
    newFile() {
      this.$toTopic({
        new: this.newname,
      })
      this.newname = ""
      this.creating = false
    },
  },
}
</script>
