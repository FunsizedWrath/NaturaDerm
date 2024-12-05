SELECT C.nomclient, co.idCommande, co.PrixTotalCommande
FROM client c, commande co
INNER JOIN commande co ON co.idclient = c.idclient

-------

SELECT *
FROM MAGASIN M
LEFT JOIN VEHICULE V ON M.ID_MAGASIN = V.ID_MAGASIN

----------

SELECT *
FROM VEHICULE V
FULL JOIN PROPRIETAIRE_VEHICULE PV ON V.ID_VEHICULE = PV.ID_VEHICULE
FULL JOIN PROPRIETAIRE P ON PV.ID_PROPRIETAIRE = P.ID_PROPRIETAIRE

----------

SELECT P.ID_PROPRIETAIRE, P.NOM, P.PRENOM, P.ANNEE_NAISSANCE
FROM PROPRIETAIRE P
LEFT JOIN PROPRIETAIRE_VEHICULE PV ON P.ID_PROPRIETAIRE = PV.ID_PROPRIETAIRE
LEFT JOIN VEHICULE V ON PV.ID_VEHICULE = V.ID_VEHICULE
WHERE V.ID_VEHICULE IS NULL

----------

group BY
having
not in
sous requete
min/max