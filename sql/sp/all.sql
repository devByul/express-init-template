/**
 * Admin 게시판 리스트 조회
 */
CREATE PROCEDURE `spAdminBoardList`()
BEGIN
	SELECT 
		A.`IDX_BOARD`,
		A.`Title`,
		A.`Content`,
		A.`Category`,
		A.`CreatedDay`,
		B.`IDX_USER`,
		B.`CarNumber`,
		C.`IDX_OPER`,
		C.`Name` as `AdminName`
	FROM `tbBoard` A
	LEFT JOIN `tbUser` B
		ON B.`IDX_USER` = A.`IDX_USER` AND B.`Active` = 'Y'
	LEFT JOIN `tbOperator` C
		ON C.`IDX_OPER` = A.`IDX_OPER`
	WHERE
		A.`Active` = 'Y' 
		AND COALESCE(B.IDX_USER,C.IDX_OPER ) is not null
	ORDER BY A.`ModifiedDay` DESC;
END

/**
 * Admin 유저리스트 조회
 */
CREATE PROCEDURE `spAdminUserList`(
	IN _LIMIT INT,
    IN _OFFSET INT
)
BEGIN
SET `_LIMIT` = IFNULL(_limit, 10);
	SELECT 
		`IDX_USER`,
		`CarNumber`,
        `Email`,
        `Phone`,
        `Active`,
        `CreatedAt`
	FROM `tbUser` 
    ORDER BY `IDX_USER`;
    #LIMIT `_LIMIT`
    #OFFSET `_OFFSET`;
END

/**
 * 전체 게시물리스트 조회
 */
CREATE PROCEDURE `spBoardList`(
	in _category varchar(20),
    in _limit int,
    in _offset int
)
BEGIN 
    SELECT 
		`IDX_BOARD`
		,`IDX_USER`
		,`Title`
		,`Content`
		,`Category`
		,`CreatedDay`
		,`ModifiedDay`
	FROM `tbBoard` 
    WHERE `Activate` = 0 AND 
        CASE
			WHEN _category = 'BBS_BC_000000' THEN `Category` LIKE 'BBS_BC_%'
			WHEN _category = 'BBS_BC_100000' THEN `Category` LIKE 'BBS_BC_1%'
			WHEN _category = 'BBS_BC_100001' THEN `Category` = 'BBS_BC_100001'
            WHEN _category = 'BBS_BC_100002' THEN `Category` = 'BBS_BC_100002'
            WHEN _category = 'BBS_BC_100003' THEN `Category` = 'BBS_BC_100003'
            WHEN _category = 'BBS_BC_200000' THEN `Category` LIKE 'BBS_BC_2%'
            WHEN _category = 'BBS_BC_200001' THEN `Category` = 'BBS_BC_200001'
            WHEN _category = 'BBS_BC_200002' THEN `Category` = 'BBS_BC_200002'
            WHEN _category = 'BBS_BC_200003' THEN `Category` = 'BBS_BC_200003'
		END
	ORDER BY IDX_BOARD
    LIMIT _limit
    OFFSET _offset;
    
    SELECT 
		(CASE 
			WHEN _category = 'BBS_BC_000000' THEN (SELECT COUNT(*) FROM `tbBoard` WHERE `Activate` = 0 AND `Category` LIKE 'BBS_BC_%')
			WHEN _category = 'BBS_BC_100000' THEN (SELECT COUNT(*) FROM `tbBoard` WHERE `Activate` = 0 AND `Category` LIKE 'BBS_BC_1%')
			WHEN _category = 'BBS_BC_100001' THEN (SELECT COUNT(*) FROM `tbBoard` WHERE `Activate` = 0 AND `Category` LIKE 'BBS_BC_100001')
            WHEN _category = 'BBS_BC_100002' THEN (SELECT COUNT(*) FROM `tbBoard` WHERE `Activate` = 0 AND `Category` LIKE 'BBS_BC_100002')
            WHEN _category = 'BBS_BC_100003' THEN (SELECT COUNT(*) FROM `tbBoard` WHERE `Activate` = 0 AND `Category` LIKE 'BBS_BC_100003')
            WHEN _category = 'BBS_BC_200000' THEN (SELECT COUNT(*) FROM `tbBoard` WHERE `Activate` = 0 AND `Category` LIKE 'BBS_BC_2%')
            WHEN _category = 'BBS_BC_200001' THEN (SELECT COUNT(*) FROM `tbBoard` WHERE `Activate` = 0 AND `Category` LIKE 'BBS_BC_200001')
            WHEN _category = 'BBS_BC_200002' THEN (SELECT COUNT(*) FROM `tbBoard` WHERE `Activate` = 0 AND `Category` LIKE 'BBS_BC_200002')
            WHEN _category = 'BBS_BC_200003' THEN (SELECT COUNT(*) FROM `tbBoard` WHERE `Activate` = 0 AND `Category` LIKE 'BBS_BC_200003')
		END) AS `ActiveTotalCount`;
	
