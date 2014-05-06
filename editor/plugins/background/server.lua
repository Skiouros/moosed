local load_code
do
  local _obj_0 = require("lib.load_code")
  load_code = _obj_0.load_code
end
local copas = require("copas")
local socket = require("socket")
local headers = [[HTTP/1.1 200 OK
Date: Fri, 19 Apr 2002 20:37:57 GMT
Server: Apache/1.3.23 (Darwin) mod_ssl/2.8.7 OpenSSL/0.9.6b
Cache-Control: max-age=60
Expires: Fri, 19 Apr 2002 20:38:57 GMT
Last-Modified: Tue, 16 Apr 2002 02:00:34 GMT
ETag: "3c57e-1e47-3cbb85c2"
Access-Control-Allow-Origin: *
Accept-Ranges: bytes\n
]]
local get_args
get_args = function(s)
  if not (s) then
    return { }
  end
  local argPos = s:find("?")
  if not (argPos) then
    return { }
  end
  local m = s:sub(argPos + 1)
  m = m:match("(.*)%s")
  local args = { }
  local url = require("socket.url")
  for name, arg in m:gmatch("(%w+)=([^&]+)") do
    args[name] = url.unescape(arg)
  end
  return args
end
local buffer = { }
print = function(obj)
  return table.insert(buffer, obj)
end
local WebServer
do
  local _base_0 = {
    register = function(self)
      return copas.addserver(self.server, function(c)
        return self:handle(copas.wrap(c))
      end)
    end,
    respond = function(self, client, msg)
      msg = headers .. "Content-Type: text/json\nContent-Length: " .. tostring(#msg) .. "\n\r\n" .. tostring(msg) .. "\n"
      return client:send(msg)
    end,
    handle = function(self, client)
      local msg = client:receive()
      local args = get_args(msg)
      if args.print then
        while #buffer < 1 do
          copas.sleep(1)
        end
        _ = table.remove(buffer, 1)
        self:respond(client, load_code("print _", true))
        _ = nil
      elseif args.code then
        return self:respond(client, load_code(args.code, true))
      end
    end,
    update = function(self)
      return copas.step(0.1)
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, port, backlog)
      self.port = port
      local err
      self.server, err = socket.bind("*", self.port, backlog)
      assert(self.server)
      if not (self.server) then
        return nil, err
      end
    end,
    __base = _base_0,
    __name = "WebServer"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  WebServer = _class_0
end
local server
local server_timer
local cron = require("lib.cron")
local load
load = function()
  server = WebServer("8085", 5)
  server:register()
  server_timer = cron.every(0.5, (function()
    local _base_0 = server
    local _fn_0 = _base_0.update
    return function(...)
      return _fn_0(_base_0, ...)
    end
  end)())
end
local unload
unload = function()
  server_timer = nil
  server = nil
end
local update
update = function(dt)
  return server_timer:update(dt)
end
return {
  name = "server",
  load = load,
  update = update,
  unload = unload
}
