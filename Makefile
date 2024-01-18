# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: babieseater <babieseater@student.42.fr>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/11/22 15:54:05 by smayrand          #+#    #+#              #
#    Updated: 2024/01/18 13:50:06 by babieseater      ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DATA_DIR =  /home/${USER}/data
WORDPRESS_DIR =  $(DATA_DIR)/wordpress/
MARIADB_DIR   =  $(DATA_DIR)/mariadb/
all: build

build:
	@if [ ! -d $(DATA_DIR) ]; then \
        mkdir -p $(DATA_DIR); \
        echo "Directory $(DATA_DIR) created."; \
    fi
	@if [ ! -d $(WORDPRESS_DIR) ]; then \
        mkdir -p $(WORDPRESS_DIR); \
        echo "Directory $(WORDPRESS_DIR) created."; \
    fi
	@if [ ! -d $(MARIADB_DIR) ]; then \
        mkdir -p $(MARIADB_DIR); \
        echo "Directory $(MARIADB_DIR) created."; \
    fi
	docker compose -f ./srcs/docker-compose.yml up -d --build


up:
	docker compose -f ./srcs/docker-compose.yml up -d

dw:
	docker compose -f ./srcs/docker-compose.yml down

prune: dw
	rm -rf $(WORDPRESS_DIR)
	rm -rf $(MARIADB_DIR)
	docker compose -f ./srcs/docker-compose.yml down --remove-orphans --volumes
	docker image prune -a -f
	docker system prune -f
	docker container prune -f

clean:
	docker stop $$(docker ps -qa);\
	docker rm $$(docker ps -qa);\
	docker rmi -f $$(docker images -qa);\
	docker volume rm  $$(docker volume ls -q);\
	docker network rm $$(docker network ls -q);\


# Tired of docker fucking up your life? Oh ive got the solution for you !
# Here are all the step for a quick uninstallation/installation of that piece of crap

uninstalldocker:
	sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras; \
	sudo rm -rf /var/lib/docker; \
	sudo rm -rf /var/lib/containerd; \
	cd && rm -rf .docker;

installdocker:
	sudo apt-get update; \
	sudo apt-get install ca-certificates curl gnupg -y; \
	sudo install -m 0755 -d /etc/apt/keyrings; \
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg; \
	sudo chmod a+r /etc/apt/keyrings/docker.gpg; \

# Copy and paste this part in console then use installdocker2: \
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	
installdocker2:
	sudo apt-get update; \
	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; \
	docker run hello-world; 


re: clean all