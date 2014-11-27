# default app to deploy to
APP=snowplow-scala-kinesis-enrich

deploy_clean:
	rm -rf ./.deploy

set_vars:
	# set variables for commit message
	$(eval CURR_DEPLOYER=$(shell whoami;echo $))
	$(eval CURR_HASH=$(shell git rev-parse HEAD;echo $))
	$(eval CURR_AUTHOR=$(shell git --no-pager show -s --format='%an <%ae>';echo $))


# check for GeoLiteCity.dat
download_geolite:
ifeq (GeoLiteCity.dat, $(shell ls ./3-enrich/scala-kinesis-enrich/ | grep GeoLiteCity.dat))
		$(info 'Found GeoLiteCity.dat file...')
else
		$(info 'No GeoLiteCity.dat file found. Downloading...')
		wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz -O ./3-enrich/scala-kinesis-enrich/GeoLiteCity.dat.gz
		gunzip ./3-enrich/scala-kinesis-enrich/GeoLiteCity.dat.gz
endif

# pushes current local changes to heroku
# ex: make APP=snowplow-scala-kinesis-enrich deploy
deploy: deploy_clean set_vars download_geolite
	# make directory and copy data
	mkdir -p ./.deploy
	cp -r ./3-enrich/scala-kinesis-enrich/* ./.deploy/
	cp ./3-enrich/scala-kinesis-enrich/.gitignore ./.deploy/

	# make git repo
	git --git-dir ./.deploy/.git --work-tree ./.deploy/ init
	git --git-dir ./.deploy/.git --work-tree ./.deploy/ add --a
	git --git-dir ./.deploy/.git --work-tree ./.deploy/ commit -m '${CURR_DEPLOYER} deployed: ${CURR_HASH} by ${CURR_AUTHOR}'
	# push git repo
	git --git-dir ./.deploy/.git --work-tree ./.deploy push git@heroku.com:${APP}.git master --force
