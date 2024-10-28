import json
import os
from time import sleep
from urllib.parse import urlsplit
from bs4 import BeautifulSoup
import requests


####################################################################################
# This script crawls over 250 recipes from "https://www.regional-saisonal.de and
# stores their data in a JSON file. An image for each recipe is downloaded and stored
# to a folder. The links to each recipe are read in from a text file.
#
# Adjust the folder_path according to your setup.
####################################################################################

base_url = "https://www.regional-saisonal.de"
folder_path = "/Users/someUser/Documents/Projects"

def download_image(img_url, folder_path):
    file_name = os.path.basename(urlsplit(img_url).path)
    os.makedirs(folder_path, exist_ok=True)
    file_path = os.path.join(folder_path, file_name)

    response = requests.get(img_url)
    if response.status_code == 200:
        with open(file_path, 'wb') as file:
            file.write(response.content)
        print(f"Image saved to {file_path}")
    else:
        print(f"Failed to download image. Status code: {response.status_code}")

def parse_recipe_page(url):
    response = requests.get(url)
    response.encoding = 'utf-8'
    if response.status_code != 200:
        print(f"Failed to retrieve {url}")
        return None
    
    soup = BeautifulSoup(response.text, "html.parser")

    try:
        title = soup.find('h1').text.strip()
        category = soup.select_one('p.kleinklein:nth-child(6) > a:nth-child(1)').text.strip()
        effort = soup.select_one('p.kleinklein:nth-child(6) > a:nth-child(2)').text.strip()
        price = soup.select_one('p.kleinklein:nth-child(6) > a:nth-child(3)').text.strip()
        description = soup.select_one('p.einleitung').text.strip()

        category_info = soup.select_one('p.kleinklein:nth-child(6)').decode_contents()
        for_groups = "ja" in category_info.split("für Gruppen:")[-1].split("•")[0]
        vegetarian = "ja" in category_info.split("vegetarisch:")[-1].split("•")[0]

        h2_element = soup.select_one("#col3_inner_col3_content > h2:nth-child(2)")
        paragraphs = []
        if h2_element:
            for sibling in h2_element.find_next_siblings():
                if sibling.name == "p" and ("rezept_vorschlag" in sibling.get("class", []) or sibling.find("strong")):
                    break
                if sibling.name == "p":
                    paragraphs.append(sibling.get_text(strip=True))
        instructions = "".join(paragraphs)

        seasonal_data = extract_seasonal_data(soup)

        img_url = soup.select_one("img.rezept_pic")["src"]
        download_image(base_url + img_url, folder_path + '/recipe_images')

        ingredients_by_persons = extract_ingredients_by_persons(url)

        return {
            "title": title,
            "category": category,
            "effort": effort,
            "price": price,
            "is_favorite": False,
            "for_groups": for_groups,
            "vegetarian": vegetarian,
            "source": "regional-saisonal.de",
            "image_name": os.path.basename(urlsplit(img_url).path),
            "description": description,
            "instructions": instructions,
            "seasonal_data": seasonal_data,
            "ingredients_by_persons": ingredients_by_persons,
        }
    except Exception as e:
        print(f"ERROR: While parsing recipe page: {e}")
        return None

def extract_seasonal_data(soup):
    deutsche_monate = ["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"]
    seasonal_data = {}
    table_row = soup.select(".saison_tabelle_rezept tr")[1]

    if table_row:
        tds = table_row.find_all("td")
        for i, td in enumerate(tds):
            img = td.find("img")
            alt_text = img.get("alt", "nein") if img else "nein"
            seasonal_data[deutsche_monate[i]] = alt_text
    else:
        print("WARNING: No table row found for seasonal data")

    return seasonal_data

def extract_ingredients_by_persons(url):
    ingredients_by_persons = {}
    for i in range(1, 11):
        payload = {'grundmenge_eingabe': i}
        response = requests.post(url, data=payload)
        response.encoding = 'utf-8'

        if response.status_code != 200:
            print(f"FAILED to retrieve data for {i} persons.")
            continue

        soup = BeautifulSoup(response.text, "html.parser")
        ingredient_table = soup.select_one(".full")

        ingredients = {}
        if ingredient_table:
            for row in ingredient_table.find_all("tr"):
                tds = row.find_all("td")
                quantity = tds[0].get_text(strip=True) if tds[0].get_text(strip=True) else ""
                ingredient = tds[1].find("a").get_text(strip=True) if tds[1].find("a") else tds[1].get_text(strip=True)
                ingredients[ingredient] = quantity
        else:
            print("WARNING: Ingredient table not found.")

        ingredients_by_persons[i] = ingredients

    return ingredients_by_persons


if __name__ == "__main__":
    with open(folder_path + "/recipe_links.txt", "r", encoding="utf-8") as file:
        recipe_paths = [line.strip() for line in file.readlines()]

    data = []
    for x, path in enumerate(recipe_paths):
        sleep(0.2) # delay, used to not overwhelm the server
        recipe_data = parse_recipe_page(base_url + path)
        if recipe_data:
            recipe_data["id"] = x
            data.append(recipe_data)

    try:
        with open(folder_path + '/recipe_data.json', 'w', encoding='utf-8') as json_file:
            json.dump(data, json_file, ensure_ascii=False, indent=4)
        print(f"SUCCESS: Data written to file {folder_path}/recipe_data.json")
    except Exception as e:
        print(f"ERROR: {e}")
