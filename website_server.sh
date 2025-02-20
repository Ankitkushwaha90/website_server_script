#!/bin/bash

# Title: Web Server Setup and Public URL Publisher
# Description: A script to set up an Apache web server and publish a public URL using ngrok.
# Author: Your Name
# Date: $(date +%Y-%m-%d)

# Variables
WEB_DIR="/var/www/html"
NGROK_TOKEN="your_ngrok_token_here"  # Replace with your ngrok authtoken
HTML_CONTENT="<html><body><h1>Welcome to My Website!</h1><p>This is a test page.</p></body></html>"

# Function to install Apache web server
install_apache() {
    echo "Installing Apache web server..."
    sudo apt update
    sudo apt install -y apache2
    echo "Apache installed successfully."
}

# Function to create a simple HTML page
create_html_page() {
    echo "Creating HTML page..."
    echo "$HTML_CONTENT" | sudo tee "$WEB_DIR/index.html" > /dev/null
    echo "HTML page created at $WEB_DIR/index.html."
}

# Function to start Apache web server
start_apache() {
    echo "Starting Apache web server..."
    sudo systemctl start apache2
    sudo systemctl enable apache2
    echo "Apache web server started."
}

# Function to install ngrok
install_ngrok() {
    echo "Installing ngrok..."
    curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
    echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
    sudo apt update
    sudo apt install -y ngrok
    echo "ngrok installed successfully."
}

# Function to authenticate ngrok
authenticate_ngrok() {
    echo "Authenticating ngrok..."
    ngrok authtoken "$NGROK_TOKEN"
    echo "ngrok authenticated."
}

# Function to start ngrok and publish the website
publish_website() {
    echo "Publishing website..."
    ngrok http 80 &
    sleep 5  # Wait for ngrok to start
    echo "Website is now live! Public URL:"
    curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url'
}

# Main script execution
echo "============================================="
echo "Web Server Setup and Public URL Publisher"
echo "============================================="

# Install Apache
install_apache

# Create HTML page
create_html_page

# Start Apache
start_apache

# Install ngrok
install_ngrok

# Authenticate ngrok
authenticate_ngrok

# Publish website
publish_website

echo "============================================="
echo "Script execution completed."
echo "============================================="
