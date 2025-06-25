## AS build é uma etapa de build
FROM node:20-alpine AS build

## Criar um diretório dentro da imagem
WORKDIR /usr/src/app

## COPY package.json package-lock.json ./
COPY package*.json ./

RUN npm i

COPY . .

RUN npm run build
################################################################
## AS runtime é uma etapa de runtime                          ##
## Nesse estágia já temos o build na contruçao da imagem.     ##
## Nesse podemos aproveitar desse build                       ##
################################################################
FROM node:20-alpine AS runtime

## Criar um diretório dentro da imagem
WORKDIR /usr/src/app

## Copiar o build e node_modules do node para a imagem
## O /usr/src/app é o diretório padrão do WORKDIR /usr/src/app na linha:4
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

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

#############################################################################################
## Otimização de imagem                                                                    ## 
## 903MB imagem inicial                                                                    ## 
## 705MB (alterado imagem para -slim)                                                      ## 
## 525MB (ajuste dos arquino no .dockerignore)                                             ##
## 438MB (alterado imagem para -alpine)                                                    ##
## 372MB Depois que add etapas de build e runtime, e compiando somente o necessário.       ##
#############################################################################################

##############################
## Criando rede no docker   ##
############################## 
## Listar redes
## docker network ls
## 
## Criar rede
## docker network create api-network
## 
## Remover rede
## docker network rm api-network
##
## Verificar redes
## docker network create --driver bridge api-network
##
## Rodar container com rede
## docker run --rm -p 3000:3000 -d --network api-network api

## Docker volume
## 
## Criar volume
## docker volume create api-volume
## 
## Ligando volume ao container com a rede
## docker run --rm -p 3000:3000 -d --network primeira-network -v api-volume:/usr/src/app api
## 
## docker inspect api-volume
## 
## docker exec -it ID bash