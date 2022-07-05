#!/bin/bash

# Log the info with the same format as NEO4J outputs
log_info() {
  # https://www.howtogeek.com/410442/how-to-display-the-date-and-time-in-the-linux-terminal-and-use-it-in-bash-scripts/
  printf '%s %s\n' "$(date -u +"%Y-%m-%d %H:%M:%S:%3N%z") INFO  Wrapper: $1"
  return
}

CONTAINER_ALREADY_STARTED="CONTAINER_ALREADY_STARTED_PLACEHOLDER"
if [ ! -e flag/$CONTAINER_ALREADY_STARTED ]; then
  touch flag/$CONTAINER_ALREADY_STARTED

  sleep 30
  counter=1
  max_retry=5
  cypher-shell -a bolt://${NEO4J_HOSTNAME}:${NEO4J_BOLT_PORT} -u ${NEO4J_USERNAME} -p ${NEO4J_PASSWORD} --fail-fast --format plain "MATCH (n) RETURN count(n) AS count LIMIT 1" > /dev/null 2>&1
  result=$?
  while [ $result -ne 0 ] && [ $counter -le $max_retry ]
  do
    # echo "Welcome $counter times"
    sleep 5
    counter=$(( $counter + 1 ))
    cypher-shell -a bolt://${NEO4J_HOSTNAME}:${NEO4J_BOLT_PORT} -u ${NEO4J_USERNAME} -p ${NEO4J_PASSWORD} --fail-fast --format plain "MATCH (n) RETURN count(n) AS count LIMIT 1" > /dev/null 2>&1
    result=$?
  done

  log_info  "Wrapper: Loading cyphers from '/import'"
  for cipherFile in import/*.cql; do
      log_info "Running cypher ${cipherFile}"
      contents=$(cat ${cipherFile})
      cypher-shell -a bolt://${NEO4J_HOSTNAME}:${NEO4J_BOLT_PORT} -u ${NEO4J_USERNAME} -p ${NEO4J_PASSWORD} "${contents}"
  done
  log_info  "Finished loading all cyphers from '/import'"
  TOTAL_CHANGES=$(cypher-shell -a bolt://${NEO4J_HOSTNAME}:${NEO4J_BOLT_PORT} -u ${NEO4J_USERNAME} -p ${NEO4J_PASSWORD} --format plain "MATCH (n) RETURN count(n) AS count")
  log_info "Wrapper: Changes $(echo ${TOTAL_CHANGES} | sed -e 's/[\r\n]//g')"
fi


# https://stackoverflow.com/questions/15520339/how-to-remove-carriage-return-and-newline-from-a-variable-in-shell-script/15520508#15520508
# log_info "Wrapper: Changes $(echo ${TOTAL_CHANGES} | sed -e 's/[\r\n]//g')"

# now we bring the primary process back into the foreground
# and leave it there
