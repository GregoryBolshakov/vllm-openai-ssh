# vLLM image with OpenSSH baked in.
#
# The stock image has no sshd, so every pod boot runs apt-get update + install
# before the tunnel can come up: ~20s when the mirrors are healthy, and a hard
# dependency on them when they are not. boot.py skips that step whenever
# /usr/sbin/sshd already exists, so this image needs no other change.
#
# Build and push (to a registry RunPod can pull from), then point rp at it:
#   docker build -t <registry>/<you>/vllm-openai-ssh:v0.27.1 docker/
#   docker push <registry>/<you>/vllm-openai-ssh:v0.27.1
#   VLLM_IMAGE=<registry>/<you>/vllm-openai-ssh:v0.27.1   (config or profile)
# Keep the tag in step with VLLM_VERSION: the startup cache is keyed by image.
ARG VLLM_VERSION=v0.27.1
FROM vllm/vllm-openai:${VLLM_VERSION}

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends openssh-server \
 && rm -rf /var/lib/apt/lists/* \
 # Host keys come from the network volume at boot (boot.py); never ship any.
 && rm -f /etc/ssh/ssh_host_* \
 && mkdir -p /var/run/sshd

# The image's own entrypoint is replaced by rp's boot script (dockerEntrypoint).
