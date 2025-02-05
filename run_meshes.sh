#!/bin/bash

# Nome do caso base
base_case="HeleShaw"

# Criar diretório inicial
if [ ! -d "$base_case" ]; then
    echo "Erro: Diretório do caso base '$base_case' não encontrado."
    exit 1
fi

# Inicializar variáveis
tolerance=0.05  # 5% de diferença
previous_flow=0  # Valor inicial para comparação
increment=30     # Incremento fixo para xMesh
iteration=1      # Contador de iterações

# Obter o valor inicial de xMesh
xMesh=$(awk '/xMesh/ {print $2}' "$base_case/system/parameters")

while true; do
    case_name="${base_case}_Ref${iteration}"
    echo "Criando caso: $case_name"

    # Copiar o caso base
    cp -r "$base_case" "$case_name"

    # Atualizar valores da malha
    xMesh=$((xMesh + increment))
    yMesh=$((xMesh / 2))  # yMesh sempre é xMesh / 2

    # Modificar o arquivo parameters
    sed -i "s/xMesh.*/xMesh  $xMesh;/" "$case_name/system/parameters"
    sed -i "s/yMesh.*/yMesh  $yMesh;/" "$case_name/system/parameters"

    # Executar a simulação
    cd "$case_name" || exit
    blockMesh
    icoFoam
    cd ..

    # Extrair o fluxo de entrada
    flow=$(grep -oP '(?<=areaIntegrate = )[-+0-9.e]+' "$case_name/postProcessing/inletFlow/0/surfaceFieldValue.dat")

    # Comparar com o fluxo anterior
    if (( $(echo "$previous_flow > 0" | bc -l) )); then
        diff=$(echo "scale=5; ($flow - $previous_flow) / $previous_flow" | bc -l)
        abs_diff=$(echo "$diff" | awk '{print ($1 < 0) ? -$1 : $1}')
        echo "Fluxo anterior: $previous_flow, Fluxo atual: $flow, Diferença relativa: $abs_diff"

        if (( $(echo "$abs_diff < $tolerance" | bc -l) )); then
            echo "Critério de convergência atingido. Parando."
            break
        fi
    fi

    # Atualizar valores para a próxima iteração
    previous_flow=$flow
    ((iteration++))
done
