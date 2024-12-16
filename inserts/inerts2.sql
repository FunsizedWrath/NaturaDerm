INSERT INTO commande (
    idCommande, remiseCommande, dateCommande, dateLivraisonCommande, PrixTotalCommande, idManager, idConseiller, idClient
) VALUES
    --commandes clients
    (6, 12.50, '2024-10-01', '2024-10-10', 116.00, NULL, 5, 1),
    (7, 4.00, '2024-09-20', '2024-09-25', 197.00, NULL, 4, 2),
    (8, NULL, '2024-06-15', '2024-06-20', 98.00, NULL, 6, 3),

    --commandes fournisseurs
    (9, 15.75, '2024-12-03', '2024-12-08', 350.50, 01, NULL, NULL),
    (10, 0.00, '2024-12-04', NULL, 410.00, 01, NULL, NULL),
    (11, 10.50, '2024-12-01', '2024-12-10', 333.00, 01, NULL, NULL);

INSERT INTO estCommande (
    referenceProduit, idCommande, quantiteProduit
) VALUES
    --commandes clients
    (10, 6, 2),
    (15, 6, 1),
    (2, 6, 3),
    (7, 7, 1),
    (30, 7, 1),
    (24, 7, 2),
    (29, 7, 4),
    (21, 7, 2),
    (11, 8, 3),
    (22, 8, 2),
    (6, 8, 7),
    (3, 8, 3)

    --commandes fournisseurs
