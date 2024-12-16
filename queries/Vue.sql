-- 1. Vue pour les Conseillers
CREATE OR ALTER VIEW vw_ConseillerClients AS
SELECT DISTINCT 
    c.idClient, 
    c.nomClient, 
    c.prenomClient, 
    c.dateNaissanceClient, 
    c.sexeClient, 
    c.telClient, 
    c.mailClient
FROM dbo.client c
JOIN dbo.reunionClient rc ON c.idClient = rc.idClient
JOIN dbo.conseiller con ON rc.idConseiller = con.idConseiller
WHERE LOWER(con.prenomConseiller + con.nomConseiller) = LOWER(SESSION_USER); -- Comparaison case-insensitive

-- Permissions pour les Conseillers
GRANT SELECT ON vw_ConseillerClients TO Conseiller;
GRANT INSERT ON dbo.commande TO Conseiller;
GRANT INSERT ON dbo.formationConseiller TO Conseiller;

-- 2. Vue pour les Marraines
CREATE OR ALTER VIEW vw_MarraineConseillers AS
SELECT DISTINCT 
    con.idConseiller, 
    con.nomConseiller, 
    con.prenomConseiller, 
    con.dateNaissanceConseiller, 
    con.telConseiller, 
    con.mailConseiller
FROM dbo.conseiller con
WHERE con.estMarraine = 1
  AND con.idConseiller IN (
      SELECT idConseiller 
      FROM dbo.conseiller 
      WHERE LOWER(prenomConseiller + nomConseiller) = LOWER(SESSION_USER) -- Comparaison case-insensitive
  );

-- Permissions pour les Marraines
CREATE ROLE Marraine
GRANT SELECT ON vw_MarraineConseillers TO Marraine;
GRANT INSERT ON dbo.commande TO Marraine;
GRANT INSERT ON dbo.formationConseiller TO Marraine;

-- 3. Vue pour le Directeur
CREATE OR ALTER VIEW vw_DirectorAccess AS
SELECT 
    'client' AS TableName, 
    CAST(idClient AS NVARCHAR(50)) AS EntityID, 
    nomClient AS Column1, 
    prenomClient AS Column2, 
    mailClient AS Column3, 
    telClient AS Column4
FROM dbo.client
UNION ALL
SELECT 
    'conseiller' AS TableName, 
    CAST(idConseiller AS NVARCHAR(50)) AS EntityID, 
    nomConseiller AS Column1, 
    prenomConseiller AS Column2, 
    mailConseiller AS Column3, 
    telConseiller AS Column4
FROM dbo.conseiller
UNION ALL
SELECT 
    'produit' AS TableName, 
    referenceProduit AS EntityID, 
    nomProduit AS Column1, 
    descriptionProduit AS Column2, 
    CAST(prixHorsTaxeProduit AS NVARCHAR(50)) AS Column3, 
    NULL AS Column4
FROM dbo.produit
UNION ALL
SELECT 
    'reunionClient' AS TableName, 
    CAST(idReunion AS NVARCHAR(50)) AS EntityID, 
    CAST(dateReunion AS NVARCHAR(50)) AS Column1, 
    NULL AS Column2, 
    NULL AS Column3, 
    NULL AS Column4
FROM dbo.reunionClient
UNION ALL
SELECT 
    'commande' AS TableName, 
    CAST(idCommande AS NVARCHAR(50)) AS EntityID, 
    CAST(dateCommande AS NVARCHAR(50)) AS Column1, 
    CAST(PrixTotalCommande AS NVARCHAR(50)) AS Column2, 
    NULL AS Column3, 
    NULL AS Column4
FROM dbo.commande
UNION ALL
SELECT 
    'formationConseiller' AS TableName, 
    CAST(idFormation AS NVARCHAR(50)) AS EntityID, 
    CAST(dateFormation AS NVARCHAR(50)) AS Column1, 
    NULL AS Column2, 
    NULL AS Column3, 
    NULL AS Column4
FROM dbo.formationConseiller;



-- Permissions pour le Directeur
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.client TO Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.conseiller TO Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.reunionClient TO Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.produit TO Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.commande TO Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.formationConseiller TO Manager;

-- 4. Vue pour l’Admin
CREATE OR ALTER VIEW vw_AdminAccess AS
SELECT 
    'client' AS TableName, 
    CAST(idClient AS NVARCHAR(50)) AS EntityID, 
    nomClient AS Column1, 
    prenomClient AS Column2, 
    mailClient AS Column3, 
    telClient AS Column4
FROM dbo.client

UNION ALL

SELECT 
    'conseiller' AS TableName, 
    CAST(idConseiller AS NVARCHAR(50)) AS EntityID, 
    nomConseiller AS Column1, 
    prenomConseiller AS Column2, 
    mailConseiller AS Column3, 
    telConseiller AS Column4
FROM dbo.conseiller

UNION ALL

SELECT 
    'reunionClient' AS TableName, 
    CAST(idReunion AS NVARCHAR(50)) AS EntityID, 
    CAST(dateReunion AS NVARCHAR(50)) AS Column1, 
    NULL AS Column2, 
    NULL AS Column3, 
    NULL AS Column4
FROM dbo.reunionClient

UNION ALL

SELECT 
    'produit' AS TableName, 
    referenceProduit AS EntityID, 
    nomProduit AS Column1, 
    descriptionProduit AS Column2, 
    CAST(prixHorsTaxeProduit AS NVARCHAR(50)) AS Column3, 
    NULL AS Column4
FROM dbo.produit

UNION ALL

SELECT 
    'commande' AS TableName, 
    CAST(idCommande AS NVARCHAR(50)) AS EntityID, 
    CAST(dateCommande AS NVARCHAR(50)) AS Column1, 
    CAST(PrixTotalCommande AS NVARCHAR(50)) AS Column2, 
    NULL AS Column3, 
    NULL AS Column4
FROM dbo.commande

UNION ALL

SELECT 
    'formationConseiller' AS TableName, 
    CAST(idFormation AS NVARCHAR(50)) AS EntityID, 
    CAST(dateFormation AS NVARCHAR(50)) AS Column1, 
    NULL AS Column2, 
    NULL AS Column3, 
    NULL AS Column4
FROM dbo.formationConseiller;


-- Permissions pour l’Admin
CREATE ROLE AdminSystem
GRANT CONTROL ON SCHEMA::dbo TO AdminSystem;
GRANT ALTER ANY USER TO AdminSystem;
GRANT ALTER ANY ROLE TO AdminSystem;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.client TO AdminSystem;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.conseiller TO AdminSystem;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.reunionClient TO AdminSystem;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.produit TO AdminSystem;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.commande TO AdminSystem;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.formationConseiller TO AdminSystem;

