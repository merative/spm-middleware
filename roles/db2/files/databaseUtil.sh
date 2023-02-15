#!/bin/sh
#
# Script to manipulate a Curam database.
#
# Note - Most configuration settings are hard-coded.  If you find that these need to vary PLEASE define an argument with a reasonable default, etc.
#
# Arguments - see usage()
#
# Prerequisites:
#   * DB2 is installed
#   * db2admin is the DB2 username
#
# TODO:
#   RESTORE
#   * Allow restore from one to another database name
#
#   CREATE
#   * Check for pre-existance of database:
#
#       db2 list database directory
#
#       System Database Directory
#       Number of entries in the directory = 1
#       Database 1 entry:
#       Database alias                       = CURAM
#       Database name                        = CURAM
#       ...
#       Number of entries in the directory = 1
#
#
#       db2 list active databases
#
#       Active Databases
#       Database name                              = CURAM
#       ...
#   * Allow for varying LOGFILSZ settings:
#       db2 update db cfg using logfilsiz 65536 logprimary 80 logsecond 80
#     versus what's below.
#
#   GENERAL
#   * Expand detail of commands reported; that is, put the command in a string and report it in the echo statement.
#   * Allow for deleting of pre-existing database.
#   * Allow failing  the script for any unexpected return code.
#


usage() {
      echo "Usage:"
      echo "  $0 "
      echo "     Actions:"
      echo "       -c | --create"
      echo "       -x | --drop"
      echo "       -b | --backup "
      echo "       -r | --restore "
      echo "       -o | --reorg "
      echo " "
      echo "     Create options:"
      echo "       -ah | --applheapsz                   - Specify the value for the APPLHEAPSZ config setting (default: AUTOMATIC)"
      echo "       -bp | --ibmdefaultbp                 - Specify the value for the IBMDEFAULTBP bufferpool size (default: AUTOMATIC)"
      echo "       -bh | --highmem                      - Specify the value for the HIGHMEM bufferpool size (default: 50, which is the official post-install step value)"
      echo "                                              Ideally we might want to use AUTOMATIC here, but configtest fails on that since HIGHMEM"
      echo "                                              is thus be configured as -2. So, you can use AUOTOMATIC, but configtest will fail (see RTC-214460)."
      echo "                                              Historically, Reliatbility testing has used a setting of 10000."
      echo " "
      echo "     Restore options:"
      echo "       -t | --timestamp                     - Specify the restore timestamp (can obtain from the backup file name (default: None)"
      echo " "
      echo "     Common options:"
      echo "     -d | --database-name <database-name>   - Specify the name of the database to create (default: DATABASE)"
      echo "     -u | --user-name <user-name>           - Specify the DB2 username (default: db2admin)"
      echo "     -p | --password <password>             - Specify the DB2 user password (default)"
      echo "     -f | --backup-restore-folder <folder-name> - Specify the folder for a backup or restore (default is the current directory)."
      echo "     -po | --port                         - Specify the TCP/IP client connection port number for the instance."
      echo ""
      echo "     -v | --verbose                         - Turn on verbose output (i.e., set -x)"
      echo " "

}


# The typeset command appears to be equivalent to function name() {}
typeset -fx createdb
typeset -fx dbconn
typeset -fx revokepublic
typeset -fx dbcfg
typeset -fx ctblspc
typeset -fx dbcreset
typeset -fx dbcomm
typeset -fx dbmgrreset


createdb () {
# TODO - Check for pre-existance of database:
  echo "$0 `date '+%0k:%0M:%0S'` INFO - Invoking db2 create database $DATABASE_NAME ..."
  db2 -v -ec create db $DATABASE_NAME using codeset UTF-8 territory US collate using identity
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 create database $DATABASE_NAME completed with: $lastRC"
  echo
}


dbconn () {
  echo "$0 `date '+%0k:%0M:%0S'` INFO - Connecting to database $DATABASE_NAME ..."
  sleep 2
  db2 -v -ec connect to $DATABASE_NAME user $USER using $PASSWORD
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 connect completed with: $lastRC"
  echo
}

