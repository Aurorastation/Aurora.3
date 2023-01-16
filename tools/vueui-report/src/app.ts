import { Stage } from './stages/stage'

export default function (states, stages: Stage[]) {
  const components = Object.fromEntries(stages.map((s, i) => [`stage-${i}`, s.component(states[i])]))
  const componentNames = Object.fromEntries(stages.map((s, i) => [`stage-${i}`, s.name()]))
  // const components = stages.map((stage, i) => ({ i, n: stage.name(), c: stage.component(states[i]) }))
  return {
    components,
    template: `<html lang="en">
    <head>
      <!-- Required meta tags -->
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
  
      <!-- Bootstrap CSS -->
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
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
        <div v-for="(name, cid) in stages" :key="cid">
          <h2>{{ name }}</h2>
          <component :is="cid"></component>
        </div>
      </div>
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    </body>
  </html>`,
    data() {
      return {
        stages: componentNames,
      }
    },
  }
}
