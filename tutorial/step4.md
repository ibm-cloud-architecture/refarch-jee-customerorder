# Step 4. Write Kubernetes YAMLs, including Deployment and Services stanzas.

In this step, we are going to write the needed configuration files, deployment files, etc for a container orchestrator such as Kubernetes to get our Liberty app appropriately deployed onto our virtulized infrastructure.

## deployment.yaml

    ```
    apiVersion: v1
    kind: Service
    metadata:
      name: customerorderservices
      labels:
        app: customerorderservices
    spec:
      ports:
        - port: 80
          targetPort: 9080
      selector:
        app: customerorderservices
      type: ClusterIP
      
    ---
    apiVersion: extensions/v1beta1
    kind: Deployment
    metadata:
      labels:
        app: customerorderservices
      name: customerorderservices
    spec:
      replicas: 1
      strategy:
        rollingUpdate:
          maxSurge: 1
          maxUnavailable: 1
        type: RollingUpdate
      template:
        metadata:
          labels:
            app: customerorderservices
        spec:
          containers:
          - image: master.cfc:8500/websphere/customerorderservices:0.1
            imagePullPolicy: Always
            name: customerorderservices
            ports:
            - containerPort: 9080
              protocol: TCP
            resources: {}
            terminationMessagePath: /dev/termination-log
            terminationMessagePolicy: File
          dnsPolicy: ClusterFirst
          imagePullSecrets:
          - name: admin.registrykey
          restartPolicy: Always
          schedulerName: default-scheduler
          securityContext: {}
          terminationGracePeriodSeconds: 30
    ```
