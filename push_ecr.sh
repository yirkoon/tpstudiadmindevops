#!/bin/bash
set -e

# Chargement des variables d'environnement depuis le fichier .env : AWS_REGION, AWS_ACCOUNT_ID, REPOSITORY_NAME, IMAGE_TAG
if [ -f .env ]; then
  export $(cat .env | xargs)
else
  echo "Erreur : Fichier .env introuvable ! Veuillez créer le fichier .env selon le modèle fourni dans le .env.example"
  exit 1
fi


ECR_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPOSITORY_NAME}"

echo "Authentification AWS ECR"
aws ecr get-login-password --region "${AWS_REGION}" | docker login --username AWS --password-stdin "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

echo "Vérification / Création du dépôt"
aws ecr describe-repositories --repository-names "${REPOSITORY_NAME}" --region "${AWS_REGION}" || \
aws ecr create-repository --repository-name "${REPOSITORY_NAME}" --region "${AWS_REGION}"

echo "Build de l'image Docker et tag de l'image"
docker build -t "${REPOSITORY_NAME}:${IMAGE_TAG}" .
docker tag "${REPOSITORY_NAME}:${IMAGE_TAG}" "${ECR_URI}:${IMAGE_TAG}"

echo "Push de l'image Docker"
docker push "${ECR_URI}:${IMAGE_TAG}"

echo "Succès : Image poussée sur ${ECR_URI}:${IMAGE_TAG}"