import pandas as pd

def carregar_dados(nome_arquivo):
    return pd.read_csv(nome_arquivo)

def calcular_media(df):
    df['media'] = df[['nota1', 'nota2', 'nota3']].mean(axis=1)
    return df

def identificar_aprovados(df):
    df['status'] = df['media'].apply(lambda x: 'Aprovado' if x >= 7 else 'Reprovado')
    return df

def gerar_relatorio(df):
    relatorio = df[['aluno', 'media', 'status']]
    return relatorio


if __name__ == "__main__":
    df = carregar_dados('alunos.csv')
    
    df_com_media = calcular_media(df)
    
    df_com_status = identificar_aprovados(df_com_media)
    
    relatorio = gerar_relatorio(df_com_status)
    
    print(relatorio)
