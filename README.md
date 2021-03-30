# oci-hub-spoke
## Deploy and manage the network and compute layers of a hub-spoke topology using Terraform

### Workshop Prerequisites
- Access to an OCI Tenancy (account)
- OCI Policies:
<pre>
Allow group GROUPNAME to manage instance-family in compartment COMPARTMENTNAME
Allow group GROUPNAME to manage virtual-network-family in compartment COMPARTMENTNAME
Allow group GROUPNAME to read app-catalog-listing in tenancy
</pre>
- Sufficient availability of resources. You can check resource availability:
<pre>
Hamburger Menu &gt Governance &gt Limits, Quotas and Usage
</pre>

### Deployment via Resource Manager
##### Recommended for first time users of this project. The 'Configure Variables' page in Resource Manager helps users provide valid input.
1. [Download this project](https://github.com/scacela/oci-hub-spoke/archive/refs/heads/main.zip) to your local machine.
2. Navigate to [cloud.oracle.com](https://cloud.oracle.com/) on a web browser.
3. Sign into OCI.
4. Click the hamburger icon.
5. Hover over 'Resource Manager' from the dropdown menu, and click 'Stacks'.
6. Under 'List Scope', Select the Compartment where you wish to create the stack.
7. Click 'Create Stack'.
8. On the 'Stack Information' page, under 'Stack Configuration', browse for and select the this project folder from your local machine.
9. Click 'Next'.
10. On the 'Configure Variables' page, edit the variables that will influence the stack topology according to your preferences.
12. Click 'Next'.
12. On the 'Review' page, review your choices for the stack deployment.
13. Click 'Create'.
14. Click 'Terraform Actions' > 'Apply' > 'Apply'.
15. You can track the logs associated with the job by clicking Jobs > Logs. After the deployment has finished, review the output information at the bottom of the logs for instructions on how to access the nodes in the topology. You can also find outputs at Jobs > Outputs.

### Deployment via CLI Terraform


1. [Download this project](https://github.com/scacela/oci-hub-spoke/archive/refs/heads/main.zip) to your local machine.
2. [Set up CLI Terraform on your local machine.](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformgetstarted.htm) 
3. Navigate to project folder on your local machine via CLI.
<pre>
cd YOUR_PATH/oci-hub-spoke
</pre>
4. Open env.sh and edit the variables of prefix 'TF_VAR_', which will influence the stack topology according to your preferences.
<pre>
vi env.sh
</pre>
5. Export the TF_VAR_ variables to the environment of the CLI instance.
<pre>
source env.sh
</pre>
6. Open the files of prefix 'variables-' at the base directory and edit the default values of the objects of type 'variable', which will influence the stack topology according to your preferences.
<pre>
vi variables-common.tf
vi variables-compute.tf
vi variables-network.tf
</pre>
7. Initialize your Terraform project, downloading necessary packages for the deployment.
<pre>
terraform init
</pre>
8. View the plan of the Terraform deployment, and confirm that the changes described in the plan reflect the changes you wish to make in your OCI environment.
<pre>
terraform plan
</pre>
9. Apply the changes described in the plan, and answer yes when prompted for confirmation.
<pre>
terraform apply
</pre>
10. You can track the logs associated with the job by monitoring the output on the CLI. After the deployment has finished, review the output information at the bottom of the logs for instructions on how to access the nodes in the topology.