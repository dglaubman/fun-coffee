_ = require( 'underscore')
{cat,plucker, showObject, complement, average, restrict, as, construct, mapcat, interpose, project, rename} = require('./util')

log = console.log
comma = ','

exports.globalThis = -> this

log exports.globalThis.call "barnabas"
log exports.globalThis.call  "barnabas", ""
log exports.globalThis.apply "barnabas", []

f = () -> this
log f.call '!'
f = _.bind f, '?'
log f.call '!'

target = {
  name: 'ok'
  aux: -> @name
  act: -> @aux()
  }

_.bindAll( target, 'aux', 'act' )
log target.act.call 'wat'

t2 =  -> {
  name: 'better'
  aux: => @name
  act: => @aux()
  }
# ??
# log t2().act.call 'wat'
#

# Closures
watLocal = () ->
  captured = 'wat'
  "local was #{captured}"

report =  watLocal
log report()

createScaleFunction = (FACTOR) ->
  (v) ->
    _.map( v, (n) -> n * FACTOR )

times10 = createScaleFunction 10
log times10 [1,2,3]

log times10 { a: 1, b: 2, c: 3 }

createWeirdScaleFunction = (FACTOR) ->
  (v) ->
    @['FACTOR'] = FACTOR
    captures = @
    _.map( v, _.bind((n) -> n * FACTOR ), captures )

times10 = createWeirdScaleFunction 10
log times10 { a: 1, b: 2, c: 3 }

makeAdder = (CAPTURED) -> (free) -> free + CAPTURED
add20 = makeAdder 20
log "20 + 10 = #{add20 10}"
add1024 = makeAdder 1024
log "1024 + 10 = #{add1024 10}"

log "average of [2,4,5] is #{average [2,4,5]}"

averageDamp = (FN) -> (n) -> average [n, FN n]
dampedCube = averageDamp (n) -> n*n*n
x = 3
log "average of #{x} and #{x}^3 is #{dampedCube x}"
x = 5
log "average of #{x} and #{x}^3 is #{dampedCube x}"

#
# Shadowing

captureShadow = (SHADOWED) -> (SHADOWED) -> SHADOWED + 1
cot37 = captureShadow 37
log cot37 99

#
# Using Closures


isEven = (x) -> x % 2 is 0
_.map [2,4,100, 99], (x) -> log "#{x} is even: #{isEven x}\n"
isOdd = complement isEven
_.map [2,4,100, 99], (x) -> log "#{x} is odd: #{isOdd x}\n"

isEven = -> false
_.map [2,4,100, 99], (x) -> log "with new isEven #{x} is even: #{isEven x}\n"

_.map [2,4,100, 99], (x) -> log "#{x} is still odd: #{isOdd x}\n"

c42 = showObject {c: 42}
log c42

c42.x = 9
log c42
c42.c = 43
log c42

pingpong = () ->
  PRIVATE = 0
  {
    inc: (n) -> PRIVATE += n
    dec: (n) -> PRIVATE -= n
  }
a =  pingpong()
log a.inc 10
b = pingpong()
log b.dec 5
log a.inc 0

library = [
    { title: "SICP", isbn: "0262010771", ed: 1 }
    { title: "SICP", isbn: "0262510871", ed: 2 }
    { title: "Joy of Clojure", isbn: "1935182641", ed: 1 }
  ]

getISBN = plucker 'isbn'
_.map library, (book) -> log getISBN book

getTitle = plucker 'title'
_.map library, (book) -> log getTitle book
third = plucker 2
log third library
log (plucker 1) library
wat = cat [{wat: "?"}], library
log wat
log _.filter wat, getTitle