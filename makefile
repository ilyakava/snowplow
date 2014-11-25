# publishes to sonatype, OSS maven repo
deploy:
	$(info "using credentials in ~/.sbt/0.13/sonatype.sbt, and passphrase in ~/.sbt/0.13/pgp.sbt")
	cd 3-enrich/scala-common-enrich/; sbt publishSigned
