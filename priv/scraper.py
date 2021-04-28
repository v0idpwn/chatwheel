import requests
import time
import json
from bs4 import BeautifulSoup

heroes = ["Rubick"]
hero_results = {}

## Data gathering
for hero in heroes:
  print(f"Requesting {hero} page")
  page = requests.get(f"https://dota2.fandom.com/wiki/{hero}/Responses")
  soup = BeautifulSoup(page.content, 'html.parser')
  audios = soup.find_all('audio')
  results = []

  for audio in audios:
    audio_description = audio.parent.parent.contents[-1].string
    audio_url = audio.find('a').get('href').split("mp3")[0] + "mp3"
    results.append({'url': audio_url, 'description': audio_description})

  unique_results = {a["description"]: a for a in results}.values()
  hero_results[hero] = unique_results

  print(f"{hero} complete, sleeping for a while...")
  time.sleep(5)

## Data processing
all_hero_list = []
counter = 0
for hero, results in hero_results.items():
  for hero_result in results:
    counter += 1
    name = f"{hero} - {hero_result['description']}"
    all_hero_list.append({"id": counter, "name": name, "url": hero_result["url"], "tags": [hero]})

## Dumping
print(json.dumps(all_hero_list))
