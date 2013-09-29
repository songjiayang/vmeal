#!/bin/bash

mysqldump -uroot -h localhost -pweidaxue vmeal_development | gzip -9 > public/mysqlback.sql.gz 
