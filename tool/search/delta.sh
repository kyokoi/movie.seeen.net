#!/bin/bash

wget -nv --spider --append-output=/usr/local/apps/movie_seen/log/delta.log http://shma.jp:8983/solr/dataimport?command=delta-import
