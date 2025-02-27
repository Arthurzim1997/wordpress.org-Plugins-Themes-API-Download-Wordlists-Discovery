#!/bin/bash
# Script para extrair temas, gerar wordlists individuais e globais.

# Diretórios de entrada e saída
THEMES_DIR="themes_downloads_file"
OUTPUT_DIR="wordlists_themes"
VERSION_DIR="$OUTPUT_DIR/wordlists_themes_version"
TEMP_DIR="temp_extract"

# Criação dos diretórios principais
mkdir -p "$OUTPUT_DIR" "$VERSION_DIR"

# Verifica se a pasta de temas existe
if [ ! -d "$THEMES_DIR" ]; then
  echo "❌ Diretório $THEMES_DIR não encontrado!"
  exit 1
fi

# Arquivos temporários para wordlists globais
global_files_tmp=$(mktemp)
global_dirs_tmp=$(mktemp)

# Processa cada tema (subpasta em THEMES_DIR)
for theme_dir in "$THEMES_DIR"/*/; do
  [ -d "$theme_dir" ] || continue
  theme_name=$(basename "$theme_dir")

  echo "🎨 Processando tema: $theme_name"

  # Cria a pasta de wordlists para esse tema dentro de wordlists_themes_version/
  theme_output_dir="$VERSION_DIR/$theme_name"
  mkdir -p "$theme_output_dir"

  # Arquivos temporários para armazenar todas as versões desse tema
  all_files_tmp=$(mktemp)
  all_dirs_tmp=$(mktemp)

  # Processa cada versão do tema
  for zipfile in "$theme_dir"/*.zip; do
    [ -f "$zipfile" ] || continue
    version_name=$(basename "$zipfile" .zip)

    echo "   🔄 Processando versão: $version_name"
    echo "   Extraindo $zipfile para pasta temporária..."

    # Cria a pasta temporária e extrai o zip
    rm -rf "$TEMP_DIR" && mkdir -p "$TEMP_DIR"
    unzip -q "$zipfile" -d "$TEMP_DIR"

    # Verifica se o conteúdo extraído está dentro de uma subpasta com o mesmo nome do tema.
    if [ -d "$TEMP_DIR/$theme_name" ]; then
      base_extract="$TEMP_DIR/$theme_name"
    else
      base_extract="$TEMP_DIR"
    fi

    # Define a pasta para essa versão dentro de wordlists_themes_version
    version_output_dir="$theme_output_dir/$version_name"
    mkdir -p "$version_output_dir"

    # Define os nomes das wordlists individuais
    files_wordlist="$version_output_dir/files_${version_name}.txt"
    directories_wordlist="$version_output_dir/directories_${version_name}.txt"
    all_wordlist="$version_output_dir/all_${version_name}.txt"

    echo "   📝 Gerando wordlists para $version_name"

    # Wordlist de arquivos
    find "$base_extract" -type f | sed "s|^$base_extract|wp-content/themes/$theme_name|" > "$files_wordlist"
    
    # Wordlist de diretórios com barra final
    find "$base_extract" -type d | sed "s|^$base_extract|wp-content/themes/$theme_name|" | sed 's|\([^/]\)$|\1/|' > "$directories_wordlist"

    # Wordlist combinada (arquivos + diretórios)
    cat "$directories_wordlist" "$files_wordlist" > "$all_wordlist"

    # Adiciona os caminhos aos arquivos temporários do tema
    cat "$files_wordlist" >> "$all_files_tmp"
    cat "$directories_wordlist" >> "$all_dirs_tmp"

    echo "   ✅ Wordlists salvas em: $version_output_dir"
    rm -rf "$TEMP_DIR"
  done

  # Criação das wordlists gerais por tema (dentro de wordlists_themes_version/)
  theme_files_wordlist="$theme_output_dir/files_${theme_name}.txt"
  theme_dirs_wordlist="$theme_output_dir/directories_${theme_name}.txt"
  theme_all_wordlist="$theme_output_dir/all_${theme_name}.txt"

  sort -u "$all_files_tmp" > "$theme_files_wordlist"
  sort -u "$all_dirs_tmp" > "$theme_dirs_wordlist"
  cat "$theme_files_wordlist" "$theme_dirs_wordlist" | sort -u > "$theme_all_wordlist"

  echo "✅ Wordlists combinadas do tema criadas em: $theme_output_dir"

  # Adiciona os caminhos aos arquivos temporários globais
  cat "$theme_files_wordlist" >> "$global_files_tmp"
  cat "$theme_dirs_wordlist" >> "$global_dirs_tmp"

  # Remove arquivos temporários do tema
  rm "$all_files_tmp" "$all_dirs_tmp"

done

# Criação das wordlists finais combinadas de TODOS os temas (dentro de wordlists_themes/)
global_files_wordlist="$OUTPUT_DIR/files_themes.txt"
global_dirs_wordlist="$OUTPUT_DIR/directories_themes.txt"
global_all_wordlist="$OUTPUT_DIR/all_themes.txt"

sort -u "$global_files_tmp" > "$global_files_wordlist"
sort -u "$global_dirs_tmp" > "$global_dirs_wordlist"
cat "$global_files_wordlist" "$global_dirs_wordlist" | sort -u > "$global_all_wordlist"

echo "🎯 Wordlists globais criadas: $global_files_wordlist | $global_dirs_wordlist | $global_all_wordlist"

# Remove arquivos temporários globais
rm "$global_files_tmp" "$global_dirs_tmp"

echo "✅ Processo concluído com sucesso!"
