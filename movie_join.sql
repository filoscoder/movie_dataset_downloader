use moviedata;
-- 날짜별 영화데이터 csv 파일 로드하여,새로운 table에 저장.
create table movie_list_total
(
showRange string,
movieNm string,
movieCd string,
audiCnt int,
showcnt int,
salesAcc int,
audiAcc int
)
Row format delimited fields terminated by ',';
load data local inpath '/home/hadoop/movies_data/movie_by_day.csv' into table movie_list_total;

--  영화 장르 csv파일 로드하여, 새로운 table에 저장.

create table movie_gen
(
movieCd string,
genres string
)
Row format delimited fields terminated by ',';
load data local inpath '/home/hadoop/movies_data/movie_detail.csv' into table movie_gen;

-- showRange date형으로 변경하기 위한 설정. 정확히 모르겠지만, 칼럼명을 변수로받아 사용 하기위한 설정인듯.
set hive.strict.checks.cartesian.product=False;

--movie_list_total과 movie_gen join해서 movie_join이라는 최종 table로 저장
-- join 하면서 showRange를 date형으로 변경.

create table movie_join as select a.*, b.genres from (select to_date(from_unixtime(UNIX_TIMESTAMP(SUBSTRING_INDEX(showRange, '~', -1),'yyyyMMdd'))) showdate, movieNm, movieCd,audiCnt,showcnt,salesAcc,audiAcc from movie_list_total) a left outer join movie_gen b 
on a.movieCd = b.movieCd;
