# Evidencias

```
dromero@Remulos tarea-final % kubectl apply -f entrega.yaml
namespace/ns-daniel-romero created
configmap/config-daniel-romero created
secret/secret-daniel-romero created
service/svc-daniel-romero created
deployment.apps/app-daniel-romero created
```

```
dromero@Remulos ~ % kubectl cluster-info
Kubernetes control plane is running at https://127.0.0.1:65164
CoreDNS is running at https://127.0.0.1:65164/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

```
dromero@Remulos ~ % kubectl get nodes
NAME                    STATUS   ROLES           AGE   VERSION
desktop-control-plane   Ready    control-plane   17d   v1.34.3
```

```
dromero@Remulos ~ % kubectl get pods -n ns-daniel-romero
NAME                                 READY   STATUS    RESTARTS   AGE
app-daniel-romero-57c87c9f98-2ftjf   1/1     Running   0          9m55s
app-daniel-romero-57c87c9f98-54zjz   1/1     Running   0          9m53s
app-daniel-romero-57c87c9f98-bgkpx   1/1     Running   0          9m52s
```

```
dromero@Remulos ~ % kubectl get deployment -n ns-daniel-romero
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
app-daniel-romero   3/3     3            3           13m
```

```
dromero@Remulos ~ % kubectl get svc -n ns-daniel-romero
NAME                TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
svc-daniel-romero   ClusterIP   10.96.16.138   <none>        80/TCP    13m
```

```
dromero@Remulos ~ % kubectl logs deployment/app-daniel-romero -n ns-daniel-romero
Found 3 pods, using pod/app-daniel-romero-57c87c9f98-2ftjf
[Nest] 1  - 06/08/2026, 2:35:22 AM     LOG [NestFactory] Starting Nest application...
[Nest] 1  - 06/08/2026, 2:35:22 AM     LOG [InstanceLoader] AppModule dependencies initialized +6ms
[Nest] 1  - 06/08/2026, 2:35:22 AM     LOG [RoutesResolver] AppController {/}: +3ms
[Nest] 1  - 06/08/2026, 2:35:22 AM     LOG [RouterExplorer] Mapped {/, GET} route +3ms
[Nest] 1  - 06/08/2026, 2:35:22 AM     LOG [RouterExplorer] Mapped {/lab, GET} route +0ms
[Nest] 1  - 06/08/2026, 2:35:22 AM     LOG [NestApplication] Nest application successfully started +5ms
```

```
dromero@Remulos ~ % kubectl exec deployment/app-daniel-romero -n ns-daniel-romero -- printenv
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=app-daniel-romero-57c87c9f98-2ftjf
NODE_VERSION=24.16.0
YARN_VERSION=1.22.22
AMBIENTE=desarrollo
API_KEY=RpjjprQ5LK5edAt4XwHYJmwkjpzdZnDVsrchrMNRdKE4b3V4Mpb1X3JFm3Usp2MkiwNTW5f0zPCTYNExPaAsQbPY4GVz0DZzJUNsXtKpeuOtdysXGJrx2te18xeNACQC67zU1lZ02uubvfLxB8GeeL9O8iLdULF2SXTpRDATtHWJCKk7hQ6tW7WGRRX788tK06bKJGXnKkjeu2e7oYJuLKRUROnRrGHDfQu5MX7r1JmGFjUkBI6sWP6H16BBWF0o
SVC_DANIEL_ROMERO_PORT_80_TCP=tcp://10.96.16.138:80
SVC_DANIEL_ROMERO_PORT_80_TCP_ADDR=10.96.16.138
KUBERNETES_PORT=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
SVC_DANIEL_ROMERO_SERVICE_PORT=80
SVC_DANIEL_ROMERO_PORT=tcp://10.96.16.138:80
SVC_DANIEL_ROMERO_PORT_80_TCP_PROTO=tcp
SVC_DANIEL_ROMERO_PORT_80_TCP_PORT=80
KUBERNETES_SERVICE_HOST=10.96.0.1
KUBERNETES_SERVICE_PORT=443
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT_443_TCP_PROTO=tcp
SVC_DANIEL_ROMERO_SERVICE_HOST=10.96.16.138
SVC_DANIEL_ROMERO_SERVICE_PORT_HTTP=80
HOME=/home/node
```

```
dromero@Remulos tarea-final % kubectl port-forward svc/svc-daniel-romero 8080:80 -n ns-daniel-romero
Forwarding from 127.0.0.1:8080 -> 3000
Forwarding from [::1]:8080 -> 3000
Handling connection for 8080

dromero@Remulos tarea-final % curl http://localhost:8080/lab
{"AMBIENTE":"desarrollo","API_KEY":"RpjjprQ5LK5edAt4XwHYJmwkjpzdZnDVsrchrMNRdKE4b3V4Mpb1X3JFm3Usp2MkiwNTW5f0zPCTYNExPaAsQbPY4GVz0DZzJUNsXtKpeuOtdysXGJrx2te18xeNACQC67zU1lZ02uubvfLxB8GeeL9O8iLdULF2SXTpRDATtHWJCKk7hQ6tW7WGRRX788tK06bKJGXnKkjeu2e7oYJuLKRUROnRrGHDfQu5MX7r1JmGFjUkBI6sWP6H16BBWF0o"}
```