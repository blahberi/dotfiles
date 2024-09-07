function fish_greeting
       fastfetch
end

if status is-interactive
       starship init fish | source
end

alias cbat='bat --color always'
alias ttyping='tt -theme gruvbox-dark -t 15'

function clearall
       clear
       printf '\e[3J'
end

fzf --fish | source
