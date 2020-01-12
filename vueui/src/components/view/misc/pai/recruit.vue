<template>
  <div>
    <p>Please configure your pAI personality's options. Remember, what you enter here could determine whether or not the user requesting a personality chooses you!</p>


    <vui-group>
      <vui-group-item label="Name:">
        <input type="text" v-model="name">
        <p>
          What you plan to call yourself. Suggestions: Any character name you would choose for a station character OR an AI.
        </p>
      </vui-group-item>
      <vui-group-item label="Description:">
        <textarea v-model="description"/>
        <p>
          What sort of pAI you typically play; your mannerisms, your quirks, etc. This can be as sparse or as detailed as you like.
        </p>
      </vui-group-item>
      <vui-group-item label="Preferred Role:">
        <input type="text" v-model="role">
        <p>
          Do you like to partner with sneaky social ninjas? Like to help security hunt down thugs? Enjoy watching an engineer's back while he saves the station yet again? This doesn't have to be limited to just station jobs. Pretty much any general descriptor for what you'd like to be doing works here.
        </p>
      </vui-group-item>
      <vui-group-item label="OOC Comments:">
        <textarea v-model="comments"/>
        Anything you'd like to address specifically to the player reading this in an OOC manner. "I prefer more serious RP.", "I'm still learning the interface!", etc. Feel free to leave this blank if you want.
      </vui-group-item>
    </vui-group>
    <vui-button :disabled="!canSubmit" :params="{submit_candidate: {name: name, description: description, role: role, comments: comments}}">Submit Personality</vui-button>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  },
  computed: {
    canSubmit() {
      return String(this.name).length > 0
    }
  }
}
</script>


<style lang="scss" scoped>
input, textarea {
  width: 100%;
  vertical-align: top;
}

textarea {
  height: 3em;
}
</style>