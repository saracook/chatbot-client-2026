This contains config files that are used as configmaps but are hard to read as configmaps; first one is jupyterhub_config.py

To recreate it; do:
kubectl -n jupyter create configmap jupyterhub-config --from-file=jupyterhub_config.py --dry-run=client -o yaml > ../namespaces/jupyter/jupyterhub-config-configmap.yaml
