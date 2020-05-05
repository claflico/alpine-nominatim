
CONF_DIR="/opt/conf"
CPU_COUNT=$(grep -c ^processor /proc/cpuinfo)
SELF_SSL_DIR="/etc/nginx/ssl"
TZ=${TZ:-"US/Central"}

NGINX_CONF_FILE=${NGINX_CONF_FILE:-"/etc/nginx/nginx.conf"}
NGINX_DEFAULT_CONF_FILE=${NGINX_DEFAULT_CONF_FILE:-"/etc/nginx/conf.d/default.conf"}
NGINX_HTTP_PORT=${NGINX_HTTP_PORT:-"80"}
NGINX_HTTPS_ENABLE=${NGINX_HTTPS_ENABLE:-"false"}
NGINX_HTTPS_PORT=${NGINX_HTTPS_PORT:-"443"}
NGINX_KEEPALIVE_TIMEOUT=${NGINX_KEEPALIVE_TIMEOUT:-"65"}
NGINX_ROOT_DIR=${NGINX_ROOT_DIR:-${NOMINATIM_HOME}"/build/website"}
NGINX_SENDFILE=${NGINX_SENDFILE:-"on"}
NGINX_SSL_CIPHERS=${NGINX_SSL_CIPHERS:-"HIGH:!aNULL:!MD5"}
NGINX_SSL_DIR=${NGINX_SSL_DIR:-${SELF_SSL_DIR}}
NGINX_SSL_CRT_FILE=${NGINX_SSL_CRT_FILE:-${NGINX_SSL_DIR}"/nominatim.crt"}
NGINX_SSL_KEY_FILE=${NGINX_SSL_KEY_FILE:-${NGINX_SSL_DIR}"/nominatim.key"}
NGINX_SSL_PROTOCOLS=${NGINX_SSL_PROTOCOLS:-"TLSv1 TLSv1.1 TLSv1.2"}
NGINX_STDERR_FILE=${NGINX_STDERR_FILE:-"/dev/stderr"}
NGINX_STDOUT_FILE=${NGINX_STDOUT_FILE:-"/dev/stdout"}
NGINX_WORKER_CONNECTIONS=${NGINX_WORKER_CONNECTIONS:-"1024"}
NGINX_WORKER_PROCESSES=${NGINX_WORKER_PROCESSES:-${CPU_COUNT}}

