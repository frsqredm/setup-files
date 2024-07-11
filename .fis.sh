#!/bin/bash

fis_version="0.2.6"

# Modify pacman ParallelDownloads
sudo sed -i "s/ParallelDownloads.*/ParallelDownloads = 16/" /etc/pacman.conf
echo "Modify pacman ParallelDownloads ..."
echo -e "\n--> done\n"
sleep 2

# Install packages
echo "Installing packages ..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm zsh pacman-contrib man-db alacritty git neovim fzf zoxide tree unzip
echo -e "\n--> done\n"
sleep 2

# Start paccache.timer to discard unused packages weekly
echo "Start paccache.timer to discard unused packages weekly ..."
sudo systemctl start paccache.timer
echo -e "\n--> paccache.timer started\n"
sleep 2

# Config git
echo "Config git as frsqredm"
git config --global user.name frsqredm
git config --global user.email fr.sqre.dm@gmail.com
git config --global credential.helper "cache --timeout=604800"
echo -e "\n--> done\n"
sleep 2

# Install oh-my-posh
echo "Install oh-my-posh"
curl -s https://ohmyposh.dev/install.sh | sudo bash -s
echo -e "\n--> oh-my-posh installed\n"
sleep 2

# Download config files
echo "Get config files for zsh, omp, neovim, neofetch"
rm -rf ~/.config # Remove existing .config folder
git clone https://github.com/frsqredm/linux-config-files.git ~/.config
echo -e "\n--> config files save at ~/.config\n"
sleep 2

# Create symbolic link for zsh and omp dotfile
rm ~/.zshrc # Remove existing .zshrc file 
ln -s ~/.config/zsh/.zshrc ~/.zshrc

# Install neofetch
echo "Install neofetch"
sudo pacman -S --noconfirm neofetch
echo -e "\n--> neofetch installed\n"
sleep 2

# Install rust
echo "Installing rust ..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Create .fis1.sh file
cat <<EOF > ~/.fis1.sh
#!/bin/zsh

# Reload .zshenv to confirm rust
echo "Reload .zshenv ..." 
source ~/.zshenv

# Confirm rust install
echo -e "\n--> \$(rustc -V) installed\n"
sleep 2

# Install ruby on rails
echo "Installing ruby on rails ..."

## Install asdf for version manager
echo "--> Installing asdf ..."
git clone https://github.com/asdf-vm/asdf.git ~/.asdf

# Reload zsh to init asdf
echo "Reload zsh ..." 
source ~/.zshenv
source ~/.zshrc
echo -e "\n--> asdf \$(asdf version) installed\n"
sleep 2

## Install dependencies
echo "--> Installing dependencies ..."
sudo pacman -S --needed --noconfirm base-devel libffi libyaml openssl zlib
echo -e "\n--> done\n"
sleep 2

## Add ruby plugin
echo "--> Adding asdf-ruby plugin ..."
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
echo -e "\n--> done\n"
sleep 2

## Install ruby 3.3.3
echo "--> Installing ruby 3.3.3 ..."
asdf install ruby 3.3.3
asdf global ruby 3.3.3

## Verify ruby install
echo -e "\n--> \$(ruby -v) installed\n"
sleep 2

## Install rails
echo "--> Installing rails ..."
gem install rails
echo -e "\n--> \$(rails -v) installed\n"
EOF

# Using zsh to continue install ruby on rails (zsh is needed to install asdf)
zsh ~/.fis1.sh

# Change default shell to zsh
echo "Changing default shell to zsh ..."
chsh -s /bin/zsh
sudo chsh -s /usr/bin/zsh
echo -e "\n--> zsh is now default shell\n"
sleep 2

# Finished
echo -e "--> f-i-s script $fis_version finished"
rm ~/.fis1.sh
exec zsh
