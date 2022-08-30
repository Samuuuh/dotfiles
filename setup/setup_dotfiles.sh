#!/bin/bash
path="$0"
package_file="packages.txt"

if [[ "${path:0:1}" = "/" ]] # check if an absolute path is provided
then
   installation_dir=$(dirname "$path")
else
   installation_dir=$(dirname "$PWD"/"$path")
fi

dotfiles_dir=$(dirname "$installation_dir")

main() {
    echo "$installation_dir"
    echo "$dotfiles_dir"

    packages
}

createDirs() {
    mkdir ~/Desktop
    mkdir ~/Downloads
    mkdir ~/Github
    mkdir ~/Templates
    mkdir ~/Wallpapers
    mkdir ~/Screenshots
}

packages() {
    # Install yay #
    read -p "Do you wish to install Yet Another Yogurt? [Y/n]" -n 1 -r
    if [ "$REPLY" != "n" ]
    then
        yay_dir=~/.local/share/yay
        git clone https://aur.archlinux.org/yay.git $yay_dir
        cd $yay_dir || exit
        makepkg -si
    fi
    echo "YAY -> Installed with success"

    # Install Packages #
    # Spotify Keys
    curl -sS https://download.spotify.com/debian/pubkey.gpg | gpg --import -
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90

    # Other Packages
    while read -r packageName
    do
        sudo pacman -S --noconfirm --needed "$packageName" || pacman -Qi "$packageName" || yay -S "$packageName" </dev/tty
    done < "$installation_dir/$package_file"

    echo "Installed all the packages"

    # Install Python Packages #
    #pip install -r "$installation_dir/python-packages.txt"
}

main "$@"