# Start minikube
minikube start --disk-size=40g --extra-disks=1 --driver kvm2 -n 2

# Rook-Ceph pods init
cd rook/deploy/examples
k create -f crds.yaml -f common.yaml -f operator.yaml
k create -f cluster-test.yaml -f filesystem-test.yaml -f nfs-test.yaml

#WARNING: wait untill all pods are running

# Use ceph tools for export the filesystem
k exec -it -n rook-ceph rook-ceph-tools-[code of tools pod] -- bash
# Enable necessary modules
ceph  mgr module enable rook 
ceph mgr module enable nfs 
ceph orch set backend rook 
# Create the new export
ceph nfs export create cephfs my-nfs /test myfs 
ceph nfs export ls my-nfs 
# Disable modules
ceph mgr module disable nfs 
ceph mgr module disable rook
exit

# Patch the service as a NodePort
k patch service -n rook-ceph -p '{"spec":{"type": "NodePort"}}' rook-ceph-nfs-my-nfs-a
