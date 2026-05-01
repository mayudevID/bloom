#!/bin/bash

cd "$(dirname "$0")/.." || exit

fvm flutter run -d A485A231-E05B-48C8-83A9-08B644420DBF --verbose --flavor staging -t lib/main_staging.dart