#!/bin/bash

base_case="HeleShaw3"
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
    icoFoam | tee log.icoFoam
    cd ..

    # Extrair o fluxo de entrada do arquivo do caso atual
    flow=$(tail -n1 "$case_name/postProcessing/inletFlow/0/surfaceFieldValue.dat" | sed -E 's/.*\(([0-9.eE+-]+).*/\1/')

    # Calcular o produto xMesh * yMesh (opcional, se desejar usar)
    product=$(echo "$xMesh * $yMesh" | bc -l)



        # ----------------------------------------------------------
    # NOVA PARTE: Extrair a média do valor da BC "inlet" do arquivo p
    #
    # Procura o diretório com o último tempo (apenas pastas numéricas)
    last_time=$(ls "$case_name" | grep -E '^[0-9]+(\.[0-9]+)?$' | sort -V | tail -n1)
    p_file="$case_name/$last_time/p"
    
    if [ -f "$p_file" ]; then
        # Procura no arquivo o bloco referente à BC "inlet" e pega a linha com "value"
        inlet_value_line=$(grep -A 3 "inlet" "$p_file" | grep "value")
        # Exemplo da linha obtida:
        #   value           nonuniform List<scalar> 4(0.00110946 0.00100346 0.00100346 0.00110946);
        
        # Extrai os números que estão entre parênteses
        numbers=$(echo "$inlet_value_line" | awk -F'[()]' '{print $2}')
        
        # Calcula a média dos números extraídos
        inlet_avg=$(echo "$numbers" | awk '{sum=0; n=NF; for(i=1;i<=n;i++){sum+=$i} if(n>0) printf "%.8f", sum/n; else print 0}')
    else
        inlet_avg="NA"
    fi
    # ----------------------------------------------------------

    # Gravar os resultados no arquivo results.txt
    echo "$case_name $flow $product $inlet_avg" >> results.txt

    # Atualizar o contador de iterações
    ((iteration++))
done
