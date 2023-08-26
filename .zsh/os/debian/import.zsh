APTFILE="${ZDOTDIR}/os/debian/aptfile" 
APTFILE_TS="${ZDOTDIR}/os/debian/aptfile.ts"
APTFILE_EXECUTABLE="${ZLOCALBIN}/aptfile" 
APTFILE_URL="https://raw.githubusercontent.com/seatgeek/bash-aptfile/master/bin/aptfile"
SUDO_RESPONSE=$(SUDO_ASKPASS=/bin/false sudo -A whoami 2>&1 | wc -l)

if [[ ! -f "$APTFILE_EXECUTABLE" ]] && [[ $SUDO_RESPONSE == 2 ]]; then
    echo "Installing aptfile"
    curl -sS -o "$APTFILE_EXECUTABLE" "$APTFILE_URL"
    chmod +x $APTFILE_EXECUTABLE
fi

[[ -f "$APTFILE" ]] || echo "$APTFILE doesn't exist"
[[ ! -f "$APTFILE_TS" ]] || echo "$APTFILE_TS doesn't exist"

if [[ -f "$APTFILE" ]] && [[ $SUDO_RESPONSE == 2 ]]; then
    if [[ ! -f "$APTFILE_TS" ]] || [[ ! "$APTFILE_TS" -nt "$APTFILE" ]]; then
        echo "Installing apt packages"
        sudo "$APTFILE_EXECUTABLE" "$APTFILE"
        touch $APTFILE_TS
    fi
fi
