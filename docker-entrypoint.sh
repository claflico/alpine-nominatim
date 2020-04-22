#!/bin/sh

set -e

source /opt/variables.sh

##### START WRITE SYSTEM CONF FILES #####
function write_fpmpool_conf() {
  if [ ! -d $PHPFPM_CONF_FILEDIR ]; then
    mkdir -p $PHPFPM_CONF_FILEDIR
  fi
  echo "[global]" > $PHPFPM_CONF_FILE
  echo "error_log = ${PHPFPM_STDERR_FILE}" >> $PHPFPM_CONF_FILE
  echo "[www]" >> $PHPFPM_CONF_FILE
  echo "user = ${PHPFPM_USER}" >> $PHPFPM_CONF_FILE
  echo "group = ${PHPFPM_GROUP}" >> $PHPFPM_CONF_FILE
  echo "listen = ${PHPFPM_LISTEN}" >> $PHPFPM_CONF_FILE
  echo "pm.status_path = ${PHPFPM_STATUS_PATH}" >> $PHPFPM_CONF_FILE
  echo "pm = ${PHPFPM_PROCESS_MANAGER}" >> $PHPFPM_CONF_FILE
  echo "pm.max_children = ${PHPFPM_MAX_CHILDREN}" >> $PHPFPM_CONF_FILE
  if [[ "x${PHPFPM_PROCESS_MANAGER}" == "xondemand" ]]; then
    echo "pm.process_idle_timeout = ${PHPFPM_PROCESS_IDLE_TIMEOUT};" >> $PHPFPM_CONF_FILE
  fi
  echo "pm.max_requests = ${PHPFPM_MAX_REQUESTS}" >> $PHPFPM_CONF_FILE
  echo "clear_env = ${PHPFPM_CLEAR_ENV}" >> $PHPFPM_CONF_FILE
  echo "catch_workers_output = ${PHPFPM_CATCH_WORKERS_OUTPUT}" >> $PHPFPM_CONF_FILE
  echo "decorate_workers_output = ${PHPFPM_DECORATE_WORKERS_OUTPUT}" >> $PHPFPM_CONF_FILE
  echo "ping.path = ${PHPFPM_PING_PATH}" >> $PHPFPM_CONF_FILE
}

function update_nginx_conf() {
  sed -i 's/NGINX_WORKER_PROCESSES/'"${NGINX_WORKER_PROCESSES}"'/' $NGINX_CONF_FILE
  sed -i 's/NGINX_WORKER_CONNECTIONS/'"${NGINX_WORKER_CONNECTIONS}"'/' $NGINX_CONF_FILE
  sed -i 's/NGINX_STDERR_FILE/'"${NGINX_STDERR_FILE//\//\\/}"'/' $NGINX_CONF_FILE
  sed -i 's/NGINX_STDOUT_FILE/'"${NGINX_STDOUT_FILE//\//\\/}"'/' $NGINX_CONF_FILE
  sed -i 's/NGINX_KEEPALIVE_TIMEOUT/'"${NGINX_KEEPALIVE_TIMEOUT}"'/' $NGINX_CONF_FILE
  sed -i 's/NGINX_HTTP_PORT/'"${NGINX_HTTP_PORT}"'/' $NGINX_DEFAULT_CONF_FILE
  sed -i 's/PHPFPM_LISTEN/'"${PHPFPM_LISTEN//\//\\/}"'/' $NGINX_DEFAULT_CONF_FILE
  sed -i 's/PHPFPM_PING_PATH/'"${PHPFPM_PING_PATH//\//\\/}"'/' $NGINX_DEFAULT_CONF_FILE
  sed -i 's/PHPFPM_PING_STATUS_ALLOW/'"${PHPFPM_PING_STATUS_ALLOW//\//\\/}"'/' $NGINX_DEFAULT_CONF_FILE
  sed -i 's/PHPFPM_STATUS_PATH/'"${PHPFPM_STATUS_PATH//\//\\/}"'/' $NGINX_DEFAULT_CONF_FILE
  sed -i 's/NGINX_ROOT_DIR/'"${NGINX_ROOT_DIR//\//\\/}"'/' $NGINX_DEFAULT_CONF_FILE
  sed -i 's/NGINX_SENDFILE/'"${NGINX_SENDFILE}"'/' $NGINX_DEFAULT_CONF_FILE
}

