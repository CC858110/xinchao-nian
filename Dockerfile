FROM node:20-slim

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY xinchao /app/xinchao

WORKDIR /app/xinchao
RUN npm install

EXPOSE 18110

CMD ["npm", "start"]
