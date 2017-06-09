#!/bin/bash

FSF_CLIENT="/home/nonroot/fsf/fsf-client/fsf_client.py"
BASE_DIR="/home/nonroot/workdir/extracted"
PENDING_DIR="$BASE_DIR/pending"
PROCESSED_DIR="$BASE_DIR/processed"
OUTPUT_DIR="$BASE_DIR/output"
ERROR_DIR="$BASE_DIR/error"

cd $PENDING_DIR

if [ `ls | wc -l` -gt 0 ] ; then
        for i in *; do
                PENDING_FILE="$PENDING_DIR/$i"
                OUTPUT_FILE="$OUTPUT_DIR/$i.json"
                PROCESSED_FILE="$PROCESSED_DIR/$i"
                echo "Processing $PENDING_FILE..."
                $FSF_CLIENT $PENDING_FILE > $OUTPUT_FILE
                echo "Wrote fsf output to $OUTPUT_FILE"
                mv $PENDING_FILE $PROCESSED_FILE
                echo "Moved processed file to $PROCESSED_FILE"
        done
fi

cd - >/dev/null

