--------------------------------------------------------------------------------------------
-- SCRIPT DE CRIAÇÃO DO BANCO DE DADOS - PROJETO: MUK - Cuidados com Plantas
-- AMBIENTE: SQL SERVER
--------------------------------------------------------------------------------------------

-- 1. CRIAÇÃO E SELEÇÃO DO BANCO DE DADOS (Usando colchetes para permitir hífens e espaços)
USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'MUK - Cuidados com Plantas')
BEGIN
    ALTER DATABASE [MUK - Cuidados com Plantas] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [MUK - Cuidados com Plantas];
END
GO

CREATE DATABASE [MUK - Cuidados com Plantas];
GO

USE [MUK - Cuidados com Plantas];
GO

------------------------------------------------------------------------------------------------
-- 2. CRIAÇÃO DAS TABELAS (DDL)
------------------------------------------------------------------------------------------------

-- Tabela de Usuários/Dona(o) das plantas
CREATE TABLE Usuarios (
    id_usuario INT IDENTITY(1,1),
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    data_cadastro DATETIME DEFAULT GETDATE(),
    CONSTRAINT PK_Usuarios PRIMARY KEY (id_usuario)
);

-- Tabela de Espécies de Plantas
CREATE TABLE Especies (
    id_especie INT IDENTITY(1,1),
    nome_comum VARCHAR(100) NOT NULL,
    nome_cientifico VARCHAR(150),
    frequencia_rega_dias INT NOT NULL, 
    exposicao_solar VARCHAR(50),      
    CONSTRAINT PK_Especies PRIMARY KEY (id_especie)
);

-- Tabela das Plantas dos Usuários
CREATE TABLE Plantas (
    id_plantas INT IDENTITY(1,1),
    id_usuario INT NOT NULL,
    id_especie INT NOT NULL,
    apelido VARCHAR(50),
    data_aquisicao DATE,
    localizacao VARCHAR(50), 
    CONSTRAINT PK_Plantas PRIMARY KEY (id_plantas),
    CONSTRAINT FK_Plantas_Usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    CONSTRAINT FK_Plantas_Especies FOREIGN KEY (id_especie) REFERENCES Especies(id_especie)
);

-- Tabela de Histórico de Regas e Cuidados
CREATE TABLE Historico_Cuidados (
    id_cuidado INT IDENTITY(1,1),
    id_plantas INT NOT NULL,
    data_cuidado DATETIME DEFAULT GETDATE(),
    tipo_cuidado VARCHAR(30) DEFAULT 'Rega', 
    observacao VARCHAR(255),
    CONSTRAINT PK_Historico_Cuidados PRIMARY KEY (id_cuidado),
    CONSTRAINT FK_Historico_Historico FOREIGN KEY (id_plantas) REFERENCES Plantas(id_plantas) ON DELETE CASCADE
);

-- Tabela de Log/Auditoria (Alvo do Trigger)
CREATE TABLE Log_Alertas (
    id_log INT IDENTITY(1,1),
    id_plantas INT,
    mensagem VARCHAR(255),
    data_log DATETIME DEFAULT GETDATE(),
    CONSTRAINT PK_Log_Alertas PRIMARY KEY (id_log)
);
GO

-----------------------------------------------------------------------------------------------
-- 3. POPULANDO AS TABELAS (10 INSERTS CADA)
----------------------------------------------------------------------------------------------

-- Carga em: Usuarios
INSERT INTO Usuarios (nome, email) VALUES 
('Giovanna Bitencurte', 'giovanna@mail.com'),
('Carlos Silva', 'carlos@mail.com'),
('Mariana Santos', 'mariana@mail.com'),
('Pedro Oliveira', 'pedro@mail.com'),
('Ana Julia', 'anaju@mail.com'),
('Lucas Almeida', 'lucas@mail.com'),
('Beatriz Costa', 'bia@mail.com'),
('Rodrigo Lima', 'rodrigo@mail.com'),
('Camila Souza', 'camila@mail.com'),
('Gabriel Ribeiro', 'gabriel@mail.com');