function write_supervisord_conf() {
  if [ ! -d $SUPERVISORD_CONF_FILEDIR ]; then
    mkdir -p $SUPERVISORD_CONF_FILEDIR
  fi
  echo "[supervisord]" > $SUPERVISORD_CONF_FILE
  echo "nodaemon=true" >> $SUPERVISORD_CONF_FILE
  echo "logfile=${SUPERVISORD_LOG_FILE}" >> $SUPERVISORD_CONF_FILE
  echo "logfile_maxbytes=0" >> $SUPERVISORD_CONF_FILE
  echo "pidfile=${SUPERVISORD_PID_FILE}" >> $SUPERVISORD_CONF_FILE
  echo "user=${SUPERVISORD_USER}" >> $SUPERVISORD_CONF_FILE
  echo "[program:php-fpm]" >> $SUPERVISORD_CONF_FILE
  echo "command=${PHPFPM_COMMAND}" >> $SUPERVISORD_CONF_FILE
  echo "stdout_logfile=${PHPFPM_STDOUT_FILE}" >> $SUPERVISORD_CONF_FILE
  echo "stdout_logfile_maxbytes=0" >> $SUPERVISORD_CONF_FILE
  echo "stderr_logfile=${PHPFPM_STDERR_FILE}" >> $SUPERVISORD_CONF_FILE
  echo "stderr_logfile_maxbytes=0" >> $SUPERVISORD_CONF_FILE
  echo "autorestart=false" >> $SUPERVISORD_CONF_FILE
  echo "startretries=0" >> $SUPERVISORD_CONF_FILE
  echo "[program:nginx]" >> $SUPERVISORD_CONF_FILE
  echo "command=nginx -g 'daemon off;'" >> $SUPERVISORD_CONF_FILE
  echo "stdout_logfile=${NGINX_STDOUT_FILE}" >> $SUPERVISORD_CONF_FILE
  echo "stdout_logfile_maxbytes=0" >> $SUPERVISORD_CONF_FILE
  echo "stderr_logfile=${NGINX_STDERR_FILE}" >> $SUPERVISORD_CONF_FILE
  echo "stderr_logfile_maxbytes=0" >> $SUPERVISORD_CONF_FILE
  echo "autorestart=false" >> $SUPERVISORD_CONF_FILE
  echo "startretries=0" >> $SUPERVISORD_CONF_FILE
  if [[ "x${NOMINATIM_POSTGRES_HOST}" == "x" ]]; then
    echo "[program:postgres]" >> $SUPERVISORD_CONF_FILE
    echo "command=/usr/bin/postgres" >> $SUPERVISORD_CONF_FILE
    echo "user=postgres" >> $SUPERVISORD_CONF_FILE
    echo "stdout_logfile=${POSTGRES_STDOUT_FILE}" >> $SUPERVISORD_CONF_FILE
    echo "stdout_logfile_maxbytes=0" >> $SUPERVISORD_CONF_FILE
    echo "stderr_logfile=${POSTGRES_STDERR_FILE}" >> $SUPERVISORD_CONF_FILE
    echo "stderr_logfile_maxbytes=0" >> $SUPERVISORD_CONF_FILE
    echo "autorestart=false" >> $SUPERVISORD_CONF_FILE
    echo "startretries=0" >> $SUPERVISORD_CONF_FILE
  fi
}

function config_postgres() {
  if [ ! -f $POSTGRES_CONF_FILE ]; then
    sudo -u postgres initdb -D $POSTGRES_DATA_DIR
    echo "listen_addresses='*'" >> $POSTGRES_CONF_FILE
    echo "include = '${POSTGRES_CONF_INCLUDE_FILE}'" >> $POSTGRES_CONF_FILE
    write_postgres_include_conf
    sudo -u postgres pg_ctl --silent start -D $POSTGRES_DATA_DIR
    sudo -u postgres psql postgres -tAc "ALTER SYSTEM SET fsync TO 'off'"
    sudo -u postgres psql postgres -tAc "ALTER SYSTEM SET full_page_writes TO 'off'"
  else
    write_postgres_include_conf
  fi
}

