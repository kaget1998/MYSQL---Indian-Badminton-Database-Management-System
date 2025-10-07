Create database IndianBadminton;
use IndianBadminton;
#Table 1: Players
CREATE TABLE Players (PlayerID INT PRIMARY KEY, Name VARCHAR(255) NOT NULL, DateOfBirth DATE, 
Gender ENUM('M', 'F'), 
State VARCHAR(50),
Status VARCHAR(50),Remarks TEXT);

#Table 2: Rankings
CREATE TABLE Rankings (RankingID INT PRIMARY KEY AUTO_INCREMENT, 
PlayerID INT, Ranks INT, RankingDate DATE,Category VARCHAR(50),
RankingPoints INT,GrandTotal INT,
FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID));

#Table 3: Tournaments
CREATE TABLE Tournaments (TournamentID INT PRIMARY KEY AUTO_INCREMENT,
TournamentTitle VARCHAR(255) NOT NULL,TournamentType VARCHAR(50),
StartDate DATE,EndDate DATE,Location VARCHAR(100));

INSERT INTO Players(PlayerID, Name, DateOfBirth, Gender, State, Status, Remarks) VALUES
(10001, 'Priya Singh', '2002-05-15', 'F', 'MH', 'Active', 'Promising junior player'),
(10002, 'Rahul Sharma', '1998-11-20', 'M', 'DL', 'Active', 'National circuit regular'),
(10003, 'Sneha Devi', '2004-02-01', 'F', 'UP', 'Active', 'Upcoming doubles specialist'),
(10004, 'Amit Verma', '1996-08-10', 'M', 'RJ', 'Inactive', 'On break due to injury'),
(10005, 'Deepika Rao', '2001-09-28', 'F', 'TN', 'Active', 'Top 10 in senior women''s singles'),
(10006, 'Arjun Reddy', '1999-07-03', 'M', 'TS', 'Active', 'Strong backhand'),
(10007, 'Shreya Patel', '2003-01-22', 'F', 'GJ', 'Active', 'Good net play'),
(10008, 'Vikram Singh', '1997-04-05', 'M', 'PB', 'Renewal Pending', 'Needs medical clearance'),
(10009, 'Pooja Agarwal', '2000-12-18', 'F', 'WB', 'Active', 'Consistent performance in state events'),
(10010, 'Sameer Khan', '1995-06-11', 'M', 'HR', 'Inactive', 'Focusing on coaching');

INSERT INTO Rankings (PlayerID, Ranks, RankingDate, Category, RankingPoints, GrandTotal) VALUES
(10001, 7, '2025-07-23', 'Junior Womens Singles', 1250, 1300),
(10002, 15, '2025-07-23', 'Senior Mens Singles', 1100, 1150),
(10003, 9, '2025-07-23', 'Junior Womens Doubles', 980, 1020),
(10004, 30, '2025-07-23', 'Senior Mens Singles', 700, 750),
(10005, 4, '2025-07-23', 'Senior Womens Singles', 1800, 1850),
(10006, 8, '2025-07-23', 'Senior Mens Singles', 1450, 1500),
(10007, 6, '2025-07-23', 'Junior Womens Singles', 1300, 1350),
(10008, 25, '2025-07-23', 'Senior Mens Singles', 850, 900),
(10009, 11, '2025-07-23', 'Senior Womens Doubles', 1050, 1100),
(10001, 3, '2025-07-23', 'Senior Womens Singles', 1900, 1950);

