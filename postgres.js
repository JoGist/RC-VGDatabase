const postgres = require('postgres')

const sql = postgres('postgres://postgres:biar@localhost:5432/centraline_rilevamento')

function wait() {
  return new Promise(resolve => {
    setTimeout(() => {
      resolve('resolved');
    }, 1000);
  });
}

async function query() {
  console.log('computing query');
  const result = await sql` 
    select * from citta`;
    await wait();
  console.log(result);
}
query();
