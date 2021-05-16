function light
  if test (uname -s) = 'Darwin'
    echo -ne "\033]50;SetProfile=Light\a"
  end

  set -xU MY_THEME "light"
end
