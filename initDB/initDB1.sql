CREATE TABLE client(
   idClient INT,
   nomClient VARCHAR(50) NOT NULL,
   prenomClient VARCHAR(50) NOT NULL,
   dateNaissanceClient DATE,
   sexeClient INT,
   telClient BIGINT,
   mailClient VARCHAR(50),
   adresse1Client VARCHAR(50) NOT NULL,
   adresse2Client VARCHAR(50) NOT NULL,
   codePostalClient INT NOT NULL,
   villeClient VARCHAR(50) NOT NULL,
   PRIMARY KEY(idClient)
);

CREATE TABLE conseiller(
   idConseiller INT,
   nomConseiller VARCHAR(50) NOT NULL,
   prenomConseiller VARCHAR(50) NOT NULL,
   dateNaissanceConseiller DATE,
   telConseiller BIGINT,
   mailConseiller VARCHAR(50),
   numSecuConseiller VARCHAR NOT NULL,
   pourcentageGainVente DECIMAL(15,2) NOT NULL,
   pourcentageMarraine DECIMAL(15,2) NOT NULL,
   estMarraine TINYINT NOT NULL,
   PRIMARY KEY(idConseiller)
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
   PRIMARY KEY(idFournisseur)
);

CREATE TABLE produit(
   referenceProduit VARCHAR(50),
   nomProduit VARCHAR(50) NOT NULL,
   prixHorsTaxeProduit Money NOT NULL,
   descriptionProduit VARCHAR(50),
   imgProduit VARCHAR(50),
   pictogrammeProduit VARCHAR(50),
   discontinuerProduit TINYINT NOT NULL,
   quantiteStockProduit INT,
   idFournisseur INT NOT NULL,
   PRIMARY KEY(referenceProduit),
   FOREIGN KEY(idFournisseur) REFERENCES fournisseur(idFournisseur)
);

CREATE TABLE manager(
   idManager INT,
   nomManager VARCHAR(50) NOT NULL,
   prenomManager VARCHAR(50) NOT NULL,
   estDirecteur TINYINT,
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
   FOREIGN KEY(idClient) REFERENCES client(idClient)
);

CREATE TABLE composant(
   idComposant INT,
   nomComposant VARCHAR(50) NOT NULL,
   estAllergene TINYINT NOT NULL,
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
   FOREIGN KEY(idCommande) REFERENCES commande(idCommande)
);

CREATE TABLE compose(
   referenceProduit VARCHAR(50),
   idComposant INT,
   PRIMARY KEY(referenceProduit, idComposant),
   FOREIGN KEY(referenceProduit) REFERENCES produit(referenceProduit),
   FOREIGN KEY(idComposant) REFERENCES composant(idComposant)
);
