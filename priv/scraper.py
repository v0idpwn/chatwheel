import requests
import time
import os
import json
from bs4 import BeautifulSoup

print("Getting heroes list")

heroes = []
heroes_page = requests.get("https://dota2.fandom.com/wiki/Heroes_by_release")
soup = BeautifulSoup(heroes_page.content, 'html.parser')
rows = soup.find_all('tr')
for row in rows[2:]:
  hero = row.contents[1].contents[0].contents[0].get('href').split("/wiki/")[1]
  heroes.append(hero)

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
  time.sleep(3)

## Data processing
print("Preparing data for write")
all_hero_list = []
counter = 0
for hero, results in hero_results.items():
  for hero_result in results:
    counter += 1
    name = f"{hero.replace('_', ' ')} - {hero_result['description']}"
    all_hero_list.append({"id": counter, "name": name, "url": hero_result["url"], "tags": [hero]})

## Dumping
print("Starting dump")
f = open("audios.json", "a")
f.write(json.dumps(all_hero_list))
f.close()
print("Dump finished")