END

/**
 * 게시물 조회
 */
CREATE PROCEDURE `spBoardView`(
	IN _view INT
)
BEGIN
	SELECT 
		`IDX_BOARD`
		,`IDX_USER`
		,`Title`
		,`Content`
		,`Category`
		,`CreatedDay`
		,`ModifiedDay`
    FROM `tbBoard` 
    WHERE `IDX_BOARD` = _view 
		AND `Activate` = 0;
    
    SELECT 
		A.`Step`,
		B.`OriginalName`,
        B.`Filename`
    FROM `tbBoardToFile` A 
    LEFT JOIN `tbFiles` B 
		ON B.`IDX_FILE` = A.`IDX_FILE` 
	WHERE `IDX_BOARD` = _view;
END

/**
 * 캐피탈 정보 리스트 조회
 */
CREATE PROCEDURE `spCapitalTableList`()
BEGIN
	SELECT
		A.*
	FROM `tbCapital` A
    JOIN `tbUser` B
		ON B.`IDX_USER` = A.`IDX_USER`
    #AND B.`CarNumber` = A.`CarNumber`
    WHERE B.`Active` = "Y"
    ;
END

/**
 * (캐피탈 없는)유저리스트 조회
 */
CREATE PROCEDURE `spCapitalUnsignedUserList`()
BEGIN
	SELECT 
		A.`IDX_USER`,
		A.`CarNumber`,
		A.`Email`,
		A.`Phone`
    FROM `tbUser` A 
    LEFT JOIN `tbcapital` B 
		ON B.`IDX_USER` = A.`IDX_USER` 
    WHERE B.`IDX_USER` is NULL
		AND A.`Active` = 'Y';
END

/**
 * 케피탈 정보 저장
 */
CREATE PROCEDURE `spSetCapital`(
	`_IDX_OPER` INT,
	`_capitalInfoJSON` JSON
)
BEGIN
	INSERT INTO `tbCapital` ( 
        IDX_USER, 
        Capital, 
        Name, 
        Business, 
        Division, 
        StartAt, 
        DueAt, 
        CarNumber, 
        VehicleId, 
        VehicleName, 
        RentalPeriod, 
        ContractedMileage, 
        Subsidy, 
        AdvancePay, 
        AcquisitionOrReturn,
        Repair, 
        PaymentMethod, 
        PaymentBank, 
        PaymentAt, 
        AccountHolder, 
        DriverAge, 
        Dedutible, 
        IndemnityReturn, 
        IndemnityTotalLoss, 
        CompulsorySubscription, 
        Phone, 
        Email, 
        CreatedBy 
	)
		SELECT 
			`capitalInfo`.*,
			A.`IDX_OPER` as CreatedBy
		FROM `tbOperator` AS A, 
		JSON_TABLE (
			`_capitalInfoJSON`,
			'$'
			COLUMNS  (
				`IDX_USER` INT PATH '$.IDX_USER',
				`Capital` VARCHAR(100) PATH '$.Capital',
				`Name` VARCHAR(20) PATH '$.Name',
				`Business` ENUM('법인','개인') PATH '$.Business',
				`Division` VARCHAR(100) PATH '$.Division',
				`StartAt` TIMESTAMP PATH '$.StartAt',
				`DueAt` TIMESTAMP PATH '$.DueAt',
				`CarNumber` VARCHAR(100) PATH '$.CarNumber',
				`VehicleId` VARCHAR(100) PATH '$.VehicleId',
				`VehicleName` VARCHAR(100) PATH '$.VehicleName',
				`RentalPeriod` TIMESTAMP PATH '$.RentalPeriod',
				`ContractedMileage` INT PATH '$.ContractedMileage',
				`Subsidy` INT PATH '$.Subsidy',
				`AdvancePay` INT PATH '$.AdvancePay',
				`AcquisitionOrReturn` VARCHAR(100) PATH '$.AcquisitionOrReturn',
				`Repair` VARCHAR(100) PATH '$.Repair',
				`PaymentMethod` VARCHAR(100) PATH '$.PaymentMethod',
				`PaymentBank` VARCHAR(100) PATH '$.PaymentBank',
				`PaymentAt` TINYINT PATH '$.PaymentAt',
				`AccountHolder` VARCHAR(100) PATH '$.AccountHolder',
				`DriverAge` INT PATH '$.DriverAge',
				`Dedutible` INT PATH '$.Dedutible',
				`IndemnityReturn` INT PATH '$.IndemnityReturn',
				`IndemnityTotalLoss` INT PATH '$.IndemnityTotalLoss',
				`CompulsorySubscription` VARCHAR(500) PATH '$.CompulsorySubscription',
				`Email` VARCHAR(100) PATH '$.Email',
				`Phone` VARCHAR(100) PATH '$.Phone'
			) 
		) AS `capitalInfo`
		WHERE A.`IDX_OPER` = _IDX_OPER;
