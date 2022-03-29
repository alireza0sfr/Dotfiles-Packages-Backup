git_dir=./.git
dir=/tmp/dotfiles-backup/
commit_msg="updated on "`date`

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

if [ ! -d "$git_dir" ]; then
    
    git init
    git remote add origin git@github.com:alireza0sfr/dotfiles.git
    git branch -M main
    
    crontab -l > mycron
    echo "@reboot ~/main/bash-scripts/backup.sh" >> mycron
    crontab mycron
    rm mycron

fi

git pull origin main --allow-unrelated-histories

mkdir ./.backup 

npm list -g --depth=0 > ./.backup/npm_packages || echo "npm failed"
pip freeze > ./.backup/pip_packages || echo "pip failed"
apt list > ./.backup/apt_packages || echo "apt failed"

git add .
git commit -m "$commit_msg"
git push -u origin main
