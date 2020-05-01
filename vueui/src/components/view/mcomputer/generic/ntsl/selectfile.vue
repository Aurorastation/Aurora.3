<template>
  <div>
    <h2>Available files:</h2>
    <table v-if="files">
      <tr>
        <th>File name</th>
        <th>File type</th>
        <th>File size (GQ)</th>
        <th>Operations</th>
      </tr>
      <tr v-for="(file,filename) in files" :key="filename">
        <td>{{file.name}}</td>
        <td>.{{file.type}}</td>
        <td>{{file.size}}GQ</td>
        <td><vui-button :params="{ execfile: file.name }">EXEC</vui-button></td>
      </tr>
    </table>
  </div>
</template>
<script>
export default {
  data() {
    return this.$root.$data.state
  }
}
</script>