git_dir=./.git
dir=/tmp/dotfiles-backup/
commit_msg="updated on "`date`

echo "[BACKUP DOTFILES] Init!"

if [ ! -d "$dir" ]; then
    mkdir $dir
fi

cd $dir
cp ~/.zshrc $dir
cp ~/.npmrc $dir
cp ~/.bashrc $dir
cp -r ~/.icons $dir
cp -r ~/.themes $dir
cp -r ~/.ssh/ $dir
cp /etc/fstab $dir

echo "[BACKUP DOTFILES] Copying dotfiles to temp folder..."

if [ ! -d "$git_dir" ]; then

    echo "[BACKUP DOTFILES] Creating a git repo..."
    git init
    git remote add origin git@github.com:alireza0sfr/dotfiles.git
    git branch -M main
    
    echo "[BACKUP DOTFILES] Adding to cron..."
    crontab -l > mycron
    echo "@reboot ~/main/bash-scripts/dotfiles-packages-backup/backup.sh" >> mycron
    crontab mycron
    rm mycron

fi

echo "[BACKUP DOTFILES] Pulling previous dotfiles..."

git pull origin main --allow-unrelated-histories

mkdir ./.backup 

npm list -g --depth=0 > ./.backup/npm_packages || echo "[BACKUP DOTFILES] Npm backup failed!"
pip freeze > ./.backup/pip_packages || echo "[BACKUP DOTFILES] Pip backup failed!"
apt list > ./.backup/apt_packages || echo "[BACKUP DOTFILES] Apt backup failed!"

git add .
git commit -m "$commit_msg"
git push -u origin main --force

echo "[BACKUP DOTFILES] Backup Done..."