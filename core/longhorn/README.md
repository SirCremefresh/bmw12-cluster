kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/master/deploy/longhorn.yaml



# label nodes
k label nodes srv01 longhorn=
k label nodes srv02 longhorn=
