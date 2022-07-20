## Instructions to bringup the docker environment(ROS 1 noetic with gazebo-11)

- Tested on docker version 20.10.17
- Requires docker compose v2.6.1 or higher

**Install the following packages if you have a dedicated nvidia graphics card**

-  Add the GPG key:
	
	```
	distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   	&& curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-	key add - \
   	&& curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
   ```
  
- Install the nvidia-docker2 package 
  
  ~~~bash
  ```
  sudo apt-get update
  ```
  
  ```
  sudo apt-get install -y nvidia-docker2
  ```
  ~~~
  
- If you are on arch then install `nvidia-container-toolkit`
  
  ```bash
  yay -S nvidia-container-toolkit
  ```
  
- Restart the Docker daemon
  
   	```
   	sudo systemctl restart docker
   	``` 
  **Instructions to build the image and run the container**

- Place the Dockerfile, and the docker-compose_gpu.yml file inside ~/your_workspace/. **NOTE:** Your entire src/ folder will be mounted as a volume in the container.

- To build the image:

	```bash
	./bringup_noetic_devel.sh -c build
	```
	
	NOTE:  This step might be time consuming.

- To run the container:
	```bash
	cd  ~/your_workspace/
	
	./bringup_noetic_devel.sh -c run
	```
	
	 Wait for the bash script to execute. In another terminal 
	
	 ```
	 docker-compose exec alpha_sim /bin/bash
	 ```
