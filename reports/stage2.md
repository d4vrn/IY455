# IY455 Stage 2

| Assessment Details | Please Complete All Details |
| ------------------ | --------------------------- |
| Group              | B                           |
| Module Title       | Implementation Model        |
| Assessment Type    | Coursework                  |
| Module Tutor Name  | Mustafa Ghashim             |
| Student ID Number  | P500796                     |
| Date of Submission | 22/2/2026                   |
| Word Count         | 592                         |

- [x] *I confirm that this assignment is my own work. Where I have referred to academic sources, I have provided in-text citations and included the sources in
  the final reference list.*

- [x] *Where I have used AI, I have cited and referenced appropriately.

---

## Task 3 - SQL code and print screen of SQL output

### Database Creation:

```sql
CREATE DATABASE IF NOT EXISTS dvd_loan;
USE dvd_loan;
```

---

### Table Creation:

```sql
CREATE TABLE Rental_Category (
    categoryId      INT             NOT NULL AUTO_INCREMENT,
    categoryName    VARCHAR(50)     NOT NULL,
    rentalDuration  INT             NOT NULL,
    rentalCost      DECIMAL(5,2)    NOT NULL,
    fineChargeRate  DECIMAL(5,2)    NOT NULL,
    PRIMARY KEY (categoryId)
);

CREATE TABLE Borrower (
    borrowerId      INT             NOT NULL AUTO_INCREMENT,
    borrowerName    VARCHAR(100)    NOT NULL,
    borrowerAddress VARCHAR(255)    NOT NULL,
    borrowerStatus  ENUM('active', 'dormant', 'suspended', 'terminated') NOT NULL,
    PRIMARY KEY (borrowerId)
);

CREATE TABLE DVD (
    dvdId           VARCHAR(10)     NOT NULL,
    dvdTitle        VARCHAR(100)    NOT NULL,
    starringActor   VARCHAR(100)    NOT NULL,
    dvdYear         INT             NOT NULL,
    categoryId      INT             NOT NULL,
    PRIMARY KEY (dvdId),
    FOREIGN KEY (categoryId) REFERENCES Rental_Category(categoryId)
);

CREATE TABLE Copy (
    copyId          INT             NOT NULL AUTO_INCREMENT,
    dvdId           VARCHAR(10)     NOT NULL,
    shelfPosition   VARCHAR(20)     NOT NULL,
    dvdStatus       ENUM('available', 'on loan', 'overdue', 'reserved', 'missing') NOT NULL,
    PRIMARY KEY (copyId),
    FOREIGN KEY (dvdId) REFERENCES DVD(dvdId)
);

CREATE TABLE Loan (
    loanId          INT             NOT NULL AUTO_INCREMENT,
    borrowerId      INT             NOT NULL,
    loanDate        DATE            NOT NULL,
    PRIMARY KEY (loanId),
    FOREIGN KEY (borrowerId) REFERENCES Borrower(borrowerId)
);

CREATE TABLE Loan_Category (
    loanId          INT             NOT NULL,
    copyId          INT             NOT NULL,
    returnDueDate   DATE            NOT NULL,
    PRIMARY KEY (loanId, copyId),
    FOREIGN KEY (loanId) REFERENCES Loan(loanId),
    FOREIGN KEY (copyId) REFERENCES Copy(copyId)
);

```

---

### Tables:

```sql
SHOW TABLES;
```

![Tables](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/tables.png)


---

### Inserting Data:

