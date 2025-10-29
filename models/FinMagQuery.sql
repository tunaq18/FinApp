--File create FinManage Database 

CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    password_hash NVARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE Categories (
	category_id INT IDENTITY(1,1) PRIMARY KEY,
	name NVARCHAR(100) NOT NULL,
	type NVARCHAR(40) NOT NULL CHECK (type IN ('income','expense')),
	user_id INT NOT NULL,
	FOREIGN KEY (user_id) REFERENCES Users(user_id)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE  Transactions (
	transaction_id INT IDENTITY(1,1) PRIMARY KEY,
	user_id INT NOT NULL,
	category_id INT NOT NULL,
	amount DECIMAL(15,2) CHECK (amount >=0),
	note NVARCHAR(MAX),
	[date] DATE NOT NULL ,
	type NVARCHAR(40) CHECK(type IN ('income','expense')),
	FOREIGN KEY (user_id) REFERENCES Users(user_id),
	FOREIGN KEY (category_id) REFERENCES Categories(category_id)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Budgets(
	budgets_id INT IDENTITY(1,1) PRIMARY KEY,
	user_id INT NOT NULL,
	category_id INT NOT NULL,
	limit_amount DECIMAL(15,2) CHECK(limit_amount >=0),
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	FOREIGN KEY (user_id) REFERENCES Users(user_id)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (category_id) REFERENCES Categories(category_id)

);

CREATE TABLE Goals(
	goal_id INT IDENTITY(1,1) PRIMARY KEY,
	user_id INT NOT NULL,
	name NVARCHAR(100) NOT NULL,
	target_amount DECIMAL(15,2) CHECK (target_amount >=0),
	current_amount DECIMAL(15,2) DEFAULT 0,
	deadline DATE NOT NULL,
	FOREIGN KEY (user_id) REFERENCES Users(user_id)
		ON DELETE CASCADE ON UPDATE CASCADE
);
