<template>
  <div>
    <div class="clear-both">
      <vui-img name="character" class="character-image"></vui-img>
      <p>
        Welcome, <strong>{{ character_name }}</strong>.<br>
        Round duration: <strong>{{ round_duration }}</strong><br>
        Alert level: <strong class="alert-level" :class="alertLevelClass">{{ alert_level }}</strong><br>
      </p>
    </div>
    <div class="clear-both">
      <strong v-if="shuttle_status" class="warning">{{ shuttleStatusMessage }}</strong>
      Choose from the following available positions:
    </div>
    <div v-if="unique_role_available">
        <vui-button :params="{ ghostspawner: 1 }" style="color: #ffffaa" icon="ghost">Ghost Spawner Menu</vui-button>
    </div>
    <div v-if="jobs_available > 0">
      <div v-for="(el, dept) in fixedJobsList" :key="dept" class="mt-2 dept-block">
        <div class="dept mb-1" :class="'bg-dept-' + dept.toLowerCase()">
          {{ dept }}
        </div>
        <div v-for="job in el" :key="job.title">
          <vui-button :params="{ SelectedJob: job.title }" :class="{ deptHead: job.head}">
            {{ job.title }} <span v-if="job.total_positions != 1">({{ job.current_positions }}<span v-if="job.total_positions > 1"> / {{ job.total_positions }}</span>)</span>
          </vui-button>
        </div>
      </div>
      <span class="fs-small fst-italic">Numbers in brackets show current amount of active players out of all available job slots for that job.</span>
    </div>
    <div v-else class="fst-italic">
      No jobs available.
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  },
  computed: {
    fixedJobsList() {
      return Object.fromEntries(Object.entries(this.jobs_list).filter(([dept, jobs]) => Object.entries(jobs).length > 0))
    },
    shuttleStatusMessage() {
      switch(this.shuttle_status) {
        case 'post-evac':
          return 'The station has been evacuated.'
        case 'evac':
          return 'The station is currently undergoing evacuation procedures.'
        case 'transfer':
          return 'The station is currently undergoing crew transfer procedures.'
      }
      return null
    },
    alertLevelClass() {
      switch(this.alert_level) {
        case 'Green':
          return ''
        case 'blue':
          return 'blue'
        case 'yellow':
          return 'yellow'
      }
      return 'red'
    },
  },
}
</script>

<style lang="scss" scoped>
.character-image {
  float: left;
  height: 64px;
}
.dept-block {
  position: relative;
  .dept {
    text-align: center;
    font-weight: bold;
  }
  .dept-head {
    font-weight: bold;
  }
}
.button {
  display: block;
}
</style>
