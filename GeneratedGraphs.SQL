/*
Created: 05.05.2026
Modified: 05.05.2026
Model: Microsoft SQL Server 2019
Database: MS SQL Server 2019
*/


-- Create tables section -------------------------------------------------

-- Table Users

Use master
go

drop database if exists Messangers
go

create database Messangers
go

Use Messangers
go 

CREATE TABLE [Users]
(
 [UserID] Int NOT NULL,
 [UserName] Nvarchar(100) NOT NULL,
 [RegisteredDate] Date NOT NULL
)
AS NODE
go

-- Add keys for table Users

ALTER TABLE [Users] ADD CONSTRAINT [PK_Users] PRIMARY KEY ([UserID])
go

-- Table Chats

CREATE TABLE [Chats]
(
 [ChatID] Int NOT NULL,
 [ChatName] Nvarchar(200) NOT NULL,
 [CreatedDate] Datetime2 NOT NULL
)
AS NODE
go

-- Add keys for table Chats

ALTER TABLE [Chats] ADD CONSTRAINT [PK_Chats] PRIMARY KEY ([ChatID])
go

-- Table Messages

CREATE TABLE [Messages]
(
 [MessageID] Int NOT NULL,
 [Text] Nvarchar(max) NOT NULL,
 [SentDate] Datetime2 NOT NULL
)
AS NODE
go

-- Add keys for table Messages

ALTER TABLE [Messages] ADD CONSTRAINT [PK_Messages] PRIMARY KEY ([MessageID])
go

-- Table MemberOf

CREATE TABLE [MemberOf]
(
 [JoinedDate] Datetime2 NOT NULL,
 [Role] Nvarchar(20) NOT NULL
)
AS EDGE
go

-- Add connection constraints for table MemberOf

ALTER TABLE [MemberOf] ADD CONSTRAINT [EC_Users_Chats] CONNECTION (
  [Users] TO [Chats])
go

-- Table Sent

CREATE TABLE [Sent]
(
 [UserDevice] Nvarchar(50) NOT NULL,
 [IsAnonimyzed] Bit NOT NULL
)
AS EDGE
go

-- Add connection constraints for table Sent

ALTER TABLE [Sent] ADD CONSTRAINT [EC_Users_Messages] CONNECTION (
  [Users] TO [Messages])
go

-- Table Includes

CREATE TABLE [Includes]
(
 [IsPinned] Bit NOT NULL,
 [DeliveryTime] Datetime2 NOT NULL
)
AS EDGE
go

-- Add connection constraints for table Includes

ALTER TABLE [Includes] ADD CONSTRAINT [EC_Chats_Messages] CONNECTION (
  [Chats] TO [Messages])
go


-- Заполнение Пользователей (Узлы)
INSERT INTO [Users] ([UserID], [UserName], [RegisteredDate]) VALUES
(1, 'Иван_Иванов', '2026-01-10'), (2, 'Мария_Петрова', '2026-01-12'),
(3, 'Алексей_Смирнов', '2026-02-01'), (4, 'Дмитрий_Соколов', '2026-02-15'),
(5, 'Елена_Козлова', '2026-03-01'), (6, 'Сергей_Морозов', '2026-03-05'),
(7, 'Анна_Волкова', '2026-03-10'), (8, 'Павел_Лебедев', '2026-04-01'),
(9, 'Ольга_Новикова', '2026-04-12'), (10, 'Игорь_Федоров', '2026-05-01');

-- Заполнение Чатов (Узлы)
INSERT INTO [Chats] ([ChatID], [ChatName], [CreatedDate]) VALUES
(1, 'Новости Университета', '2026-01-01 10:00:00'), (2, 'Лабораторная Группа 01', '2026-02-01 12:00:00'),
(3, 'Подготовка к Экзамену', '2026-05-01 09:00:00'), (4, 'Курилка / Флуд', '2026-01-15 15:30:00'),
(5, 'Любители SQL', '2026-03-10 11:00:00'), (6, 'Игровой чат', '2026-04-20 20:00:00'),
(7, 'Техподдержка вуза', '2026-01-05 08:00:00'), (8, 'Проектная команда X', '2026-04-15 14:00:00'),
(9, 'Объявления старост', '2026-01-01 00:00:00'), (10, 'Хобби и спорт', '2026-02-28 18:45:00');

-- Заполнение Сообщений (Узлы)
INSERT INTO [Messages] ([MessageID], [Text], [SentDate]) VALUES
(1, 'Всем привет! Кто сделал лабу?', '2026-05-05 10:01:00'), 
(2, 'Скиньте расписание на завтра, плиз', '2026-05-05 10:05:00'),
(3, 'Я нашел ошибку в схеме базы данных', '2026-05-05 11:00:00'), 
(4, 'Графовые БД — это не так сложно', '2026-05-05 12:30:00'),
(5, 'Дедлайн уже завтра, поторопитесь!', '2026-05-05 14:00:00'), 
(6, 'Кто пойдет в столовую после пары?', '2026-05-05 15:00:00'),
(7, 'Встречаемся в дискорде вечером', '2026-05-05 16:20:00'), 
(8, 'Спокойной ночи, завтра будет тяжко', '2026-05-05 23:00:00'),
(9, 'Посмотрите эту ссылку на документацию', '2026-05-06 09:00:00'), 
(10, 'Собрание команды в 17:00', '2026-05-06 10:00:00');


