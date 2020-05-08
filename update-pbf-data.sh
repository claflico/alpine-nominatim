#!/bin/sh

set -e

source /opt/variables.sh

update_continent_region() {
  CONTINENT_REGION=$1
  if [ ! -d $NOMINATIM_PBF_DIR/updates/ ]; then
    sudo -u $NOMINATIM_SYSTEM_USER mkdir -p $NOMINATIM_PBF_DIR/updates/
  fi
  CONTINENT_REGION_DIR=${CONTINENT_REGION//[\/]/-}
  if [ ! -d $NOMINATIM_PBF_DIR/updates/$CONTINENT_REGION_DIR ]; then
    sudo -u $NOMINATIM_SYSTEM_USER mkdir -p $NOMINATIM_PBF_DIR/updates/$CONTINENT_REGION_DIR
  fi
  if [ ! -f $NOMINATIM_PBF_DIR/updates/$CONTINENT_REGION_DIR/configuration.txt ]; then
    echo "Initializing updates for: ${CONTINENT_REGION}"
    sudo -u $NOMINATIM_SYSTEM_USER osmosis --rrii workingDirectory=$NOMINATIM_PBF_DIR/updates/$CONTINENT_REGION_DIR/
    sudo -u $NOMINATIM_SYSTEM_USER echo "baseUrl=${NOMINATIM_PBF_UPDATE_URL}/${CONTINENT_REGION}-updates" > $NOMINATIM_PBF_DIR/updates/$CONTINENT_REGION_DIR/configuration.txt
    sudo -u $NOMINATIM_SYSTEM_USER echo "maxInterval = ${NOMINATIM_PBF_UPDATE_MAX_INTERVAL}" >> $NOMINATIM_PBF_DIR/updates/$CONTINENT_REGION_DIR/configuration.txt
    echo "Downloading ${NOMINATIM_PBF_UPDATE_URL}/${CONTINENT_REGION}-updates/state.txt to ${NOMINATIM_PBF_DIR}/updates/${CONTINENT_REGION_DIR}/"
    sudo -u $NOMINATIM_SYSTEM_USER curl -k -# -L "${NOMINATIM_PBF_UPDATE_URL}/${CONTINENT_REGION}-updates/state.txt" -o "${NOMINATIM_PBF_DIR}/updates/${CONTINENT_REGION_DIR}/state.txt"
  fi
  #Get diff data
  echo "Getting diff data from ${NOMINATIM_PBF_UPDATE_URL}/${CONTINENT_REGION}-updates"
  sudo -u $NOMINATIM_SYSTEM_USER osmosis --rri workingDirectory=$NOMINATIM_PBF_DIR/updates/$CONTINENT_REGION_DIR/ --wxc $NOMINATIM_PBF_DIR/updates/$CONTINENT_REGION_DIR/diff.osc.gz 2>&1 | tee -a $NOMINATIM_DATA_DIR/update.log
  if [ -f $NOMINATIM_PBF_DIR/updates/$CONTINENT_REGION_DIR/diff.osc.gz ]; then
    #Import the diff data
    echo "Importing diff file ${NOMINATIM_PBF_DIR}/updates/${CONTINENT_REGION_DIR}/diff.osc.gz "
    sudo -u $NOMINATIM_SYSTEM_USER $NOMINATIM_BUILD_DIR/utils/update.php --osm2pgsql-cache $NOMINATIM_OSM2PGSQL_CACHE --import-diff $NOMINATIM_PBF_DIR/updates/$CONTINENT_REGION_DIR/diff.osc.gz $NOMINATIM_PBF_UPDATE_OPTS 2>&1 | tee -a $NOMINATIM_DATA_DIR/update.log
    rm -rf $NOMINATIM_PBF_DIR/updates/$CONTINENT_REGION_DIR/diff.osc.gz
  fi
}


if [ -f $NOMINATIM_PBF_UPDATE_LIST_FILE ]; then
  echo "STARTING PBF UPDATE: $(date)" 2>&1 | tee -a $NOMINATIM_DATA_DIR/update.log
  while IFS= read -r CONTINENT_REGION; do
    update_continent_region $CONTINENT_REGION
  done < "$NOMINATIM_PBF_UPDATE_LIST_FILE"
  #Update the index
  echo "Indexing Nominatim data: ${NOMINATIM_BUILD_DIR}/utils/update.php --osm2pgsql-cache ${NOMINATIM_OSM2PGSQL_CACHE} --index ${NOMINATIM_PBF_UPDATE_OPTS}"
  sudo -u $NOMINATIM_SYSTEM_USER $NOMINATIM_BUILD_DIR/utils/update.php --osm2pgsql-cache $NOMINATIM_OSM2PGSQL_CACHE --index $NOMINATIM_PBF_UPDATE_OPTS 2>&1 | tee -a $NOMINATIM_DATA_DIR/update.log
  echo "ENDING PBF UPDATE: $(date)" 2>&1 | tee -a $NOMINATIM_DATA_DIR/update.log
fi
