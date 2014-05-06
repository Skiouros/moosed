json = require "lib.dkjson"
cron = require "lib.cron"

class SpriteSheet
    new: (json_file) =>
        info = love.filesystem.read json_file
        info = json.decode info
        @img = love.graphics.newImage "res/img/" .. info.meta.image
        @img\setFilter "nearest", "nearest"

        width, height = info.meta.size.w, info.meta.size.h
        @frames = {}
        for frame, info in pairs info.frames
            { :x, :y, :w, :h } = info.frame
            quad = love.graphics.newQuad x, y, w, h, width, height
            table.insert @frames, quad

        @current_frame = #@frames
        @timer = cron.every 0.2, ->
            @current_frame -= 1
            if @current_frame < 1
                @current_frame = #@frames

    draw: (x, y) =>
        love.graphics.draw @img, @frames[@current_frame], x, y, 0, 2, 2

    update: (dt) =>
        @timer\update dt

{ :SpriteSheet}
