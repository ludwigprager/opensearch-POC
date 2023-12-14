#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR


source ./functions.sh
source ./set-env.sh

FOO_PID=""
function finish {
  echo killing $FOO_PID
  kill $FOO_PID
}
trap finish INT TERM EXIT



./kubectl port-forward --address 0.0.0.0 svc/opensearch-cluster-master 9200:9200 &
FOO_PID=$!
wait-for-port-forward 9200

ARTICLE_ID=$RANDOM$RANDOM

SVC=localhost

curl --fail -XGET --insecure -u 'admin:admin' "https://$SVC:9200"

# Create your first index.
curl --fail -XPUT --insecure -u 'admin:admin' "https://$SVC:9200/my-first-index${ARTICLE_ID}"

# Add some data to your newly created index.
curl --fail -XPUT --insecure -u 'admin:admin' "https://$SVC:9200/my-first-index${ARTICLE_ID}/_doc/1" -H 'Content-Type: application/json' -d '{"Description": "To be or not to be, that is the question."}'

# Retrieve the data to see that it was added properly.
curl --fail -XGET --insecure -u 'admin:admin' "https://$SVC:9200/my-first-index${ARTICLE_ID}/_doc/1"

# aus: https://dev.to/ankitmalikg/opensearch-crud-operation-with-curl-4dka
curl --fail -XPUT --insecure -u 'admin:admin' "https://$SVC:9200/dev-article${ARTICLE_ID}" -H 'Content-Type: application/json' -d '
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  },
  "mappings": {
    "properties": {
      "title": {
        "type": "text"
      },
      "content": {
        "type": "text"
      }
    }
  }
}'

curl --fail -XPOST --insecure -u 'admin:admin' "https://$SVC:9200/dev-article${ARTICLE_ID}/_doc" -H 'Content-Type: application/json' -d '
{
  "title": "Getting Started with OpenSearch",
  "content": "OpenSearch is a powerful open-source search and analytics engine..."
}'

# curl -XGET "http://$SVC:9200/dev-article${ARTICLE_ID}/_doc/{document_id}"


# curl -XPOST "http://$SVC:9200/dev-article${ARTICLE_ID}/_doc/{document_id}/_update" -H 'Content-Type: application/json' -d '
# {
#   "doc": {
#     "content": "OpenSearch is a powerful open-source search and analytics platform..."
#   }
# }'

# curl -XDELETE "http://$SVC:9200/dev-article${ARTICLE_ID}/_doc/{document_id}"