```sql
INSERT INTO Rental_Category (categoryName, rentalDuration, rentalCost, fineChargeRate) VALUES
('Action',      3, 4.00, 1.00),
('Adventure',   7, 3.50, 0.50),
('Animation',   7, 3.50, 0.50),
('Biography',   7, 3.80, 0.50),
('Comedy',      3, 4.50, 1.00),
('Crime',       3, 3.80, 1.00),
('Drama',       7, 4.20, 0.50),
('Horror',      3, 4.00, 1.00),
('Superhero',   1, 4.50, 1.50);


INSERT INTO Borrower (borrowerName, borrowerAddress, borrowerStatus) VALUES
('Ben Jones',       '28 Low Road, Nottingham NG5 3PB',      'active'),
('Sarah Miller',    '14 High Street, Nottingham NG1 2AB',   'active'),
('James Wilson',    '5 Park Lane, Nottingham NG7 4CD',      'active'),
('Emily Davis',     '33 Oak Avenue, Nottingham NG3 5EF',    'dormant'),
('Michael Brown',   '9 Elm Close, Nottingham NG8 6GH',      'active'),
('Laura Taylor',    '21 Maple Road, Nottingham NG2 7IJ',    'suspended'),
('Daniel White',    '7 Cedar Street, Nottingham NG6 8KL',   'active'),
('Sophie Harris',   '15 Birch Way, Nottingham NG4 9MN',     'active');


INSERT INTO DVD (dvdId, dvdTitle, starringActor, dvdYear, categoryId) VALUES
('DN050',  'Guardians of the Galaxy',                      'Chris Pratt',          2014, 9),
('DN0135', 'Prometheus',                                   'Noomi Rapace',         2012, 2),
('DN0171', 'Split',                                        'James McAvoy',         2016, 8),
('DN0102', 'Sing',                                         'Matthew McConaughey',  2016, 3),
('DN0188', 'Suicide Squad',                                'Will Smith',           2016, 9),
('DN025',  'The Great Wall',                               'Matt Damon',           2016, 1),
('DN0157', 'La La Land',                                   'Ryan Gosling',         2016, 5),
('DN0177', 'Mindhorn',                                     'Essie Davis',          2016, 5),
('DN0129', 'The Lost City of Z',                           'Charlie Hunnam',       2016, 1),
('DN0114', 'Passengers',                                   'Jennifer Lawrence',    2016, 2),
('DN085',  'Fantastic Beasts and Where to Find Them',      'Eddie Redmayne',       2016, 2),
('DN083',  'Hidden Figures',                               'Taraji P. Henson',     2016, 4),
('DN039',  'Rogue One',                                    'Felicity Jones',       2016, 1),
('DN0117', 'Moana',                                        'Auli i Cravalho',      2016, 3),
('DN0183', 'Colossal',                                     'Anne Hathaway',        2016, 1),
('DN100',  'The Secret Life of Pets',                      'Louis C.K.',           2016, 3),
('DN070',  'Hacksaw Ridge',                                'Andrew Garfield',      2016, 4),
('DN048',  'Jason Bourne',                                 'Matt Damon',           2016, 1),
('DN0146', 'Lion',                                         'Dev Patel',            2016, 4),
('DN062',  'Arrival',                                      'Amy Adams',            2016, 7),
('DN0139', 'Gold',                                         'Matthew McConaughey',  2016, 2),
('DN0151', 'Manchester by the Sea',                        'Casey Affleck',        2016, 7),
('DN056',  'Hounds of Love',                               'Emma Booth',           2016, 6),
('DN0156', 'Trolls',                                       'Anna Kendrick',        2016, 3),
('DN0166', 'Independence Day: Resurgence',                 'Liam Hemsworth',       2016, 1),
('DN033',  'Paris pieds nus',                              'Fiona Gordon',         2016, 5),
('DN0108', 'Bahubali: The Beginning',                      'Prabhas',              2015, 1),
('DN052',  'Dead Awake',                                   'Jocelin Donahue',      2016, 8),
('DN0159', 'Bad Moms',                                     'Mila Kunis',           2016, 5),
('DN0167', 'Assassins Creed',                              'Michael Fassbender',   2016, 1),
('DN0161', 'Why Him?',                                     'Zoey Deutch',          2016, 5),
('DN013',  'Nocturnal Animals',                            'Amy Adams',            2016, 7),
('DN0149', 'X-Men: Apocalypse',                            'James McAvoy',         2016, 9),
('DN087',  'Deadpool',                                     'Ryan Reynolds',        2016, 9),
('DN0190', 'Resident Evil: The Final Chapter',             'Milla Jovovich',       2016, 1),
('DN0107', 'Captain America: Civil War',                   'Chris Evans',          2016, 9),
('DN0127', 'Interstellar',                                 'Matthew McConaughey',  2014, 2),
('DN0109', 'Doctor Strange',                               'Benedict Cumberbatch', 2016, 9),
('DN0152', 'The Magnificent Seven',                        'Denzel Washington',    2016, 1),
('DN015',  '5/25/1977',                                    'John Francis Daley',   2007, 5),
('DN089',  'Sausage Party',                                'Seth Rogen',           2016, 3),
('DN072',  'Moonlight',                                    'Mahershala Ali',       2016, 7),
('DN019',  'Don t Die in the Woods',                       'Brittany Blanton',     2016, 8),
('DN032',  'The Founder',                                  'Michael Keaton',       2016, 4),
('DN0123', 'Lowriders',                                    'Gabriel Chavarria',    2016, 7),
('DN003',  'Pirates of the Caribbean: On Stranger Tides',  'Johnny Depp',          2011, 1),
('DN029',  'Miss Sloane',                                  'Jessica Chastain',     2016, 7),
('DN0158', 'Fallen',                                       'Hermione Corfield',    2016, 2),
('DN011',  'Star Trek Beyond',                             'Chris Pine',           2016, 1),
('DN040',  'The Last Face',                                'Charlize Theron',      2016, 7),
('DN0132', 'Star Wars: Episode VII - The Force Awakens',   'Daisy Ridley',         2015, 1),
('DN0196', 'Underworld: Blood Wars',                       'Kate Beckinsale',      2016, 1),
('DN095',  'Mothers Day',                                  'Jennifer Aniston',     2016, 5),
('DN0140', 'John Wick',                                    'Keanu Reeves',         2014, 1),
('DN073',  'The Dark Knight',                              'Christian Bale',       2008, 9),
('DN0187', 'Silence',                                      'Andrew Garfield',      2016, 2),
('DN0186', 'Don t Breathe',                                'Stephen Lang',         2016, 6),
('DN0200', 'Me Before You',                                'Emilia Clarke',        2016, 7),
('DN046',  'Their Finest',                                 'Gemma Arterton',       2016, 5),
('DN090',  'Sully',                                        'Tom Hanks',            2016, 4),
('DN0142', 'Batman v Superman: Dawn of Justice',           'Ben Affleck',          2016, 9),
('DN092',  'The Autopsy of Jane Doe',                      'Brian Cox',            2016, 8),
('DN0155', 'The Girl on the Train',                        'Emily Blunt',          2016, 6),
('DN0150', 'Fifty Shades of Grey',                         'Dakota Johnson',       2015, 7),
('DN001',  'The Prestige',                                 'Christian Bale',       2006, 7),
('DN0103', 'Kingsman: The Secret Service',                 'Colin Firth',          2014, 1),
('DN078',  'Patriots Day',                                 'Mark Wahlberg',        2016, 7),
('DN068',  'Mad Max: Fury Road',                           'Tom Hardy',            2015, 1),
('DN0192', 'Wakefield',                                    'Bryan Cranston',       2016, 7),
('DN042',  'Deepwater Horizon',                            'Mark Wahlberg',        2016, 1),
('DN049',  'The Promise',                                  'Oscar Isaac',          2016, 7),
('DN0111', 'Allied',                                       'Brad Pitt',            2016, 1),
('DN0144', 'A Monster Calls',                              'Lewis MacDougall',     2016, 7),
('DN0112', 'Collateral Beauty',                            'Will Smith',           2016, 7),
('DN006',  'Zootopia',                                     'Ginnifer Goodwin',     2016, 3),
('DN060',  'Pirates of the Caribbean: At World s End',     'Johnny Depp',          2007, 1),
('DN0116', 'The Avengers',                                 'Robert Downey Jr.',    2012, 9),
('DN0128', 'Inglourious Basterds',                         'Brad Pitt',            2009, 2),
('DN0194', 'Pirates of the Caribbean: Dead Man s Chest',   'Johnny Depp',          2006, 1),
('DN0181', 'Ghostbusters',                                 'Melissa McCarthy',     2016, 1),
('DN0118', 'Inception',                                    'Leonardo DiCaprio',    2010, 1),
('DN014',  'Captain Fantastic',                            'Viggo Mortensen',      2016, 5),
('DN0175', 'The Wolf of Wall Street',                      'Leonardo DiCaprio',    2013, 4),
('DN061',  'Gone Girl',                                    'Ben Affleck',          2014, 6),
('DN053',  'Furious Seven',                                'Vin Diesel',           2015, 1),
('DN065',  'Jurassic World',                               'Chris Pratt',          2015, 1),
('DN0164', 'Live by Night',                                'Ben Affleck',          2016, 6),
('DN0115', 'Avatar',                                       'Sam Worthington',      2009, 1),
('DN0143', 'The Hateful Eight',                            'Samuel L. Jackson',    2015, 6),
('DN041',  'The Accountant',                               'Ben Affleck',          2016, 1),
('DN0101', 'Prisoners',                                    'Hugh Jackman',         2013, 6),
('DN0138', 'Warcraft',                                     'Travis Fimmel',        2016, 1),
('DN0141', 'The Help',                                     'Emma Stone',           2011, 7),
('DN0197', 'War Dogs',                                     'Jonah Hill',           2016, 5),
('DN0179', 'Avengers: Age of Ultron',                      'Robert Downey Jr.',    2015, 9),
('DN0120', 'The Nice Guys',                                'Russell Crowe',        2016, 1),
('DN0198', 'Kimi no na wa',                                'Ryunosuke Kamiki',     2016, 3),
('DN038',  'The Void',                                     'Aaron Poole',          2016, 8),
('DN051',  'Personal Shopper',                             'Kristen Stewart',      2016, 7);


INSERT INTO Copy (dvdId, shelfPosition, dvdStatus) VALUES
('DN050',  'SH-A1',  'available'),
('DN0135', 'SH-A2',  'available'),
('DN0171', 'SH-B1',  'on loan'),
('DN0102', 'SH-B2',  'available'),
('DN0188', 'SH-C1',  'on loan'),
('DN025',  'SH-C2',  'available'),
('DN0157', 'SH-D1',  'on loan'),
('DN0177', 'SH-D2',  'available'),
('DN0129', 'SH-E1',  'overdue'),
('DN0114', 'SH-E2',  'available'),
('DN085',  'SH-F1',  'available'),
('DN083',  'SH-F2',  'on loan'),
('DN039',  'SH-G1',  'available'),
('DN0117', 'SH-G2',  'available'),
('DN0183', 'SH-H1',  'on loan'),
('DN0140', 'SH-H2',  'on loan'),
('DN087',  'SH-I1',  'available'),
('DN073',  'SH-I2',  'on loan');


INSERT INTO Loan (borrowerId, loanDate) VALUES
(1, '2026-03-01'),
(2, '2026-03-05'),
(3, '2026-03-10'),
(5, '2026-03-12'),
(7, '2026-03-14'),
(8, '2026-03-15'),
(1, '2026-03-18'),
(3, '2026-03-19');


INSERT INTO Loan_Category (loanId, copyId, returnDueDate) VALUES
(1, 3,  '2026-03-04'),
(1, 5,  '2026-03-02'),
(2, 7,  '2026-03-08'),
(2, 12, '2026-03-12'),
(3, 9,  '2026-03-13'),

(4, 15, '2026-03-15'),
(4, 16, '2026-03-15'),
(5, 18, '2026-03-15'),
(6, 1,  '2026-03-22'),
(7, 6,  '2026-03-21'),
(7, 11, '2026-03-25'),
(8, 13, '2026-03-26');
```

