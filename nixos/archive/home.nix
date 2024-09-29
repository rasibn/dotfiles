{config, pkgs,...}:

{
	programs.git = {
	  enable = true;
	  userName = "Rasib Nadeem";
	  userEmail = "rasibnadeem101@gmail.com";
	  includes = [
	    { path = "~/.gitconfig.local"; }
	  ];
	};

	programs.fish = {
	  enable = true;

	  plugins = [
	    {
	      name = "plugin-git";
	      src = pkgs.fishPlugins.plugin-git.src;
	    }
	  ];
	};
}
