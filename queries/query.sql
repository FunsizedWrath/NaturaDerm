INSERT INTO vente.commande (idCommande, remiseCommande, dateCommande, dateLivraisonCommande, PrixTotalCommande, idManager, idConseiller, idClient)
VALUES
(1, 10.50, '2024-12-01', '2024-12-10', 150.00, null, 5, 1),
(2, 5.00, '2024-11-20', '2024-11-25', 200.00, null, 4, 2),
(3, NULL, '2024-10-15', '2024-10-20', 120.00, NULL, 6, 3),
(4, 15.75, '2024-12-03', '2024-12-08', 180.50, 1, 5, 4),
(5, 0.00, '2024-12-04', NULL, 100.00, 1, NULL, 5);


INSERT into vente.reunionClient (idclient, idconseiller, idreunion, datereunion)
values
(1,2,1,'2024-10-12'),
(5,2,2,'2024-10-12'),
(2,4,3,'2024-10-12');

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
FROM dbo.commande
JOIN dbo.conseiller
ON commande.idConseiller = conseiller.idConseiller
GROUP BY conseiller.nomConseiller
ORDER by TotalCommandes DESC;


SELECT DISTINCT pr.nomProduit, pr.referenceProduit
FROM dbo.produit pr
LEFT JOIN dbo.compose c
ON pr.referenceProduit = c.referenceProduit
AND c.idComposant = 9
WHERE c.referenceProduit IS NULL;
