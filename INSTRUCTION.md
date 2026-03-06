### 1. Environment Preparation

Spin up the local cluster using `kind`:

```bash
kind create cluster --config cluster.yml --name todoapp-cluster
```

### 2. Deployment

Execute the automated bootstrap script:

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

### 3. Database Validation (MySQL)

* **Pod Status**: Run `kubectl get pods -n mysql` to verify that 3 pods (`mysql-0, 1, 2`) are running.
* **Storage**: Run `kubectl get pvc -n mysql` to ensure each pod has a unique disk named `data-mysql-X`.
* **Initialization**: Verify that the `tododb` database exists in the first pod:
```bash
kubectl exec -it mysql-0 -n mysql -- mysql -u root -p"my-secret-pw" -e "SHOW DATABASES;"
```



### 4. Application Validation (TodoApp)

* **Connectivity**: Check the application logs for successful database connection:
```bash
kubectl logs -l app=todoapp -n todoapp
```


* **Environment Check**: Verify the `HOST` points to `mysql-0.mysql.mysql.svc.cluster.local`:
```bash
kubectl describe secret app-secret -n todoapp
```

