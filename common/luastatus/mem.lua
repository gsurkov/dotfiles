widget = luastatus.require_plugin('mem-usage-linux').widget{
    timer_opts = {
        period = 2
    },

    cb = function(t)
        local kb_in_gb = 1024 * 1024

        local used_gb = (t.total.value - t.avail.value) / kb_in_gb 
        local total_gb = t.total.value / kb_in_gb

        return string.format("MEM:%.1f/%.1fGi", used_gb, total_gb)
    end,
}
