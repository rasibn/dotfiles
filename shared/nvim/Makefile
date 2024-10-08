
all: for-nix for-pc

# adds lsp and disables mason for nix!
for-nix:
	rm ./lua/plugins/lsp.lua; ln -s $(DOTFILE_DIR)/shared/nvim/lua/nix-only/lsp.lua ./lua/plugins/lsp.lua
	rm ./lua/plugins/disable-mason.lua; ln -s $(DOTFILE_DIR)/shared/nvim/lua/nix-only/disable-mason.lua ./lua/plugins/disable-mason.lua

# adds cord plugin for discord ;)
for-pc:
	rm ./lua/plugins/cord.lua; ln -s $(DOTFILE_DIR)/shared/nvim/lua/pc-only/cord.lua ./lua/plugins/cord.lua

for-macos:
	rm ./lua/plugins/lsp.lua; ln -s $(DOTFILE_DIR)/shared/nvim/lua/pc-only/lsp-macos.lua ./lua/plugins/lsp.lua
