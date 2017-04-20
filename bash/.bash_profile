# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

################# CUSTOM ####################


set -o vi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
	. $(brew --prefix)/etc/bash_completion
fi
GIT_PS1_SHOWDIRTYSTATE=true
PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\] @ \[\033[0;36m\]\h \w\[\033[0;32m\]$(__git_ps1)\n\[\033[0;32m\]└─\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\] ▶\[\033[0m\] '

export JAVA_HOME="`/usr/libexec/java_home`"
export HADOOP_HOME="/Users/tvancann/libs/hadoop-2.7.3"
export SPARK_HOME="/Users/tvancann/libs/spark-2.0.2-bin-hadoop2.7"
export HIVE_HOME="/Users/tvancann/libs/apache-hive-2.1.0"
export SCALA_HOME="/Users/tvancann/libs/scala-2.11.8"
#export APP_ENGINE_HOME="/Users/tvancann/Libraries/google_appengine"
export PATH=$HADOOP_HOME/bin:$SPARK_HOME/bin:$HIVE_HOME/bin:$PLAY_HOME/bin:$SCALA_HOME/bin:$PATH

#folders
alias ll='ls -FlaGh'
alias m="mvim"
alias vimrc="m ~/.vimrc"
alias vbash="m ~/.bash_profile"

# The next line updates PATH for the Google Cloud SDK.
if [ -f /Users/tvancann/Downloads/google-cloud-sdk/path.bash.inc ]; then
  source '/Users/tvancann/Downloads/google-cloud-sdk/path.bash.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f /Users/tvancann/Downloads/google-cloud-sdk/completion.bash.inc ]; then
  source '/Users/tvancann/Downloads/google-cloud-sdk/completion.bash.inc'
fi

function tunnel-aws(){ ssh -i ~/.ssh/persgroep_key_id_rsa -ND 8157 hadoop@10.220.$1; }
function ssh-aws(){ ssh -i ~/.ssh/persgroep_key_id_rsa hadoop@10.220.$1; }
function nbview(){ jupyter nbconvert --to slides "$1" --reveal-prefix=reveal.js --post serve; }
