k8s_version="v1.29"
prereqs_to_install=()
prereq_commands=('curl' 'wget' 'gpg')
prereq_packages=('apt-transport-https' 'software-properties-common' 'ca-certificates' 'lsb-release')
for prereq_command in ${prereq_commands[@]}
do
    if [ ! $(command -v $prereq_command) ]; then
        echo "Installing $prereq_command..."
        prereqs_to_install+=("$prereq_command")
    fi
done

for prereq_package in ${prereq_packages[@]}
do
    if [ ! $(dpkg-query -W -f='${Status}' $prereq_package 2>/dev/null | grep -c "ok installed") ]; then
        echo "Installing $prereq_package..."
        prereqs_to_install+=("$prereq_package")
    fi
done

first=1
for prereq_to_install in ${prereqs_to_install[@]}
do
    if [ "$first" -eq "1" ]; then
        first=0
        sudo apt-get update
    fi

    sudo apt-get install $prereq_to_install -yy > /dev/null
done

# Install keyrings
if [ ! -f /etc/apt/sources.list.d/github-cli.list ] || [ ! -f /usr/share/keyrings/githubcli-archive-keyring.gpg ] || [ ! $(command -v gh) ]; then
    echo "Installing github keyring..."
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
        && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
fi

if [ ! -f /etc/apt/keyrings/kubernetes-apt-keyring.gpg ]; then
    echo "Installing kubernetes 1.29 keyring..."
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
        && echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
fi

if [ ! $(command -v terraform) ]; then
    echo "Installing hashicorp keyring..."    
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg \
        && gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint \
        && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
fi

if [ ! $(command -v ctop) ]; then
    echo "Installing ctop..."
    sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-linux-amd64 -O /usr/local/bin/ctop \
        && sudo chmod +x /usr/local/bin/ctop
fi

APTFILE="${ZDOTDIR}/os/debian/aptfile" 
APTFILE_TS="${ZDOTDIR}/os/debian/aptfile.ts"
APTFILE_EXECUTABLE="${ZLOCALBIN}/aptfile" 
APTFILE_URL="https://raw.githubusercontent.com/seatgeek/bash-aptfile/master/bin/aptfile"
SUDO_RESPONSE=$(SUDO_ASKPASS=/bin/false sudo -A whoami 2>&1)
SUDO_LINES=$(echo $SUDO_RESPONSE | wc -l)

if [[ ! -f "$APTFILE_EXECUTABLE" ]] && [[ $SUDO_RESPONSE == 'root' || $SUDO_LINES == 2 ]]; then
    echo "Installing aptfile"
    curl -sS -o "$APTFILE_EXECUTABLE" "$APTFILE_URL"
    chmod +x $APTFILE_EXECUTABLE
fi

if [[ -f "$APTFILE" ]] && [[ $SUDO_RESPONSE == 'root' || $SUDO_LINES == 2 ]]; then
    if [[ ! -f "$APTFILE_TS" ]] || [[ ! "$APTFILE_TS" -nt "$APTFILE" ]]; then
        echo "Installing apt packages"
        sudo "$APTFILE_EXECUTABLE" "$APTFILE"
        touch $APTFILE_TS
    fi
fi
