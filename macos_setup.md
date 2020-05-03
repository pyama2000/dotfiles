# Dock関連
```bash
# スリープさせない
$ sudo systemsetup -setcomputersleep Off > /dev/null
```

- "自動的に非表示"をオンにする

# Finder関連
```bash
# 隠しファイルを表示
$ defaults write com.app.finder AppleShowAllFiles -bool true

# 拡張子を表示する
$ defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# ステータスバーを表示
$ defaults write com.apple.finder ShowStatusBar -bool true

# パスバーを表示
$ defaults write com.apple.finder ShowPathbar -bool true

# 名前で並べ替えを選択時にディレクトリを前に置くようにする
$ defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# USBやネットワークストレージに.DS_Storeファイルを作成しない
$ defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
$ defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ボリュームマウント時に自動的にFinderを表示
$ defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
$ defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
$ defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# ~/Libraryを表示
$ chflags nohidden ~/Library

# /Volumesを表示
$ sudo chflags nohidden /Volumes
```

# brew

```bash
$ brew install fish
$ brew install fzf
$ /usr/local/fzf/install
```
