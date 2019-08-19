# install powerline
pip install powerline-status

# install powerline patch
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

# install starship
cargo install starship
