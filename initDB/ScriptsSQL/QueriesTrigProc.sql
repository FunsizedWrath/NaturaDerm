--DEGUFFROY, JORE, LACABANNE, CARUELLE
-- Procédures Stockées

-- 1. Gestion de stock : Mise à jour automatique des stocks après une vente ou un réapprovisionnement
CREATE PROCEDURE UpdateStock
    @ProductID INT,
    @QuantityChange INT,
    @IsRestock BIT -- 1 pour un réapprovisionnement, 0 pour une vente
AS
BEGIN
    SET NOCOUNT ON;

    -- Vérifie si le produit existe
    IF EXISTS (SELECT 1 FROM dbo.produit WHERE referenceProduit = @ProductID)
    BEGIN
        -- Mise à jour de la quantité en stock
        IF @IsRestock = 1
        BEGIN
            UPDATE dbo.produit
            SET quantiteStockProduit = quantiteStockProduit + @QuantityChange
            WHERE referenceProduit = @ProductID;
        END
        ELSE
        BEGIN
            UPDATE dbo.produit
            SET quantiteStockProduit = quantiteStockProduit - @QuantityChange
            WHERE referenceProduit = @ProductID;

            -- Vérification du seuil critique
            IF (SELECT quantiteStockProduit FROM dbo.produit WHERE referenceProduit = @ProductID) < 10
            BEGIN
                PRINT 'Attention : Le stock est en dessous du seuil critique!';
            END
        END
    END
    ELSE
    BEGIN
        PRINT 'Erreur : Produit introuvable';
    END
END;
GO

-- 2. Rapports : Génération de rapports de vente par conseiller, client, ou produit
CREATE PROCEDURE SalesReport
    @StartDate DATE,
    @EndDate DATE,
    @GroupBy NVARCHAR(50) -- Peut être 'conseiller', 'client', ou 'produit'
AS
BEGIN
    SET NOCOUNT ON;

    IF @GroupBy = 'conseiller'
    BEGIN
        SELECT c.idConseiller, c.nomConseiller, c.prenomConseiller, SUM(v.montant) AS TotalVentes
        FROM dbo.vente v
        JOIN dbo.conseiller c ON v.idConseiller = c.idConseiller
        WHERE v.dateVente BETWEEN @StartDate AND @EndDate
        GROUP BY c.idConseiller, c.nomConseiller, c.prenomConseiller;
    END
    ELSE IF @GroupBy = 'client'
    BEGIN
        SELECT cl.idClient, cl.nomClient, cl.prenomClient, SUM(v.montant) AS TotalVentes
        FROM dbo.vente v
        JOIN dbo.client cl ON v.idClient = cl.idClient
        WHERE v.dateVente BETWEEN @StartDate AND @EndDate
        GROUP BY cl.idClient, cl.nomClient, cl.prenomClient;
    END
    ELSE IF @GroupBy = 'produit'
    BEGIN
        SELECT p.referenceProduit, p.nomProduit, SUM(v.quantite) AS TotalQuantiteVendue, SUM(v.montant) AS TotalVentes
        FROM dbo.vente v
        JOIN dbo.produit p ON v.referenceProduit = p.referenceProduit
        WHERE v.dateVente BETWEEN @StartDate AND @EndDate
        GROUP BY p.referenceProduit, p.nomProduit;
    END
    ELSE
    BEGIN
        PRINT 'Erreur : Valeur de GroupBy non valide';
    END
END;
GO

-- Triggers

-- 1. Sur dbo.produit : Notification pour seuil critique
CREATE TRIGGER trg_ProductStockUpdate
ON dbo.produit
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Vérifie si la mise à jour concerne la quantité en stock
    IF EXISTS (SELECT 1 FROM Inserted i JOIN Deleted d ON i.referenceProduit = d.referenceProduit
               WHERE i.quantiteStockProduit <> d.quantiteStockProduit)
    BEGIN
        DECLARE @ProductID INT, @Stock INT;

        SELECT @ProductID = referenceProduit, @Stock = quantiteStockProduit FROM Inserted;

        -- Avertissement si le stock est en dessous du seuil critique
        IF @Stock < 10
        BEGIN
            PRINT 'Attention : Stock critique pour le produit ' + CAST(@ProductID AS VARCHAR);
        END
    END
