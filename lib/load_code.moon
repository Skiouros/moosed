import insert from table
json = require "lib.dkjson"

raw_tostring = (o) ->
  if meta = type(o) == "table" and getmetatable o
    setmetatable o, nil
    with tostring o
      setmetatable o, meta
  else
    tostring o

encode_value = (val, seen={}, depth=0) ->
  depth += 1
  t = type val
  switch t
    when "table"
      if seen[val]
        return { "recursion", raw_tostring(val) }

      seen[val] = true

      tuples = for k,v in pairs val
        { encode_value(k, seen, depth), encode_value(v, seen, depth) }

      if meta = getmetatable val
        insert tuples, {
          { "metatable", "metatable" }
          encode_value meta, seen, depth
        }

      { t, tuples }
    else
      { t, raw_tostring val }

run = (self, fn using nil) ->
  lines = {}
  queries = {}

  scope = setmetatable {
    :self
    print: (...) ->
      count = select "#", ...
      insert lines, [ encode_value (select i, ...) for i=1,count]
  }, __index: _G

  setfenv fn, scope
  ret = { pcall fn }
  return unpack ret, 1, 2 unless ret[1]

  lines, queries

has_moonscript, ms = pcall -> return require "moonscript"

load_code = (code, moonscript) ->
    local fn, err
    if moonscript and has_moonscript
        fn, err = ms.loadstring code
    else
        fn, err = loadstring code

    if err
      json.encode { error: err }
    else
      lines, queries = run @, fn
      if lines
        json.encode { :lines, :queries }
      else
        json.encode { error: queries }

{ :run, :load_code }
