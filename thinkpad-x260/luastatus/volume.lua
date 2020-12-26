widget = {
    plugin = "pulse",

    opts = {
    },

    cb = function(t)
        local vol = ""
        if not t.mute then
            vol = math.ceil(t.cur / t.norm * 100) .. "%"
        else
            vol = "M"
        end

        return "VOL:" .. vol
    end,

    event = function(t)
    end
}
