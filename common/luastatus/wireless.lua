widget = {
    plugin = "network-linux",
    opts = {
        wireless = true,
        timeout = 5
    },

    cb = function(t)
        local signal_dbm = t.wlp4s0.wireless.signal_dbm

        if signal_dbm then
            signal_dbm = signal_dbm .. "dBm"
        else
            signal_dbm = "DOWN"
        end

        return "WLAN:" .. signal_dbm
    end,

    event = function(t)
    end
}
