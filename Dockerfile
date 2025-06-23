FROM node:20-slim

WORKDIR /usr/src/app

## COPY package.json package-lock.json ./
COPY package*.json ./

RUN npm i

COPY . .

RUN npm run build

EXPOSE 3000

CMD ["npm", "run", "start"]

## Criar uma imagem a partir do Dockerfile
## docker build -t api .
##
## Verificar se a imagem foi criada
## docker image ls api
##
## --rm: Quando o container termina, ele é removido automaticamente.
## -p 3000:3000: Mapeia a porta 3000 do container para a porta 3000 do host.
## -d: Roda o container em segundo plano.
##
## docker run --rm -p 3000:3000 -d api
## 
## docker image ls api

## Otimização de imagem
## 903MB => 705MB => 525MB   -378MB
