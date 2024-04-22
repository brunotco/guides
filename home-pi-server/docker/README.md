# Docker

To install `Docker` you will need to set up the Docker repository.

## Set up Docker repository

First update and install required packages:

```sh
sudo apt-get update
sudo apt-get install ca-certificates curl
```

Now add Docker official GPG key:

```sh
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

To finish set up the repository:

```sh
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
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
