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
