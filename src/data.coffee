root = exports ? this

root.people = [{name: "Frederick", age: 65}, {name: "Lucy", age: 36}]
root.zombie = { name: "Bob", film: "Day of Bob" }
root.books = [
    title: "Mister Monday"
    author: "Nix"
  ,
    title: "Grim Tuesday"
    author: "Nix"
  ,
    title: "Drowned Wdnesday"
  ]

root.person = {
  name: "Romy",
  token: '234897',
  password: "secret"
}


root.library = [
    { title: "SICP", isbn: "0262010771", ed: 1 }
    { title: "SICP", isbn: "0262510871", ed: 2 }
    { title: "Joy of Clojure", isbn: "1935182641", ed: 1 }
  ]

root.plays = [
  {artist: "Burial", track: "Archangel"},
  {artist: "Ben Frost", track: "Stomp"},
  {artist: "Ben Frost", track: "Stomp"},
  {artist: "Burial", track: "Archangel"},
  {artist: "Emeralds", track: "Snores"},
  {artist: "Burial", track: "Archangel"},
  {artist:"Joni Mitchell", track: "Blue"},
  {artist:"Joni Mitchell", track: "Blonde in the Bleachers"}
]


root.influences = [
  ['Lisp', 'Smalltalk'],
  ['Lisp', 'Scheme'],
  ['Smalltalk', 'Self'],
  ['Scheme', 'JavaScript'],
  ['Scheme', 'Lua'],
  ['Self', 'Lua'],
  ['Self', 'JavaScript']
]

root.elt = [
  ['event', 101],
  ['loss', 1000.0]
]