---

### Verifying Data:

- Rental_Category table

```sql
SELECT * FROM Rental_Category;
```

![Rental_Category Table](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/rental_category.png)



- Borrower table

```sql
SELECT * FROM Rental_Category;
```

![Borrower Table](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/borrower.png)



- DVD table

```sql
SELECT * FROM DVD;
```

![DVD Table Part 1](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/dvd_p1.png)

![DVD Table Part 2](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/dvd_p2.png)

![DVD Table Part 3](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/dvd_p3.png)



- Copy table

```sql
SELECT * FROM Copy;
```

![Copy Table](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/copy.png)



- Loan table

```sql
SELECT * FROM Loan;
```

![Loan Table](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/loan.png)





- Loan_Category table (junction table)

```sql
SELECT * FROM Loan_Category;
```

![Loan_Category Table](https://raw.githubusercontent.com/d4vrn/IY455/main/assets/images/loan_category.png)

The `Loan_Category` table is a junction table, also known as a bridge or associative table. It exists to resolve the many-to-many relationship between `Loan` and `Copy` — a single loan can include multiple DVD copies, and a single copy can appear across many loans over time. Rather than storing a surrogate ID, `Loan_Category` uses a composite primary key made up of `loanId` and `copyId` together, as the same copy cannot appear on the same loan twice. This design is a direct result of the normalisation process and ensures referential integrity is maintained across the database (Connolly and Begg, 2014).

---

### Reference List:

Connolly, T. and Begg, C. (2014) *Database Systems: A Practical Approach to Design, Implementation and Management*. 6th edn. Harlow: Pearson Education.
