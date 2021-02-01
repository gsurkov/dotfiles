local work_min = 30
local break_min = 5

local color_warn = "#c18401"
local color_urgent = "#e45649"

local function sectomin(s)
    return {minutes = math.floor(s / 60), seconds = s % 60}
end

local function timetostr(t)
    return string.format("%02d:%02d", t.minutes, t.seconds)
end

widget = {
    plugin = "timer",
    mode = "stop",
    count = 0
}

function widget:begin_interval(t)
    self.count = t.duration * 60
    self.mode = t.mode
    os.execute(string.format("notify-send 'Pomodoro' '%s'", t.message))
end

function widget:begin_work(min)
    widget:begin_interval({duration = work_min, mode = "work", message = "Begin working!"})
end

function widget:begin_break(min)
    widget:begin_interval({duration = break_min, mode = "break", message = "Take a break!"})
end

function widget:stop()
    widget:begin_interval({duration = 0, mode = "stop", message = "Timer stopped!"})
end

function widget:decrement()
    self.count = self.count - 1
end

function widget.cb()
    local color = nil

    if widget.mode == "stop" then
        color = color_warn

    elseif widget.mode == "work" then
        widget:decrement()

        if widget.count <= 10 then
            color = color_warn
        end

        if widget.count == 0 then
            widget:begin_break()
        end

    elseif widget.mode == "break" then
        widget:decrement()
        color = color_urgent

        if widget.count == 0 then
            widget:begin_work()
        end
    end

    return {full_text = timetostr(sectomin(widget.count)), color = color}
end

function widget.event(arg)
    if arg.button == 1 then
        if widget.mode == "stop" or widget.mode == "break" then
            widget:begin_work()
        elseif widget.mode == "work" then
            widget:begin_break()
        end

    elseif arg.button == 2 then
        if widget.mode ~= "stop" then
            widget:begin_work()
        end

    elseif arg.button == 3 then
        widget:stop()
    end

end
