function fish_prompt
  set -l last_status $status

  set_color -o green
  echo -n (whoami)
  set_color normal

  echo -n '@'

  set_color -o cyan
  echo -n (hostname -s)
  set_color normal

  echo -n ':'

  set_color green
  echo -n (prompt_pwd)
  set_color normal

  set -l project_version (version)
  echo -n '@'$project_version

  __terlar_git_prompt


  echo
  if not test $last_status -eq 0
    set_color red --bold
  end

  echo -n '➤ '
  set_color normal

end

