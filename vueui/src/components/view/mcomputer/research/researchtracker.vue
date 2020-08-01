<template>
  <div>
    <h3>Research Levels:</h3>
    <vui-group>
      <vui-group-item v-for="tech in techs" :key="tech" :label="tech.name" v-if="tech.level > 1 || tech.next_level_progress > 0">
        <p>{{ tech.desc }}</p>
        <vui-progress :value="tech.next_level_progress" :max="tech.next_level_threshold" v-if="tech.level < max_level"> LEVEL {{tech.level}} -- 
          {{ abbreviateNumber(tech.next_level_progress) }} / {{ abbreviateNumber(tech.next_level_threshold) }}
        </vui-progress>
        <p v-else>COMPLETE</p>
      </vui-group-item>
    </vui-group>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  },
  methods: {
    abbreviateNumber(value) {
      let newValue = value;
      const suffixes = ["", "K", "M", "B","T"];
      let suffixNum = 0;
      while (newValue >= 1000) {
        newValue /= 1000;
        suffixNum++;
      }

      newValue = Math.round(newValue);

      newValue += suffixes[suffixNum];
      return newValue;
    }
  }
}
</script>