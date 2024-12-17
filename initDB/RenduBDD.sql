DROP TABLE IF EXISTS compose;
DROP TABLE IF EXISTS estCommande;
DROP TABLE IF EXISTS formationConseiller;
DROP TABLE IF EXISTS reunionClient;
DROP TABLE IF EXISTS composant;
DROP TABLE IF EXISTS commande;
DROP TABLE IF EXISTS manager;
DROP TABLE IF EXISTS produit;
DROP TABLE IF EXISTS fournisseur;
DROP TABLE IF EXISTS conseiller;
DROP TABLE IF EXISTS client;

CREATE TABLE client(
   idClient INT,
   nomClient VARCHAR(50) NOT NULL,
   prenomClient VARCHAR(50) NOT NULL,
   dateNaissanceClient DATE,
   sexeClient INT,
   telClient BIGINT NOT NULL,
   mailClient VARCHAR(50) NOT NULL,
   adresse1Client VARCHAR(50) NOT NULL,
   adresse2Client VARCHAR(50) NOT NULL,
   codePostalClient INT NOT NULL,
   villeClient VARCHAR(50) NOT NULL,
   PRIMARY KEY(idClient),
   CHECK (sexeClient = 0 OR sexeClient = 1 OR sexeClient = 2),
   CHECK (LEN(CAST(telClient AS VARCHAR(10))) = 10),
   CHECK (LEN(mailClient) >= 5), -- 4 car il faut au moins trois charactere un @ et un point ex: a@b.c
   CHECK (LEN(adresse1Client) > 0),
   CHECK (LEN(adresse2Client) > 0),
);

CREATE TABLE conseiller(
   idConseiller INT,
   nomConseiller VARCHAR(50) NOT NULL,
   prenomConseiller VARCHAR(50) NOT NULL,
   dateNaissanceConseiller DATE,
   telConseiller VARCHAR(10),
   mailConseiller VARCHAR(50),
   numSecuConseiller VARCHAR(50) NOT NULL,
   pourcentageGainVente DECIMAL(15,2) NOT NULL,
   pourcentageMarraine DECIMAL(15,2) NOT NULL,
   estMarraine TINYINT NOT NULL,
   PRIMARY KEY(idConseiller),
   CHECK (LEN(telConseiller) = 10),
   CHECK (pourcentageGainVente >= 0 AND pourcentageGainVente <= 100),
   CHECK (pourcentageMarraine >= 0 AND pourcentageMarraine <= 100)
);

CREATE TABLE fournisseur(
   idFournisseur INT,
   nomFournisseur VARCHAR(50) NOT NULL,
   paysFournisseur VARCHAR(50) NOT NULL,
   adresse1Fournisseur VARCHAR(50),
   adresse2Fournisseur VARCHAR(50),
   CPFournisseur INT,
   villeFournisseur VARCHAR(50),
   telFournisseur BIGINT,
   mailFournisseur VARCHAR(50),
   numSIRETFournisseur BIGINT,
   PRIMARY KEY(idFournisseur),
   CHECK (LEN(CAST(telFournisseur AS VARCHAR(10))) = 10)
);

CREATE TABLE produit(
   referenceProduit VARCHAR(50),
   nomProduit VARCHAR(50) NOT NULL,
   prixHorsTaxeProduit Money NOT NULL,
   descriptionProduit VARCHAR(50),
   imgProduit VARCHAR(50),
   pictogrammeProduit VARCHAR(50),
   discontinuerProduit BIT DEFAULT 0,
   quantiteStockProduit INT,
   idFournisseur INT NOT NULL,
   PRIMARY KEY(referenceProduit),
   FOREIGN KEY(idFournisseur) REFERENCES fournisseur(idFournisseur),
   CHECK (prixHorsTaxeProduit > 0),
   CHECK (quantiteStockProduit >= 0)
);

CREATE TABLE manager(
   idManager INT,
   nomManager VARCHAR(50) NOT NULL,
   prenomManager VARCHAR(50) NOT NULL,
   estDirecteur BIT DEFAULT 0,
   PRIMARY KEY(idManager)
);

CREATE TABLE commande(
   idCommande INT,
   remiseCommande Money,
   dateCommande DATE,
   dateLivraisonCommande DATE,
   PrixTotalCommande Money,
   idManager INT,
   idConseiller INT,
   idClient INT,
   PRIMARY KEY(idCommande),
   FOREIGN KEY(idManager) REFERENCES manager(idManager),
   FOREIGN KEY(idConseiller) REFERENCES conseiller(idConseiller),
   FOREIGN KEY(idClient) REFERENCES client(idClient),
   CHECK (remiseCommande >= 0),
   CHECK (PrixTotalCommande > 0)
);