-- Carga em: Especies
INSERT INTO Especies (nome_comum, nome_cientifico, frequencia_rega_dias, exposicao_solar) VALUES 
('Suculenta', 'Echeveria elegans', 10, 'Sol Pleno'),
('Espada de São Jorge', 'Sansevieria trifasciata', 15, 'Meia Sombra'),
('Jiboia', 'Epipremnum pinnatum', 4, 'Meia Sombra'),
('Costela de Adão', 'Monstera deliciosa', 5, 'Meia Sombra'),
('Orquídea', 'Phalaenopsis', 7, 'Sombra'),
('Samambaia', 'Nephrolepis exaltata', 2, 'Sombra'),
('Cacto Bola', 'Echinocactus grusonii', 20, 'Sol Pleno'),
('Lírio da Paz', 'Spathiphyllum', 3, 'Sombra'),
('Manjericão', 'Ocimum basilicum', 2, 'Sol Pleno'),
('Alecrim', 'Salvia rosmarinus', 4, 'Sol Pleno');

-- Carga em: Plantas
INSERT INTO Plantas (id_usuario, id_especie, apelido, data_aquisicao, localizacao) VALUES 
(1, 1, 'Verdinha', '2025-01-10', 'Varanda'),
(1, 3, 'Preciosa', '2025-02-15', 'Sala de Estar'),
(2, 2, 'Guerreira', '2024-11-20', 'Corredor'),
(3, 4, 'Monstrinha', '2025-03-01', 'Varanda'),
(4, 6, 'Pluma', '2025-05-12', 'Quintal'),
(5, 5, 'Diva', '2026-01-05', 'Quarto'),
(6, 7, 'Espinho', '2025-08-22', 'Escritório'),
(7, 8, 'Paz', '2026-02-10', 'Sala de Jantar'),
(8, 9, 'Tempero', '2026-04-18', 'Cozinha'),
(9, 10, 'Cheiroso', '2026-05-01', 'Quintal');

-- Carga em: Historico_Cuidados
INSERT INTO Historico_Cuidados (id_plantas, data_cuidado, tipo_cuidado, observacao) VALUES 
(1, '2026-06-01 09:00:00', 'Rega', 'Pouca água conforme manual.'),
(2, '2026-06-08 10:30:00', 'Rega', 'Rega abundante.'),
(3, '2026-05-25 16:00:00', 'Rega', 'Solo estava bem seco.'),
(4, '2026-06-07 08:00:00', 'Rega', 'Adicionado borrifador nas folhas.'),
(5, '2026-06-09 17:00:00', 'Rega', 'Solo úmido.'),
(6, '2026-06-05 11:00:00', 'Adubação', 'Aplicado NPK 10-10-10.'),
(7, '2026-05-20 07:00:00', 'Rega', 'Rega mensal de inverno.'),
(8, '2026-06-09 14:00:00', 'Rega', 'Folhas murchas, precisava de água.'),
(9, '2026-06-09 08:30:00', 'Poda', 'Retirada de folhas secas.'),
(10, '2026-06-08 18:00:00', 'Rega', 'Rega de fim de tarde.');
GO

----------------------------------------------------------------------------------------------------
-- 4. CRIAÇÃO DE USER-DEFINED FUNCTION (UDF)
---------------------------------------------------------------------------------------------------
CREATE FUNCTION dbo.fn_CalcularProximaRega (@id_plantas INT)
RETURNS DATE
AS
BEGIN
    DECLARE @UltimaRega DATE;
    DECLARE @DiasIntervalo INT;
    DECLARE @ProximaRega DATE;

    SELECT TOP 1 @UltimaRega = CAST(data_cuidado AS DATE)
    FROM Historico_Cuidados
    WHERE id_plantas = @id_plantas AND tipo_cuidado = 'Rega'
    ORDER BY data_cuidado DESC;

    IF @UltimaRega IS NULL
    BEGIN
        SELECT @UltimaRega = data_aquisicao FROM Plantas WHERE id_plantas = @id_plantas;
    END

    SELECT @DiasIntervalo = E.frequencia_rega_dias
    FROM Plantas P
    INNER JOIN Especies E ON P.id_especie = E.id_especie
    WHERE P.id_plantas = @id_plantas;

    SET @ProximaRega = DATEADD(day, ISNULL(@DiasIntervalo, 7), @UltimaRega);

    RETURN @ProximaRega;
