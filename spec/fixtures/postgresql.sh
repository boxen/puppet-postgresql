# Postgres config vars

export BOXEN_POSTGRESQL_PORT=15432
export BOXEN_POSTGRESQL_URL="postgres://localhost:$BOXEN_POSTGRESQL_PORT/"

# soft global overrides

[ -z "$PGPORT" ] && {
	export PGPORT=$BOXEN_POSTGRESQL_PORT
}
