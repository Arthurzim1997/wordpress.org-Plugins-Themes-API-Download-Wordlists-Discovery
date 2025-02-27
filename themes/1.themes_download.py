import requests
import os

# URLs da API para temas
THEMES_LIST_URL = "https://api.wordpress.org/themes/info/1.2/?action=query_themes&request[page]={page}&request[per_page]=250"
THEME_INFO_URL = "https://api.wordpress.org/themes/info/1.2/?action=theme_information&request[slug]={slug}"

# Criar diretório para salvar os arquivos de temas
SAVE_DIR = "themes_downloads"
os.makedirs(SAVE_DIR, exist_ok=True)

def get_all_themes():
    """ Obtém todos os temas disponíveis na API do WordPress """
    all_themes = []
    page = 1

    while True:
        print(f"🔄 Buscando temas na página {page}...")
        url = THEMES_LIST_URL.format(page=page)
        response = requests.get(url)
        data = response.json()

        themes = data.get("themes", [])
        if not themes:
            print("✅ Nenhum tema encontrado! Fim da busca.")
            break  # Sai do loop quando não houver mais temas

        print(f"✅ {len(themes)} temas encontrados na página {page}.")
        all_themes.extend(themes)
        page += 1

    print(f"🎯 Total de temas coletados: {len(all_themes)}\n")
    return all_themes

def get_theme_versions(slug):
    """ Obtém todas as versões disponíveis de um tema específico """
    url = THEME_INFO_URL.format(slug=slug)
    response = requests.get(url)
    data = response.json()

    download_links = set()  # Usar um set() para remover duplicatas automaticamente

    # ✅ Garante que o "download_link" sempre será incluído
    if "download_link" in data and data["download_link"]:
        print(f"   🚀 Adicionando link principal: {data['download_link']}")
        download_links.add(data["download_link"])

    # ✅ Adiciona todas as versões disponíveis
    versions = data.get("versions", {})
    if isinstance(versions, dict) and versions:
        print(f"   🔍 {len(versions)} versões encontradas para {slug}.")
        download_links.update(versions.values())
    else:
        print(f"   ⚠️ O tema {slug} não tem versões listadas na API.")

    return list(download_links)  # Converte de volta para lista antes de retornar

# Obtém todos os temas do repositório WordPress
all_themes = get_all_themes()

for index, theme in enumerate(all_themes, start=1):
    slug = theme["slug"]
    
    print(f"🎨 ({index}/{len(all_themes)}) Coletando versões de: {slug}")
    download_links = get_theme_versions(slug)

    # Se não houver links, pular para o próximo tema
    if not download_links:
        print(f"   ⚠️ Nenhum link encontrado para {slug}. Pulando...\n")
        continue

    # Criar um arquivo para esse tema
    theme_file_path = os.path.join(SAVE_DIR, f"{slug}.txt")
    
    with open(theme_file_path, "w") as file:
        for link in sorted(download_links):  # Ordena para melhor organização
            file.write(link + "\n")
    
    print(f"   ✅ Links de {slug} salvos ({len(download_links)} versões) em {theme_file_path}\n")

print("\n🎯 Todos os temas foram processados e salvos!")
