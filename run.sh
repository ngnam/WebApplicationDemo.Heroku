docker build -t HealthCheck .
docker run -p 5000:80 HealthCheck