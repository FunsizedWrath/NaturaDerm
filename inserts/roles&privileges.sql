CREATE LOGIN Conseiller
WITH PASSWORD = 'p@ssword123',
DEFAULT_DATABASE=NaturaDerm,
DEFAULT_LANGUAGE=French

CREATE LOGIN Manager
WITH PASSWORD = 'ManagerP@ssword123',
DEFAULT_DATABASE=NaturaDerm,
DEFAULT_LANGUAGE=French

CREATE LOGIN Administrateur
WITH PASSWORD = 'AdminP@ssword123',
DEFAULT_DATABASE=NaturaDerm,
DEFAULT_LANGUAGE=French

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

-- Droits pour Conseiller
CREATE ROLE Conseiller;
GRANT SELECT ON Client TO Conseiller;
GRANT SELECT ON Produit TO Conseiller;
GRANT INSERT, UPDATE, SELECT ON Vente TO Conseiller;
GRANT SELECT ON Composant TO Conseiller;
GRANT SELECT ON Conseiller TO Conseiller;

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

-- Droits pour Manager
CREATE ROLE Manager
GRANT SELECT, INSERT, UPDATE ON Client TO Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON Vente TO Manager;
GRANT SELECT, INSERT, UPDATE ON Produit TO Manager;
GRANT SELECT ON Fournisseur TO Manager;
GRANT SELECT ON Conseiller TO Manager;

ALTER ROLE Manager ADD member BallasOrokin;



-- Droits pour AdminSystem
GRANT CONTROL ON SCHEMA::dbo TO AdminSystem;
GRANT ALTER ANY USER TO AdminSystem;
GRANT ALTER ANY ROLE TO AdminSystem;

ALTER ROLE Administrateur ADD member SysAdmin;
