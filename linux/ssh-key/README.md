# SSH key authentication

## Create SSH key
First you need to generate a public/private key pair.
You can do it by using:

```sh
ssh-keygen
```

You will be prompted to set a location and file to save the key, you can leave the default (id_rsa, in .ssh folder, inside user home dir - `/home/admin/.ssh/id_rsa`) or choose another location and name. Despite what you choose just ensure that the folder permissions are as `700` and the owner as your own user. If you need to set this do it with, replacing `user`, `group` and `folder` accordingly:

```sh
# ~/.ssh/ - if not default, replace
# admin:admin - replace with your user and group
sudo chmod 700 ~/.ssh/
sudo chown admin:admin ~/.ssh/
```

Next you can define a passphrase for extra security, this is optional but recommended as this means that if anyone gets a hold of the private key they can access your device without entering a password.

## Enable SSH key
Now that the key is created you need to tell the device to trust the key, you can do this two ways.

### Manually
Copy the content of the generated `.pub` key and paste it inside `~/.ssh/authorized_keys`, then ensure the permissions of the file, you can do this with:

```sh
# Edit the file
nano ~/.ssh/authorized_keys
# Set permissions
# admin:admin - replace with your user and group
sudo chmod 644 ~/.ssh/authorized_keys
sudo chown admin:admin ~/.ssh/authorized_keys
```

### Using SSH tools
You just need to run the command, changing the `folder` and `destination` accordingly:

```sh
# ~/.ssh/id_rsa.pub - if not default, replace
# pi - replace with hostname or ip
ssh-copy-id -i ~/.ssh/id_rsa.pub pi
```

If asked if you want to continue connecting say `yes`, then when asked enter your password.

## Using SSH key
With the SSH key now saved and the permissions correctly set you can now login, just using the private key (the one that doesn't have `.pub`).

## Disable password authentication
If you are using SSH key for authentication you can disable SSH password authentication.

For this you need to change a setting in `sshd_config` with:

```sh
sudo nano /etc/ssh/sshd_config
```

Search the line with the option `PasswordAuthentication` from `yes` to `no`, if the line is commented you need to uncomment it also.

For the changes to take effect you need to restart the device.