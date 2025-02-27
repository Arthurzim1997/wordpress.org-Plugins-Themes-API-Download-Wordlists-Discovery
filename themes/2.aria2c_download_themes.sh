#!/bin/bash
# Script para baixar os arquivos listados em cada TXT na pasta themes_downloads,
# salvando os downloads em subpastas (com nomes iguais aos TXT) dentro da pasta themes_downloads_file.
# O script executa até 6 processos aria2c em paralelo e remove arquivos vazios ao final.

INPUT_DIR="themes_downloads"          # Diretório onde estão os arquivos .txt com os links
OUTPUT_BASE="themes_downloads_file"   # Diretório base onde os downloads serão salvos

echo "🔄 Iniciando o processo de download dos temas..."

# Verifica se o diretório de entrada existe
if [ ! -d "$INPUT_DIR" ]; then
    echo "❌ Diretório '$INPUT_DIR' não encontrado. Abortando."
    exit 1
fi
echo "✅ Diretório de entrada '$INPUT_DIR' encontrado."

# Cria o diretório de saída, se não existir
if [ ! -d "$OUTPUT_BASE" ]; then
    echo "🔄 Criando diretório de saída: '$OUTPUT_BASE'..."
    mkdir -p "$OUTPUT_BASE"
    echo "✅ Diretório de saída '$OUTPUT_BASE' criado."
else
    echo "✅ Diretório de saída '$OUTPUT_BASE' já existe."
fi

# Função para processar um arquivo .txt e baixar os links com aria2c
download_theme() {
    local txtfile="$1"
    local base_name
    base_name=$(basename "$txtfile" .txt)
    local output_dir="$OUTPUT_BASE/$base_name"

    echo "--------------------------------------------"
    echo "📂 Processando arquivo: $txtfile"
    echo "🎨 Nome do tema: $base_name"

    # Cria a subpasta para o tema
    echo "🔄 Criando subpasta: '$output_dir'..."
    mkdir -p "$output_dir"
    echo "✅ Subpasta '$output_dir' pronta."

    echo "📥 Iniciando download dos links listados em '$txtfile' para '$output_dir'..."
    aria2c -x 8 -s 8 -j 16 -i "$txtfile" -d "$output_dir"
    status=$?
    if [ $status -eq 0 ]; then
        echo "✅ Downloads concluídos em: '$output_dir'"
    else
        echo "❌ Erro ao baixar arquivos em: '$output_dir'"
    fi

    echo "🧹 Removendo arquivos com tamanho 0 em '$output_dir'..."
    find "$output_dir" -type f -size 0 -delete
    echo "✅ Limpeza concluída em: '$output_dir'"
    echo "--------------------------------------------"
}

MAX_PROCS=6  # Número máximo de processos aria2c em paralelo

# Loop para iterar sobre cada arquivo .txt em INPUT_DIR
for txtfile in "$INPUT_DIR"/*.txt; do
    if [ ! -e "$txtfile" ]; then
        echo "⚠️ Nenhum arquivo .txt encontrado em '$INPUT_DIR'."
        continue
    fi

    # Inicia a função download_theme em background
    download_theme "$txtfile" &

    # Limita a execução a MAX_PROCS simultâneos
    while [ "$(jobs -p | wc -l)" -ge "$MAX_PROCS" ]; do
        sleep 1
    done
done

# Aguarda a finalização de todos os processos em background
wait
echo "🎯 Todos os downloads foram processados e finalizados!"
