# AWS Linux Automation Lab

**Terraform · Ansible · AWS EC2 · Linux**

For my network deployment coursework, I used Terraform to deploy Ubuntu and RHEL servers in AWS, then used Ansible to configure administrator accounts on both. I verified SSH connectivity, account creation and group membership, and finished with no failed or unreachable tasks.

This repository contains a standalone version of that lab. Terraform defines the EC2 instances; Ansible handles Linux accounts and SSH keys.

## Lab results

Terraform provisioned Ubuntu and RHEL hosts, and the original Ansible playbook completed successfully on both:

```text
PLAY RECAP
rhel      : ok=3  changed=2  unreachable=0  failed=0
ubuntu    : ok=3  changed=2  unreachable=0  failed=0
```

The output above is from the original lab. The code here is a revised version that uses SSH keys and locks password authentication for its maintenance account. GitHub Actions validates the revised Terraform configuration and Ansible playbook syntax; this revision hasn't been deployed end to end.

## What it sets up

- Terraform provisions the EC2 instances listed in an input map. The sample defines an Ubuntu host and a RHEL-compatible host.
- An AWS security group permits SSH from a single administrator IPv4 address (`/32`). EC2 metadata requires IMDSv2, and the root volumes are encrypted.
- Ansible creates a maintenance account, adds the supplied public SSH key, and locks password authentication for that account. The administrative group is `sudo` on Ubuntu or `wheel` on RHEL-family systems.

The example expects an existing VPC, subnet, EC2 key pair, and appropriate AMIs. It uses public instance IPs for a disposable lab, not a recommended production design.

## Try it in a test account

Review the Terraform plan before creating anything. EC2 resources can incur charges.

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Replace the sample values with your own account, AMIs and network IDs.
terraform init
terraform validate
terraform plan
# terraform apply   # Only after reviewing the plan and costs
```

Then configure the actual host addresses in `ansible/inventory.ini`:

```bash
cd ../ansible
cp inventory.example.ini inventory.ini
ansible-galaxy collection install -r requirements.yml
export ADMIN_SSH_PUBLIC_KEY="$(cat ~/.ssh/id_ed25519.pub)"
ansible-playbook -i inventory.ini provision_admin.yml
```

Use the correct `admin_group` for each OS. On PowerShell, the public key can be read with `(Get-Content "$HOME\.ssh\id_ed25519.pub" -Raw).Trim()`.

## Testing

GitHub Actions runs Terraform validation and an Ansible syntax check. I have **not** yet tested the revised public files through a live Terraform apply, Ansible run, repeat run for idempotency, and teardown. Those are still needed before treating the example as deployment-tested.

I adapted the coursework into this standalone example with AI assistance during cleanup.