NOMINATIM_BUILD_DIR=${NOMINATIM_BUILD_DIR:-${NOMINATIM_HOME}"/build"}
NOMINATIM_DATA_DIR=${NOMINATIM_DATA_DIR:-${NOMINATIM_HOME}"/data"}
NOMINATIM_DATA_GB_POSTCODE_ENABLE=${NOMINATIM_DATA_GB_POSTCODE_ENABLE:-"false"} #false
NOMINATIM_DATA_GB_POSTCODE_URL=${NOMINATIM_DATA_GB_POSTCODE_URL:-"https://www.nominatim.org/data/gb_postcode_data.sql.gz"}
NOMINATIM_DATA_US_POSTCODE_ENABLE=${NOMINATIM_DATA_US_POSTCODE_ENABLE:-"true"}
NOMINATIM_DATA_US_POSTCODE_URL=${NOMINATIM_DATA_US_POSTCODE_URL:-"https://www.nominatim.org/data/us_postcode_data.sql.gz"}
NOMINATIM_DATA_WIKIPEDIA_ARTICLE_ENABLE=${NOMINATIM_DATA_WIKIPEDIA_ARTICLE_ENABLE:-"false"}
NOMINATIM_DATA_WIKIPEDIA_ARTICLE_URL=${NOMINATIM_DATA_WIKIPEDIA_ARTICLE_URL:-"https://www.nominatim.org/data/wikipedia_article.sql.bin"}
NOMINATIM_DATA_WIKIPEDIA_REDIRECT_ENABLE=${NOMINATIM_DATA_WIKIPEDIA_REDIRECT_ENABLE:-"false"}
NOMINATIM_DATA_WIKIPEDIA_REDIRECT_URL=${NOMINATIM_DATA_WIKIPEDIA_REDIRECT_URL:-"https://www.nominatim.org/data/wikipedia_redirect.sql.bin"}
NOMINATIM_DB_WEB_USER=${NOMINATIM_DB_WEB_USER:-"nginx"}
NOMINATIM_FLATNODE_ENABLE=${NOMINATIM_FLATNODE_ENABLE:-"false"}
NOMINATIM_FLATNODE_FILE=${NOMINATIM_FLATNODE_FILE:-${NOMINATIM_DATA_DIR}"/flatnode.file"}
NOMINATIM_IMPORT_STYLE=${NOMINATIM_IMPORT_STYLE:-"import-full.style"}
NOMINATIM_LOCAL_FILE=${NOMINATIM_BUILD_DIR}"/settings/local.php"
NOMINATIM_OSM2PGSQL_CACHE=${NOMINATIM_OSM2PGSQL_CACHE:-"2000"} #Megabytes
NOMINATIM_PBF_DIR=${NOMINATIM_PBF_DIR:-${NOMINATIM_DATA_DIR}"/pbf"}
NOMINATIM_PBF_IMPORT_FILE=""
NOMINATIM_PBF_PLANET_ENABLE=${NOMINATIM_PBF_PLANET_ENABLE:-"false"}
NOMINATIM_PBF_PLANET_URL=${NOMINATIM_PBF_PLANET_URL:-"https://ftp.osuosl.org/pub/openstreetmap/pbf/planet-latest.osm.pbf"}
NOMINATIM_PBF_AFRICA_ENABLE=${NOMINATIM_PBF_AFRICA_ENABLE:-"false"}
NOMINATIM_PBF_AFRICA_REGION=${NOMINATIM_PBF_AFRICA_REGION}
NOMINATIM_PBF_AFRICA_REGION_URL=${NOMINATIM_PBF_AFRICA_REGION_URL:-"http://download.geofabrik.de/africa"}
NOMINATIM_PBF_AFRICA_URL=${NOMINATIM_PBF_AFRICA_URL:-"http://download.geofabrik.de/africa-latest.osm.pbf"}
NOMINATIM_PBF_ANTARCTICA_ENABLE=${NOMINATIM_PBF_ANTARCTICA_ENABLE:-"false"}
NOMINATIM_PBF_ANTARCTICA_URL=${NOMINATIM_PBF_ANTARCTICA_URL:-"http://download.geofabrik.de/anartica.osm.pbf"}
NOMINATIM_PBF_ASIA_ENABLE=${NOMINATIM_PBF_ASIA_ENABLE:-"false"}
NOMINATIM_PBF_ASIA_REGION=${NOMINATIM_PBF_ASIA_REGION}
NOMINATIM_PBF_ASIA_REGION_URL=${NOMINATIM_PBF_ASIA_REGION_URL:-"http://download.geofabrik.de/asia"}
NOMINATIM_PBF_ASIA_URL=${NOMINATIM_PBF_ASIA_URL:-"http://download.geofabrik.de/asia-latest.osm.pbf"}
NOMINATIM_PBF_AUSTRALIA_OCEANIA_ENABLE=${NOMINATIM_PBF_AUSTRALIA_OCEANIA_ENABLE:-"false"}
NOMINATIM_PBF_AUSTRALIA_OCEANIA_REGION=${NOMINATIM_PBF_AUSTRALIA_OCEANIA_REGION}
NOMINATIM_PBF_AUSTRALIA_OCEANIA_REGION_URL=${NOMINATIM_PBF_AUSTRALIA_OCEANIA_REGION_URL:-"http://download.geofabrik.de/australia-oceania"}
NOMINATIM_PBF_AUSTRALIA_OCEANIA_URL=${NOMINATIM_PBF_AUSTRALIA_OCEANIA_URL:-"http://download.geofabrik.de/australia-oceania-latest.osm.pbf"}
NOMINATIM_PBF_CENTRAL_AMERICA_ENABLE=${NOMINATIM_PBF_CENTRAL_AMERICA_ENABLE:-"false"}
NOMINATIM_PBF_CENTRAL_AMERICA_REGION=${NOMINATIM_PBF_CENTRAL_AMERICA_REGION}
NOMINATIM_PBF_CENTRAL_AMERICA_REGION_URL=${NOMINATIM_PBF_CENTRAL_AMERICA_REGION_URL:-"http://download.geofabrik.de/central-america"}
NOMINATIM_PBF_CENTRAL_AMERICA_URL=${NOMINATIM_PBF_CENTRAL_AMERICA_URL:-"http://download.geofabrik.de/central-america-latest.osm.pbf"}
NOMINATIM_PBF_EUROPE_ENABLE=${NOMINATIM_PBF_EUROPE_ENABLE:-"false"}
NOMINATIM_PBF_EUROPE_REGION=${NOMINATIM_PBF_EUROPE_REGION}
NOMINATIM_PBF_EUROPE_REGION_URL=${NOMINATIM_PBF_EUROPE_REGION_URL:-"http://download.geofabrik.de/europe"}
NOMINATIM_PBF_EUROPE_URL=${NOMINATIM_PBF_EUROPE_URL:-"http://download.geofabrik.de/europe-latest.osm.pbf"}
NOMINATIM_PBF_NORTH_AMERICA_ENABLE=${NOMINATIM_PBF_NORTH_AMERICA_ENABLE:-"false"}
NOMINATIM_PBF_NORTH_AMERICA_REGION=${NOMINATIM_PBF_NORTH_AMERICA_REGION}
NOMINATIM_PBF_NORTH_AMERICA_REGION_URL=${NOMINATIM_PBF_NORTH_AMERICA_REGION_URL:-"http://download.geofabrik.de/north-america"}
NOMINATIM_PBF_NORTH_AMERICA_URL=${NOMINATIM_PBF_NORTH_AMERICA_URL:-"http://download.geofabrik.de/north-america-latest.osm.pbf"}
NOMINATIM_PBF_SOUTH_AMERICA_ENABLE=${NOMINATIM_PBF_SOUTH_AMERICA_ENABLE:-"false"}
NOMINATIM_PBF_SOUTH_AMERICA_REGION=${NOMINATIM_PBF_SOUTH_AMERICA_REGION}
NOMINATIM_PBF_SOUTH_AMERICA_REGION_URL=${NOMINATIM_PBF_SOUTH_AMERICA_REGION_URL:-"http://download.geofabrik.de/south-america"}
NOMINATIM_PBF_SOUTH_AMERICA_URL=${NOMINATIM_PBF_SOUTH_AMERICA_URL:-"http://download.geofabrik.de/south-america-latest.osm.pbf"}
NOMINATIM_PBF_VERIFY_MD5=${NOMINATIM_PBF_VERIFY_MD5:-"true"}
NOMINATIM_POSTGIS_VERSION=${NOMINATIM_POSTGIS_VERSION:-"3"}
NOMINATIM_POSTGRES_DB=${NOMINATIM_POSTGRES_DB:-"nominatim"}
NOMINATIM_POSTGRES_HOST=${NOMINATIM_POSTGRES_HOST}
NOMINATIM_POSTGRES_PASSWORD=${NOMINATIM_POSTGRES_PASSWORD}
NOMINATIM_POSTGRES_PORT=${NOMINATIM_POSTGRES_PORT:-"5432"}
NOMINATIM_POSTGRES_USER=${NOMINATIM_POSTGRES_USER}
NOMINATIM_POSTGRES_VERSION=${NOMINATIM_POSTGRES_VERSION:-"12"}
NOMINATIM_REVERSE_ONLY_ENABLE=${NOMINATIM_REVERSE_ONLY_ENABLE:-"false"}
NOMINATIM_SETUP_ENABLE=${NOMINATIM_SETUP_ENABLE:-"false"}
NOMINATIM_SETUP_OPTS=${NOMINATIM_SETUP_OPTS:-""}
NOMINATIM_SYSTEM_UID=${NOMINATIM_SYSTEM_UID:-"1000"}
NOMINATIM_SYSTEM_USER=${NOMINATIM_SYSTEM_USER:-"nominatim"}
NOMINATIM_THREADS=${NOMINATIM_THREADS:-${CPU_COUNT}}
NOMINATIM_WEBSITE_BASEURL=${NOMINATIM_WEBSITE_BASEURL:-"/"}