END

/**
 * 증빙서류 리스트 조회
 */
CREATE PROCEDURE `spDocumentayTableList`()
BEGIN
	SELECT
		A.`IDX_VR`,
		A.`IDX_USER`,
		B.`CarNumber`,
		A.`Category`,
		A.`imgNum`,
		A.`imgName`,
		A.`CreatedDay`,
		C.`IDX_OPER`,
		C.`Name`
	FROM `tbDocumentaryEvidence` A
	LEFT JOIN `tbUser` B
		ON B.`IDX_USER` = A.`IDX_USER`
	LEFT JOIN `tbOperator` C
		ON C.`IDX_OPER` = A.`CreatedBy`
	WHERE A.`Active` = 'Y'
	ORDER BY A.`IDX_USER`, A.`Category`, A.`imgNum`;
END

/**
 * (증빙서류 없는)유저리스트 조회
 */
CREATE PROCEDURE `spDocumentayUnsignedUserList`()
BEGIN
	SELECT
		A.`IDX_USER`,
		A.`CarNumber`
	FROM `tbUser` A
	LEFT JOIN `tbDocumentaryEvidence` B
		ON B.`IDX_USER` = A.`IDX_USER`
	WHERE B.`IDX_USER` IS NULL
		AND A.`Active` = 'Y';
END

/**
 * 증빙서류 이미지 내역 저장
 */
CREATE PROCEDURE `spSetDocumentay`(
	`_IDX_USER` INT,
	`_Category` VARCHAR(50),
    `_ImgNum` INT,
	`_ImgName` VARCHAR(200),
    `_IDX_OPER` INT
)
BEGIN
	INSERT INTO `tbDocumentaryEvidence` (
		`IDX_USER`,
        `Category`,
        `ImgNum`,
        `ImgName`,
        `CreatedBy`
	) 
    SELECT
		`_IDX_USER`,
        `_Category`,
        (
			CASE
				WHEN `_Category` = 'NFT' THEN 0
                ELSE (SELECT `imgNum` + 1 FROM `tbDocumentaryEvidence` WHERE `IDX_USER` = `_IDX_USER` AND `Category` = `_Category` ORDER BY `imgNum` DESC LIMIT 1)
			END    
		),
        `_ImgName`,
        `_IDX_OPER`
	;
END

/**
 * NFT 민팅 트랜잭션 상태 이력 추가
 */
