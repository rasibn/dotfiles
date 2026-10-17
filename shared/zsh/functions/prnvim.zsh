prnvim() {
    if ! command -v nvim >/dev/null 2>&1; then
        echo "nvim is not installed"
        return 1
    fi

    nvim -c PRReview
}
