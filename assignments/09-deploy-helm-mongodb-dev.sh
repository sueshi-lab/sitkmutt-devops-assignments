# create a secret
kubectl create secret generic bookinfo-dev-ratings-mongodb-secret \
  --from-literal=mongodb-password=CHANGEME \
  --from-literal=mongodb-root-password=CHANGEME

cd ratings/k8s
touch helm-values/values-bookinfo-dev-ratings-mongodb.yaml

echo 'image:
  tag: 5.0.3-debian-10-r30
auth:
  enabled: true
  username: ratings
  database: ratings
  existingSecret: bookinfo-dev-ratings-mongodb-secret
persistence:
  enabled: false
initdbScriptsConfigMap: bookinfo-dev-ratings-mongodb-initdb' >> k8s/helm-values/values-bookinfo-dev-ratings-mongodb.yaml

# configmap
kubectl create configmap bookinfo-dev-ratings-mongodb-initdb \
  --from-file=databases/ratings_data.json \
  --from-file=databases/script.sh

# deploy (helm install)
helm install -f k8s/helm-values/values-bookinfo-dev-ratings-mongodb.yaml \
  bookinfo-dev-ratings-mongodb bitnami/mongodb --version 10.28.4