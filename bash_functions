
# Pushbullet notification
if [ -f ~/.apikeyrc ]; then
    . ~/.apikeyrc
fi

function push() {
    if [[ -z $1 ]]; then
        while read content; do
            curl -s -u $PUSHBULLET_APIKEY: -X POST https://api.pushbullet.com/v2/pushes --header 'Content-Type: application/json' --data-binary "{\"type\":\"note\",\"title\":\"$content\"}" > /dev/null 2> /dev/null
        done
    else
        curl -s -u $PUSHBULLET_APIKEY: -X POST https://api.pushbullet.com/v2/pushes --header 'Content-Type: application/json' --data-binary "{\"type\":\"note\",\"title\":\"$(echo $@)\"}" > /dev/null 2> /dev/null
    fi
}


# Git clone shorthand
function gh() {
    git clone "https://github.com/$@"
}


# Extract a column from a tabular output
function col {
    awk -v col=$1 '{print $col}'
}
