function dark
  if test (uname -s) = 'Darwin'
    echo -ne "\033]50;SetProfile=Dark\a"
  end

  set --export --universal MY_THEME "dark"
end