CREATE PROCEDURE `spMintTxStatus`(
	in _IDX_OPER INT,
	in _IDX_USER INT,
	in _ImgName VARCHAR(100),
	in _ImgCID VARCHAR(100),
	in _MetaName VARCHAR(100),
	in _MetaCID VARCHAR(100),
	in _Tx VARCHAR(100)
)
BEGIN
DECLARE _IDX_NFT INT;
	START TRANSACTION;        
		INSERT INTO `tbNFT`
		(`IDX_OPER`, `IDX_USER`, `ImgName`, `ImgCID`, `MetaName`, `MetaCID`)
		VALUES (_IDX_OPER, _IDX_USER, _ImgName, _ImgCID, _MetaName, _MetaCID);
		
        SET _IDX_NFT = LAST_INSERT_ID();
		
        INSERT INTO `tbMintTxStatus`
		(`IDX_NFT`,`Tx`)
		VALUES (_IDX_NFT,_Tx);
	COMMIT;
END

/**
 * 에이전트
 * NFT 민팅 트렌잭션 상태 이력 변경 코드
 */
CREATE PROCEDURE `spMintTxStatusChange`(
	in _IDX_TXMINT INT,
    in _IDX_NFT INT,
    in _Tx VARCHAR(100),
    in _Status TINYINT,
    in _TokenId INT
)
BEGIN
	# Status = Sueccess
	IF(_Status = 1) THEN
		UPDATE `tbNFT` A
        LEFT JOIN `tbMintTxStatus` B
        ON B.IDX_NFT = A.IDX_NFT
        SET 
			A.`TokenId` = _TokenId,
			B.`Status` = "Success",
            B.`DecisionDay` = NOW()
		WHERE `IDX_TXMINT` = _IDX_TXMINT;
	# Status = False
    ELSEIF(_Status = 0) THEN
		UPDATE `tbMintTxStatus`
        SET 
			`Status` = "False",
            `DecisionDay` = NOW()
		WHERE `IDX_TXMINT` = _IDX_TXMINT;
	# Status = Pending
	ELSE
		UPDATE `tbMintTxStatus`
        SET 
			`LastConDay` = NOW()
		WHERE `IDX_TXMINT` = _IDX_TXMINT;
    END IF;
END

/**
 * NFT 리스트 조회
 */
CREATE PROCEDURE `spNFTTableList`()
BEGIN
	SELECT
		A.`IDX_NFT`,
		C.`IDX_USER`,
		C.`CarNumber`,
		A.`TokenID`,
		B.`Status`,
		D.`Name` AS `AdminName`,
		B.`Tx`,
		A.`MetaCID`,
		B.`CreatedDay`
	FROM `tbNFT` A
	LEFT JOIN `tbMinttxStatus` B
		ON B.`IDX_NFT` = A.`IDX_NFT` 
	LEFT JOIN `tbUser` C
		ON C.`IDX_USER` = A.`IDX_USER`
	LEFT JOIN `tbOperator` D
		ON D.`IDX_OPER` = A.`IDX_OPER`
	ORDER BY A.`IDX_NFT` DESC;
END

/**
 * NFT 없는 유저리스트 조회
 */
CREATE PROCEDURE `spNFTUnsignedUserList`()
BEGIN
 	SELECT 
		A.`IDX_USER`,
		A.`CarNumber`
    FROM `tbUser` A 
    LEFT JOIN `tbNFT` B 
		ON B.`IDX_USER` = A.`IDX_USER` 
    WHERE B.`IDX_USER` is NULL
		AND A.`Active` = 'Y';
END

/**
 * NFT 이미지 내역 저장
 */
 CREATE PROCEDURE `spSetNft`(
	`_IDX_USER` INT,
	`_Category` VARCHAR(50),
    `_ImgNum` INT,
	`_ImgName` VARCHAR(200),
    `_IDX_OPER` INT
)
BEGIN
	INSERT INTO `tbDocumentaryEvidence` (
		`IDX_USER`,
        `Category`,
        `ImgNum`,
        `ImgName`,
        `CreatedBy`
	) 
    SELECT
		`_IDX_USER`,
        `_Category`,
        (
			CASE
				WHEN `_Category` = 'NFT' THEN 0
                ELSE (SELECT `imgNum` + 1 FROM `tbDocumentaryEvidence` WHERE `IDX_USER` = `_IDX_USER` AND `Category` = `_Category` ORDER BY `imgNum` DESC LIMIT 1)
			END    
		),
        `_ImgName`,
        `_IDX_OPER`
	;
