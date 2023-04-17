/**
 * 공통 코드
 */
DROP TABLE IF EXISTS `tbCommonCode`;
TRUNCATE TABLE `tbCommonCode`;
CREATE TABLE `tbCommonCode` (
    `Key`				VARCHAR(100)			NOT NULL						COMMENT '공통코드 키',
    `Value`				TEXT					NOT NULL						COMMENT '공통코드 내용',
    CONSTRAINT `PK_CODE` PRIMARY KEY(`Key`)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci 
COMMENT = '공통';

/**
 * DB 런타임 에러 로그
 */
DROP TABLE IF EXISTS `tbErrorLog`;
TRUNCATE TABLE `tbErrorLog`;
CREATE TABLE `tbErrorLog` (
    `IDX_ERROR`				SMALLINT	UNSIGNED	AUTO_INCREMENT					COMMENT '에러 로그 ID',
    `ProcName`				VARCHAR(100)			NOT NULL						COMMENT '프로시저 이름',
    `ProcStep`				TINYINT 	UNSIGNED	NOT NULL						COMMENT '프로시저 내에서 에러가 발생한 스텝 번호',
    `SqlState`				VARCHAR(5)				NOT NULL						COMMENT 'SQLSTATE',
    `ErrorNo`				INT						NOT NULL						COMMENT '에러 번호',
    `ErrorMsg`				TEXT					NOT NULL						COMMENT '에러 메세지',
    `CallStack`				TEXT						NULL						COMMENT '프로시저 호출 파라미터',
    `ProcCallDate`			TIMESTAMP				NOT NULL						COMMENT '프로시저 호출 일자',
    `LogDate`				TIMESTAMP				NOT NULL	DEFAULT NOW()		COMMENT '로그 적재 일자',
    CONSTRAINT `PK_ERROR` PRIMARY KEY(`IDX_ERROR`)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci 
COMMENT = 'DB 런타임 에러 로그';

/**
 * 예외 로그
 */
DROP TABLE IF EXISTS `tbExceptionLog`;
TRUNCATE TABLE `tbExceptionLog`;
CREATE TABLE `tbExceptionLog` (
  `IDX_EXCEPTION`			MEDIUMINT	UNSIGNED	AUTO_INCREMENT					COMMENT '예외 ID',
  `ProcName`				VARCHAR(100)			NOT NULL						COMMENT '프로시저 이름',
  `ProcStep`				TINYINT		UNSIGNED	NOT NULL						COMMENT '프로서저 안에서 예외가 발생한 단계',
  `ExceptionNo`				INT			UNSIGNED	NOT NULL						COMMENT '예외 ID',
  `CallStack`				TEXT 						NULL						COMMENT '프로시저 호출 파라미터',
  `ProcCallDate`			TIMESTAMP 				NOT NULL						COMMENT '프로시저 호출 일자',
  `LogDate`					TIMESTAMP 				NOT NULL	DEFAULT NOW()		COMMENT '로그 적재 일자',
  CONSTRAINT `PK_EXCEPTION` PRIMARY KEY(`IDX_EXCEPTION`)
) 
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci 
COMMENT='예외 로그';

/**
 * 관리자 테이블
 */
#DROP TABLE IF EXISTS `tbOperator`;
#TRUNCATE TABLE `tbOperator`;
CREATE TABLE `tbOperator` (
	`IDX_OPER`				INT						AUTO_INCREMENT	            	COMMENT '관리자 IDX',
	`ID`					VARCHAR(100)			NOT NULL	            		COMMENT '관리자 ID',
	`Name`					VARCHAR(50)				NOT NULL	            		COMMENT '이름',
	`Pwd`					VARCHAR(100)			NOT NULL	            		COMMENT '비밀번호',
	`Phone`					VARCHAR(20)				NOT NULL	            		COMMENT '휴대폰번호',
	`Tel`					VARCHAR(20)				NOT NULL	            		COMMENT '유선번호',
	`Email`					VARCHAR(100)			NOT NULL	            		COMMENT '이메일',
	`Capital`				VARCHAR(100)			NOT NULL	            		COMMENT '캐피탈 부서',
	`ProfileImg`			VARCHAR(255)			NULL	            			COMMENT '프로필 이미지',
	`Active`				enum("Y","N")			NOT NULL	  DEFAULT 'Y'       COMMENT '사용 여부',
	`LastConDay`			TIMESTAMP				NULL      			    		COMMENT '최종 접속 시간',
	`RegID`					VARCHAR(100)			NOT NULL	            		COMMENT '생성자',
	`CreatedAt`				TIMESTAMP				NOT NULL      DEFAULT NOW() 	COMMENT '생성일시',
	`ChgID`					VARCHAR(100)			NULL	            			COMMENT '변경자',
	`ModifiedAt`			TIMESTAMP				NULL      			    		COMMENT '변경일시',
	CONSTRAINT `PK_OPERATOR` PRIMARY KEY(`IDX_OPER`)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci 
COMMENT '관리자 테이블';

/**
 * 캐피탈 목록 테이블
 */
#DROP TABLE IF EXISTS `tbCapitalInfo`;
#TRUNCATE TABLE `tbCapitalInfo`;
CREATE TABLE `tbCapitalInfo` (
	`IDX_CAP_INFO`	        INT             	AUTO_INCREMENT                		COMMENT '캐피탈 목록_IDX',
	`CapitalName`          	VARCHAR(100)       	NOT NULL                      		COMMENT '캐피탈명',
	`Contact`	            VARCHAR(100)       	NOT NULL                      		COMMENT '연락처',
	`ContactTime`	        VARCHAR(100) 	  	NOT NULL                      		COMMENT '연락가능시간',
	`CreatedDay`	        TIMESTAMP       	NOT NULL      DEFAULT NOW()   		COMMENT '작성일',
	`CreatedBy`	        	INT       	  		NOT NULL      				   		COMMENT '작성자',
	`ModifyedDay`	        TIMESTAMP       	  	NULL      				   		COMMENT '수정일',
	`ModifyedBy`	        INT       	  			NULL      				   		COMMENT '수정자',
	`DeletedDay`	        TIMESTAMP       	  	NULL      				   		COMMENT '삭제일',
	`DeletedBy`	        	INT       	  			NULL      				   		COMMENT '삭제자',
  CONSTRAINT `PK_ENQUIRY_ANSWER` PRIMARY KEY(`IDX_CAP_INFO`),
  INDEX `IDX_CAPINFO` (`CapitalName`)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci 
COMMENT '캐피탈 목록 테이블';

/**
 * 유저 테이블
 */
#DROP TABLE IF EXISTS `tbUser`;
#TRUNCATE TABLE `tbUser`;
CREATE TABLE `tbUser` (
	`IDX_USER`              INT              		AUTO_INCREMENT	            	COMMENT 'IDX_USER',
	`CarNumber`				VARCHAR(50)				NOT NULL						COMMENT '차량 번호',
	`Pwd`					VARCHAR(100)			NOT NULL						COMMENT '비밀번호',
	`Email`					VARCHAR(100)			NOT NULL						COMMENT '이메일',
	`Phone`					VARCHAR(20)				NOT NULL						COMMENT '휴대폰 번호',
	`ProfileImg`			TINYINT					NOT NULL	DEFAULT 1			COMMENT '프로필 이미지',
	`CreatedAt`				TIMESTAMP           	NOT NULL    DEFAULT NOW()    	COMMENT '유저 생성일',
    `Active` 				enum("Y","N") 			NOT NULL	DEFAULT "Y"			COMMENT "활성화 여부",
	`ModifiedAt`			TIMESTAMP           	NULL      				    	COMMENT '유저 수정일',
	`DeletedAt`				TIMESTAMP           	NULL                       		COMMENT '유저 삭제일',
	CONSTRAINT `PK_USER` PRIMARY KEY(`IDX_USER`),
	CONSTRAINT `UK_USER` UNIQUE KEY(`CarNumber`),
	INDEX `IDX_USER` (`CarNumber`,`Email`)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci 
COMMENT '유저 테이블';

/**
 * 유저 수집 정보 테이블
 */
#DROP TABLE IF EXISTS `tbUserCollectedInfo`;
#TRUNCATE TABLE `tbUserCollectedInfo`;
CREATE TABLE `tbUserCollectedInfo` (
	`IDX_USER`				INT						NOT NULL						COMMENT 'IDX_USER',
    `Privacy`				ENUM("Y","N")			NOT NULL						COMMENT '개인정보수집 및 이용',
	#`Location`				ENUM("Y","N")			NOT NULL						COMMENT '위치기반서비스 이용약관',
    `Promotion`				ENUM("Y","N")			NOT NULL						COMMENT '프로모션 정보수신약관',
	`Marketing`				ENUM("Y","N")			NOT NULL						COMMENT '마케팅 정보 수신동의',
	`Email`            		ENUM("Y","N")    		NOT NULL                		COMMENT '이메일 수신 동의여부',
    `SNS`            		ENUM("Y","N")    		NOT NULL                		COMMENT 'SNS 수신 동의여부'
	#CONSTRAINT `FK_USER_SEND` FOREIGN KEY(`IDX_USER`) REFERENCES `tbUser` (`IDX_USER`)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci 
COMMENT '유저 수집 정보 테이블';

/**
 * 증빙서류
 */
#DROP TABLE IF EXISTS `tbDocumentaryEvidence`;
#TRUNCATE TABLE `tbDocumentaryEvidence`;
CREATE TABLE `tbDocumentaryEvidence` (
	`IDX_VR`				INT					AUTO_INCREMENT              		COMMENT 'IDX_VR',
	`IDX_USER`				INT					NOT NULL							COMMENT 'IDX_USER',
    `Category`				VARCHAR(50)			NOT NULL							COMMENT '서류 항목',
    `imgNum`				INT					NOT NULL							COMMENT '이미지 번호',
    `imgName`				VARCHAR(200)		NOT NULL							COMMENT '이미지 이름',
	`CreatedDay`	        TIMESTAMP       	NOT NULL      DEFAULT NOW()   		COMMENT '작성일',
	`CreatedBy`	        	INT       			NOT NULL         					COMMENT '작성자',
	`ModifiedDay`	        TIMESTAMP       	NULL      	  ON UPDATE	NOW()		COMMENT '수정일',
	`ModifiedBy`	        INT       			NULL      				   			COMMENT '수정자',
	`DeletedDay`	        TIMESTAMP       	NULL								COMMENT '삭제일',
	`DeletedBy`	        	INT			       	NULL                      			COMMENT '삭제자',
	`Active`				ENUM('Y','N')		NOT NULL      DEFAULT 'Y'    		COMMENT '활성여부',
	CONSTRAINT `PK_VR` PRIMARY KEY(`IDX_VR`),
    CONSTRAINT `UK_VR` UNIQUE KEY(`IDX_USER`, `Category`, `imgNum`)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci 
COMMENT '차량 등록증 테이블';

/**
 * 캐피탈 제공 정보 테이블
 */
#DROP TABLE IF EXISTS `tbCapital`;
#TRUNCATE TABLE `tbCapital`;
CREATE TABLE `tbCapital` (
	`IDX_CAP`				INT						AUTO_INCREMENT              	COMMENT '캐피탈 제공 정보 테이블',
	`IDX_USER`              INT              		NULL			            	COMMENT '유저 테이블',
	`Capital`				VARCHAR(100)			NOT NULL                    	COMMENT '캐피탈 업체명',
	`Name`					VARCHAR(20)				NOT NULL                    	COMMENT '이용자명',
	`Business`				ENUM('법인','개인')		NOT NULL                    	COMMENT '사업자',
	`Division`				VARCHAR(100)			NOT NULL                    	COMMENT '대상구분',
	`StartAt`				TIMESTAMP				NOT NULL                    	COMMENT '개시일',
	`DueAt`					TIMESTAMP				NOT NULL                    	COMMENT '만기일',
	`CarNumber`				VARCHAR(100)			NOT NULL                    	COMMENT '차량번호',
	`VehicleId`				VARCHAR(100)			NOT NULL                    	COMMENT '차대번호',
	`VehicleName`			VARCHAR(100)			NOT NULL                    	COMMENT '차량명',
	`RentalPeriod`			TIMESTAMP				NOT NULL                    	COMMENT '대여기간',
	`ContractedMileage`		INT						NOT NULL                    	COMMENT '약정 운행거리(km)',
	`Subsidy`				INT						NOT NULL                    	COMMENT '보조금(원)',
	`AdvancePay`			INT						NOT NULL                    	COMMENT '선수금(원)',
	`AcquisitionOrReturn`	VARCHAR(100)			NOT NULL                    	COMMENT '계약해지시',
	`Repair`				VARCHAR(100)			NOT NULL                    	COMMENT '정비 서비스',
	`PaymentMethod`			VARCHAR(100)			NOT NULL                    	COMMENT '결제방법',
	`PaymentBank`			VARCHAR(100)			NOT NULL                    	COMMENT '결제은행',
	`PaymentAt`				TINYINT					NOT NULL                    	COMMENT '결제일',
	`AccountHolder`			VARCHAR(100)			NOT NULL                    	COMMENT '예금주',
	`DriverAge`				INT						NOT NULL                    	COMMENT '운전자 연령',
	`Dedutible`				INT						NOT NULL                    	COMMENT '자기부담금(원)',
	`IndemnityReturn`		INT						NOT NULL                    	COMMENT '차량반납시 차량훼손 면책금(원)',
	`IndemnityTotalLoss`	INT						NOT NULL                    	COMMENT '차량전손시 차량손해 면책금(원)',
	`CompulsorySubscription`VARCHAR(500)			NOT NULL                    	COMMENT '의무가입사항',
	`Phone`					VARCHAR(100)			NOT NULL                    	COMMENT '전화번호',
	`Email`					VARCHAR(100)			NOT NULL                    	COMMENT '이메일',
	`Active`				ENUM('Y','N')		NOT NULL      DEFAULT 'Y'    		COMMENT '활성여부',
	`CreatedDay`	        TIMESTAMP       	  	NOT NULL      DEFAULT NOW()   	COMMENT '작성일',
	`CreatedBy`	        	INT       	  			NOT NULL         				COMMENT '작성자',
	`ModifiedDay`	        TIMESTAMP       	  	NULL      	  ON UPDATE	NOW()	COMMENT '수정일',
	`ModifiedBy`	        INT       	  			NULL      				   		COMMENT '수정자',
	`DeletedDay`	        TIMESTAMP       	  	NULL                      		COMMENT '삭제일',
	`DeletedBy`	        	INT       	  			NULL                      		COMMENT '삭제자',
	CONSTRAINT `PK_CAPITAL` PRIMARY KEY(`IDX_CAP`),
    CONSTRAINT `UK_CAPITAL` UNIQUE KEY(`IDX_USER`,`Capital`,`Business`),
	INDEX `IDX_CAPITAL` (`IDX_USER`)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci 
COMMENT '캐피탈 제공 정보 테이블';

/**
 * HDWallet 지갑 주소 테이블
 */
#DROP TABLE IF EXISTS `tbWallet`;
#TRUNCATE TABLE `tbWallet`;
CREATE TABLE `tbWallet` (
	`Index`					INT						NOT NULL	              		COMMENT '지갑 번호',
	`Address`				VARCHAR(100)			NOT NULL						COMMENT '지갑 주소',
	`Public`				VARCHAR(100)			NOT NULL						COMMENT '지갑 공개키',
	`Private`				VARCHAR(100)			NOT NULL						COMMENT '지갑 비밀키',
	CONSTRAINT `PK_WLT` PRIMARY KEY(`Index`),
	CONSTRAINT `UK_WLT` UNIQUE KEY(`Address`)
);

/**
 * NFT 테이블
 */
#DROP TABLE IF EXISTS `tbNFT`;
#TRUNCATE TABLE `tbNFT`;
CREATE TABLE `tbNFT` (
	`IDX_NFT`				INT						AUTO_INCREMENT              	COMMENT 'IDX_NFT',
	`IDX_OPER`				INT						NOT NULL	              		COMMENT 'IDX_OPER',
	`IDX_USER`				INT						NOT NULL	              		COMMENT 'IDX_USER',
	`ImgName`				VARCHAR(100)			NOT NULL						COMMENT '이미지 파일명',
	`ImgCID`				VARCHAR(100)			NOT NULL						COMMENT '이미지 CID',
	`MetaName`				VARCHAR(100)			NOT NULL						COMMENT '메타데이터 파일명',
	`MetaCID`				VARCHAR(100)			NOT NULL						COMMENT '메타데이터 CID',
	`MetaInfo`				TEXT					NOT NULL						COMMENT '메타데이터',
	`TokenID`				INT						NULL							COMMENT '토큰 ID',
	CONSTRAINT `PK_NFT` PRIMARY KEY(`IDX_NFT`),
    CONSTRAINT `UK_NFT` UNIQUE KEY(`IDX_USER`)
);

/**
 * 민팅 트렌잭션 이력 
 */
#DROP TABLE IF EXISTS `tbMintTxStatus`;
#TRUNCATE TABLE `tbMintTxStatus`;
CREATE TABLE `tbMintTxStatus` (
	`IDX_TXMINT`			INT						AUTO_INCREMENT              	COMMENT 'IDX_TXMINT',
	`IDX_NFT`				INT						NOT NULL	              		COMMENT 'IDX_NFT',
	`Tx`					VARCHAR(100)			NOT NULL						COMMENT '트랜잭션 해시',
	`Status`	enum("Pending","Success","False")	NOT NULL	DEFAULT "Pending"	COMMENT '상태',
	`CreatedDay`			TIMESTAMP				NOT NULL	DEFAULT NOW()   	COMMENT '작성일',
	`LastConDay`			TIMESTAMP				NULL		ON UPDATE NOW()		COMMENT '최종 확인 시간',
	`DecisionDay`			TIMESTAMP				NULL							COMMENT '결정된 시간',
	CONSTRAINT `PK_TXMINT` PRIMARY KEY(`IDX_TXMINT`)
);

/**
 * 트렌잭션 추적 내역
 */
DROP TABLE IF EXISTS `tbTranTxTracking`;
TRUNCATE TABLE `tbTranTxTracking`;
CREATE TABLE `tbTranTxTracking` (
	`BlockNumber`			BIGINT					NOT NULL						COMMENT '블록넘버',
	`TokenId`				INT						NOT NULL						COMMENT '토큰 ID',
	`Tx`					VARCHAR(100)			NOT NULL						COMMENT '트랜잭션 해쉬',
	`TxFee`					BIGINT					NOT NULL						COMMENT '트렌잭션 수수료',
	`Transfer`				TEXT					NOT NULL						COMMENT '이벤트(Transfer)',
	`Approval`				TEXT					NOT NULL						COMMENT '이벤트(Approval)',
	`TrackingDate`			TIMESTAMP				NOT NULL	DEFAULT NOW()		COMMENT '추적일',
    `TxDate`				TIMESTAMP				NOT NULL						COMMENT '트렌젝션 생성일',
	`Status`	enum("Pending","Success","False")	NOT NULL						COMMENT '트렌잭션 상태',
	`IDX_OPER`				INT						NULL							COMMENT '추적한 관리자',
    `IDX_USER`				INT						NOT NULL						COMMENT '대상 유저',
	CONSTRAINT `UK_TX_TRACKING` UNIQUE KEY(`BlockNumber`),
	INDEX `IDX_TX_TRACKING` (`Tx`)
);


/**
 * ! [ 추후 업데이트 예정 ] 
 * 파일 테이블
 */
#DROP TABLE IF EXISTS `tbFiles`;
#TRUNCATE TABLE `tbFiles`;
CREATE TABLE `tbFiles` (
	`IDX_FILE`              INT              	AUTO_INCREMENT	              		COMMENT 'IDX_FILE',
	`OriginalName`	        VARCHAR(255)	    NOT NULL                      		COMMENT '오리지날 이름',
	`Filename`	            VARCHAR(255)	    NOT NULL                      		COMMENT '저장된 이름',
	`Path`	                VARCHAR(255)	    NOT NULL                      		COMMENT '파일 경로',
	`Size`	                INT               	NOT NULL                      		COMMENT '파일 용량',
	`Mimetype`              VARCHAR(255)	    NOT NULL                      		COMMENT 'MIME 타입',
  CONSTRAINT `PK_FILES` PRIMARY KEY(`IDX_FILE`)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci 
COMMENT '파일 테이블';

/**
 * ! [ 추후 업데이트 예정 ] 
 * 게시판 파일 테이블
 */
#DROP TABLE IF EXISTS `tbBoardToFile`;
#TRUNCATE TABLE `tbBoardToFile`;
CREATE TABLE `tbBoardToFile` (
	`IDX_FILE`	            INT             	NOT NULL                     		COMMENT 'IDX_FILE',
	`IDX_BOARD`	            INT             	NOT NULL                     		COMMENT 'IDX_BOARD',
	`Step` 	                INT              	NOT NULL                     		COMMENT '순서'
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci 
COMMENT '게시판 파일 매핑 테이틀';

/**
 * 게시판 테이블
 */
#DROP TABLE IF EXISTS `tbBoard`;
#TRUNCATE TABLE `tbBoard`;
CREATE TABLE `tbBoard` (
	`IDX_BOARD`	            INT             	AUTO_INCREMENT                 		COMMENT 'IDX_BOARD',
	`IDX_USER`	            INT             		NULL                       		COMMENT 'IDX_USER',
	`IDX_OPER`	            INT             		NULL                       		COMMENT 'IDX_OPER',
	`Title`	                VARCHAR(255)     	NOT NULL                       		COMMENT '제목',
	`Content`	            VARCHAR(2048)    	NOT NULL                       		COMMENT '내용',
	`Category`	            VARCHAR(20)      	NOT NULL                       		COMMENT '카테고리',
    `View`	            	INT             	NOT NULL      DEFAULT 0        		COMMENT '조회수',
	`CreatedDay`	        TIMESTAMP           NOT NULL      DEFAULT NOW()    		COMMENT '글 작성일',
	`ModifiedDay`	        TIMESTAMP            	NULL      ON UPDATE NOW() 		COMMENT '글 수정일',
	`DeletedDay`	        TIMESTAMP            	NULL                       		COMMENT '글 삭제일',
	`Active`				ENUM('Y','N')		NOT NULL      DEFAULT 'Y'    		COMMENT '글 활성여부',
  CONSTRAINT `PK_BOARD` PRIMARY KEY(`IDX_BOARD`),
  INDEX `IDX_BOARD` (`Category`,`Active`)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci 
COMMENT '게시판 테이블';

/**
 * 자주묻는 질문
 */
#DROP TABLE IF EXISTS `tbFaqBoard`;
#TRUNCATE TABLE `tbFaqBoard`;
CREATE TABLE `tbFaqBoard` (
    `IDX_FAQ`				INT                	AUTO_INCREMENT                      COMMENT 'FAQ 테이블',
    `IDX_OPER`				INT                	NOT NULL							COMMENT 'Operator 테이블',
    `Title`					VARCHAR(255)    	NOT NULL							COMMENT '제목',
    `Content`				VARCHAR(2048)    	NOT NULL							COMMENT '내용',
    `CreatedDay`			TIMESTAMP        	NOT NULL	DEFAULT NOW()        	COMMENT '작성일',
    `ModifiedDay`			TIMESTAMP        		NULL	ON UPDATE NOW()        	COMMENT '수정일',            
    `DeletedDay`			TIMESTAMP        		NULL                            COMMENT '삭제일',            
    `Active`				ENUM('Y', 'N')    	NOT NULL	DEFAULT 'Y'             COMMENT '활성여부',
  CONSTRAINT `PK_FAQ` PRIMARY KEY(`IDX_FAQ`)
);

/**
 * ! [ 추후 업데이트 예정 ] 
 * 계층형 댓글 테이블
 */
#DROP TABLE IF EXISTS `tbComment`;
#TRUNCATE TABLE `tbComment`;
CREATE TABLE `tbComment` (
	`IDX_COMMENT`	        INT             	AUTO_INCREMENT                		COMMENT 'IDX_COMMENT',
	`IDX_BOARD`	            INT             	NOT NULL                      		COMMENT 'IDX_BOARD',
	`IDX_USER`	            INT             	NOT NULL                      		COMMENT 'IDX_USER',
	`Comment`	            VARCHAR(1024)   	NOT NULL                      		COMMENT '내용',
	`IDX_PARENT`            INT             	  	NULL                      		COMMENT '부모 댓글 IDX',
	`Depth`	                INT             	  	NULL                      		COMMENT '댓글 계층',
	`Step`	                INT             	  	NULL                      		COMMENT '댓글 순서',
	`CreatedDay`	        TIMESTAMP       	  	NULL	DEFAULT NOW()   		COMMENT '댓글 작성일',
	`ModifiedDay`	        TIMESTAMP       	  	NULL      				  		COMMENT '댓글 수정일',
	`DeletedDay`	        TIMESTAMP       	  	NULL                      		COMMENT '댓글 삭제일',
  CONSTRAINT `PK_COMMENT` PRIMARY KEY(`IDX_COMMENT`)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci 
COMMENT '계층형 댓글 테이블';

/**
 * 임시 계층형 댓글 테이블
 */
DROP TABLE IF EXISTS `tbComment1`;
TRUNCATE TABLE `tbComment1`;
CREATE TABLE `tbComment1` (
    `IDX_COMMENT`			INT					AUTO_INCREMENT						COMMENT 'comment 테이블',
    `IDX_BOARD`				INT					NOT NULL							COMMENT 'board 테이블',
    `IDX_USER`				INT					NOT NULL							COMMENT 'user 테이블',
    `Comment`				VARCHAR(1024)		NOT NULL							COMMENT '댓글내용',
    `CreatedDay`			TIMESTAMP			NOT NULL	DEFAULT NOW()			COMMENT '작성일',
    `ModifiedDay`			TIMESTAMP				NULL	ON UPDATE NOW()			COMMENT '수정일',
    `DeletedDay`			TIMESTAMP				NULL							COMMENT '삭제일',
    `Active`				ENUM('Y','N')		NOT NULL	DEFAULT 'Y'				COMMENT '활성여부',
    CONSTRAINT `PK_COMMENT_TMP` PRIMARY KEY(`IDX_COMMENT`)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci 
COMMENT '임시 계층형 댓글 테이블';

/**
 * 문의하기 테이블
 */
#DROP TABLE IF EXISTS `tbEnquiry`;
#TRUNCATE TABLE `tbEnquiry`;
CREATE TABLE `tbEnquiry` (
	`IDX_ENQ`	        	INT             	AUTO_INCREMENT                		COMMENT '문의_IDX',
	`IDX_USER`	            INT             	NOT NULL                      		COMMENT '유저_IDX',
	`Title`	            	VARCHAR(1024)   	NOT NULL                      		COMMENT '문의 제목',
	`Content`	            VARCHAR(1024)   	NOT NULL                      		COMMENT '문의 내용',
    `Answer`	        	ENUM('Y','N')		NOT NULL	  DEFAULT 'N'			COMMENT '답변여부',
	`CreatedDay`	        TIMESTAMP       	  	NULL      DEFAULT NOW()   		COMMENT '문의 작성일',
	`ModifiedDay`	        TIMESTAMP       	  	NULL      ON UPDATE NOW()   	COMMENT '문의 작성일',
    `DeletedDay`	        TIMESTAMP       	  	NULL      				   		COMMENT '문의 작성일',
	`Active`	        	ENUM('Y','N')		NOT NULL	  DEFAULT 'N'			COMMENT '답변여부',
  CONSTRAINT `PK_ENQUIRY` PRIMARY KEY(`IDX_ENQ`)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci 
COMMENT '문의하기 테이블';

/**
 * 문의답변 테이블
 */
#DROP TABLE IF EXISTS `tbEnquiryAnswer`;
#TRUNCATE TABLE `tbEnquiryAnswer`;
CREATE TABLE `tbEnquiryAnswer` (
	`IDX_EAN`	        	INT             	AUTO_INCREMENT                		COMMENT '문의_IDX',
	`IDX_ENQ`	            INT             	NOT NULL                      		COMMENT '문의답변_IDX',
	`IDX_OPER`	            INT             	NOT NULL                      		COMMENT '관리자_IDX',
	`Content`	            VARCHAR(1024)   	NOT NULL                      		COMMENT '문의 내용',
	`CreatedDay`	        TIMESTAMP       	  	NULL      DEFAULT NOW()   		COMMENT '문의 작성일',
  CONSTRAINT `PK_ENQUIRY_ANSWER` PRIMARY KEY(`IDX_EAN`),
  CONSTRAINT `UK_ENQUIRY_ANSWER` UNIQUE KEY(`IDX_ENQ`)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci 
COMMENT '문의답변 테이블';

/**
 * 신고 테이블
 */
DROP TABLE IF EXISTS `tbReport`;
#TRUNCATE TABLE `tbReport`;
CREATE TABLE `tbReport` (
	`IDX_REPORT`			INT					AUTO_INCREMENT						COMMENT '신고_IDX',
	`IDX_USER`				INT					NOT NULL							COMMENT '신고자',
	`TargetIdx`				INT					NOT	NULL							COMMENT '신고당한 유저 IDX',
	`TargetTypeIdx`			INT					NOT	NULL							COMMENT '신고당한 IDX( 댓글,게시글 )',
	`TargetType`			ENUM('1','2')		NOT	NULL							COMMENT '신고당한 Type( 1: 게시글, 2: 댓글 )',
	`ReportedDay`			TIMESTAMP			NOT	NULL		DEFAULT NOW()		COMMENT '신고일',
	CONSTRAINT `PK_REPORT` PRIMARY KEY(`IDX_REPORT`),
    CONSTRAINT `UK_REPORT` UNIQUE KEY(`IDX_USER`,`TargetIdx`,`TargetTypeIdx`,`TargetType`),
	INDEX `IDX_REPORT` (`IDX_USER`)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci 
COMMENT '신고 테이블';

/**
 * 차단 테이블
 */
DROP TABLE IF EXISTS `tbBlock`;
TRUNCATE TABLE `tbBlock`;
CREATE TABLE `tbBlock` (
	`IDX_BLOCK`				INT					AUTO_INCREMENT						COMMENT '차단_IDX',
	`IDX_USER`				INT					NOT NULL							COMMENT '차단자',
	`TargetIdx`				INT					NOT NULL							COMMENT '차단당한 PK( 유저,댓글,게시글 )',
	`TargetType`			ENUM('1','2','3')	NOT NULL							COMMENT '차단당한 Type( 1: 유저, 2: 댓글, 3: 게시글 )  - 현재는 유저만 차단',
	`BlockedDay`			TIMESTAMP			NOT NULL		DEFAULT NOW()		COMMENT '차단일',
	`Active`				ENUM('Y','N')		NOT NULL		DEFAULT 'Y'			COMMENT '차단 여부',
	CONSTRAINT `PK_BLOCK` PRIMARY KEY(`IDX_BLOCK`),
	INDEX `IDX_BLOCK` (`IDX_USER`)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci 
COMMENT '차단 테이블';



