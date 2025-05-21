# end-to-end testing in CI-pipeline commands

Start by setting up project:
```
cd osrm-project

docker compose up -d
```

### For non-containerized testing:
```
cd osrm-project/tests

npm install

npx playwright test
```

### For containerized testing:
```
cd tests

docker build -t osrm-tests .

docker run osrm-tests
```
For linux, `--net="host"` might be needed.