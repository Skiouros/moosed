local frame
local game

class Box
    new: (@x, @y, @width, @height) =>

    contains: (x, y) =>
        if @x <= x and x <= (@x + @width) and @y <= y and y <= @height + @y
            return true
        false


old_get_x = love.mouse.getX
old_get_y = love.mouse.getY

push = (x, y) ->
    love.mouse.getX = -> old_get_x! - frame\GetX!
    love.mouse.getY = -> old_get_y! - frame\GetY!
pop = ->
    love.mouse.getX = old_get_x
    love.mouse.getY = old_get_y

load = ->
    Game = require "game"
    game = Game!

    game.running = true
    game.drawing = true

    frame = loveframes.Create "frame"
    frame\SetName "Game"
    frame\ShowCloseButton false
    frame\SetScreenLocked true
    -- frame\SetResizable true

    game.gameBox = Box frame\GetX!, frame\GetY! + 25,
        frame\GetWidth!, frame\GetHeight!

    frame.Update = (obj, dt) ->
        game.gameBox.x = obj\GetX!
        game.gameBox.y = obj\GetY! + 25

        if game.running
            push!
            game\update dt
            pop!

    frame.OnResize = (obj, w, h) ->
        game.gameBox.width = w
        game.gameBox.height = h - 25

    frame.OnMouseEnter = (obj) ->
        game.running = true

    frame.OnMouseExit = (obj) ->
        game.running = false

    frame.OnClose = ->
        game.running = false
        game.drawing = false

    editor.window_manager\set frame, name: "game", x: 0, y:0, width: 100, height: 65
    frame

unload = ->
    frame = nil

draw = ->
    gameBox = game.gameBox
    if game.drawing
        love.graphics.push!

        love.graphics.setScissor gameBox.x, gameBox.y, gameBox.width, gameBox.height
        love.graphics.translate gameBox.x, gameBox.y
        game\draw!
        love.graphics.setScissor!

        love.graphics.pop!

mousepressed = (x, y, button) ->
    if game.gameBox\contains x, y
            game\mousepressed x, y, button

mousereleased = (x, y, button) ->
    if game.gameBox\contains x, y
        game\mousereleased x, y, button

keypressed = (k) ->
    if game.keypressed then game\keypressed k

keyreleased = (k) ->
    if game.keyreleased then game\keyreleased k


name: "game", gui: true, :load, :unload, :draw, :mousepressed, :mousereleased, :keypressed, :keyreleased