revokepublic () {
  echo "$0 `date '+%0k:%0M:%0S'` INFO - Revoking public privileges for database $DATABASE_NAME ..."
  sleep 2
  db2 -v -ec revoke bindadd,connect,createtab,implicit_schema on $DATABASE_NAME from public
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 revoke completed with: $lastRC"
  echo
}

dbcfg () {
  echo "$0 `date '+%0k:%0M:%0S'` INFO - Making configuration changes for database $DATABASE_NAME ..."
  echo

  db2 -v -ec update db cfg for $DATABASE_NAME using LOCKTIMEOUT 30
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 LOCKTIMEOUT configuration completed with: $lastRC (2 is a normal code as the DB must be restarted)"
  echo

  db2 -v -ec update db cfg for $DATABASE_NAME using APPLHEAPSZ ${APPLHEAPSZ}
  lastRC=$?
	echo
  echo -e "\n$0 `date '+%0k:%0M:%0S'` INFO - db2 APPLHEAPSZ ${APPLHEAPSZ} configuration completed with: $lastRC"
  echo

  db2 -v -ec update db cfg for $DATABASE_NAME using CATALOGCACHE_SZ 1000
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 CATALOGCACHE_SZ configuration completed with: $lastRC"
  echo

  db2 -v -ec update db cfg for $DATABASE_NAME using PCKCACHESZ 12000
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 PCKCACHESZ configuration completed with: $lastRC"
  echo

  db2 -v -ec update db cfg for $DATABASE_NAME using LOGFILSIZ 1024 logprimary 50 logsecond 100
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 LOGFILSIZ configuration completed with: $lastRC (2 is a normal code as the DB must be restarted)"
  echo

  db2 -v -ec update db cfg for $DATABASE_NAME using LOGARCHMETH1 OFF LOGARCHMETH2 OFF
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 LOGARCHMETH1 configuration completed with: $lastRC (2 is a normal code as the DB must be restarted)"
  echo

  db2 -v -ec update db configuration using DBHEAP AUTOMATIC
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 DBHEAP configuration completed with: $lastRC"
  echo

  db2 -v -ec ALTER TABLESPACE USERSPACE1 DROPPED TABLE RECOVERY OFF
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 TABLESPACE configuration completed with: $lastRC"
  echo

  db2set DB2_HASH_JOIN=NO
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2set DB2_HASH_JOIN configuration completed with: $lastRC"
  echo

  db2set DB2_USE_ALTERNATE_PAGE_CLEANING=ON
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2set DB2_USE_ALTERNATE_PAGE_CLEANING configuration completed with: $lastRC"
  echo

  echo "$0 `date '+%0k:%0M:%0S'` INFO - SETTING PARALLEL_IO TO 1.  THIS IS THE NUMBER OF PHYSICAL DISKS ON THE SERVER.  DEFAULT IS 1, IF DIFFERENT PLEASE CHANGE THIS SETTING MANUALLY USING - db2set DB2_PARALLEL_IO=*:<NUMBER OF PHYSICAL DISKS>"
  db2set DB2_PARALLEL_IO=*:1
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2set DB2_PARALLEL_IO configuration completed with: $lastRC"
  echo

  db2 -v -ec bind ~/sqllib/bnd/db2schema.bnd blocking all grant public
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 bind completed with: $lastRC"
  echo

  echo "$0 `date '+%0k:%0M:%0S'` INFO - Configuration changes for database $DATABASE_NAME complete."
  echo
}


