# vim:ft=zsh ts=2 sw=2 sts=2

finalize() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  echo -n " $"
  CURRENT_BG=''
}

context() {
  echo -n "%{$fg[white]%}▸ %{$fg[cyan]%}%n@%m %{$fg[yellow]%}%~\n"
}

virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"

  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    echo -n "%{$fg[white]%}▸ [ %{$fg[blue]%}`basename $virtualenv_path`%{$fg[white]%} ]%{$reset_color%}\n"
  fi
}

git_status() {
  (( $+commands[git] )) || return
  if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
    return
  fi
  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    PL_BRANCH_CHAR=$'\ue0a0'         # 
  }
  local ref dirty mode repo_path changed untracked staged

  if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
    repo_path=$(git rev-parse --git-dir 2>/dev/null)
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
    if [[ -n $dirty ]]; then

      mode="%{%F{red}%}"
      # set untracked files
      if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        untracked=$(git status --porcelain | grep "^??" | wc -l | awk '{print $1}')
        mode+="untracked:${untracked} "
      fi

      # set modified files
      if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep ' M' &> /dev/null ; then
        changed=$(git status --porcelain | grep "^ M" | wc -l | awk '{print $1}')
        mode+="changed:${changed} "
      fi

      # set staged
      if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep 'A ' &> /dev/null ; then
        staged=$(git status --porcelain | grep "^A " | wc -l | awk '{print $1}')
        mode+="staged:${staged} "
      fi
    else
      #prompt_segment green $CURRENT_FG
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode+=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode+=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode+=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:*' unstagedstr '±'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    echo -n "%{$fg[white]%}▸ %{$fg[blue]%}${ref/refs\/heads\//$PL_BRANCH_CHAR }%{$fg[yellow]%}${vcs_info_msg_0_%% } ${mode}\n"
  fi
}

clock() {
  echo -n "%{$fg[white]%}▸ %{$fg[white]%}%D{%T} %{$reset_color%}"
}

shell_status() {
  local -a symbols

  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}ERR-$RETVAL"
  [[ $RETVAL -eq 0 ]] && symbols+="%{%F{green}%}OK"

  echo -n "$symbols"
}

build_prompt() {
  RETVAL=$?
  virtualenv
  context
  git_status
  clock
  shell_status
  finalize
}

PROMPT='$(build_prompt) '
