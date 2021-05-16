function dark
  if test (uname -s) = 'Darwin'
    echo -ne "\033]50;SetProfile=Dark\a"
  end

  set -xU MY_THEME "dark"
end
