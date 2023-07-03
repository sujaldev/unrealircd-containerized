# UnrealIRCd Containerized

Builds a docker/podman container with default options (you can change the `config.settings` file to change build
parameters).

## Usage

```bash
# Build Image
docker compose build

# Configure
# Some values must be changed in the config file, otherwise the container will not start.
mkdir conf
docker run --rm --entrypoint cat unrealircd-containerized /app/conf/examples/example.conf > ./conf/unrealircd.conf

# To generate cloak values
docker run --rm -it --entrypoint "" unrealircd-containerized /app/unrealircd gencloak

# Start
docker compose up -d
```
