use moviedata;

-- 일별 박스오피스 테이블 생성 (json구조)
create external table if not exists movies_js(
		boxOfficeResult struct<
				boxofficeType : String,
				showRange:String,
				dailyBoxOfficeList: Array <
									struct< rnum :String,
									rank : String,
									rankInten : String,
									rankOldAndNew : String,
									movieCd : String,
									movieNm : String,
									openDt : String,
									salesAmt : String,
									salesShare : String,
									salesInten : String,
									salesChange : String,
									salesAcc : String,
									audiCnt : String,
									audiInten : String,
									audiChange : String,
									audiAcc : String,
									scrnCnt : String,
									showcnt : String>
									>
									>
)
Row format serde 'org.apache.hive.hcatalog.data.JsonSerDe';

-- 일별 박스오피스 파일이 들어 있는 폴더 통째로 moives_js 테이블에 로딩.
load data local inpath '/home/hadoop/movies_data/datelist' into table movies_js; 


-- movies_js에서 필요한 data만 parcing해서 가져온다.
--select a.boxOfficeResult.showRange as showRange, b.movieNm as movieNm, b.movieCd as movieCd, b.audiCnt as audiCnt , b.showcnt as showcnt, b.salesAcc as salesAcc ,b.audiAcc as audiAcc from movies_js a LATERAL VIEW OUTER inline (a.boxOfficeResult.dailyBoxOfficeList) b;






	

