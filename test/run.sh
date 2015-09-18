#!/bin/bash
set -e
IN=/tmp/filein-$RANDOM
export HADOOP_ROOT_LOGGER=WARN,console

for f in $(ls test*sh | sort); do
  echo ""
  echo "Test: " $f
  read -p "Perform test? [y/n]" -n 1 -r
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    #. $f
    echo "Perfomring $f"
  fi
done

