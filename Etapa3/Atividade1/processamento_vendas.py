import pandas as pd

def carregar_dados(caminho_arquivo):
    return pd.read_csv(caminho_arquivo)

def calcular_valor_total(df):
    df['valor_total'] = df['quantidade'] * df['preco_unitario']
    return df

def filtrar_vendas(df):
    return df[df['valor_total'] > 500]

def salvar_resultado(df, caminho_saida):
    df.to_csv(caminho_saida, index=False)

def main():
    df = carregar_dados('vendas.csv')

    df = calcular_valor_total(df)

    df_filtrado = filtrar_vendas(df)

    salvar_resultado(df_filtrado, 'vendas_filtradas.csv')

    print("Processamento concluído! O arquivo 'vendas_filtradas.csv' foi gerado.")

