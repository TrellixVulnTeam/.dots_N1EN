# Dotfiles
## Increase sudo timeout and use single sudo cache across all ttys

``` bash
# Defaults:<username> !tty_tickets, timestamp_timeout=480
visudo -f /etc/sudoers.d/mysudoconf 
```

## Gnome terminal

``` sh
dconf dump /org/gnome/terminal/ > gnome_terminal_settings_backup.txt
dconf reset -f /org/gnome/terminal/
dconf load /org/gnome/terminal/ < gnome_terminal_settings_backup.txt
```
