#!/bin/bash

# Log the info with the same format as NEO4J outputs
log_info() {
  # https://www.howtogeek.com/410442/how-to-display-the-date-and-time-in-the-linux-terminal-and-use-it-in-bash-scripts/
  printf '%s %s\n' "$(date -u +"%Y-%m-%d %H:%M:%S:%3N%z") INFO  Wrapper: $1"
  return
}

log_info  "Wrapper: Loading cyphers from '/import'"
for cipherFile in import/*.cql; do
  if [ -e ${cipherFile} ]; then
    log_info "Running cypher ${cipherFile}"
    contents=$(cat ${cipherFile})
    cypher-shell -a bolt://${NEO4J_HOSTNAME}:${NEO4J_BOLT_PORT} -u ${NEO4J_USERNAME} -p ${NEO4J_PASSWORD} "${contents}"
    rm ${cipherFile}
  fi
done
log_info  "Finished loading all cyphers from '/import'"