INSERT INTO [MemberOf] ($from_id, $to_id, [JoinedDate], [Role]) VALUES 
( (SELECT $node_id FROM [Users] WHERE [UserID] = 1), (SELECT $node_id FROM [Chats] WHERE [ChatID] = 1), '2026-01-10', 'Админ' ),
( (SELECT $node_id FROM [Users] WHERE [UserID] = 2), (SELECT $node_id FROM [Chats] WHERE [ChatID] = 1), '2026-01-12', 'Участник' ),
( (SELECT $node_id FROM [Users] WHERE [UserID] = 3), (SELECT $node_id FROM [Chats] WHERE [ChatID] = 2), '2026-02-01', 'Староста' ),
( (SELECT $node_id FROM [Users] WHERE [UserID] = 4), (SELECT $node_id FROM [Chats] WHERE [ChatID] = 5), '2026-03-15', 'Модератор' );


INSERT INTO [Sent] ($from_id, $to_id, [UserDevice], [IsAnonimyzed]) VALUES 
( (SELECT $node_id FROM [Users] WHERE [UserID] = 1), (SELECT $node_id FROM [Messages] WHERE [MessageID] = 1), 'ПК (Windows)', 0 ),
( (SELECT $node_id FROM [Users] WHERE [UserID] = 2), (SELECT $node_id FROM [Messages] WHERE [MessageID] = 2), 'iPhone', 0 ),
( (SELECT $node_id FROM [Users] WHERE [UserID] = 3), (SELECT $node_id FROM [Messages] WHERE [MessageID] = 3), 'Android', 1 ),
( (SELECT $node_id FROM [Users] WHERE [UserID] = 5), (SELECT $node_id FROM [Messages] WHERE [MessageID] = 4), 'Веб-браузер', 0 );


INSERT INTO [Includes] ($from_id, $to_id, [IsPinned], [DeliveryTime]) VALUES 
( (SELECT $node_id FROM [Chats] WHERE [ChatID] = 1), (SELECT $node_id FROM [Messages] WHERE [MessageID] = 1), 0, '2026-05-05 10:01:05' ),
( (SELECT $node_id FROM [Chats] WHERE [ChatID] = 2), (SELECT $node_id FROM [Messages] WHERE [MessageID] = 3), 1, '2026-05-05 11:00:10' ),
( (SELECT $node_id FROM [Chats] WHERE [ChatID] = 5), (SELECT $node_id FROM [Messages] WHERE [MessageID] = 4), 0, '2026-05-05 12:30:15' );


SELECT 
    U.UserName AS [Отправитель], 
    M.Text AS [Текст сообщения], 
    C.ChatName AS [Название чата]
FROM Users U, Sent S, Messages M, Includes I, Chats C
WHERE MATCH(U-(S)->M AND C-(I)->M)
  AND C.ChatName = N'Новости Университета';


  SELECT DISTINCT 
    U.UserName AS [Активный участник], 
    C.ChatName AS [Чат]
FROM Users U, MemberOf MO, Chats C, Includes I, Messages M, Sent S
WHERE MATCH(U-(MO)->C AND C-(I)->M AND U-(S)->M);


SELECT 
    C.ChatName AS [Где закреплено], 
    M.Text AS [Сообщение], 
    U.UserName AS [Автор]
FROM Chats C, Includes I, Messages M, Sent S, Users U
WHERE MATCH(C-(I)->M AND U-(S)->M)
  AND I.IsPinned = 1;


  SELECT 
    U.UserName, 
    M.Text, 
    S.UserDevice
FROM Users U, Sent S, Messages M, Includes I, Chats C
WHERE MATCH(U-(S)->M AND C-(I)->M)
  AND S.UserDevice = N'Android';


  SELECT 
    C.ChatName AS [Чат с анонимом], 
    M.Text AS [Анонимное сообщение],
    U.UserName AS [Скрытый логин]
FROM Users U, Sent S, Messages M, Includes I, Chats C
WHERE MATCH(U-(S)->M AND C-(I)->M)
  AND S.IsAnonimyzed = 1;





SELECT 
    U.UserName AS [Начало пути],
    (M.Text + ' -> ' + C.ChatName) AS [Весь путь],
    N'2 шага' AS [Длина пути]
FROM Users U, Sent S, Messages M, Includes I, Chats C
WHERE MATCH(U-(S)->M AND C-(I)->M)
  AND U.UserName = N'Иван_Иванов';



 SELECT 
    U.UserName AS [Автор],
    M.Text AS [Текст сообщения],
    N'1 шаг' AS [Длина пути]
FROM Users AS U, Sent AS S, Messages AS M
WHERE MATCH(U-(S)->M)
  AND M.MessageID = 3;