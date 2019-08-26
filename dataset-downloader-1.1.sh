#!/bin/bash
echo "*********************************************************"
echo "*********************************************************"
echo "******** +-------------------------------+ **************"
echo "******** | MOVIE BOX OFFICE DATA CRAWLER | **************"
echo "******** +-------------------------------+ **************"
echo "*********************************************************"
echo "*********************************************************"
echo -e "\n"

# daily box office data set API key = 'adaa1a08797e106b116cf45088442ba6'
dailyurl="http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=adaa1a08797e106b116cf45088442ba6"

# movie detail data set API key = '6069f6c03975876e5d59dfbaa7b62485'
detailurl="http://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieInfo.json?key=6069f6c03975876e5d59dfbaa7b62485"

# getting 'movieCd' key value from downloaded daily boxOffice json files
# jq '.boxOfficeResult.dailyBoxOfficeList[0].movieCd' [/path/filename]
key="movieCd"
path="/home/hadoop/movies_data"
path1="/home/hadoop/movies_data/movie_detail"
# DATA MOVIE MARKET = 'K' Korean movies // 'F' Foreign movies
# read -p "Are you looking for [KOREAN] or [FOREIGN] movies dataset?   (select: K / F)" market
# echo -e "You selected : $market \n\n"
shouldloop=true
while $shouldloop; do
# select the date format: specific date? : 1 // date range? : 2 // Exit : 3
echo -e "Please select your looking DATE format= \n"
select option in "[SPECIFIC DATE] (YYYYMMDD)" "[DATE RANGE] (YYYYMMDD - YYYYMMDD)" "[Exit]"
do
    case $option in
        # [OPTION 1] ********** download by a specific date **********
        "[SPECIFIC DATE] (YYYYMMDD)")
        echo -e "\n You selected : $option \n\n";
        read -p "Enter your specific date (YYYYMMDD):" sdate
        len=${#sdate}
        
        if [ $len==8 ]; then
        echo -e "SPECIFIC DATE= $sdate \n"
        wget --directory-prefix="$path" --output-document=$sdate "$dailyurl&targetDt=$sdate"         
        elements=$(jq '.boxOfficeResult.dailyBoxOfficeList | length' "$path/$sdate")
        echo $elements
        # Finding the movie code ('movieCd') inside the downloaded json files above
        # and download detailed each movie dataset by movie code
            if [ -f "$path/$sdate"  ]; then
            echo "inside IF statement"
                for(( i=0;i<$elements;i++ )); do
                exe=".boxOfficeResult.dailyBoxOfficeList[$i].movieCd"
                echo $exe
		movieCd=$(jq -r $exe "$path/$sdate")
                echo "$movieCd founded"
                wget --output-document=$movieCd "$detailurl&movieCd=$movieCd"
                mv "$path/$movieCd" "$path1/"                
                done
            mv "$path/$sdate" "$path/datelist/$sdate"
            else
                echo "$sdate file doesn't exists"        
            fi
        else
        echo -e "$sdate \n You inserted an incorrect date format \n\n"
        shouldloop=true
        fi
         break
         ;;

        # [OPTION 2] ********** download by looping the date range **********
        "[DATE RANGE] (YYYYMMDD - YYYYMMDD)" ) 
        echo -e "\n You selected : $option \n\n";
        read -p "Enter the starting date (YYYYMMDD):" r1date
        read -p "Enter the ending date (YYYYMMDD):" r2date
        echo -e "FROM= $r1date TO= $r2date \n"

        # casting user input to date type
        dt=$(date -d $r1date +"%Y%m%d")
        dt2=$(date -d $r2date +"%Y%m%d")

        # compare input date format by it lengths
        len1=${#r1date}
        len2=${#r2date}

        # if the format is correct ('YYYYMMDD', length = 8)
       if [ "$len1" == "8" -o "$len2" == "8" ]; then
            # download box office json file by day 
            # while starting date is lower or equal end date
            while [ "$dt" -le "$dt2" ]; do            
                echo "$dt"    
                wget --directory-prefix="$path/" --output-document=$dt "$dailyurl&targetDt=$dt"

            # Checking if the json file exists in the downloaded path
            if [ -f "$path/$dt"  ]; then
            # Finding the movie code ('movieCd') inside the downloaded json files above
            elements=$(jq '.boxOfficeResult.dailyBoxOfficeList | length' "$path/$dt")
            # and download each detailed movie dataset by movie code (key='movieCd')
                for(( i=0;i<$elements;i++ )); do
                    exe=".boxOfficeResult.dailyBoxOfficeList[$i].movieCd"
                    movieCd=$(jq -r $exe "$path/$dt")
                    echo "$movieCd founded"
                    
                     # if the movie detail file doesn't exists proceed to download
                    if [ ! -f "$path1/$movieCd"  ]; then
                        wget --output-document=$movieCd "$detailurl&movieCd=$movieCd"
                        mv "$path/$movieCd" "$path1/"
                        echo "$movieCd file downloaded"
                    else
                        echo "$movieCd file already exists"
                    fi           
                done
            mv "$path/$dt" "$path/datelist/$dt"
            else
                echo "$dt file doesn't exists"
            fi
    # increasing the box office dataset day++
	dt=`date -d "$dt 1 day" +"%Y%m%d"`
	done
       else
           echo -e "You inserted an incorrect date format \n";
           shouldloop=true;           
       fi  
       break;     
        ;;
        # [OPTION 3] ********** Exit downloader **********           
        "[Exit]" )
        echo -e "\n You selected : $option \n";
        echo -e "*** Exit : [ MOVIE BOX OFFICE DATA CRAWLER ] \n\n";
        shouldloop=false;
        exit;
         break;
    esac
    done
done