function write_postgres_include_conf() {
  echo "autovacuum_work_mem = ${POSTGRES_AUTOVACUUM_WORK_MEM}" > $POSTGRES_CONF_INCLUDE_FILE
  echo "checkpoint_completion_target = ${POSTGRES_CHECKPOINT_COMPLETION_TARGET}" >> $POSTGRES_CONF_INCLUDE_FILE
  echo "checkpoint_timeout = ${POSTGRES_CHECKPOINT_TIMEOUT}" >> $POSTGRES_CONF_INCLUDE_FILE
  echo "effective_cache_size = ${POSTGRES_EFFECTIVE_CACHE_SIZE}" >> $POSTGRES_CONF_INCLUDE_FILE
  echo "maintenance_work_mem = ${POSTGRES_MAINTENANCE_WORK_MEM}" >> $POSTGRES_CONF_INCLUDE_FILE
  echo "max_wal_size = ${POSTGRES_MAX_WAL_SIZE}" >> $POSTGRES_CONF_INCLUDE_FILE
  echo "shared_buffers = ${POSTGRES_SHARED_BUFFERS}" >> $POSTGRES_CONF_INCLUDE_FILE
  echo "synchronous_commit = ${POSTGRES_SYNCHRONOUS_COMMIT}" >> $POSTGRES_CONF_INCLUDE_FILE
  echo "work_mem = ${POSTGRES_WORK_MEM}" >> $POSTGRES_CONF_INCLUDE_FILE
}
##### END WRITE SYSTEM CONF FILES #####


##### START NOMINATIM CONFIG UPDATE #####
function manage_nominatim_creds() {
  grep -c $NOMINATIM_SYSTEM_USER /etc/group | grep -q 1 || addgroup -g $NOMINATIM_SYSTEM_UID -S $NOMINATIM_SYSTEM_USER
  grep -c $NOMINATIM_SYSTEM_USER /etc/passwd | grep -q 1 || adduser -S -D -u $NOMINATIM_SYSTEM_UID -G $NOMINATIM_SYSTEM_USER $NOMINATIM_SYSTEM_USER
  # If postgres is local and is mounted volume users could have changed
  if [[ "x${NOMINATIM_POSTGRES_HOST}" == "x" ]]; then
    [ ! -f "${POSTGRES_DATA_DIR}/postmaster.pid" ] && sudo -u postgres pg_ctl --silent start -D $POSTGRES_DATA_DIR || echo "" #HACK
    sudo -u postgres psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='${NOMINATIM_SYSTEM_USER}'" | grep -q 1 || sudo -u postgres createuser -s $NOMINATIM_SYSTEM_USER
    sudo -u postgres psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='${NOMINATIM_DB_WEB_USER}'" | grep -q 1 || sudo -u postgres createuser -SDR $NOMINATIM_DB_WEB_USER
    [ -f "${NOMINATIM_DATA_DIR}/setup-finished.txt" ] && sudo -u postgres pg_ctl --silent stop -D $POSTGRES_DATA_DIR || echo "" #HACK
  fi
}

function manage_nominatim_perms() {
  chown -R $NOMINATIM_SYSTEM_USER:$NOMINATIM_SYSTEM_USER $NOMINATIM_HOME
}

function write_nominatim_local() {
  echo "<?php" > $NOMINATIM_LOCAL_FILE
  echo "@define('CONST_Postgresql_Version', '${NOMINATIM_POSTGRES_VERSION}');" >> $NOMINATIM_LOCAL_FILE
  echo "@define('CONST_Postgis_Version', '${NOMINATIM_POSTGIS_VERSION}');" >> $NOMINATIM_LOCAL_FILE
  echo "@define('CONST_Website_BaseURL', '${NOMINATIM_WEBSITE_BASEURL}');" >> $NOMINATIM_LOCAL_FILE
  echo "@define('CONST_Database_Web_User', '${NOMINATIM_DB_WEB_USER}');" >> $NOMINATIM_LOCAL_FILE
  echo "@define('CONST_Import_Style', CONST_BasePath.'/settings/${NOMINATIM_IMPORT_STYLE}');" >> $NOMINATIM_LOCAL_FILE
#  if [[ "x${NOMINATIM_FLATNODE_ENABLE}" == "xtrue" ]]; then
#    echo "@define('CONST_Osm2pgsql_Flatnode_File', '${NOMINATIM_FLATNODE_FILE}');" >> $NOMINATIM_LOCAL_FILE
#  fi
  # If postgres host is used
  if [[ "x${NOMINATIM_POSTGRES_HOST}" != "x" ]]; then
    if [[ "x${NOMINATIM_POSTGRES_PORT}" != "x" ]] && [[ "x${NOMINATIM_POSTGRES_USER}" != "x" ]] && [[ "x${NOMINATIM_POSTGRES_PASSWORD}" != "x" ]] && [[ "x${NOMINATIM_POSTGRES_DB}" != "x" ]]; then
      echo "@define('CONST_Database_DSN', 'pgsql:host=${NOMINATIM_POSTGRES_HOST};port=${NOMINATIM_POSTGRES_PORT};user=${NOMINATIM_POSTGRES_USER};password=${NOMINATIM_POSTGRES_PASSWORD};dbname=${NOMINATIM_POSTGRES_DB}');" >> $NOMINATIM_LOCAL_FILE
    else
      echo "ERROR: NOMINATIM_POSTGRES_HOST is set but one of the following is empty: NOMINATIM_POSTGRES_PORT, NOMINATIM_POSTGRES_USER, NOMINATIM_POSTGRES_PASSWORD, NOMINATIM_POSTGRES_DB"
      echo "Cannot continue...."
      exit 1
    fi

  fi
}
##### END NOMINATIM CONFIG UPDATE #####


