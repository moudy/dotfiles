function light
  if test (uname -s) = 'Darwin'
    echo -ne "\033]50;SetProfile=Light\a"
  end

  set --export --universal MY_THEME "light"
end
