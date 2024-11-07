DROP TABLE IF EXISTS marston.prod_maatoutcomesodfdc;

CREATE TABLE marston.prod_maatoutcomesodfdc (
    rep_id INTEGER,
    ccoo_outcome TEXT,
    cc_outcome_date TEXT,
    sentence_order_date TEXT,
    final_cost TEXT,
    lgfs_cost TEXT,
    agfs_cost TEXT
);

CREATE INDEX idx_rep_id ON marston.prod_maatoutcomesodfdc (rep_id);

COPY marston.prod_maatoutcomesodfdc (rep_id, ccoo_outcome, cc_outcome_date, sentence_order_date, final_cost, lgfs_cost, agfs_cost)
FROM '/Users/abe.cetin/Documents/MAATOutcomesSODFDCs.csv'
DELIMITER ','
CSV HEADER;
