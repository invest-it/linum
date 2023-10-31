lakos --no-tree -o structure.dot -m -i "{lib/generated/**,test/**,integration_test/**}" --node-metrics  ../../
dot -Tsvg -o structure.svg structure.dot

lakos -o structure-by-dir.dot -m -i "{lib/generated/**,test/**,integration_test/**}" --node-metrics  ../../
dot -Tsvg -o structure-by-dir.svg structure-by-dir.dot

lakos --no-tree -o details/core.dot -m -i  --node-metrics  ../../lib/core
dot -Tsvg -o details/core-structure.svg details/core.dot