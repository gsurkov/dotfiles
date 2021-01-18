widget = {
    plugin = "timer",
    opts = {
    },

    cb = function()
        return {full_text = os.date("%a %b %d %H:%M")}
    end
}
