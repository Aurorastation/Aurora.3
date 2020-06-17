<template>
  <div>
    <vui-group>
      <vui-group-item label="Hard drive:">
        <vui-progress
          :class="{ good: !lowHardDrive, average: lowHardDrive }"
          class="vui-progress"
          :max="s.disk_size"
          :value="s.disk_used"
        >{{ s.disk_used }}GQ / {{ s.disk_size }}GQ</vui-progress>
      </vui-group-item>
    </vui-group>
    <template v-if="s.queue_size">
      <h2>Queue</h2>
      <table class="queue-list">
        <tr>
          <th>Name</th>
          <th>Progress</th>
          <th>Action</th>
        </tr>
        <tr v-for="program in queue" :key="program.filename">
          <td class="name">{{ program.filename }}</td>
          <td>
            <vui-progress
              class="vui-progress"
              :max="program.size"
              :value="program.progress"
            >{{ program.progress }}GQ / {{ program.size }}GQ</vui-progress>
          </td>
          <td class="action">
            <vui-button :params="{ cancel: program.filename }">Cancel</vui-button>
          </td>
        </tr>
      </table>
    </template>
    <h2>Available Programs</h2>
    <vui-input-search
      style="float: right;"
      :input="unrestrictedPrograms"
      v-model="search_results"
      :keys="['name', 'filename', 'desc']"
      autofocus
    />
    <vui-group>
      <template v-for="program in search_results">
        <vui-group-item :key="program.filename" label="Program name:">
          <b>{{ program.name }}</b>
        </vui-group-item>
        <vui-group-item
          :key="program.filename"
          label="File name:"
        >{{ program.filename }} ({{program.size}} GQ)</vui-group-item>
        <vui-group-item :key="program.filename" label="Description:">{{ program.desc }}</vui-group-item>
        <vui-group-item :key="program.filename" label="File controls:">
          <vui-button
            :params="{ download: program.filename }"
            :class="{ danger: !canDownload(program)}"
          >Download</vui-button>
        </vui-group-item>
        <td colspan="2" :key="program.filename">
          <hr>
        </td>
      </template>
    </vui-group>
  </div>
</template>

<script>
export default {
  data() {
    return {
      search_results: [],
      s: this.$root.$data.state,
    }
  },
  computed: {
    unrestrictedPrograms() {
      var entries = Object.entries(this.s.available)
        .filter(
          ([key, value]) =>
            !(key in this.s.installed) && !value.rest && !(key in this.s.queue)
        )
        .sort(([, avalue], [, bvalue]) => avalue.size - bvalue.size)
        .map(([key, value]) => {
          value["filename"] = key
          return value
        })
      return entries
    },
    lowHardDrive() {
      return this.s.disk_used / this.s.disk_size > 0.8 // More than 80%
    },
    queue() {
      return Object.entries(this.s.queue).map(([name, progress]) => {
        let fp = this.s.available[name]
        fp.progress = progress
        fp.filename = name
        return fp
      })
    },
  },
  methods: {
    canDownload(program) {
      if (
        program.size + this.s.queue_size + this.s.disk_used >
        this.s.disk_size
      )
        return false
      return true
    },
  },
}
</script>

<style lang="scss" scoped>
table {
  width: 100%;

  &.queue-list {
    td {
      padding: 0.2em;
      &.name,
      &.action {
        width: 1%;
        white-space: nowrap;
      }
    }
  }
}

.vui-progress {
  width: 100%;
}
</style>>