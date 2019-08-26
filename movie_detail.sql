use moviedata;

-- 영화코드로 조회한 영화 정보 테이블 생성(json 구조)
create external table if not exists movies_feature(
   movieInfoResult struct   <
		movieInfo : struct			<
			  movieCd : String,
			  movieNm : String,
			  movieNmEn : String,
			  movieNmOg : String,
			  showTm : String,
			  prdtYear : String,
			  openDt : String,
			  prdtStatNm : String,
			  typeNm : String,
			  nations :Array<string>,
			  genres : Array <struct
			  <
			  	genreNm : String
			  	>>,
			  directors : Array<string>,
			  actors : Array<string>,
			  showTypes : Array<string>,
			  companys : Array<string>,
			  audits : Array<string>,
			  staffs : Array<string>
      
			>,
		source : String
      >
)
Row format serde 'org.apache.hive.hcatalog.data.JsonSerDe';

--영화 정보 파일이 들어 있는 폴더 통째로 movies_feature 테이블에 로딩.
load data local inpath '/home/hadoop/movies_data/movie_detail' into table movies_feature;


-- movies_js에서 필요한 data만 parcing해서 가져온다.
--select a.movieInfoResult.movieInfo.movieCd as movieCd, b.genreNm as genreNm from movies_feature a LATERAL VIEW OUTER inline (a.movieInfoResult.movieInfo.genres) b;
--select a.movieInfoResult.movieInfo.movieCd as movieCd, a.movieInfoResult.movieInfo.movieNm as movieNm, a.movieInfoResult.movieInfo.genres as genres from movies_feature a ;
