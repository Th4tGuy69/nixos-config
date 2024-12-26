def main [
    --no-push -n
] {
    # Replace repo with current system config
    ls ~/nixos-config | get name | each { | i | rm -r $i } 
    cp -rp /etc/nixos/* ~/nixos-config/
    
    # Rebuild
    sudo nixos-rebuild switch --flake /etc/nixos#default
    
    # Push if successful and flag
    if not ($no_push or $n) {
        git add .
        git commit -m $"(date now | format date '%D %r')"
        git push
    } 
}