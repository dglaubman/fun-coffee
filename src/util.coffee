root = exports ? this
_ = require( 'underscore' )

root.fail = fail = (x) -> throw x

root.existy = existy = (x) -> x?

root.truthy = truthy = (x) -> x? and x

root.doWhen = doWhen = (cond, action) ->
  action() if truthy cond


root.cat = cat = () ->
  head = _.first(arguments)
  if (existy head)
    head.concat.apply head, _.rest( arguments )
  else
    []

root.construct = construct = (h, t) ->
  cat [h], _.toArray t

root.mapcat = mapcat = (f, coll) ->
  cat.apply null, _.map(coll, f)

butlast = (coll) -> _.toArray(coll).slice(0,-1)

root.interpose = interpose = (inter, coll) ->
  butlast  (mapcat ((e) -> construct e, [inter] ),    coll)

root.project = project = (table, keys) ->
  _.map( table, (o) ->
    _.pick.apply( null, construct( o, keys ) )
  )

root.rename = rename = (obj, names) ->
  _.reduce( names, (acc, nu, old) ->
      acc[nu] = obj[old] if _.has( obj, old )
      acc
  , _.omit.apply( null, construct( obj, _.keys names )))

root.as = as = (table, names) ->
  _.map table, (row) ->
    rename row, names

root.restrict = restrict = (table, pred) ->
  _.reduce( table, (t, row) ->
      if pred row
        t
      else
        _.without t, row
    , table )

root.mapcat = mapcat = (fun, coll) ->
  cat.apply null, _.map(coll, fun)

root.average = average = (array) ->
  sum = _.reduce array, (a,b) -> a + b
  sum / _.size array

root.complement = complement =
  (pred) -> () -> not pred.apply null, _.toArray arguments

root.showObject = showObject = (o) -> o

root.plucker = plucker = (field) -> (obj) ->
  return false unless obj
  obj[field]


root.invoker = invoker = (name, method) ->
  (target) ->
    if not target then fail( "must provide a target" )
    targetMethod = target[name]
    args = _.rest arguments
    doWhen (targetMethod and (method is targetMethod)), ->
      targetMethod.apply target, args

root.fnull = fnull = (f) ->
  defaults = _.rest arguments
  ->
    args = _.map arguments, (e,i) ->
      if existy e then e else defaults[i]
    f.apply null, args

root.defaults = defaults = (d) ->
  (o, k) ->
    val = fnull _.identity, d[k]
    o and val( o[k] )

root.checker = checker = ->
  validators = _.toArray arguments
  (obj) ->
    _.reduce validators, (errs, check) ->
      if check obj
        errs
      else
        _.chain(errs)
          .push(check.message)
          .value()
    , []

root.validator = validator = (message, fn) ->
  f = ->
    fn.apply fn, arguments
  f['message'] = message
  f

root.hasKeys = hasKeys = ->
  keys = _.toArray arguments
  fun = (obj) ->
    _.every keys, (k) ->
      _.has obj, k

  fun.message = cat( [ 'Must have values for keys:'], keys).join ' '
  fun

root.finder = finder = (valueOf, bestOf, coll) ->
  _.reduce coll, (best, current) ->
    x = valueOf best
    y = valueOf current
    if x is bestOf x, y
      best
    else
      current

root.dispatch = dispatch = (funs...) ->
  (target, args...) ->
    for fun in funs
      ret = fun.apply fun, (construct target, args)
      return ret if existy ret
    ret

root.always = always = (v) -> () -> v

stringReverse = (s) ->
  if not _.isString s
    return undefined
  s.split( '' ).reverse().join ''

root.rev = rev = dispatch(
  (invoker 'reverse', Array.prototype.reverse)
  , stringReverse
  , (x) -> throw "Don't know how to reverse #{x}."
)

root.curry = curry = (f) ->
  (arg) ->
    f arg

root.curry2 = curry2 = (f) ->
  (arg2) ->
    (arg1) -> f arg1, arg2

root.curry3 = curry3 = (f) ->
  (arg3) ->
    (arg2) ->
      (arg1) -> f arg1, arg2, arg3

root.splat = splat = (f) ->
  (array) ->
    f.apply null, array

root.cycle = cycle = (times, array) ->
  if times <= 0
    array
  else
    cat array, cycle( times - 1, array)
root.isIndexed = isIndexed = (data) ->
  _.isArray data or  _.isString data

root.nth = nth = (a, index) ->
  if not _.isNumber(index)
    fail "Expected a number as the index"
  if not isIndexed(a)
    fail "Not supported on non-indexed type"
  if (index < 0) or (index > a.length - 1)
    fail "Index value is out of bounds"

  return a[index];

root.second = second = (a) ->
  return nth(a, 1)


root.constructPair = constructPair = (pair, rest) ->
  [ construct( (_.first pair),  (_.first rest) ),
    construct( (second pair), (second rest) ) ]

root.unzip = unzip = (pairs) ->
  if _.isEmpty pairs
    [[],[]]
  else
    constructPair (_.first pairs), (unzip _.rest pairs)   

root.nexts = nexts = (graph, node) ->
  if _.isEmpty graph then return []

  first = _.first graph
  rest = _.rest graph
  from = _.first first
  to = second first

  if _.isEqual node, from
    construct to, (nexts rest, node)
  else
    nexts rest, node

root.depthSearch = depthSearch = (graph, nodes, seen) ->
  if _.isEmpty nodes
    return rev seen

  node = _.first nodes
  rest = _.rest nodes

  if _.contains seen, node
    depthSearch graph, rest, seen
  else
    depthSearch( 
      graph
      , (cat (nexts graph, node), rest)
      , (construct node, seen)
    )

root.andify = andify = (preds...) ->
  (args...) ->
    everything = (ps, truth) ->
      if _.isEmpty ps then truth
      else
        (_.every args, _.first ps) and
        (everything (_.rest ps), truth)
    everything preds, true

root.orify = orify = (preds...) ->
  (args...) ->
    anything = (ps, truth) ->
      if _.isEmpty ps then truth
      else
        (_.any args, _.first ps) or
        (anything (_.rest ps), truth)
    anything preds, false

root.deepClone = deepClone = (obj) ->
  if not existy(obj) or not _.isObject( obj)
    obj

  temp = new obj.constructor()
  for own key of obj
    temp[key] = deepClone obj[key]
  temp

root.visit = visit = (mapF, resultF, array) ->
    if _.isArray array
      resultF (_.map array, mapF)
    else
      resultF array 

root.partial1 = partial1 = (f, arg1) ->
  (rest...) ->
    args = construct arg1, rest
    f.apply f, args

root.partial = partial = (f, args1...) ->
  log args1
  (args2...) ->
    log args2
    f.apply f, (cat args1, args2)

root.postDepth = postDepth = (f, array) ->
  visit (partial1 postDepth, f), f, array

root.preDepth = preDepth = (f, array) ->
  visit (partial1 preDepth, f), f, f(array)
