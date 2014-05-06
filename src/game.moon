console = editor.plugins "console"

class Game
    x: 0
    y: 0
    text: "test"
    image: love.graphics.newImage("res/img/crosshair.png")

    new: =>

    update: (dt) =>
        @x, @y = love.mouse.getX!, love.mouse.getY!

    draw: =>
        w, h = love.window.getWidth!, love.graphics.getHeight!
        love.graphics.setColor 120, 130, 5
        love.graphics.rectangle "fill", 0, 0, w, h

        love.graphics.setColor 255, 255, 255
        love.graphics.print @text, 1, 1
        love.graphics.draw(@image, @x - (@image\getWidth! / 2), @y - (@image\getHeight!))

    keypressed: (k) =>
        console\log k

    keyreleased: (k) =>

    mousepressed: (x, y, button) => @text = "mouse down"

    mousereleased: (x, y, button) => @text = "mouse up"


