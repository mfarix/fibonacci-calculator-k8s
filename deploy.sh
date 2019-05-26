export TAG=`if [ "$GIT_BRANCH" == "master" ]; then echo "latest"; else echo $GIT_BRANCH ; fi`

docker build -t $CLIENT_REPO:$GIT_COMMIT -t $CLIENT_REPO:$TAG -f ./client/Dockerfile ./client
docker build -t $SERVER_REPO:$GIT_COMMIT -t $SERVER_REPO:$TAG -f ./server/Dockerfile ./server
docker build -t $WORKER_REPO:$GIT_COMMIT -t $WORKER_REPO:$TAG -f ./worker/Dockerfile ./worker

docker push $CLIENT_REPO
docker push $SERVER_REPO
docker push $WORKER_REPO

kubectl apply -f k8s

kubectl set image deployments/worker-deployment server=$WORKER_REPO:$GIT_COMMIT
kubectl set image deployments/server-deployment server=$SERVER_REPO:$GIT_COMMIT
kubectl set image deployments/client-deployment server=$CLIENT_REPO:$GIT_COMMIT
