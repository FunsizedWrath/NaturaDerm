-- Vue pour les conseillers
CREATE VIEW vw_ConseillerClients AS
SELECT c.idClient, c.nomClient, c.prenomClient, c.dateNaissanceClient, c.sexeClient, c.telClient, c.mailClient
FROM dbo.client c
JOIN dbo.conseiller con ON c.idConseiller = con.idConseiller
WHERE con.idConseiller = SESSION_USER; -- Utilisation de SESSION_USER pour restreindre dynamiquement
GO

-- Permissions pour insérer des données dans commande et formationConseiller
GRANT INSERT ON dbo.commande TO CONSEILLER_ROLE;
GRANT INSERT ON dbo.formationConseiller TO CONSEILLER_ROLE;


-- Vue pour les marraines
CREATE VIEW vw_MarraineConseillers AS
SELECT con.idConseiller, con.nomConseiller, con.prenomConseiller, con.dateNaissanceConseiller, con.telConseiller, con.mailConseiller
FROM dbo.conseiller con
WHERE con.idMarraine = SESSION_USER; -- Restreindre dynamiquement aux conseillers sous la marraine
GO

-- Permissions pour insérer des données dans commande et formationConseiller
GRANT INSERT ON dbo.commande TO MARRAINE_ROLE;
GRANT INSERT ON dbo.formationConseiller TO MARRAINE_ROLE;


-- Vue pour le directeur
CREATE VIEW vw_DirectorAccess AS
SELECT * FROM dbo.client
UNION ALL
SELECT * FROM dbo.conseiller
UNION ALL
SELECT * FROM dbo.fournisseur
UNION ALL
SELECT * FROM dbo.produit
UNION ALL
SELECT * FROM dbo.commande
UNION ALL
SELECT * FROM dbo.formationConseiller;
GO

-- Permissions pour insérer et supprimer dans toutes les tables
GRANT INSERT, DELETE ON dbo.client TO DIRECTOR_ROLE;
GRANT INSERT, DELETE ON dbo.conseiller TO DIRECTOR_ROLE;
GRANT INSERT, DELETE ON dbo.fournisseur TO DIRECTOR_ROLE;
GRANT INSERT, DELETE ON dbo.produit TO DIRECTOR_ROLE;
GRANT INSERT, DELETE ON dbo.commande TO DIRECTOR_ROLE;
GRANT INSERT, DELETE ON dbo.formationConseiller TO DIRECTOR_ROLE;


-- Vue pour l'admin
CREATE VIEW vw_AdminAccess AS
SELECT * FROM dbo.client
UNION ALL
SELECT * FROM dbo.conseiller
UNION ALL
SELECT * FROM dbo.fournisseur
UNION ALL
SELECT * FROM dbo.produit
UNION ALL
SELECT * FROM dbo.commande
UNION ALL
SELECT * FROM dbo.formationConseiller;
GO

-- Permissions complètes pour l'admin
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.client TO ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.conseiller TO ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.fournisseur TO ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.produit TO ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.commande TO ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.formationConseiller TO ADMIN_ROLE;
