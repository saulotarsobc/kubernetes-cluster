#! bash
# kubectl delete all --all -n development;
# kubectl delete namespace development;
# kubectl delete -f deployment.yaml;

# deletar pods
kubectl delete pods --all -n development;
kubectl get all -n development -o wide;