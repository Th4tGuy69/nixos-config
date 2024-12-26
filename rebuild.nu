def main [
    --no-push -n
] {
    # Replace repo with current system config
    cd /home/thatguy/nixos-config/
    ls | get name | each { | i | rm -r $i } 
    cp -rp /etc/nixos/* ./
    
    # Rebuild
    sudo nixos-rebuild switch --flake /etc/nixos#default
    
    # Push if successful and flag
    if not ($no_push or $n) {
        git -c include.path=/home/thatguy/.gitconfig add .
        git -c include.path=/home/thatguy/.gitconfig commit -m "$(date '+%D %r')"
        git -c include.path=/home/thatguy/.gitconfig push
    } 
}
