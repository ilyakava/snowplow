# default arg
APP=snowplow-kinesis-redshift-sink

deploy_clean:
	rm -rf ./.deploy

set_vars:
	# set variables for commit message
	$(eval CURR_DEPLOYER=$(shell whoami;echo $))
	$(eval CURR_HASH=$(shell git rev-parse HEAD;echo $))
	$(eval CURR_AUTHOR=$(shell git --no-pager show -s --format='%an <%ae>';echo $))

# pushes current local changes to heroku
# ex: make APP=snowplow-kinesis-redshift-sink deploy
deploy: deploy_clean set_vars
	# make directory and copy data
	mkdir -p ./.deploy
	cp -r ./4-storage/kinesis-redshift-sink/* ./.deploy/
	cp ./4-storage/kinesis-redshift-sink/.gitignore ./.deploy/

	# make git repo
	git --git-dir ./.deploy/.git --work-tree ./.deploy/ init
	git --git-dir ./.deploy/.git --work-tree ./.deploy/ add --a
	git --git-dir ./.deploy/.git --work-tree ./.deploy/ commit -m '${CURR_DEPLOYER} deployed: ${CURR_HASH} by ${CURR_AUTHOR}'
	# push git repo
	git --git-dir ./.deploy/.git --work-tree ./.deploy push git@heroku.com:${APP}.git master --force
	$(info "DONE pushing local branch master to heroku app: ${APP}")