CREATE TABLE composant(
   idComposant INT,
   nomComposant VARCHAR(50) NOT NULL,
   estAllergene BIT NOT NULL DEFAULT 0,
   PRIMARY KEY(idComposant),
   UNIQUE(nomComposant)
);

CREATE TABLE reunionClient(
   idClient INT,
   idConseiller INT,
   idReunion INT NOT NULL,
   dateReunion DATE,
   PRIMARY KEY(idClient, idConseiller),
   UNIQUE(idReunion),
   FOREIGN KEY(idClient) REFERENCES client(idClient),
   FOREIGN KEY(idConseiller) REFERENCES conseiller(idConseiller)
);

CREATE TABLE formationConseiller(
   idConseiller INT,
   idConseiller_1 INT,
   idFormation INT NOT NULL,
   dateFormation DATE,
   PRIMARY KEY(idConseiller, idConseiller_1),
   UNIQUE(idFormation),
   FOREIGN KEY(idConseiller) REFERENCES conseiller(idConseiller),
   FOREIGN KEY(idConseiller_1) REFERENCES conseiller(idConseiller)
);

CREATE TABLE estCommande(
   referenceProduit VARCHAR(50),
   idCommande INT,
   quantiteProduit INT NOT NULL,
   PRIMARY KEY(referenceProduit, idCommande),
   FOREIGN KEY(referenceProduit) REFERENCES produit(referenceProduit),
   FOREIGN KEY(idCommande) REFERENCES commande(idCommande),
   CHECK (quantiteProduit > 0)
);

CREATE TABLE compose(
   referenceProduit VARCHAR(50),
   idComposant INT,
   PRIMARY KEY(referenceProduit, idComposant),
   FOREIGN KEY(referenceProduit) REFERENCES produit(referenceProduit),
   FOREIGN KEY(idComposant) REFERENCES composant(idComposant)
);

CREATE LOGIN Conseiller
WITH PASSWORD = 'p@ssword123',
DEFAULT_DATABASE=NatureDerm,
DEFAULT_LANGUAGE=French
GO

CREATE LOGIN Manager
WITH PASSWORD = 'ManagerP@ssword123',
DEFAULT_DATABASE=NatureDerm,
DEFAULT_LANGUAGE=French
GO

CREATE LOGIN Administrateur
WITH PASSWORD = 'AdminP@ssword123',
DEFAULT_DATABASE=NatureDerm,
DEFAULT_LANGUAGE=French
GO

CREATE user ThorOdinson FOR LOGIN Conseiller;
CREATE user LokiLaufeyson FOR LOGIN Conseiller;
CREATE user FreyrFreyson FOR LOGIN Conseiller;
CREATE user NjordNjordson FOR LOGIN Conseiller;
CREATE user FriggOdinsdottir FOR LOGIN Conseiller;
CREATE user OdinHreidmarson FOR LOGIN Conseiller;
CREATE user AngrbodaJotundottir FOR LOGIN Conseiller;
CREATE user FreyjaFreyjadottir FOR LOGIN Conseiller;
CREATE user VidarYggdrasilson FOR LOGIN Conseiller;
CREATE user HelOdinsdottir FOR LOGIN Conseiller;
CREATE user TyrTyrson FOR LOGIN Conseiller;
CREATE user BaldrBaldrson FOR LOGIN Conseiller;
CREATE user ThorolfHymirson FOR LOGIN Conseiller;
CREATE user FenrirFenrirson FOR LOGIN Conseiller;
CREATE user SkadiJotundottir FOR LOGIN Conseiller;
CREATE user BragiBragason FOR LOGIN Conseiller;
CREATE user ViliThorvaldson FOR LOGIN Conseiller;
CREATE user EirVeidottir FOR LOGIN Conseiller;
CREATE user HeimdallHeimdallson FOR LOGIN Conseiller;
CREATE user GullveigGullveigsdottir FOR LOGIN Conseiller;
GO

-- Droits pour Conseiller
CREATE ROLE Conseiller;
GRANT SELECT ON Client TO Conseiller;
GRANT SELECT ON Produit TO Conseiller;
GRANT INSERT, UPDATE, SELECT ON Vente TO Conseiller;
GRANT SELECT ON Composant TO Conseiller;
GRANT SELECT ON Conseiller TO Conseiller;
GO

