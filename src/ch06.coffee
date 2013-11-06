_ = require( 'underscore')
# $ = require( 'jquery' )
{ partial, partial1, postDepth, preDepth, visit, deepClone, orify, andify, depthSearch, nexts, unzip, nth, second, constructPair, cycle, mapcat, splat,
  curry3,curry2, curry, always, rev, dispatch, hasKeys, validator,
  checker, defaults, fnull, doWhen, fail, invoker, cat, plucker,
  showObject, complement, average, restrict, as, construct, mapcat,
  interpose, project, rename, finder} = require './util'
{elt, plt, influences, plays, people, person, books, library, zombie} = require './data'
log = console.log
comma = ','

# Recursion
#
# 
log cycle 5, ['11']

log constructPair [1,2], [[],[]]

log _.zip.apply null,
  constructPair ['a',1],
    constructPair ['b',2],
      constructPair ['c',3], [[],[]]

log unzip [['a',1],['b',2],['c',3]]

log nexts influences, 'Self'

log depthSearch influences, ['Lisp'], []

log depthSearch influences, ['Smalltalk'], []

log depthSearch (construct ['Lua', 'Io'], influences), ['Smalltalk'], []

isEven = (n) -> n % 2 is 0
evens = andify _.isNumber, isEven
log evens 2,4,5
log evens 2,6,8

stringOrNumber = orify _.isNumber, _.isString

log stringOrNumber "hi"
log stringOrNumber true, {a:1}
log stringOrNumber true, {a:1}, 1

#
# Codependent functions

evenSteven = (n) ->
  if n is 0
    true
  else
    oddJohn Math.abs(n) - 1

oddJohn = (n) ->
    if n is 0
      false
    else
      evenSteven Math.abs(n) - 1

log "100 is even #{evenSteven 100}"
log "99 is odd: #{oddJohn 99}"
log "4 is odd: #{oddJohn 4}"

# bends minds, but better to use _.flatten
flat = (array) ->
  if _.isArray array
    cat.apply null, (_.map array, flat)
  else
    [array]

log flat [1,[2],[[3,4]]]

# deep clone - (not ready for prime time)
log deepClone {
  a: {
    b: 2
  }
}
log deepClone {
  a: {
    b: {
      c: 55,
      d: 3
    }
  }
}

log deepClone { a: [{b:2}] }
# doesnt work right - coffeescript messes with ctor?

# visit

log visit _.identity, isEven, 36
log visit _.identity, isEven, [2]
log visit _.identity, isEven, [3]
log visit _.identity, isEven, [2,4]
log visit isEven, _.identity, [3, 7, 100, 2]

log postDepth _.identity, influences

log postDepth ((x) ->
  if x is "Lisp" then "LISP" else x)
  , influences

log preDepth ((x) ->
  if x is "Lisp" then "LISP" else x)
  , influences

scale = (k) -> (loss) -> k * loss
transformLoss = (xform, pair) ->
  if _.first pair is 'loss'
    ['loss', xform second pair]
  else
    pair
