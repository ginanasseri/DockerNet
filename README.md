# DockerNet

Virtual network of Docker containers simulating two hosts communicating through a router connected to an external gateway.

## How to Set Up 

1. Ensure Docker is installed and running.
2. Update volume paths in `docker-compose.yml` to match your system (replace `/Users/ginanasseri/` with your local project path).
3. Run `docker-compose build` to build the images.
4. Run `docker-compose up -d` to start the containers in the background.
5. In separate terminals, start interactive sessions in each container:
    - Terminal 1: `docker exec -it host1 /bin/bash`
    - Terminal 2: `docker exec -it host2 /bin/bash`
    - Terminal 3: `docker exec -it router /bin/bash`
    - Terminal 4: `docker exec -it gateway /bin/bash`
6. In `host1`, set the default route to the router:  
   `ip route replace default via 192.168.1.2`
7. In `host2`, set the default route to the router:  
   `ip route replace default via 10.10.1.2`

## Usage Example

Note: use `ip route` inside each container to check IP addresses.

1. Ping host2 from host1:  
   From `host1`: `ping 10.10.1.200`

2. Ping host1 from host2:  
   From `host2`: `ping 192.168.1.100`

3. Listen to traffic from the router:  
   From `router`: `tcpdump -i any -nn -v`
