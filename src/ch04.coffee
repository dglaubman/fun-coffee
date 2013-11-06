_ = require( 'underscore')
# $ = require( 'jquery' )
{hasKeys, validator, checker, defaults, fnull, doWhen, fail, invoker, cat,plucker, showObject, complement, average, restrict, as, construct, mapcat, interpose, project, rename} = require './util'
{person, books, library, zombie} = require './data'
log = console.log
comma = ','

# high order functions
#

finder = (valueOf, bestOf, coll) ->
  _.reduce coll, (best, current) ->
    x = valueOf best
    y = valueOf current
    if x is bestOf x, y
      best
    else
      current

log finder _.identity, Math.max, [100..1]

people = [{name: "Frederick", age: 65}, {name: "Lucy", age: 36}]

log finder (plucker 'age'), Math.max, people
log finder (plucker 'name'),
    (n1,n2) -> if (_.size n1) < (_.size n2) then n1 else n2
  , people

# Graham 1993
best = (fn, coll) ->
  _.reduce coll, (x,y) ->
    if fn(x,y) then x else y

log best ((x,y) -> x > y), [1..10]
log best ((x,y) -> x < y), [1..10]

repeat = (times, val) ->
  _.map [1..times], () -> val


log repeat 3, 'ha'

repeatedly = (times, f) ->
  _.map [1..times], f

log repeatedly 3, () -> 'ha'

log repeatedly 3, () -> Math.floor (Math.random()*10+1)

# -- needs jquery (npm install jquery)
# log repeatedly 3, (n) ->
#   id = 'id' + n
#   $('body').append $('<p>0delay</p>').attr('id', id)
#   id

doUntil = (f, check, init) ->
  ret = []
  result = f init
  while check result
    ret.push result
    result = f result
  ret

lessThan = (limit) -> (i) -> i < limit
times = (factor) -> (x) -> x * factor
log doUntil (times 2), (lessThan 10000), 2

always =  (v) -> () -> v

# Braithwaite 2013
f = always Math.random()
log "Using always repeatedly gives same random nubmer: #{repeatedly 3, f}"

f = Math.random
log "Using random repeatedly gives different random numbers: #{repeatedly 3, f}"

f = always ->
g = always ->
log "f isnt g: #{f() isnt g()}"
log "but f is f: #{f() is f()}"

# always is a combinator
#

plus = (summand) -> (x) -> x + summand
times = (factor) -> (x) -> x * factor
# so is compose
compose = (a,b) -> (c) -> a(b(c))

sumProduct = compose (plus 1), (times 2)
log sumProduct 3

rev = invoker 'reverse', Array.prototype.reverse
log _.map [[1..3]], rev

#
uniqueString = (len) -> Math.random()
  .toString(36)
  .substr(2, len)

log uniqueString 12

uniqueString = (prefix) ->
  [prefix, new Date().getTime()].join ''

log uniqueString 'sam'
log uniqueString 'trupti'

makeUniqueStringFunction = (start) ->
  counter = start
  (prefix) -> [prefix, counter++].join ''

uniqueString = makeUniqueStringFunction 12
log uniqueString 'Sam&Dave'
log uniqueString 'Sam&Dave'
log uniqueString 'Sam&Dave'

# guarding against null

holy = [1..10]
log _.reduce holy, (total, n) -> total * n
holy[3] = null
log _.reduce holy, (total, n) -> total * n

safeMul = fnull ((total, n) -> total * n), 1, 1
log _.reduce holy, safeMul
log safeMul null, undefined

doSomething = (config) ->
  lookup = defaults {critical: 999}
  lookup config, 'critical'

log doSomething { critical: 1000 }
log doSomething {}

alwaysPasses = checker (always true), (always true)
log alwaysPasses {}

fails = (always false)
fails.message = "D'oh"
alwaysFails = checker fails 
log alwaysFails {}

gonnaFail = checker validator 'ZOMG!', always false
log gonnaFail 50

aMap = (obj) ->
  _.isObject obj

checkCmd = checker validator 'must be a map', aMap

log checkCmd {}
log checkCmd 42

log _([1..3])
  .chain()
  .map( (x) -> 2 * x )
  .map( (x) -> x * 3 )
  .value()

log _.chain([1..3])
  .map( (x) -> 2* x )
  .tap( (x) -> log x )
  .map( (x) -> x * 3 )
  .value()

hasSome = hasKeys 'title', 'ed'
log (plucker 1) library
log hasSome (plucker 1) library
checks = checker (validator "must be a map", aMap), (hasKeys 'msg', 'type')
log checks {msg: 'blah', type: 1}
log checks "nope"
log checks {msg: 'huh'}
