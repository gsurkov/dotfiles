widget = {
    plugin = "network-linux",
    opts = {
        ethernet = true,
    },

    cb = function(t)
        local mbit_s = t.eno1.ethernet.speed
        return {full_text = "ETH:" .. math.floor(mbit_s) .. "M"}
    end,

    event = function(t)
    end
}
