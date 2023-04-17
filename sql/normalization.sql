# SELECT COUNT(*) FROM beopjeongdong; # 46289개의 법정동 데이터
# SELECT COUNT(*) FROM `beopjeongdong` WHERE `deleteDate` = ""; # 20,557개의 현존 데이터
# DESC beopjeongdong; 
########################################################
			# sido Table로 정규화 시킬 내용 검색
########################################################
#SELECT 
#	`PNU` AS `sidoPNU`,
#	LEFT(`PNU`,2) AS `sidoCode`,
#	`sido` AS `value`,
#	`rank` 
#FROM `beopjeongdong` WHERE `PNU` LIKE '%00000000' AND `deleteDate` = "";

# 17개의 시도 데이터를 select 과 insert를 동시에 작업
#INSERT INTO `sido`(`sidoPNU`,`sidoCode`,`value`,`rank`)
#SELECT 
#	`PNU` AS `sidoPNU`,
#	LEFT(`PNU`,2) AS `sidoCode`,
#	`sido` AS `value`,
#	`rank` 
#FROM `beopjeongdong` WHERE `PNU` LIKE '%00000000' AND `deleteDate` = "";

#SELECT * FROM `sido`;

########################################################
		# sigungu Table로 정규화 시킬 내용 검색
########################################################
#SELECT 
#	`PNU` AS `sigunguPNU`,
#	RPAD(LEFT(`PNU`,2),10,'0') AS `sidoPNU`,
#	SUBSTRING(`PNU`,3,3) AS `sigunguCode`,
#	`sigungu` AS `value`,
#	`rank` 	
#FROM `beopjeongdong` WHERE `sigungu` != "" AND `eupmyeondong` = "" AND `deleteDate` = "";

# 261개의 시군구 데이터를 select 과 insert를 동시에 작업
#INSERT INTO `sigungu`(`PNU`,`sidoPNU`,`sigunguCode`,`value`,`rank`)
#SELECT 
#	`PNU`,
#	RPAD(LEFT(`PNU`,2),10,'0') AS `sidoPNU`,
#	SUBSTRING(`PNU`,3,3) AS `sigunguCode`,
#	`sigungu` AS `value`,
#	`rank` 	
#FROM `beopjeongdong` WHERE `sigungu` != "" AND `eupmyeondong` = "" AND `deleteDate` = "";

#SELECT substring(`PNU`,6,5) FROM `sigungu`;

########################################################
		# eupmyeondong Table로 정규화 시킬 내용 검색
########################################################
#SELECT 
#	`PNU`,
#	RPAD(LEFT(`PNU`,5),10,'0') AS `sigunguPNU`,
#	SUBSTRING(`PNU`,6,3) AS `eupmyeondongCode`,
#	`eupmyeondong` AS `value`,
#	`rank`
#FROM `beopjeongdong` WHERE `eupmyeondong` != "" AND `ri` = "" AND `deleteDate` = "";

# 5053개의 읍면동 데이터를 select과 insert를 동시에 작업
#INSERT INTO `eupmyeondong`(`PNU`,`sigunguPNU`,`eupmyeondongCode`,`value`,`rank`)
#SELECT 
#	`PNU`,
#	RPAD(LEFT(`PNU`,5),10,'0') AS `sigunguPNU`,
#	SUBSTRING(`PNU`,6,3) AS `eupmyeondongCode`,
#	`eupmyeondong` AS `value`,
#	`rank`
#FROM `beopjeongdong` WHERE `eupmyeondong` != "" AND `ri` = "" AND `deleteDate` = "";

########################################################
			# ri Table로 정규화 시킬 내용 검색
########################################################
#SELECT 
#	`PNU`,
#	RPAD(LEFT(`PNU`,8),10,'0') AS `eupmyeondongPNU`,
#	SUBSTRING(`PNU`,9,2) AS `eupmyeondongCode`,
#	`ri` AS `value`,
#	`rank`
#FROM `beopjeongdong` WHERE `ri` != "" AND `deleteDate` = "";

# 15226개의 읍면동 데이터를 select 과 insert를 동시에 작업
#INSERT INTO `ri`(`PNU`,`eupmyeondongPNU`,`riCode`,`value`,`rank`)sigungu
#SELECT 
#	`PNU`,
#	RPAD(LEFT(`PNU`,8),10,'0') AS `eupmyeondongPNU`,
#	SUBSTRING(`PNU`,9,2) AS `eupmyeondongCode`,
#	`ri` AS `value`,
#	`rank`
#FROM `beopjeongdong` WHERE `ri` != "" AND `deleteDate` = "";

# 결과 46,289개의 데이터를 17개의 시도, 261개의 시군구, 5,053개의 읍면동, 15,226개의 리 데이터로 총합(20,557) 스케일링 및 정규화 진행