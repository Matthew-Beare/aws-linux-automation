# Ansible control host

Run the Ansible playbook from a supported controller, such as Linux or Ubuntu under WSL. **Native Windows PowerShell is not an Ansible control node.** Terraform can be run independently on Windows.

The inventory supplies the target hosts and their Linux login accounts. Verify each target's SSH host key and make the administrator SSH public key available in the `ADMIN_SSH_PUBLIC_KEY` environment variable of the controller before running `ansible-playbook`.

The original lab ran successfully on Ubuntu and RHEL hosts. The public key-only configuration is a revised example with automated syntax checks.
