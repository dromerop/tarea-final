# Repositorios
```
Código: https://github.com/dromerop/tarea-final
GitHub: https://github.com/users/dromerop/packages/container/package/tarea-final
DockerHub: https://hub.docker.com/repository/docker/dromerocl/tarea-final/general
```

# 1. Build manual de Dockerfile

```
docker build -t tarea-final .
```

# 2. Publicación Manual

## 2.1 DockerHub

```
Login:

echo $DH_TOKEN | docker login -u dromerocl --password-stdin
```

```
docker tag tarea-final dromerocl/tarea-final:daniel-romero
docker tag tarea-final dromerocl/tarea-final:latest
docker tag tarea-final dromerocl/tarea-final:0.0.1
docker push dromerocl/tarea-final:daniel-romero
docker push dromerocl/tarea-final:latest
docker push dromerocl/tarea-final:0.0.1
```

## 2.2 GitHub

```
Login:

echo $GH_TOKEN | docker login ghcr.io -u dromerop --password-stdin
```

```
docker tag tarea-final ghcr.io/dromerop/tarea-final:daniel-romero
docker tag tarea-final ghcr.io/dromerop/tarea-final:latest
docker tag tarea-final ghcr.io/dromerop/tarea-final:0.0.1
docker push ghcr.io/dromerop/tarea-final:daniel-romero
docker push ghcr.io/dromerop/tarea-final:latest
docker push ghcr.io/dromerop/tarea-final:0.0.1
```

## 2.3 Creación de secrets
```
kubectl create secret docker-registry regcred-dh \
--docker-server=https://index.docker.io/v1/ \
--docker-username=dromerocl \          
--docker-password=<TOKEN> \    
--docker-email=<EMAIL> \
--namespace jenkins   

kubectl create secret docker-registry regcred-gh \
--docker-server=https://ghcr.io \            
--docker-username=dromerop \
--docker-password=<TOKEN> \
--docker-email=<EMAIL> \
--namespace jenkins
```

# 3. Kubernetes

## 3.1 Deployment

Crear deployment:
```
kubectl apply -f entrega.yaml 
```
Eliminar deployment y objetos relacionados:
```
kubectl delete -f entrega.yaml
```

# 4. Jenkins 

## 4.1 Credenciales para Kubernetes

En http://jenkins.local/job/tarea-final/credentials/ crear credencial global de tipo Secret File con 
ID credenciales-kubernetes cuyo contenido sea el archivo config existente en nuestro $HOME/.kube

## 4.2 Pipeline

En http://jenkins.local/view/all/newJob crear nueva Multibranch Pipeline, que tenga un Branch Source 
apuntando a https://github.com/dromerop/tarea-final con sus respectivas credenciales de GitHub

# 6. Publicación automática de imagen en GitHub y DockerHub y actualización de Deployment
  
   Pipeline referenciado en 4.2 se encarga de monitorear cambios en el repositorio https://github.com/dromerop/tarea-final, 
   construir la imagen, crear tags, publicar dichos tags en GitHub y DockerHub para luego actualizar
   el Deployment app-daniel-romero con la imagen recién creada.