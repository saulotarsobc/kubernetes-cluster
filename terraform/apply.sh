#! bash
terraform apply -auto-approve;
kubectl get svc,pods -n hcode -o wide;