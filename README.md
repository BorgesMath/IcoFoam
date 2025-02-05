### IcoFoam e o Escoamento de Hele-Shaw
[NOTION DA SIMULAÇÃO](https://www.notion.so/IcoFoam-1915cfe25b5f802da782eab6816d821f)


### **Introdução ao IcoFoam**

O **IcoFoam** é um solver do OpenFOAM utilizado para simular escoamentos incompressíveis e transientes em regime laminar. Ele resolve as equações de Navier-Stokes para fluidos newtonianos, empregando o método dos volumes finitos. O solver é adequado para problemas onde a turbulência não é dominante e pode ser aplicado a diversas situações, como a simulação de escoamentos internos e externos em geometrias complexas.

### **Escoamento de Hele-Shaw**

O **escoamento de Hele-Shaw** ocorre entre duas placas paralelas muito próximas, gerando um perfil de velocidade semelhante ao escoamento de Poiseuille em regime bidimensional. Esse tipo de escoamento é governado pela equação de Brinkman, que se assemelha à equação de Darcy para meios porosos. Ele é amplamente estudado em aplicações como a modelagem de escoamentos em meios porosos, injeção de polímeros e processos microfluídicos.

### **Uso do IcoFoam no Escoamento de Hele-Shaw**

O IcoFoam pode ser adaptado para estudar escoamentos do tipo Hele-Shaw ao ajustar a viscosidade e as condições de contorno para representar a resistência imposta pelas paredes. Além disso, a equação de Brinkman pode ser implementada para capturar melhor os efeitos viscosos em diferentes materiais.

## Geometria [Dolomite1.pdf](https://www.notion.so/1915cfe25b5f803b8b31d64352be3cd4?pvs=21)

The geometry consists of a microfluidic channel packed with a quasi-monolayer of crushed marble. The key dimensions are:

- **Length (L):** 1690μm
- **Width (W):** 1200 μm
- **Depth (H):** 55 μm
- **Bulk cross-sectional area (A):** 6.5 × 10⁴ μm²
- **Mean equivalent grain diameter (dp):** 53 ± 24 μm
- **Mean porosity (ϕ):** 0.27

