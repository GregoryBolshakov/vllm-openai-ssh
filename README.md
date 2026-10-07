# vllm-openai-ssh

`vllm/vllm-openai` with `openssh-server` preinstalled, for RunPod pods that are
reached only through an SSH tunnel. With sshd already in the image, a pod does
not have to run `apt-get install openssh-server` on every boot.

    ghcr.io/gregorybolshakov/vllm-openai-ssh:v0.27.1

There are no host keys in the image. The boot script supplies the key from the
network volume. To build another vLLM version, run the workflow manually with
`vllm_version`.