ctblspc () {
  echo "$0 `date '+%0k:%0M:%0S'` INFO - Making tablespace configuration changes for database $DATABASE_NAME ..."
  echo

  db2 -v -ec create bufferpool highmem size ${HIGHMEM} pagesize 32k
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 create bufferpool highmem of size ${HIGHMEM} completed with: $lastRC"
  echo

  db2 -v -ec alter bufferpool ibmdefaultbp immediate size ${IBMDEFAULTBP}
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 alter bufferpool ibmdefaultbp of size ${IBMDEFAULTBP} completed with: $lastRC"
  echo

  dbcreset

  echo "$0 `date '+%0k:%0M:%0S'` INFO - Restarting DB2 ..."
  set -e
  db2 -v -ec force application all
  echo
  db2 -v -ec db2stop force
  lastRC=$?
  echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2stop completed with: $lastRC"
  # Redunadant with dbcreset above and should be done before db2stop: db2 terminate
  db2 -v -ec db2start
  lastRC=$?
  echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 restart completed with: $lastRC"
  echo
  set +e

  dbconn $DATABASE_NAME $USER $PASSWORD

  echo 'CREATE TABLESPACE '$1'_L'
  echo '.........................'
  db2 -v -ec create tablespace $1_L pagesize 32k managed by system using \
                                            \(\'${HOME}/tblspc/$1_L\'\) bufferpool highmem
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 create tablespace completed with: $lastRC"
  echo

  echo 'CREATE TEMPORARY TABLESPACE '$1'_T'
  echo '....................................'
  db2 -v -ec create temporary tablespace $1_T pagesize 32k managed by system using \
                                            \(\'${HOME}/tblspc/$1_T\'\) bufferpool highmem
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 create temporary tablespace completed with: $lastRC"
  echo

  echo 'ALTER TABLESPACE '$1'_L DROPPED TABLE RECOVERY OFF'
  echo '...................................................'
  db2 -v -ec ALTER TABLESPACE $1_L DROPPED TABLE RECOVERY OFF
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 alter tablespace completed with: $lastRC"
  echo

  echo "$0 `date '+%0k:%0M:%0S'` INFO - Tablespace configuration changes for db $DATABASE_NAME complete."
  echo
}


dbcreset () {
  echo "$0 `date '+%0k:%0M:%0S'` INFO - Resetting and terminting DB2 connections ..."
  sleep 2
  # Is db2 connect reset superfluous?  DB2 manual says: "Although TERMINATE and CONNECT RESET both break the connection to a database, only TERMINATE results in termination of the back-end process."
  db2 -v -ec connect reset
  echo
  db2 -v -ec terminate
  echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 connection reset complete."
  echo
}


dbcomm () {
  echo "$0 `date '+%0k:%0M:%0S'` INFO - Configuring DB2 TCP/IP settings ..."
  sleep 2
  db2set DB2COMM=tcpip
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2COMM set completed with: $lastRC"
  echo

  db2 -v -ec update dbm cfg using svcename $PORT
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 port configuration completed with: $lastRC"
  echo

  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 TCP/IP configuration complete."
  echo
}


dbmgrreset () {
  echo "$0 `date '+%0k:%0M:%0S'` INFO - Resetting the DB2 database manager ..."
  sleep 2
  db2 -v -ec force application all
  echo
  db2 -v -ec terminate
  echo
  db2 -v -ec stop db manager
  echo
  db2 -v -ec start db manager
  echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 database manager reset complete."
  echo
}


# Drop a database
dropdb() {
  echo "$0 `date '+%0k:%0M:%0S'` INFO - Dropping database $DATABASE_NAME ..."

  echo "$0 `date '+%0k:%0M:%0S'` INFO - Activity for database $DATABASE_NAME that is to be dropped..."
  db2 -v -ec list applications for db $DATABASE_NAME
  echo
  # Is db2 connect reset superfluous?  DB2 manual says: "Although TERMINATE and CONNECT RESET both break the connection to a database, only TERMINATE results in termination of the back-end process."
  db2 -v -ec connect reset
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 connect reset completed with: $lastRC"
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 connect RC=4 is normal when no connection exists."
  echo

  db2 -v -ec force application all
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 force application all completed with: $lastRC"
  echo

  echo "$0 `date '+%0k:%0M:%0S'` INFO - Restarting DB2 ..."
  db2 -v -ec terminate
  echo
  db2stop
  # Should come before db2stop: db2 terminate
  db2start
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 restart complete. "
  echo

  db2 -v -ec quiesce instance $USER restricted access immediate force connections
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 quiesce instance user completed with: $lastRC"
  echo

  # Redundant wtih above? db2 terminate
  #lastRC=$?
	echo
  #echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 terminate completed with: $lastRC"
  #echo

  db2 -v -ec deactivate db $DATABASE_NAME
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 deactivate db completed with: $lastRC"
  echo

  db2 -v -ec drop  db $DATABASE_NAME
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 drop db completed with: $lastRC"
  echo

  db2 -v -ec list applications for db $DATABASE_NAME
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 list applications completed with: $lastRC"
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 list applications RC=4 is normal at this point"
  echo
}

actionInfo() {
  echo " "
  echo "$0 `date '+%0k:%0M:%0S'` INFO - Action $1 with settings:"
  echo "            DATABASE NAME=$DATABASE_NAME."
  echo "            USER=$USER."
  echo " "

  if [ "${CREATE}" == "true" ] ; then
    echo "            APPLHEAPSZ=${APPLHEAPSZ}"
    echo "            HIGHMEM=${HIGHMEM}"
    echo "            IBMDEFAULTBP=${IBMDEFAULTBP}"
    echo " "
  fi

  echo "            VERBOSE=$VERBOSE."
  echo " "
}

# Backup a database
backupdb(){
  echo "$0 `date '+%0k:%0M:%0S'` INFO - Backup database $DATABASE_NAME ..."

  if [ ! -z "$FOLDER" -a -e "$FOLDER" -a -d "$FOLDER" ] ; then
    cd "$FOLDER"
  else
    echo "$0 `date '+%0k:%0M:%0S'` ERROR - Folder not specified, doesn't exist, or is not a folder."
    exit 1
  fi

  echo "$0 `date '+%0k:%0M:%0S'` INFO - Activity prior to $DATABASE_NAME backup: "
  db2 -v -ec list applications for db $DATABASE_NAME
  echo
  # Is db2 connect reset superfluous?  DB2 manual says: "Although TERMINATE and CONNECT RESET both break the connection to a database, only TERMINATE results in termination of the back-end process."
  db2 -v -ec connect reset
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 connect reset completed with: $lastRC"
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 connect RC=4 is normal when no connection exists."
  echo

  db2 -v -ec force application all
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 force application all completed with: $lastRC"
  echo

  db2 -v -ec quiesce instance $USER restricted access immediate force connections
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 quiesce instance user completed with: $lastRC"
  echo

  db2 -v -ec terminate
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 terminate completed with: $lastRC"
  echo

  db2 -v -ec deactivate db $DATABASE_NAME
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 deactivate db completed with: $lastRC"
  echo

  echo "$0 `date '+%0k:%0M:%0S'` INFO - Beginning database backup..."
  if [ ! -z "$FOLDER" -a -e "$FOLDER" -a -d "$FOLDER" ] ; then
    cd "$FOLDER"
  else
    echo "$0 `date '+%0k:%0M:%0S'` INFO - Folder not specified, doesn't exist, or is not a folder, using current directory (`pwd`)."
  fi

  db2 -v -ec BACKUP db $DATABASE_NAME WITH 2 BUFFERS BUFFER 1024 PARALLELISM 1 COMPRESS WITHOUT PROMPTING
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 backup db completed with: $lastRC"
  echo

  db2 -v -ec activate db $DATABASE_NAME
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 activate db completed with: $lastRC"
  echo

  db2 -v -ec unquiesce instance $USER
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 unquiesce db completed with: $lastRC"
  echo
}


# Reorg a database
reorgdb() {
  echo "$0 `date '+%0k:%0M:%0S'` INFO - Reorging database $DATABASE_NAME ..."

  dbconn $DATABASE_NAME $USER $PASSWORD

  echo 'CREATE TEMPORARY 32K TABLESPACE'
  echo '...............................'
  db2 -v -ec create temporary tablespace TEMPSPACE_32K pagesize 32k managed by AUTOMATIC STORAGE BUFFERPOOL HIGHMEM
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 create temporary tablespace completed with: $lastRC"
  echo


  echo 'REORGING TABLES'
  echo '...............'
  echo "select 'reorg table', substr(rtrim(tabschema)||'.'||rtrim(tabname),1,50),' ALLOW NO ACCESS ; ' from syscat.tables where TYPE = 'T' and tabschema='${USER^^}' ;" > reorgselect.sql
  db2 -xtf reorgselect.sql > reorgtab.sql
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 -tvf for reorgselect.sql completed with: $lastRC"

  db2 -v -ec -tf reorgtab.sql
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 -tvf reorgtab.sql completed with: $lastRC"


  echo 'REORGING INDEXES'
  echo '................'
  echo "select distinct 'reorg indexes all for table', substr(rtrim(i.tabschema)||'.'||rtrim(i.tabname),1,50),' ALLOW NO ACCESS ; ' from syscat.indexes i, syscat.tables t where  i.tabschema='${USER^^}' and t.tabschema = i.tabschema and t.tabname = i.tabname and t.type = 'T' ; " > reorgidxselect.sql
  dt2 -xtf reorgidxselect.sql > reorgidx.sql
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 command for reorgidxselect.sql completed with: $lastRC"

  db2 -v -ec -tf reorgidx.sql
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 command for reorgidx.sql completed with: $lastRC"


  echo 'RUNSTATS'
  echo '........'
  db2 -x "select 'runstats on table', substr(rtrim(tabschema)||'.'||rtrim(tabname),1,50),' AND DETAILED INDEXES ALL ; ' from syscat.tables where TYPE = 'T' and tabschema='DB2ADMIN' " > runstats.sql
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 select for runstats.sql completed with: $lastRC"

  db2 -v -ec -tvf runstats.sql
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - db2 command runstats.sql completed with: $lastRC"

}


restoredb() {
  echo "$0 `date '+%0k:%0M:%0S'` INFO - Restoring database $DATABASE_NAME ..."

  db2 -v -ec RESTORE db $DATABASE_NAME FROM $FOLDER TAKEN AT $TIMESTAMP INTO $DATABASE_NAME REDIRECT WITHOUT ROLLING FORWARD WITHOUT PROMPTING
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 RESTORE completed with: $lastRC"
  echo

  db2 -v -ec RESTORE db $DATABASE_NAME CONTINUE
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 RESTORE CONTINUE completed with: $lastRC"
  echo

  db2 -v -ec activate db $DATABASE_NAME
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 activate db completed with: $lastRC"
  echo

  db2 -v -ec unquiesce instance $USER
  lastRC=$?
	echo
  echo "$0 `date '+%0k:%0M:%0S'` INFO - DB2 unquiesce db completed with: $lastRC"
  echo

}


#==========
#== Main ==
#==========

DROP=""
CREATE=""
BACKUP=""
RESTORE=""
REORG=""
DATABASE_NAME="DATABASE"
USER="db2admin"
PASSWORD="db2admin"
VERBOSE="false"
APPLHEAPSZ="AUTOMATIC"
# This is the setting in the official post-install db configuration setps
HIGHMEM="50"
PORT="50000"
IBMDEFAULTBP="AUTOMATIC"
FOLDER="$(pwd)"
TIMESTAMP=""

while [ $# -gt 0 ] ; do
  case "${1}" in
    '-c'|'--create')
      CREATE="true"
      ;;
    '-ah'|'--applheapsz')
      APPLHEAPSZ="${2}"
      shift
      ;;
    '-bp'|'--ibmdefaultbp')
      IBMDEFAULTBP="${2}"
      shift
      ;;
    '-bh'|'--highmem')
      # Convert highmem to lowercase
      HIGHMEM="${2,,}"
      shift
      ;;
    '-po'|'--port')
      PORT="${2}"
      shift
      ;;      
    '-x'|'--drop')
      DROP="true"
      ;;
    '-b'|'--backup')
      BACKUP="true"
      ;;
    '-r'|'--restore')
      RESTORE="true"
      ;;
    '-t'|'--timestamp')
      TIMESTAMP="${2}"
      shift
      ;;
    '-o'|'--reorg')
      REORG="true"
      ;;
    '-d'|'--database-name')
      DATABASE_NAME="${2}"
      shift
      ;;
    '-u'|'--user-name')
      USER="${2}"
      shift
      ;;
    '-p'|'--password')
      PASSWORD="${2}"
      shift
      ;;
    '-v'|'--verbose')
      VERBOSE="true"
      ;;
    '-f'|'--backup-restore-folder')
      FOLDER="${2}"
      shift
      ;;
    '-h'|'--h'|'--help')
      usage
      echo " "
      exit 0
  esac
  shift
