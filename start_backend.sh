docker run -t --rm -v "${PWD}/map:/data" ghcr.io/project-osrm/osrm-backend osrm-extract -p /opt/car.lua /data/route-data.osm || echo "osrm-extract failed"
docker run -t --rm -v "${PWD}/map:/data" ghcr.io/project-osrm/osrm-backend osrm-contract /data/route-data.osrm || echo "osrm-partition failed"
docker run -t -i -p 5000:5000 -v "${PWD}/map:/data" ghcr.io/project-osrm/osrm-backend osrm-routed --algorithm ch /data/route-data.osrm
