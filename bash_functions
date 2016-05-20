
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

function pulldb {
    adb -d shell "run-as $1 cat /data/data/$1/databases/$2 > /sdcard/$2"
    adb pull "/sdcard/$2"
}

function app-backup() {
    if [[ -z $1 ]]; then
        echo 'Informe o nome do pacote'
        return 1
    fi
    adb backup -f $1.ab -noapk -noshared $1
    java -jar ~/.dotfiles/abe.jar unpack $1.ab $1.tar
    tar -xf $1.tar
    rm $1.ab $1.tar
}


# Git clone shorthand
function gh() {
    git clone "https://github.com/$@"
}


# Extract a column from a tabular output
function col {
    awk -v col=$1 '{print $col}'
}

function goloc {
    for pkg in $(go list $1/...); do
        wc -l $(go list -f '{{range .GoFiles}}{{$.Dir}}/{{.}} {{end}}' $pkg) | \
            tail -1 | awk '{ print $1 " '$pkg'" }'
    done | sort -nr
}

function gograph {
    (
        echo "digraph G {"
        go list -f '{{range .Imports}}{{printf "\t%q -> %q;\n" $.ImportPath .}}{{end}}' \
            $(go list -f '{{join .Deps " "}}' $1) $1
        echo "}"
    ) | dot -Tsvg -o gograph.svg
}
