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
    IF EXISTS (SELECT 1 FROM produit WHERE referenceProduit = @ProductID)
    BEGIN
        -- Mise à jour de la quantité en stock
        IF @IsRestock = 1
        BEGIN
            UPDATE produit
            SET quantiteStockProduit = quantiteStockProduit + @QuantityChange
            WHERE referenceProduit = @ProductID;
        END
        ELSE
        BEGIN
            UPDATE produit
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
        FROM commande c
        JOIN conseiller c ON v.idConseiller = c.idConseiller
        WHERE c.dateCommande BETWEEN @StartDate AND @EndDate
        GROUP BY c.idConseiller, c.nomConseiller, c.prenomConseiller;
    END
    ELSE IF @GroupBy = 'client'
    BEGIN
        SELECT cl.idClient, cl.nomClient, cl.prenomClient, SUM(v.montant) AS TotalVentes
        FROM commande c
        JOIN client cl ON v.idClient = cl.idClient
        WHERE c.dateCommande BETWEEN @StartDate AND @EndDate
        GROUP BY cl.idClient, cl.nomClient, cl.prenomClient;
    END
    ELSE IF @GroupBy = 'produit'
    BEGIN
        SELECT p.referenceProduit, p.nomProduit, SUM(v.quantite) AS TotalQuantiteVendue, SUM(v.montant) AS TotalVentes
        FROM commande c
        JOIN produit p ON v.referenceProduit = p.referenceProduit
        WHERE c.datecommande BETWEEN @StartDate AND @EndDate
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
