git clone https://github.com/netdata/helmchart.git netdata-helmchart
cd netdata-helmchart && git pull && cd ..

kubectl create namespace netdata
helm install --namespace=netdata netdata ./netdata-helmchart -f netdata-helmchart/values.yaml -f netdata-values.yaml
helm upgrade --namespace=netdata netdata ./netdata-helmchart -f netdata-helmchart/values.yaml -f netdata-values.yaml



export POD_NAME=$(kubectl get pods --namespace netdata -l "app=netdata,release=netdata" -o jsonpath="{.items[0].metadata.name}")
echo "Visit http://127.0.0.1:8080 to use your application"
kubectl -n netdata port-forward $POD_NAME 8080:19999

