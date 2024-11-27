CREATE DATABASE IF NOT EXISTS Retail_Store;
USE Retail_Store;

CREATE TABLE Employees (
  EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
  FName VARCHAR(40),
  LName VARCHAR(40),
  Address VARCHAR(120),
  Phone VARCHAR(15),
  Email VARCHAR(50),
  Position VARCHAR(15),
  Hourly_Pay FLOAT DEFAULT 7.25
);


CREATE TABLE Suppliers (
  SupplierID INT PRIMARY KEY AUTO_INCREMENT,
  Name VARCHAR(40),
  Address VARCHAR(120),
  Phone VARCHAR(15),
  Email VARCHAR(50)
);


CREATE TABLE Products (
  ProductID INT PRIMARY KEY AUTO_INCREMENT,
  SupplierID INT,
  Name VARCHAR(40),
  Price FLOAT DEFAULT 0.0,
  Stock INT DEFAULT 0,
  Description VARCHAR(120),
  FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID) ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE Transactions (
  TransactionID INT PRIMARY KEY AUTO_INCREMENT,
  EmployeeID INT,
  Date DATETIME,
  Payment_Method VARCHAR(40) DEFAULT 'Cash',
  Total_Price FLOAT DEFAULT 0.0,
  FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE Sells (
  TransactionID INT,
  ProductID INT,
  Quantity INT,
  PRIMARY KEY (TransactionID, ProductID),
  FOREIGN KEY (TransactionID) REFERENCES Transactions(TransactionID) ON DELETE CASCADE,
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);


CREATE TABLE Provided_By (
  SupplierID INT,
  ProductID INT,
  Quantity_Provided INT,
  PRIMARY KEY (SupplierID, ProductID),
  FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID) ON DELETE CASCADE,
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);


DELIMITER //

CREATE TRIGGER UpdateStockSELL
AFTER INSERT ON Sells
FOR EACH ROW
BEGIN
    UPDATE Products
    SET Stock = Stock - NEW.Quantity
    WHERE ProductID = NEW.ProductID;
END//

CREATE TRIGGER UpdateStockIMPORT
AFTER INSERT ON Provided_By
FOR EACH ROW
BEGIN
    UPDATE Products
    SET Stock = Stock + NEW.Quantity_Provided
    WHERE ProductID = NEW.ProductID;
END//

DELIMITER ;