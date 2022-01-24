module.exports = function (states, stages) {
  var components = stages.map((stage, i) => ({i, n: stage.name(), c: stage.component(states[i])}))
  return ({
    template: `<!doctype html>
  <html lang="en">
    <head>
      <!-- Required meta tags -->
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
  
      <!-- Bootstrap CSS -->
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-giJF6kkoqNQ00vy+HMDP7azOuL0xtbfIcaT9wjKHr8RbDVddVHyTfAAsrekwKmP1" crossorigin="anonymous">
      <style>
        .error-info {
          white-space: normal;
          color: darkred;
        }
      </style>
      <title>VueUI report</title>
    </head>
    <body>
      <div class="container">
        <h1>VueUi Report</h1>
        <div v-for="stage in stages" :key="stage.i">
          <h2>{{ stage.n }}</h2>
          <component v-bind:is="stage.c"></component>
        </div>
      </div>
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/js/bootstrap.bundle.min.js" integrity="sha384-ygbV9kiqUc6oa4msXn9868pTtWMgiQaeYH7/t7LECLbyPA2x65Kgf80OJFdroafW" crossorigin="anonymous"></script>
    </body>
  </html>`,
    data() {
      return {
        stages: components
      }
    }
  })
}