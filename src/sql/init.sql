DROP TABLE IF EXISTS data;

CREATE TABLE data (
    name                      VARCHAR(99)           NOT NULL,
    england_nw_europe         TINYINT     UNSIGNED  NOT NULL,
    ireland                   TINYINT     UNSIGNED  NOT NULL,
    scotland                  TINYINT     UNSIGNED  NOT NULL,
    wales                     TINYINT     UNSIGNED  NOT NULL,
    germanic_europe           TINYINT     UNSIGNED  NOT NULL,
    norway                    TINYINT     UNSIGNED  NOT NULL,
    sweden_denmark            TINYINT     UNSIGNED  NOT NULL,
    finland                   TINYINT     UNSIGNED  NOT NULL,
    eastern_europe_russia     TINYINT     UNSIGNED  NOT NULL,
    european_jewish           TINYINT     UNSIGNED  NOT NULL,
    baltics                   TINYINT     UNSIGNED  NOT NULL,
    sardinia                  TINYINT     UNSIGNED  NOT NULL,
    indigenous_north_america  TINYINT     UNSIGNED  NOT NULL,
    northern_philippines      TINYINT     UNSIGNED  NOT NULL,

    PRIMARY KEY (name)
);

LOAD DATA LOCAL INFILE
    './data/family.csv'
    INTO TABLE data
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;
