{ pkgs, ... }:

{
	  # Enable OpenGL
	hardware.graphics = {
	  enable = true;
	  extraPackages = with pkgs; [
	    vulkan-loader
	    vulkan-validation-layers
	    vulkan-extension-layer
	  ];
	};
}
