class WindowManager
    frames: {}
    frames_by_name: {}

    set_frame: (frame) =>
        info = @frames[frame]

        x = (info.x * (0.01)) * love.window.getWidth!
        y = (info.y * (0.01)) * love.window.getHeight!

        width = (info.width * (0.01 / 1)) * love.window.getWidth!
        height = (info.height * (0.01 / 1)) * love.window.getHeight!

        frame\SetX x
        frame\SetY y
        frame\SetWidth width
        frame\SetHeight height

        if frame.OnResize
            frame\OnResize width, height


    set: (frame, info) =>
        @frames[frame] = info
        @frames_by_name[info.name] = frame

        @set_frame frame

    remove: (name) =>
        frame = @frames_by_name[name]
        if frame.OnClose
                frame\OnClose!
        frame\Remove!

        @frames_by_name[name] = nil
        @frames[frame] = nil

    update: =>

    clear: =>
        for name in *@frames_by_name
            @remove name

    onresize: (w, h) =>
        for frame in pairs @frames
            @set_frame frame
            frame\SetMaxWidth love.window.getWidth!
            frame\SetMaxHeight love.window.getHeight!

