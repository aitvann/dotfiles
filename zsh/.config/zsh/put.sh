# cteates file and path to it
put() {
    if [ $# -lt 1 ]; then
        echo "put: missing operand";
        return 1;
    fi

    for f in "$@"; do
        mkdir -p -- "$(dirname -- "$f")"
        touch -- "$f"
    done
}

