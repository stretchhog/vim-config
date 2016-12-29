# install dependencies
if ! which brew > /dev/null; then
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
fi

if ! which ctags > /dev/null; then
	brew install ctags
fi

if ! which macvim > /dev/null; then
	brew install macvim --with-cscope --with-lua
fi

# install fonts
cd ~/Library/Fonts && curl -fLo "Sauce Code Pro Nerd Font Complete" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf

# install pathogen and vundle
mkdir -p ~/.vim/autoload ~/.vim/bundle; \
curl -Sso ~/.vim/autoload/pathogen.vim \
	https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# clone vimrc and install vundle plugins
git clone https://github.com/stretchhog/vim-config.git

cp vim-config/.vimrc ~/.vimrc

mvim +PluginInstall +qall
