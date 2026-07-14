#!/bin/bash

mkdir -p final_project
cd final_project

if [ ! -d "oaqjp-final-project-emb-ai" ]; then
        git clone https://github.com/Oscar-Amacende/oaqjp-final-project-emb-ai
fi

#touch emotion_detection.py
cat << 'EOF' > emotion_detection.py
import requests

#Funcion de detección de emociones
def emotion_detector(text_to_analyze):
    url = "https://sn-watson-emotion.labs.skills.network/v1/watson.runtime.nlp.v1/NlpService/EmotionPredict"

    #Headers
    headers = {
        "grpc-metadata-mm-model-id": "emotion_aggregated-workflow_lang_en_stock"
    }

    #Crear el JSON
    input_json = {
        "raw_document": {
        "text": text_to_analyze
        }
    }
    #Hacer la peticion
    response = requests.post(
        url,
        json=input_json,
        headers=headers
    )

    #Obtener respuestas
    result = response.json()
    return response.text
EOF

#Copiamos al otro archivo
cp emotion_detection.py 2a_emotion_detection

#importamos lo necesario de python
python3 -m pip install requests

#Importamos la aplicacion
python3 -c 'from emotion_detection import emotion_detector; print(emotion_detector("I love this new technology"))' > 2b_application_creation
echo "Salida de programa : \n\n"
cat 2b_application_creation

#Agregamos la biblioteca de json
sed -i '/import requests/a import json' emotion_detection.py

#Agregar al programa   ahora sed si modifica el archivo
sed -i '/return response.text/i\ \tresponse_dict = json.loads(response.text)\print(response_dict)' emotion_detection.py