ALTER ROLE Conseiller ADD member ThorOdinson;
ALTER ROLE Conseiller ADD member LokiLaufeyson;
ALTER ROLE Conseiller ADD member FreyrFreyson;
ALTER ROLE Conseiller ADD member NjordNjordson;
ALTER ROLE Conseiller ADD member FriggOdinsdottir;
ALTER ROLE Conseiller ADD member OdinHreidmarson;
ALTER ROLE Conseiller ADD member AngrbodaJotundottir;
ALTER ROLE Conseiller ADD member FreyjaFreyjadottir;
ALTER ROLE Conseiller ADD member VidarYggdrasilson;
ALTER ROLE Conseiller ADD member HelOdinsdottir;
ALTER ROLE Conseiller ADD member TyrTyrson;
ALTER ROLE Conseiller ADD member BaldrBaldrson;
ALTER ROLE Conseiller ADD member ThorolfHymirson;
ALTER ROLE Conseiller ADD member FenrirFenrirson;
ALTER ROLE Conseiller ADD member SkadiJotundottir;
ALTER ROLE Conseiller ADD member BragiBragason;
ALTER ROLE Conseiller ADD member ViliThorvaldson;
ALTER ROLE Conseiller ADD member EirVeidottir;
ALTER ROLE Conseiller ADD member HeimdallHeimdallson;
ALTER ROLE Conseiller ADD member GullveigGullveigsdottir;
GO

-- Droits pour Manager
CREATE ROLE Manager
GRANT SELECT, INSERT, UPDATE ON Client TO Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON Vente TO Manager;
GRANT SELECT, INSERT, UPDATE ON Produit TO Manager;
GRANT SELECT ON Fournisseur TO Manager;
GRANT SELECT ON Conseiller TO Manager;
GO

ALTER ROLE Manager ADD member BallasOrokin;
GO


-- Droits pour AdminSystem
GRANT CONTROL ON SCHEMA::dbo TO AdminSystem;
GRANT ALTER ANY USER TO AdminSystem;
GRANT ALTER ANY ROLE TO AdminSystem;
GO

ALTER ROLE Administrateur ADD member SysAdmin;
GO

