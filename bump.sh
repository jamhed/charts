#!/bin/bash -ae
NAME=$1
[ -z "$NAME" ] && (echo "Usage: $0 chart"; exit 1)
CHART=$(yq r $NAME/Chart.yaml version)
CHARTMINOR=$(echo $CHART | sed -E 's|^.*\.([0-9]+)$|\1|')
CHARTMAJOR=$(echo $CHART | sed -E 's|(.*)\.[0-9]+$|\1|')
NEWCHART="$CHARTMAJOR.$((CHARTMINOR+1))"
yq w -i $NAME/Chart.yaml version $NEWCHART
git commit $NAME/Chart.yaml -m "Bump chart:$NAME to $NEWCHART"
make
git add docs
git commit docs -m "Add release chart:$NAME:$NEWCHART"
git push
