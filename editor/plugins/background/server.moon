import load_code from require "lib.load_code"

copas = require "copas"
socket = require "socket"

headers = [[HTTP/1.1 200 OK
Date: Fri, 19 Apr 2002 20:37:57 GMT
Server: Apache/1.3.23 (Darwin) mod_ssl/2.8.7 OpenSSL/0.9.6b
Cache-Control: max-age=60
Expires: Fri, 19 Apr 2002 20:38:57 GMT
Last-Modified: Tue, 16 Apr 2002 02:00:34 GMT
ETag: "3c57e-1e47-3cbb85c2"
Access-Control-Allow-Origin: *
Accept-Ranges: bytes\n
]]

get_args = (s) ->
    return {} unless s
    argPos = s\find "?"
    return {} unless argPos
    m = s\sub argPos + 1

    m = m\match "(.*)%s"

    args = {}
    url = require "socket.url"

    for name, arg in m\gmatch "(%w+)=([^&]+)"
        args[name] = url.unescape arg

    args

buffer = {}
export print = (obj) ->
    table.insert buffer, obj

class WebServer

    register: () =>
        copas.addserver @server, (c) ->
            @handle copas.wrap c

    new: (@port, backlog) =>
        @server, err = socket.bind "*", @port, backlog
        assert @server
        return nil, err unless @server


    respond: (client, msg) =>
        msg = headers .. "Content-Type: text/json
Content-Length: #{#msg}\n\r\n#{msg}
"

        client\send msg

    handle: (client) =>
        msg = client\receive!
        args = get_args(msg)

        if args.print
            while #buffer < 1
                copas.sleep 1
            export _ = table.remove buffer, 1
            @respond client, load_code "print _", true
            _ = nil
        elseif args.code
            @respond client, load_code args.code, true

    update: =>
        copas.step 0.1

local server
local server_timer

cron = require "lib.cron"

load = ->
    server = WebServer "8085", 5
    server\register!

    server_timer = cron.every 0.5, server\update

unload = ->
    server_timer = nil
    server = nil

update = (dt) ->
    server_timer\update dt

name: "server", :load, :update, :unload
