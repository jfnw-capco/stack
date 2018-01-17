# Commands

docker-compose -p "api" up --scale api-app=3 -d

curl -H Host:api.example.com http://localhost:80
