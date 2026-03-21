CREATE DATABASE IF NOT EXISTS dvd_loan;
USE dvd_loan;

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




