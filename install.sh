#!/bin/bash

# Install UV
curl -LsSf https://astral.sh/uv/install.sh | sh

# install helix

# Set variables
HELIX_VERSION="24.07"
HELIX_URL="https://github.com/helix-editor/helix/releases/download/${HELIX_VERSION}/helix-${HELIX_VERSION}-x86_64-linux.tar.xz"
INSTALL_DIR="$HOME/.local/helix"
CONFIG_DIR="$HOME/.config/helix"
CONFIG_FILE="$CONFIG_DIR/config.toml"
TMUX_CONF_FILE="$HOME/.tmux.conf"

# Create necessary directories
mkdir -p "$INSTALL_DIR"
mkdir -p "$CONFIG_DIR"

# Download Helix
wget "$HELIX_URL" -O /tmp/helix.tar.xz

# Extract the binaries and runtime
tar -xf /tmp/helix.tar.xz -C /tmp/

# Move the binary to the install directory
mv /tmp/helix-${HELIX_VERSION}-x86_64-linux/hx "$INSTALL_DIR/"

# Move the runtime directory to the config directory
mv /tmp/helix-${HELIX_VERSION}-x86_64-linux/runtime "$CONFIG_DIR/"

# Create the config.toml file with the specified content
cat <<EOL > "$CONFIG_FILE"
theme = "dustfox"

[editor]
true-color = true
EOL

# Create the .tmux.conf file with the specified content
cat <<EOT > "$TMUX_CONF_FILE"
# remap prefix from 'C-b' to 'C-a'
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# split panes using | and -
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# reload config file (change file location to your the tmux.conf you want to use)
bind r source-file ~/.tmux.conf

# switch panes using Alt-arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Enable mouse control (clickable windows, panes, resizable panes)
set -g mouse on
set -sg escape-time 0

set -g default-terminal "screen-256color"
EOT

# Cleanup
rm -rf /tmp/helix*

# Add the helix binary to your PATH in the current shell session
export PATH="$INSTALL_DIR:$PATH"

# Optionally add the helix binary to your PATH permanently by adding the following to your shell configuration file (.bashrc, .zshrc, etc.)
echo 'export PATH="$HOME/.local/helix:$PATH"' >> ~/.bashrc

# Notify the user
echo "Helix has been installed in $INSTALL_DIR. A config file has been created at $CONFIG_FILE."
echo "A tmux configuration file has been created at $TMUX_CONF_FILE."
echo "Please restart your terminal or run 'source ~/.bashrc' to use Helix from the command line."
