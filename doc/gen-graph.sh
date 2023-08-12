lakos --no-tree -o structure.dot -m -i "{lib/generated/**,test/**,integration_test/**}" --node-metrics  ../
dot -Tsvg -o structure.svg structure.dot

lakos --no-tree -o core-structure.dot -m -i  --node-metrics  ../lib/core
dot -Tsvg -o core-structure.svg core-structure.dot