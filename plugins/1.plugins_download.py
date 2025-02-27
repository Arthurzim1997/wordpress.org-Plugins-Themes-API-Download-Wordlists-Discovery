import requests
import os

# URLs da API
PLUGINS_LIST_URL = "https://api.wordpress.org/plugins/info/1.2/?action=query_plugins&request[page]={page}&request[per_page]=250"
PLUGIN_INFO_URL = "https://api.wordpress.org/plugins/info/1.2/?action=plugin_information&request[slug]={slug}"

# Criar diretório para salvar os arquivos de plugins
SAVE_DIR = "plugins_downloads"
os.makedirs(SAVE_DIR, exist_ok=True)

def get_all_plugins():
    """ Obtém todos os plugins disponíveis na API do WordPress """
    all_plugins = []
    page = 1

    while True:
        print(f"🔄 Buscando plugins na página {page}...")
        url = PLUGINS_LIST_URL.format(page=page)
        response = requests.get(url)
        data = response.json()

        plugins = data.get("plugins", [])
        if not plugins:
            print("✅ Nenhum plugin encontrado! Fim da busca.")
            break  # Sai do loop quando não houver mais plugins

        print(f"✅ {len(plugins)} plugins encontrados na página {page}.")
        all_plugins.extend(plugins)
        page += 1

    print(f"🎯 Total de plugins coletados: {len(all_plugins)}\n")
    return all_plugins

def get_plugin_versions(slug):
    """ Obtém todas as versões disponíveis de um plugin específico """
    url = PLUGIN_INFO_URL.format(slug=slug)
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
        print(f"   ⚠️ O plugin {slug} não tem versões listadas na API.")

    return list(download_links)  # Converte de volta para lista antes de retornar

# Obtém todos os plugins do repositório WordPress
all_plugins = get_all_plugins()

for index, plugin in enumerate(all_plugins, start=1):
    slug = plugin["slug"]
    
    print(f"📦 ({index}/{len(all_plugins)}) Coletando versões de: {slug}")
    download_links = get_plugin_versions(slug)

    # Se não houver links, pular para o próximo plugin
    if not download_links:
        print(f"   ⚠️ Nenhum link encontrado para {slug}. Pulando...\n")
        continue

    # Criar um arquivo para esse plugin
    plugin_file_path = os.path.join(SAVE_DIR, f"{slug}.txt")
    
    with open(plugin_file_path, "w") as file:
        for link in sorted(download_links):  # Ordena para melhor organização
            file.write(link + "\n")
    
    print(f"   ✅ Links de {slug} salvos ({len(download_links)} versões) em {plugin_file_path}\n")

print("\n🎯 Todos os plugins foram processados e salvos!")
