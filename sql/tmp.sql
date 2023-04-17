show databases;
use publicapi;

SHOW GLOBAL VARIABLES LIKE 'local_infile';
set global local_infile = true;

# csv 파일로 백업
SELECT * FROM entrc
INTO OUTFILE 'entrc.csv'
CHARACTER SET euckr
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '\\'
LINES TERMINATED BY '\n';

show tables;
desc `entrc`; 			# 위정정보요약DB
desc `beopjeongdong`;	# 법정동 코드
desc `sido`; 			# 행정군 구역 코드(시도)
desc `sigungu`; 		# 행정군 구역 코드(시군구)
desc `eupmyeondong`; 	# 행정군 구역 코드(읍면동)
desc `ri`; 				# 행정군 구역 코드(리)

select * from `entrc`;
select * from `sido`;
select * from `sigungu`;
select * from `eupmyeondong`;
select * from `ri`;

show warnings;
# 1681 Integer display width is deprecated and will be removed in a future release. 
# 1681 해결 : INT(11) 등의 형태에서 INT로 수정

/**
    위정정보요약DB
    https://www.juso.go.kr/
*/
DROP TABLE IF EXISTS `entrc`;
TRUNCATE TABLE `entrc`;
CREATE TABLE `entrc` (
  `cityCountyCode`                  VARCHAR(5)      DEFAULT NULL    COMMENT '시군구코드',
  `doorwaySerialNumber`             VARCHAR(10)     DEFAULT NULL    COMMENT '출입구일련번호',
  `statutoryCode`                   VARCHAR(10)     DEFAULT NULL    COMMENT '법정동코드',
  `cityName`                        VARCHAR(40)     DEFAULT NULL    COMMENT '시도명',
  `cityCountyName`                  VARCHAR(40)     DEFAULT NULL    COMMENT '시군구명',
  `eupMyeonDongName`                VARCHAR(40)     DEFAULT NULL    COMMENT '읍면동명',
  `roadNameCode`                    VARCHAR(12)     DEFAULT NULL    COMMENT '도로명코드',
  `roadName`                        VARCHAR(80)     DEFAULT NULL    COMMENT '도로명',
  `undergroundYN`                   VARCHAR(1)      DEFAULT NULL    COMMENT '지하여부',
  `buildingNumber`                  INT     		DEFAULT NULL    COMMENT '건물본번',
  `buildingSubNumber`               INT     		DEFAULT NULL    COMMENT '건물부번',
  `buildingName`                    VARCHAR(40)     DEFAULT NULL    COMMENT '건물명',
  `zipCode`                         VARCHAR(5)      DEFAULT NULL    COMMENT '우편번호',
  `classificationOfBuildingUse`     VARCHAR(100)    DEFAULT NULL    COMMENT '건물용도분류',
  `buildingGroup`                   VARCHAR(1)      DEFAULT NULL    COMMENT '건물군여부',
  `jurisdiction`                    VARCHAR(8)      DEFAULT NULL    COMMENT '관할행정동',
  `UTMKX`                           VARCHAR(30)     DEFAULT NULL    COMMENT 'UTM-K(X좌표)',
  `UTMKY`                           VARCHAR(30)     DEFAULT NULL    COMMENT 'UTM-K(Y좌표)',
  `WGS84X`                          VARCHAR(40)     DEFAULT NULL    COMMENT 'WGS84(X좌표)',
  `WGS84Y`                          VARCHAR(40)     DEFAULT NULL    COMMENT 'WGS84(Y좌표)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT '위정정보요약DB';


/**
	법정동 코드
*/
DROP TABLE IF EXISTS `beopjeongdong`;
TRUNCATE TABLE `beopjeongdong`;
CREATE TABLE `beopjeongdong` (
  `PNU`                             VARCHAR(10)	    NOT NULL        COMMENT '법정동코드',
  `sido`                            VARCHAR(40)     NOT NULL        COMMENT '시도명',
  `sigungu`                         VARCHAR(40)     DEFAULT NULL    COMMENT '시군구명',
  `eupmyeondong`                    VARCHAR(40)     DEFAULT NULL    COMMENT '읍면동명',
  `ri`                              VARCHAR(40)     DEFAULT NULL    COMMENT '리명',
  `rank`                            VARCHAR(5)      DEFAULT NULL    COMMENT '순위',
  `createDate`                      VARCHAR(10)     NOT NULL        COMMENT '생성일자',
  `deleteDate`                      VARCHAR(10)     DEFAULT NULL    COMMENT '삭제일자',
  `pastPNU`                         VARCHAR(10)     DEFAULT NULL    COMMENT '과거법정동코드',
  CONSTRAINT `sidoPK` PRIMARY KEY (`PNU`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT '시도';

/**
    행정군구역 코드 ( 법정동 코드 정규화 테이블 )
    시도 , 시군구 , 읍면동, 리
*/
DROP TABLE IF EXISTS `sido`;
TRUNCATE TABLE `sido`;
CREATE TABLE `sido` (
  `PNU`                             VARCHAR(10)	    NOT NULL COMMENT '법정동코드',
  `sidoCode`                        VARCHAR(2)      NOT NULL COMMENT '시도코드',
  `value`                           VARCHAR(40)     NOT NULL COMMENT '명칭',
  `rank`                            VARCHAR(3)      NOT NULL COMMENT '순위',
  CONSTRAINT `sidoPK` PRIMARY KEY (`PNU`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT '시도';

DROP TABLE IF EXISTS `sigungu`;
TRUNCATE TABLE `sigungu`;
CREATE TABLE `sigungu` (
  `PNU`                             VARCHAR(10)	    NOT NULL COMMENT '법정동코드',
  `sidoPNU`                         VARCHAR(10)     NOT NULL COMMENT '시도코드',
  `sigunguCode`                     VARCHAR(3)      NOT NULL COMMENT '시군구코드',
  `value`                           VARCHAR(40)     NOT NULL COMMENT '명칭',
  `rank`                            VARCHAR(3)      NOT NULL COMMENT '순위',
  CONSTRAINT `sigunguPK` PRIMARY KEY (`PNU`),
  CONSTRAINT `sidoFK` FOREIGN KEY (`sidoPNU`) REFERENCES `sido` (`PNU`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT '시군구';

DROP TABLE IF EXISTS `eupmyeondong`;
TRUNCATE TABLE `eupmyeondong`;
CREATE TABLE `eupmyeondong` (
  `PNU`					            VARCHAR(10)	    NOT NULL COMMENT '법정동코드',
  `sigunguPNU`                      VARCHAR(10)     NOT NULL COMMENT '시군구코드',
  `eupmyeondongCode`                VARCHAR(3)      NOT NULL COMMENT '읍면동코드',
  `value`                           VARCHAR(40)     NOT NULL COMMENT '명칭',
  `rank`                            VARCHAR(3)      NOT NULL COMMENT '순위',
  CONSTRAINT `eupmyeondongPK` PRIMARY KEY (`PNU`),
  CONSTRAINT `sigunguFK` FOREIGN KEY (`sigunguPNU`) REFERENCES `sigungu` (`PNU`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT '읍면동';

DROP TABLE IF EXISTS `ri`;
TRUNCATE TABLE `ri`;
CREATE TABLE `ri` (
  `PNU`					            VARCHAR(10)	    NOT NULL COMMENT '법정동코드',
  `eupmyeondongPNU`                 VARCHAR(10)     NOT NULL COMMENT '읍면동코드',
  `riCode`                          VARCHAR(2)      NOT NULL COMMENT '리코드',
  `value`                           VARCHAR(40)     NOT NULL COMMENT '명칭',
  `rank`                            VARCHAR(3)      NOT NULL COMMENT '순위',
  CONSTRAINT `riPK` PRIMARY KEY (`PNU`),
  CONSTRAINT `eupmyeondongFK` FOREIGN KEY (`eupmyeondongPNU`) REFERENCES `eupmyeondong` (`PNU`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT '리';