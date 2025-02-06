#!/bin/bash

base_case="HeleShaw"
increment=10     
iteration=1      


# Primeira parte
# Ta achando?
if [ ! -d "$base_case" ]; then
    echo "Erro: '$base_case' não encontrado."
    exit 1
fi

#Achar xMesh antigo
xMesh=$(awk '/xMesh/ {gsub(/;/, "", $2); print $2}' "$base_case/system/parametersMesh")

# Limpar results
> results.txt


while [ $iteration -le 10 ]; do
    case_name="${base_case}_Ref${iteration}"
    echo "Criando caso: $case_name"

    # Copiar o caso base
    cp -r "$base_case" "$case_name"

    # Atualizar valores da malha
    xMesh=$((xMesh + increment))
    yMesh=$(awk "BEGIN {printf \"%d\", $xMesh * 0.2}")


    # Modificar o arquivo parameters
    sed -i "s/xMesh.*/xMesh  $xMesh;/" "$case_name/system/parametersMesh"
    sed -i "s/yMesh.*/yMesh  $yMesh;/" "$case_name/system/parametersMesh"

    # Executar a simulação
    cd "$case_name" || exit
    blockMesh
    icoFoam
    cd ..

    # Extrair o fluxo de entrada do arquivo do caso atual
    flow=$(tail -n1 "$case_name/postProcessing/inletFlow/0/surfaceFieldValue.dat" | sed -E 's/.*\(([0-9.eE+-]+).*/\1/')

    # Calcular o produto xMesh * yMesh (opcional, se desejar usar)
    product=$(echo "$xMesh * $yMesh" | bc -l)

    # Gravar os resultados no arquivo results.txt
    echo "$case_name $flow $product" >> results.txt

    # Atualizar o contador de iterações
    ((iteration++))
done
