/**
  {
    "api": 1,
    "name": "Number Commas",
    "description": "Add commas to a number",
    "author": "noriah",
    "icon": "counter",
    "tags": "transform"
  }
 **/

function main(input) {
  input.text = input.text.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
