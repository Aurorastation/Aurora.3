export default function (state) {
  return {
    template: `
      <div class="row" v-for="(run, runId) in results" :key="runId">
        <h5>{{ run.testFile }}</h5>
        <div class="card col-sm-4" v-for="ss in run.screenshots">
          <img :src="'data:image/png;base64,' + ss.image" class="card-img-top">
          <div class="card-body" v-if="ss.name">
            <h5 class="card-title">{{ ss.name }}</h5>
          </div>
        </div>
        <pre style="white-space: pre-wrap;">
          <div :class="{ 'text-danger': m.type =='Error', 'text-info': m.type == 'Info' }" v-for="m in run.log">{{ m.message }}</div>
        </pre>
      </div>
      
    `,
    data() {
      return state
    },
  }
}