PHPFPM_CATCH_WORKERS_OUTPUT=${PHPFPM_CATCH_WORKERS_OUTPUT:-"yes"}
PHPFPM_CLEAR_ENV=${PHPFPM_CLEAR_ENV:-"no"}
PHPFPM_COMMAND=${PHPFPM_COMMAND:-"php-fpm7 -F"}
PHPFPM_CONF_FILE=${PHPFPM_CONF_FILE:-"/etc/php7/php-fpm.d/www.conf"}
PHPFPM_CONF_FILEDIR=$(dirname $PHPFPM_CONF_FILE)
PHPFPM_DECORATE_WORKERS_OUTPUT=${PHPFPM_DECORATE_WORKERS_OUTPUT:-"no"}
PHPFPM_GROUP=${PHPFPM_GROUP:-"nginx"}
PHPFPM_LISTEN=${PHPFPM_LISTEN:-"127.0.0.1:9000"}
PHPFPM_MAX_CHILDREN=${PHPFPM_MAX_CHILDREN:-"100"}
PHPFPM_MAX_REQUESTS=${PHPFPM_MAX_REQUESTS:-"1000"}
PHPFPM_PING_PATH=${PHPFPM_PING_PATH:-"/fpm-ping"}
PHPFPM_PING_STATUS_ALLOW=${PHPFPM_PING_STATUS_ALLOW:-"127.0.0.1"}
PHPFPM_PROCESS_IDLE_TIMEOUT=${PHPFPM_PROCESS_IDLE_TIMEOUT:-"10s"}
PHPFPM_PROCESS_MANAGER=${PHPFPM_PROCESS_MANAGER:-"ondemand"}
PHPFPM_STATUS_PATH=${PHPFPM_STATUS_PATH:-"/fpm-status"}
PHPFPM_STDERR_FILE=${PHPFPM_STDERR_FILE:-"/dev/stderr"}
PHPFPM_STDOUT_FILE=${PHPFPM_STDOUT_FILE:-"/dev/stdout"}
PHPFPM_USER=${PHPFPM_USER:-"nginx"}

