ln -snfv ~/dotfiles/.gitconfig ~/
ln -snfv ~/dotfiles/.commit_template ~/
ln -snfv ~/dotfilses/.hyper.js ~/
ln -snfv ~/dotfiles/.config/nvim ~/.config/
ln -snfv ~/dotfiles/.config/coc ~/.config/
ln -snfv ~/dotfiles/.config/fish/config.fish ~/.config/fish/
ln -snfv ~/dotfiles/.config/fish/functions/fish_prompt.fish ~/.config/fish/functions/

if [ $(expr substr $(uname -s) 1 5) == "Linux" ]; then
  ln -snfv ~/dotfiles/.bashrc ~/
  ln -snfv ~/dotfiles/.profile ~/
fi

