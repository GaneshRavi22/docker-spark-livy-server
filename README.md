# Livy Server with PySpark Configured

The default versions of software used in the image are:
* spark_version=2.4.5
* livy_version=0.7.0
* hadoop_version=2.10.0

These can be overridden at the time of building as shown in the below build image section.

## Build the Docker Image
```
docker build \
--build-arg spark_version=2.4.5 \
--build-arg livy_version=0.7.0 \
-t ganesh/livy .
```

## Run the Docker Container
```
docker run --name livy -p 8998:8998 -t ganesh/livy
```

## Send request to Livy Server using curl from Host machine

Below is the curl command to send a simple PySpark batch job request to Livy:
```
curl -X POST \
--data '{"file": "local:///usr/local/lib/python3.6/dist-packages/pyspark/examples/src/main/python/pi.py"}' \
-H "Content-Type: application/json" \
localhost:8998/batches
```

## Open the Livy UI
Go to the followin URL on the web-browser of the host machine: `http://localhost:8998/`

## Open a shell into the running Container for debugging
```
docker exec -it livy /bin/bash
```
