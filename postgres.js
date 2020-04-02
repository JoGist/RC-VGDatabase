const postgres = require('postgres')

const sql = postgres('postgres://postgres:biar@localhost:5432/centraline_rilevamento')

//const columns = ['id', 'nome']

console.log('computing query');

async function query() {
  let promise = new Promise((res, rej) => {
    setTimeout(() => res("Now it's done!"), 1000)
  });

  // wait until the promise returns us a value
  let result = await sql`
  select id, nome from citta
`;

  // "Now it's done!"
  alert(result);
};
query();


/*function query() {
  sql`
  select ${
    sql(columns)
  } from citta
`
console.log(sql);
  return sql;
}


let search = 'Lazio'

const users = await sql`
  select
    id,
    nome,
    regione
  from citta
  where
    name like ${ search + '%' }
`*/

// Is translated into this query:
//select name, age from users