done

echo " "
if [ "${CREATE}" == "" -a "${DROP}" == "" -a "${BACKUP}" == "" -a "${RESTORE}" == "" -a "${REORG}" == "" ] ; then
  echo "ERROR - No action option specified. "
  echo " "
  usage
  exit 1
fi

# Note an automatic setting is converted to lower-case above.
if [ "${HIGHMEM}" == "automatic" ] ; then
  echo "WARNING - A setting of automatic for the highmem bufferpool will cause configtest to fail (see RTC-214460)."
fi


# Logical combinations, aside from the four discretely:
#   Backup, Restore (invokes Drop)
#   Restore (invokes Drop)
#   Drop, Create
#   Backup, Drop

# 1. Backup
# 2. Drop
# 3. Restore
# 4. Create
# 5. Reorg - standalone


if [ "$VERBOSE" == "true" ] ;
then
  set -x
fi

if [ "${BACKUP}" == "true" ] ; then
  actionInfo "BACKUP"
  echo "INFO - The backup will be to folder $FOLDER."
  if [ ! -w "$FOLDER" ] ; then
    echo "ERROR - The folder ($FOLDER) for backing up is not writable by this user. Correct folder permissions and retry."
    exit 1
  fi
  backupdb $DATABASE_NAME
  dbcomm
  dbmgrreset
  dbcreset
