widget = {
    plugin = "network-linux",
    opts = {
        wireless = true,
        timeout = 5
    },

    cb = function(t)
        local signal_dbm

        for k, v in pairs(t) do
            if string.find(k, "wlp") then
                signal_dbm = v.wireless.signal_dbm
                break
            end
        end

        if signal_dbm then
            signal_dbm = signal_dbm .. "dBm"
        else
            signal_dbm = "DOWN"
        end

        return {full_text = "WLAN:" .. signal_dbm}
    end,

    event = function(t)
    end
}
