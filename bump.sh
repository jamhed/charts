#!/bin/bash -ae
NAME=$1
[ -z "$NAME" ] && (echo "Usage: $0 chart"; exit 1)
CHART=$(yq r $NAME/Chart.yaml version)
CHARTMINOR=$(echo $CHART | sed -E 's|^.*\.([0-9]+)$|\1|')
CHARTMAJOR=$(echo $CHART | sed -E 's|(.*)\.[0-9]+$|\1|')
NEWCHART="$CHARTMAJOR.$((CHARTMINOR+1))"
yq w -i $NAME/Chart.yaml appVersion $NEWVER
yq w -i $NAME/Chart.yaml version $NEWCHART
git commit $NAME/Chart.yaml -m "Bump chart version to app:v$NEWVER chart:$NEWCHART"
make helm
git add docs
git commit docs -m "Bump chart release to v$NEWVER"
git push --tags
git push
