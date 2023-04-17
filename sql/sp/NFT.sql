/**
 * NFT 민팅 직후 트렌젝션 이력 생성
 */
DROP PROCEDURE IF EXISTS `spMintTxStatus`;
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