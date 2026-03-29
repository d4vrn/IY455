USE dvd_loan;

-- Output all borrowers who have current rentals and order them by surname.

    -- order by will probably be with join and ASC (ascending) borrowerLastName also.
        -- I think I need to check Loan_Line table actualReturnDate.

    SELECT * FROM Borrower JOIN dvd_loan.Loan L ON Borrower.borrowerId = L.borrowerId
        JOIN dvd_loan.Loan_Line LL ON L.loanId = LL.loanId WHERE LL.actualReturnDate IS NULL ORDER BY borrowerLastName ASC;


    SELECT DISTINCT borrowerFirstName, borrowerLastName, borrowerAddress, borrowerStatus, actualReturnDate
    FROM Borrower JOIN Loan L ON Borrower.borrowerId = L.borrowerId
    JOIN Loan_Line LL ON L.loanId = LL.loanId
    WHERE LL.actualReturnDate IS NULL ORDER BY borrowerLastName ASC;


    SELECT borrowerFirstName, borrowerLastName, borrowerAddress, borrowerStatus, loanDate, actualReturnDate
    FROM Borrower JOIN Loan L ON Borrower.borrowerId = L.borrowerId
    JOIN Loan_Line LL ON L.loanId = LL.loanId
    WHERE LL.actualReturnDate IS NULL ORDER BY borrowerLastName ASC;


-- Create a list that shows all borrowers who have over-due loans and rank them highest to lowest.

    -- okay, I will output only useful columns of borrower, like surname, name, address and status.
    -- the confusing part is with highest to lowest. is it by number of overdue loans or by days of it.

    SELECT *
    FROM Borrower AS B JOIN Loan L ON B.borrowerId = L.borrowerId
    JOIN Loan_Line AS LL ON L.loanId = LL.loanId
    JOIN Copy C ON LL.copyId = C.copyId WHERE dvdStatus = 'overdue';

#     SELECT borrowerFirstName, borrowerLastName, borrowerAddress, borrowerStatus, returnDueDate, current_date
#     , COUNT(DAY(CURRENT_DATE-returnDueDate)) AS daysOverdue
#     FROM Borrower AS B JOIN Loan L ON B.borrowerId = L.borrowerId
#     JOIN Loan_Line AS LL ON L.loanId = LL.loanId WHERE actualReturnDate IS NULL
#     AND CURRENT_DATE > returnDueDate;

    SELECT borrowerFirstName, borrowerLastName, borrowerAddress, borrowerStatus, returnDueDate, current_date
    , DATEDIFF(current_date, returnDueDate) AS daysOverdue
    FROM Borrower AS B JOIN Loan L ON B.borrowerId = L.borrowerId
    JOIN Loan_Line AS LL ON L.loanId = LL.loanId WHERE actualReturnDate IS NULL
    AND CURRENT_DATE > returnDueDate;

    # Highest to lowest by the number of loans
    SELECT borrowerFirstName, borrowerLastName, borrowerAddress, COUNT(*) AS overDueLoans
    FROM Borrower AS B JOIN Loan L ON B.borrowerId = L.borrowerId
    JOIN Loan_Line AS LL ON L.loanId = LL.loanId WHERE actualReturnDate IS NULL
    AND CURRENT_DATE > returnDueDate GROUP BY B.borrowerId, borrowerFirstName, borrowerLastName, borrowerAddress
    ORDER BY COUNT(*) DESC;

    # Highest to lowest by the number of days (each loan having different time borrowers may appear more than once)
    SELECT borrowerFirstName, borrowerLastName, borrowerAddress, borrowerAddress,
    returnDueDate, current_date, DATEDIFF(current_date, returnDueDate) AS daysOverdue
    FROM Borrower AS B JOIN Loan L ON B.borrowerId = L.borrowerId
    JOIN Loan_Line AS LL ON L.loanId = LL.loanId WHERE actualReturnDate IS NULL
    AND CURRENT_DATE > returnDueDate ORDER BY daysOverdue DESC;


