# k8s-init-restarter
Tool to kill pods which have failed init containers

## Usage
Just run it on cluster with correct RBAC : 
```
- apiGroups:
  - ""
  resources:
  - namespaces
  verbs:
  - get
  - list
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - delete
  - get
  - list
```
