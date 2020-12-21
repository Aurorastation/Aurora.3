module.exports = function (state) {
  return ({
    template: `<div>
      <div class="row" v-for="(r, path) in results" :key="path">
        <h5>{{ path }}</h5>
        <div class="col-6" v-for="(data, theme) in r" :key="theme">
          <img :src="'data:image/png;base64,' + data.image" class="img-fluid"><br/>
          {{ data.errors }}
        </div>
      </div>
      
    </div>`,
    data() {
      return state
    }
  })
}