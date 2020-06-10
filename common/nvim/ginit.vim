"Neovim-gtk
if exists('g:GtkGuiLoaded')
    set background=light
    colorscheme NeoSolarized

    call rpcnotify(1, 'Gui', 'Option', 'Popupmenu', 0)
endif
