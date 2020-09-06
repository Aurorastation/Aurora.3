<template>
  <div>
    <table class="pmon">
      <tr v-for="el in fixedmanifest" :key="el">
        <th v-if="el.header" colspan="3" :class="el.class">{{ el.name }}</th>
        <template v-else>
          <td>{{el.name}}</td>
          <td>{{el.rank}}</td>
          <td>{{el.active}}</td>
        </template>
      </tr>
    </table>
  </div>
</template>


<script>
export default {
  data() {
    return this.$root.$data.state
  },
  computed: {
    fixedmanifest() {
      var entries = Object.entries(this.manifest)
        .filter(([, crew]) => !!crew.length)
        .flatMap(([name, crew]) =>
          [
            {
              header: name,
              class: this.getClass(name),
              name: this.getTitle(name),
            },
            crew,
          ].flat()
        )
      return entries
    },
  },
  methods: {
    getTitle(key) {
      switch (key) {
        case "heads":
          return "Command"
        case "sec":
          return "Security"
        case "eng":
          return "Engineering"
        case "med":
          return "Medical"
        case "sci":
          return "Science"
        case "car":
          return "Cargo"
        case "civ":
          return "Civilian"
        case "misc":
          return "Misc"
        case "bot":
          return "Equipment"
        default:
          return "Unknown"
      }
    },
    getClass(key) {
      switch (key) {
        case "heads":
          return "command"
        default:
          return key
      }
    },
  },
}
</script>

<style lang="scss" scoped>
/* Table Stuffs for manifest*/

table {
  border: 2px solid RoyalBlue;
  width: 100%;
}

table {
  td,
  th {
    border-bottom: 1px dotted black;
    padding: 0px 5px 0px 5px;
    width: auto;
  }
  th {
    font-weight: bold;
    color: #ffffff;
    &.command {
      background: #3333ff;
    }

    &.sec {
      background: #8e0000;
    }

    &.med {
      background: #006600;
    }

    &.eng {
      background: #b27300;
    }

    &.sci {
      background: #a65ba6;
    }

    &.car {
      background: #bb9040;
    }

    &.civ {
      background: #a32800;
    }

    &.misc {
      background: #666666;
    }
  }
}
</style>