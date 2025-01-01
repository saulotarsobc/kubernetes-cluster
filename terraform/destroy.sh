#! bash
terraform destroy -auto-approve;
kubectl get svc,pods -n hcode -o wide;