END;
GO

-- 2. Sur dbo.conseiller : Mise à jour automatique du statut estMarraine
CREATE TRIGGER trg_ConseillerUpdate
ON dbo.conseiller
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Vérifie si le pourcentage de parrainage a changé
    IF EXISTS (SELECT 1 FROM Inserted i JOIN Deleted d ON i.idConseiller = d.idConseiller
               WHERE i.pourcentageMarraine <> d.pourcentageMarraine)
    BEGIN
        UPDATE dbo.conseiller
        SET estMarraine = CASE WHEN pourcentageMarraine > 0 THEN 1 ELSE 0 END
        WHERE idConseiller IN (SELECT idConseiller FROM Inserted);
    END
END;
GO

SELECT nomProduit, quantitestockproduit
from produit P
LEFT JOIN fournisseur F
on P.idFournisseur = F.idFournisseur
WHERE P.idFournisseur = 1
ORDER by quantiteStockProduit DESC;

SELECT *
FROM conseiller
WHERE pourcentageGainVente > 10
AND estMarraine IS NOT NULL;


SELECT conseiller.nomConseiller, SUM(commande.PrixTotalCommande) AS TotalCommandes
FROM commande
JOIN conseiller
ON commande.idConseiller = conseiller.idConseiller
GROUP BY conseiller.nomConseiller
ORDER by TotalCommandes DESC;


SELECT DISTINCT pr.nomProduit, pr.referenceProduit
FROM dbo.produit pr
LEFT JOIN dbo.compose c
ON pr.referenceProduit = c.referenceProduit
AND c.idComposant = 9
WHERE c.referenceProduit IS NULL;

EXEC UpdateStock @ProductID = 10, @QuantityChange = 50, @IsRestock = 1;
-- Augmente la quantité en stock du produit avec l'ID 10 de 50 unités.

EXEC UpdateStock @ProductID = 5, @QuantityChange = 10, @IsRestock = 0;
-- Diminue la quantité en stock du produit avec l'ID 5 de 10 unités.
-- Si la quantité restante est inférieure à 10, un message d'avertissement est affiché.


EXEC SalesReport @StartDate = '2024-01-01', @EndDate = '2024-12-31', @GroupBy = 'conseiller';
-- Affiche les ventes totales pour chaque conseiller sur l'année 2024.
EXEC SalesReport @StartDate = '2024-06-01', @EndDate = '2024-06-30', @GroupBy = 'client';
-- Affiche les ventes totales par client pour le mois de juin 2024.
EXEC SalesReport @StartDate = '2024-01-01', @EndDate = '2024-12-31', @GroupBy = 'produit';
-- Montre la quantité vendue et le total des ventes pour chaque produit sur l'année 2024.


UPDATE dbo.produit
SET quantiteStockProduit = 5
WHERE referenceProduit = 10;
-- Si la quantité tombe à 5, un message est affiché : "Attention : Stock critique pour le produit 10".
UPDATE dbo.produit
SET quantiteStockProduit = 50
WHERE referenceProduit = 5;
-- Aucun avertissement car le stock est au-dessus du seuil critique.


UPDATE dbo.conseiller
SET pourcentageMarraine = 15
WHERE idConseiller = 1;
-- Le trigger met automatiquement à jour `estMarraine` à 1 pour ce conseiller.
UPDATE dbo.conseiller
SET pourcentageMarraine = 0
WHERE idConseiller = 7;
-- Le trigger met automatiquement à jour `estMarraine` à 0 pour ce conseiller.
GO

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
GO

-- Permissions pour les Conseillers
GRANT SELECT ON vw_ConseillerClients TO Conseiller;
GRANT INSERT ON dbo.commande TO Conseiller;
GRANT INSERT ON dbo.formationConseiller TO Conseiller;
GO

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
GO

-- Permissions pour les Marraines
CREATE ROLE Marraine
GRANT SELECT ON vw_MarraineConseillers TO Marraine;
GRANT INSERT ON dbo.commande TO Marraine;
GRANT INSERT ON dbo.formationConseiller TO Marraine;
GO

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

GO



-- Permissions pour le Directeur
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.client TO Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.conseiller TO Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.reunionClient TO Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.produit TO Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.commande TO Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.formationConseiller TO Manager;
GO

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

GO


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
