Creating a script to set up a web server and publish a website link publicly involves several steps. Below is a Bash script that automates the process of setting up an Apache web server, configuring it to serve a simple HTML page, and making it accessible to the public using ngrok (a tool that creates a public URL for your local server).

This script is designed for educational purposes and assumes you are using a Linux-based system (e.g., Ubuntu).

Bash Script: Web Server Setup and Public URL Publishing
bash
Copy
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
How to Use the Script
Install Dependencies:

Ensure curl and jq are installed on your system:

bash
Copy
sudo apt install -y curl jq
Get an ngrok Authtoken:

Sign up at ngrok and get your authtoken.

Replace your_ngrok_token_here in the script with your actual ngrok authtoken.

Save the Script:

Save the script to a file, e.g., setup_web_server.sh.

Make the Script Executable:

bash
Copy
chmod +x setup_web_server.sh
Run the Script:

bash
Copy
./setup_web_server.sh
Access the Website:

The script will output a public URL (e.g., https://abc123.ngrok.io).

Open this URL in your browser to access the website.

Explanation of the Script
Apache Installation:

The script installs the Apache web server using apt.

HTML Page Creation:

A simple HTML page is created in the default web directory (/var/www/html/index.html).

Apache Startup:

The Apache service is started and enabled to run on boot.

ngrok Installation:

ngrok is installed to create a public URL for the local server.

ngrok Authentication:

The script authenticates ngrok using your authtoken.

Website Publishing:

ngrok is started, and the public URL is fetched using the ngrok API.

Notes
Security: This script is for educational purposes. If you're deploying a real website, ensure proper security measures (e.g., firewalls, HTTPS, etc.).

ngrok Free Tier: The free version of ngrok provides temporary URLs. For permanent URLs, consider upgrading to a paid plan.

Customization: You can modify the HTML content or use your own website files by replacing the content in /var/www/html.

This script provides a hands-on way to learn about web servers, networking, and tools like ngrok. Always use such tools responsibly and ethically.
