function fish_greeting
       neofetch
end

if status is-interactive
       starship init fish | source
end

alias cbat='bat --color always'
alias ttyping='tt -theme gruvbox-dark -t 15'

fzf --fish | source
