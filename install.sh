#!bin/bash
set -eu -o pipefail
trap 'echo "ERROR: line no = $LINENO, exit status = $?" >&2; exit 1' ERR

wget --no-check-certificate https://github.com/pyama2000/dotfiles/archive/master.tar.gz
tar xzvf master.tar.gz
mv ~/dotfiles-master ~/dotfiles
bash ~/dotfiles/setup.sh
cd dotfiles
git init
git remote add origin git@github.com:pyama2000/dotfiles.git
