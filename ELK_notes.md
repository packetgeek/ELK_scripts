# ELK Container

## Features

* The container, created by this scrip, provides data persistence by using an external volume (i.e., if you delete the container, data is not lost).
* The main script creates a number of management scripts (in /elk) that are constructed so that the user can also learn a bit about Docker.  Recommend revieing each script before it's run.

## Needs

* The main script needs to be run as root, primarily because it creates a folder in the system's root directory.  
* The other scripts should be run as root, or as whichever user you allow to create Docker containers.  By default, the main script creates the other scripts to run as root.  Once it's run, it can be ignored/deleted.

## Using the scripits

Following is recommended order for building/running the ELK container:
```c
chmod u+x ./main.sh
./main.sh
cd /elk
./install_docker.sh"
./build_elk_image.sh"
./build_elk_container.sh"
```

After peforming the above, point your browser at: '''http://Your_IP:5601'''

''Note:'' The "./install_docker.sh" step can be skipped if Docker and git are already installed.

''Note:'' The "./build_elk_container" step will also start the container.  After that, the container can be stopped/started via either of the following:
```c
./stop_elk.sh
./start_elk.sh
```

Also included are scripts to delete the container and/or the image:
```c
./destroy_elk_container.sh"
./destroy_elk_image.sh"
```

''Note:'' Before you destroy the container, you must stop it.

''Note:''Before you destroy the image, you must destroy the container.
