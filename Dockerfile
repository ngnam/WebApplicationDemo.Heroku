#FROM node:10.13.0-alpine as node
#WORKDIR /app
#COPY bower.json ./
#COPY .bowerrc ./
#RUN npm install --progress=true --loglevel=silent
#COPY src/client ./src/client/
#RUN npm run build

#FROM node:10.13.0-alpine as node
#RUN cd ./HealthCheck/ClientApp && npm install --progress=true --loglevel=silent

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine AS builder
WORKDIR /source
#COPY ./HealthCheck .
COPY . .
RUN dotnet restore
RUN dotnet publish -c Release -r linux-musl-x64 -o /app-healthcheck ./HealthCheck

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine
WORKDIR /app-healthcheck
#COPY --from=builder /app .
#COPY --from=node /app/build ./wwwroot
CMD ASPNETCORE_URLS=http://*:$PORT ./HealthCheck
