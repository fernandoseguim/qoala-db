-- EXIBE A QUANTIDADE DE DISPOSITIVOS POR CLIENTE CADASTRADO QUANDO A QUANTIDADE FOR MAIOR QUE ZERO 
SELECT NAME "CLIENTE", COUNT(ALIAS) "QTADE DE DEVICES" FROM VW_USER_DEVICES
GROUP BY NAME
HAVING COUNT(ALIAS) > 0

-- EXIBE DADOS CADASTRAIS DE USU�RIO QUE SE CADASTRARAM PARA ACOMPANHAR O PROJETO, MAS AINDA N�O COMPRARAM O DISPOSITIVO DE LOCALIZA��O DE PETS
-- ESTE RELAT�RIO SERVE PARA QUE O TIME DE MARKETING POSSA CRIAR A��ES PARA CONVERCER ESSES PROSPCTES A COMPREREM O PRODUTO
SELECT "CLIENTE", EMAIL "E-MAIL DO CLIENTE", ADDRESS "ENDERE�O", DISTRICT "BAIRRO", CITY "CIDADE", STATE "ESTADO", ZIPCODE "CEP"
FROM (SELECT NAME "CLIENTE", EMAIL, ADDRESS, DISTRICT, CITY, STATE, ZIPCODE, COUNT(ALIAS) "QTADE_DEVICES" FROM VW_USER_DEVICES
GROUP BY NAME, EMAIL,ADDRESS, DISTRICT, CITY, STATE, ZIPCODE) 
WHERE "QTADE_DEVICES" = 0

       
-- EXIBE AS NOT�CIAS PUBLICAS POR AUTORES COM PERFIL P�BLICO EM FASE DE DESENVOLVIMENTO 
-- E QUE DEVEM SER EXCLU�DOS DO BANCO DE DADOS ANTES DO SISTEMA ENTRAR EM PRODU��O
SELECT ID_POST, TITULO, AUTOR FROM VW_POSTS_USER
WHERE PERFIL = 'P�blico'


-- EXIBE SOMENTE OS COMENT�RIOS PENDENTES DE APROVA��O
SELECT ID_COMENTARIO, DATA_COMENTARIO, AUTOR_COMENTARIO, TITULO_NOTICIA, AUTOR_NOTICIA 
FROM VW_POST_COMMENTS
WHERE DATA_COMENTARIO IS NOT NULL AND DATA_APROVACAO IS NULL

-- EXIBE A QUANTIDADE DE COMENT�RIOS NA NOT�CIA
-- POSSIBILITA AO MARKETING MENSURAR O IMPACTO GERADO PELA PUBLICA��O (QUANTO MAIS COMENT�RIOS, MAIOR O IMPACTO GERADO)
SELECT TITULO_NOTICIA, AUTOR_NOTICIA, COUNT(ID_COMENTARIO) "QTDE_COMENTARIOS"
FROM VW_POST_COMMENTS
GROUP BY TITULO_NOTICIA, AUTOR_NOTICIA


