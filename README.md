# blue-green-deployment

## configure AWS credentials to access the resources
> using action -> aws-actions/configure-aws-credentials@v1

## install docker client to run docker caommands
> using action -> docker-practice/actions-setup-docker@1.0.8

## get access to ECR repository 
> aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin [repo-uri]

## build docker image
> docker build -t flask-app:latest

## tag the image with the name of ECR repository
> docker tag flask-app:latest [repo-uri]:latest

## push the image to ECR
> docker push [repo-uri]:latest

## install kubectl to run kubernetes commands
> sudo snap install kubectl --classic

## configure access to EKS cluster by updating kube-config file
> aws eks --region ${{ secrets.REGION }} update-kubeconfig --name [cluster-name]

## get the version of current deployment
> export Version=$(kubectl get service flask-app-service -o=jsonpath='{.spec.selector.version}' --namespace=bg-ns)

## extract the version number from the version string and create a new version string
> export VersionNumber=$(echo $Version | sed 's/[^0-9]*//g') 

> export NewVersion="${Version:0:7}"$(expr $VersionNumber + 1)


## create a new deployment with new version
> kubectl get deployment flask-app-$Version -o=yaml --namespace=bg-ns | sed -e "s/$Version/$NewVersion/g" | kubectl apply --namespace=bg-ns -f - 

## wait for the new deployment to be live and healthy
> kubectl rollout status deployment/flask-app-$NewVersion --namespace=bg-ns 

## update the service file to redirect the traffic to new deployment
> kubectl get service flask-app-service -o=yaml --namespace=bg-ns | sed -e "s/$Version/$NewVersion/g" | kubectl apply --namespace=bg-ns -f - 

## delete the previous deployment(blue/green)
> kubectl delete deployment flask-app-$Version --namespace=bg-ns 

## view the new deployment and service 
> kubectl get deployment -n bg-ns

> kubectl get service -n bg-ns





