#!/bin/sh
# Helium Dark

# source for these helper functions:
# https://github.com/chriskempson/base16-shell/blob/master/templates/default.mustache
if [ -n "$TMUX" ]; then
  # Tell tmux to pass the escape sequences through
  # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
  put_template() { printf '\033Ptmux;\033\033]4;%d;rgb:%s\033\033\\\033\\' $@; }
  put_template_var() { printf '\033Ptmux;\033\033]%d;rgb:%s\033\033\\\033\\' $@; }
  put_template_custom() { printf '\033Ptmux;\033\033]%s%s\033\033\\\033\\' $@; }
elif [ "${TERM%%[-.]*}" = "screen" ]; then
  # GNU screen (screen, screen-256color, screen-256color-bce)
  put_template() { printf '\033P\033]4;%d;rgb:%s\007\033\\' $@; }
  put_template_var() { printf '\033P\033]%d;rgb:%s\007\033\\' $@; }
  put_template_custom() { printf '\033P\033]%s%s\007\033\\' $@; }
elif [ "${TERM%%-*}" = "linux" ]; then
  put_template() { [ $1 -lt 16 ] && printf "\e]P%x%s" $1 $(echo $2 | sed 's/\///g'); }
  put_template_var() { true; }
  put_template_custom() { true; }
else
  put_template() { printf '\033]4;%d;rgb:%s\033\\' $@; }
  put_template_var() { printf '\033]%d;rgb:%s\033\\' $@; }
  put_template_custom() { printf '\033]%s%s\033\\' $@; }
fi

# 16 color space
put_template 0  "0d/38/44"
put_template 1  "ef/4c/47"
put_template 2  "60/a3/19"
put_template 3  "b0/88/00"
put_template 4  "3f/8e/ef"
put_template 5  "d5/5a/a4"
put_template 6  "00/a4/97"
put_template 7  "98/a7/a8"
put_template 8  "67/75/75"
put_template 9  "ff/5b/54"
put_template 10 "6e/b1/2e"
put_template 11 "be/96/00"
put_template 12 "4d/9c/ff"
put_template 13 "e4/68/b1"
put_template 14 "20/b2/a4"
put_template 15 "b4/c3/c4"

color_foreground="98/a7/a8"
color_background="00/2d/38"

if [ -n "$ITERM_SESSION_ID" ]; then
  # iTerm2 proprietary escape codes
  put_template_custom Pg "98a7a8"
  put_template_custom Ph "002d38"
  put_template_custom Pi "98a7a8"
  put_template_custom Pj "0d3844"
  put_template_custom Pk "20b2a4"
  put_template_custom Pl "98a7a8"
  put_template_custom Pm "002d38"
else
  put_template_var 10 $color_foreground
  put_template_var 11 $color_background
  if [ "${TERM%%-*}" = "rxvt" ]; then
    put_template_var 708 $color_background # internal border (rxvt)
  fi
  put_template_custom 12 ";7" # cursor (reverse video)
fi

# clean up
unset -f put_template
unset -f put_template_var
unset -f put_template_custom

unset color_foreground
unset color_background