END;
GO

---------------------------------------------------------------------------------------------------
-- 5. CRIAÇÃO DE VIEW (VISÃO)
----------------------------------------------------------------------------------------------------
CREATE VIEW vw_Status_Plantas AS
SELECT 
    P.id_plantas AS [Código Planta],
    U.nome AS [Dona(o)],
    P.apelido AS [Nome da Planta],
    E.nome_comum AS [Espécie],
    P.localizacao AS [Ambiente],
    ISNULL(CONVERT(VARCHAR, (SELECT MAX(data_cuidado) FROM Historico_Cuidados WHERE id_plantas = P.id_plantas AND tipo_cuidado = 'Rega'), 103), 'Nenhuma') AS [Última Rega],
    CONVERT(VARCHAR, dbo.fn_CalcularProximaRega(P.id_plantas), 103) AS [Próxima Rega Esperada],
    CASE 
        WHEN GETDATE() > dbo.fn_CalcularProximaRega(P.id_plantas) THEN '⚠️ NECESSITA REGA!'
        ELSE '✅ Em dia'
    END AS [Status]
FROM Plantas P
INNER JOIN Usuarios U ON P.id_usuario = U.id_usuario
INNER JOIN Especies E ON P.id_especie = E.id_especie;
GO

---------------------------------------------------------------------------------------------
-- 6. CRIAÇÃO DE STORED PROCEDURE (PROCEDIMENTO ARMAZENADO)
------------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_RegistrarCuidado
    @id_plantas INT,
    @tipo_cuidado VARCHAR(30),
    @observacao VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Plantas WHERE id_plantas = @id_plantas)
    BEGIN
        RAISERROR('Erro: Planta informada não está cadastrada no sistema MUK.', 16, 1);
        RETURN;
    END

    IF @tipo_cuidado IS NULL SET @tipo_cuidado = 'Rega';

    INSERT INTO Historico_Cuidados (id_plantas, data_cuidado, tipo_cuidado, observacao)
    VALUES (@id_plantas, GETDATE(), @tipo_cuidado, @observacao);

    PRINT 'Sucesso: Registro de cuidado inserido com êxito.';
END;
GO

-----------------------------------------------------------------------------------------------
-- 7. CRIAÇÃO DE TRIGGER (GATILHO)
----------------------------------------------------------------------------------------------
CREATE TRIGGER trg_AuditoriaCuidadosCríticos
ON Historico_Cuidados
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM inserted 
        WHERE tipo_cuidado = 'Rega' AND (observacao LIKE '%murcha%' OR observacao LIKE '%seca%')
    )
    BEGIN
        INSERT INTO Log_Alertas (id_plantas, message)
        SELECT 
            id_plantas, 
            CONCAT('Alerta de saúde emitido para planta ID ', id_plantas, '. Motivo anotado: ', observacao)
        FROM inserted;
    END
END;
GO

-------------------------------------------------------------------------------------------
-- 8. TESTES DE VALIDAÇÃO (DML)
----------------------------------------------------------------------------------------------

-- Testando a VIEW
SELECT * FROM vw_Status_Plantas;

-- Testando a Stored Procedure
EXEC sp_RegistrarCuidado @id_plantas = 1, @tipo_cuidado = 'Rega', @observacao = 'Planta estava muito murcha';

-- Testando o Trigger de Log
SELECT * FROM Log_Alertas;