INSERT INTO Tournaments (TournamentTitle, TournamentType, StartDate, EndDate, Location) VALUES
('All India Junior Ranking Tournament - Pune 2025', 'Ranking', '2025-09-01', '2025-09-06', 'Pune, Maharashtra'),
('Yonex Sunrise Senior Nationals 2025', 'National', '2025-11-10', '2025-11-16', 'Bengaluru, Karnataka'),
('North Zone Inter-State Championship 2025', 'Zonal', '2025-08-15', '2025-08-18', 'Chandigarh'),
('South India Challenge 2025', 'Regional', '2025-10-05', '2025-10-09', 'Chennai, Tamil Nadu'),
('Sub-Junior (U-13) Open Championship - Delhi', 'Junior', '2026-01-20', '2026-01-24', 'New Delhi, Delhi'),
('West Zone Badminton Open 2025', 'Regional', '2025-11-20', '2025-11-24', 'Ahmedabad, Gujarat'),
('All India Senior Ranking Tournament - Kochi', 'Ranking', '2026-02-10', '2026-02-15', 'Kochi, Kerala'),
('National School Games Badminton - Indore', 'School Level', '2026-03-05', '2026-03-09', 'Indore, Madhya Pradesh'),
('Hyderabad Badminton League 2025', 'League', '2025-12-01', '2025-12-07', 'Hyderabad, Telangana'),
('Junior National Championships - Lucknow', 'National', '2026-04-18', '2026-04-23', 'Lucknow, Uttar Pradesh');

select * from Players;
select * from Rankings;
select * from Tournaments;

.................................................START QUERIES ANALYASIS...................................................................

#Find the names and states of all active players analysis
SELECT Name, State FROM Players WHERE Status = 'Active';

#List all tournaments scheduled to start after today
SELECT TournamentTitle, StartDate from Tournaments WHERE StartDate > CURDate();

#Count the number of active players from each state:
SELECT State, COUNT(PlayerID) AS NumberOfActivePlayers
FROM Players
WHERE Status = 'Active'
GROUP BY State;

#Find the player with the highest ranking points in the 'Senior Women's Singles' category:
SELECT P.Name, R.RankingPoints
FROM Players P
JOIN Rankings R ON P.PlayerID = R.PlayerID
WHERE R.Category = 'Senior Womens Singles'
ORDER BY R.RankingPoints DESC
LIMIT 1;

#Count the number of Inactive players from each state
SELECT State, COUNT(PlayerID) AS TotalInactivePlayers
FROM Players
WHERE Status = 'Inactive'
GROUP BY State;

#Get the number of tournaments scheduled for each month
SELECT MONTH(StartDate) AS Month, YEAR(StartDate) AS Year, COUNT(TournamentID) AS NumberOfTournaments
FROM Tournaments
GROUP BY YEAR(StartDate), MONTH(StartDate)
ORDER BY YEAR(StartDate), MONTH(StartDate);

#List all players and their current ranks
SELECT P.Name, R.Ranks, R.Category
FROM Players P
LEFT JOIN Rankings R ON P.PlayerID = R.PlayerID;

#Create a view to display active player rankings
CREATE VIEW ActivePlayerRankings AS
SELECT P.Name, P.State, R.Ranks, R.Category, R.RankingPoints
FROM Players P
JOIN Rankings R ON P.PlayerID = R.PlayerID
WHERE P.Status = 'Active';
select * from ActivePlayerRankings;

#List players who are active and have a rank within the Top 10 for any category:
SELECT P.Name, P.State, R.Ranks, R.Category
FROM Players P
JOIN Rankings R ON P.PlayerID = R.PlayerID
WHERE P.Status = 'Active' AND R.Ranks<= 10
ORDER BY R.Category, R.Ranks;

#Find the top 5 players based on their GrandTotal ranking points in 'Senior Women's Singles' category:
select P.Name, R.GrandTotal from Players P
Join Rankings R on P.PlayerID=R.PlayerID where R.Category='Senior Womens Singles'
order by GrandTotal desc limit 5;

#Find the total number of tournaments happening in each location and sort by the number of tournaments:
SELECT Location, COUNT(TournamentID) AS TournamentCount
FROM Tournaments
GROUP BY Location
ORDER BY TournamentCount DESC;

#Count the number of tournaments each year
SELECT YEAR(StartDate) as TYear , COUNT(TournamentID) as CountofT from Tournaments
group by TYear order by TYear;

#List all tournaments scheduled to take place in Mumbai in the next 6 months
select TournamentTitle , StartDate , EndDate from Tournaments
where Location like '%Mumbai , Maharashtra%' and StartDate between curdate() and date_add(curdate() , interval 6 month)
order by StartDate;

#List all active female players along with their current age
SELECT Name, DateOfBirth, TIMESTAMPDIFF(YEAR, DateOfBirth, CURDATE()) AS Age
FROM Players
WHERE Gender = 'F' AND Status = 'Active';