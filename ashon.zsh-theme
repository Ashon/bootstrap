# vim:ft=zsh ts=2 sw=2 sts=2

finalize() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}$"
  CURRENT_BG=''
}

segment() {
  if [[ -n $@ ]]; then
    echo "%{$fg[white]%}▸" $@
  fi
}

context() {
  echo -n "%{$fg[cyan]%}%n@%m %{$fg[yellow]%}%~"
}

virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"

  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    echo -n "%{$fg[white]%}[ %{$fg[blue]%}`basename $virtualenv_path`%{$fg[white]%} ]%{$reset_color%}"
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

  is_working_dir=$(git rev-parse --is-inside-work-tree 2> /dev/null)
  if [[ $is_working_dir == "true" ]]; then
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
    if [[ -n $dirty ]]; then
      # set untracked files
      untracked=$(git status --porcelain | grep "^??" | wc -l | awk '{print $1}')
      if [[ $untracked -ne "0" ]]; then
        mode+="%{%F{cyan}%}untracked:${untracked} "
      fi

      # set modified files
      changed=$(git status --porcelain | grep "^ M" | wc -l | awk '{print $1}')
      if [[ $changed -ne "0" ]]; then
        mode+="%{%F{yellow}%}changed:${changed} "
      fi

      # set staged
      staged=$(git diff --name-only --cached | wc -l | awk '{print $1}')
      if [[ $staged -ne "0" ]]; then
        mode+="%{%F{blue}%}staged:${staged} "
      fi

    else
      mode="%{%F{green}%}clean "
    fi

    # add stash list
    stash=$(git stash list | wc -l | awk '{ print $1 }')
    if [[ $stash -ne "0" ]]; then
      mode+="%{%F{red}%}stash:${stash} "
    fi

    repo_path=$(git rev-parse --git-dir 2>/dev/null)
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
    echo -n "[ %{$fg[magenta]%}${ref/refs\/heads\//$PL_BRANCH_CHAR }%{$fg[yellow]%}${vcs_info_msg_0_%% } ${mode}%{$fg[white]%}]"
  fi
}

clock() {
  echo -n "%{$fg[white]%}%D{%T}%{$reset_color%}"
}

shell_status() {
  local -a symbols

  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}ERR-$RETVAL"
  [[ $RETVAL -eq 0 ]] && symbols+="%{%F{green}%}OK"

  echo -n "$symbols"
}

build_prompt() {
  RETVAL=$?
  segment $(context)
  segment $(virtualenv) $(git_status)
  segment $(clock) $(shell_status) $(finalize)
}

PROMPT='$(build_prompt) '