INSERT INTO client (
    idClient, nomClient, prenomClient, dateNaissanceClient, sexeClient, telClient, mailClient, adresse1Client, adresse2Client, codePostalClient, villeClient
) VALUES
    (1, 'de Beaune', 'Martin', '1587-06-15', 1, 1587158615, 'martindebeaune-eveque@abbaye.fr', '32 Rue de la Grève', 'Ancienne Abbaye Saint-Florentin', 28800, 'Bonneval'),
    (2, 'Bochetel', 'Guillaume', '1558-09-02', 1, 7219121210, 'guillaume.bochetel@minister.fr', '107 Avenue du Roi', 'Batiment A', 95340, 'Benres'),
    (3, 'de Montmorency', 'Anne', '1493-03-15', 1, 1493150315, 'anne.montmorency@domaine.fr', '4 Place du Maréchal', 'Château de Chantilly', 60500, 'Chantilly'),
    (4, 'd’Estrées', 'Gabrielle', '1573-01-01', 2, 1573010123, 'gabrielle.estrées@cour.fr', '18 Rue Royale', 'Manoir des Fleurs', 75008, 'Paris'),
    (5, 'de La Rochefoucauld', 'François', '1559-09-15', 1, 1559091515, 'francois.rochefoucauld@marquis.fr', '2 Rue du Duc', 'Hôtel Particulier', 16000, 'Angoulême'),
    (6, 'de Nevers', 'Louis', '1588-12-24', 1, 1588122412, 'louis.nevers@duche.fr', '6 Rue des Ducs', 'Palais des Nevers', 58000, 'Nevers'),
    (7, 'd’Alençon', 'Marguerite', '1553-05-01', 2, 1553050101, 'marguerite.alencon@reine.fr', '7 Rue de la Reine', 'Résidence Royale', 78000, 'Versailles'),
    (8, 'de Lorraine', 'Charles', '1524-10-01', 1, 1524100101, 'charles.lorraine@duche.fr', '10 Rue du Cardinal', 'Palais Ducal', 54000, 'Nancy'),
    (9, 'de Guise', 'Henri', '1550-12-31', 1, 1550123112, 'henri.guise@guise.fr', '3 Rue Saint-Louis', 'Château de Guise', 02120, 'Guise'),
    (10, 'de Bourbon', 'Louis', '1530-11-10', 1, 1530111011, 'louis.bourbon@royale.fr', '5 Rue des Princes', 'Manoir de Bourbon', 75007, 'Paris'),
    (11, 'de Longueville', 'Françoise', '1535-04-12', 2, 1535041212, 'francoise.longueville@cour.fr', '20 Rue de la Reine', 'Résidence des Dames', 75008, 'Paris'),
    (12, 'de Foix', 'Gaston', '1512-09-20', 1, 1512092012, 'gaston.foix@comte.fr', '12 Rue des Comtes', 'Château de Foix', 09000, 'Foix'),
    (13, 'de la Tour', 'Catherine', '1540-08-05', 2, 1540080514, 'catherine.latour@cour.fr', '8 Rue des Dames', 'Résidence Royale', 75006, 'Paris'),
    (14, 'de Valois', 'Marguerite', '1553-05-01', 2, 1553050155, 'marguerite.valois@reine.fr', '7 Rue de la Reine', 'Résidence Royale', 78000, 'Versailles'),
    (15, 'de Navarre', 'Jeanne', '1528-01-07', 2, 1528010707, 'jeanne.navarre@cour.fr', '4 Rue de Navarre', 'Château de Navarre', 27000, 'Evreux'),
    (16, 'de Soissons', 'Louis', '1555-03-22', 1, 1555032203, 'louis.soissons@soissons.fr', '15 Avenue des Princes', 'Hôtel des Comtes', 02200, 'Soissons'),
    (17, 'de Vendôme', 'Antoine', '1518-06-29', 1, 1518062929, 'antoine.vendome@cour.fr', '9 Rue du Roi', 'Manoir de Vendôme', 41100, 'Vendôme'),
    (18, 'd’Anjou', 'René', '1409-01-16', 1, 1409011616, 'rene.anjou@cour.fr', '10 Rue des Ducs', 'Château d’Anjou', 49000, 'Angers'),
    (19, 'de Saint-Simon', 'Louis', '1560-07-08', 1, 1560070807, 'louis.saintsimon@duc.fr', '22 Rue de la Cour', 'Hôtel Saint-Simon', 75004, 'Paris'),
    (20, 'de Clèves', 'Anne', '1515-09-22', 2, 1515092215, 'anne.cleves@cour.fr', '13 Rue Royale', 'Palais de Clèves', 59000, 'Lille'),
    (21, 'de Luxembourg', 'Jean', '1505-05-15', 1, 1505051515, 'jean.luxembourg@cour.fr', '12 Rue des Nobles', 'Château de Luxembourg', 67000, 'Strasbourg'),
    (22, 'de Nemours', 'Jacqueline', '1538-11-19', 2, 1538111911, 'jacqueline.nemours@cour.fr', '19 Avenue de la Noblesse', 'Domaine de Nemours', 77000, 'Nemours'),
    (23, 'de Noailles', 'Gaspard', '1550-02-11', 1, 1550021111, 'gaspard.noailles@duc.fr', '8 Rue du Maréchal', 'Château de Noailles', 13000, 'Marseille'),
    (24, 'de Sully', 'Maximilien', '1560-12-13', 1, 1560121312, 'maximilien.sully@cour.fr', '7 Avenue des Nobles', 'Manoir de Sully', 75002, 'Paris'),
    (25, 'de La Trémoille', 'Charlotte', '1533-08-20', 2, 1533082020, 'charlotte.tremoille@marquise.fr', '16 Rue de la Duchesse', 'Hôtel de La Trémoille', 75009, 'Paris'),
    (26, 'd’Aragon', 'Blanche', '1478-06-05', 2, 1478060555, 'blanche.aragon@cour.fr', '5 Rue du Roi', 'Palais Royal', 75001, 'Paris'),
    (27, 'd’Albret', 'Jeanne', '1528-11-07', 2, 1528110728, 'jeanne.albret@reine.fr', '3 Rue des Rois', 'Château d’Albret', 40000, 'Mont-de-Marsan'),
    (28, 'de Médicis', 'Marie', '1573-04-26', 2, 1573042626, 'marie.medicis@reine.fr', '14 Rue des Rois', 'Palais des Médicis', 75007, 'Paris'),
    (29, 'de Rochechouart', 'Gabrielle', '1565-03-12', 2, 1565031212, 'gabrielle.rochechouart@cour.fr', '21 Rue de la Duchesse', 'Hôtel Rochechouart', 75006, 'Paris'),
    (30, 'de Montpensier', 'Charlotte', '1546-10-10', 2, 1546101010, 'charlotte.montpensier@cour.fr', '17 Avenue des Ducs', 'Château de Montpensier', 69000, 'Lyon'),
    (31, 'de Brissac', 'Charles', '1543-05-05', 1, 1543050555, 'charles.brissac@cour.fr', '8 Rue du Maréchal', 'Hôtel de Brissac', 49000, 'Angers'),
    (32, 'de Thou', 'Jacques', '1563-10-08', 1, 1563100810, 'jacques.thou@cour.fr', '19 Rue du Parlement', 'Palais de Justice', 75004, 'Paris'),
    (33, 'de Gondi', 'Jean-François', '1557-02-27', 1, 1557022727, 'jean.gondi@cour.fr', '3 Rue de la Couronne', 'Palais Gondi', 75001, 'Paris'),
    (34, 'd’Ornano', 'Alphonse', '1548-07-17', 1, 1548071717, 'alphonse.ornano@duc.fr', '12 Rue des Commandeurs', 'Château d’Ornano', 75008, 'Paris'),
    (35, 'de Broglie', 'Victor', '1588-03-13', 1, 1588031313, 'victor.broglie@duc.fr', '20 Rue des Nobles', 'Hôtel de Broglie', 75003, 'Paris'),
    (36, 'd’Épernon', 'Jean-Louis', '1554-08-22', 1, 1554082215, 'jeanlouis.epernon@cour.fr', '6 Avenue Royale', 'Palais des Épernon', 33200, 'Bordeaux'),
    (37, 'de Cossé', 'Artus', '1530-06-14', 1, 1530061414, 'artus.cosse@duc.fr', '22 Rue des Marquis', 'Château de Cossé', 53100, 'Mayenne'),
    (38, 'de Beauvilliers', 'Paul', '1570-09-05', 1, 1570090505, 'paul.beauvilliers@duc.fr', '5 Rue Royale', 'Hôtel de Beauvilliers', 75002, 'Paris'),
    (39, 'de Châtillon', 'Gaspard', '1529-04-06', 1, 1529040606, 'gaspard.chatillon@duc.fr', '14 Rue du Chevalier', 'Château de Châtillon', 60520, 'La Chapelle-en-Serval'),
    (40, 'de La Rivière', 'Renée', '1569-11-23', 2, 1569112311, 'renee.lariviere@cour.fr', '9 Rue de la Duchesse', 'Hôtel de La Rivière', 75005, 'Paris'),
    (41, 'de La Marck', 'Robert', '1506-08-15', 1, 1506081515, 'robert.lamarck@duc.fr', '16 Rue des Comtes', 'Château de Sedan', 08200, 'Sedan'),
    (42, 'de Talleyrand', 'Alexandre', '1559-12-01', 1, 1559120115, 'alexandre.talleyrand@cour.fr', '2 Rue de la Duchesse', 'Palais Talleyrand', 75001, 'Paris'),
    (43, 'de Créquy', 'Françoise', '1572-03-21', 2, 1572032103, 'francoise.crequy@marquise.fr', '3 Avenue de l’Église', 'Hôtel de Créquy', 75007, 'Paris'),
    (44, 'de Clermont', 'Henriette', '1547-05-30', 2, 1547053015, 'henriette.clermont@reine.fr', '11 Rue des Dames', 'Résidence Royale', 75001, 'Paris'),
    (45, 'de La Rochejacquelein', 'Marie-Louise', '1584-02-13', 2, 1584021315, 'marielouise.larochejacquelein@cour.fr', '6 Rue des Nobles', 'Château de La Rochejacquelein', 49300, 'Cholet'),
    (46, 'de Chabannes', 'Louis', '1511-11-09', 1, 1511110909, 'louis.chabannes@cour.fr', '8 Rue des Marquis', 'Château de Chabannes', 23300, 'La Souterraine'),
    (47, 'de La Rivière', 'Philippe', '1575-09-18', 1, 1575091809, 'philippe.lariviere@cour.fr', '4 Rue de la Fontaine', 'Hôtel de La Rivière', 75006, 'Paris');

