/**
 * ?[관리자]
 * !게시판 리스트
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
 * ?[관리자]
 * !유저 리스트
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
 * ?[관리자]
 * !캐피탈 테이블 리스트
 */
CREATE PROCEDURE `spCapitalTableList`()
BEGIN
	SELECT
		A.*
	FROM `tbCapital` A
    JOIN `tbUser` B
		ON B.`IDX_USER` = A.`IDX_USER`
    #AND B.`CarNumber` = A.`CarNumber`
    WHERE B.`Active` = "Y";
END

/**
 * ?[관리자]
 * !캐피탈 유저 선택 리스트
 */
CREATE PROCEDURE `spCapitalUnsignedUserList`()
BEGIN
	SELECT 
		A.`IDX_USER`,
		A.`CarNumber`,
		A.`Email`,
		A.`Phone`
    FROM `tbUser` A 
    LEFT JOIN `tbCapital` B 
		ON B.`IDX_USER` = A.`IDX_USER` 
    WHERE B.`IDX_USER` is NULL
		AND A.`Active` = 'Y';
END

/**
 * ?[관리자]
 * !캐피탈 작성
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
 * ?[관리자]
 * !증빙서류 테이블 리스트
 */
CREATE PROCEDURE `spDocumentayTableList`()
BEGIN
	SELECT
		A.`IDX_VR`,
		A.`IDX_USER`,
		B.`CarNumber`,
		A.`Category`,
		A.`imgNum` as `ImgNum`, 
		A.`imgName` as `ImgName`, 
		A.`CreatedDay`,
		C.`IDX_OPER`,
		C.`Name` as `AdminName`
	FROM `tbDocumentaryEvidence` A
	LEFT JOIN `tbUser` B
		ON B.`IDX_USER` = A.`IDX_USER`
	LEFT JOIN `tbOperator` C
		ON C.`IDX_OPER` = A.`CreatedBy`
	WHERE A.`Active` = 'Y'
	ORDER BY A.`IDX_USER`, A.`Category`, A.`imgNum`;
END

/**
 * ?[관리자]
 * !증빙서류 유저 선택 리스트
 */
CREATE PROCEDURE `spDocumentayUnsignedUserList`()
BEGIN
	SELECT
		`IDX_USER`,
		`CarNumber`
	FROM `tbUser`
	WHERE `Active` = 'Y';
END

/**
 * ?[관리자]
 * !증빙서류 작성
 */