POSTGRES_CONF_FILE=${POSTGRES_CONF_FILE:-${PGDATA}"/postgresql.conf"}
POSTGRES_CONF_INCLUDE_FILE=${POSTGRES_CONF_INCLUDE_FILE:-${PGDATA}"/postgresql-include.conf"}
POSTGRES_DATA_DIR=${PGDATA:-"/var/lib/postgresql/data"}
POSTGRES_AUTOVACUUM_WORK_MEM=${POSTGRES_AUTOVACUUM_WORK_MEM:-"2GB"} #Nominatim install docs suggests 2GB
POSTGRES_CHECKPOINT_COMPLETION_TARGET=${POSTGRES_CHECKPOINT_COMPLETION_TARGET:-"0.9"} #Nominatim install docs suggests 0.9, postgresql suggests maximum of 0.9
POSTGRES_CHECKPOINT_TIMEOUT=${POSTGRES_CHECKPOINT_TIMEOUT:-"10min"} #Nominatim install docs suggests 10min
POSTGRES_EFFECTIVE_CACHE_SIZE=${POSTGRES_EFFECTIVE_CACHE_SIZE:-"8GB"} #Nominatim install docs suggests 24GB, postgresql suggests 50% of total memory
POSTGRES_MAINTENANCE_WORK_MEM=${POSTGRES_MAINTENANCE_WORK_MEM:-"10GB"} #Nominatim install docs suggests 10GB, postgresql suggests 2X or more than POSTGRES_WORK_MEM
POSTGRES_MAX_WAL_SIZE=${POSTGRES_MAX_WAL_SIZE:-"1GB"} #Nominatim install docs suggests 1GB
POSTGRES_PID_FILE=${POSTGRES_PID_FILE:-"/run/postgresql/postgresql.pid"}
POSTGRES_SHARED_BUFFERS=${POSTGRES_SHARED_BUFFERS:-"2GB"} #Nominatim install docs suggests 2GB, postgresql suggests 25% of total memory
POSTGRES_STDERR_FILE=${POSTGRES_STDERR_FILE:-"/dev/stderr"}
POSTGRES_STDOUT_FILE=${POSTGRES_STDOUT_FILE:-"/dev/stdout"}
POSTGRES_SYNCHRONOUS_COMMIT=${POSTGRES_SYNCHRONOUS_COMMIT:-"off"} #Nominatim install docs suggests off
POSTGRES_WORK_MEM=${POSTGRES_WORK_MEM:-"50MB"} #Nominatim install docs suggests 50MB

SUPERVISORD_CONF_FILE=${SUPERVISORD_CONF_FILE:-"/etc/supervisor.conf"}
SUPERVISORD_CONF_FILEDIR=$(dirname $SUPERVISORD_CONF_FILE)
SUPERVISORD_LOG_FILE=${SUPERVISORD_LOG_FILE:-"/dev/null"}
SUPERVISORD_PID_FILE=${SUPERVISORD_PID_FILE:-"/run/supervisord.pid"}
SUPERVISORD_USER=${SUPERVISORD_USER:-"root"}
