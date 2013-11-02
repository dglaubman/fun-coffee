_ = require( 'underscore')
{restrict, as, construct, mapcat, interpose, project, rename} = require('./util')

log = console.log
comma = ','
x = construct 1, [comma]
log x
log mapcat(
  (e) -> construct(e,[comma]),
  [1,2,3] )
log interpose( comma, [1,2,3] )

zombie = { name: "Bob", film: "Day of Bob" }

log _.keys( zombie )
log _.values( zombie )
log _.pluck( [zombie], "name" )

log zombie
log _.pairs( zombie )
log _.object(_.pairs(zombie))

log _.object(_.map(_.pairs(zombie), (x) -> [x[0].toUpperCase(), x[1]]))
log _.invert(_.object(_.pairs(zombie)))

books = [
    title: "Mister Monday"
    author: "Nix"
  ,
    title: "Grim Tuesday"
    author: "Nix"
  ,
    title: "Drowned Wdnesday"
  ]


person = {
  name: "Romy",
  token: '234897',
  password: "secret"
}

x = _.pluck(
    _.map(books, (o) ->
      _.defaults o, {author: "unknown"}),
  'author')

log x

log _.omit person, 'token', 'password'

creds = _.pick person, 'token', 'password'
log creds

log _.where books, { author: "Nix" }
log _.findWhere books, { author: "Nix" }

log project books, ["title"]

log construct( {title: "Grim Wednesday"}, ["title"])

library = [
    { title: "SICP", isbn: "0262010771", ed: 1 }
    { title: "SICP", isbn: "0262510871", ed: 2 }
    { title: "Joy of Clojure", isbn: "1935182641", ed: 1 }
  ]

isbnResults = project library, ['isbn']
log isbnResults

log rename { a: 1, b: 2}, { 'a': 'x' }

log as library, { 'ed': 'Edition', 'isbn': 'ISBN', title: 'Title' }
log project (as library, { 'ed': 'Edition', 'isbn': 'ISBN', title: 'Title' }), ['ISBN']

log restrict( library, (book) -> book.ed is 1 )