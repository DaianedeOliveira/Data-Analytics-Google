SELECT * FROM `basedosdados.br_sp_gov_ssp.ocorrencias_registradas` LIMIT 100

-- Ano que mais teve homicídio doloso por região em SP, a partir do ano de 2010
SELECT ano,  regiao_ssp, homicidio_doloso
FROM `basedosdados.br_sp_gov_ssp.ocorrencias_registradas`
WHERE ano >= 2010 AND homicidio_doloso <> 0

--Qual o total por ano de casos de tentativas de homicídio
SELECT ano, SUM(tentativa_de_homicidio) AS Acumulado
FROM `basedosdados.br_sp_gov_ssp.ocorrencias_registradas`
GROUP BY ano
ORDER BY ano

--Qual ano teve mais caso de tentativa de homicídio
SELECT ano, SUM(tentativa_de_homicidio) AS Acumulado
FROM `basedosdados.br_sp_gov_ssp.ocorrencias_registradas`
GROUP BY ano
ORDER BY ano
LIMIT 1


--Qual a diferença de homicidio doloso e culposo por transito do total geral?

WITH homicidioDoloso AS (
  SELECT id_municipio, numero_de_vitimas_em_homicidio_doloso_por_acidente_de_transito,
  ROUND(numero_de_vitimas_em_homicidio_doloso_por_acidente_de_transito	/ SUM(numero_de_vitimas_em_homicidio_doloso_por_acidente_de_transito),2) AS porcentagemHD
  FROM `basedosdados.br_sp_gov_ssp.ocorrencias_registradas`
  WHERE numero_de_vitimas_em_homicidio_doloso_por_acidente_de_transito <> 0
    GROUP BY numero_de_vitimas_em_homicidio_doloso_por_acidente_de_transito, id_municipio
),

homicidioCulposo AS(
  SELECT id_municipio, homicidio_culposo_por_acidente_de_transito, ROUND(homicidio_culposo_por_acidente_de_transito/ SUM(homicidio_culposo_por_acidente_de_transito),2)AS porcentagemHC 
  FROM `basedosdados.br_sp_gov_ssp.ocorrencias_registradas`
  WHERE homicidio_culposo_por_acidente_de_transito <> 0
  GROUP BY homicidio_culposo_por_acidente_de_transito, id_municipio

)

SELECT hd.porcentagemHD, hc.porcentagemHC, ROUND(hd.porcentagemHD - hc.porcentagemHC,2) AS diferenca
FROM homicidioDoloso hd
INNER JOIN homicidioCulposo hc ON hd.id_municipio	= hc.id_municipio

-- Qual a região com mais vítimas de latrocínios?

SELECT  regiao_ssp,ano,numero_de_vitimas_em_latrocinio, SUM(numero_de_vitimas_em_latrocinio)  AS vitimas_latrocinio
FROM `basedosdados.br_sp_gov_ssp.ocorrencias_registradas`
GROUP BY regiao_ssp, ano, numero_de_vitimas_em_latrocinio
ORDER BY numero_de_vitimas_em_latrocinio DESC
LIMIT 10

-- Qual o total e a média de latrocinio a partir do ano de 2019?
SELECT ano, mes, SUM(latrocinio) AS latrocinio, ROUND(AVG(latrocinio) * 100,2) AS mediaLatrocinio 
FROM `basedosdados.br_sp_gov_ssp.ocorrencias_registradas`
WHERE ano >= 2019 AND latrocinio IS NOT NULL
GROUP BY mes, ano
ORDER BY ano, mes ASC
