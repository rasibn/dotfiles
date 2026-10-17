function prnvim -d "Open the current PR's changes in Neovim"
    if not command -q nvim
        echo "nvim is not installed"
        return 1
    end

    nvim -c PRReview
end