INSERT INTO conseiller (
    idConseiller, nomConseiller, prenomConseiller, dateNaissanceConseiller, telConseiller, mailConseiller, numSecuConseiller, pourcentageGainVente, pourcentageMarraine, estMarraine
) VALUES
    (1, 'Odinson', 'Thor', '1985-04-12', '0601123456', 'thor.odinson@asgard.com', '1234567890123', 12.50, 0, 1),
    (2, 'Laufeyson', 'Loki', '1987-08-21', '0602234567', 'loki.laufeyson@asgard.com', '2345678901234', 10.00, 0, 0),
    (3, 'Freyson', 'Freyr', '1990-05-15', '0603345678', 'freyr.freyson@vanaheim.com', '3456789012345', 11.75, 7.25, 1),
    (4, 'Njordson', 'Njord', '1975-09-30', '0604456789', 'njord.njordson@vanaheim.com', '4567890123456', 13.00, 9.00, 1),
    (5, 'Odinsdottir', 'Frigg', '1982-02-18', '0605567890', 'frigg.odinsdottir@asgard.com', '5678901234567', 12.00, 8.75, 1),
    (6, 'Hreidmarson', 'Odin', '1960-11-11', '0606678901', 'odin.hreidmarson@asgard.com', '6789012345678', 15.00, 9.50, 1),
    (7, 'Jotundottir', 'Angrboda', '1989-06-09', '0607789012', 'angrboda.jotundottir@jotunheim.com', '7890123456789', 9.75, 5.75, 0),
    (8, 'Freyjadottir', 'Freyja', '1992-12-05', '0608890123', 'freyja.freyjadottir@vanaheim.com', '8901234567890', 14.25, 10.25, 1),
    (9, 'Yggdrasilson', 'Vidar', '1984-03-18', '0609901234', 'vidar.yggdrasilson@asgard.com', '9012345678901', 10.50, 6.75, 0),
    (10, 'Odinsdottir', 'Hel', '1986-10-30', '0610012345', 'hel.odinsdottir@helheim.com', '1123456789012', 11.00, 7.00, 0),
    (11, 'Tyrson', 'Tyr', '1983-08-12', '0611123456', 'tyr.tyrson@asgard.com', '2234567890123', 13.75, 9.25, 1),
    (12, 'Baldrson', 'Baldr', '1987-05-27', '0612234567', 'baldr.baldrson@asgard.com', '3345678901234', 12.50, 8.00, 1),
    (13, 'Hymirson', 'Thorolf', '1980-02-25', '0613345678', 'thorolf.hymirson@midgard.com', '4456789012345', 11.25, 7.50, 0),
    (14, 'Fenrirson', 'Fenrir', '1993-04-17', '0614456789', 'fenrir.fenrirson@jotunheim.com', '5567890123456', 9.50, 5.50, 0),
    (15, 'Jotundottir', 'Skadi', '1991-07-19', '0615567890', 'skadi.jotundottir@jotunheim.com', '6678901234567', 10.75, 6.25, 1),
    (16, 'Bragason', 'Bragi', '1985-09-25', '0616678901', 'bragi.bragason@asgard.com', '7789012345678', 13.50, 8.75, 1),
    (17, 'Thorvaldson', 'Vili', '1988-11-07', '0617789012', 'vili.thorvaldson@asgard.com', '8890123456789', 12.00, 0, 0),
    (18, 'Veidottir', 'Eir', '1981-10-02', '0618890123', 'eir.veidottir@asgard.com', '9901234567890', 14.00, 9.75, 1),
    (19, 'Heimdallson', 'Heimdall', '1983-12-12', '0619901234', 'heimdall.heimdallson@asgard.com', '1012345678901', 10.25, 6.50, 0),
    (20, 'Gullveigsdottir', 'Gullveig', '1978-01-29', '0620012345', 'gullveig.gullveigsdottir@vanaheim.com', '2123456789012', 15.50, 10.50, 1);

