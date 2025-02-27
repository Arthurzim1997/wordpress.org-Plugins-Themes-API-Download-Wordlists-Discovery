#!/bin/bash
# Script para extrair plugins, gerar wordlists individuais e globais.

# Diretórios de entrada e saída
PLUGINS_DIR="plugins_downloads_file"
OUTPUT_DIR="wordlists_plugins"
VERSION_DIR="$OUTPUT_DIR/wordlists_plugins_version"
TEMP_DIR="temp_extract"

# Criação dos diretórios principais
mkdir -p "$OUTPUT_DIR" "$VERSION_DIR"

# Verifica se a pasta de plugins existe
if [ ! -d "$PLUGINS_DIR" ]; then
  echo "❌ Diretório $PLUGINS_DIR não encontrado!"
  exit 1
fi

# Arquivos temporários para wordlists globais
global_files_tmp=$(mktemp)
global_dirs_tmp=$(mktemp)

# Processa cada plugin (subpasta em PLUGINS_DIR)
for plugin_dir in "$PLUGINS_DIR"/*/; do
  [ -d "$plugin_dir" ] || continue
  plugin_name=$(basename "$plugin_dir")

  echo "📦 Processando plugin: $plugin_name"

  # Cria a pasta de wordlists para esse plugin dentro de wordlists_plugins_version/
  plugin_output_dir="$VERSION_DIR/$plugin_name"
  mkdir -p "$plugin_output_dir"

  # Arquivos temporários para armazenar todas as versões desse plugin
  all_files_tmp=$(mktemp)
  all_dirs_tmp=$(mktemp)

  # Processa cada versão do plugin
  for zipfile in "$plugin_dir"/*.zip; do
    [ -f "$zipfile" ] || continue
    version_name=$(basename "$zipfile" .zip)

    echo "   🔄 Processando versão: $version_name"
    echo "   Extraindo $zipfile para pasta temporária..."

    # Cria a pasta temporária e extrai o zip
    rm -rf "$TEMP_DIR" && mkdir -p "$TEMP_DIR"
    unzip -q "$zipfile" -d "$TEMP_DIR"

    # Verifica se o conteúdo extraído está dentro de uma subpasta com o mesmo nome do plugin.
    if [ -d "$TEMP_DIR/$plugin_name" ]; then
      base_extract="$TEMP_DIR/$plugin_name"
    else
      base_extract="$TEMP_DIR"
    fi

    # Define a pasta para essa versão dentro de wordlists_plugins_version
    version_output_dir="$plugin_output_dir/$version_name"
    mkdir -p "$version_output_dir"

    # Define os nomes das wordlists individuais
    files_wordlist="$version_output_dir/files_${version_name}.txt"
    directories_wordlist="$version_output_dir/directories_${version_name}.txt"
    all_wordlist="$version_output_dir/all_${version_name}.txt"

    echo "   📝 Gerando wordlists para $version_name"

    # Wordlist de arquivos
    find "$base_extract" -type f | sed "s|^$base_extract|wp-content/plugins/$plugin_name|" > "$files_wordlist"
    
    # Wordlist de diretórios com barra final
    find "$base_extract" -type d | sed "s|^$base_extract|wp-content/plugins/$plugin_name|" | sed 's|\([^/]\)$|\1/|' > "$directories_wordlist"

    # Wordlist combinada (arquivos + diretórios)
    cat "$directories_wordlist" "$files_wordlist" > "$all_wordlist"

    # Adiciona os caminhos aos arquivos temporários do plugin
    cat "$files_wordlist" >> "$all_files_tmp"
    cat "$directories_wordlist" >> "$all_dirs_tmp"

    echo "   ✅ Wordlists salvas em: $version_output_dir"
    rm -rf "$TEMP_DIR"
  done

  # Criação das wordlists gerais por plugin (dentro de wordlists_plugins_version/)
  plugin_files_wordlist="$plugin_output_dir/files_${plugin_name}.txt"
  plugin_dirs_wordlist="$plugin_output_dir/directories_${plugin_name}.txt"
  plugin_all_wordlist="$plugin_output_dir/all_${plugin_name}.txt"

  sort -u "$all_files_tmp" > "$plugin_files_wordlist"
  sort -u "$all_dirs_tmp" > "$plugin_dirs_wordlist"
  cat "$plugin_files_wordlist" "$plugin_dirs_wordlist" | sort -u > "$plugin_all_wordlist"

  echo "✅ Wordlists combinadas do plugin criadas em: $plugin_output_dir"

  # Adiciona os caminhos aos arquivos temporários globais
  cat "$plugin_files_wordlist" >> "$global_files_tmp"
  cat "$plugin_dirs_wordlist" >> "$global_dirs_tmp"

  # Remove arquivos temporários do plugin
  rm "$all_files_tmp" "$all_dirs_tmp"

done

# Criação das wordlists finais combinadas de TODOS os plugins (dentro de wordlists_plugins/)
global_files_wordlist="$OUTPUT_DIR/files_plugins.txt"
global_dirs_wordlist="$OUTPUT_DIR/directories_plugins.txt"
global_all_wordlist="$OUTPUT_DIR/all_plugins.txt"

sort -u "$global_files_tmp" > "$global_files_wordlist"
sort -u "$global_dirs_tmp" > "$global_dirs_wordlist"
cat "$global_files_wordlist" "$global_dirs_wordlist" | sort -u > "$global_all_wordlist"

echo "🎯 Wordlists globais criadas: $global_files_wordlist | $global_dirs_wordlist | $global_all_wordlist"

# Remove arquivos temporários globais
rm "$global_files_tmp" "$global_dirs_tmp"

echo "✅ Processo concluído com sucesso!"
