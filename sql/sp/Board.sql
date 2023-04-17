/**
 * 게시물 조회
 */
DROP PROCEDURE IF EXISTS `spBoardView`;
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
 * 게시물 리스트 조회
 */
DROP PROCEDURE IF EXISTS `spBoardList`;
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