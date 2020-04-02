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
  console.log('calling');
  const result = await sql` //await wait();
  select * from citta
`;
  console.log(result);
}
query();