-- Display the borrower details and DVDs for all borrowers who have rented comedy movies in the last 4 weeks.


    SELECT borrowerFirstName, borrowerLastName, borrowerAddress, dvdTitle,
    dvdYear, starringActor, categoryName
    FROM Borrower B JOIN Loan L ON B.borrowerId = L.borrowerId
    JOIN Loan_Line LL ON L.loanId = LL.loanId
    JOIN Copy C ON  LL.copyId = C.copyId
    JOIN DVD D ON C.dvdId = D.dvdId JOIN Rental_Category RC
    ON D.categoryId = RC.categoryId WHERE categoryName = 'Comedy'
    AND L.loanDate >= DATE_SUB(CURDATE(), INTERVAL 4 WEEK);


-- Find the borrower who has accumulated the most over-due finds, calculate the total in fines and display their details.

    -- I am not sure about part with whether it includes late but returned fine or not returned loans.
    -- And I also thought about whether I should calculate the total fines paid.

    SELECT borrowerFirstName, borrowerLastName, borrowerAddress,
    fineChargeRate * DATEDIFF(IFNULL(actualReturnDate, CURDATE()), returnDueDate)
    totalFine FROM Borrower B JOIN Loan L ON B.borrowerId = L.borrowerId
    JOIN Loan_Line LL ON L.loanId = LL.loanId
    JOIN Copy C ON  LL.copyId = C.copyId
    JOIN DVD D ON C.dvdId = D.dvdId JOIN Rental_Category RC
    ON D.categoryId = RC.categoryId
    WHERE (actualReturnDate IS NOT NULL AND actualReturnDate > returnDueDate)
    OR (actualReturnDate IS NULL AND returnDueDate < CURDATE())
    ORDER BY totalFine DESC;


    SELECT borrowerFirstName, borrowerLastName, borrowerAddress,
    SUM(fineChargeRate * DATEDIFF(actualReturnDate, returnDueDate))
    totalFine FROM Borrower B JOIN Loan L ON B.borrowerId = L.borrowerId
    JOIN Loan_Line LL ON L.loanId = LL.loanId
    JOIN Copy C ON  LL.copyId = C.copyId
    JOIN DVD D ON C.dvdId = D.dvdId JOIN Rental_Category RC
    ON D.categoryId = RC.categoryId
    WHERE actualReturnDate IS NOT NULL AND actualReturnDate > returnDueDate
    GROUP BY borrowerFirstName, borrowerLastName, borrowerAddress
    ORDER BY totalFine DESC LIMIT 1;

-- Update the cost for rentals where the release date is >=2015 to £5.50 and the movie category is superhero.

    SELECT categoryName, rentalCost, dvdTitle, dvdYear
    FROM Rental_Category RC
    JOIN DVD D ON RC.categoryId = D.categoryId
    WHERE categoryName = 'Superhero' AND dvdYear >= 2015;

    UPDATE Rental_Category RC
    JOIN DVD D ON RC.categoryId = D.categoryId
    SET rentalCost = 5.50
    WHERE dvdYear >= 2015 AND categoryName = 'Superhero';

    SELECT categoryName, rentalCost, dvdTitle, dvdYear
    FROM Rental_Category RC
    JOIN DVD D ON RC.categoryId = D.categoryId
    WHERE categoryName = 'Superhero' AND dvdYear >= 2015;


-- Remove DVD movies from the system where there are no loans registered for the movie.

    SELECT dvdTitle, starringActor, dvdYear FROM DVD
    WHERE dvdId NOT IN (
    SELECT DISTINCT D.dvdId FROM DVD D
    JOIN Copy C ON D.dvdId = C.dvdId
    JOIN Loan_Line LL ON C.copyId = LL.copyId);

    DELETE C FROM Copy C
    LEFT JOIN Loan_Line LL ON C.copyId = LL.copyId
    WHERE LL.copyId IS NULL;

    DELETE FROM DVD
    WHERE NOT EXISTS (
        SELECT 1 FROM Copy
        WHERE Copy.dvdId = DVD.dvdId
    );

    SELECT * FROM DVD;
