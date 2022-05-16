#!/bin/bash -ae
NAME=$1
[ -z "$NAME" ] && (echo "Usage: $0 chart"; exit 1)
CHART=$(yq e .version $NAME/Chart.yaml)
CHARTMINOR=$(echo $CHART | sed -E 's|^.*\.([0-9]+)$|\1|')
CHARTMAJOR=$(echo $CHART | sed -E 's|(.*)\.[0-9]+$|\1|')
NEWCHART="$CHARTMAJOR.$((CHARTMINOR+1))"
yq -i ".version=\"$NEWCHART\"" $NAME/Chart.yaml
git commit $NAME/Chart.yaml -m "Bump chart:$NAME to $NEWCHART"
helm package $NAME -d docs
helm repo index docs --url https://jamhed.github.io/charts
git add docs
git commit docs -m "Add release chart:$NAME:$NEWCHART"
git push
