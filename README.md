## Setup

Requirements:

- Docker
- Docker Compose

Before running `docker-compose up -d` for the first time, you need to run the following commands:

```bash
docker-compose run --rm -v $HOME/.cache/composer:/tmp -e COMPOSER_HOME=/tmp php composer install
docker-compose run --rm node npm install
```

Now you can run:

```bash
docker-compose up -d
```

### Episode 04 - Setting up a production Kubernetes environment

During the video, I showed some manifest as examples, here are they if you want to copy the code:

**The Nginx Deployment**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world
spec:
  replicas: 3
  selector:
    matchLabels:
      app: hello-world-nginx
  template:
    metadata:
      labels:
        app: hello-world-nginx
    spec:
      containers:
        - name: hello-nginx
          image: nginx:1.17
          ports:
            - containerPort: 80
      restartPolicy: Always
```


**The Nginx LoadBalancer Service**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: hello-world-lb-svc
spec:
  ports:
    - name: http
      port: 80
      targetPort: 80
      protocol: TCP
  selector:
    app: hello-world-nginx
  type: LoadBalancer
```
