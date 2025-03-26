import pytest
import pandas as pd
from main import carregar_dados, calcular_valor_total, filtrar_vendas

def test_carregar_dados():
    df = carregar_dados('vendas.csv')
    assert isinstance(df, pd.DataFrame), "A função deve retornar um DataFrame"
    assert 'produto' in df.columns, "A coluna 'produto' deve existir"
    assert 'quantidade' in df.columns, "A coluna 'quantidade' deve existir"
    assert 'preco_unitario' in df.columns, "A coluna 'preco_unitario' deve existir"

def test_calcular_valor_total():
    df = pd.DataFrame({
        'produto': ['Produto A', 'Produto B'],
        'quantidade': [10, 5],
        'preco_unitario': [50.0, 150.0]
    })
    df = calcular_valor_total(df)
    assert 'valor_total' in df.columns, "A coluna 'valor_total' deve ser criada"
    assert df.loc[0, 'valor_total'] == 500.0, "O valor total do Produto A está incorreto"
    assert df.loc[1, 'valor_total'] == 750.0, "O valor total do Produto B está incorreto"

def test_filtrar_vendas():
    df = pd.DataFrame({
        'produto': ['Produto A', 'Produto B', 'Produto C', 'Produto D'],
        'quantidade': [10, 5, 8, 12],
        'preco_unitario': [50.0, 150.0, 80.0, 30.0]
    })
    df = calcular_valor_total(df)
    df_filtrado = filtrar_vendas(df)
    
    df_filtrado = df_filtrado.reset_index(drop=True)

    assert len(df_filtrado) == 2, "Deve retornar 2 registros com valor_total maior que 500"
    assert df_filtrado.loc[0, 'produto'] == 'Produto B', "Produto B deve ser incluído"
    assert df_filtrado.loc[1, 'produto'] == 'Produto C', "Produto C deve ser incluído"
