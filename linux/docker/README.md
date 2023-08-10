# Docker

## Set up Docker repository
To install `Docker` you will need to set up the Docker repository.

First update and install required packages:

```sh
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
```

Now add Docker official GPG key:

```sh
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/raspbian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

To finish set up the repository:

```sh
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/raspbian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

```

## Install Docker
Now we can install the `Docker` engine, first update the packages with the newly added Docker repository:

```sh
sudo apt-get update
```

Now you can in install `Docker`:

```sh
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

## Usage
You can use `Docker` by command line but if you would like to have a Web UI, were you can manage images, containers and all related stuff you can use `Portainer`.

You can deploy portainer with docker run command:

```sh
sudo docker run -d \
  -p 9443:9443 \
  --name portainer \
  --restart unless-stopped \
  -v data:/data \
  -v /var/run/docker.sock:/var/run/docker.sock \
  portainer/portainer-ce:latest
```

You can also use it with docker compose, for more instructions see the docker compose files on another repo.