fi


if [ "${DROP}" == "true" ] ; then
  actionInfo "DROP"
  dropdb
fi

if [ "${RESTORE}" == "true" ] ; then
  actionInfo "RESTORE"
  if [ -z "${TIMESTAMP}" ] ; then
    "$0 -`date '+%0k:%0M:%0S'` ERROR - No timestamp argument specified for restore.  Cannot continue."
    exit 1
  fi

  cd "$FOLDER"
  BackupFile=`ls -1 *${TIMESTAMP}*`
  cd -
  if [ ! -r "$FOLDER/$BackupFile" ] ; then
    echo "ERROR - backup file $FOLDER/$BackupFile is not readable by this ID."
    echo "        Use root and the 'chmod -a+r ...' command to fix the issue and retry."
    ls -l "$FOLDER/$BackupFile"
    exit 1
  fi
  if [ "${DROP}" == "" ] ; then
    dropdb
  fi
  restoredb
fi

if [ "${CREATE}" == "true" ] ; then
  actionInfo "CREATE"
  createdb $DATABASE_NAME
  dbconn $DATABASE_NAME $USER $PASSWORD
  revokepublic $DATABASE_NAME
  dbcfg $DATABASE_NAME
  ctblspc $DATABASE_NAME $USER $PASSWORD
  dbcomm
  dbmgrreset
  dbcreset
fi

if [ "${REORG}" == "true" ] ; then
  actionInfo "REORG"
  reorgdb
fi


echo "$0 `date '+%0k:%0M:%0S'` INFO - Database $ACTION complete for $DATABASE_NAME."
echo
#<end>
