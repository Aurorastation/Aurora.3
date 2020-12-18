<template>
  <div>
    <div class="clear-both">
      <vui-img name="character" class="character-image" />
      <p>
        Welcome, <strong>{{ character_name }}</strong
        >.<br />
        Round duration: <strong>{{ round_duration }}</strong
        ><br />
        Alert level:
        <strong :style="{ color: alertLevelColor }">{{ alert_level }}</strong
        ><br />
      </p>
    </div>
    <div class="clear-both">
      <strong v-if="shuttleStatusMessage">{{ shuttleStatusMessage }}</strong
      ><br />
      Choose from the following available positions:
    </div>
    <div v-if="unique_role_available">
      <div class="gs-block">
        <div class="dept">A unique role is available!</div>
        <vui-button :params="{ ghostspawner: 1 }" class="d-block m-1" icon="ghost">Ghost Spawner Menu</vui-button>
      </div>
    </div>
    <div v-else>
      <vui-button :params="{ ghostspawner: 1 }" class="d-block" icon="ghost">Ghost Spawner Menu</vui-button>
    </div>
    <div v-if="jobs_available > 0">
      <div
        v-for="(el, dept) in fixedJobsList"
        :key="dept"
        class="mt-2 dept-block"
        :class="'border-dept-' + dept.toLowerCase()"
      >
        <div class="dept mb-1" :class="'bg-dept-' + dept.toLowerCase()">
          {{ dept }}
        </div>
        <div v-for="job in el" :key="job.title">
          <vui-button :params="{ SelectedJob: job.title }" class="d-block mx-1">
            <span :class="{ 'fw-bold': job.head }">{{ job.title }}</span>
            <span v-if="job.total_positions != 1">
              ({{ job.current_positions }}<span v-if="job.total_positions > 1"> / {{ job.total_positions }}</span
              >)</span
            >
          </vui-button>
        </div>
      </div>
      <span class="fs-small fst-italic"
        >Numbers in brackets show current amount of active players out of all available job slots for that job.</span
      >
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
      return Object.fromEntries(Object.entries(this.jobs_list).filter(([, jobs]) => Object.entries(jobs).length > 0))
    },
    shuttleStatusMessage() {
      switch (this.shuttle_status) {
        case 'post-evac':
          return 'The station has been evacuated.'
        case 'evac':
          return 'The station is currently undergoing evacuation procedures.'
        case 'transfer':
          return 'The station is currently undergoing crew transfer procedures.'
      }
      return null
    },
    alertLevelColor() {
      switch (this.alert_level.toLowerCase()) {
        case 'green':
          return 'inherit'
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
.gs-block,
.dept-block {
  position: relative;
  border: 2px solid;
  .dept {
    text-align: center;
    font-weight: bold;
  }
}
.gs-block {
  $gs-color: #41ff41;
  border-color: $gs-color;
  .dept {
    background-color: $gs-color;
    color: black;
  }
}
</style>
