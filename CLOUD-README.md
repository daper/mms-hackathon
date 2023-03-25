### Cloud Infrastructure

##### Permissions
I had to grant myself the role `Administrador de Kubernetes Engine`.

##### Gather cluster credentials
```
gcloud container clusters get-credentials \
  anxzsvl9qyjsvznb6wlvsso6l6qeg9-gke \
  --region europe-southwest1 \
  --project anxzsvl9qyjsvznb6wlvsso6l6qeg9
```