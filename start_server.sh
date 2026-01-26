#!/bin/bash
cd /app
export RAILS_ENV=development
ruby -I/app -rconfig/boot -rcommands/server