INSERT INTO fournisseur (
    idFournisseur, nomFournisseur, paysFournisseur, adresse1Fournisseur, adresse2Fournisseur, CPFournisseur, villeFournisseur, telFournisseur, mailFournisseur, numSIRETFournisseur
) VALUES
    (1, 'DreamtimeImports', 'Australie', '14 Bushland Road', 'Quartier des Esprits', 2000, 'Sydney', 6123456781, 'contact@dreamtimeimports.au', 12345678901234),
    (2, 'SouthernCrossSupplies', 'Australie', '88 Outback Lane', 'Centre Australis', 3000, 'Melbourne', 6234567849, 'service@southerncrosssupplies.au', 23456789012345);

INSERT INTO produit (
    referenceProduit, nomProduit, prixHorsTaxeProduit, descriptionProduit, imgProduit, pictogrammeProduit, discontinuerProduit, quantiteStockProduit, idFournisseur
) VALUES
    ('PRD001', 'Mjölnir', 1200.00, 'Marteau de Thor', 'mjolnir.png', 'pict_mjolnir.png', 0, 15, 1),
    ('PRD002', 'Épée dExcalibur', 2300.00, 'Épée magique du roi Arthur', 'excalibur.png', 'pict_excalibur.png', 0, 8, 2),
    ('PRD003', 'Saint Graal', 5000.00, 'Coupe sacrée aux pouvoirs de guérison', 'graal.png', 'pict_graal.png', 1, 3, 1),
    ('PRD004', 'Talisman dAnubis', 750.00, 'Amulette égyptienne de protection', 'anubis_talisman.png', 'pict_anubis.png', 0, 25, 2),
    ('PRD005', 'Yata no Kagami', 1800.00, 'Miroir sacré japonais', 'yata_no_kagami.png', 'pict_yata_no_kagami.png', 0, 7, 1),
    ('PRD006', 'Trident de Poséidon', 3400.00, 'Trident du dieu des mers', 'trident_poseidon.png', 'pict_trident.png', 0, 4, 2),
    ('PRD007', 'Cape dInvisibilité', 2500.00, 'Cape rendant invisible', 'cape_invisibilite.png', 'pict_cape.png', 1, 0, 1),
    ('PRD008', 'Lanterne dAladdin', 1500.00, 'Lampe aux souhaits magique', 'lanterne_aladdin.png', 'pict_lanterne.png', 0, 10, 2),
    ('PRD009', 'Châle de Morrigan', 600.00, 'Cape des transformations', 'chale_morrigan.png', 'pict_morrigan.png', 0, 20, 1),
    ('PRD010', 'Anneau de Gygès', 2100.00, 'Anneau d’invisibilité grec', 'anneau_gyges.png', 'pict_gyges.png', 1, 5, 2),
    ('PRD011', 'Pierre Philosophale', 4500.00, 'Pierre d’immortalité et transmutation', 'pierre_philosophale.png', 'pict_pierre.png', 1, 1, 1),
    ('PRD012', 'Caduceus dHermès', 1700.00, 'Bâton de guérison et de protection', 'caduceus_hermes.png', 'pict_caduceus.png', 0, 12, 2),
    ('PRD013', 'Collier de Freyja', 900.00, 'Collier de fertilité et prospérité', 'collier_freyja.png', 'pict_freyja.png', 0, 18, 1),
    ('PRD014', 'Bouclier dAchille', 3000.00, 'Bouclier invincible du héros grec', 'bouclier_achille.png', 'pict_bouclier.png', 0, 6, 2),
    ('PRD015', 'Talisman de Shamash', 800.00, 'Symbole de justice et vérité', 'talisman_shamash.png', 'pict_shamash.png', 0, 22, 1),
    ('PRD016', 'Couronne de Gilgamesh', 2500.00, 'Symbole de puissance et longévité', 'couronne_gilgamesh.png', 'pict_gilgamesh.png', 1, 2, 2),
    ('PRD017', 'Chapeau de Merlin', 1100.00, 'Chapeau magique de clairvoyance', 'chapeau_merlin.png', 'pict_merlin.png', 0, 14, 1),
    ('PRD018', 'Anneau des Nibelungen', 2800.00, 'Anneau de pouvoir germanique', 'anneau_nibelungen.png', 'pict_nibelungen.png', 0, 9, 2),
    ('PRD019', 'Heaume de Hades', 2200.00, 'Casque rendant invisible', 'heaume_hades.png', 'pict_hades.png', 1, 3, 1),
    ('PRD020', 'Peigne dAmaterasu', 1300.00, 'Peigne solaire de la déesse japonaise', 'peigne_amaterasu.png', 'pict_amaterasu.png', 0, 16, 2);

