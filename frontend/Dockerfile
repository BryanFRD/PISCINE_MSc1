# Étape 1 : Construction de l'application Vue.js
FROM node:18-alpine AS build-stage

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier les fichiers package.json et package-lock.json
COPY package*.json ./

# Installer les dépendances
RUN npm install --include=optional

# Copier le reste des fichiers du projet
COPY . .

# Build de l'application pour la production
RUN npm run build

# Étape 2 : Image de production pour servir les fichiers statiques
FROM nginx:alpine AS production-stage

# Copier les fichiers générés dans l'image Nginx
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Copier le fichier de configuration par défaut de Nginx
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Exposer le port 80
EXPOSE 80

# Démarrer Nginx
CMD ["nginx", "-g", "daemon off;"]