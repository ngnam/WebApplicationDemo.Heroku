FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine AS builder
WORKDIR /source
COPY . .
RUN dotnet restore
RUN dotnet publish -c Release -r linux-musl-x64 -o /app

FROM node:10.13.0-alpine as node
WORKDIR /app
COPY bower.json ./
COPY .bowerrc ./
RUN npm install bower --progress=true --loglevel=silent
RUN bower install

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine
WORKDIR /app
#COPY --from=builder /app .
#COPY --from=node /app/build ./wwwroot
CMD ASPNETCORE_URLS=http://*:$PORT ./WebApplicationDemo.Heroku
