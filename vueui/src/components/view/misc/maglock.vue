<template>
  <div>
    <input v-model="passcode" placeholder="Enter passcode..." autofocus>
    <vui-button :params="{ passcode: passcode }">Submit</vui-button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      passcode: ""
    }
  }
}
</script>

