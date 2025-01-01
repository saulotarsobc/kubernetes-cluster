#! bash
kubectl apply -f deployment.yaml;
kubectl get all -n development -o wide;