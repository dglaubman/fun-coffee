_ = require( 'underscore')
# $ = require( 'jquery' )
{splat,curry3,curry2, curry, always, rev, dispatch, hasKeys, validator, checker, defaults, fnull, doWhen, fail, invoker, cat,plucker, showObject, complement, average, restrict, as, construct, mapcat, interpose, project, rename, finder} = require './util'
{plays, people, person, books, library, zombie} = require './data'
log = console.log
comma = ','

# Function building functions
#
str = dispatch(
  (invoker 'toString', Array.prototype.toString)
  (invoker 'toString', String.prototype.toString)
)
log str 'a'
log str [1.. 10]

log rev [1..3]
log rev 'abc'
try
  log rev 42
catch e 
# curry
#
rightCurryDiv = (denom) ->
    (num) -> num/denom

leftCurryDiv = (num) ->
  (denom) ->
    num/denom

log "5 / 10 = #{(leftCurryDiv 5) 10}"
log "10 / 5 = #{(rightCurryDiv 5) 10}"


DivBy10 = curry (n) -> n / 10

log DivBy10 5

cParseInt = curry parseInt
log _.map ['11','11','11','11'], cParseInt

div = (n,d) -> n/d
div10 = (curry2 div) 10
log div10 50

parseBinary = (curry2 parseInt) 2

log parseBinary '1101'

log _.countBy plays, (song) ->
  [song.artist, song.track].join ' - '

songToArtist = (song) -> song.artist
log _.countBy plays, songToArtist

songsByArtist = (curry2 _.countBy) songToArtist
log songsByArtist plays

songToString = (song) -> "#{song.artist} - #{song.track}"
songsPlayed = curry3(_.uniq)(false)(songToString)
log songsPlayed plays
log _.uniq(plays, false, songToString)

# Hues

toHex = (n) ->
  hex = n.toString 16
  if hex.length < 2 then "0#{hex}" else hex

log toHex 255

rgbToHex = (r, g, b) ->
  "##{toHex r}#{toHex g}#{toHex b}"

log rgbToHex 255, 128, 63

blueGreenish = curry3(rgbToHex)(255)(200)
log blueGreenish 108

greaterThan = curry2 (lhs, rhs) ->
  lhs > rhs

lessThan = curry2 (lhs, rhs) ->
  lhs < rhs

withinRange = checker(
  (validator 'arg not > 10', greaterThan 10),
  (validator 'arg not < 20', lessThan 20)
)

log withinRange 15
log withinRange 10
log withinRange 's'

# partial application (bind in modern js)

divPart = (n) ->
  (d) ->
    n / d  

over10Part = divPart 10
log over10Part 2

partial1 = (f, arg1) ->
  (rest...) ->
    args = construct arg1, rest
    f.apply f, args


under10Part1 = partial1 div, 10
log under10Part1 5

partial = (f, args1...) ->
  log args1
  (args2...) ->
    log args2
    f.apply f, (cat args1, args2)

log partial parseInt, '111'
partial parseInt, '111'
threeones = partial parseInt, '111'
log threeones 2

aMap = (obj) ->
  _.isObject obj

log validator( 'arg must be a map', aMap) 

# stitching with compose
#
# composedmapcat
add2 = (x, y) -> [y,x]
log  add2.call null, 36, 58 
add2 = (x, y) ->   x + y

log (splat add2) [2, 3]
composedmapcat = _.compose(splat(cat),_.map)
log composedmapcat [[1,2],[3,4],[4]], _.identity
