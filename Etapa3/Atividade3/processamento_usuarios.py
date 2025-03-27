import pandas as pd
import json

def carregar_dados(nome_arquivo):
    with open(nome_arquivo, 'r') as f:
        dados = json.load(f)
    return pd.DataFrame(dados['usuarios'])

def filtrar_usuarios(df):
    return df[df['idade'] > 18]

def ordenar_usuarios(df):
    return df.sort_values(by='idade')

def gerar_relatorio(df):
    return df.to_dict(orient='records')

if __name__ == "__main__":
    df = carregar_dados('usuarios.json')
    
    df_filtrado = filtrar_usuarios(df)
    
    df_ordenado = ordenar_usuarios(df_filtrado)
    
    relatorio = gerar_relatorio(df_ordenado)
    
    print(relatorio)
