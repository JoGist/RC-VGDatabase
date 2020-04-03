//https://www.npmjs.com/package/postgres

const postgres = require('postgres')

const sql = postgres('postgres://postgres:biar@localhost:5432/centraline_rilevamento')

var query = async function () {
  console.log('computing query');
  const result = await sql` 
    select * from citta`;
  console.log('query eseguita');
  console.log(result);
  console.log('query stampata');
  console.log('sono qui');
}
query();