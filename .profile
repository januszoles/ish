
export PATH=$PATH:~/bin/

### if ash load different prompt
if [ "$SHELL" = "/bin/ash" ]; then

  export PS1='\h:\w# '

  ### ashrc
  if [ -f ~/.ashrc ]; then
      . ~/.ashrc
  fi

  ### aliases
  if [ -f ~/.ash_aliases ]; then
      . ~/.ash_aliases
  fi
fi
