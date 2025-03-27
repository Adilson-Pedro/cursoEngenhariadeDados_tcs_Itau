import pandas as pd

def carregar_dados(nome_arquivo):
    return pd.read_csv(nome_arquivo)

def realizar_agregacoes(df):
    agregacoes = df.groupby('categoria')['valor'].agg(['sum', 'mean']).reset_index()
    agregacoes.columns = ['categoria', 'soma_valor', 'media_valor']
    return agregacoes

def salvar_dados_em_parquet(df, nome_arquivo):
    df.to_parquet(nome_arquivo, index=False)

def carregar_dados_parquet(nome_arquivo):
    return pd.read_parquet(nome_arquivo)

if __name__ == "__main__":
    df = carregar_dados('dados_agregacao.csv')
    
    df_agregado = realizar_agregacoes(df)
    
    salvar_dados_em_parquet(df_agregado, 'dados_agregados.parquet')
    
    df_carregado = carregar_dados_parquet('dados_agregados.parquet')
    
    print(df_carregado)
