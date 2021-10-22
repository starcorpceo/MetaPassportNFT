import random
import json

L1_MAX = 5500 # Number of random unique images we want to generate
L2_MAX = 8000
L3_MAX = 8888

IMAGES_BASE_URI = "https://YOUR_S3.s3.amazonaws.com/"
PROJECT_NAME = "Meta Passport Level "
IPFS_URI = "ipfs://YOUR_IPFS_URI/"

def getAttribute(key, value):
    return {
        "trait_type": key,
        "value": value
    }

for i in range(1, L3_MAX+1):

    if (i <= 5500):
        lvl = '1'
    if (i > 5500 and i <= 8000):
        lvl = '2'
    if (i > 8000 and i <= 8888):
        lvl = '3'
    
    token = {
        "image": f'{IMAGES_BASE_URI}{lvl}.jpg',
        "tokenId": i,
        "name": f'{PROJECT_NAME}{lvl} - #{i}',
        "description": f"Meta Passport is the Passport for Multi-Metaverse. This is MetaMata Level {lvl} Passport - access to Level {lvl} rights.",
        "ipfs_image": f'{IPFS_URI}{lvl}.jpg',
        "attributes": []
    }

    token["attributes"].append(getAttribute("Level", lvl))

    with open(f'./metapass-metadata/{i}.json', 'w') as outfile:
        json.dump(token, outfile, indent=4)

