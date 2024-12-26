def main [git: bool = true] {
	ls ~/nixos-config | get name | each { | i | rm -r $i } 
	cp -rp /etc/nixos/* ~/nixos-config/
	sudo nixos-rebuild switch --flake /etc/nixos#default
}