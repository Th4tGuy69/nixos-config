def main [] {
    # Replace repo with current system config (as regular user)
    cd /home/thatguy/nixos-config/
    
    # Clean up any existing symlinks and files more thoroughly
    ls | get name | each { | i | 
        if ($i | path type) == "symlink" {
            rm $i
        } else {
            rm -r $i
        }
    }
    
    # Copy new config (need sudo for reading /etc/nixos)
    sudo cp -rp /etc/nixos/* ./
    
    # Fix ownership after copying as root
    sudo chown -R thatguy:users /home/thatguy/nixos-config/
    
    # Stage all changes before rebuild to avoid "dirty" warnings
    git -c include.path=/home/thatguy/.gitconfig add .
    
    # Rebuild (needs sudo)
    sudo nixos-rebuild switch --flake
    
    # Commit and push after successful rebuild (as regular user)
    git -c include.path=/home/thatguy/.gitconfig commit -m (date now | format date '%D %r')
    git -c include.path=/home/thatguy/.gitconfig push
}
