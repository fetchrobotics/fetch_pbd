#!/bin/bash
path=`rospack find fetch_pbd_interaction`
cd $path/web_interface/fetch-pbd-gui/compiled_frontend/bundled-es6
python -m SimpleHTTPServer 8080
