/**
 * !차량번호 중복 확인
 */
CREATE PROCEDURE `spDoubleCheckNft`(
	`_IDX_USER` INT
)
BEGIN
DECLARE `_COUNT` BOOLEAN;
DECLARE `_ERROR_MSG` TEXT;
SET `_COUNT` = (SELECT COUNT(*) FROM `tbNFT` WHERE `IDX_USER` = `_IDX_USER`);
	
	CASE
		WHEN `_COUNT` > 0 THEN 
			SET `_ERROR_MSG` = CONCAT('Duplicate entry ', `_IDX_USER`, '-NFT for key tbNFT');
			SIGNAL SQLSTATE '23000' SET MESSAGE_TEXT = `_ERROR_MSG`;
        ELSE SELECT TRUE;
	END CASE;

END

/**
 * !회원가입
 */
CREATE PROCEDURE `spUserSignUp`(
	`_CarNumber` 	VARCHAR(50),
	`_Email` 		VARCHAR(100),
	`_Pwd` 			VARCHAR(100),
	`_Phone` 		VARCHAR(20),
	`_Privacy` 		ENUM('Y','N'),
	`_Location` 	ENUM('Y','N'),
	`_Promotion` 	ENUM('Y','N'),
	`_Marketing` 	ENUM('Y','N')	
)
BEGIN
DECLARE `_ERROR` INT DEFAULT 0;
DECLARE `_ERROR_MSG` TEXT;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_ERROR` = 1;
	START TRANSACTION;
		INSERT INTO `tbUser` (
			`CarNumber`,
			`Email`,
			`Pwd`,
			`Phone`
		)
		VALUES (
			`_CarNumber`,
			`_Email`,
			`_Pwd`,
			`_Phone`
		);
		
		INSERT INTO `tbUserCollectedInfo` (
			`IDX_USER`,
			`Privacy`,
			`Location`,
			`Promotion`,
			`Marketing`
		)
		VALUES (
			(SELECT LAST_INSERT_ID()),
			`_Privacy`,
			`_Location`,
			`_Promotion`,
			`_Marketing`
		);
    IF `_ERROR` = 0 THEN
		COMMIT;
	ELSE
        ROLLBACK;
	END IF;
END

/**
 * !캐피탈 정보 조회
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
		SET `_ERROR_MSG` = CONCAT('EMPTY : IDX_USER is Null');
		SIGNAL SQLSTATE '42000' SET MESSAGE_TEXT = `_ERROR_MSG`;
END CASE;
END

/**
 * !증빙서류 정보 조회
 */
CREATE PROCEDURE `spGetDocumentary`(
	`_IDX_USER` INT,
    `_Category` VARCHAR(50)
)
BEGIN
	SELECT
		`Category`,
        `ImgNum`,
        `ImgName`
	FROM `tbDocumentaryEvidence`
	WHERE
		`IDX_USER` = `_IDX_USER`
		AND `Category` = `_Category`
	ORDER BY `ImgNum` ASC;
END

/**
 * !NFT 정보 조회
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
			A.`MetaCID`,
			A.`MetaInfo`,
            B.`VehicleId`
		FROM `tbNFT` A 
            LEFT JOIN `tbCapital` B ON B.`IDX_USER` = A.`IDX_USER`
		WHERE A.`IDX_USER` = `_IDX_USER`;
END CASE;	
END

/**
 * !문의사항 조회
 */
CREATE PROCEDURE `spGetEnquiry`(
	_IDX_USER INT
)
BEGIN
	SELECT 
		A.`IDX_ENQ`,
		A.`Title`,
		A.`Content`,
		A.`CreatedDay`,
		B.`IDX_EAN`,
		B.`Content` as `AdminAnswer`,
		C.`IDX_OPER`,
		C.`Name` AS `AdminName`,
		B.`CreatedDay` AS `AnswerDay`
	FROM `tbEnquiry` A
	LEFT JOIN `tbEnquiryAnswer` B ON B.`IDX_ENQ` = A.`IDX_ENQ`
	LEFT JOIN `tbOperator` C ON C.`IDX_OPER` = B.`IDX_OPER`
	WHERE A.`IDX_USER` = `_IDX_USER`;
END