##### START MANAGE NOMINATIM DATA/PDF FILES #####
# Download optional data files for import
function check_nominatim_data_files() {
  check_data_file $NOMINATIM_DATA_GB_POSTCODE_ENABLE $NOMINATIM_DATA_GB_POSTCODE_URL
  check_data_file $NOMINATIM_DATA_US_POSTCODE_ENABLE $NOMINATIM_DATA_US_POSTCODE_URL
  check_data_file $NOMINATIM_DATA_WIKIPEDIA_ARTICLE_ENABLE $NOMINATIM_DATA_WIKIPEDIA_ARTICLE_URL
  check_data_file $NOMINATIM_DATA_WIKIPEDIA_REDIRECT_ENABLE $NOMINATIM_DATA_WIKIPEDIA_REDIRECT_URL
}

function check_data_file() {
  DATA_FILE_ENABLE=$1
  DATA_FILE_URL=$2
  if [[ "x${DATA_FILE_ENABLE}" == "xtrue" ]]; then
    DATA_FILE=${DATA_FILE_URL##*/}
    if [ ! -f $NOMINATIM_DATA_DIR/$DATA_FILE ]; then
      download_data_file $DATA_FILE_URL $DATA_FILE
    fi
  fi
}

# Download the data file
function download_data_file() {
  DATA_FILE_URL=$1
  DATA_FILE=$2
  echo "Downloading ${DATA_FILE_URL}....to ${NOMINATIM_DATA_DIR}"
  sudo -u $NOMINATIM_SYSTEM_USER curl -k -# -L "${DATA_FILE_URL}" -o "${NOMINATIM_DATA_DIR}/${DATA_FILE}"
}

function check_nominatim_pbf_files() {
  if [ ! -d $NOMINATIM_PBF_DIR ]; then
    sudo -u $NOMINATIM_SYSTEM_USER mkdir -p $NOMINATIM_PBF_DIR
  fi
  check_region_pbf_file $NOMINATIM_PBF_AFRICA_ENABLE $NOMINATIM_PBF_AFRICA_REGION_URL $NOMINATIM_PBF_AFRICA_REGION
  check_region_pbf_file $NOMINATIM_PBF_ASIA_ENABLE $NOMINATIM_PBF_ASIA_REGION_URL $NOMINATIM_PBF_ASIA_REGION
  check_region_pbf_file $NOMINATIM_PBF_AUSTRALIA_OCEANIA_ENABLE $NOMINATIM_PBF_AUSTRALIA_OCEANIA_REGION_URL $NOMINATIM_PBF_AUSTRALIA_OCEANIA_REGION
  check_region_pbf_file $NOMINATIM_PBF_CENTRAL_AMERICA_ENABLE $NOMINATIM_PBF_CENTRAL_AMERICA_REGION_URL $NOMINATIM_PBF_CENTRAL_AMERICA_REGION
  check_region_pbf_file $NOMINATIM_PBF_EUROPE_ENABLE $NOMINATIM_PBF_EUROPE_REGION_URL $NOMINATIM_PBF_EUROPE_REGION
  check_region_pbf_file $NOMINATIM_PBF_NORTH_AMERICA_ENABLE $NOMINATIM_PBF_NORTH_AMERICA_REGION_URL $NOMINATIM_PBF_NORTH_AMERICA_REGION
  check_region_pbf_file $NOMINATIM_PBF_SOUTH_AMERICA_ENABLE $NOMINATIM_PBF_SOUTH_AMERICA_REGION_URL $NOMINATIM_PBF_SOUTH_AMERICA_REGION
  check_continent_pbf_file $NOMINATIM_PBF_AFRICA_ENABLE $NOMINATIM_PBF_AFRICA_URL
  check_continent_pbf_file $NOMINATIM_PBF_ASIA_ENABLE $NOMINATIM_PBF_ASIA_URL
  check_continent_pbf_file $NOMINATIM_PBF_ANTARCTICA_ENABLE $NOMINATIM_PBF_ANTARCTICA_URL
  check_continent_pbf_file $NOMINATIM_PBF_AUSTRALIA_OCEANIA_ENABLE $NOMINATIM_PBF_AUSTRALIA_OCEANIA_URL
  check_continent_pbf_file $NOMINATIM_PBF_CENTRAL_AMERICA_ENABLE $NOMINATIM_PBF_CENTRAL_AMERICA_URL
  check_continent_pbf_file $NOMINATIM_PBF_EUROPE_ENABLE $NOMINATIM_PBF_EUROPE_URL
  check_continent_pbf_file $NOMINATIM_PBF_NORTH_AMERICA_ENABLE $NOMINATIM_PBF_NORTH_AMERICA_URL
  check_continent_pbf_file $NOMINATIM_PBF_SOUTH_AMERICA_ENABLE $NOMINATIM_PBF_SOUTH_AMERICA_URL
}

# Check if PDF file enabled and exists
function check_region_pbf_file() {
  BPF_ENABLE=$1
  BPF_REGION_URL=$2
  BPF_REGION=$3
  if [[ "x${BPF_REGION}" != "x" ]]; then
    if [[ "x${BPF_ENABLE}" != "xtrue" ]]; then
      for REGION in $(echo $BPF_REGION | tr "," "\n")
      do
        BPF_FILE="${REGION}-latest.osm.pbf"
        BPF_URL=$BPF_REGION_URL/$BPF_FILE
        echo $BPF_FILE
        echo $BPF_URL
        if [ ! -f $NOMINATIM_PBF_DIR/$BPF_FILE ]; then
          download_pbf_file $BPF_URL $BPF_FILE
        fi
      done
    else
      echo "ERROR: Continent PBF can't be enabled if continent region is set. Cannot continue...."
      exit 1
    fi
  fi
}

function check_continent_pbf_file() {
  BPF_ENABLE=$1
  BPF_URL=$2
  if [[ "x${BPF_ENABLE}" == "xtrue" ]]; then
    BPF_FILE=${BPF_URL##*/}
    if [ ! -f $NOMINATIM_PBF_DIR/$BPF_FILE ]; then
      download_pbf_file $BPF_URL $BPF_FILE
    fi
  fi
}

# Download the PDF file
function download_pbf_file() {
  BPF_URL=$1
  BPF_FILE=$2
  echo "Downloading ${BPF_URL}....to ${NOMINATIM_PBF_DIR}"
  sudo -u $NOMINATIM_SYSTEM_USER curl -k -# -L "${BPF_URL}" -o "${NOMINATIM_PBF_DIR}/${BPF_FILE}"
  if [[ "x${NOMINATIM_PBF_VERIFY_MD5}" == "xtrue" ]]; then
    check_pbf_md5 $BPF_URL $BPF_FILE
  fi
}

# Verify md5 if enabled
function check_pbf_md5() {
  BPF_URL=$1
  BPF_FILE=$2
  echo "Verifying ${BPF_FILE} MD5 sum...."
  sudo -u $NOMINATIM_SYSTEM_USER curl -k -sS -L "${BPF_URL}.md5" -o "${NOMINATIM_PBF_DIR}/${BPF_FILE}.md5"
  MD5SUM=$(cat ${NOMINATIM_PBF_DIR}/${BPF_FILE}.md5 | cut -d " " -f1)
  MD5SUM_PBF=$(md5sum ${NOMINATIM_PBF_DIR}/${BPF_FILE} | cut -d " " -f1)
  if [[ "x${MD5SUM}" == "x${MD5SUM_PBF}" ]]; then
    echo "${BPF_FILE} MD5 sum matches, proceeding...."
  else
    echo "MD5 sum does not match. Redownloading ${BPF_URL}"
    download_pbf_file $BPF_URL $BPF_FILE
  fi
}

# Count PBF files and merge if more than one
function set_nominatim_pbf_import_file() {
  PBF_COUNT=$(ls -alh ${NOMINATIM_PBF_DIR} | grep osm.pbf | grep -v md5 | wc -l )
  if [[ $PBF_COUNT -gt 1 ]]; then
    echo "More than one PBF file found. Merging..."
    sudo -u $NOMINATIM_SYSTEM_USER osmium cat $NOMINATIM_PBF_DIR/*.osm.pbf -o $NOMINATIM_PBF_DIR/import.osm.pbf
    NOMINATIM_PBF_IMPORT_FILE=$NOMINATIM_PBF_DIR/import.osm.pbf
  elif [[ $PBF_COUNT -eq 1 ]]; then
    NOMINATIM_PBF_IMPORT_FILE=$NOMINATIM_PBF_DIR/$(ls ${NOMINATIM_PBF_DIR} | grep osm.pbf | grep -v md5)
  fi
}
##### END MANAGE NOMINATIM DATA/PDF FILES #####


function run_nominatim_setup() {
  if [[ "x${NOMINATIM_PBF_IMPORT_FILE}" != "x" ]]; then
    NOMINATIM_SETUP_OPTS=$NOMINATIM_SETUP_OPTS" --all --threads ${NOMINATIM_THREADS}"
#    if [[ "x${NOMINATIM_FLATNODE_ENABLE}" == "xfalse" ]]; then
      #Get size of PBF file in MB
      PBF_IMPORT_SIZE=$(($( stat -c '%s' $NOMINATIM_PBF_IMPORT_FILE ) / 1000000))
      if [[ $PBF_IMPORT_SIZE -lt $NOMINATIM_OSM2PGSQL_CACHE ]]; then
        OSM2PGSQL_CACHE=$PBF_IMPORT_SIZE
      else
        OSM2PGSQL_CACHE=$NOMINATIM_OSM2PGSQL_CACHE
      fi
      NOMINATIM_SETUP_OPTS=$NOMINATIM_SETUP_OPTS" --osm2pgsql-cache ${OSM2PGSQL_CACHE}"
#    fi
    if [[ "x${NOMINATIM_REVERSE_ONLY_ENABLE}" == "xtrue" ]]; then
      NOMINATIM_SETUP_OPTS=$NOMINATIM_SETUP_OPTS" --reverse-only"
    fi
    echo "Running Nominatim setup: ${NOMINATIM_BUILD_DIR}/utils/setup.php --osm-file ${NOMINATIM_PBF_IMPORT_FILE} ${NOMINATIM_SETUP_OPTS}"
    sudo -u $NOMINATIM_SYSTEM_USER $NOMINATIM_BUILD_DIR/utils/setup.php --osm-file $NOMINATIM_PBF_IMPORT_FILE $NOMINATIM_SETUP_OPTS 2>&1 | tee $NOMINATIM_DATA_DIR/setup.log
    grep -c "Setup finished" $NOMINATIM_DATA_DIR/setup.log | grep -q 1 && sudo -u $NOMINATIM_SYSTEM_USER touch $NOMINATIM_DATA_DIR/setup-finished.txt #HACK
    sudo -u postgres psql postgres -tAc "ALTER SYSTEM SET fsync TO 'on'"
    sudo -u postgres psql postgres -tAc "ALTER SYSTEM SET full_page_writes TO 'on'"
  fi
}

function clean_nominatim_setup() {
  if [ -f $NOMINATIM_PBF_DIR/import.osm.pbf ]; then
    rm -rf $NOMINATIM_PBF_DIR/import.osm.pbf
  fi
  sudo -u postgres pg_ctl --silent stop -D $POSTGRES_DATA_DIR
}

#Set Timezone
cp /usr/share/zoneinfo/$TZ /etc/localtime
echo "${TZ}" >  /etc/timezone

write_fpmpool_conf
update_nginx_conf
# Check if external DB host
if [[ "x${NOMINATIM_POSTGRES_HOST}" == "x" ]]; then
  config_postgres
fi
write_supervisord_conf

manage_nominatim_creds
write_nominatim_local
#HACK - Need to find a better way to determine if setup is already done
if [ ! -f $NOMINATIM_DATA_DIR/setup-finished.txt ]; then
  check_nominatim_data_files
  check_nominatim_pbf_files
  set_nominatim_pbf_import_file
  run_nominatim_setup
  clean_nominatim_setup
fi
manage_nominatim_perms

exec /usr/bin/supervisord -c $SUPERVISORD_CONF_FILE