END


/**
 * NFT 민팅 여부 확인
 */
CREATE PROCEDURE `spDoubleCheckNft`(
	`_IDX_USER` INT
)
BEGIN
DECLARE `_COUNT` BOOLEAN;
DECLARE `_ERROR_MSG` TEXT;
SET `_COUNT`
 = (SELECT 
		(
			CASE
				WHEN COUNT(*) = 0 THEN TRUE
				ELSE FALSE
			END
		)
	FROM `tbNFT` 
	WHERE 
		`IDX_USER` = `_IDX_USER` 
	);
	
	CASE
		WHEN `_COUNT` = FALSE THEN 
			SET `_ERROR_MSG` = CONCAT('Duplicate entry ', `_IDX_USER`, '-NFT for key tbNFT');
			SIGNAL SQLSTATE '23000' SET MESSAGE_TEXT = `_ERROR_MSG`;
        ELSE SELECT TRUE;
	END CASE;

END

/********************************/
/******** USER API QUERY ********/
/********************************/

/**
 * [유저] 캐피탈 정보
 */
CREATE PROCEDURE `spGetCapital`(
	`_IDX_USER` INT
)
BEGIN
DECLARE `_Active` ENUM('Y','N');
DECLARE `_ERROR_MSG` TEXT;
SET `_Active` = (SELECT `Active` FROM `tbCapital` WHERE `IDX_USER` = `_IDX_USER`);

	CASE
		WHEN `_Active` = 'Y' THEN 
			SELECT
				`Capital`,
				`Name`,
				`Business`,
				`Division`,
				`StartAt`,
				`DueAt`,
				`CarNumber`,
				`VehicleId`,
				`VehicleName`,
				`RentalPeriod`,
				`ContractedMileage`,
				`Subsidy`,
				`AdvancePay`,
				`AcquisitionOrReturn`,
				`Repair`,
				`PaymentMethod`,
				`PaymentBank`,
				`PaymentAt`,
				`AccountHolder`,
				`DriverAge`,
				`Dedutible`,
				`IndemnityReturn`,
				`IndemnityTotalLoss`,
				`CompulsorySubscription`,
				`Phone`,
				`Email`
			FROM `tbCapital`
			WHERE `IDX_USER` = `_IDX_USER`;
		WHEN `_Active` = 'N' THEN
			SET `_ERROR_MSG` = CONCAT('DISABLED : CarNumber[ ', (SELECT `CarNumber` FROM `tbUser` WHERE `IDX_USER` = `_IDX_USER`), ' ] is dsabled CarNumber');
			SIGNAL SQLSTATE '42000' SET MESSAGE_TEXT = `_ERROR_MSG`;
		ELSE
			SET `_ERROR_MSG` = CONCAT('EMPTY : IDX_USER[ ', `_IDX_USER`, ' ] is non-existent user');
			SIGNAL SQLSTATE '42000' SET MESSAGE_TEXT = `_ERROR_MSG`;
	END CASE;
END


/**
 * [유저] NFT 정보
 */
CREATE PROCEDURE `spGetNft`(
	`_IDX_USER` INT
)
BEGIN
DECLARE `_COUNT` BOOLEAN;
DECLARE `_ERROR_MSG` TEXT;
SET `_COUNT` = (SELECT COUNT(*) FROM `tbNFT` WHERE `IDX_USER` = `_IDX_USER`);

CASE
	WHEN `_COUNT` = 0 THEN 
		SET `_ERROR_MSG` = CONCAT('EMPTY : IDX_USER[ ',`_IDX_USER`, ' ] is non-existent user');
		SIGNAL SQLSTATE '42000' SET MESSAGE_TEXT = `_ERROR_MSG`;
	ELSE
		SELECT
			'NFT' as `Category`,
			A.`ImgName`,
            B.`VehicleId`
		FROM `tbNFT` A 
            LEFT JOIN `tbCapital` B ON B.`IDX_USER` = A.`IDX_USER`
		WHERE A.`IDX_USER` = `_IDX_USER`;
END CASE;	
END