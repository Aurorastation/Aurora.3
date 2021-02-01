# VueUI report generator
This program is used to make reports for VueUI. Reports include varius checks.
## How to add a check stage
Stages are sequential, they run one after each other. To add stage copy `00_null` stage and modify it's code. And finally add appropriate require to `stages/index.js`. 
## How to use
1. Get Node.js 10.0.0 or newer.
0. Run `npm install`
0. Run `node .`
0. Wait for all stages to finish
0. Look at `report.htm` in same directory.
## How to add more UI tests to Puppeteer report?
Create a json file somewhere under `/vueui/tests` folder with containing following object
```JSON
{
    "size": [100, 100],
    "data": ...
}
```
`size` specifies width and height of UI while data determines root UI data to be used. It is same data that is shown in debug section of VueUI.