INSERT INTO manager (
    idManager, nomManager, prenomManager, estDirecteur) VALUES (01, 'Orokin', 'Ballas',1);

INSERT INTO composant (
    idComposant, nomComposant, estAllergene
) VALUES
    (1, 'Poudre de Météorite Sacrée', 0),
    (2, 'Écaille de Dragon Ancien', 1),
    (3, 'Essence de Lotus Bleu', 0),
    (4, 'Ambre des Anciens', 0),
    (5, 'Plume de Phénix', 1),
    (6, 'Fragment dÉtoile Filante', 0),
    (7, 'Cendre dImmortel', 0),
    (8, 'Poussière de Lune', 0),
    (9, 'Élixir de Vie Éternelle', 1),
    (10, 'Larme de Sirène', 0),
    (11, 'Sang de Minotaure', 1),
    (12, 'Pétale de Rose Éternelle', 0),
    (13, 'Corne de Licorne', 1),
    (14, 'Argent Enchanté', 0),
    (15, 'Racine de Mandragore', 1),
    (16, 'Eau du Styx', 1),
    (17, 'Essence de Myrrhe Divine', 0),
    (18, 'Cœur de Cristal Magique', 0),
    (19, 'Poudre de Saphir Mystique', 0),
    (20, 'Écorce de lArbre Monde', 0),
    (21, 'Feuille dIf Sacré', 1),
    (22, 'Lumière de lAurore Boréale', 0),
    (23, 'Huile de la Flamme Éternelle', 1),
    (24, 'Éclat de la Pierre Philosophale', 1),
    (25, 'Fleur de Mandragora', 1),
    (26, 'Résine de lArbre de Vie', 0),
    (27, 'Sable du Désert du Temps', 0),
    (28, 'Souffle du Vent du Nord', 0),
    (29, 'Ombre de la Nuit Étoilée', 0),
    (30, 'Perle des Profondeurs', 1);

GO

