#!/bin/bash
echo "******************************************************"
echo "******************************************************"
echo "******** +----------------------------------+ ********"
echo "******** | MOVIE BOX OFFICE DATA DOWNLOADER | ********"
echo "******** +----------------------------------+ ********"
echo "******************************************************"
echo "******************************************************"
echo -e "\n"

# daily box office data set API key = 'adaa1a08797e106b116cf45088442ba6'
dailyurl="http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=adaa1a08797e106b116cf45088442ba6"

# movie detail data set API key = '6069f6c03975876e5d59dfbaa7b62485'
detailurl="http://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieInfo.json?key=6069f6c03975876e5d59dfbaa7b62485"

# useful variable declaration
key="movieCd"
cwd=$(pwd)
cwd1="$cwd/movie_detail"

# Install .jq line editor for json files
if [ -f "/usr/local/bin/jq"  ]; then
echo "//// .JQ editor already installed! ////"
echo -e "\n"
else
wget --directory-prefix="/usr/local/bin/" http://stedolan.github.io/jq/download/linux64/jq
chmod a+x jq
echo "//// .JQ editor installed! ////"
echo -e "\n"
jq
fi

#****************** START USER SELECT MENU ************************
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
        wget  --output-document=$sdate "$dailyurl&targetDt=$sdate"         
        elements=$(jq '.boxOfficeResult.dailyBoxOfficeList | length' "$cwd/$sdate")
        echo $elements
        mkdir "$cwd/boxofficebydate"
        # Finding the movie code ('movieCd') inside the downloaded json files above
        # and download detailed each movie dataset by movie code
            if [ -f "$cwd/$sdate"  ]; then
            echo "inside IF statement"
                for(( i=0;i<$elements;i++ )); do
                exe=".boxOfficeResult.dailyBoxOfficeList[$i].movieCd"
                echo $exe
		movieCd=$(jq -r $exe "$cwd/$sdate")
                echo "$movieCd founded"
                wget --output-document=$movieCd "$detailurl&movieCd=$movieCd"
                mkdir "$cwd1"
                mv "$cwd/$movieCd" "$cwd1/"                
                done            
            mv "$cwd/$sdate" "$cwd/boxofficebydate/$sdate"
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

        # casting user input to DATE type
        dt=$(date -d $r1date +"%Y%m%d")
        dt2=$(date -d $r2date +"%Y%m%d")

        # compare input date 'input format' by it lengths
        len1=${#r1date}
        len2=${#r2date}

        # if the format is correct ('YYYYMMDD', length = 8)
        if [ "$len1" == "8" -o "$len2" == "8" ]; then
            # download box office json file by day 
            # while starting date is lower or equal end date
            while [ "$dt" -le "$dt2" ]; do            
                echo -e "\n START DOWNLOADING <<<<<<<  $dt  >>>>>>> \n"    
                wget --directory-prefix="$cwd/" --output-document=$dt "$dailyurl&targetDt=$dt"
                mkdir "$cwd/movie_detail"
            # Checking if the json file exists in the downloaded path
            if [ -f "$cwd/$dt"  ]; then
            # Finding the movie code ('movieCd') inside the downloaded json files above
            elements=$(jq '.boxOfficeResult.dailyBoxOfficeList | length' "$cwd/$dt")
            # and download each detailed movie dataset by movie code (key='movieCd')
                for(( i=0;i<$elements;i++ )); do
                    exe=".boxOfficeResult.dailyBoxOfficeList[$i].movieCd"
                    movieCd=$(jq -r $exe "$cwd/$dt")
                    echo -e "\n $movieCd founded"
                    
                     # if the movie detail file doesn't exists proceed to download
                    if [ ! -f "$cwd1/$movieCd"  ]; then
                        wget --output-document=$movieCd "$detailurl&movieCd=$movieCd"
                        mv "$cwd/$movieCd" "$cwd1/"
                        echo -e "\n $movieCd file downloaded"
                    else
                        echo -e "\n $movieCd file already exists"
                    fi           
                done
            mkdir "$cwd/boxofficebydate"
            mv "$cwd/$dt" "$cwd/boxofficebydate/$dt"
            else
                echo -e "\n $dt file doesn't exists"
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
        echo -e "*** Exit : [ MOVIE BOX OFFICE DATA DOWNLOADER ] \n\n";
        shouldloop=false;
        exit;
         break;
    esac
    done
done
