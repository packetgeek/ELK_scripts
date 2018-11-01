#!/bin/bash

# Written by Tim Kramer on 31 Oct 2018
# Adapted from: https://elk-docker.readthedocs.io/

# Assumes a clean install of Ubuntu 18.04.

# Following installs the ELK stack in Docker and 
# creates a number of scripts to start/stop same
# Needs to be run as root.  Tailor as desired/needed.

# following creates the data directory for data persistence
mkdir -p /elk/data

# From this point on, it's probably easier to read the individual scripts.

# create the Docker install script
cat << EOF0 > /elk/install_docker.sh
#!/bin/bash

# install the various binaries
apt-get update
apt-get upgrade -y
apt-get install -y git docker.io
EOF0

# create the start script
cat << EOF1 > /elk/start_elk.sh
#!/bin/bash

echo "Note: although the command line will return immediately, it can"
echo "take Elasticsearch and Kibana 30-45 seconds to start."
echo " "
docker start elk
EOF1

# create the stop script
cat << EOF2 > /elk/stop_elk.sh
#!/bin/bash

echo "this takes a few seconds..."
echo " "
docker stop elk
EOF2

# create the build_image script
cat << EOF3 > /elk/build_elk_image.sh
#!/bin/bash

echo "Adapted from: https://elk-docker.readthedocs.io/"
echo " "
echo "The original Dockerfile can be viewed at:"
echo "  https://github.com/spujadas/elk-docker"
echo " "

docker pull sebp/elk
EOF3

# create the build_container script
cat << EOF4 > /elk/build_elk_container.sh
#!/bin/bash

echo " "
echo "Following increases dedicated memory and avoids the following error:"
echo "   max virtual memory areas vm.max_map_count [65530] is too "
echo "     low, increase to at least [262144]"
echo " "
sysctl -w vm.max_map_count=262144

echo " "
echo "In the following:"
echo " - 5601 is the Kibana web interface"
echo " - 9200 is the Elasticsearch JSON interface"
echo " - 5044 is the Logstash Beats interace"
echo " "

echo "docker run --name elk -itd -v /elk/data:/var/lib/elasticsearch -p 5601:5601 -p 9200:9200 -p 5044:5044 sebp/elk"

# build/start the container
docker run --name elk -itd -v /elk/data:/var/lib/elasticsearch -p 5601:5601 -p 9200:9200 -p 5044:5044 sebp/elk

echo " "
echo "Note: In the above, omit the 'd' in '-itd' if you want to monitor "
echo "      what the ELK stack is doing. Edit this script to change it."
echo " "

# Note: for the above, elastic search can take a few seconds to start.  Be patient.
# Also, the first time that you point a browser at Kibana, it may take a few 
#    seconds to present a page.

EOF4

# Create the troubleshooting help
cat << EOF5 > /elk/troubleshooting.sh

echo "If the above fails to start Elasticsearch, recommend consulting:"
echo "  https://elk-docker.readthedocs.io/#troubleshooting"
EOF5

# Create the destroy elk's container script
cat << EOF6 > /elk/destroy_elk_container.sh
#!/bin/bash

docker rm elk
EOF6

# Create the destroy elk's image script
cat << EOF7 > /elk/destroy_elk_image.sh
#!/bin/bash

docker rmi sebp/elk
EOF7

# make all shell scripts executable
chmod u+x /elk/*.sh

# Recommended order
echo "Following order is recommended:"
echo " 1) cd /elk"
echo " 2) ./install_docker.sh"
echo " 3) ./build_elk_image.sh"
echo " 4) ./build_elk_container.sh"
echo " 5) point a browser at: http://Your_IP:5601"
echo " "
echo "Note: Step 2 can be skipped if Docker and git are already installed."
echo " "
echo "Note: Step 4 will also start the container.  After that, the" 
echo "container can be stopped/started via either of the following:"
echo "   ./stop_elk.sh"
echo "   ./start_elk.sh"
echo " "
echo "Note: Also included are scripts to delete the container and/or the image:"
echo "   ./destroy_elk_container.sh"
echo "   ./destroy_elk_image.sh"