INSERT INTO compose (
    referenceProduit, idComposant
) VALUES
    -- Mjölnir (Marteau de Thor)
    ('PRD001', 2),  -- Écaille de Dragon Ancien
    ('PRD001', 6),  -- Fragment dÉtoile Filante
    ('PRD001', 14), -- Argent Enchanté

    -- Épée dExcalibur
    ('PRD002', 7),  -- Cendre dImmortel
    ('PRD002', 14), -- Argent Enchanté
    ('PRD002', 18), -- Cœur de Cristal Magique

    -- Saint Graal
    ('PRD003', 10), -- Larme de Sirène
    ('PRD003', 9),  -- Élixir de Vie Éternelle
    ('PRD003', 17), -- Essence de Myrrhe Divine

    -- Talisman dAnubis
    ('PRD004', 4),  -- Ambre des Anciens
    ('PRD004', 11), -- Sang de Minotaure
    ('PRD004', 15), -- Racine de Mandragore

    -- Yata no Kagami (Miroir sacré japonais)
    ('PRD005', 3),  -- Essence de Lotus Bleu
    ('PRD005', 8),  -- Poussière de Lune
    ('PRD005', 12), -- Pétale de Rose Éternelle

    -- Trident de Poséidon
    ('PRD006', 10), -- Larme de Sirène
    ('PRD006', 26), -- Résine de lArbre de Vie
    ('PRD006', 19), -- Poudre de Saphir Mystique

    -- Cape dInvisibilité
    ('PRD007', 28), -- Souffle du Vent du Nord
    ('PRD007', 22), -- Lumière de lAurore Boréale
    ('PRD007', 18), -- Cœur de Cristal Magique

    -- Lanterne dAladdin
    ('PRD008', 23), -- Huile de la Flamme Éternelle
    ('PRD008', 29), -- Ombre de la Nuit Étoilée
    ('PRD008', 5),  -- Plume de Phénix

    -- Châle de Morrigan
    ('PRD009', 21), -- Feuille dIf Sacré
    ('PRD009', 1),  -- Poudre de Météorite Sacrée
    ('PRD009', 25), -- Fleur de Mandragora

    -- Anneau de Gygès
    ('PRD010', 13), -- Corne de Licorne
    ('PRD010', 16), -- Eau du Styx
    ('PRD010', 6),  -- Fragment dÉtoile Filante

    -- Pierre Philosophale
    ('PRD011', 24), -- Éclat de la Pierre Philosophale
    ('PRD011', 7),  -- Cendre dImmortel
    ('PRD011', 19), -- Poudre de Saphir Mystique

    -- Caduceus dHermès
    ('PRD012', 17), -- Essence de Myrrhe Divine
    ('PRD012', 3),  -- Essence de Lotus Bleu
    ('PRD012', 10), -- Larme de Sirène

    -- Collier de Freyja
    ('PRD013', 26), -- Résine de lArbre de Vie
    ('PRD013', 12), -- Pétale de Rose Éternelle
    ('PRD013', 22), -- Lumière de lAurore Boréale

    -- Bouclier dAchille
    ('PRD014', 4),  -- Ambre des Anciens
    ('PRD014', 15), -- Racine de Mandragore
    ('PRD014', 19), -- Poudre de Saphir Mystique

    -- Talisman de Shamash
    ('PRD015', 8),  -- Poussière de Lune
    ('PRD015', 5),  -- Plume de Phénix
    ('PRD015', 18), -- Cœur de Cristal Magique

    -- Couronne de Gilgamesh
    ('PRD016', 20), -- Écorce de lArbre Monde
    ('PRD016', 9),  -- Élixir de Vie Éternelle
    ('PRD016', 6),  -- Fragment dÉtoile Filante

    -- Chapeau de Merlin
    ('PRD017', 27), -- Sable du Désert du Temps
    ('PRD017', 28), -- Souffle du Vent du Nord
    ('PRD017', 3),  -- Essence de Lotus Bleu

    -- Anneau des Nibelungen
    ('PRD018', 2),  -- Écaille de Dragon Ancien
    ('PRD018', 11), -- Sang de Minotaure
    ('PRD018', 14), -- Argent Enchanté

    -- Heaume de Hades
    ('PRD019', 16), -- Eau du Styx
    ('PRD019', 29), -- Ombre de la Nuit Étoilée
    ('PRD019', 24), -- Éclat de la Pierre Philosophale

    -- Peigne dAmaterasu
    ('PRD020', 22), -- Lumière de lAurore Boréale
    ('PRD020', 12), -- Pétale de Rose Éternelle
    ('PRD020', 17); -- Essence de Myrrhe Divine

INSERT INTO commande (idCommande, remiseCommande, dateCommande, dateLivraisonCommande, PrixTotalCommande, idManager, idConseiller, idClient)
VALUES
(1, 10.50, '2024-12-01', '2024-12-10', 150.00, null, 5, 1),
(2, 5.00, '2024-11-20', '2024-11-25', 200.00, null, 4, 2),
(3, NULL, '2024-10-15', '2024-10-20', 120.00, NULL, 6, 3),
(4, 15.75, '2024-12-03', '2024-12-08', 180.50, 1, 5, 4),
(5, 0.00, '2024-12-04', NULL, 100.00, 1, NULL, 5);


INSERT into reunionClient (idclient, idconseiller, idreunion, datereunion)
values
(1,2,1,'2024-10-12'),
(5,2,2,'2024-10-12'),
(2,4,3,'2024-10-12');
GO

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

-- BACKUP DATABASE NaturaDerm
-- TO DISK = 'C:\tmp\NaturaDermSave.bak'

-- USE MASTER
-- RESTORE DATABASE NaturaDerm
-- FROM DISK = 'C:\tmp\NaturaDermSave.bak'
-- WITH REPLACE;