CREATE PROCEDURE `spSetDocumentay`(
	`_IDX_USER` INT,
	`_Category` VARCHAR(50),
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
        (SELECT `imgNum` + 1 FROM `tbDocumentaryEvidence` WHERE `IDX_USER` = `_IDX_USER` AND `Category` = `_Category` ORDER BY `imgNum` DESC LIMIT 1),
        `_ImgName`,
        `_IDX_OPER`
	;
    
END

/**
 * ?[관리자]
 * !NFT 테이블 리스트
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
	LEFT JOIN `tbMintTxStatus` B
		ON B.`IDX_NFT` = A.`IDX_NFT` 
	LEFT JOIN `tbUser` C
		ON C.`IDX_USER` = A.`IDX_USER`
	LEFT JOIN `tbOperator` D
		ON D.`IDX_OPER` = A.`IDX_OPER`
	ORDER BY A.`IDX_NFT` DESC;
END

/**
 * ?[관리자]
 * !NFT 테이블 리스트
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
 * ! 사용 안함 현재 spMintTxStatus 만 사용중임.
 * ?[관리자]
 * !NFT 작성
 */
CREATE PROCEDURE `spSetNft`(
	`_IDX_USER` INT,
	`_Category` VARCHAR(50),
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
 * ?[관리자]
 * !민팅 트랜잭션 상태 이력 추가
 */
CREATE PROCEDURE `spMintTxStatus`(
	in _IDX_OPER INT,
	in _IDX_USER INT,
	in _ImgName VARCHAR(100),
	in _ImgCID VARCHAR(100),
	in _MetaName VARCHAR(100),
	in _MetaCID VARCHAR(100),
	in _MetaInfo TEXT,
	in _Tx VARCHAR(100)
)
BEGIN
DECLARE `_IDX_NFT` INT;
	START TRANSACTION;        
		INSERT INTO `tbNFT` (
			`IDX_OPER`,
			`IDX_USER`, 
			`ImgName`, 
			`ImgCID`, 
			`MetaName`, 
			`MetaInfo`, 
			`MetaCID`
		)
		VALUES (
			`_IDX_OPER`, 
			`_IDX_USER`, 
			`_ImgName`, 
			`_ImgCID`, 
			`_MetaName`, 
			`_MetaInfo`, 
			`_MetaCID`
		);
		
        SET `_IDX_NFT` = LAST_INSERT_ID();
		
        INSERT INTO `tbMintTxStatus` (
			`IDX_NFT`,
			`Tx`
		)
		VALUES (
			`_IDX_NFT`,
			`_Tx`
		);
	COMMIT;
END

/**
 * *[에이전트]
 * ?[관리자]
 * !민팅 상태 확인
 */
CREATE PROCEDURE `spMintTxStatusChange`(
	in _IDX_TXMINT INT,
    in _IDX_NFT INT,
    in _Tx VARCHAR(100),
    in _Status TINYINT,
    in _TokenId INT
)
BEGIN
	# Status = Sueccess 일경우
	IF(_Status = 1) THEN
		UPDATE `tbNFT` A
        LEFT JOIN `tbMintTxStatus` B
        ON B.IDX_NFT = A.IDX_NFT
        SET 
			A.`TokenId` = _TokenId,
			B.`Status` = "Success",
            B.`DecisionDay` = NOW()
		WHERE `IDX_TXMINT` = _IDX_TXMINT;
	# Status = False 일경우
    ELSEIF(_Status = 0) THEN
		UPDATE `tbMintTxStatus`
        SET 
			`Status` = "False",
            `DecisionDay` = NOW()
		WHERE `IDX_TXMINT` = _IDX_TXMINT;
	# Status = Pending 일 경우
	ELSE
		UPDATE `tbMintTxStatus`
        SET 
			`LastConDay` = NOW()
		WHERE `IDX_TXMINT` = _IDX_TXMINT;
    END IF;
END

/**
 * ?[관리자]
 * !문의사항 테이블 리스트
 */
CREATE PROCEDURE `spEnquiryTableList`()
BEGIN
	SELECT 
		A.`IDX_ENQ`,
		A.`IDX_USER`,
		B.`CarNumber`,
		A.`Title`,
		A.`Content`,
		A.`CreatedDay`,
		A.`Answer`,
		D.`Name` as `AdminName`
	FROM `tbEnquiry` A 
		LEFT JOIN `tbUser` B ON B.`IDX_USER` = A.`IDX_USER`
		LEFT JOIN `tbEnquiryanswer` C ON C.`IDX_ENQ` = A.`IDX_ENQ`
		LEFT JOIN `tbOperator` D ON D.`IDX_OPER` = C.`IDX_OPER`;
END

/**
 * ?[관리자]
 * !문의사항 답변 달기
 */
CREATE PROCEDURE `spSetEnquiryAnswer`(
	_IDX_ENQ INT,
    _IDX_OPER INT,
    _Content VARCHAR(1024)
)
BEGIN
DECLARE `_ERROR` INT DEFAULT 0;
DECLARE `_ERROR_MSG` TEXT;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_ERROR` = 1;
	START TRANSACTION;
		INSERT INTO `tbEnquiryAnswer`
		(
			`IDX_ENQ`,
			`IDX_OPER`,
			`Content`
		) 
		VALUE
		(
			`_IDX_ENQ`,
			`_IDX_OPER`,
			`_Content`
		);
		
		IF `_ERROR` = 0 THEN
			UPDATE `tbEnquiry` 
			SET `Answer` = 'Y' 
			WHERE `IDX_ENQ` = _IDX_ENQ;
			COMMIT;
		ELSE
			ROLLBACK;
		END IF;
END

/**
 * ?[관리자]
 * !FAQ 추가
 */
CREATE PROCEDURE `spAddFaq`(
	IN `_IDX_OPER` INT,
	IN `_Title` VARCHAR(255),
	IN `_Content` VARCHAR(2048)
)
BEGIN
INSERT INTO `tbFaqBoard`(`IDX_OPER`, `Title`, `Content`) 
VALUES (_IDX_OPER, _Title, _Content);
END

/**
 * ?[관리자]
 * !FAQ 삭제
 */
CREATE PROCEDURE `spDeleteFaq`(
	_IDX_FAQ	INT,
    _IDX_OPER	INT
)
BEGIN
DECLARE _COUNT	INT;
DECLARE _ERROR_MSG	TEXT;
SET _COUNT = (SELECT COUNT(*) FROM `tbFaqBoard` WHERE `IDX_FAQ` = `_IDX_FAQ` AND `IDX_OPER` = `_IDX_OPER` AND `Active` = 'Y');

CASE
	WHEN _COUNT = 0 THEN
		SET _ERROR_MSG = CONCAT('[', `_IDX_FAQ`, '-', `IDX_OPER`, ']');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = `_ERROR_MSG`;
	
    ELSE
		UPDATE `tbFaqBoard` 
		SET 
			`DeletedDay` = (SELECT CURRENT_TIMESTAMP), 
            `Active` = 'N' 
		WHERE `IDX_FAQ` = _IDX_FAQ AND `IDX_OPER` = _IDX_OPER AND `Active` = 'Y';
END CASE;
END

/**
 * ?[관리자 | 유저]
 * !FAQ 리스트
 */
CREATE PROCEDURE `spFaqList`()
BEGIN
SELECT 
    A.`IDX_FAQ`,
    A.`Title`,
    A.`Content`,
    B.`Name`
FROM `tbFaqBoard` A
	LEFT JOIN `tboperator` B 
	ON B.`IDX_OPER` = A.`IDX_OPER`
WHERE A.`Active` = 'Y'
ORDER BY `IDX_FAQ`;
END

/**
 * ?[관리자]
 * !FAQ 수정
 */
CREATE PROCEDURE `spModifyFaq`(
	_IDX_FAQ	INT,
    _IDX_OPER	INT,
    _title		VARCHAR(255),
    _content		VARCHAR(2048)
)
BEGIN
DECLARE _COUNT	INT;
DECLARE _ERROR_MSG	TEXT;
SET _COUNT = (SELECT COUNT(*) FROM `tbFaqBoard` WHERE `IDX_FAQ` = `_IDX_FAQ` AND `IDX_OPER` = _IDX_OPER AND `Active` = 'Y');

CASE
	WHEN _COUNT = 0 THEN 
		SET _ERROR_MSG = CONCAT('[',`_IDX_FAQ`,']');
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = `_ERROR_MSG`;
	
    ELSE
		UPDATE `tbFaqBoard` 
		SET `Title` = _title, `Content` = _content 
		WHERE `IDX_FAQ` = _IDX_FAQ AND `IDX_OPER` = _IDX_OPER AND `Active` = 'Y';
END CASE;
END